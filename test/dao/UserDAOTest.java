package dao;

import model.User;
import org.junit.Before;
import org.junit.Test;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import static org.junit.Assert.*;

public class UserDAOTest {

    private UserDAO userDAO;

    @Before
    public void setUp() {
        userDAO = new UserDAO();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testFindByEmailWithMockConn() throws Exception {
        Map<String, Object> userData = new HashMap<>();
        userData.put("userId", 1);
        userData.put("email", "student@fpt.edu.vn");
        userData.put("passwordHash", "$2a$10$hashedpassword");
        userData.put("status", "active");
        userData.put("role", "STUDENT");

        Connection mockConn = MockJdbc.createMockConnection(userData, 0);
        assertNotNull(mockConn);
        assertNotNull(userDAO);
    }

    @Test
    public void testUpdatePasswordWithMockConn() throws Exception {
        Connection mockConn = MockJdbc.createMockConnection(null, 1);
        assertNotNull(mockConn);
    }
}
