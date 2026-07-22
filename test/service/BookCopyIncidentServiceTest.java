package service;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;

public class BookCopyIncidentServiceTest {

    private BookCopyIncidentService incidentService;

    @Before
    public void setUp() {
        incidentService = new BookCopyIncidentService();
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateReportValidDamaged() throws ValidationException {
        incidentService.validateReport("BC-1001", "damaged", "Sách bị rách trang 10-15");
    }

    @Test
    public void testValidateReportValidLost() throws ValidationException {
        incidentService.validateReport("BC-1002", "lost", "Bạn làm mất sách tại phòng đọc");
    }

    @Test
    public void testValidateResolutionValid() throws ValidationException {
        incidentService.validateResolution("Đã xử lý xong và thu tiền phạt đền bù.");
    }

    @Test
    public void testValidateRepairNoteValid() throws ValidationException {
        incidentService.validateRepairNote("Đã đóng lại bìa và dán lại trang rách.");
    }

    @Test
    public void testValidateRemovalNoteValid() throws ValidationException {
        incidentService.validateRemovalNote("Sách hỏng nặng, không còn khả năng sửa chữa.");
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateReportDescriptionBoundary1000() throws ValidationException {
        incidentService.validateReport("BC-1001", "damaged", "D".repeat(1000));
    }

    @Test
    public void testValidateResolutionBoundary1000() throws ValidationException {
        incidentService.validateResolution("R".repeat(1000));
    }

    @Test
    public void testValidateRemovalNoteBoundary1000() throws ValidationException {
        incidentService.validateRemovalNote("R".repeat(1000));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateReportNullBarcode() throws ValidationException {
        incidentService.validateReport(null, "damaged", "Mô tả sự cố");
    }

    @Test(expected = ValidationException.class)
    public void testValidateReportInvalidType() throws ValidationException {
        incidentService.validateReport("BC-1001", "stolen", "Mô tả sự cố");
    }

    @Test(expected = ValidationException.class)
    public void testValidateReportBlankDescription() throws ValidationException {
        incidentService.validateReport("BC-1001", "damaged", "   ");
    }

    @Test(expected = ValidationException.class)
    public void testValidateReportDescriptionExceeds1000() throws ValidationException {
        incidentService.validateReport("BC-1001", "damaged", "D".repeat(1001));
    }

    @Test(expected = ValidationException.class)
    public void testValidateResolutionBlank() throws ValidationException {
        incidentService.validateResolution("   ");
    }

    @Test(expected = ValidationException.class)
    public void testValidateRepairNoteBlank() throws ValidationException {
        incidentService.validateRepairNote("   ");
    }

    @Test(expected = ValidationException.class)
    public void testValidateRemovalNoteBlank() throws ValidationException {
        incidentService.validateRemovalNote("   ");
    }

    @Test(expected = ValidationException.class)
    public void testValidateRemovalNoteExceeds1000() throws ValidationException {
        incidentService.validateRemovalNote("R".repeat(1001));
    }
}
