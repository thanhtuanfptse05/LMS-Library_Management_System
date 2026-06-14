package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Book;
import model.Category;
import model.Tag;
import util.DatabaseConnection;

/**
 * BookDAO — Data Access Object cho bảng Book.
 *
 * Tuân thủ:
 * - SEC-03: 100% PreparedStatement.
 * - Kiến trúc: Tính toán Top Trending và Candidate Pool cho F8.
 */
public class BookDAO {

    private static final Logger LOGGER = Logger.getLogger(BookDAO.class.getName());

    /**
     * FR-42: Tìm kiếm và lọc sách có phân trang.
     * 
     * @param keyword Từ khóa tìm kiếm (Title hoặc Author)
     * @param categoryId ID Danh mục (0 nếu không lọc)
     * @param tagIds Mảng ID Tag (null hoặc rỗng nếu không lọc)
     * @param availableOnly Chỉ lấy sách có sẵn (availableQuantity > 0)
     * @param page Trang hiện tại (bắt đầu từ 1)
     * @param pageSize Số lượng trên mỗi trang
     * @return Danh sách các sách tìm được
     */
    public List<Book> searchBooks(String keyword, int categoryId, int[] tagIds, boolean availableOnly, int page, int pageSize) {
        List<Book> books = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT b.bookId, b.isbn, b.title, b.author, b.publisher, b.publicationYear, " +
            "b.price, b.coverImage, b.totalQuantity, b.availableQuantity, b.status, b.createdAt, b.updatedAt " +
            "FROM Book b "
        );

        if (categoryId > 0) {
            sql.append("INNER JOIN BookCategory bc ON b.bookId = bc.bookId ");
        }

