package service;

import dao.UserDAO;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.MemberProfile;
import model.User;
import model.UserDTO;
import org.junit.Before;
import org.junit.Test;
import org.mindrot.jbcrypt.BCrypt;
import static org.junit.Assert.*;

/**
 * UserServiceTest — Unit Tests cho UserService sử dụng JUnit 4.
 */
public class UserServiceTest {

    private UserService userService;
    private MockUserDAO mockUserDAO;

    @Before
    public void setUp() {
        mockUserDAO = new MockUserDAO();
        userService = new UserService(mockUserDAO);
    }

    /**
     * Test tạo tài khoản thành công (Happy Path).
     */
    @Test
    public void testCreateUserSuccess() throws Exception {
        UserDTO dto = new UserDTO();
        dto.setEmail("student1@uni.edu.vn");
        dto.setFullName("Nguyễn Văn A");
        dto.setPhoneNumber("0912345678");
        dto.setGender("Nam");
        dto.setDateOfBirth(Date.valueOf("2005-10-15"));
        dto.setRole("STUDENT");
        dto.setCode("HE170001");
        dto.setMajor("Kỹ thuật phần mềm");
        dto.setEnrollmentYear(2023);

        userService.createUser(dto, 99); // creatorId = 99

        assertTrue("Hàm insert trong CSDL phải được gọi", mockUserDAO.createUserCalled);
        assertNotNull("Mật khẩu mặc định băm BCrypt phải được lưu", mockUserDAO.createdUser.getPasswordHash());
        assertTrue("Mật khẩu băm phải khớp với email", BCrypt.checkpw("student1@uni.edu.vn", mockUserDAO.createdUser.getPasswordHash()));
        assertTrue("Hành động Audit Log phải được ghi", mockUserDAO.auditLogCalled);
        assertEquals("Hành động ghi Audit phải là CREATE_USER", "CREATE_USER", mockUserDAO.auditAction);
    }

    /**
     * Test tạo tài khoản thất bại khi thiếu email.
     */
    @Test
    public void testCreateUserMissingEmail() {
        UserDTO dto = new UserDTO();
        dto.setEmail("");
        dto.setFullName("Nguyễn Văn A");
        dto.setPhoneNumber("0912345678");
        dto.setDateOfBirth(Date.valueOf("2005-10-15"));
        dto.setRole("STUDENT");
        dto.setCode("HE170001");

        try {
            userService.createUser(dto, 99);
            fail("Phải ném Exception khi Email rỗng");
        } catch (Exception e) {
            assertEquals("Email không được để trống.", e.getMessage());
            assertFalse("Không được gọi hàm ghi CSDL", mockUserDAO.createUserCalled);
        }
    }

    /**
     * Test tạo tài khoản thất bại khi trùng Email đã tồn tại.
     */
    @Test
    public void testCreateUserDuplicateEmail() {
        UserDTO dto = new UserDTO();
        dto.setEmail("duplicate@uni.edu.vn");
        dto.setFullName("Nguyễn Văn A");
        dto.setPhoneNumber("0912345678");
        dto.setDateOfBirth(Date.valueOf("2005-10-15"));
        dto.setRole("STUDENT");
        dto.setCode("HE170001");

        mockUserDAO.existingEmail = "duplicate@uni.edu.vn";

        try {
            userService.createUser(dto, 99);
            fail("Phải ném Exception khi trùng Email");
        } catch (Exception e) {
            assertEquals("Địa chỉ Email này đã được sử dụng bởi tài khoản khác.", e.getMessage());
            assertFalse("Không được gọi hàm ghi CSDL", mockUserDAO.createUserCalled);
        }
    }

