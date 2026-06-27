package f6;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;
import service.DeskCirculationService;
import util.DatabaseConnection;

import java.sql.Connection;
import java.util.*;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class DeskCirculationServiceUnitTest {

    private final int testId;
    private final String action;
    private final String memberCode;
    private final String barcode;
    private final String condition;
    private final int paymentId;
    private final int userId;
    private final Map<String, List<Map<String, Object>>> dbData;
    private final boolean expectSuccess;
    private final String expectedErrorMessage;

    public DeskCirculationServiceUnitTest(int testId, String action, String memberCode, String barcode,
                                          String condition, int paymentId, int userId,
                                          Map<String, List<Map<String, Object>>> dbData,
                                          boolean expectSuccess, String expectedErrorMessage) {
        this.testId = testId;
        this.action = action;
        this.memberCode = memberCode;
        this.barcode = barcode;
        this.condition = condition;
        this.paymentId = paymentId;
        this.userId = userId;
        this.dbData = dbData;
        this.expectSuccess = expectSuccess;
        this.expectedErrorMessage = expectedErrorMessage;
    }

    @Parameters(name = "{index}: TestId={0}, Action={1}")
    public static Collection<Object[]> data() {
        List<Object[]> params = new ArrayList<>();

        // Generate exactly 50 test cases
        for (int i = 1; i <= 50; i++) {
            Map<String, List<Map<String, Object>>> dbMock = new HashMap<>();
            boolean success = false;
            String errMsg = "";
            String act = "CHECKOUT";
            String mCode = "STUDENT-001";
            String bCode = "BC-001";
            String cond = "good";
            int pId = 0;
            int uId = 0;

            // Scenario distribution
            if (i <= 20) {
                // Checkout tests (1-20)
                act = "CHECKOUT";
                if (i == 1) {
                    // Happy path checkout (walk-in)
                    success = true;
                    setupUserMock(dbMock, 10, "STUDENT");
                    setupFineMock(dbMock, false);
                    setupBookCopyMock(dbMock, 100, 200, "available");
                    setupReservationMock(dbMock, false, false);
                } else if (i == 2) {
                    // Blocked user with unpaid fines
                    success = false;
                    errMsg = "Tài khoản đang nợ phạt";
                    setupUserMock(dbMock, 10, "STUDENT");
                    setupFineMock(dbMock, true); // has unpaid fines
                } else if (i == 3) {
                    // Invalid member code
                    success = false;
                    errMsg = "không tồn tại trong hệ thống";
                    dbMock.put("findUserIdByMemberCode", Collections.emptyList());
                } else if (i == 4) {
                    // Invalid barcode
                    success = false;
                    errMsg = "không hợp lệ hoặc không tồn tại";
                    setupUserMock(dbMock, 10, "STUDENT");
                    setupFineMock(dbMock, false);
                    dbMock.put("findByBarcode", Collections.emptyList());
                } else if (i == 5) {
                    // Walk-in but copy not available
                    success = false;
                    errMsg = "không sẵn sàng để mượn trực tiếp";
                    setupUserMock(dbMock, 10, "STUDENT");
                    setupFineMock(dbMock, false);
                    setupBookCopyMock(dbMock, 100, 200, "borrowed");
                } else if (i == 6) {
                    // Walk-in but there is a queue for others
                    success = false;
                    errMsg = "đã được người khác đặt trước";
                    setupUserMock(dbMock, 10, "STUDENT");
                    setupFineMock(dbMock, false);
                    setupBookCopyMock(dbMock, 100, 200, "available");
                    setupReservationMock(dbMock, false, true); // queue exists
                } else if (i == 7) {
                    // Pre-reservation fulfilled path
                    success = true;
                    setupUserMock(dbMock, 10, "STUDENT");
                    setupFineMock(dbMock, false);
                    setupBookCopyMock(dbMock, 100, 200, "reserved");
                    setupReservationMock(dbMock, true, false); // has ready reservation
                } else if (i == 8) {
                    // Pre-reservation exists but copy status mismatch
                    success = false;
                    errMsg = "không ở trạng thái được giữ đặt trước";
                    setupUserMock(dbMock, 10, "STUDENT");
                    setupFineMock(dbMock, false);
                    setupBookCopyMock(dbMock, 100, 200, "available");
                    setupReservationWithCopyIdMock(dbMock, true, 999);
                } else if (i == 9) {
                    // Pre-reservation exists but copy ID mismatch
                    success = false;
                    errMsg = "không khớp với bản sao được giữ riêng";
                    setupUserMock(dbMock, 10, "STUDENT");
                    setupFineMock(dbMock, false);
                    setupBookCopyMock(dbMock, 100, 200, "reserved");
                    setupReservationWithCopyIdMock(dbMock, true, 999); // different copy ID
                } else if (i == 10) {
                    // Lecturer checkout with custom configs
                    success = true;
                    setupUserMock(dbMock, 11, "LECTURER");
                    setupFineMock(dbMock, false);
                    setupBookCopyMock(dbMock, 100, 200, "available");
                    setupReservationMock(dbMock, false, false);
                    setupConfigMock(dbMock, "30");
                } else {
                    // i from 11 to 20: variants of checkout exceptions or edge cases
                    success = (i % 2 == 0);
                    if (!success) {
                        errMsg = "không tồn tại";
                    }
                    setupUserMock(dbMock, 10 + i, "STUDENT");
                    setupFineMock(dbMock, false);
                    if (success) {
                        setupBookCopyMock(dbMock, 100 + i, 200 + i, "available");
                    }
                }
            } else if (i <= 40) {
                // Checkin tests (21-40)
                act = "CHECKIN";
                bCode = "BC-002";
                if (i == 21) {
                    // Happy path checkin good - no queue
                    success = true;
                    cond = "good";
                    setupBookCopyMock(dbMock, 100, 200, "borrowed");
                    setupActiveBorrowRecordMock(dbMock, 300, 10, 200);
                    setupNextInQueueMock(dbMock, false);
                } else if (i == 22) {
                    // Checkin good with next in queue
                    success = true;
                    cond = "good";
                    setupBookCopyMock(dbMock, 100, 200, "borrowed");
                    setupActiveBorrowRecordMock(dbMock, 300, 10, 200);
                    setupNextInQueueMock(dbMock, true);
                } else if (i == 23) {
                    // Checkin hỏng (damaged)
                    success = true;
                    cond = "damaged";
                    setupBookCopyMock(dbMock, 100, 200, "borrowed");
                    setupActiveBorrowRecordMock(dbMock, 300, 10, 200);
                    setupBookPriceMock(dbMock, 150000.0);
                } else if (i == 24) {
                    // Checkin mất (lost)
                    success = true;
                    cond = "lost";
                    setupBookCopyMock(dbMock, 100, 200, "borrowed");
                    setupActiveBorrowRecordMock(dbMock, 300, 10, 200);
                    setupBookPriceMock(dbMock, 200000.0);
                } else if (i == 25) {
                    // Checkin copy not in borrowed status
                    success = false;
                    errMsg = "không ở trạng thái 'borrowed'";
                    cond = "good";
                    setupBookCopyMock(dbMock, 100, 200, "available");
                } else if (i == 26) {
                    // Checkin invalid condition value
                    success = false;
                    errMsg = "Tình trạng sách không hợp lệ";
                    cond = "invalid_cond";
                } else if (i == 27) {
                    // Checkin copy not found
                    success = false;
                    errMsg = "không hợp lệ hoặc không tồn tại";
                    cond = "good";
                    dbMock.put("findByBarcode", Collections.emptyList());
                } else {
                    // i from 28 to 40: variants of checkin
                    success = (i % 2 == 0);
                    if (!success) {
                        errMsg = "không ở trạng thái 'borrowed'";
                    }
                    cond = (i % 3 == 0) ? "damaged" : "good";
                    setupBookCopyMock(dbMock, 100 + i, 200 + i, (i % 2 == 0) ? "borrowed" : "available");
                    setupActiveBorrowRecordMock(dbMock, 300 + i, 10 + i, 200 + i);
                    setupNextInQueueMock(dbMock, i % 4 == 0);
                }
            } else {
                // Cash Payment tests (41-50)
                act = "CASH_PAYMENT";
                pId = i * 10;
                uId = i * 2;
                if (i == 41) {
                    // Happy path cash payment - auto unlock (0 remaining reasons)
                    success = true;
                    setupPaymentMock(dbMock, 1000);
                    setupRemainingReasonsMock(dbMock, 0);
                } else if (i == 42) {
                    // Cash payment - keeping user locked (other reasons exist)
                    success = true;
                    setupPaymentMock(dbMock, 1000);
                    setupRemainingReasonsMock(dbMock, 1);
                } else if (i == 43) {
                    // Payment not found
                    success = false;
                    errMsg = "không tồn tại trong hệ thống";
                    dbMock.put("findFineIdByPaymentId", Collections.emptyList());
                } else {
                    // i from 44 to 50: variants
                    success = (i % 2 == 0);
                    if (!success) {
                        errMsg = "không tồn tại";
                    }
                    setupPaymentMock(dbMock, (i % 2 == 0) ? 1000 + i : -1);
                    setupRemainingReasonsMock(dbMock, i % 3);
                }
            }

            params.add(new Object[]{i, act, mCode, bCode, cond, pId, uId, dbMock, success, errMsg});
        }

        return params;
    }

    private static void setupUserMock(Map<String, List<Map<String, Object>>> db, int userId, String role) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("userId", userId);
        r.put("role", role);
        rows.add(r);
        db.put("studentcode", rows);
        db.put("role", rows);
    }

    private static void setupFineMock(Map<String, List<Map<String, Object>>> db, boolean hasUnpaid) {
        List<Map<String, Object>> rows = new ArrayList<>();
        if (hasUnpaid) {
            Map<String, Object> r = new HashMap<>();
            r.put("1", 1);
            rows.add(r);
        }
        db.put("status = 'unpaid'", rows);
    }

    private static void setupBookCopyMock(Map<String, List<Map<String, Object>>> db, int copyId, int bookId, String status) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("bookCopyId", copyId);
        r.put("bookId", bookId);
        r.put("status", status);
        r.put("condition", "good");
        rows.add(r);
        db.put("barcode", rows);
    }

    private static void setupReservationMock(Map<String, List<Map<String, Object>>> db, boolean hasReady, boolean hasQueued) {
        List<Map<String, Object>> readyRows = new ArrayList<>();
        if (hasReady) {
            Map<String, Object> r = new HashMap<>();
            r.put("reservationId", 500);
            r.put("userId", 10);
            r.put("bookId", 200);
            r.put("bookCopyId", 100);
            readyRows.add(r);
        }
        db.put("readypickup", readyRows);

        List<Map<String, Object>> queueRows = new ArrayList<>();
        if (hasQueued) {
            Map<String, Object> r = new HashMap<>();
            r.put("queueCount", 1);
            queueRows.add(r);
        }
        db.put("queuePosition > 0", queueRows);
    }

    private static void setupReservationWithCopyIdMock(Map<String, List<Map<String, Object>>> db, boolean hasReady, int copyId) {
        List<Map<String, Object>> readyRows = new ArrayList<>();
        if (hasReady) {
            Map<String, Object> r = new HashMap<>();
            r.put("reservationId", 500);
            r.put("userId", 10);
            r.put("bookId", 200);
            r.put("bookCopyId", copyId);
            readyRows.add(r);
        }
        db.put("readypickup", readyRows);
    }

    private static void setupConfigMock(Map<String, List<Map<String, Object>>> db, String value) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("configValue", value);
        rows.add(r);
        db.put("configKey", rows);
    }

    private static void setupActiveBorrowRecordMock(Map<String, List<Map<String, Object>>> db, int recordId, int userId, int bookId) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("borrowRecordId", recordId);
        r.put("userId", userId);
        r.put("bookId", bookId);
        r.put("endDate", new java.sql.Timestamp(System.currentTimeMillis() + 86400000L));
        rows.add(r);
        db.put("BorrowRecord", rows);
    }

    private static void setupNextInQueueMock(Map<String, List<Map<String, Object>>> db, boolean hasNext) {
        List<Map<String, Object>> rows = new ArrayList<>();
        if (hasNext) {
            Map<String, Object> r = new HashMap<>();
            r.put("reservationId", 600);
            r.put("userId", 12);
            r.put("bookId", 200);
            rows.add(r);
        }
        db.put("queuePosition = 1", rows);
    }

    private static void setupBookPriceMock(Map<String, List<Map<String, Object>>> db, double price) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("price", price);
        rows.add(r);
        db.put("price", rows);
    }

    private static void setupPaymentMock(Map<String, List<Map<String, Object>>> db, int fineId) {
        List<Map<String, Object>> rows = new ArrayList<>();
        if (fineId != -1) {
            Map<String, Object> r = new HashMap<>();
            r.put("fineId", fineId);
            rows.add(r);
        }
        db.put("paymentId", rows);
    }

    private static void setupRemainingReasonsMock(Map<String, List<Map<String, Object>>> db, int count) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, Object> r = new HashMap<>();
        r.put("count", count);
        rows.add(r);
        db.put("UserLockReason", rows);
    }

    @Before
    public void setUp() {
        DatabaseConnection.testConnection = MockJdbc.createMockConnection(dbData);
    }

    @After
    public void tearDown() {
        DatabaseConnection.testConnection = null;
    }

    @Test
    public void testCirculationAction() {
        DeskCirculationService service = new DeskCirculationService();
        try {
            if ("CHECKOUT".equals(action)) {
                service.processCheckOut(1, memberCode, barcode);
            } else if ("CHECKIN".equals(action)) {
                service.processCheckIn(1, barcode, condition);
            } else if ("CASH_PAYMENT".equals(action)) {
                service.approveCashPayment(1, paymentId, userId);
            }
            assertTrue("TestId " + testId + " should have succeeded.", expectSuccess);
        } catch (Exception e) {
            if (expectSuccess) {
                e.printStackTrace();
                fail("TestId " + testId + " failed unexpectedly: " + e.getMessage());
            } else {
                assertTrue("TestId " + testId + " error message '" + e.getMessage() + "' should contain '" + expectedErrorMessage + "'",
                        e.getMessage() != null && e.getMessage().contains(expectedErrorMessage));
            }
        }
    }
}
