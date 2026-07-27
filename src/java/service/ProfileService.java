package service;

import dao.MemberProfileDAO;
import dao.UserDAO;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import model.MemberProfile;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

/**
 * ProfileService — Lớp xử lý nghiệp vụ liên quan đến quản lý hồ sơ và đổi mật khẩu.
 */
public class ProfileService {

    private final MemberProfileDAO memberProfileDAO;
    private final UserDAO userDAO;

    public ProfileService() {
        this.memberProfileDAO = new MemberProfileDAO();
        this.userDAO = new UserDAO();
    }

    public ProfileService(MemberProfileDAO memberProfileDAO, UserDAO userDAO) {
        this.memberProfileDAO = memberProfileDAO;
        this.userDAO = userDAO;
    }

    /**
     * Cập nhật thông tin cá nhân.
     */
    public void updateUserInfo(int userId, String fullName, String phoneNumber, String gender, String dateOfBirthStr) throws Exception {
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new Exception("Họ và tên không được để trống.");
        }

        Date dateOfBirth = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                sdf.setLenient(false);
                java.util.Date parsed = sdf.parse(dateOfBirthStr.trim());
                dateOfBirth = new Date(parsed.getTime());
            } catch (ParseException e) {
                throw new Exception("Ngày sinh không đúng định dạng YYYY-MM-DD.");
            }
        }

        MemberProfile profile = memberProfileDAO.findByUserId(userId);
        if (profile == null) {
            profile = new MemberProfile();
            profile.setUserId(userId);
            profile.setStartDate(new Date(System.currentTimeMillis()));
            profile.setEndDate(new Date(System.currentTimeMillis() + 31536000000L)); // 1 year
        }

        profile.setFullName(fullName.trim());
        profile.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : null);
        profile.setGender(gender != null ? gender.trim() : null);
        profile.setDateOfBirth(dateOfBirth);

        boolean success = memberProfileDAO.updateProfile(profile);
        if (!success) {
            throw new Exception("Lỗi hệ thống khi cập nhật thông tin cá nhân.");
        }
    }

    /**
     * Đổi mật khẩu.
     */
    public void changePassword(int userId, String currentPw, String newPw, String confirmPw) throws Exception {
        if (currentPw == null || currentPw.isEmpty() || newPw == null || newPw.isEmpty() || confirmPw == null || confirmPw.isEmpty()) {
            throw new Exception("Vui lòng điền đầy đủ tất cả các trường mật khẩu.");
        }

        if (!newPw.equals(confirmPw)) {
            throw new Exception("Xác nhận mật khẩu mới không khớp.");
        }

        // Chính sách mật khẩu: tối thiểu 8 ký tự, bao gồm ít nhất 1 chữ hoa, 1 chữ thường, 1 chữ số, 1 ký tự đặc biệt
        String pwPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&._\\-,#^()])[A-Za-z\\d@$!%*?&._\\-,#^()]{8,}$";
        if (!newPw.matches(pwPattern)) {
            throw new Exception("Mật khẩu mới phải từ 8 ký tự trở lên, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt (@$!%*?&._-).");
        }

        User user = userDAO.findByUserId(userId);
        if (user == null) {
            throw new Exception("Tài khoản không tồn tại.");
        }

        if (!BCrypt.checkpw(currentPw, user.getPasswordHash())) {
            throw new Exception("Mật khẩu hiện tại không chính xác.");
        }

        String hashedNewPw = BCrypt.hashpw(newPw, BCrypt.gensalt(10));
        userDAO.updatePasswordHash(userId, hashedNewPw);

        // Ghi Audit Log hành động đổi mật khẩu
        userDAO.insertAuditLog(userId, "CHANGE_PASSWORD", "User", userId, "{}", "{}");
    }
}
