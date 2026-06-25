package service;

import dao.UserDAO;
import dao.UserLockReasonDAO;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

/**
 * AuthService — Lớp xử lý toàn bộ logic nghiệp vụ xác thực (Business Logic).
 *
 * <p>Tuân thủ nghiêm ngặt:</p>
 * <ul>
 *   <li>Không chứa bất kỳ câu lệnh SQL hay JDBC nào.</li>
 *   <li>Mọi tương tác CSDL đều gọi qua UserDAO.</li>
 *   <li>Sử dụng BCrypt để bảo mật thông tin mật khẩu.</li>
 * </ul>
 */
public class AuthService {

    private final UserDAO userDAO;
    private final UserLockReasonDAO userLockReasonDAO;

    public AuthService() {
        this.userDAO = new UserDAO();
        this.userLockReasonDAO = new UserLockReasonDAO();
    }

    // Constructor phục vụ mục đích Testing (Dependency Injection)
    AuthService(UserDAO userDAO) {
        this.userDAO = userDAO;
        this.userLockReasonDAO = new UserLockReasonDAO();
    }

    /**
     * Xác thực mật khẩu nhập vào có trùng khớp với BCrypt hash trong DB hay không.
     *
     * @param plainPassword Mật khẩu chưa mã hóa (người dùng nhập)
     * @param storedHash   Chuỗi BCrypt hash lấy từ Database
     * @return {@code true} nếu khớp, ngược lại {@code false}
     */
    public boolean verifyPassword(String plainPassword, String storedHash) {
        if (storedHash == null || !storedHash.startsWith("$2a$")) {
            return false;
        }
        return BCrypt.checkpw(plainPassword, storedHash);
    }

    /**
     * Kiểm tra xem tài khoản có đang bị khóa tạm thời hay không.
     *
     * @param user Đối tượng người dùng cần kiểm tra
     * @return {@code true} nếu tài khoản đang bị khóa, ngược lại {@code false}
     */
    public boolean isAccountLocked(User user) {
        if (user == null || !"locked".equals(user.getStatus())) {
            return false;
        }
        java.sql.Timestamp lockedUntil = user.getLockedUntil();
        if (lockedUntil == null) {
            return true; // Khóa bởi Admin (vĩnh viễn / cho đến khi được mở)
        }
        java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
        return lockedUntil.after(now);
    }

    /**
     * Kiểm tra xem tài khoản bị khóa có CHỈ do lý do 'unpaid' hay không.
     *
     * <p>Nếu đúng, hệ thống cho phép người dùng đăng nhập nhưng sẽ hiển thị
     * cảnh báo yêu cầu thanh toán tiền phạt.</p>
     *
     * @param userId ID của người dùng cần kiểm tra
     * @return {@code true} nếu tài khoản bị khóa CHỈ vì lý do 'unpaid',
     *         ngược lại {@code false}
     */
    public boolean isLockedOnlyForUnpaid(int userId) {
        boolean hasUnpaid = userLockReasonDAO.hasReason(userId, "unpaid");
        if (!hasUnpaid) {
            return false;
        }
        // Kiểm tra xem có lý do khóa nào khác ngoài 'unpaid' không
        return !hasNonUnpaidLockReason(userId);
    }

    /**
     * Kiểm tra xem tài khoản có bất kỳ lý do khóa nào KHÁC 'unpaid' không.
     * (ví dụ: 'securitybreach', 'adminban')
     *
     * @param userId ID của người dùng cần kiểm tra
     * @return {@code true} nếu tồn tại ít nhất một lý do khóa khác 'unpaid'
     */
    public boolean hasNonUnpaidLockReason(int userId) {
        return userLockReasonDAO.hasReason(userId, "securitybreach")
                || userLockReasonDAO.hasReason(userId, "adminban");
    }

    /**
     * Xử lý khi đăng nhập thất bại.
     * Tăng số lần đăng nhập sai của người dùng. Nếu số lần đăng nhập sai đạt mốc 5,
     * thực hiện khóa tài khoản tạm thời 30 phút.
     *
     * @param user Đối tượng người dùng thực hiện đăng nhập
     * @return Số lần đăng nhập sai mới của người dùng
     */
    public int handleFailedLogin(User user) {
        if (user == null) {
            return 0;
        }
        int newAttempts = user.getFailedLoginAttempts() + 1;
        if (newAttempts >= 5) {
            userDAO.lockAccount(user.getUserId());
            user.setStatus("locked");
            user.setFailedLoginAttempts(0);
            return 5;
        } else {
            userDAO.updateFailedAttempts(user.getUserId(), newAttempts);
            user.setFailedLoginAttempts(newAttempts);
            return newAttempts;
        }
    }

    /**
     * Sinh mật khẩu mới ngẫu nhiên gồm đúng 8 ký tự (chữ cái và số).
     *
     * @return Chuỗi mật khẩu ngẫu nhiên
     */
    public String generateRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 8; i++) {
            int index = (int) (Math.random() * chars.length());
            sb.append(chars.charAt(index));
        }
        return sb.toString();
    }

    /**
     * Khôi phục mật khẩu tài khoản.
     * Sinh mật khẩu mới -> Mã hóa BCrypt -> Cập nhật CSDL -> Trả về mật khẩu thô để gửi qua Email.
     *
     * @param email Địa chỉ email của tài khoản cần reset
     * @return Mật khẩu mới dạng chưa mã hóa (plaintext) hoặc {@code null} nếu email không tồn tại
     */
    public String resetPassword(String email) {
        User user = userDAO.findByEmail(email);
        if (user == null) {
            return null;
        }
        String rawPassword = generateRandomPassword();
        String hashedPassword = BCrypt.hashpw(rawPassword, BCrypt.gensalt(10));
        userDAO.updatePasswordHash(user.getUserId(), hashedPassword);
        return rawPassword;
    }

    /**
     * Thực hiện kiểm thử BCrypt giả lập nhằm chống tấn công Timing Attack.
     * Hàm này luôn mất khoảng thời gian tương đương như verify mật khẩu thật.
     */
    public void runDummyVerify() {
        BCrypt.checkpw("dummy_password", "$2a$10$dummyhashxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    }
}
