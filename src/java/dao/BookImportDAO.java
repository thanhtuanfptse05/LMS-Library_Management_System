package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.BookImportBatch;
import model.BookImportError;
import util.DatabaseConnection;

public class BookImportDAO {

    public int insertBatch(Connection conn, BookImportBatch batch) throws SQLException {
        String sql = "INSERT INTO BookImportBatch (importedBy, fileName, totalRows, successRows, failedRows, "
                + "[status], createdAt, expiresAt) VALUES (?, ?, ?, ?, ?, ?, GETDATE(), DATEADD(YEAR, 1, GETDATE()))";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, batch.getImportedBy());
            ps.setString(2, batch.getFileName());
            ps.setInt(3, batch.getTotalRows());
            ps.setInt(4, batch.getSuccessRows());
            ps.setInt(5, batch.getFailedRows());
            ps.setString(6, batch.getStatus());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new SQLException("Không thể lấy mã phiên import vừa tạo.");
    }

    public void insertErrors(Connection conn, int batchId, List<BookImportError> errors) throws SQLException {
        if (errors.isEmpty()) {
            return;
        }
        String sql = "INSERT INTO BookImportError (importBatchId, sheetName, rowNumber, columnName, "
                + "errorMessage, createdAt) VALUES (?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (BookImportError error : errors) {
                ps.setInt(1, batchId);
                ps.setString(2, error.getSheetName());
                ps.setInt(3, Math.max(1, error.getRowNumber()));
                ps.setString(4, error.getColumnName());
                ps.setString(5, error.getErrorMessage());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    public List<BookImportBatch> search(String keyword, String status, int offset, int pageSize)
            throws SQLException {
        StringBuilder sql = new StringBuilder(baseSelect() + " WHERE b.expiresAt > GETDATE() ");
        List<Object> values = new ArrayList<>();
        appendFilters(sql, values, keyword, status);
        sql.append("ORDER BY b.createdAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        values.add(offset);
        values.add(pageSize);
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bind(ps, values);
            try (ResultSet rs = ps.executeQuery()) {
                List<BookImportBatch> batches = new ArrayList<>();
                while (rs.next()) {
                    batches.add(mapBatch(rs));
                }
                return batches;
            }
        }
    }

    public int count(String keyword, String status) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM BookImportBatch b WHERE b.expiresAt > GETDATE() ");
        List<Object> values = new ArrayList<>();
        appendFilters(sql, values, keyword, status);
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bind(ps, values);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public BookImportBatch findById(int batchId) throws SQLException {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(baseSelect() + " WHERE b.importBatchId = ?")) {
            ps.setInt(1, batchId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                BookImportBatch batch = mapBatch(rs);
                batch.setErrors(findErrors(conn, batchId));
                return batch;
            }
        }
    }

    private List<BookImportError> findErrors(Connection conn, int batchId) throws SQLException {
        String sql = "SELECT importErrorId, importBatchId, sheetName, rowNumber, columnName, errorMessage, "
                + "createdAt FROM BookImportError WHERE importBatchId = ? ORDER BY sheetName, rowNumber, importErrorId";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, batchId);
            try (ResultSet rs = ps.executeQuery()) {
                List<BookImportError> errors = new ArrayList<>();
                while (rs.next()) {
                    BookImportError error = new BookImportError();
                    error.setImportErrorId(rs.getInt("importErrorId"));
                    error.setImportBatchId(rs.getInt("importBatchId"));
                    error.setSheetName(rs.getString("sheetName"));
                    error.setRowNumber(rs.getInt("rowNumber"));
                    error.setColumnName(rs.getString("columnName"));
                    error.setErrorMessage(rs.getString("errorMessage"));
                    error.setCreatedAt(rs.getTimestamp("createdAt"));
                    errors.add(error);
                }
                return errors;
            }
        }
    }

    private String baseSelect() {
        return "SELECT b.importBatchId, b.importedBy, COALESCE(mp.fullName, u.email) importedByName, "
                + "b.fileName, b.totalRows, b.successRows, b.failedRows, b.[status], b.createdAt, b.expiresAt "
                + "FROM BookImportBatch b JOIN [User] u ON u.userId = b.importedBy "
                + "LEFT JOIN MemberProfile mp ON mp.userId = b.importedBy";
    }

    private void appendFilters(StringBuilder sql, List<Object> values, String keyword, String status) {
        if (keyword != null) {
            sql.append("AND (b.fileName LIKE ? OR CAST(b.importBatchId AS NVARCHAR(20)) LIKE ?) ");
            values.add("%" + keyword + "%");
            values.add("%" + keyword + "%");
        }
        if (status != null) {
            sql.append("AND b.[status] = ? ");
            values.add(status);
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

    private BookImportBatch mapBatch(ResultSet rs) throws SQLException {
        BookImportBatch batch = new BookImportBatch();
        batch.setImportBatchId(rs.getInt("importBatchId"));
        batch.setImportedBy(rs.getInt("importedBy"));
        batch.setImportedByName(rs.getString("importedByName"));
        batch.setFileName(rs.getString("fileName"));
        batch.setTotalRows(rs.getInt("totalRows"));
        batch.setSuccessRows(rs.getInt("successRows"));
        batch.setFailedRows(rs.getInt("failedRows"));
        batch.setStatus(rs.getString("status"));
        batch.setCreatedAt(rs.getTimestamp("createdAt"));
        batch.setExpiresAt(rs.getTimestamp("expiresAt"));
        return batch;
    }
}
