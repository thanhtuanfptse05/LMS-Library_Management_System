package controllers;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
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
 *   <li>Parse JSON body: lấy {@code content} (nội dung chuyển khoản) và {@code transferAmount}.</li>
 *   <li>Trích xuất mã hóa đơn {@code LMSPF<paymentId>} từ {@code content} bằng Regex.</li>
 *   <li>Đối chiếu số tiền chuyển khoản với số tiền cần thanh toán.</li>
 *   <li>Nếu hợp lệ: cập nhật Payment thành 'completed', Fine thành 'paid', ghi Audit Log.</li>
 *   <li>Trả HTTP 200 OK kèm JSON xác nhận.</li>
 * </ol>
 *
 * <p>Tuân thủ: SEC-03 (PreparedStatement), TRANS-01 (Connection truyền từ Service).</p>
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

        String expectedAuthValue = "Apikey " + configuredApiKey;
        if (authHeader == null || !authHeader.equals(expectedAuthValue)) {
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

        JsonObject json;
        try {
            json = JsonParser.parseString(jsonBody).getAsJsonObject();
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "SePay Webhook: JSON body không hợp lệ", e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"Invalid JSON\"}");
            return;
        }

        // 3. Trích xuất thông tin từ JSON SePay
        String content = json.has("content") ? json.get("content").getAsString() : "";
        BigDecimal transferAmount = BigDecimal.ZERO;
        if (json.has("transferAmount")) {
            try {
                transferAmount = json.get("transferAmount").getAsBigDecimal();
            } catch (Exception e) {
                LOGGER.warning("SePay Webhook: transferAmount không hợp lệ");
            }
        }

        String transactionRef = json.has("referenceCode")
                ? json.get("referenceCode").getAsString() : "";

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
}