    /**
     * Test tạo tài khoản thất bại khi trùng mã số định danh (studentCode).
     */
    @Test
    public void testCreateUserDuplicateCode() {
        UserDTO dto = new UserDTO();
        dto.setEmail("student2@uni.edu.vn");
        dto.setFullName("Nguyễn Văn A");
        dto.setPhoneNumber("0912345678");
        dto.setDateOfBirth(Date.valueOf("2005-10-15"));
        dto.setRole("STUDENT");
        dto.setCode("HE179999"); // Mã số bị trùng

        mockUserDAO.existingCode = "HE179999";
        mockUserDAO.existingCodeRole = "STUDENT";

        try {
            userService.createUser(dto, 99);
            fail("Phải ném Exception khi trùng Mã định danh");
        } catch (Exception e) {
            assertEquals("Mã định danh (HE179999) đã được đăng ký trên hệ thống.", e.getMessage());
            assertFalse("Không được gọi hàm ghi CSDL", mockUserDAO.createUserCalled);
        }
    }

    /**
     * Test tạo tài khoản thất bại khi thiếu số điện thoại.
     */
    @Test
    public void testCreateUserMissingPhone() {
        UserDTO dto = new UserDTO();
        dto.setEmail("student3@uni.edu.vn");
        dto.setFullName("Nguyễn Văn A");
        dto.setPhoneNumber(""); // Số điện thoại trống
        dto.setDateOfBirth(Date.valueOf("2005-10-15"));
        dto.setRole("STUDENT");
        dto.setCode("HE170003");

        try {
            userService.createUser(dto, 99);
            fail("Phải ném Exception khi thiếu số điện thoại");
        } catch (Exception e) {
            assertEquals("Số điện thoại không được để trống.", e.getMessage());
            assertFalse("Không được gọi hàm ghi CSDL", mockUserDAO.createUserCalled);
        }
    }

    /**
     * Test tạo tài khoản thất bại khi số điện thoại không hợp lệ (không đủ 10 số, chứa chữ).
     */
    @Test
    public void testCreateUserInvalidPhone() {
        UserDTO dto = new UserDTO();
        dto.setEmail("student4@uni.edu.vn");
        dto.setFullName("Nguyễn Văn A");
        dto.setPhoneNumber("091234567a"); // Chứa chữ và dài 10 ký tự
        dto.setDateOfBirth(Date.valueOf("2005-10-15"));
        dto.setRole("STUDENT");
        dto.setCode("HE170004");

        try {
            userService.createUser(dto, 99);
            fail("Phải ném Exception khi số điện thoại chứa chữ");
        } catch (Exception e) {
            assertEquals("Số điện thoại phải bao gồm đúng 10 chữ số và không chứa ký tự chữ.", e.getMessage());
        }

        // Test trường hợp không đủ số (9 số)
        dto.setPhoneNumber("091234567");
        try {
            userService.createUser(dto, 99);
            fail("Phải ném Exception khi số điện thoại chỉ có 9 số");
        } catch (Exception e) {
            assertEquals("Số điện thoại phải bao gồm đúng 10 chữ số và không chứa ký tự chữ.", e.getMessage());
        }
    }

    /**
     * Test khóa tài khoản người dùng thành công.
     */
    @Test
    public void testToggleUserStatusLock() throws Exception {
        mockUserDAO.dbUser = new User(10, "test@lms.com", "hash", "active", "STUDENT", null, 0, null);

        userService.toggleUserStatus(10, "locked", "unpaid", 99);

        assertTrue("Trạng thái status phải được cập nhật ở DB", mockUserDAO.updateStatusCalled);
        assertEquals("Trạng thái mới phải là locked", "locked", mockUserDAO.newStatus);
        assertEquals("Lý do khóa phải là unpaid", "unpaid", mockUserDAO.newLockReason);
        assertTrue("Audit Log phải được ghi", mockUserDAO.auditLogCalled);
        assertEquals("Loại action trong Audit phải là LOCK_USER", "LOCK_USER", mockUserDAO.auditAction);
    }

