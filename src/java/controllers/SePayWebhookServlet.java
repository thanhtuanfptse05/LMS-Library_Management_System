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
 * SePayWebhookServlet — API Endpoint tiếp nhận Webhook tự động từ cổng thanh toán SePay khi có biến động tài khoản ngân hàng.
 *
 * <p>Route: {@code /api/sepay-webhook} (Phương thức HTTP POST)</p>
 *
 * <p><b>Luồng xử lý 5 bước chuẩn hóa:</b></p>
 * <ol>
 *   <li><b>Xác thực API Key:</b> So sánh Secret Token/API Key từ Header Authorization của request với cấu hình trong DB.</li>
 *   <li><b>Đọc Body JSON:</b> Tiếp nhận nội dung JSON biến động số dư từ cổng SePay.</li>
 *   <li><b>Parse JSON thủ công:</b> Trích xuất các trường `content`, `code`, `transferAmount`, `referenceCode` (không phụ thuộc thư viện ngoài).</li>
 *   <li><b>Trích xuất Payment ID:</b> Dùng Regex tìm định dạng mã hóa đơn {@code LMSPF<paymentId>} (ví dụ: LMSPF12).</li>
 *   <li><b>Xử lý Giao dịch CSDL (Transaction Atomic):</b>
 *       <ul>
 *         <li>Kiểm tra trạng thái sách: Nếu sách ĐÃ TRẢ -> Cập nhật Payment = 'completed', Fine = 'paid', xóa lý do khóa 'unpaid', tự động MỞ KHÓA tài khoản độc giả nếu hết nợ.</li>
 *         <li>Nếu sách CHƯA TRẢ: Ghi nhận Payment = 'completed' (vì tiền đã vào tài khoản), giữ nguyên Fine = 'unpaid', KHÔNG mở khóa tài khoản, ghi log cảnh báo.</li>
 *       </ul>
 *   </li>
 * </ol>
 */
