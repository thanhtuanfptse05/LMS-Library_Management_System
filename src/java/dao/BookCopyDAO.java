package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.BookCopy;
import dto.BookCopySummaryDTO;
import util.DatabaseConnection;

public class BookCopyDAO {

    public List<BookCopy> search(String keyword, String location, String status, int offset, int pageSize)
            throws SQLException {
        StringBuilder sql = new StringBuilder(baseSelect() + " WHERE 1 = 1 ");
        List<Object> parameters = new ArrayList<>();
        appendFilters(sql, parameters, keyword, location, status);
        sql.append("ORDER BY COALESCE(bc.updatedAt, bc.createdAt) DESC, bc.bookCopyId DESC "
                + "LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add(offset);
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
        String sql = "SELECT DISTINCT location FROM BookCopy WHERE location IS NOT NULL "
                + "AND LTRIM(RTRIM(location)) <> '' ORDER BY location";
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

    public BookCopySummaryDTO getSummary() throws SQLException {
        String sql = "SELECT COUNT(*) totalCopies, "
                + "SUM(CASE WHEN status = 'available' THEN 1 ELSE 0 END) availableCopies, "
                + "SUM(CASE WHEN status = 'borrowed' THEN 1 ELSE 0 END) borrowedCopies, "
                + "SUM(CASE WHEN condition IN ('damaged', 'lost') THEN 1 ELSE 0 END) incidentCopies FROM BookCopy";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            BookCopySummaryDTO summary = new BookCopySummaryDTO();
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

    public BookCopy findAvailableCopyByBookId(Connection conn, int bookId) throws SQLException {
        String sql = baseSelect() + " WHERE bc.bookId = ? AND bc.status = 'available' AND bc.condition = 'good' LIMIT 1 FOR UPDATE";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
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

    public java.util.Map<Integer, String> findBarcodesForCopyIds(Connection conn, List<Integer> copyIds) throws SQLException {
        java.util.Map<Integer, String> map = new java.util.HashMap<>();
        if (copyIds == null || copyIds.isEmpty()) {
            return map;
        }
        StringBuilder sql = new StringBuilder("SELECT bookCopyId, barcode FROM BookCopy WHERE bookCopyId IN (");
        for (int i = 0; i < copyIds.size(); i++) {
            sql.append(i == 0 ? "?" : ", ?");
        }
        sql.append(")");
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < copyIds.size(); i++) {
                ps.setInt(i + 1, copyIds.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getInt("bookCopyId"), rs.getString("barcode"));
                }
            }
        }
        return map;
    }

    public int insert(Connection conn, BookCopy copy) throws SQLException {
        String sql = "INSERT INTO BookCopy (bookId, location, condition, status, barcode, createdAt) "
                + "VALUES (?, ?, 'good', 'available', ?, NOW())";
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
        String sql = "UPDATE BookCopy SET location = ?, updatedAt = NOW() "
                + "WHERE bookCopyId = ? AND status = 'available' AND condition = 'good'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, copy.getLocation());
            ps.setInt(2, copy.getBookCopyId());
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Bản sao không còn ở trạng thái sẵn sàng.");
            }
        }
    }

    public void updateLocation(Connection conn, int bookCopyId, String location) throws SQLException {
        String sql = "UPDATE BookCopy SET location = ?, updatedAt = NOW() WHERE bookCopyId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, location);
            ps.setInt(2, bookCopyId);
            if (ps.executeUpdate() != 1) throw new SQLException("Bản sao không tồn tại.");
        }
    }

    public void markUnavailable(Connection conn, int bookCopyId) throws SQLException {
        updateIncidentState(conn, bookCopyId, "SET status = 'unavailable', updatedAt = NOW()",
                "status = 'available' AND condition = 'good'");
    }

    public void restoreAvailable(Connection conn, int bookCopyId) throws SQLException {
        updateIncidentState(conn, bookCopyId, "SET status = 'available', updatedAt = NOW()",
                "status = 'unavailable' AND condition = 'good'");
    }

    public void restoreAfterRepair(Connection conn, int bookCopyId) throws SQLException {
        updateIncidentState(conn, bookCopyId,
                "SET status = 'available', condition = 'good', updatedAt = NOW()",
                "status = 'unavailable' AND condition = 'damaged'");
    }

    public void resolveCondition(Connection conn, int bookCopyId, String condition) throws SQLException {
        String sql = "UPDATE BookCopy SET condition = ?, updatedAt = NOW() "
                + "WHERE bookCopyId = ? AND status = 'unavailable' AND condition = 'good'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, condition);
            ps.setInt(2, bookCopyId);
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Bản sao không còn ở trạng thái chờ kết luận sự cố.");
            }
        }
    }

    /**
     * @deprecated Sử dụng {@link #updateStatusToBorrowedFromAvailable} hoặc
     * {@link #updateStatusToBorrowedFromReserved} thay thế.
     * Hàm cũ chỉ chấp nhận status='available' gây lỗi khi checkout pre-reservation.
     */
    @Deprecated
    public void updateStatusToBorrowed(Connection conn, int bookCopyId) throws SQLException {
        updateStatusToBorrowedFromAvailable(conn, bookCopyId);
    }

    /**
     * Walk-in checkout: chuyển BookCopy từ 'available' → 'borrowed'.
     * <p>CÓ giảm {@code Book.availableQuantity -= 1} vì chưa giảm từ trước.</p>
     *
     * @param conn       Connection trong Transaction
     * @param bookCopyId ID bản sao sách
     * @throws SQLException nếu BookCopy không ở status='available' hoặc availableQuantity đã = 0
     */
    public void updateStatusToBorrowedFromAvailable(Connection conn, int bookCopyId) throws SQLException {
        updateStatus(conn, bookCopyId, "borrowed", "available");
        String sql = "UPDATE Book SET availableQuantity = availableQuantity - 1, updatedAt = NOW() "
                + "WHERE bookId = (SELECT bookId FROM BookCopy WHERE bookCopyId = ?) "
                + "AND availableQuantity > 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookCopyId);
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Không thể đồng bộ số lượng sách khả dụng.");
            }
        }
    }

    /**
     * Pre-reservation checkout: chuyển BookCopy từ 'reserved' → 'borrowed'.
     * <p>KHÔNG giảm {@code Book.availableQuantity} vì đã giảm khi đặt trước
     * trong {@code OnlineCirculationService.reserveBook()}.</p>
     *
     * @param conn       Connection trong Transaction
     * @param bookCopyId ID bản sao sách
     * @throws SQLException nếu BookCopy không ở status='reserved'
     */
    public void updateStatusToBorrowedFromReserved(Connection conn, int bookCopyId) throws SQLException {
        updateStatus(conn, bookCopyId, "borrowed", "reserved");
    }

    public void updateStatusToUnavailable(Connection conn, int bookCopyId, String condition)
            throws SQLException {
        String sql = "UPDATE BookCopy SET status = 'unavailable', condition = ?, updatedAt = NOW() "
                + "WHERE bookCopyId = ? AND status = 'borrowed'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, condition);
            ps.setInt(2, bookCopyId);
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Bản sao không ở trạng thái đang mượn.");
            }
        }
    }

    public void updateStatusToAvailable(Connection conn, int bookCopyId) throws SQLException {
        String sql = "UPDATE BookCopy SET status = 'available', condition = 'good', updatedAt = NOW() "
                + "WHERE bookCopyId = ? AND status IN ('borrowed', 'reserved', 'unavailable')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookCopyId);
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Bản sao không thể chuyển về trạng thái khả dụng.");
            }
        }
    }

    public void updateStatusToReserved(Connection conn, int bookCopyId) throws SQLException {
        updateStatus(conn, bookCopyId, "reserved", "available");
    }

    private void updateStatus(Connection conn, int bookCopyId, String targetStatus, String expectedStatus)
            throws SQLException {
        String sql = "UPDATE BookCopy SET status = ?, updatedAt = NOW() "
                + "WHERE bookCopyId = ? AND status = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, targetStatus);
            ps.setInt(2, bookCopyId);
            ps.setString(3, expectedStatus);
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Bản sao không còn ở trạng thái phù hợp.");
            }
        }
    }

    private BookCopy findForUpdate(Connection conn, String predicate, Object value) throws SQLException {
        String sql = "SELECT bc.bookCopyId, bc.bookId, b.title AS bookTitle, b.isbn, bc.location, "
                + "bc.condition, bc.status, bc.barcode, bc.createdAt, bc.updatedAt "
                + "FROM BookCopy bc JOIN Book b ON b.bookId = bc.bookId WHERE " + predicate + " FOR UPDATE";
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
        return "SELECT bc.bookCopyId, bc.bookId, b.title AS bookTitle, b.isbn, bc.location, "
                + "bc.condition, bc.status, bc.barcode, bc.createdAt, bc.updatedAt "
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
            sql.append("AND bc.location = ? ");
            parameters.add(location);
        }
        if ("incident".equals(status)) {
            sql.append("AND bc.condition IN ('damaged', 'lost') ");
        } else if (status != null) {
            sql.append("AND bc.status = ? ");
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
