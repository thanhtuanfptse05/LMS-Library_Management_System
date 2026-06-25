package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.OverdueProcessor;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * TriggerOverdueServlet - Cho phép Admin kích hoạt quy trình quét và phạt quá hạn trả sách thủ công.
 */
@WebServlet(name = "TriggerOverdueServlet", urlPatterns = {"/admin/trigger-overdue"})
public class TriggerOverdueServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TriggerOverdueServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        // 1. Phân quyền và bảo mật: Kiểm tra role ADMIN
        HttpSession session = request.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        if (userId == null || !"ADMIN".equalsIgnoreCase(role)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"success\":false,\"message\":\"Bạn không có quyền thực hiện hành động này.\"}");
            }
            return;
        }

        LOGGER.log(Level.INFO, "Admin ID={0} kích hoạt quy trình quét quá hạn trả sách thủ công.", userId);

        try {
            // 2. Chạy quy trình quét quá hạn
            OverdueProcessor processor = new OverdueProcessor();
            OverdueProcessor.OverdueResult result = processor.processOverdue();

            // 3. Trả về kết quả JSON tiếng Việt
            try (PrintWriter out = response.getWriter()) {
                out.print(String.format(
                    "{\"success\":true,\"message\":\"Quét quá hạn thành công! Đã xử lý %d lượt mượn trễ hạn, khóa thêm %d tài khoản và gửi %d email thông báo.\",\"processedRecords\":%d,\"lockedUsers\":%d,\"emailsSent\":%d}",
                    result.processedRecords, result.lockedUsers, result.emailsSent,
                    result.processedRecords, result.lockedUsers, result.emailsSent
                ));
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi chạy quét quá hạn thủ công", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"success\":false,\"message\":\"Đã xảy ra lỗi hệ thống khi quét quá hạn.\"}");
            }
        }
    }
}
