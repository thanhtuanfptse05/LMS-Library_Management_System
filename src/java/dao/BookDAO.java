package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Book;
import model.BookCatalogSummary;
import model.Category;
import model.Tag;
import util.DatabaseConnection;

public class BookDAO {

    public List<Book> search(String keyword, Integer categoryId, Integer tagId, String status, String sort,
            int offset, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT b.bookId, b.isbn, b.title, b.author, b.publisher, b.publicationYear, b.price, "
                + "b.totalQuantity, b.availableQuantity, b.[status], b.createdAt, b.updatedAt "
                + "FROM Book b WHERE 1=1 ");
        List<Object> parameters = new ArrayList<>();
        appendFilters(sql, parameters, keyword, categoryId, tagId, status);
        sql.append(" ORDER BY ").append(resolveSort(sort)).append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add(offset);
        parameters.add(pageSize);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bind(ps, parameters);
            List<Book> books = new ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapBook(rs));
                }
            }
            loadRelations(conn, books);
            return books;
        }
    }

    public int count(String keyword, Integer categoryId, Integer tagId, String status) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Book b WHERE 1=1 ");
        List<Object> parameters = new ArrayList<>();
        appendFilters(sql, parameters, keyword, categoryId, tagId, status);
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bind(ps, parameters);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public BookCatalogSummary getSummary() throws SQLException {
        String sql = "SELECT COUNT(*) AS totalBooks, COALESCE(SUM(totalQuantity), 0) AS totalCopies, "
                + "COALESCE(SUM(availableQuantity), 0) AS availableCopies, "
                + "COALESCE(SUM(CASE WHEN totalQuantity = 0 THEN 1 ELSE 0 END), 0) AS booksWithoutCopies FROM Book";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            BookCatalogSummary summary = new BookCatalogSummary();
            if (rs.next()) {
                summary.setTotalBooks(rs.getInt("totalBooks"));
                summary.setTotalCopies(rs.getInt("totalCopies"));
                summary.setAvailableCopies(rs.getInt("availableCopies"));
                summary.setBooksWithoutCopies(rs.getInt("booksWithoutCopies"));
            }
            return summary;
        }
    }

    public Book findById(int bookId) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            return findById(conn, bookId);
        }
    }

    public List<Book> findAllForSelection() throws SQLException {
        String sql = "SELECT bookId, isbn, title, author, publisher, publicationYear, price, "
                + "totalQuantity, availableQuantity, [status], createdAt, updatedAt "
                + "FROM Book WHERE [status] = 'available' ORDER BY title";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Book> books = new ArrayList<>();
            while (rs.next()) {
                books.add(mapBook(rs));
            }
            return books;
        }
    }

    public Book findById(Connection conn, int bookId) throws SQLException {
        String sql = "SELECT bookId, isbn, title, author, publisher, publicationYear, price, "
                + "totalQuantity, availableQuantity, [status], createdAt, updatedAt FROM Book WHERE bookId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Book book = mapBook(rs);
                    loadRelations(conn, book);
                    return book;
                }
            }
            return null;
        }
    }

    public Book findByIsbn(Connection conn, String isbn) throws SQLException {
        String sql = "SELECT bookId, isbn, title, author, publisher, publicationYear, price, "
                + "totalQuantity, availableQuantity, [status], createdAt, updatedAt FROM Book WHERE isbn = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, isbn);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapBook(rs) : null;
            }
        }
    }

    public boolean existsByIsbn(Connection conn, String isbn) throws SQLException {
        String sql = "SELECT 1 FROM Book WHERE isbn = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, isbn);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int insert(Connection conn, Book book) throws SQLException {
        String sql = "INSERT INTO Book (isbn, title, author, publisher, publicationYear, price, "
                + "totalQuantity, availableQuantity, [status], createdAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, 0, 0, 'available', GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bindBookMetadata(ps, book, true);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new SQLException("Không lấy được ID đầu sách vừa tạo.");
                }
                return keys.getInt(1);
            }
        }
    }

    public void update(Connection conn, Book book) throws SQLException {
        String sql = "UPDATE Book SET title = ?, author = ?, publisher = ?, publicationYear = ?, "
                + "price = ?, [status] = ?, updatedAt = GETDATE() WHERE bookId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            bindBookMetadata(ps, book, false);
            ps.setInt(7, book.getBookId());
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Không tìm thấy đầu sách cần cập nhật.");
            }
        }
    }

    public void updateQuantities(Connection conn, int bookId, int totalDelta, int availableDelta) throws SQLException {
        String sql = "UPDATE Book SET totalQuantity = totalQuantity + ?, "
                + "availableQuantity = availableQuantity + ?, updatedAt = GETDATE() "
                + "WHERE bookId = ? AND totalQuantity + ? >= 0 AND availableQuantity + ? >= 0 "
                + "AND availableQuantity + ? <= totalQuantity + ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, totalDelta);
            ps.setInt(2, availableDelta);
            ps.setInt(3, bookId);
            ps.setInt(4, totalDelta);
            ps.setInt(5, availableDelta);
            ps.setInt(6, availableDelta);
            ps.setInt(7, totalDelta);
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Không thể đồng bộ số lượng tồn kho của đầu sách.");
            }
        }
    }

    public void replaceCategories(Connection conn, int bookId, int[] categoryIds) throws SQLException {
        replaceRelations(conn, "BookCategory", "categoryId", bookId, categoryIds);
    }

    public void replaceTags(Connection conn, int bookId, int[] tagIds) throws SQLException {
        replaceRelations(conn, "BookTag", "tagId", bookId, tagIds);
    }

    private void replaceRelations(Connection conn, String table, String relationColumn,
            int bookId, int[] relationIds) throws SQLException {
        try (PreparedStatement delete = conn.prepareStatement("DELETE FROM " + table + " WHERE bookId = ?")) {
            delete.setInt(1, bookId);
            delete.executeUpdate();
        }
        if (relationIds.length == 0) {
            return;
        }
        String sql = "INSERT INTO " + table + " (bookId, " + relationColumn + ") VALUES (?, ?)";
        try (PreparedStatement insert = conn.prepareStatement(sql)) {
            for (int relationId : relationIds) {
                insert.setInt(1, bookId);
                insert.setInt(2, relationId);
                insert.addBatch();
            }
            insert.executeBatch();
        }
    }

    private void appendFilters(StringBuilder sql, List<Object> parameters, String keyword,
            Integer categoryId, Integer tagId, String status) {
        if (keyword != null && !keyword.isBlank()) {
            sql.append("AND (b.title LIKE ? OR b.isbn LIKE ? OR b.author LIKE ?) ");
            String value = "%" + keyword.trim() + "%";
            parameters.add(value);
            parameters.add(value);
            parameters.add(value);
        }
        if (categoryId != null) {
            sql.append("AND EXISTS (SELECT 1 FROM BookCategory bc WHERE bc.bookId = b.bookId AND bc.categoryId = ?) ");
            parameters.add(categoryId);
        }
        if (tagId != null) {
            sql.append("AND EXISTS (SELECT 1 FROM BookTag bt WHERE bt.bookId = b.bookId AND bt.tagId = ?) ");
            parameters.add(tagId);
        }
        if ("noCopies".equals(status)) {
            sql.append("AND b.totalQuantity = 0 ");
        } else if ("available".equals(status) || "unavailable".equals(status)) {
            sql.append("AND b.[status] = ? ");
            parameters.add(status);
        }
    }

    private String resolveSort(String sort) {
        if ("title".equals(sort)) {
            return "b.title ASC";
        }
        if ("copies".equals(sort)) {
            return "b.totalQuantity DESC, b.title ASC";
        }
        if ("noCopies".equals(sort)) {
            return "CASE WHEN b.totalQuantity = 0 THEN 0 ELSE 1 END, b.title ASC";
        }
        return "COALESCE(b.updatedAt, b.createdAt) DESC, b.bookId DESC";
    }

    private void loadRelations(Connection conn, Book book) throws SQLException {
        book.setCategories(loadCategories(conn, book.getBookId()));
        book.setTags(loadTags(conn, book.getBookId()));
    }

    private void loadRelations(Connection conn, List<Book> books) throws SQLException {
        if (books.isEmpty()) {
            return;
        }
        Map<Integer, Book> booksById = new HashMap<>();
        for (Book book : books) {
            booksById.put(book.getBookId(), book);
        }
        String placeholders = String.join(",", java.util.Collections.nCopies(books.size(), "?"));
        String categorySql = "SELECT bc.bookId, c.categoryId, c.name, c.description, c.[status] FROM BookCategory bc "
                + "JOIN Category c ON c.categoryId = bc.categoryId WHERE bc.bookId IN (" + placeholders + ") ORDER BY c.name";
        try (PreparedStatement ps = conn.prepareStatement(categorySql)) {
            bindBookIds(ps, books);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("categoryId"));
                    category.setName(rs.getString("name"));
                    category.setDescription(rs.getString("description"));
                    category.setStatus(rs.getString("status"));
                    booksById.get(rs.getInt("bookId")).getCategories().add(category);
                }
            }
        }
        String tagSql = "SELECT bt.bookId, t.tagId, t.name, t.[status] FROM BookTag bt "
                + "JOIN Tag t ON t.tagId = bt.tagId WHERE bt.bookId IN (" + placeholders + ") ORDER BY t.name";
        try (PreparedStatement ps = conn.prepareStatement(tagSql)) {
            bindBookIds(ps, books);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tag tag = new Tag();
                    tag.setTagId(rs.getInt("tagId"));
                    tag.setName(rs.getString("name"));
                    tag.setStatus(rs.getString("status"));
                    booksById.get(rs.getInt("bookId")).getTags().add(tag);
                }
            }
        }
    }

    private void bindBookIds(PreparedStatement ps, List<Book> books) throws SQLException {
        for (int i = 0; i < books.size(); i++) {
            ps.setInt(i + 1, books.get(i).getBookId());
        }
    }

    private List<Category> loadCategories(Connection conn, int bookId) throws SQLException {
        String sql = "SELECT c.categoryId, c.name, c.description, c.[status] FROM Category c "
                + "JOIN BookCategory bc ON bc.categoryId = c.categoryId WHERE bc.bookId = ? ORDER BY c.name";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Category> categories = new ArrayList<>();
                while (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("categoryId"));
                    category.setName(rs.getString("name"));
                    category.setDescription(rs.getString("description"));
                    category.setStatus(rs.getString("status"));
                    categories.add(category);
                }
                return categories;
            }
        }
    }

    private List<Tag> loadTags(Connection conn, int bookId) throws SQLException {
        String sql = "SELECT t.tagId, t.name, t.[status] FROM Tag t JOIN BookTag bt ON bt.tagId = t.tagId "
                + "WHERE bt.bookId = ? ORDER BY t.name";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Tag> tags = new ArrayList<>();
                while (rs.next()) {
                    Tag tag = new Tag();
                    tag.setTagId(rs.getInt("tagId"));
                    tag.setName(rs.getString("name"));
                    tag.setStatus(rs.getString("status"));
                    tags.add(tag);
                }
                return tags;
            }
        }
    }

    private Book mapBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setBookId(rs.getInt("bookId"));
        book.setIsbn(rs.getString("isbn"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setPublisher(rs.getString("publisher"));
        int year = rs.getInt("publicationYear");
        book.setPublicationYear(rs.wasNull() ? null : year);
        book.setPrice(rs.getBigDecimal("price"));
        book.setTotalQuantity(rs.getInt("totalQuantity"));
        book.setAvailableQuantity(rs.getInt("availableQuantity"));
        book.setStatus(rs.getString("status"));
        book.setCreatedAt(rs.getTimestamp("createdAt"));
        book.setUpdatedAt(rs.getTimestamp("updatedAt"));
        return book;
    }

    private void bindBookMetadata(PreparedStatement ps, Book book, boolean includeIsbn) throws SQLException {
        int index = 1;
        if (includeIsbn) {
            ps.setString(index++, book.getIsbn());
        }
        ps.setString(index++, book.getTitle());
        ps.setString(index++, book.getAuthor());
        ps.setString(index++, book.getPublisher());
        if (book.getPublicationYear() == null) {
            ps.setNull(index++, java.sql.Types.INTEGER);
        } else {
            ps.setInt(index++, book.getPublicationYear());
        }
        ps.setBigDecimal(index++, book.getPrice());
        if (!includeIsbn) {
            ps.setString(index, book.getStatus());
        }
    }

    private void bind(PreparedStatement ps, List<Object> parameters) throws SQLException {
        for (int i = 0; i < parameters.size(); i++) {
            Object value = parameters.get(i);
            if (value instanceof Integer) {
                ps.setInt(i + 1, (Integer) value);
            } else {
                ps.setString(i + 1, String.valueOf(value));
            }
        }
    }
}
