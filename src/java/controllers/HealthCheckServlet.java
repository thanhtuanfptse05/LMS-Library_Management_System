package controllers;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * HealthCheckServlet — Endpoint kiểm tra trạng thái hoạt động của ứng dụng.
 *
 * <p>Route: {@code /health} (GET) — Public, không yêu cầu xác thực.</p>
 *
 * <p>Dùng bởi UptimeRobot hoặc bất kỳ monitoring service nào để ping ứng dụng
 * mỗi 5 phút, tránh Render Free tier tự động sleep sau 15 phút không hoạt động.
 * Điều này đảm bảo SePay Webhook luôn kết nối được khi có giao dịch thanh toán.</p>
 */
@WebServlet(name = "HealthCheckServlet", urlPatterns = {"/health"})
public class HealthCheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().print("{\"status\":\"ok\",\"service\":\"LMS-Library Management System\"}");
    }
}
