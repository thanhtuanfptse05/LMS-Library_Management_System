package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import service.DeskCirculationService;
import util.DatabaseConnection;

/**
 * CashPaymentServlet — Controller xử lý luồng Duyệt Thanh Toán Tiền Mặt.
 *
 * <p>Tuân thủ Single Responsibility Principle: Servlet này CHỈ xử lý luồng
 * thanh toán tiền mặt (Cash Payment). Mọi logic nghiệp vụ và SQL được ủy
 * quyền cho {@code DeskCirculationService.approveCashPayment()}.</p>
 *
 * <p>Flow:
 * <ul>
 *   <li>{@code GET /librarian/cash-payment} → forward tới {@code desk-payment.jsp}</li>
 *   <li>{@code POST /librarian/cash-payment} → gọi Service → flash message → redirect GET</li>
 * </ul></p>
 *
 * <p>Traceability: FR-F6-07, FR-F6-08, BR-25, PLAN.md §2.</p>
 */
@WebServlet(name = "CashPaymentServlet", urlPatterns = {"/librarian/cash-payment"})
public class CashPaymentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CashPaymentServlet.class.getName());

    private DeskCirculationService service;

    @Override
    public void init() throws ServletException {
        this.service = new DeskCirculationService();
    }

    /**
     * GET /librarian/cash-payment — Chuyển hướng về Bảng điều khiển quầy.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorized(request, response)) return;
        response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard");
    }

    /**
     * POST /librarian/cash-payment — Xử lý Duyệt Thanh Toán (PRG pattern).
     *
     * <p>Đọc {@code paymentId} và {@code userId} từ form. Service sẽ thực thi
     * toàn bộ 5 bước BR-25 trong một DB Transaction nguyên tử.</p>
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8"); 

        if (!isAuthorized(request, response)) return;

        HttpSession session = request.getSession(false);
        int librarianId = (int) session.getAttribute("userId");

        // [LAZY LOAD] Quét nợ phạt quá hạn mới nhất trước khi xử lý thu tiền mặt
        try {
            new service.OverdueProcessor().processOverdue();
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "[LAZY LOAD] Lỗi khi quét nợ phạt trên CashPaymentServlet", e);
        }

        String memberCodeParam = request.getParameter("memberCode");
        String memberCode = (memberCodeParam != null) ? memberCodeParam.trim() : "";

        try {
            // ----------------------------------------------------------------
            // Validate đầu vào
            // ----------------------------------------------------------------
            String paymentIdRaw = request.getParameter("paymentId");

            if (paymentIdRaw == null || paymentIdRaw.isBlank()) {
                session.setAttribute("errorMessage", "Vui lòng nhập mã phiếu thanh toán.");
                response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCode);
                return;
            }
            if (memberCode.isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng nhập mã số độc giả.");
                response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCode);
                return;
            }

            int paymentId = Integer.parseInt(paymentIdRaw.trim());

            // Ánh xạ memberCode sang userId
            Integer userId = null;
            try (Connection conn = DatabaseConnection.getConnection()) {
                userId = new dao.UserLookupDAO().findUserIdByMemberCode(conn, memberCode);
            }

            if (userId == null) {
                session.setAttribute("errorMessage", "Mã số độc giả '" + memberCode + "' không tồn tại trong hệ thống.");
                response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCode);
                return;
            }

            // ----------------------------------------------------------------
            // Gọi Service — BR-25 Auto-unlock
            // ----------------------------------------------------------------
            service.approveCashPayment(librarianId, paymentId, userId);

            session.setAttribute("successMessage",
                    "Duyệt thanh toán thành công! Phiếu #" + paymentId
                    + " — Độc giả: " + memberCode + ". Trạng thái tài khoản đã được cập nhật tự động.");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage",
                    "Mã phiếu thanh toán hoặc mã người dùng không hợp lệ — vui lòng nhập số nguyên.");

        } catch (IllegalStateException e) {
            // Lỗi nghiệp vụ: paymentId không tồn tại
            session.setAttribute("errorMessage", e.getMessage());

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL trong CashPaymentServlet.doPost", e);
            session.setAttribute("errorMessage",
                    "Đã xảy ra lỗi hệ thống khi xử lý thanh toán. Vui lòng thử lại hoặc liên hệ quản trị viên.");
        }

        response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCode);
    }

    private boolean isAuthorized(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null
                || session.getAttribute("userId") == null
                || !"LIBRARIAN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
