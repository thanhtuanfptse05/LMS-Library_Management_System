package service;

import dao.UserDAO;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import model.MemberProfile;
import model.User;
import dto.UserDTO;
import org.mindrot.jbcrypt.BCrypt;

/**
 * UserService — Lớp xử lý logic nghiệp vụ quản lý tài khoản người dùng.
 */
public class UserService {

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public UserService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    /**
     * Lấy danh sách người dùng phân trang và lọc tìm kiếm.
     */
    public List<UserDTO> getUserList(String search, String role, String status, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return userDAO.findAllUsers(search, role, status, offset, pageSize);
    }

    /**
     * Lấy tổng số lượng người dùng để phân trang.
     */
    public int getTotalUserCount(String search, String role, String status) {
        return userDAO.countAllUsers(search, role, status);
    }

    /**
     * Lấy toàn bộ danh sách người dùng không phân trang để xuất dữ liệu.
     */
    public List<UserDTO> getUsersForExport(String search, String role, String status) {
        return userDAO.findAllUsers(search, role, status, 0, Integer.MAX_VALUE);
    }

    /**
     * Lấy chi tiết thông tin người dùng gộp.
     */
    public UserDTO getUserDetail(int userId) {
        return userDAO.findUserDTOById(userId);
    }

    /**
     * Tạo tài khoản người dùng mới (đơn lẻ).
     */
    public void createUser(UserDTO dto, int creatorId) throws Exception {
        validateUserDTO(dto, true);

        // Băm mật khẩu mặc định bằng Email (BR-12)
        String rawPassword = dto.getEmail().trim();
        String passwordHash = BCrypt.hashpw(rawPassword, BCrypt.gensalt(10));

        User user = new User();
        user.setEmail(dto.getEmail().trim());
        user.setPasswordHash(passwordHash);
        user.setStatus(dto.getStatus() != null ? dto.getStatus() : "active");
        user.setRole(dto.getRole().toUpperCase());

        MemberProfile profile = new MemberProfile();
        profile.setFullName(dto.getFullName().trim());
        profile.setPhoneNumber(dto.getPhoneNumber() != null ? dto.getPhoneNumber().trim() : "");
        profile.setGender(dto.getGender() != null ? dto.getGender().trim() : "Khác");
        profile.setDateOfBirth(dto.getDateOfBirth());
        Date currentDate = new Date(System.currentTimeMillis());
        profile.setStartDate(dto.getStartDate() != null ? dto.getStartDate() : currentDate);
        
        if (dto.getEndDate() != null) {
            profile.setEndDate(dto.getEndDate());
        } else if ("STUDENT".equalsIgnoreCase(dto.getRole())) {
            java.time.LocalDate localStartDate = profile.getStartDate().toLocalDate();
            profile.setEndDate(Date.valueOf(localStartDate.plusYears(4)));
        } else {
            profile.setEndDate(new Date(System.currentTimeMillis() + 31536000000L));
        }

        boolean success = userDAO.createUserWithProfile(
                user, profile, 
                dto.getCode().trim(), 
                dto.getMajor() != null ? dto.getMajor().trim() : null, 
                dto.getEnrollmentYear(), 
                dto.getDepartment() != null ? dto.getDepartment().trim() : null
        );

        if (!success) {
            throw new Exception("Lỗi hệ thống khi tạo tài khoản người dùng.");
        }

        // Ghi Audit Log (BR-14)
        String logDetails = String.format("{\"email\":\"%s\",\"role\":\"%s\",\"code\":\"%s\"}", user.getEmail(), user.getRole(), dto.getCode());
        userDAO.insertAuditLog(creatorId, "CREATE_USER", "User", user.getUserId(), null, logDetails);
    }

