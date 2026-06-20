package controllers;

import dao.PaymentDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.DatabaseConnection;

/**
 * PaymentApiServlet — API JSON trả về trạng thái thanh toán (AJAX Polling).
 *
 * <p>Route: {@code /api/payment-status} (GET)</p>
 * <p>Giao diện độc giả gọi endpoint này mỗi 3 giây sau khi mở Modal QR
 * để kiểm tra xem SePay Webhook đã cập nhật Payment thành 'completed' chưa.</p>
 */
@WebServlet(name = "PaymentApiServlet", urlPatterns = {"/api/payment-status"})
public class PaymentApiServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PaymentApiServlet.class.getName());
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        PrintWriter out = response.getWriter();

        // Kiểm tra session — chỉ cho phép người dùng đã đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\":\"Unauthorized\"}");
            return;
        }

        String paymentIdStr = request.getParameter("paymentId");
        if (paymentIdStr == null || paymentIdStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Missing paymentId\"}");
            return;
        }

        int paymentId;
        try {
            paymentId = Integer.parseInt(paymentIdStr.trim());
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid paymentId\"}");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            String status = paymentDAO.getPaymentStatus(conn, paymentId);
            if (status == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\":\"Payment not found\"}");
            } else {
                out.print("{\"paymentId\":" + paymentId + ",\"status\":\"" + status + "\"}");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy trạng thái Payment paymentId=" + paymentId, e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Internal server error\"}");
        }
    }
}
