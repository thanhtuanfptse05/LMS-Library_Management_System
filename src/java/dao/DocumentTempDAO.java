package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.DocumentTemp;
import util.DatabaseConnection;

/**
 * DocumentTempDAO — Data Access Object cho bảng [DocumentTemp].
 *
 * <p>Bảng DocumentTemp lưu trữ các Mẫu Email (Email Template) dùng để gửi
 * thông báo giao dịch cá nhân hóa (Mượn sách, Trả sách, Phạt...).
 * Manager có quyền xem và cập nhật nội dung các mẫu.</p>
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>SEC-03: 100% câu SQL dùng {@code PreparedStatement}.</li>
 *   <li>ENG-01: try-with-resources cho mọi tài nguyên JDBC.</li>
 *   <li>ARCH-01: JDBC thuần, không ORM.</li>
 * </ul>
 */
public class DocumentTempDAO {

    private static final Logger LOGGER = Logger.getLogger(DocumentTempDAO.class.getName());

    /**
     * Lấy toàn bộ danh sách mẫu Email. Dùng cho trang quản lý của Manager.
     *
     * @return Danh sách DocumentTemp, danh sách rỗng nếu không có dữ liệu
     */
    public List<DocumentTemp> getAll() {
        String sql = "SELECT tempId, tempName, [subject], bodyContent, managerId, createdAt, updatedAt "
                + "FROM DocumentTemp ORDER BY createdAt DESC";

        List<DocumentTemp> list = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToDocumentTemp(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all document templates", e);
        }
        return list;
    }

    /**
     * Tìm mẫu Email theo tên định danh (tempName).
     * Dùng khi hệ thống cần lấy mẫu để inject dữ liệu và gửi Email.
     *
     * @param tempName Tên định danh mẫu (VD: 'BORROW_SUCCESS', 'RETURN_SUCCESS')
     * @return DocumentTemp nếu tìm thấy, null nếu không tồn tại
     */
    public DocumentTemp findByTempName(String tempName) {
        String sql = "SELECT tempId, tempName, [subject], bodyContent, managerId, createdAt, updatedAt "
                + "FROM DocumentTemp WHERE tempName = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tempName);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDocumentTemp(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding document template by name=" + tempName, e);
        }
        return null;
    }

    /**
     * Tìm mẫu Email theo ID.
     *
     * @param tempId ID mẫu cần tìm
     * @return DocumentTemp nếu tìm thấy, null nếu không tồn tại
     */
    public DocumentTemp findById(int tempId) {
        String sql = "SELECT tempId, tempName, [subject], bodyContent, managerId, createdAt, updatedAt "
                + "FROM DocumentTemp WHERE tempId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tempId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDocumentTemp(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding document template by id=" + tempId, e);
        }
        return null;
    }

    /**
     * Thêm mẫu Email mới vào CSDL.
     *
     * @param dt Đối tượng DocumentTemp cần lưu (tempId sẽ bị bỏ qua)
     * @return ID tự động tăng vừa được tạo, -1 nếu thất bại
     */
    public int insert(DocumentTemp dt) {
        String sql = "INSERT INTO DocumentTemp (tempName, [subject], bodyContent, managerId, createdAt) "
                + "VALUES (?, ?, ?, ?, GETDATE())";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, dt.getTempName());
            ps.setString(2, dt.getSubject());
            ps.setString(3, dt.getBodyContent());
            ps.setInt(4, dt.getManagerId());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting document template: " + dt.getTempName(), e);
        }
        return -1;
    }

    /**
     * Cập nhật nội dung mẫu Email. Chỉ Manager mới được thực hiện.
     * Cập nhật: subject, bodyContent, updatedAt.
     *
     * @param dt Đối tượng DocumentTemp chứa dữ liệu mới (tempId dùng để định vị bản ghi)
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean update(DocumentTemp dt) {
        String sql = "UPDATE DocumentTemp SET [subject] = ?, bodyContent = ?, updatedAt = GETDATE() "
                + "WHERE tempId = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dt.getSubject());
            ps.setString(2, dt.getBodyContent());
            ps.setInt(3, dt.getTempId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating document template id=" + dt.getTempId(), e);
        }
        return false;
    }

    /**
     * Ánh xạ một dòng ResultSet thành đối tượng DocumentTemp.
     *
     * @param rs ResultSet đang trỏ tới dòng dữ liệu hợp lệ
     * @return Đối tượng DocumentTemp đã populate đầy đủ
     * @throws SQLException nếu có lỗi đọc dữ liệu
     */
    private DocumentTemp mapResultSetToDocumentTemp(ResultSet rs) throws SQLException {
        DocumentTemp dt = new DocumentTemp();
        dt.setTempId(rs.getInt("tempId"));
        dt.setTempName(rs.getString("tempName"));
        dt.setSubject(rs.getString("subject"));
        dt.setBodyContent(rs.getString("bodyContent"));
        dt.setManagerId(rs.getInt("managerId"));
        dt.setCreatedAt(rs.getTimestamp("createdAt"));
        dt.setUpdatedAt(rs.getTimestamp("updatedAt"));
        return dt;
    }
}
