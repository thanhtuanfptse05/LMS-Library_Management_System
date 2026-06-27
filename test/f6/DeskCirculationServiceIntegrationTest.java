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
public class DeskCirculationServiceIntegrationTest {

    private final int testId;
    private final String action;
    private final String memberCode;
    private final String barcode;
    private final String condition;
    private final int paymentId;
    private final int userId;
    private final Map<String, List<Map<String, Object>>> dbData;
    private final boolean expectSuccess;

    public DeskCirculationServiceIntegrationTest(int testId, String action, String memberCode, String barcode,
                                                String condition, int paymentId, int userId,
                                                Map<String, List<Map<String, Object>>> dbData,
                                                boolean expectSuccess) {
        this.testId = testId;
        this.action = action;
        this.memberCode = memberCode;
        this.barcode = barcode;
        this.condition = condition;
        this.paymentId = paymentId;
        this.userId = userId;
        this.dbData = dbData;
        this.expectSuccess = expectSuccess;
    }

    @Parameters(name = "{index}: Integration TestId={0}, Action={1}")
    public static Collection<Object[]> data() {
        List<Object[]> params = new ArrayList<>();

        for (int i = 1; i <= 30; i++) {
            Map<String, List<Map<String, Object>>> dbMock = new HashMap<>();
            boolean success = false;
            String act = "CHECKOUT";
            String mCode = "STUDENT-INTEG-" + i;
            String bCode = "BC-INTEG-" + i;
            String cond = "good";
            int pId = 0;
            int uId = 0;

            if (i <= 10) {
                // Checkout integration
                act = "CHECKOUT";
                success = (i % 2 == 1);
                if (success) {
                    setupUserMock(dbMock, 100 + i, "STUDENT");
                    setupFineMock(dbMock, false);
                    setupBookCopyMock(dbMock, 1000 + i, 2000 + i, "available");
                    setupReservationMock(dbMock, false, false);
                } else {
                    setupUserMock(dbMock, 100 + i, "STUDENT");
                    setupFineMock(dbMock, true); // fail due to unpaid fines
                }
            } else if (i <= 20) {
                // Checkin integration
                act = "CHECKIN";
                success = (i % 3 != 0);
                cond = (i % 2 == 0) ? "damaged" : "good";
                if (success) {
                    setupBookCopyMock(dbMock, 1000 + i, 2000 + i, "borrowed");
                    setupActiveBorrowRecordMock(dbMock, 3000 + i, 100 + i, 2000 + i);
                    setupNextInQueueMock(dbMock, false);
                    setupBookPriceMock(dbMock, 120000.0);
                } else {
                    // Fail due to available copy status (already returned)
                    setupBookCopyMock(dbMock, 1000 + i, 2000 + i, "available");
                }
            } else {
                // Cash Payment integration
                act = "CASH_PAYMENT";
                pId = i * 5;
                uId = i * 3;
                success = (i % 2 == 0);
                if (success) {
                    setupPaymentMock(dbMock, 5000 + i);
                    setupRemainingReasonsMock(dbMock, 0);
                } else {
                    // Payment not found
                    dbMock.put("findFineIdByPaymentId", Collections.emptyList());
                }
            }

            params.add(new Object[]{i, act, mCode, bCode, cond, pId, uId, dbMock, success});
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
    public void testIntegration() {
        DeskCirculationService service = new DeskCirculationService();
        try {
            if ("CHECKOUT".equals(action)) {
                service.processCheckOut(1, memberCode, barcode);
            } else if ("CHECKIN".equals(action)) {
                service.processCheckIn(1, barcode, condition);
            } else if ("CASH_PAYMENT".equals(action)) {
                service.approveCashPayment(1, paymentId, userId);
            }
            assertTrue("Integration TestId " + testId + " should have succeeded.", expectSuccess);
        } catch (Exception e) {
            if (expectSuccess) {
                fail("Integration TestId " + testId + " failed: " + e.getMessage());
            }
        }
    }
}