    /**
     * Test mở khóa tài khoản người dùng thành công.
     */
    @Test
    public void testToggleUserStatusUnlock() throws Exception {
        mockUserDAO.dbUser = new User(10, "test@lms.com", "hash", "locked", "STUDENT", "adminban", 0, null);

        userService.toggleUserStatus(10, "active", null, 99);

        assertTrue("Trạng thái status phải được cập nhật ở DB", mockUserDAO.updateStatusCalled);
        assertEquals("Trạng thái mới phải là active", "active", mockUserDAO.newStatus);
        assertNull("Lý do khóa phải được xóa bỏ (null)", mockUserDAO.newLockReason);
        assertTrue("Audit Log phải được ghi", mockUserDAO.auditLogCalled);
        assertEquals("Loại action trong Audit phải là UNLOCK_USER", "UNLOCK_USER", mockUserDAO.auditAction);
    }

    /**
     * Test cập nhật tài khoản Admin bởi một Admin khác (phải thất bại).
     */
    @Test
    public void testUpdateUserAdminByAnotherAdminFailure() {
        UserDTO targetAdmin = new UserDTO();
        targetAdmin.setUserId(10);
        targetAdmin.setEmail("admin1@uni.edu.vn");
        targetAdmin.setFullName("Quản trị viên 1");
        targetAdmin.setPhoneNumber("0912345678");
        targetAdmin.setGender("Nam");
        targetAdmin.setDateOfBirth(Date.valueOf("1990-01-01"));
        targetAdmin.setRole("ADMIN");
        targetAdmin.setCode("AD0001");

        mockUserDAO.dbUserDTO = targetAdmin;

        // DTO update
        UserDTO updateDto = new UserDTO();
        updateDto.setUserId(10);
        updateDto.setEmail("admin1@uni.edu.vn");
        updateDto.setFullName("Quản trị viên 1 Edit");
        updateDto.setPhoneNumber("0912345678");
        updateDto.setGender("Nam");
        updateDto.setDateOfBirth(Date.valueOf("1990-01-01"));
        updateDto.setCode("AD0001");

        try {
            userService.updateUser(updateDto, 20); // updaterId = 20 (Khác target 10)
            fail("Phải ném Exception khi Admin sửa thông tin của Admin khác");
        } catch (Exception e) {
            assertEquals("Bạn không có quyền chỉnh sửa thông tin của Quản trị viên khác.", e.getMessage());
            assertFalse("Không được gọi cập nhật ở DB", mockUserDAO.updateUserCalled);
        }
    }

    /**
     * Test cập nhật tài khoản Admin bởi chính mình (phải thành công).
     */
    @Test
    public void testUpdateUserAdminBySelfSuccess() throws Exception {
        UserDTO targetAdmin = new UserDTO();
        targetAdmin.setUserId(10);
        targetAdmin.setEmail("admin1@uni.edu.vn");
        targetAdmin.setFullName("Quản trị viên 1");
        targetAdmin.setPhoneNumber("0912345678");
        targetAdmin.setGender("Nam");
        targetAdmin.setDateOfBirth(Date.valueOf("1990-01-01"));
        targetAdmin.setRole("ADMIN");
        targetAdmin.setCode("AD0001");

        mockUserDAO.dbUserDTO = targetAdmin;

        // DTO update
        UserDTO updateDto = new UserDTO();
        updateDto.setUserId(10);
        updateDto.setEmail("admin1@uni.edu.vn");
        updateDto.setFullName("Quản trị viên 1 Edit");
        updateDto.setPhoneNumber("0912345678");
        updateDto.setGender("Nam");
        updateDto.setDateOfBirth(Date.valueOf("1990-01-01"));
        updateDto.setCode("AD0001");

        userService.updateUser(updateDto, 10); // updaterId = 10 (Chính mình)
        assertTrue("Hàm cập nhật phải được gọi", mockUserDAO.updateUserCalled);
    }

