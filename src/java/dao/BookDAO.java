package dao;

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
     * @param tagId ID Tag (0 nếu không lọc)
     * @param availableOnly Chỉ lấy sách có sẵn (availableQuantity > 0)
     * @param page Trang hiện tại (bắt đầu từ 1)
     * @param pageSize Số lượng trên mỗi trang
     * @return Danh sách các sách tìm được
     */
    public List<Book> searchBooks(String keyword, int categoryId, int tagId, boolean availableOnly, int page, int pageSize) {
        List<Book> books = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT b.bookId, b.isbn, b.title, b.author, b.publisher, b.publicationYear, " +
            "b.price, b.totalQuantity, b.availableQuantity, b.status, b.createdAt, b.updatedAt " +
            "FROM Book b "
        );

        if (categoryId > 0) {
            sql.append("INNER JOIN BookCategory bc ON b.bookId = bc.bookId ");
        }

        if (tagId > 0) {
            sql.append("INNER JOIN BookTag bt ON b.bookId = bt.bookId ");
        }

        sql.append("WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (b.title LIKE ? OR b.author LIKE ?) ");
        }

        if (categoryId > 0) {
            sql.append("AND bc.categoryId = ? ");
        }

        if (tagId > 0) {
            sql.append("AND bt.tagId = ? ");
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
            
            if (tagId > 0) {
                ps.setInt(paramIndex++, tagId);
            }
            
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm kiếm sách", e);
        }
        return books;
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
                     "INNER JOIN BorrowRecord br ON b.bookId = br.bookId " +
                     "WHERE b.status = 'available' " +
                     "GROUP BY b.bookId, b.isbn, b.title, b.author, b.publisher, b.publicationYear, " +
                     "b.price, b.totalQuantity, b.availableQuantity, b.status, b.createdAt, b.updatedAt " +
                     "ORDER BY borrowCount DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy sách Top Trending", e);
        }
        return books;
    }

    /**
     * FR-46: Lấy Candidate Pool (Những sách liên quan làm đầu vào cho AI).
     * Ở đây mô phỏng bằng cách lấy sách cùng Category với các sách user đã mượn.
     * 
     * @param userId ID người dùng
     * @param limit Số lượng tối đa
     * @return Danh sách ID sách
     */
    public List<Integer> getCandidatePool(int userId, int limit) {
        List<Integer> pool = new ArrayList<>();
        // Query mô phỏng: Lấy các sách thuộc về cùng Category mà User này từng mượn.
        String sql = "SELECT DISTINCT TOP (?) bc.bookId " +
                     "FROM BookCategory bc " +
                     "WHERE bc.categoryId IN (" +
                     "   SELECT DISTINCT bc2.categoryId " +
                     "   FROM BorrowRecord br " +
                     "   INNER JOIN BookCategory bc2 ON br.bookId = bc2.bookId " +
                     "   WHERE br.userId = ?" +
                     ") AND bc.bookId NOT IN (" +
                     "   SELECT bookId FROM BorrowRecord WHERE userId = ?" +
                     ")";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ps.setInt(2, userId);
            ps.setInt(3, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    pool.add(rs.getInt("bookId"));
                }
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
        book.setCreatedAt(rs.getTimestamp("createdAt"));
        book.setUpdatedAt(rs.getTimestamp("updatedAt"));
        return book;
    }
}