    /**
     * Cập nhật thông tin tài khoản người dùng.
     */
    public void updateUser(UserDTO dto, int updaterId) throws Exception {
        UserDTO oldDto = userDAO.findUserDTOById(dto.getUserId());
        if (oldDto == null) {
            throw new Exception("Tài khoản không tồn tại trên hệ thống.");
        }

        if ("ADMIN".equalsIgnoreCase(oldDto.getRole()) && updaterId != oldDto.getUserId()) {
            throw new Exception("Bạn không có quyền chỉnh sửa thông tin của Quản trị viên khác.");
        }

        validateUserDTO(dto, false);

        User user = new User();
        user.setUserId(dto.getUserId());
        user.setEmail(dto.getEmail());
        user.setStatus(dto.getStatus() != null ? dto.getStatus() : "active");
        user.setRole(oldDto.getRole());
        
        MemberProfile profile = new MemberProfile();
        profile.setFullName(dto.getFullName().trim());
        profile.setPhoneNumber(dto.getPhoneNumber() != null ? dto.getPhoneNumber().trim() : "");
        profile.setGender(dto.getGender() != null ? dto.getGender().trim() : "Khác");
        profile.setDateOfBirth(dto.getDateOfBirth());
        profile.setStartDate(oldDto.getStartDate());
        profile.setEndDate(dto.getEndDate() != null ? dto.getEndDate() : oldDto.getEndDate());

        boolean success = userDAO.updateUserWithProfile(
                user, profile, 
                dto.getCode().trim(), 
                dto.getMajor() != null ? dto.getMajor().trim() : null, 
                dto.getEnrollmentYear(), 
                dto.getDepartment() != null ? dto.getDepartment().trim() : null
        );

        if (!success) {
            throw new Exception("Lỗi hệ thống khi cập nhật tài khoản.");
        }

        // Ghi Audit Log (BR-14)
        String oldValues = String.format("{\"fullName\":\"%s\",\"phoneNumber\":\"%s\",\"status\":\"%s\"}", 
                oldDto.getFullName(), oldDto.getPhoneNumber(), oldDto.getStatus());
        String newValues = String.format("{\"fullName\":\"%s\",\"phoneNumber\":\"%s\",\"status\":\"%s\"}", 
                dto.getFullName(), dto.getPhoneNumber(), dto.getStatus());
        userDAO.insertAuditLog(updaterId, "UPDATE_USER", "User", dto.getUserId(), oldValues, newValues);
    }

    /**
     * Khóa hoặc mở khóa tài khoản nhanh.
     */
    public void toggleUserStatus(int userId, String status, String lockReason, int actorId) throws Exception {
        User user = userDAO.findByUserId(userId);
        if (user == null) {
            throw new Exception("Tài khoản không tồn tại.");
        }

        if ("ADMIN".equalsIgnoreCase(user.getRole()) && actorId != user.getUserId()) {
            throw new Exception("Bạn không có quyền thay đổi trạng thái của Quản trị viên khác.");
        }

        if ("active".equals(status)) {
            lockReason = null;
        } else {
            if (lockReason == null || lockReason.trim().isEmpty()) {
                throw new Exception("Vui lòng nhập lý do khóa tài khoản.");
            }
            lockReason = lockReason.trim();
            if (lockReason.length() > 50) {
                lockReason = lockReason.substring(0, 50);
            }
        }

        boolean success = userDAO.updateUserStatus(userId, status, lockReason);
        if (!success) {
            throw new Exception("Lỗi hệ thống khi cập nhật trạng thái tài khoản.");
        }

        // Ghi Audit Log (BR-14)
        String actionType = "active".equals(status) ? "UNLOCK_USER" : "LOCK_USER";
        String oldValues = "{\"status\":\"" + user.getStatus() + "\"}";
        String newValues = "{\"status\":\"" + status + "\",\"lockReason\":\"" + lockReason + "\"}";
        userDAO.insertAuditLog(actorId, actionType, "User", userId, oldValues, newValues);
    }

    // =========================================================================
    // IMPORT USERS — PHASE 1 (VALIDATE) + PHASE 2 (DB TRANSACTION)
    // =========================================================================

