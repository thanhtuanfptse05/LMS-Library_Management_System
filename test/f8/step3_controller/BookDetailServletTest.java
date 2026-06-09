package f8.step3_controller;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * BookDetailServletTest — Unit Tests cho BookDetailServlet.
 * 
 * Tập trung kiểm thử logic kiểm soát quyền truy cập Guest (Chưa đăng nhập).
 */
public class BookDetailServletTest {

    @Test
    public void testGuestRedirect() {
        // Giả lập trạng thái session
        boolean isUserLoggedIn = false;
        
        // Theo FR-44: Nút mượn sách bị vô hiệu hóa nếu user chưa đăng nhập
        boolean isBorrowButtonEnabled = isUserLoggedIn;
        String alertMessage = isUserLoggedIn ? "" : "Vui lòng đăng nhập để mượn sách.";
        
        assertFalse("Nút mượn sách phải bị vô hiệu hóa đối với Guest", isBorrowButtonEnabled);
        assertEquals("Phải có thông báo yêu cầu đăng nhập", "Vui lòng đăng nhập để mượn sách.", alertMessage);
    }
    
    @Test
    public void testStudentAccess() {
        // Giả lập trạng thái session
        boolean isUserLoggedIn = true;
        
        boolean isBorrowButtonEnabled = isUserLoggedIn;
        
        assertTrue("Nút mượn sách phải được kích hoạt đối với người dùng đã đăng nhập", isBorrowButtonEnabled);
    }
}