    /**
     * Test khóa tài khoản Admin bởi Admin khác (phải thất bại).
     */
    @Test
    public void testToggleUserStatusAdminByAnotherAdminFailure() {
        mockUserDAO.dbUser = new User(10, "admin1@uni.edu.vn", "hash", "active", "ADMIN", null, 0, null);

        try {
            userService.toggleUserStatus(10, "locked", "adminban", 20); // actorId = 20 (khác 10)
            fail("Phải ném Exception khi Admin khóa Admin khác");
        } catch (Exception e) {
            assertEquals("Bạn không có quyền thay đổi trạng thái của Quản trị viên khác.", e.getMessage());
            assertFalse("Không được cập nhật DB", mockUserDAO.updateStatusCalled);
        }
    }

    /**
     * Test khóa tài khoản Admin bởi chính mình (phải thành công).
     */
    @Test
    public void testToggleUserStatusAdminBySelfSuccess() throws Exception {
        mockUserDAO.dbUser = new User(10, "admin1@uni.edu.vn", "hash", "active", "ADMIN", null, 0, null);

        userService.toggleUserStatus(10, "locked", "adminban", 10); // actorId = 10 (chính mình)
        assertTrue("Trạng thái phải được cập nhật ở DB", mockUserDAO.updateStatusCalled);
    }

    /**
     * Test Import hàng loạt thành công.
     */
    @Test
    public void testImportUsersSuccess() throws Exception {
        List<UserDTO> list = new ArrayList<>();
        UserDTO u1 = new UserDTO();
        u1.setEmail("import1@uni.edu.vn");
        u1.setFullName("Import User 1");
        u1.setDateOfBirth(Date.valueOf("2005-01-01"));
        u1.setCode("HE180001");
        u1.setGender("Nam");
        list.add(u1);

        UserDTO u2 = new UserDTO();
        u2.setEmail("import2@uni.edu.vn");
        u2.setFullName("Import User 2");
        u2.setDateOfBirth(Date.valueOf("2005-02-02"));
        u2.setCode("HE180002");
        u2.setGender("Nữ");
        list.add(u2);

        userService.importUsers(list, "STUDENT", 99);

        assertTrue("Hàm import batch trong CSDL phải được gọi", mockUserDAO.importBatchCalled);
        assertEquals("Số lượng tài khoản import thành công phải là 2", 2, mockUserDAO.importedList.size());
        assertTrue("Mật khẩu của user import phải được băm", BCrypt.checkpw("import1@uni.edu.vn", mockUserDAO.importedList.get(0).getPasswordHash()));
        assertTrue("Audit Log phải được ghi", mockUserDAO.auditLogCalled);
        assertEquals("Loại action trong Audit phải là IMPORT_USERS", "IMPORT_USERS", mockUserDAO.auditAction);
    }

    /**
     * Test Import hàng loạt thất bại ở Phase 1 do lỗi định dạng hoặc trùng lặp (All-or-Nothing).
     */
    @Test
    public void testImportUsersPhase1Failure() {
        List<UserDTO> list = new ArrayList<>();
        UserDTO u1 = new UserDTO();
        u1.setEmail("invalid-email"); // Lỗi email
        u1.setFullName("User 1");
        u1.setDateOfBirth(Date.valueOf("2005-01-01"));
        u1.setCode("HE180001");
        list.add(u1);

        UserDTO u2 = new UserDTO();
        u2.setEmail("duplicate@uni.edu.vn");
        u2.setFullName("User 2");
        u2.setDateOfBirth(Date.valueOf("2005-02-02"));
        u2.setCode("HE180001"); // Trùng mã số trong file với user 1
        list.add(u2);

        try {
            userService.importUsers(list, "STUDENT", 99);
            fail("Phải ném Exception ở Phase 1");
        } catch (Exception e) {
            assertTrue("Thông báo lỗi phải chứa thông tin lỗi định dạng", e.getMessage().contains("Phase 1"));
            assertFalse("Không được gọi hàm import batch vào DB (All-or-Nothing)", mockUserDAO.importBatchCalled);
            assertFalse("Không được ghi Audit Log", mockUserDAO.auditLogCalled);
        }
    }

