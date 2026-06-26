package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import service.DeskCirculationService;

/**
 * CheckOutServlet — Controller xử lý luồng Giao Sách (Check-out) tại quầy.
 *
 * <p>Tuân thủ Single Responsibility Principle: Servlet này CHỈ xử lý luồng
 * Check-out. Mọi logic nghiệp vụ và SQL được ủy quyền hoàn toàn cho
 * {@code DeskCirculationService.processCheckOut()}.</p>
 *
 * <p>Flow:
 * <ul>
 *   <li>{@code GET /librarian/checkout} → forward tới {@code desk-checkout.jsp}</li>
 *   <li>{@code POST /librarian/checkout} → gọi Service → flash message → redirect GET</li>
 * </ul></p>
 *
 * <p>Phân quyền: Chỉ LIBRARIAN có phiên đăng nhập hợp lệ mới được truy cập.
 * Các role khác bị redirect về trang đăng nhập.</p>
 *
 * <p>Traceability: FR-F6-01 đến FR-F6-03, PLAN.md §2 (Controller Layer).</p>
 */
@WebServlet(name = "CheckOutServlet", urlPatterns = {"/librarian/checkout"})
public class CheckOutServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CheckOutServlet.class.getName());

    /** View path — tương đối với web root */
    private static final String VIEW_PATH    = "/librarian/desk-checkout.jsp";
    /** Redirect path sau POST (PRG pattern) */
    private static final String REDIRECT_URL = "/librarian/checkout";

    private DeskCirculationService service;

    @Override
    public void init() throws ServletException {
        this.service = new DeskCirculationService();
    }

    /**
     * GET /librarian/checkout — Hiển thị form Giao Sách.
     * Đọc flash messages từ session (nếu có) và forward tới JSP.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorized(request, response)) return;
        request.getRequestDispatcher(VIEW_PATH).forward(request, response);
    }

    /**
     * POST /librarian/checkout — Xử lý form Giao Sách (PRG pattern).
     *
     * <p>Đọc {@code userId} và {@code barcode} từ form. Gọi Service trong
     * một try-catch phân loại lỗi:
     * <ul>
     *   <li>{@code IllegalStateException}: Lỗi nghiệp vụ (barcode không tồn tại,
     *       nợ phạt, hàng chờ...) → hiển thị thông báo lỗi thân thiện.</li>
     *   <li>{@code NumberFormatException}: userId không phải số → thông báo lỗi nhập liệu.</li>
     *   <li>{@code SQLException}: Lỗi hạ tầng DB → thông báo lỗi hệ thống chung.</li>
     * </ul></p>
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorized(request, response)) return;

        HttpSession session = request.getSession(false);
        int librarianId = (int) session.getAttribute("userId");

        try {
            // ----------------------------------------------------------------
            // Đọc và validate tham số đầu vào từ form
            // ----------------------------------------------------------------
            String barcodeRaw = request.getParameter("barcode");
            String memberCodeRaw  = request.getParameter("memberCode");

            if (barcodeRaw == null || barcodeRaw.isBlank()) {
                session.setAttribute("errorMessage", "Vui lòng nhập mã vạch sách.");
                response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard");
                return;
            }
            if (memberCodeRaw == null || memberCodeRaw.isBlank()) {
                session.setAttribute("errorMessage", "Vui lòng nhập mã số độc giả.");
                response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard");
                return;
            }

            String memberCode = memberCodeRaw.trim();
            String barcode = barcodeRaw.trim();

            String targetBookIdRaw = request.getParameter("targetBookId");
            Integer targetBookId = null;
            if (targetBookIdRaw != null && !targetBookIdRaw.isBlank()) {
                try {
                    targetBookId = Integer.parseInt(targetBookIdRaw.trim());
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid targetBookId format: {0}", targetBookIdRaw);
                }
            }

            // ----------------------------------------------------------------
            // Gọi Service — toàn bộ logic nghiệp vụ nằm ở tầng này
            // ----------------------------------------------------------------
            service.processCheckOut(librarianId, memberCode, barcode, targetBookId);

            session.setAttribute("successMessage",
                    "Giao sách thành công! Mã vạch: " + barcode + " — Độc giả: " + memberCode + ".");

            response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCode);
            return;

        } catch (IllegalStateException e) {
            // Lỗi nghiệp vụ từ Service (BR-22, BR-23, barcode không tồn tại...)
            session.setAttribute("errorMessage", e.getMessage());

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL trong CheckOutServlet.doPost", e);
            session.setAttribute("errorMessage",
                    "Đã xảy ra lỗi hệ thống khi xử lý giao sách. Vui lòng thử lại hoặc liên hệ quản trị viên.");
        }

        // PRG: luôn redirect sau POST về Dashboard của độc giả
        String memberCodeParam = request.getParameter("memberCode");
        if (memberCodeParam != null && !memberCodeParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCodeParam.trim());
        } else {
            response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard");
        }
    }

    /**
     * Kiểm tra phiên đăng nhập và phân quyền LIBRARIAN.
     *
     * @return {@code true} nếu hợp lệ; {@code false} và đã redirect nếu không
     */
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
