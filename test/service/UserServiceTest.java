package service;

import dto.UserDTO;
import org.junit.Before;
import org.junit.Test;
import java.util.ArrayList;
import java.util.List;
import static org.junit.Assert.*;

public class UserServiceTest {

    private UserService userService;

    @Before
    public void setUp() {
        userService = new UserService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testUserServiceInstantiation() {
        assertNotNull("UserService instance được khởi tạo thành công", userService);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test(expected = Exception.class)
    public void testImportUsersEmptyList() throws Exception {
        // Danh sách import rỗng (0 phần tử) phải ném Exception
        userService.importUsers(new ArrayList<>(), "STUDENT", 1);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = Exception.class)
    public void testImportUsersNullList() throws Exception {
        // Danh sách import null phải ném Exception
        userService.importUsers(null, "STUDENT", 1);
    }
}
