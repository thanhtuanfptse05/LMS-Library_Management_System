package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.BookCopy;
import model.BookCopySummary;
import util.DatabaseConnection;

public class BookCopyDAO {

    public List<BookCopy> search(String keyword, String location, String status, int offset, int pageSize)
            throws SQLException {
        StringBuilder sql = new StringBuilder(baseSelect() + " WHERE 1 = 1 ");
        List<Object> parameters = new ArrayList<>();
        appendFilters(sql, parameters, keyword, location, status);
        sql.append("ORDER BY COALESCE(bc.updatedAt, bc.createdAt) DESC, bc.bookCopyId DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add(offset);
        parameters.add(pageSize);
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bind(ps, parameters);
            try (ResultSet rs = ps.executeQuery()) {
                List<BookCopy> copies = new ArrayList<>();
                while (rs.next()) {
                    copies.add(map(rs));
                }
                return copies;
            }
        }
    }

    public int count(String keyword, String location, String status) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM BookCopy bc JOIN Book b ON b.bookId = bc.bookId WHERE 1 = 1 ");
        List<Object> parameters = new ArrayList<>();
        appendFilters(sql, parameters, keyword, location, status);
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bind(ps, parameters);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public List<String> findLocations() throws SQLException {
        String sql = "SELECT DISTINCT [location] FROM BookCopy WHERE [location] IS NOT NULL "
                + "AND LTRIM(RTRIM([location])) <> '' ORDER BY [location]";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<String> locations = new ArrayList<>();
            while (rs.next()) {
                locations.add(rs.getString(1));
            }
            return locations;
        }
    }

    public BookCopySummary getSummary() throws SQLException {
        String sql = "SELECT COUNT(*) totalCopies, "
                + "SUM(CASE WHEN [status] = 'available' THEN 1 ELSE 0 END) availableCopies, "
                + "SUM(CASE WHEN [status] = 'borrowed' THEN 1 ELSE 0 END) borrowedCopies, "
                + "SUM(CASE WHEN condition IN ('damaged', 'lost') THEN 1 ELSE 0 END) incidentCopies FROM BookCopy";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            BookCopySummary summary = new BookCopySummary();
            if (rs.next()) {
                summary.setTotalCopies(rs.getInt("totalCopies"));
                summary.setAvailableCopies(rs.getInt("availableCopies"));
                summary.setBorrowedCopies(rs.getInt("borrowedCopies"));
                summary.setIncidentCopies(rs.getInt("incidentCopies"));
            }
            return summary;
        }
    }

    public BookCopy findById(Connection conn, int bookCopyId) throws SQLException {
        String sql = baseSelect() + " WHERE bc.bookCopyId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookCopyId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public BookCopy findByIdForUpdate(Connection conn, int bookCopyId) throws SQLException {
        return findForUpdate(conn, "bc.bookCopyId = ?", bookCopyId);
    }

    public BookCopy findByBarcodeForUpdate(Connection conn, String barcode) throws SQLException {
        return findForUpdate(conn, "bc.barcode = ?", barcode);
    }

    public BookCopy findByBarcode(Connection conn, String barcode) throws SQLException {
        String sql = baseSelect() + " WHERE bc.barcode = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, barcode);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public int insert(Connection conn, BookCopy copy) throws SQLException {
        String sql = "INSERT INTO BookCopy (bookId, [location], condition, [status], barcode, createdAt) "
                + "VALUES (?, ?, 'good', 'available', ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, copy.getBookId());
            ps.setString(2, copy.getLocation());
            ps.setString(3, copy.getBarcode());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new SQLException("Không thể lấy mã bản sao vừa tạo.");
    }

    public void updateAvailableCopy(Connection conn, BookCopy copy) throws SQLException {
        String sql = "UPDATE BookCopy SET [location] = ?, updatedAt = GETDATE() "
                + "WHERE bookCopyId = ? AND [status] = 'available' AND condition = 'good'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, copy.getLocation());
            ps.setInt(2, copy.getBookCopyId());
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Bản sao không còn ở trạng thái sẵn sàng.");
            }
        }
    }

    public void markUnavailable(Connection conn, int bookCopyId) throws SQLException {
        updateIncidentState(conn, bookCopyId, "SET [status] = 'unavailable', updatedAt = GETDATE()",
                "[status] = 'available' AND condition = 'good'");
    }

    public void restoreAvailable(Connection conn, int bookCopyId) throws SQLException {
        updateIncidentState(conn, bookCopyId, "SET [status] = 'available', updatedAt = GETDATE()",
                "[status] = 'unavailable' AND condition = 'good'");
    }

    public void resolveCondition(Connection conn, int bookCopyId, String condition) throws SQLException {
        String sql = "UPDATE BookCopy SET condition = ?, updatedAt = GETDATE() "
                + "WHERE bookCopyId = ? AND [status] = 'unavailable' AND condition = 'good'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, condition);
            ps.setInt(2, bookCopyId);
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Bản sao không còn ở trạng thái chờ kết luận sự cố.");
            }
        }
    }

    private BookCopy findForUpdate(Connection conn, String predicate, Object value) throws SQLException {
        String sql = "SELECT bc.bookCopyId, bc.bookId, b.title AS bookTitle, b.isbn, bc.[location], "
                + "bc.condition, bc.[status], bc.barcode, bc.createdAt, bc.updatedAt "
                + "FROM BookCopy bc WITH (UPDLOCK, ROWLOCK) JOIN Book b ON b.bookId = bc.bookId WHERE " + predicate;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (value instanceof Integer) {
                ps.setInt(1, (Integer) value);
            } else {
                ps.setString(1, String.valueOf(value));
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    private void updateIncidentState(Connection conn, int bookCopyId, String update, String predicate)
            throws SQLException {
        String sql = "UPDATE BookCopy " + update + " WHERE bookCopyId = ? AND " + predicate;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookCopyId);
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Bản sao không còn ở trạng thái phù hợp.");
            }
        }
    }

    private String baseSelect() {
        return "SELECT bc.bookCopyId, bc.bookId, b.title AS bookTitle, b.isbn, bc.[location], "
                + "bc.condition, bc.[status], bc.barcode, bc.createdAt, bc.updatedAt "
                + "FROM BookCopy bc JOIN Book b ON b.bookId = bc.bookId";
    }

    private void appendFilters(StringBuilder sql, List<Object> parameters, String keyword, String location, String status) {
        if (keyword != null) {
            sql.append("AND (bc.barcode LIKE ? OR b.title LIKE ? OR b.isbn LIKE ?) ");
            String value = "%" + keyword + "%";
            parameters.add(value);
            parameters.add(value);
            parameters.add(value);
        }
        if (location != null) {
            sql.append("AND bc.[location] = ? ");
            parameters.add(location);
        }
        if ("incident".equals(status)) {
            sql.append("AND bc.condition IN ('damaged', 'lost') ");
        } else if (status != null) {
            sql.append("AND bc.[status] = ? ");
            parameters.add(status);
        }
    }

    private void bind(PreparedStatement ps, List<Object> values) throws SQLException {
        for (int i = 0; i < values.size(); i++) {
            Object value = values.get(i);
            if (value instanceof Integer) {
                ps.setInt(i + 1, (Integer) value);
            } else {
                ps.setString(i + 1, String.valueOf(value));
            }
        }
    }

    private BookCopy map(ResultSet rs) throws SQLException {
        BookCopy copy = new BookCopy();
        copy.setBookCopyId(rs.getInt("bookCopyId"));
        copy.setBookId(rs.getInt("bookId"));
        copy.setBookTitle(rs.getString("bookTitle"));
        copy.setIsbn(rs.getString("isbn"));
        copy.setLocation(rs.getString("location"));
        copy.setCondition(rs.getString("condition"));
        copy.setStatus(rs.getString("status"));
        copy.setBarcode(rs.getString("barcode"));
        copy.setCreatedAt(rs.getTimestamp("createdAt"));
        copy.setUpdatedAt(rs.getTimestamp("updatedAt"));
        return copy;
    }
}