        sql.append("WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (b.title LIKE ? OR b.author LIKE ?) ");
        }

        if (categoryId > 0) {
            sql.append("AND bc.categoryId = ? ");
        }

        if (tagIds != null && tagIds.length > 0) {
            for (int i = 0; i < tagIds.length; i++) {
                sql.append("AND b.bookId IN (SELECT bookId FROM BookTag WHERE tagId = ?) ");
            }
        }

        if (availableOnly) {
            sql.append("AND b.availableQuantity > 0 ");
        }

        sql.append("ORDER BY b.createdAt DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                String likeParam = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, likeParam);
                ps.setString(paramIndex++, likeParam);
            }
            
            if (categoryId > 0) {
                ps.setInt(paramIndex++, categoryId);
            }
            
            if (tagIds != null && tagIds.length > 0) {
                for (int tId : tagIds) {
                    ps.setInt(paramIndex++, tId);
                }
            }
            
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book book = mapResultSetToBook(rs);
                    book.setCategories(getCategoriesByBookId(conn, book.getBookId()));
                    book.setTags(getTagsByBookId(conn, book.getBookId()));
                    books.add(book);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm kiếm sách", e);
        }
        return books;
    }

    /**
     * Đếm tổng số sách tìm kiếm được theo bộ lọc để phục vụ phân trang.
     */
    public int countSearchBooks(String keyword, int categoryId, int[] tagIds, boolean availableOnly) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(DISTINCT b.bookId) AS total FROM Book b "
        );

        if (categoryId > 0) {
            sql.append("INNER JOIN BookCategory bc ON b.bookId = bc.bookId ");
        }

        sql.append("WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (b.title LIKE ? OR b.author LIKE ?) ");
        }

        if (categoryId > 0) {
            sql.append("AND bc.categoryId = ? ");
        }

        if (tagIds != null && tagIds.length > 0) {
            for (int i = 0; i < tagIds.length; i++) {
                sql.append("AND b.bookId IN (SELECT bookId FROM BookTag WHERE tagId = ?) ");
            }
        }

        if (availableOnly) {
            sql.append("AND b.availableQuantity > 0 ");
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                String likeParam = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, likeParam);
                ps.setString(paramIndex++, likeParam);
            }
            
            if (categoryId > 0) {
                ps.setInt(paramIndex++, categoryId);
            }
            
            if (tagIds != null && tagIds.length > 0) {
                for (int tId : tagIds) {
                    ps.setInt(paramIndex++, tId);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm tổng số sách tìm kiếm", e);
        }
        return 0;
    }

    /**
     * FR-43: Lấy chi tiết một cuốn sách, bao gồm cả danh sách Category và Tag.
     * Ở đây sử dụng Option A (Dùng cột availableQuantity có sẵn).
     * 
     * @param bookId ID của sách
     * @return Đối tượng Book (đã kèm Category và Tag) hoặc null nếu không thấy
     */
    public Book getBookById(int bookId) {
        Book book = null;
        String sql = "SELECT * FROM Book WHERE bookId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    book = mapResultSetToBook(rs);
                    // Lấy thêm danh sách Category và Tag gộp vào
                    book.setCategories(getCategoriesByBookId(conn, bookId));
                    book.setTags(getTagsByBookId(conn, bookId));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy chi tiết sách ID=" + bookId, e);
        }
        return book;
    }

    /**
     * FR-45: Lấy Top Trending (Những sách được mượn nhiều nhất).
     * 
     * @param limit Số lượng tối đa
     * @return Danh sách sách Top Trending
     */
    public List<Book> getTopTrendingBooks(int limit) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT TOP (?) b.*, COUNT(br.borrowRecordId) AS borrowCount " +
                     "FROM Book b " +
                     "LEFT JOIN BorrowRecord br ON b.bookId = br.bookId " +
                     "WHERE b.status = 'available' " +
                     "GROUP BY b.bookId, b.isbn, b.title, b.author, b.publisher, b.publicationYear, " +
                     "b.price, b.coverImage, b.totalQuantity, b.availableQuantity, b.status, b.createdAt, b.updatedAt " +
                     "ORDER BY borrowCount DESC, b.createdAt DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book book = mapResultSetToBook(rs);
                    book.setCategories(getCategoriesByBookId(conn, book.getBookId()));
                    book.setTags(getTagsByBookId(conn, book.getBookId()));
                    books.add(book);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy sách Top Trending", e);
        }
        return books;
    }

    /**
     * Lấy tần suất xuất hiện của Category và Tag dựa trên lịch sử mượn.
     */
    public java.util.Map<String, java.util.Map<String, Integer>> getUserTagCategoryFrequency(int userId) {
        java.util.Map<String, java.util.Map<String, Integer>> result = new java.util.HashMap<>();
        java.util.Map<String, Integer> categoryFreq = new java.util.HashMap<>();
        java.util.Map<String, Integer> tagFreq = new java.util.HashMap<>();

        String sqlCategory = "SELECT c.name, COUNT(*) AS freq " +
                             "FROM BorrowRecord br " +
                             "INNER JOIN BookCategory bc ON br.bookId = bc.bookId " +
                             "INNER JOIN Category c ON bc.categoryId = c.categoryId " +
                             "WHERE br.userId = ? " +
                             "GROUP BY c.name " +
                             "ORDER BY freq DESC";
                             
        String sqlTag = "SELECT t.name, COUNT(*) AS freq " +
                        "FROM BorrowRecord br " +
                        "INNER JOIN BookTag bt ON br.bookId = bt.bookId " +
                        "INNER JOIN Tag t ON bt.tagId = t.tagId " +
                        "WHERE br.userId = ? " +
                        "GROUP BY t.name " +
                        "ORDER BY freq DESC";

        try (Connection conn = DatabaseConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sqlCategory)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        categoryFreq.put(rs.getString("name"), rs.getInt("freq"));
                    }
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(sqlTag)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        tagFreq.put(rs.getString("name"), rs.getInt("freq"));
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy tần suất tag/category cho userId=" + userId, e);
        }

        result.put("categories", categoryFreq);
        result.put("tags", tagFreq);
        return result;
    }

    /**
     * Lấy các cuốn sách mượn gần nhất (ID, Categories, Tags)
     */
    public List<model.BookSummaryDTO> getRecentBorrowedSummary(int userId, int limit) {
        List<model.BookSummaryDTO> list = new ArrayList<>();
        String sql = "SELECT TOP (?) br.bookId, c.name AS categoryName, t.name AS tagName " +
                     "FROM BorrowRecord br " +
                     "INNER JOIN BookCategory bc ON br.bookId = bc.bookId " +
                     "INNER JOIN Category c ON bc.categoryId = c.categoryId " +
                     "LEFT JOIN BookTag bt ON br.bookId = bt.bookId " +
                     "LEFT JOIN Tag t ON bt.tagId = t.tagId " +
                     "WHERE br.userId = ? " +
                     "ORDER BY br.startDate DESC";
                     
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                java.util.Map<Integer, model.BookSummaryDTO> map = new java.util.LinkedHashMap<>();
                while (rs.next()) {
                    int bookId = rs.getInt("bookId");
                    model.BookSummaryDTO dto = map.getOrDefault(bookId, new model.BookSummaryDTO(bookId, new ArrayList<>(), new ArrayList<>()));
                    
                    String catName = rs.getString("categoryName");
                    if (catName != null && !dto.getCategories().contains(catName)) {
                        dto.getCategories().add(catName);
                    }
                    
                    String tagName = rs.getString("tagName");
                    if (tagName != null && !dto.getTags().contains(tagName)) {
                        dto.getTags().add(tagName);
                    }
                    
                    map.put(bookId, dto);
                }
                list.addAll(map.values());
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy sách mượn gần đây cho userId=" + userId, e);
        }
        return list;
    }

    /**
     * Lấy candidate pool (Sách chưa mượn, cùng category/tag, xếp theo lượt mượn)
     */
    public List<model.BookSummaryDTO> getCandidatePoolWithTagsAndCategories(int userId, int limit) {
        List<model.BookSummaryDTO> pool = new ArrayList<>();
        String sql = "SELECT DISTINCT TOP (?) b.bookId, c.name AS categoryName, t.name AS tagName, " +
                     "(SELECT COUNT(*) FROM BorrowRecord WHERE bookId = b.bookId) AS borrowCount " +
                     "FROM Book b " +
                     "INNER JOIN BookCategory bc ON b.bookId = bc.bookId " +
                     "INNER JOIN Category c ON bc.categoryId = c.categoryId " +
                     "LEFT JOIN BookTag bt ON b.bookId = bt.bookId " +
                     "LEFT JOIN Tag t ON bt.tagId = t.tagId " +
                     "WHERE (" +
                     "    bc.categoryId IN (SELECT DISTINCT bc2.categoryId FROM BorrowRecord br INNER JOIN BookCategory bc2 ON br.bookId = bc2.bookId WHERE br.userId = ?) " +
                     "    OR bt.tagId IN (SELECT DISTINCT bt2.tagId FROM BorrowRecord br INNER JOIN BookTag bt2 ON br.bookId = bt2.bookId WHERE br.userId = ?) " +
                     ") " +
                     "AND b.bookId NOT IN (SELECT bookId FROM BorrowRecord WHERE userId = ?) " +
                     "AND b.status = 'available' " +
                     "ORDER BY borrowCount DESC, b.bookId";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            ps.setInt(4, userId);

            try (ResultSet rs = ps.executeQuery()) {
                java.util.Map<Integer, model.BookSummaryDTO> map = new java.util.LinkedHashMap<>();
                while (rs.next()) {
                    int bookId = rs.getInt("bookId");
                    model.BookSummaryDTO dto = map.getOrDefault(bookId, new model.BookSummaryDTO(bookId, new ArrayList<>(), new ArrayList<>()));
                    
                    String catName = rs.getString("categoryName");
                    if (catName != null && !dto.getCategories().contains(catName)) {
                        dto.getCategories().add(catName);
                    }
                    
                    String tagName = rs.getString("tagName");
                    if (tagName != null && !dto.getTags().contains(tagName)) {
                        dto.getTags().add(tagName);
                    }
                    
                    map.put(bookId, dto);
                }
                pool.addAll(map.values());
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy Candidate Pool cho userId=" + userId, e);
        }
        return pool;
    }

    /**
     * Lấy toàn bộ danh sách Category.
     */
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Category ORDER BY name ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category cat = new Category();
                cat.setCategoryId(rs.getInt("categoryId"));
                cat.setName(rs.getString("name"));
                cat.setDescription(rs.getString("description"));
                list.add(cat);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách Category", e);
        }
        return list;
    }

    /**
     * Lấy toàn bộ danh sách Tag.
     */
    public List<Tag> getAllTags() {
        List<Tag> list = new ArrayList<>();
        String sql = "SELECT * FROM Tag ORDER BY name ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Tag tag = new Tag();
                tag.setTagId(rs.getInt("tagId"));
                tag.setName(rs.getString("name"));
                list.add(tag);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách Tag", e);
        }
        return list;
    }

    // --- CÁC HÀM TIỆN ÍCH NỘI BỘ ---

    private List<Category> getCategoriesByBookId(Connection conn, int bookId) throws SQLException {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.* FROM Category c INNER JOIN BookCategory bc ON c.categoryId = bc.categoryId WHERE bc.bookId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category cat = new Category();
                    cat.setCategoryId(rs.getInt("categoryId"));
                    cat.setName(rs.getString("name"));
                    cat.setDescription(rs.getString("description"));
                    list.add(cat);
                }
            }
        }
        return list;
    }

    private List<Tag> getTagsByBookId(Connection conn, int bookId) throws SQLException {
        List<Tag> list = new ArrayList<>();
        String sql = "SELECT t.* FROM Tag t INNER JOIN BookTag bt ON t.tagId = bt.tagId WHERE bt.bookId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tag tag = new Tag();
                    tag.setTagId(rs.getInt("tagId"));
                    tag.setName(rs.getString("name"));
                    list.add(tag);
                }
            }
        }
        return list;
    }

    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setBookId(rs.getInt("bookId"));
        book.setIsbn(rs.getString("isbn"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setPublisher(rs.getString("publisher"));
        book.setPublicationYear(rs.getObject("publicationYear") != null ? rs.getInt("publicationYear") : null);
        book.setPrice(rs.getBigDecimal("price"));
        book.setTotalQuantity(rs.getInt("totalQuantity"));
        book.setAvailableQuantity(rs.getInt("availableQuantity"));
        book.setStatus(rs.getString("status"));
        book.setCoverImage(rs.getString("coverImage"));
        book.setCreatedAt(rs.getTimestamp("createdAt"));
        book.setUpdatedAt(rs.getTimestamp("updatedAt"));
        return book;
    }
    // =========================================================================
    // F6 DESK CIRCULATION METHODS (từ nhánh Thai)
    // =========================================================================

    /**
     * Tra cứu đầu sách theo ID, bao gồm giá gốc phục vụ tính phạt đền bù.
     *
     * <p>Được gọi trong luồng Check-in sách hỏng/mất (FR-F6-04) để lấy
     * {@code price} của sách nhằm tính toán số tiền phạt đền bù.
     * Hàm này cũng cần thiết để kiểm tra {@code totalQuantity} trước khi trừ.</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param bookId ID đầu sách cần tra cứu
     * @return Đối tượng {@code Book} nếu tìm thấy; {@code null} nếu không tồn tại
     * @throws SQLException nếu có lỗi thực thi trậy vấn SQL,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Event-driven]: WHEN damaged/lost check-in occurs,
    // THE LMS System SHALL query Book to get price for fine calculation [FR-F6-04]
    public Book findById(Connection conn, int bookId) throws SQLException {
        String sql = "SELECT bookId, isbn, title, author, publisher, publicationYear, "
                   + "       price, totalQuantity, availableQuantity, [status], "
                   + "       createdAt, updatedAt "
                   + "FROM   [Book] "
                   + "WHERE  bookId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Book book = new Book();
                    book.setBookId(rs.getInt("bookId"));
                    book.setIsbn(rs.getString("isbn"));
                    book.setTitle(rs.getString("title"));
                    book.setAuthor(rs.getString("author"));
                    book.setPublisher(rs.getString("publisher"));
                    int rawYear = rs.getInt("publicationYear");
                    book.setPublicationYear(rs.wasNull() ? null : rawYear);
                    BigDecimal price = rs.getBigDecimal("price");
                    book.setPrice(price);
                    book.setTotalQuantity(rs.getInt("totalQuantity"));
                    book.setAvailableQuantity(rs.getInt("availableQuantity"));
                    book.setStatus(rs.getString("status"));
                    book.setCreatedAt(rs.getTimestamp("createdAt"));
                    book.setUpdatedAt(rs.getTimestamp("updatedAt"));
                    return book;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi tra cứu Book theo bookId=" + bookId, e);
            throw e;
        }

        return null;
    }

    /**
     * Giảm {@code totalQuantity} đi 1 khi một bản sao bị hỏng hoặc mất.
     *
     * <p>Được gọi trong luồng Check-in sách hỏng/mất (FR-F6-04 — Node 6.17)
     * để loại bỏ vĩnh viễn bản sao đó khỏi tổng tài sản thư viện (BR-24).
     * Dùng {@code CASE WHEN} để đảm bảo {@code totalQuantity} không bao giờ
     * âm — bảo vệ tính nhất quán dữ liệu kho.
     * Hàm này không tự commit — commit do tầng Service kiểm soát (TRANS-01).</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param bookId ID đầu sách cần giảm tổng số lượng
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Event-driven]: WHEN Check-in condition IN ('damaged', 'lost'),
    // THE LMS System SHALL UPDATE Book.totalQuantity = totalQuantity - 1
    // WHERE bookId = ? [Node 6.17, FR-F6-04, BR-24]
    public void decrementTotalQuantity(Connection conn, int bookId) throws SQLException {
        String sql = "UPDATE [Book] "
                   + "SET    totalQuantity = CASE WHEN totalQuantity > 0 "
                   + "                           THEN totalQuantity - 1 "
                   + "                           ELSE 0 END, "
                   + "       updatedAt     = GETDATE() "
                   + "WHERE  bookId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi giảm totalQuantity cho bookId=" + bookId, e);
            throw e;
        }
    }

    /**
     * Tăng {@code availableQuantity} lên 1 khi sách được trả nguyên vẹn và không có ai chờ.
     *
     * <p>Được gọi trong nhánh "Queue Empty" của luồng Check-in sách tốt
     * (FR-F6-06 — Node 9.22). Dùng {@code CASE WHEN} để đảm bảo
     * {@code availableQuantity} không vượt quá {@code totalQuantity}.
     * Hàm này không tự commit — commit do tầng Service kiểm soát (TRANS-01).</p>
     *
     * @param conn   {@code Connection} được quản lý bởi tầng Service
     *               (đã {@code setAutoCommit(false)})
     * @param bookId ID đầu sách cần tăng số lượng khả dụng
     * @throws SQLException nếu có lỗi thực thi câu lệnh UPDATE,
     *                      cho phép Service tầng trên thực hiện rollback
     */
    // EARS[Condition-driven]: WHERE queue is empty after good return,
    // THE LMS System SHALL UPDATE Book.availableQuantity = availableQuantity + 1
    // WHERE bookId = ? [Node 9.22, FR-F6-06]
    public void incrementAvailableQuantity(Connection conn, int bookId) throws SQLException {
        String sql = "UPDATE [Book] "
                   + "SET    availableQuantity = CASE "
                   + "           WHEN availableQuantity < totalQuantity "
                   + "           THEN availableQuantity + 1 "
                   + "           ELSE availableQuantity END, "
                   + "       updatedAt         = GETDATE() "
                   + "WHERE  bookId = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                    "Lỗi khi tăng availableQuantity cho bookId=" + bookId, e);
            throw e;
        }
    }
}
