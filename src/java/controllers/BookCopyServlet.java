package controllers;

import dao.BookCopyDAO;
import dao.BookDAO;
import exception.DatabaseException;
import exception.ValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.BookCopy;
import service.BookCopyService;
import util.DatabaseConnection;

@WebServlet(name = "BookCopyServlet", urlPatterns = {
    "/librarian/book-management/copies",
    "/book-management/copies"
})
public class BookCopyServlet extends HttpServlet {

    private static final int PAGE_SIZE = 20;
    /** Các tham số lọc/phân trang cần giữ lại khi quay về danh sách. */
    private static final String[] LIST_FILTER_PARAMS = {"q", "location", "status", "page"};
    private static final Logger LOGGER = Logger.getLogger(BookCopyServlet.class.getName());
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final BookCopyService bookCopyService = new BookCopyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        boolean canEdit = isEditor((String) session.getAttribute("role"));
        String keyword = trimToNull(request.getParameter("q"));
        String location = trimToNull(request.getParameter("location"));
        String status = normalizeStatus(request.getParameter("status"));
        int page = Math.max(1, parseInt(request.getParameter("page"), 1));
        try {
            int totalItems = bookCopyDAO.count(keyword, location, status);
            int totalPages = Math.max(1, (int) Math.ceil(totalItems / (double) PAGE_SIZE));
            page = Math.min(page, totalPages);
            request.setAttribute("copies", bookCopyDAO.search(keyword, location, status,
                    (page - 1) * PAGE_SIZE, PAGE_SIZE));
            request.setAttribute("summary", bookCopyDAO.getSummary());
            request.setAttribute("locations", bookCopyDAO.findLocations());
            request.setAttribute("books", bookDAO.findAllForSelection());
            request.setAttribute("canEdit", canEdit);
            request.setAttribute("q", keyword == null ? "" : keyword);
            request.setAttribute("selectedLocation", location == null ? "" : location);
            request.setAttribute("selectedStatus", status == null ? "" : status);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("pageSize", PAGE_SIZE);

            Integer editId = parseOptionalInt(request.getParameter("editId"));
            if (canEdit && editId != null) {
                try (Connection conn = DatabaseConnection.getConnection()) {
                    request.setAttribute("editCopy", bookCopyDAO.findById(conn, editId));
                }
            }
            request.getRequestDispatcher("/librarian/book-copies.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải danh sách bản sao.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!isEditor((String) session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn chỉ có quyền xem kho vật lý.");
            return;
        }
        boolean keepPage = true;
        try {
            String action = request.getParameter("action");
            int actorId = (Integer) session.getAttribute("userId");
            if ("create".equals(action)) {
                bookCopyService.create(readCreateCopy(request), actorId);
                // Bản sao vừa tạo nằm ở trang đầu theo sắp xếp mặc định nên bỏ số trang cũ.
                keepPage = false;
                session.setAttribute("successMessage", "Thêm bản sao và đồng bộ tồn kho thành công.");
            } else if ("update".equals(action)) {
                bookCopyService.update(readUpdateCopy(request), actorId);
                session.setAttribute("successMessage", "Cập nhật bản sao và đồng bộ tồn kho thành công.");
            } else {
                throw new ValidationException("Thao tác không hợp lệ.");
            }
        } catch (ValidationException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (DatabaseException | NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Không thể lưu bản sao.", e);
            session.setAttribute("errorMessage", "Không thể lưu bản sao. Vui lòng kiểm tra dữ liệu và thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/librarian/book-management/copies"
                + buildListQuery(request, keepPage));
    }

    /**
     * Dựng lại query string của danh sách từ chính request đang xử lý, để sau khi lưu
     * thủ thư quay về đúng trang và đúng bộ lọc đã áp dụng.
     *
     * <p>Giá trị được URL-encode nên không thể chèn ký tự xuống dòng vào header redirect.</p>
     */
    private String buildListQuery(HttpServletRequest request, boolean keepPage) {
        StringBuilder query = new StringBuilder();
        for (String name : LIST_FILTER_PARAMS) {
            if (!keepPage && "page".equals(name)) {
                continue;
            }
            String value = trimToNull("location".equals(name)
                    ? request.getParameter("filterLocation")
                    : request.getParameter(name));
            if (value == null) {
                continue;
            }
            query.append(query.length() == 0 ? '?' : '&')
                    .append(name)
                    .append('=')
                    .append(URLEncoder.encode(value, StandardCharsets.UTF_8));
        }
        return query.toString();
    }

    private BookCopy readCreateCopy(HttpServletRequest request) {
        BookCopy copy = new BookCopy();
        copy.setBookId(Integer.parseInt(request.getParameter("bookId")));
        copy.setBarcode(trimToNull(request.getParameter("barcode")));
        copy.setLocation(readCopyLocation(request));
        return copy;
    }

    private BookCopy readUpdateCopy(HttpServletRequest request) {
        BookCopy copy = new BookCopy();
        copy.setBookCopyId(Integer.parseInt(request.getParameter("bookCopyId")));
        copy.setLocation(readCopyLocation(request));
        return copy;
    }

    private String readCopyLocation(HttpServletRequest request) {
        String location = trimToNull(request.getParameter("copyLocation"));
        return location == null ? trimToNull(request.getParameter("location")) : location;
    }

    private boolean isEditor(String role) {
        return "LIBRARIAN".equalsIgnoreCase(role);
    }

    private String normalizeStatus(String status) {
        return "available".equals(status) || "borrowed".equals(status)
                || "unavailable".equals(status)
                || "incident".equals(status) ? status : null;
    }

    private Integer parseOptionalInt(String value) {
        try {
            return value == null || value.isBlank() ? null : Integer.valueOf(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private int parseInt(String value, int fallback) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return fallback;
        }
    }

    private String trimToNull(String value) {
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }
}
