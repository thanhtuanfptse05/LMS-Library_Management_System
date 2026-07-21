package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.MemberProfile;
import model.User;
import org.junit.Test;
import static org.junit.Assert.*;
import org.mindrot.jbcrypt.BCrypt;
import util.DatabaseConnection;

public class UserDAOTest {

    @Test
    public void testCreateUserWithProfile_Success() throws Exception {
        UserDAO userDAO = new UserDAO();
        User user = new User();
        String suffix = String.valueOf(System.nanoTime()).substring(8);
        user.setEmail("test_" + suffix + "@uni.edu.vn");
        user.setPasswordHash(BCrypt.hashpw("password123", BCrypt.gensalt()));
        user.setStatus("active");
        user.setRole("STUDENT");

        MemberProfile profile = new MemberProfile();
        profile.setFullName("Nguyễn Văn Test");
        profile.setPhoneNumber("0912345" + suffix.substring(0, 3));
        profile.setGender("Nam");
        profile.setDateOfBirth(Date.valueOf("2000-01-01"));

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                boolean result = userDAO.createUserWithProfile(user, profile, "HE" + suffix, "SE", 2023, null);
                assertTrue("Tạo user phải thành công", result);
                assertTrue("User ID phải được sinh ra", user.getUserId() > 0);

                // Verify DB
                try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM \"User\" WHERE userId = ?")) {
                    ps.setInt(1, user.getUserId());
                    try (ResultSet rs = ps.executeQuery()) {
                        assertTrue(rs.next());
                        assertEquals(user.getEmail(), rs.getString("email"));
                    }
                }
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    @Test
    public void testCreateUserWithProfile_DuplicateEmail() throws Exception {
        UserDAO userDAO = new UserDAO();
        
        // Cần đảm bảo có ít nhất 1 email tồn tại, ta tạo 1 email ngẫu nhiên nhưng insert 2 lần.
        String suffix = String.valueOf(System.nanoTime()).substring(8);
        String email = "dup_" + suffix + "@uni.edu.vn";

        User user1 = new User();
        user1.setEmail(email);
        user1.setPasswordHash("hash1");
        user1.setRole("STUDENT");

        MemberProfile profile1 = new MemberProfile();
        profile1.setFullName("User 1");
        profile1.setPhoneNumber("0912345678");
        profile1.setGender("Nam");
        profile1.setDateOfBirth(Date.valueOf("2000-01-01"));
        
        User user2 = new User();
        user2.setEmail(email);
        user2.setPasswordHash("hash2");
        user2.setRole("STUDENT");

        MemberProfile profile2 = new MemberProfile();
        profile2.setFullName("User 2");
        profile2.setPhoneNumber("0912345679");
        profile2.setGender("Nữ");
        profile2.setDateOfBirth(Date.valueOf("2001-01-01"));

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Insert lần 1 thành công
                userDAO.createUserWithProfile(user1, profile1, "HE" + suffix, "SE", 2023, null);
                
                // Insert lần 2 phải quăng SQLException vì trùng email (UNIQUE)
                try {
                    userDAO.createUserWithProfile(user2, profile2, "HE99" + suffix, "SE", 2023, null);
                    fail("Phải văng exception khi insert trùng email");
                } catch (SQLException e) {
                    assertNotNull(e);
                }
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    @Test
    public void testUpdateUserStatus_Success() throws Exception {
        UserDAO userDAO = new UserDAO();
        String suffix = String.valueOf(System.nanoTime()).substring(8);
        
        User user = new User();
        user.setEmail("lock_" + suffix + "@uni.edu.vn");
        user.setPasswordHash("hash");
        user.setStatus("active");
        user.setRole("STUDENT");
        
        MemberProfile profile = new MemberProfile();
        profile.setFullName("Test Lock");
        profile.setPhoneNumber("0912345680");
        profile.setGender("Nam");
        profile.setDateOfBirth(Date.valueOf("2002-01-01"));

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Tạo user
                userDAO.createUserWithProfile(user, profile, "HE" + suffix, "SE", 2023, null);
                int userId = user.getUserId();
                
                // 2. Cập nhật status
                boolean updateResult = userDAO.updateUserStatus(userId, "locked", "Vi phạm nội quy");
                assertTrue("Cập nhật status phải trả về true", updateResult);
                
                // 3. Verify status
                User dbUser = userDAO.findByUserId(userId);
                assertNotNull(dbUser);
                assertEquals("locked", dbUser.getStatus());
                
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    @Test
    public void testExistsByEmail() throws Exception {
        UserDAO userDAO = new UserDAO();
        String suffix = String.valueOf(System.nanoTime()).substring(8);
        String email = "exists_" + suffix + "@uni.edu.vn";
        
        User user = new User();
        user.setEmail(email);
        user.setPasswordHash("hash");
        user.setRole("STUDENT");
        MemberProfile profile = new MemberProfile();
        profile.setFullName("Test Exists");
        profile.setPhoneNumber("0912345681");
        profile.setGender("Nữ");
        profile.setDateOfBirth(Date.valueOf("2003-01-01"));

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Chưa tạo -> false
                assertFalse(userDAO.existsByEmail(email, null));
                
                // Tạo user
                userDAO.createUserWithProfile(user, profile, "HE" + suffix, "SE", 2023, null);
                
                // Đã tạo -> true
                assertTrue(userDAO.existsByEmail(email, null));
                
                // Check excludeUserId -> false (vì trùng với chính nó)
                assertFalse(userDAO.existsByEmail(email, user.getUserId()));
                
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }
}
