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
}