    /**
     * Phase 1 — Validate dữ liệu import trên RAM trước khi cho phép xác nhận.
     *
     * <p>Kiểm tra:</p>
     * <ul>
     *   <li>Email: Không trống, đúng định dạng, không trùng trong file, không trùng trong DB</li>
     *   <li>Họ tên: Không trống</li>
     *   <li>Mã số: Không trống, không trùng trong file, không trùng trong DB</li>
     *   <li>Ngày sinh: Không trống</li>
     *   <li>Giới tính: Nếu có, phải là Nam/Nữ/Khác</li>
     *   <li>Số điện thoại: Nếu có, phải đúng 10 chữ số</li>
     * </ul>
     *
     * @param users Danh sách UserDTO đã được parse từ Excel
     * @param role  Vai trò chung áp dụng cho đợt import
     * @return Danh sách lỗi (rỗng = tất cả hợp lệ)
     */
    public List<String> validateImportData(List<UserDTO> users, String role) {
        List<String> errors = new ArrayList<>();
        Set<String> emailsInFile = new HashSet<>();
        Set<String> codesInFile = new HashSet<>();
        String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";

        for (int i = 0; i < users.size(); i++) {
            UserDTO u = users.get(i);
            int rowNum = i + 2; // Header là dòng 1, data bắt đầu từ dòng 2

            // 1. Validate Email
            if (u.getEmail() == null || u.getEmail().trim().isEmpty()) {
                errors.add("Dòng " + rowNum + ": Email không được để trống.");
            } else {
                String email = u.getEmail().trim().toLowerCase();
                if (!email.matches(emailPattern)) {
                    errors.add("Dòng " + rowNum + ": Email '" + u.getEmail() + "' sai định dạng.");
                } else if (emailsInFile.contains(email)) {
                    errors.add("Dòng " + rowNum + ": Email '" + u.getEmail() + "' bị trùng lặp trong file tải lên.");
                } else {
                    emailsInFile.add(email);
                    if (userDAO.existsByEmail(email, null)) {
                        errors.add("Dòng " + rowNum + ": Email '" + u.getEmail() + "' đã tồn tại trong hệ thống.");
                    }
                }
            }

            // 2. Validate Họ và tên
            if (u.getFullName() == null || u.getFullName().trim().isEmpty()) {
                errors.add("Dòng " + rowNum + ": Họ và tên không được để trống.");
            }

            // 3. Validate Mã số định danh
            if (u.getCode() == null || u.getCode().trim().isEmpty()) {
                errors.add("Dòng " + rowNum + ": Mã số định danh không được để trống.");
            } else {
                String code = u.getCode().trim().toUpperCase();
                if (codesInFile.contains(code)) {
                    errors.add("Dòng " + rowNum + ": Mã số '" + u.getCode() + "' bị trùng lặp trong file tải lên.");
                } else {
                    codesInFile.add(code);
                    if (userDAO.existsByCode(code, role, null)) {
                        errors.add("Dòng " + rowNum + ": Mã số '" + u.getCode() + "' đã tồn tại trong hệ thống.");
                    }
                }
            }

            // 4. Validate Ngày sinh
            if (u.getDateOfBirth() == null) {
                errors.add("Dòng " + rowNum + ": Ngày sinh trống hoặc sai định dạng (yêu cầu yyyy-MM-dd).");
            }

            // 5. Validate Giới tính
            if (u.getGender() != null && !u.getGender().trim().isEmpty()) {
                String g = u.getGender().trim();
                if (!"Nam".equalsIgnoreCase(g) && !"Nữ".equalsIgnoreCase(g) && !"Khác".equalsIgnoreCase(g)) {
                    errors.add("Dòng " + rowNum + ": Giới tính '" + u.getGender() + "' không hợp lệ (chỉ chấp nhận: Nam, Nữ, Khác).");
                }
            }

            // 6. Validate Số điện thoại (nhất quán với validateUserDTO cho Create/Update)
            if (u.getPhoneNumber() != null && !u.getPhoneNumber().trim().isEmpty()) {
                String phone = u.getPhoneNumber().trim();
                if (!phone.matches("^[0-9]{10}$")) {
                    errors.add("Dòng " + rowNum + ": Số điện thoại '" + phone + "' không hợp lệ (yêu cầu đúng 10 chữ số).");
                }
            }
        }

        return errors;
    }

