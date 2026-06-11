package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.BookCopyIncident;
import model.BookCopyIncidentSummary;
import util.DatabaseConnection;

public class BookCopyIncidentDAO {

    public List<BookCopyIncident> search(String keyword, String incidentType, String status,
            int offset, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder(baseSelect() + " WHERE 1 = 1 ");
        List<Object> parameters = new ArrayList<>();
        appendFilters(sql, parameters, keyword, incidentType, status);
        sql.append("ORDER BY i.reportedAt DESC, i.incidentId DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        parameters.add(offset);
        parameters.add(pageSize);
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bind(ps, parameters);
            try (ResultSet rs = ps.executeQuery()) {
                List<BookCopyIncident> incidents = new ArrayList<>();
                while (rs.next()) {
                    incidents.add(map(rs));
                }
                return incidents;
            }
        }
    }

    public int count(String keyword, String incidentType, String status) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM BookCopyIncident i "
                + "JOIN BookCopy bc ON bc.bookCopyId = i.bookCopyId "
                + "JOIN Book b ON b.bookId = bc.bookId WHERE 1 = 1 ");
        List<Object> parameters = new ArrayList<>();
        appendFilters(sql, parameters, keyword, incidentType, status);
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bind(ps, parameters);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public BookCopyIncidentSummary getSummary() throws SQLException {
        String sql = "SELECT "
                + "SUM(CASE WHEN [status] = 'pending' THEN 1 ELSE 0 END) pendingCount, "
                + "SUM(CASE WHEN [status] = 'investigating' THEN 1 ELSE 0 END) investigatingCount, "
                + "SUM(CASE WHEN [status] IN ('resolved', 'rejected') "
                + "AND resolvedAt >= DATEFROMPARTS(YEAR(GETDATE()), "
                + "MONTH(GETDATE()), 1) THEN 1 ELSE 0 END) resolvedThisMonthCount FROM BookCopyIncident";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            BookCopyIncidentSummary summary = new BookCopyIncidentSummary();
            if (rs.next()) {
                summary.setPendingCount(rs.getInt("pendingCount"));
                summary.setInvestigatingCount(rs.getInt("investigatingCount"));
                summary.setResolvedThisMonthCount(rs.getInt("resolvedThisMonthCount"));
            }
            return summary;
        }
    }

    public BookCopyIncident findById(Connection conn, int incidentId) throws SQLException {
        return find(conn, baseSelect() + " WHERE i.incidentId = ?", incidentId);
    }

    public BookCopyIncident findByIdForUpdate(Connection conn, int incidentId) throws SQLException {
        return find(conn, baseSelect("BookCopyIncident i WITH (UPDLOCK, ROWLOCK)")
                + " WHERE i.incidentId = ?", incidentId);
    }

    public BookCopyIncident findOpenByBookCopyId(Connection conn, int bookCopyId) throws SQLException {
        return find(conn, baseSelect() + " WHERE i.bookCopyId = ? "
                + "AND i.[status] IN ('pending', 'investigating')", bookCopyId);
    }

    public int insert(Connection conn, BookCopyIncident incident) throws SQLException {
        String sql = "INSERT INTO BookCopyIncident (bookCopyId, incidentType, description, [status], "
                + "reportedBy, reportedAt) VALUES (?, ?, ?, 'pending', ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, incident.getBookCopyId());
            ps.setString(2, incident.getIncidentType());
            ps.setString(3, incident.getDescription());
            ps.setInt(4, incident.getReportedBy());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new SQLException("Không thể lấy mã sự cố vừa tạo.");
    }

    public void startInvestigating(Connection conn, int incidentId) throws SQLException {
        String sql = "UPDATE BookCopyIncident SET [status] = 'investigating' "
                + "WHERE incidentId = ? AND [status] = 'pending'";
        executeSingleUpdate(conn, sql, incidentId);
    }

    public void finish(Connection conn, int incidentId, String status, String resolution, int actorId)
            throws SQLException {
        String sql = "UPDATE BookCopyIncident SET [status] = ?, resolution = ?, resolvedBy = ?, "
                + "resolvedAt = GETDATE() WHERE incidentId = ? AND [status] IN ('pending', 'investigating')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, resolution);
            ps.setInt(3, actorId);
            ps.setInt(4, incidentId);
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Sự cố không còn ở trạng thái có thể kết luận.");
            }
        }
    }

    private BookCopyIncident find(Connection conn, String sql, int id) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    private void executeSingleUpdate(Connection conn, String sql, int incidentId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, incidentId);
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Sự cố không còn ở trạng thái phù hợp.");
            }
        }
    }

    private String baseSelect() {
        return baseSelect("BookCopyIncident i");
    }

    private String baseSelect(String incidentTable) {
        return "SELECT i.incidentId, i.bookCopyId, bc.barcode, b.title AS bookTitle, i.incidentType, "
                + "i.description, i.[status], i.resolution, i.reportedBy, "
                + "COALESCE(reporter.fullName, ru.email) reportedByName, i.reportedAt, i.resolvedBy, "
                + "COALESCE(resolver.fullName, xu.email) resolvedByName, i.resolvedAt FROM "
                + incidentTable + " JOIN BookCopy bc ON bc.bookCopyId = i.bookCopyId "
                + "JOIN Book b ON b.bookId = bc.bookId JOIN [User] ru ON ru.userId = i.reportedBy "
                + "LEFT JOIN MemberProfile reporter ON reporter.userId = i.reportedBy "
                + "LEFT JOIN [User] xu ON xu.userId = i.resolvedBy "
                + "LEFT JOIN MemberProfile resolver ON resolver.userId = i.resolvedBy";
    }

    private void appendFilters(StringBuilder sql, List<Object> parameters, String keyword,
            String incidentType, String status) {
        if (keyword != null) {
            sql.append("AND (bc.barcode LIKE ? OR b.title LIKE ?) ");
            String value = "%" + keyword + "%";
            parameters.add(value);
            parameters.add(value);
        }
        if (incidentType != null) {
            sql.append("AND i.incidentType = ? ");
            parameters.add(incidentType);
        }
        if (status != null) {
            sql.append("AND i.[status] = ? ");
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

    private BookCopyIncident map(ResultSet rs) throws SQLException {
        BookCopyIncident incident = new BookCopyIncident();
        incident.setIncidentId(rs.getInt("incidentId"));
        incident.setBookCopyId(rs.getInt("bookCopyId"));
        incident.setBarcode(rs.getString("barcode"));
        incident.setBookTitle(rs.getString("bookTitle"));
        incident.setIncidentType(rs.getString("incidentType"));
        incident.setDescription(rs.getString("description"));
        incident.setStatus(rs.getString("status"));
        incident.setResolution(rs.getString("resolution"));
        incident.setReportedBy(rs.getInt("reportedBy"));
        incident.setReportedByName(rs.getString("reportedByName"));
        incident.setReportedAt(rs.getTimestamp("reportedAt"));
        int resolvedBy = rs.getInt("resolvedBy");
        incident.setResolvedBy(rs.wasNull() ? null : resolvedBy);
        incident.setResolvedByName(rs.getString("resolvedByName"));
        incident.setResolvedAt(rs.getTimestamp("resolvedAt"));
        return incident;
    }
}
