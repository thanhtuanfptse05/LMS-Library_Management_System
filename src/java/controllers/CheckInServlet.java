package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import service.DeskCirculationService;

/**
 * CheckInServlet — Controller xử lý luồng Nhận Sách (Check-in) tại quầy.
 *
 * <p>Tuân thủ Single Responsibility Principle: Servlet này CHỈ xử lý luồng
 * Check-in. Mọi logic nghiệp vụ và SQL được ủy quyền cho
 * {@code DeskCirculationService.processCheckIn()}.</p>
 *
 * <p>Flow:
 * <ul>
 *   <li>{@code GET /librarian/checkin} → forward tới {@code desk-checkin.jsp}</li>
 *   <li>{@code POST /librarian/checkin} → gọi Service → flash message → redirect GET</li>
 * </ul></p>
 *
 * <p>Traceability: FR-F6-04 đến FR-F6-06, PLAN.md §2.</p>
 */
@WebServlet(name = "CheckInServlet", urlPatterns = {"/librarian/checkin"})
public class CheckInServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CheckInServlet.class.getName());

    private static final String VIEW_PATH    = "/librarian/desk-checkin.jsp";
    private static final String REDIRECT_URL = "/librarian/checkin";

    /** Tập hợp giá trị condition hợp lệ — whitelist phòng SQL Injection qua giá trị lạ */
    private static final Set<String> VALID_CONDITIONS = Set.of("good", "damaged", "lost");

    private DeskCirculationService service;

    @Override
    public void init() throws ServletException {
        this.service = new DeskCirculationService();
    }

    /**
     * GET /librarian/checkin — Hiển thị form Nhận Sách.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorized(request, response)) return;
        request.getRequestDispatcher(VIEW_PATH).forward(request, response);
    }

    /**
     * POST /librarian/checkin — Xử lý form Nhận Sách (PRG pattern).
     *
     * <p>Đọc {@code barcode} và {@code condition} từ form. Whitelist validation
     * cho condition trước khi gọi Service để bắt lỗi nhập liệu sớm.</p>
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorized(request, response)) return;

        HttpSession session = request.getSession(false);
        int librarianId = (int) session.getAttribute("userId");

        String memberCodeParam = request.getParameter("memberCode");
        String memberCode = (memberCodeParam != null) ? memberCodeParam.trim() : "";

        try {
            // ----------------------------------------------------------------
            // Validate đầu vào
            // ----------------------------------------------------------------
            String barcodeRaw   = request.getParameter("barcode");
            String conditionRaw = request.getParameter("condition");

            if (barcodeRaw == null || barcodeRaw.isBlank()) {
                session.setAttribute("errorMessage", "Vui lòng nhập mã vạch sách.");
                response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCode);
                return;
            }
            if (conditionRaw == null || !VALID_CONDITIONS.contains(conditionRaw)) {
                session.setAttribute("errorMessage",
                        "Tình trạng sách không hợp lệ. Vui lòng chọn: Tốt, Hỏng hoặc Mất.");
                response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCode);
                return;
            }

            String barcode   = barcodeRaw.trim();
            String condition = conditionRaw; // đã whitelist, an toàn

            // ----------------------------------------------------------------
            // Gọi Service
            // ----------------------------------------------------------------
            service.processCheckIn(librarianId, barcode, condition);

            String conditionLabel = switch (condition) {
                case "damaged" -> "Hỏng";
                case "lost"    -> "Mất";
                default        -> "Tốt";
            };
            session.setAttribute("successMessage",
                    "Nhận sách thành công! Mã vạch: " + barcode
                    + " — Tình trạng: " + conditionLabel + ".");

        } catch (IllegalStateException e) {
            session.setAttribute("errorMessage", e.getMessage());

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi SQL trong CheckInServlet.doPost", e);
            session.setAttribute("errorMessage",
                    "Đã xảy ra lỗi hệ thống khi xử lý nhận sách. Chi tiết: " + e.getMessage());
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
