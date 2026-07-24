package dto;

/**
 * UserContactDTO — Data Transfer Object dùng để gửi Email hàng loạt.
 *
 * <p>Chứa thông tin liên lạc tối thiểu cần thiết cho việc gửi Email:
 * địa chỉ email và tên hiển thị của người nhận.</p>

 * <p>Tuân thủ: ARCH-01 (Java Bean thuần, không ORM).</p>
 */
public class UserContactDTO {

    private String email;
    private String fullName;

    public UserContactDTO() {
    }

    public UserContactDTO(String email, String fullName) {
        this.email = email;
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
}
