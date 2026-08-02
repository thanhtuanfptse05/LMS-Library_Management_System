package service;

import exception.ValidationException;
import model.BookCopy;
import model.InventoryItem;
import model.InventorySession;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

public class InventoryReconciliationServiceTest {

    private InventoryReconciliationService service;

    @Before
    public void setUp() {
        service = new InventoryReconciliationService();
    }

    @Test
    public void testMisplacedCopyCanBeResolvedWhenStillInCountingScope() throws ValidationException {
        service.validateResolvableMisplacedCopy(copy("available", "good", false));
    }

    @Test
    public void testMisplacedCopyCannotBeMovedWhenBorrowed() {
        assertValidationContains(copy("borrowed", "good", false), "sẵn sàng");
    }

    @Test
    public void testMisplacedCopyCannotBeMovedWhenDamaged() {
        assertValidationContains(copy("available", "damaged", false), "tình trạng tốt");
    }

    @Test
    public void testMisplacedCopyCannotBeMovedWhenRemovedFromInventory() {
        assertValidationContains(copy("unavailable", "lost", true), "thanh lý");
    }

    @Test
    public void testReviewingSessionWithResolvedDiscrepancyCannotBeCancelled() {
        InventorySession session = session("reviewing");
        try {
            service.validateCancellableSession(session, 1);
            fail("Phiên đã có xử lý không được phép hủy");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("đã có chênh lệch được xử lý"));
        }
    }

    @Test
    public void testDraftCountingAndUntouchedReviewingSessionCanBeCancelled() throws ValidationException {
        service.validateCancellableSession(session("draft"), 0);
        service.validateCancellableSession(session("counting"), 0);
        service.validateCancellableSession(session("reviewing"), 0);
    }

    @Test
    public void testBothMisplacedResolutionModesAreAccepted() throws ValidationException {
        service.validateMisplacedResolutionMode("return_to_expected");
        service.validateMisplacedResolutionMode("relocate_to_scanned");
    }

    @Test
    public void testUnknownMisplacedResolutionModeIsRejected() {
        try {
            service.validateMisplacedResolutionMode("force_update");
            fail("Không được chấp nhận cách xử lý sai vị trí không xác định");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("không hợp lệ"));
        }
    }

    @Test
    public void testSnapshotLocationComparisonIgnoresCaseAndOuterSpaces() throws ValidationException {
        BookCopy copy = copy("available", "good", false);
        copy.setLocation(" Kệ A1 ");
        InventoryItem item = item("kệ a1");

        service.validateSnapshotLocation(copy, item);
    }

    @Test
    public void testChangedLocationAfterSnapshotIsRejected() {
        BookCopy copy = copy("available", "good", false);
        copy.setLocation("Kệ B2");
        try {
            service.validateSnapshotLocation(copy, item("Kệ A1"));
            fail("Không được xử lý item dựa trên snapshot vị trí đã cũ");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("đã thay đổi sau khi lập snapshot"));
        }
    }

    private void assertValidationContains(BookCopy copy, String expectedMessage) {
        try {
            service.validateResolvableMisplacedCopy(copy);
            fail("Bản sao ngoài phạm vi không được phép cập nhật vị trí");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains(expectedMessage));
        }
    }

    private BookCopy copy(String status, String condition, boolean removed) {
        BookCopy copy = new BookCopy();
        copy.setStatus(status);
        copy.setCondition(condition);
        copy.setRemovedFromInventory(removed);
        return copy;
    }

    private InventorySession session(String status) {
        InventorySession session = new InventorySession();
        session.setStatus(status);
        return session;
    }

    private InventoryItem item(String expectedLocation) {
        InventoryItem item = new InventoryItem();
        item.setExpectedLocation(expectedLocation);
        return item;
    }
}
