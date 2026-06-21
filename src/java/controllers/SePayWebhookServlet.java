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
 *   <li>Xác thực Header {@code Authorization: Apikey <token>} so khớp với cấu hình DB.</li>
 *   <li>Parse JSON body thủ công (không dùng Gson): lấy {@code content} và {@code transferAmount}.</li>
 *   <li>Trích xuất mã hóa đơn {@code LMSPF<paymentId>} từ {@code content} bằng Regex.</li>
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // 1. Xác thực API Key từ SePay
        String authHeader = request.getHeader("Authorization");
        String configuredApiKey = systemConfigDAO.getValue("SEPAY_API_KEY", "");

        if (configuredApiKey.isEmpty()) {
            LOGGER.warning("SEPAY_API_KEY chưa được cấu hình trong SystemConfigurations.");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Server configuration error\"}");
            return;
        }

        if (authHeader == null || !authHeader.contains(configuredApiKey)) {
            LOGGER.warning("SePay Webhook: Xác thực API Key thất bại. Header nhận được: " + authHeader);
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"message\":\"Unauthorized\"}");
            return;
        }

        // 2. Đọc JSON body
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        String jsonBody = sb.toString();
        LOGGER.info("SePay Webhook body received: " + jsonBody);

        // 3. Parse JSON thủ công (không dùng Gson vì không có trong allowed libs)
        String content = extractJsonStringValue(jsonBody, "content");
        String transferAmountStr = extractJsonNumberValue(jsonBody, "transferAmount");
        String transactionRef = extractJsonStringValue(jsonBody, "referenceCode");

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
        if (transactionRef == null) {
            transactionRef = "";
        }

        // 4. Tìm paymentId từ nội dung chuyển khoản
        Matcher matcher = PAYMENT_CODE_PATTERN.matcher(content);
        if (!matcher.find()) {
            LOGGER.info("SePay Webhook: Không tìm thấy mã LMSPF trong nội dung: " + content);
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

        // 5. Xử lý cập nhật DB trong Transaction
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Kiểm tra trạng thái hiện tại
                String currentStatus = paymentDAO.getPaymentStatus(conn, paymentId);
                if (currentStatus == null) {
                    conn.rollback();
                    LOGGER.warning("SePay Webhook: paymentId=" + paymentId + " không tồn tại.");
                    out.print("{\"success\":false,\"message\":\"Payment not found\"}");
                    return;
                }

                if ("completed".equals(currentStatus)) {
                    conn.rollback();
                    LOGGER.info("SePay Webhook: paymentId=" + paymentId + " đã được thanh toán trước đó.");
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

                // Cập nhật Payment -> completed
                paymentDAO.updatePaymentOnlineSuccess(conn, paymentId, transactionRef,
                        "BankTransfer", transferAmount);

                // Cập nhật Fine -> paid
                fineDAO.updateStatusToPaid(conn, fineId);

                // Ghi Audit Log
                auditLogDAO.insert(conn, null, "SEPAY_WEBHOOK_PAYMENT",
                        "Payment", paymentId, "{\"status\":\"pending\"}",
                        "{\"status\":\"completed\",\"transactionRef\":\"" + transactionRef
                        + "\",\"amount\":" + transferAmount + "}");

                conn.commit();
                LOGGER.info("SePay Webhook: Thanh toán thành công paymentId="
                        + paymentId + ", fineId=" + fineId);

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
     * Áp dụng cho JSON phẳng (flat) từ SePay webhook.
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
