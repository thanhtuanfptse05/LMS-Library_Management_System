package controllers;

import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Notification;

/**
 * PublicNewsServlet — Servlet hiển thị trang Tin tức & Sự kiện công khai.
 *
 * <p>URL Pattern: /news</p>
 * <p>Quyền truy cập: Công khai (không yêu cầu đăng nhập).</p>
 *
 * <p>Luồng xử lý:</p>
 * <ul>
 *   <li>GET /news            : Danh sách tất cả tin tức công khai (type=general/event), có phân trang.</li>
 *   <li>GET /news?type=event : Lọc theo tab (general hoặc event).</li>
 *   <li>GET /news?id=123     : Trang chi tiết một bài tin tức.</li>
 * </ul>
 *
 * <p>Chỉ hiển thị thông báo có type IN ('general','event').
 * Thông báo type 'urgent' và 'policy' chỉ hiện trên bảng tin nội bộ.</p>
 */
@WebServlet(name = "PublicNewsServlet", urlPatterns = {"/news"})
public class PublicNewsServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PublicNewsServlet.class.getName());
    private static final int PAGE_SIZE = 9; // 3x3 grid

    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            // Trang chi tiet bai tin tuc
            handleDetail(request, response, idParam.trim());
        } else {
            // Danh sach tin tuc
            handleList(request, response);
        }
    }

    /**
     * Hiển thị danh sách tin tức công khai có phân trang và lọc theo tab.
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String typeFilter = request.getParameter("type"); // "general" | "event" | null

        // Chi chap nhan gia tri hop le, reject type khac (urgent, policy)
        if (typeFilter != null && !typeFilter.equals("general") && !typeFilter.equals("event")) {
            typeFilter = null;
        }

        int page = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                page = Math.max(1, Integer.parseInt(pageParam.trim()));
            }
        } catch (NumberFormatException ignored) {
            LOGGER.log(Level.FINE, "Invalid page parameter, defaulting to 1");
        }

        int totalCount = notificationDAO.countPublicNews(typeFilter);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / PAGE_SIZE);
        page = Math.min(page, totalPages);

        List<Notification> newsList = notificationDAO.getPublicNewsPaged(typeFilter, page, PAGE_SIZE);

        request.setAttribute("newsList", newsList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("activeType", typeFilter != null ? typeFilter : "");

        request.getRequestDispatcher("/news.jsp").forward(request, response);
    }

    /**
     * Hiển thị trang chi tiết một bài tin tức.
     */
    private void handleDetail(HttpServletRequest request, HttpServletResponse response, String idParam)
            throws ServletException, IOException {

        try {
            int notificationId = Integer.parseInt(idParam);
            Notification detail = notificationDAO.findById(notificationId);

            if (detail == null
                    || (!detail.getType().equals("general") && !detail.getType().equals("event"))) {
                // Khong tim thay hoac la thong bao noi bo (urgent/policy) — khong cho xem cong khai
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Khong tim thay bai tin tuc");
                return;
            }

            // Lay 4 bai lien quan cung type (tru bai hien tai)
            List<Notification> related = notificationDAO.getPublicNewsPaged(detail.getType(), 1, 5);
            related.removeIf(n -> n.getNotificationId() == notificationId);
            if (related.size() > 4) {
                related = related.subList(0, 4);
            }

            request.setAttribute("newsDetail", detail);
            request.setAttribute("relatedNews", related);
            request.getRequestDispatcher("/news-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID khong hop le");
        }
    }
}