@WebServlet(name = "SePayWebhookServlet", urlPatterns = {"/api/sepay-webhook"})
public class SePayWebhookServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SePayWebhookServlet.class.getName());

    /** Biểu thức chính quy (Regex) trích xuất paymentId từ nội dung chuyển khoản: LMSPF<số> (không phân biệt hoa thường) */
    private static final Pattern PAYMENT_CODE_PATTERN = Pattern.compile("LMSPF(\\d+)", Pattern.CASE_INSENSITIVE);

    // Các đối tượng DAO cần thiết phục vụ cập nhật trạng thái thanh toán và tài khoản
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
        // Endpoint Webhook chỉ nhận HTTP POST
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

        // ================================================================
        // BƯỚC 1: XÁC THỰC API KEY (BẢO MẬT WEBHOOK)
        // ================================================================
        // Nếu SEPAY_API_KEY được cấu hình trong DB → kiểm tra Header Authorization.
        // Nếu KHÔNG cấu hình (rỗng) -> bỏ qua bước xác thực (chế độ "Không xác thực" trên SePay).
        String configuredApiKey = systemConfigDAO.getValue("SEPAY_API_KEY", "").trim();

        if (!configuredApiKey.isEmpty()) {
            String authHeader = request.getHeader("Authorization");
            // SePay gửi header dạng: "Apikey <API_KEY_CUA_BAN>"
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
            LOGGER.info("SePay Webhook: SEPAY_API_KEY chưa cấu hình - bỏ qua xác thực (chế độ Không xác thực).");
        }

        // ================================================================
        // BƯỚC 2: ĐỌC NỘI DUNG CHUỖI JSON TỪ WEBHOOK BODY
        // ================================================================
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        String jsonBody = sb.toString();
        LOGGER.info("SePay Webhook body: " + jsonBody);

        // ================================================================
        // BƯỚC 3: PARSE DỮ LIỆU JSON TỰ ĐỘNG BẰNG REGEX (TRÁNH DÙNG THƯ VIỆN NGOÀI)
        // ================================================================
        // SePay gửi JSON format chuẩn dạng:
        // {
        //   "id": 92704,
        //   "gateway": "Vietcombank",
        //   "transactionDate": "2024-07-02 11:08:33",
        //   "accountNumber": "1017588888",
        //   "code": "LMSPF5",                       <-- Mã thanh toán (SePay tự tách)
        //   "content": "LMSPF5 chuyen tien",         <-- Nội dung chuyển khoản gốc
        //   "transferType": "in",
        //   "transferAmount": 10000,                  <-- Số tiền chuyển
        //   "referenceCode": "FT24012345678"          <-- Mã giao dịch ngân hàng
        // }

        String content = extractJsonStringValue(jsonBody, "content");
        String code = extractJsonStringValue(jsonBody, "code");
        String transferAmountStr = extractJsonNumberValue(jsonBody, "transferAmount");
        String transactionRef = extractJsonStringValue(jsonBody, "referenceCode");

        LOGGER.info("SePay Webhook parsed — content: [" + content
                + "], code: [" + code
                + "], transferAmount: [" + transferAmountStr
                + "], referenceCode: [" + transactionRef + "]");

        // Chuyển đổi số tiền nhận được sang BigDecimal
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
            // Tài khoản ảo VA (Virtual Account) thường không gửi referenceCode
            // Ta tự tạo mã tham chiếu fallback duy nhất để tránh vi phạm khóa duy nhất UNIQUE trên DB
            transactionRef = "SEPAY-VA-" + System.currentTimeMillis();
            LOGGER.info("SePay Webhook: referenceCode rỗng, dùng fallback: " + transactionRef);
        }

        // ================================================================
        // BƯỚC 4: RÚT TRÍCH PAYMENT_ID TỪ NỘI DUNG CHUYỂN KHỎAN
        // ================================================================
        // Ưu tiên tìm trong "content" (nội dung gốc) và "code" (mã SePay tự tách)
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

        // ================================================================
        // BƯỚC 5: XỬ LÝ CẬP NHẬT CƠ SỞ DỮ LIỆU (DATABASE TRANSACTION)
        // ================================================================
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false); // Bắt đầu Transaction
            try {
                // Kiểm tra trạng thái Payment hiện tại trong DB
                String currentStatus = paymentDAO.getPaymentStatus(conn, paymentId);
                if (currentStatus == null) {
                    conn.rollback();
                    LOGGER.warning("SePay Webhook: paymentId=" + paymentId + " không tồn tại trong DB.");
                    out.print("{\"success\":false,\"message\":\"Payment not found\"}");
                    return;
                }

                // Nếu hóa đơn này đã được thanh toán trước đó rồi (Idempotency) -> Bỏ qua không xử lý lại
                if ("completed".equals(currentStatus)) {
                    conn.rollback();
                    LOGGER.info("SePay Webhook: paymentId=" + paymentId + " đã thanh toán trước đó - bỏ qua.");
                    out.print("{\"success\":true,\"message\":\"Payment already completed\"}");
                    return;
                }

                // Lấy khoản phạt Fine liên kết với Payment này
                int fineId = paymentDAO.findFineIdByPaymentId(conn, paymentId);
                if (fineId == -1) {
                    conn.rollback();
                    LOGGER.warning("SePay Webhook: Không tìm thấy fineId cho paymentId=" + paymentId);
                    out.print("{\"success\":false,\"message\":\"Fine not found for payment\"}");
                    return;
                }

                // ----------------------------------------------------------------
                // PHƯƠNG ÁN AN TOÀN NGHỆP VỤ: Kiểm tra sách đã được trả vật lý chưa
                // - Tiền đã nhận -> Luôn ghi nhận Payment = 'completed' (vì tiền thật đã vào TK ngân hàng).
                // - NẾU sách CHƯA TRẢ: Giữ nguyên Fine = 'unpaid', KHÔNG unlock tài khoản độc giả.
                //   Khi thủ thư nhận trả sách tại quầy (Check-in), hệ thống sẽ tự phát hiện Payment đã completed.
                // ----------------------------------------------------------------
                int borrowRecordId = fineDAO.findBorrowRecordIdByFineId(conn, fineId);
                boolean bookAlreadyReturned = true; // Mặc định true nếu khoản phạt không gắn với đơn mượn
                if (borrowRecordId != -1) {
                    String brStatus = borrowRecordDAO.findStatusById(conn, borrowRecordId);
                    bookAlreadyReturned = "returned".equals(brStatus)
                                      || "lost".equals(brStatus)
                                      || "damaged".equals(brStatus);
                }

                // Cập nhật trạng thái Payment -> 'completed' kèm số tiền và mã giao dịch ngân hàng
                paymentDAO.updatePaymentOnlineSuccess(conn, paymentId, transactionRef,
                        "BankTransfer", transferAmount);

                // Lấy ID độc giả từ khoản phạt
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
                    // Sách CHƯA trả -> Ghi log cảnh báo, không xóa nợ phạt, không unlock tài khoản
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

                // Trường hợp sách ĐÃ TRẢ: Cập nhật Fine -> 'paid'
                fineDAO.updateStatusToPaid(conn, fineId);

                // Xóa lý do khóa do nợ phạt ('unpaid') và tự động mở khóa tài khoản nếu không còn lý do khóa nào khác
                if (userId != -1) {
                    userLockReasonDAO.deleteLockReason(conn, userId, "unpaid");
                    int remainingReasons = userLockReasonDAO.countLockReasonsByUserId(conn, userId);
                    if (remainingReasons == 0) {
                        userDAO.updateStatusToActive(conn, userId); // Mở khóa tài khoản về 'active'
                    }
                }

                // Ghi Audit Log hoàn tất thanh toán thành công
                auditLogDAO.insert(conn, userId != -1 ? userId : null, "SEPAY_WEBHOOK_PAYMENT",
                        "Payment", paymentId, "{\"status\":\"pending\"}",
                        "{\"status\":\"completed\",\"transactionRef\":\"" + transactionRef
                        + "\",\"amount\":" + transferAmount + "}");

                conn.commit(); // Hoàn tất Transaction
                LOGGER.info("SePay Webhook: THÀNH CÔNG — paymentId="
                        + paymentId + ", fineId=" + fineId
                        + ", amount=" + transferAmount);

                // Gửi email xác nhận thanh toán thành công (Bất đồng bộ)
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
     * Áp dụng cho JSON phẳng (flat) gửi từ SePay Webhook.
     *
     * @param json Chuỗi JSON đầu vào
     * @param key  Tên trường cần lấy giá trị
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
     * Hỗ trợ cả số nguyên và số thực/thập phân.
     *
     * @param json Chuỗi JSON đầu vào
     * @param key  Tên trường cần lấy giá trị
     * @return Chuỗi chứa giá trị số hoặc null nếu không tìm thấy
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

