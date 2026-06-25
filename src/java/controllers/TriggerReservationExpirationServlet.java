package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.ReservationExpirationProcessor;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * TriggerReservationExpirationServlet - Cho phép Admin kích hoạt quy trình quét quá hạn nhận sách thủ công.
 */
@WebServlet(name = "TriggerReservationExpirationServlet", urlPatterns = {"/admin/trigger-reservation-expiration"})
public class TriggerReservationExpirationServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TriggerReservationExpirationServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        // 1. Phân quyền và bảo mật: Kiểm tra role ADMIN (được kết hợp kiểm tra từ AuthFilter)
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

        LOGGER.log(Level.INFO, "Admin ID={0} kích hoạt quy trình hủy đặt trước quá hạn nhận sách thủ công.", userId);

        try {
            // 2. Chạy quy trình đồng bộ
            ReservationExpirationProcessor processor = new ReservationExpirationProcessor();
            ReservationExpirationProcessor.ProcessResult result = processor.processExpiration();

            // 3. Trả về kết quả JSON tiếng Việt
            try (PrintWriter out = response.getWriter()) {
                out.print(String.format(
                    "{\"success\":true,\"message\":\"Đã dọn dẹp xong. Hủy %d đơn quá hạn, đôn %d độc giả xếp hàng tiếp theo lên.\",\"cancelled\":%d,\"promoted\":%d}",
                    result.cancelledCount, result.promotedCount, result.cancelledCount, result.promotedCount
                ));
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi chạy dọn dẹp thủ công", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"success\":false,\"message\":\"Đã xảy ra lỗi hệ thống khi xử lý dọn dẹp.\"}");
            }
        }
    }
}