    /**
     * Test lấy danh sách người dùng để xuất Excel (không phân trang).
     */
    @Test
    public void testGetUsersForExport() {
        List<UserDTO> result = userService.getUsersForExport("search_key", "STUDENT", "active");
        
        assertTrue("Hàm findAllUsers trong CSDL phải được gọi", mockUserDAO.findAllUsersCalled);
        assertEquals("Tham số search truyền vào phải khớp", "search_key", mockUserDAO.searchParam);
        assertEquals("Tham số role truyền vào phải khớp", "STUDENT", mockUserDAO.roleParam);
        assertEquals("Tham số status truyền vào phải khớp", "active", mockUserDAO.statusParam);
        assertEquals("Danh sách xuất ra phải có 1 phần tử", 1, result.size());
        assertEquals("Email khớp với mock", "test_export@uni.edu.vn", result.get(0).getEmail());
    }

    /**
     * Lớp MockUserDAO kế thừa UserDAO để stubbing.
     */
    private static class MockUserDAO extends UserDAO {
        private boolean createUserCalled = false;
        private User createdUser = null;
        private boolean auditLogCalled = false;
        private String auditAction = null;
        
        private String existingEmail = null;
        private String existingCode = null;
        private String existingCodeRole = null;
        
        private boolean findAllUsersCalled = false;
        private String searchParam = null;
        private String roleParam = null;
        private String statusParam = null;
        
        private boolean updateStatusCalled = false;
        private String newStatus = null;
        private String newLockReason = null;
        private User dbUser = null;

        private UserDTO dbUserDTO = null;
        private boolean updateUserCalled = false;

        private boolean importBatchCalled = false;
        private List<UserDTO> importedList = null;

        @Override
        public boolean existsByEmail(String email, Integer excludeUserId) {
            return email.equals(existingEmail);
        }

        @Override
        public boolean existsByCode(String code, String role, Integer excludeUserId) {
            return code.equals(existingCode) && role.equalsIgnoreCase(existingCodeRole);
        }

        @Override
        public boolean createUserWithProfile(User user, MemberProfile profile, String code, String major, Integer enrollmentYear, String department) throws SQLException {
            this.createUserCalled = true;
            this.createdUser = user;
            user.setUserId(123); // giả lập ID sinh ra
            return true;
        }

        @Override
        public User findByUserId(int userId) {
            if (dbUser != null && dbUser.getUserId() == userId) {
                return dbUser;
            }
            return null;
        }

        @Override
        public UserDTO findUserDTOById(int userId) {
            if (dbUserDTO != null && dbUserDTO.getUserId() == userId) {
                return dbUserDTO;
            }
            return null;
        }

        @Override
        public boolean updateUserWithProfile(User user, MemberProfile profile, String code, String major, Integer enrollmentYear, String department) throws SQLException {
            this.updateUserCalled = true;
            return true;
        }

        @Override
        public boolean updateUserStatus(int userId, String status, String lockReason) {
            this.updateStatusCalled = true;
            this.newStatus = status;
            this.newLockReason = lockReason;
            if (dbUser != null && dbUser.getUserId() == userId) {
                dbUser.setStatus(status);
                dbUser.setLockReason(lockReason);
            }
            return true;
        }

        @Override
        public boolean importUsersBatch(List<UserDTO> users, String role) throws SQLException {
            this.importBatchCalled = true;
            this.importedList = users;
            return true;
        }

        @Override
        public void insertAuditLog(Integer userId, String actionType, String entityName, Integer entityId, String oldValues, String newValues) {
            this.auditLogCalled = true;
            this.auditAction = actionType;
        }

        @Override
        public List<UserDTO> findAllUsers(String search, String role, String status, int offset, int limit) {
            this.findAllUsersCalled = true;
            this.searchParam = search;
            this.roleParam = role;
            this.statusParam = status;
            List<UserDTO> list = new ArrayList<>();
            UserDTO u = new UserDTO();
            u.setEmail("test_export@uni.edu.vn");
            list.add(u);
            return list;
        }
    }
}