    /**
     * Phase 2 — Thực thi import hàng loạt vào CSDL trong một Transaction duy nhất (All-or-Nothing).
     *
     * <p>Method này CHỈ xử lý:</p>
     * <ul>
     *   <li>Hash BCrypt mật khẩu mặc định (= email) cho mỗi user</li>
     *   <li>Gọi DAO batch insert trong 1 DB Transaction (bao gồm cả AuditLog)</li>
     * </ul>
     *
     * <p>Validate phải được gọi trước qua {@link #validateImportData(List, String)}
     * và đảm bảo errors rỗng trước khi gọi method này.</p>
     *
     * @param users   Danh sách UserDTO đã validate thành công ở Phase 1
     * @param role    Vai trò chung
     * @param actorId ID Admin thực hiện import
     * @throws Exception Khi xảy ra lỗi hệ thống (ẩn stack trace theo FR-21)
     */
    public void importUsers(List<UserDTO> users, String role, int actorId) throws Exception {
        if (users == null || users.isEmpty()) {
            throw new Exception("Danh sách import rỗng hoặc không hợp lệ.");
        }

        role = role.trim().toUpperCase();

        // Hash BCrypt mật khẩu mặc định (= email) cho mỗi user
        for (UserDTO u : users) {
            String rawPw = u.getEmail().trim();
            u.setPasswordHash(BCrypt.hashpw(rawPw, BCrypt.gensalt(10)));
        }

        // Gọi DAO batch insert — AuditLog nằm BÊN TRONG cùng Transaction
        try {
            boolean success = userDAO.importUsersBatch(users, role, actorId);
            if (!success) {
                throw new Exception("Lỗi hệ thống trong quá trình thực thi ghi CSDL.");
            }
        } catch (SQLException e) {
            // Ném lỗi chung không để lộ chi tiết stack trace (FR-21)
            throw new Exception("Lỗi hệ thống: Không thể hoàn tất lưu trữ hàng loạt vào Cơ sở dữ liệu.");
        }
    }

    /**
     * Validate dữ liệu UserDTO cho thao tác Tạo mới hoặc Cập nhật đơn lẻ.
     */
    private void validateUserDTO(UserDTO dto, boolean isCreate) throws Exception {
        // 1. Kiểm tra Email
        if (dto.getEmail() == null || dto.getEmail().trim().isEmpty()) {
            throw new Exception("Email không được để trống.");
        }
        String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";
        if (!dto.getEmail().trim().matches(emailPattern)) {
            throw new Exception("Địa chỉ Email không đúng định dạng.");
        }
        if (userDAO.existsByEmail(dto.getEmail().trim(), isCreate ? null : dto.getUserId())) {
            throw new Exception("Địa chỉ Email này đã được sử dụng bởi tài khoản khác.");
        }

        // 2. Kiểm tra Họ và tên
        if (dto.getFullName() == null || dto.getFullName().trim().isEmpty()) {
            throw new Exception("Họ và tên không được để trống.");
        }

        // Kiểm tra Số điện thoại (phải đủ 10 số, không chứa chữ)
        if (dto.getPhoneNumber() == null || dto.getPhoneNumber().trim().isEmpty()) {
            throw new Exception("Số điện thoại không được để trống.");
        }
        String phone = dto.getPhoneNumber().trim();
        if (!phone.matches("^[0-9]{10}$")) {
            throw new Exception("Số điện thoại phải bao gồm đúng 10 chữ số và không chứa ký tự chữ.");
        }

        // 3. Kiểm tra Mã số định danh
        if (dto.getCode() == null || dto.getCode().trim().isEmpty()) {
            throw new Exception("Mã số định danh không được để trống.");
        }
        
        String role = isCreate ? dto.getRole() : oldRoleFromDB(dto.getUserId());
        if (userDAO.existsByCode(dto.getCode().trim(), role, isCreate ? null : dto.getUserId())) {
            throw new Exception("Mã định danh (" + dto.getCode() + ") đã được đăng ký trên hệ thống.");
        }

        // 4. Kiểm tra Ngày sinh
        if (dto.getDateOfBirth() == null) {
            throw new Exception("Ngày sinh không hợp lệ hoặc để trống.");
        }

        // 5. Kiểm tra vai trò (khi tạo mới)
        if (isCreate) {
            if (dto.getRole() == null || dto.getRole().trim().isEmpty()) {
                throw new Exception("Vui lòng lựa chọn vai trò cho tài khoản.");
            }
            String r = dto.getRole().toUpperCase();
            if (!"ADMIN".equals(r) && !"LIBRARIAN".equals(r) && !"STUDENT".equals(r) && !"LECTURER".equals(r)) {
                throw new Exception("Vai trò người dùng không hợp lệ.");
            }
        }
    }

    private String oldRoleFromDB(int userId) {
        User u = userDAO.findByUserId(userId);
        return u != null ? u.getRole() : "";
    }
}
