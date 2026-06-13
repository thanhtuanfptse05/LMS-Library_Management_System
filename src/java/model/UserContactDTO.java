package model;

/**
 * UserContactDTO ΓÇö Data Transfer Object d├╣ng ─æß╗â gß╗¡i Email h├áng loß║ít.
 *
 * <p>Chß╗⌐a th├┤ng tin li├¬n lß║íc tß╗æi thiß╗âu cß║ºn thiß║┐t cho viß╗çc gß╗¡i Email:
 * ─æß╗ïa chß╗ë email v├á t├¬n hiß╗ân thß╗ï cß╗ºa ng╞░ß╗¥i nhß║¡n.</p>
 *
 * <p>Tu├ón thß╗º: ARCH-01 (Java Bean thuß║ºn, kh├┤ng ORM).</p>
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
