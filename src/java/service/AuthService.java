package service;

import dao.UserDAO;
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

    private final UserDAO userDAO = new UserDAO();

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
            return false;
        }
        java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
        return lockedUntil.after(now);
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
}
