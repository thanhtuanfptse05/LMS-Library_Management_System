package controllers;

import dao.AuditLogDAO;
import dao.FineDAO;
import dao.PaymentDAO;
import dao.SystemConfigDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import util.DatabaseConnection;

/**
 * SePayWebhookServlet — Tiếp nhận Webhook từ SePay khi có chuyển khoản ngân hàng.
 *
 * <p>Route: {@code /api/sepay-webhook} (POST)</p>
 *
 * <p>Luồng xử lý:</p>
 * <ol>
 *   <li>Xac thuc API Key (tuy chon - bo qua neu SePay cau hinh "Khong xac thuc").</li>
 *   <li>Parse JSON body thủ công: lấy {@code content}, {@code code} và {@code transferAmount}.</li>
 *   <li>Trích xuất mã hóa đơn {@code LMSPF<paymentId>} từ {@code content} hoặc {@code code}.</li>
 *   <li>Nếu hợp lệ: cập nhật Payment thành 'completed', Fine thành 'paid', ghi Audit Log.</li>
 *   <li>Trả HTTP 200 OK kèm JSON xác nhận.</li>
 * </ol>
 *
 * <p>Tuân thủ: SEC-03 (PreparedStatement), TRANS-01 (Atomic Transaction).</p>
 */
@WebServlet(name = "SePayWebhookServlet", urlPatterns = {"/api/sepay-webhook"})
public class SePayWebhookServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SePayWebhookServlet.class.getName());

    /** Regex trích xuất paymentId từ nội dung chuyển khoản: LMSPF<số> */
    private static final Pattern PAYMENT_CODE_PATTERN = Pattern.compile("LMSPF(\\d+)", Pattern.CASE_INSENSITIVE);

    private final SystemConfigDAO systemConfigDAO = new SystemConfigDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final FineDAO fineDAO = new FineDAO();
    private final AuditLogDAO auditLogDAO = new AuditLogDAO();
    private final dao.UserLockReasonDAO userLockReasonDAO = new dao.UserLockReasonDAO();
    private final dao.UserDAO userDAO = new dao.UserDAO();
    private final dao.BorrowRecordDAO borrowRecordDAO = new dao.BorrowRecordDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
       
    }

    private void out(HttpServletResponse response, String json) throws IOException {
        response.getWriter().print(json);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        LOGGER.info("=== SePay Webhook: Nhận request mới ===");

        // 1. Xác thực API Key (TUỲ CHỌN)
        // Nếu SEPAY_API_KEY được cấu hình trong DB → kiểm tra Header Authorization.
        // Neu KHONG cau hinh (rong) -> bo qua buoc xac thuc (che do "Khong xac thuc" tren SePay).
        // Trim để loại bỏ khoảng trắng thừa có thể bị copy-paste vào DB
        String configuredApiKey = systemConfigDAO.getValue("SEPAY_API_KEY", "").trim();

        if (!configuredApiKey.isEmpty()) {
            String authHeader = request.getHeader("Authorization");
            // SePay gửi header dạng: "Apikey <API_KEY_CUA_BAN"
            // Kiểm tra authHeader chứa API key (cả dạng bare và dạng "Apikey ...").
            boolean apiKeyValid = authHeader != null
                    && (authHeader.contains(configuredApiKey)
                        || authHeader.equalsIgnoreCase("Apikey " + configuredApiKey));
            if (!apiKeyValid) {
                LOGGER.warning("SePay Webhook: Xác thực API Key thất bại. Header: " + authHeader);
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"success\":false,\"message\":\"Unauthorized\"}");
                return;
            }
            LOGGER.info("SePay Webhook: Xác thực API Key thành công.");
        } else {
            LOGGER.info("SePay Webhook: SEPAY_API_KEY chua cau hinh - bo qua xac thuc (che do Khong xac thuc).");
        }

        // 2. Doc JSON body
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        String jsonBody = sb.toString();
        LOGGER.info("SePay Webhook body: " + jsonBody);

        // 3. Parse JSON thủ công (không dùng Gson vì không có trong allowed libs)
        // SePay gửi JSON format chuẩn:
        // {
        //   "id": 92704,
        //   "gateway": "Vietcombank",
        //   "transactionDate": "2024-07-02 11:08:33",
        //   "accountNumber": "1017588888",
        //   "code": "LMSPF5",                       <-- Mã thanh toán (SePay tự tách)
        //   "content": "LMSPF5 chuyen tien",         <-- Nội dung chuyển khoản gốc
        //   "transferType": "in",
        //   "transferAmount": 10000,                  <-- So tien
        //   "referenceCode": "FT24012345678"          <-- Mã tham chiếu ngân hàng
        // }

        String content = extractJsonStringValue(jsonBody, "content");
        String code = extractJsonStringValue(jsonBody, "code");
        String transferAmountStr = extractJsonNumberValue(jsonBody, "transferAmount");
        String transactionRef = extractJsonStringValue(jsonBody, "referenceCode");

        LOGGER.info("SePay Webhook parsed — content: [" + content
                + "], code: [" + code
                + "], transferAmount: [" + transferAmountStr
                + "], referenceCode: [" + transactionRef + "]");

        BigDecimal transferAmount = BigDecimal.ZERO;
        if (transferAmountStr != null && !transferAmountStr.isEmpty()) {
            try {
                transferAmount = new BigDecimal(transferAmountStr);
            } catch (NumberFormatException e) {
                LOGGER.warning("SePay Webhook: transferAmount không hợp lệ: " + transferAmountStr);
            }
        }

        if (content == null) {
            content = "";
        }
        if (code == null) {
            code = "";
        }
        if (transactionRef == null || transactionRef.trim().isEmpty()) {
            // VA (Virtual Account) thường không có referenceCode riêng.
            // Sinh fallback unique reference để tránh lỗi UNIQUE constraint trên cột transactionReference.
            transactionRef = "SEPAY-VA-" + System.currentTimeMillis();
            LOGGER.info("SePay Webhook: referenceCode rỗng, dùng fallback: " + transactionRef);
        }

        // 4. Tìm paymentId từ nội dung chuyển khoản
        // Ưu tiên tìm trong "content" trước (nội dung chuyển khoản gốc),
        // sau đó tìm trong "code" (mã thanh toán SePay tự tách).
        // Cuối cùng ghép cả 2 để thử lần cuối.
        String combinedText = content + " " + code;
        Matcher matcher = PAYMENT_CODE_PATTERN.matcher(combinedText);

        if (!matcher.find()) {
            LOGGER.info("SePay Webhook: Không tìm thấy mã LMSPF. content=[" + content + "], code=[" + code + "]");
            response.setStatus(HttpServletResponse.SC_OK);
            out.print("{\"success\":true,\"message\":\"No matching payment code found\"}");
            return;
        }

        int paymentId;
        try {
            paymentId = Integer.parseInt(matcher.group(1));
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_OK);
            out.print("{\"success\":true,\"message\":\"Invalid payment code format\"}");
            return;
        }

        LOGGER.info("SePay Webhook: Tìm thấy paymentId=" + paymentId);

        // 5. Xử lý cập nhật DB trong Transaction
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Kiểm tra trạng thái hiện tại
                String currentStatus = paymentDAO.getPaymentStatus(conn, paymentId);
                if (currentStatus == null) {
                    conn.rollback();
                    LOGGER.warning("SePay Webhook: paymentId=" + paymentId + " không tồn tại trong DB.");
                    out.print("{\"success\":false,\"message\":\"Payment not found\"}");
                    return;
                }

                if ("completed".equals(currentStatus)) {
                    conn.rollback();
                    LOGGER.info("SePay Webhook: paymentId=" + paymentId + " da thanh toan truoc do - bo qua.");
                    out.print("{\"success\":true,\"message\":\"Payment already completed\"}");
                    return;
                }

                // Lấy fineId liên kết
                int fineId = paymentDAO.findFineIdByPaymentId(conn, paymentId);
                if (fineId == -1) {
                    conn.rollback();
                    LOGGER.warning("SePay Webhook: Không tìm thấy fineId cho paymentId=" + paymentId);
                    out.print("{\"success\":false,\"message\":\"Fine not found for payment\"}");
                    return;
                }

                // ----------------------------------------------------------------
                // [BUG-FIX] Guard — Kiểm tra sách đã được trả vật lý chưa (Phương án B)
                // Tiền đã chuyển khoản thực tế → luôn ghi Payment = 'completed'.
                // Nhưng NẾU sách chưa trả: KHÔNG mark Fine = 'paid', KHÔNG unlock tài khoản.
                // Thủ thư sẽ thấy khoản phạt vẫn 'unpaid' và yêu cầu trả sách tại quầy.
                // Khi trả sách (Check-in), OverdueProcessor / processCheckInGood sẽ
                // phát hiện Payment đã 'completed' và tự xử lý.
                // ----------------------------------------------------------------
                int borrowRecordId = fineDAO.findBorrowRecordIdByFineId(conn, fineId);
                boolean bookAlreadyReturned = true; // mặc định cho phép nếu không có BorrowRecord
                if (borrowRecordId != -1) {
                    String brStatus = borrowRecordDAO.findStatusById(conn, borrowRecordId);
                    bookAlreadyReturned = "returned".equals(brStatus)
                                      || "lost".equals(brStatus)
                                      || "damaged".equals(brStatus);
                }

                // Luôn ghi nhận Payment = 'completed' vì tiền đã thật sự vào tài khoản
                paymentDAO.updatePaymentOnlineSuccess(conn, paymentId, transactionRef,
                        "BankTransfer", transferAmount);

                // Lấy userId từ bảng Fine
                int userId = -1;
                String sqlUser = "SELECT userId FROM Fine WHERE fineId = ?";
                try (PreparedStatement psUser = conn.prepareStatement(sqlUser)) {
                    psUser.setInt(1, fineId);
                    try (ResultSet rsUser = psUser.executeQuery()) {
                        if (rsUser.next()) {
                            userId = rsUser.getInt("userId");
                        }
                    }
                }

                if (!bookAlreadyReturned) {
                    // Sách chưa trả — ghi Audit Log cảnh báo, KHÔNG mark Fine = paid, KHÔNG unlock
                    LOGGER.warning("SePay Webhook: Tiền đã nhận nhưng sách CHƯA TRẢ — "
                            + "paymentId=" + paymentId + ", fineId=" + fineId
                            + ", borrowRecordId=" + borrowRecordId
                            + ". Payment = completed nhưng Fine vẫn 'unpaid', tài khoản KHÔNG unlock.");
                    auditLogDAO.insert(conn, userId != -1 ? userId : null,
                            "SEPAY_WEBHOOK_PAID_BOOK_NOT_RETURNED",
                            "Payment", paymentId, "{\"status\":\"pending\"}",
                            "{\"status\":\"completed\",\"warning\":\"book_not_returned\""
                            + ",\"borrowRecordId\":" + borrowRecordId
                            + ",\"transactionRef\":\"" + transactionRef + "\"}");
                    conn.commit();
                    out.print("{\"success\":true,\"message\":\"Payment recorded. Book not yet returned — fine remains unpaid until book is returned.\"}");
                    return;
                }

                // Sách đã trả — xử lý bình thường
                // Cập nhật Fine -> paid
                fineDAO.updateStatusToPaid(conn, fineId);

                // Xóa lý do khóa 'unpaid' và tự động mở khóa (BR-25)
                if (userId != -1) {
                    userLockReasonDAO.deleteLockReason(conn, userId, "unpaid");
                    int remainingReasons = userLockReasonDAO.countLockReasonsByUserId(conn, userId);
                    if (remainingReasons == 0) {
                        userDAO.updateStatusToActive(conn, userId);
                    }
                }

                // Ghi Audit Log
                auditLogDAO.insert(conn, userId != -1 ? userId : null, "SEPAY_WEBHOOK_PAYMENT",
                        "Payment", paymentId, "{\"status\":\"pending\"}",
                        "{\"status\":\"completed\",\"transactionRef\":\"" + transactionRef
                        + "\",\"amount\":" + transferAmount + "}");

                conn.commit();
                LOGGER.info("SePay Webhook: THÀNH CÔNG — paymentId="
                        + paymentId + ", fineId=" + fineId
                        + ", amount=" + transferAmount);

                // Gửi email xác nhận thanh toán (bất đồng bộ, ngoài transaction)
                if (userId != -1) {
                    service.EmailService.sendPaymentConfirmationEmail(paymentId, userId, "BankTransfer");
                }

                out.print("{\"success\":true,\"message\":\"Payment processed successfully\"}");

            } catch (SQLException e) {
                conn.rollback();
                LOGGER.log(Level.SEVERE, "SePay Webhook: Lỗi DB khi xử lý paymentId=" + paymentId, e);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\":false,\"message\":\"Database error\"}");
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SePay Webhook: Không thể kết nối cơ sở dữ liệu", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Database connection error\"}");
        }
    }

    /**
     * Trích xuất giá trị chuỗi (String) từ JSON body bằng regex đơn giản.
     * Ap dung cho JSON phang (flat) tu SePay webhook.
     *
     * @param json JSON string
     * @param key  Key cần trích xuất
     * @return Giá trị chuỗi hoặc null nếu không tìm thấy
     */
    private String extractJsonStringValue(String json, String key) {
        Pattern pattern = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*\"([^\"]*?)\"");
        Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }

    /**
     * Trích xuất giá trị số (Number) từ JSON body bằng regex đơn giản.
     * Hỗ trợ cả số nguyên và số thập phân.
     *
     * @param json JSON string
     * @param key  Key cần trích xuất
     * @return Chuỗi số hoặc null nếu không tìm thấy
     */
    private String extractJsonNumberValue(String json, String key) {
        Pattern pattern = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*([0-9.]+)");
        Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }
}
