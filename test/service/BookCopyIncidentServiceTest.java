package service;

import exception.ValidationException;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

public class BookCopyIncidentServiceTest {

    private BookCopyIncidentService service;

    @Before
    public void setUp() {
        service = new BookCopyIncidentService(null, null, null, null);
    }

    @Test
    public void validateReportAcceptsCompleteReport() throws Exception {
        service.validateReport("BC-TEST-001", "damaged", "Rách bìa sau.");
        assertTrue(true);
    }

    @Test
    public void validateReportRejectsInvalidType() throws Exception {
        assertValidation(() -> service.validateReport("BC-TEST-001", "missing", "Không tìm thấy."),
                "Loại sự cố không hợp lệ.");
    }

    @Test
    public void validateReportRejectsMissingDescription() throws Exception {
        assertValidation(() -> service.validateReport("BC-TEST-001", "lost", null),
                "Mô tả hiện trạng không được để trống.");
    }

    @Test
    public void validateResolutionRejectsBlankConclusion() throws Exception {
        assertValidation(() -> service.validateResolution(" "), "Kết luận xử lý không được để trống.");
    }

    @Test
    public void validateRepairNoteRejectsBlankNote() throws Exception {
        assertValidation(() -> service.validateRepairNote(" "), "Ghi chú sửa chữa không được để trống.");
    }

    private void assertValidation(ValidationCall call, String expected) throws Exception {
        try {
            call.run();
            fail("Expected ValidationException");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains(expected));
        }
    }

    @FunctionalInterface
    private interface ValidationCall {
        void run() throws ValidationException;
    }
}
