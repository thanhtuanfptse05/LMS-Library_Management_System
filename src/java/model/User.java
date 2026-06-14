package model;

import java.sql.Timestamp;

/**
 * User — Entity bean ánh xạ 1-1 với bảng [User] trong CSDL.
 *
 * <p>Schema mapping (SPEC §5 — Data Model):</p>
 * <ul>
 *   <li>{@code userId}             — INT IDENTITY(1,1) PRIMARY KEY</li>
 *   <li>{@code email}              — NVARCHAR(255) NOT NULL UNIQUE</li>
 *   <li>{@code passwordHash}       — NVARCHAR(255) NOT NULL (BCrypt hash)</li>
 *   <li>{@code status}             — NVARCHAR(50) DEFAULT 'active' ('active' | 'locked')</li>
 *   <li>{@code role}               — NVARCHAR(50) NOT NULL ('ADMIN' | 'LIBRARIAN' | 'MANAGER' | 'STUDENT')</li>
 *   <li>{@code lockReason}         — NVARCHAR(50) NULL ('unpaid' | 'adminban' | 'securitybreach')</li>
 *   <li>{@code failedLoginAttempts} — INT DEFAULT 0</li>
 *   <li>{@code lockedUntil}        — DATETIME NULL</li>
 * </ul>
 *
 * <p>Tuân thủ: ARCH-01 (Java Bean thuần, không ORM annotation),
 * ENG-02 (PascalCase class name, camelCase fields matching DB columns).</p>
 */
public class User {

    private int userId;
    private String email;
    private String passwordHash;
    private String status;
    private String role;
    private int failedLoginAttempts;
    private Timestamp lockedUntil;

    /**
     * Constructor không tham số — yêu cầu bởi Java Bean convention.
     */
    public User() {
    }

    /**
     * Constructor đầy đủ tham số cho trường hợp khởi tạo nhanh từ ResultSet.
     *
     * @param userId              ID tự tăng của tài khoản
     * @param email               Địa chỉ email định danh tài khoản
     * @param passwordHash        Mật khẩu đã mã hóa BCrypt
     * @param status              Trạng thái tài khoản ('active' hoặc 'locked')
     * @param role                Vai trò phân quyền
     */
    public User(int userId, String email, String passwordHash, String status,
                String role, int failedLoginAttempts,
                Timestamp lockedUntil) {
        this.userId = userId;
        this.email = email;
        this.passwordHash = passwordHash;
        this.status = status;
        this.role = role;
        this.failedLoginAttempts = failedLoginAttempts;
        this.lockedUntil = lockedUntil;
    }

    // ========================
    // GETTERS & SETTERS
    // ========================

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public int getFailedLoginAttempts() {
        return failedLoginAttempts;
    }

    public void setFailedLoginAttempts(int failedLoginAttempts) {
        this.failedLoginAttempts = failedLoginAttempts;
    }

    public Timestamp getLockedUntil() {
        return lockedUntil;
    }

    public void setLockedUntil(Timestamp lockedUntil) {
        this.lockedUntil = lockedUntil;
    }
}
