package service;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;
import java.util.List;
import static org.junit.Assert.*;

public class NotificationServiceTest {

    private NotificationService notificationService;

    @Before
    public void setUp() {
        notificationService = new NotificationService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateNotificationSuccess() throws ValidationException {
        notificationService.validateNotification("Thông báo nghỉ lễ", "Thư viện sẽ nghỉ lễ 30/4", "general");
        notificationService.validateNotification("Bảo trì hệ thống", "Hệ thống bảo trì từ 22h", "maintenance");
    }

    @Test
    public void testValidateDocumentTemplateSuccess() throws ValidationException {
        notificationService.validateDocumentTemplate("OVERDUE_NOTICE", "Cảnh báo quá hạn {{bookTitle}}", "Sách {{bookTitle}} của bạn quá hạn {{dueDate}}.");
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testTitleBoundary255() throws ValidationException {
        String title255 = "T".repeat(255);
        notificationService.validateNotification(title255, "Nội dung", "policy");
    }

    @Test
    public void testCheckRequiredPlaceholdersResetPassword() {
        List<String> missing = notificationService.checkRequiredPlaceholders("RESET_PASSWORD", "Mã của bạn: 123456");
        assertTrue("Thiếu {{tempPassword}} và {{userName}}", missing.contains("{{tempPassword}}") || missing.contains("{{userName}}"));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateNotificationEmptyTitleThrowsException() throws ValidationException {
        notificationService.validateNotification("   ", "Nội dung", "general");
    }

    @Test(expected = ValidationException.class)
    public void testValidateNotificationTitleTooLongThrowsException() throws ValidationException {
        String title256 = "T".repeat(256);
        notificationService.validateNotification(title256, "Nội dung", "general");
    }

    @Test(expected = ValidationException.class)
    public void testValidateNotificationInvalidTypeThrowsException() throws ValidationException {
        notificationService.validateNotification("Tiêu đề", "Nội dung", "invalid_type");
    }

    @Test(expected = ValidationException.class)
    public void testValidateDocumentTemplateEmptySubjectThrowsException() throws ValidationException {
        notificationService.validateDocumentTemplate("OVERDUE_NOTICE", "", "Nội dung");
    }

    @Test(expected = ValidationException.class)
    public void testValidateDocumentTemplateMissingPlaceholderThrowsException() throws ValidationException {
        // OVERDUE_NOTICE thiếu {{bookTitle}}
        notificationService.validateDocumentTemplate("OVERDUE_NOTICE", "Tiêu đề", "Nội dung không có placeholder");
    }
}
