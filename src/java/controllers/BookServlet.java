package controllers;

import dao.BookCopyDAO;
import dao.BookDAO;
import dao.CategoryDAO;
import dao.TagDAO;
import exception.DatabaseException;
import exception.ValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Book;
import service.BookService;
import util.BookImageStorage;

@WebServlet(name = "BookServlet", urlPatterns = {
    "/librarian/book-management/titles",
    "/book-management/titles"
})
@MultipartConfig(maxFileSize = BookImageStorage.MAX_FILE_SIZE, maxRequestSize = BookImageStorage.MAX_FILE_SIZE + 1024 * 1024)
public class BookServlet extends HttpServlet {

    private static final int PAGE_SIZE = 20;
    /** Các tham số lọc/sắp xếp/phân trang cần giữ lại khi quay về danh sách. */
    private static final String[] LIST_FILTER_PARAMS = {"q", "categoryId", "tagId", "status", "sort", "page"};
    private static final Logger LOGGER = Logger.getLogger(BookServlet.class.getName());

    private final BookDAO bookDAO = new BookDAO();
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final TagDAO tagDAO = new TagDAO();
    private final BookService bookService = new BookService();
    private final BookImageStorage imageStorage = new BookImageStorage();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String role = (String) session.getAttribute("role");
        boolean canEdit = isEditor(role);

        String keyword = trimToNull(request.getParameter("q"));
        Integer categoryId = parseOptionalInt(request.getParameter("categoryId"));
        Integer tagId = parseOptionalInt(request.getParameter("tagId"));
        String status = normalizeStatus(request.getParameter("status"));
        String sort = normalizeSort(request.getParameter("sort"));
        int page = Math.max(1, parseInt(request.getParameter("page"), 1));

        try {
            int totalItems = bookDAO.count(keyword, categoryId, tagId, status);
            int totalPages = Math.max(1, (int) Math.ceil(totalItems / (double) PAGE_SIZE));
            page = Math.min(page, totalPages);

            List<Book> books = bookDAO.search(keyword, categoryId, tagId, status, sort,
                    (page - 1) * PAGE_SIZE, PAGE_SIZE);
            List<Integer> bookIds = new ArrayList<>();
            for (Book book : books) {
                bookIds.add(book.getBookId());
            }

            request.setAttribute("books", books);
            request.setAttribute("copiesByBookId", bookCopyDAO.findByBookIds(bookIds));
            request.setAttribute("summary", bookDAO.getSummary());
            request.setAttribute("categories", categoryDAO.findAll());
            request.setAttribute("tags", tagDAO.findAll());
            request.setAttribute("canEdit", canEdit);
            request.setAttribute("q", keyword == null ? "" : keyword);
            request.setAttribute("selectedCategoryId", categoryId);
            request.setAttribute("selectedTagId", tagId);
            request.setAttribute("selectedStatus", status);
            request.setAttribute("selectedSort", sort);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("pageSize", PAGE_SIZE);

            Integer editId = parseOptionalInt(request.getParameter("editId"));
            if (editId != null && canEdit) {
                request.setAttribute("editBook", bookDAO.findById(editId));
            }
            request.getRequestDispatcher("/librarian/book-titles.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải danh sách đầu sách.", e);
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
        String role = (String) session.getAttribute("role");
        if (!isEditor(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn chỉ có quyền xem dữ liệu đầu sách.");
            return;
        }

        String action = null;
        String newImagePath = null;
        String oldImagePath = null;
        boolean keepPage = true;
        try {
            action = request.getParameter("action");
            Book book = readBook(request, "update".equals(action));
            if ("update".equals(action)) {
                Book existing = bookDAO.findById(book.getBookId());
                if (existing == null) {
                    throw new ValidationException("Đầu sách không tồn tại.");
                }
                oldImagePath = existing.getImagePath();
            }
            newImagePath = imageStorage.save(request.getPart("imageFile"));
            book.setImagePath(newImagePath == null ? oldImagePath : newImagePath);
            int[] categoryIds = parseIds(request.getParameterValues("categoryIds"));
            int[] tagIds = parseIds(request.getParameterValues("tagIds"));
            int actorId = (Integer) session.getAttribute("userId");

            if ("create".equals(action)) {
                bookService.createBook(book, categoryIds, tagIds, actorId);
                session.setAttribute("successMessage", "Tạo đầu sách thành công.");
            } else if ("update".equals(action)) {
                bookService.updateBook(book, categoryIds, tagIds, actorId);
                session.setAttribute("successMessage", "Cập nhật đầu sách thành công.");
            } else {
                throw new ValidationException("Thao tác không hợp lệ.");
            }
            if (newImagePath != null && oldImagePath != null) {
                imageStorage.deleteQuietly(oldImagePath);
            }
            // Sau khi tạo mới thì bỏ số trang: đầu sách vừa tạo nằm ở trang đầu với
            // sắp xếp mặc định, giữ nguyên trang cũ sẽ khiến thủ thư không thấy nó.
            keepPage = !"create".equals(action);
        } catch (ValidationException e) {
            imageStorage.deleteQuietly(newImagePath);
            session.setAttribute("errorMessage", e.getMessage());
        } catch (DatabaseException | SQLException | NumberFormatException | IllegalStateException | IOException e) {
            imageStorage.deleteQuietly(newImagePath);
            LOGGER.log(Level.SEVERE, "Không thể lưu đầu sách.", e);
            session.setAttribute("errorMessage", "Không thể lưu đầu sách. Vui lòng kiểm tra dữ liệu và thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/librarian/book-management/titles"
                + buildListQuery(request, keepPage));
    }

    /**
     * Dựng lại query string của danh sách từ chính request đang xử lý.
     *
     * <p>Form gửi lên {@code listUrl} đã mang sẵn bộ lọc trong query string, nên sau khi lưu
     * ta chỉ cần chép lại để đưa thủ thư về đúng trang, đúng bộ lọc đã áp dụng.</p>
     *
     * <p>Giá trị được URL-encode nên không thể chèn ký tự xuống dòng vào header redirect.</p>
     */
    private String buildListQuery(HttpServletRequest request, boolean keepPage) {
        StringBuilder query = new StringBuilder();
        for (String name : LIST_FILTER_PARAMS) {
            if (!keepPage && "page".equals(name)) {
                continue;
            }
            String value = trimToNull(request.getParameter(name));
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

    private Book readBook(HttpServletRequest request, boolean updating) {
        Book book = new Book();
        if (updating) {
            book.setBookId(Integer.parseInt(request.getParameter("bookId")));
        }
        book.setIsbn(trimToNull(request.getParameter("isbn")));
        book.setTitle(trimToNull(request.getParameter("title")));
        book.setAuthor(trimToNull(request.getParameter("author")));
        book.setPublisher(trimToNull(request.getParameter("publisher")));
        book.setPublicationYear(parseOptionalInt(request.getParameter("publicationYear")));
        String price = trimToNull(request.getParameter("price"));
        book.setPrice(price == null ? null : new BigDecimal(stripGroupingSeparators(price)));
        book.setStatus(normalizeBookStatus(request.getParameter("bookStatus")));
        return book;
    }

    /**
     * Gỡ dấu chấm phân cách hàng nghìn khỏi giá sách trước khi chuyển sang {@link BigDecimal}.
     *
     * <p>Ô nhập giá hiển thị dạng "1.300.000" cho dễ đọc và JavaScript đã gỡ dấu chấm trước
     * khi submit; hàm này chỉ là lớp phòng vệ khi JavaScript không chạy.</p>
     *
     * <p>Chỉ gỡ khi chuỗi đúng dạng nhóm ba chữ số, nên giá trị có phần thập phân như
     * "1300000.00" được giữ nguyên chứ không bị hiểu nhầm thành 130000000.</p>
     */
    private String stripGroupingSeparators(String value) {
        return value.matches("\\d{1,3}(\\.\\d{3})+") ? value.replace(".", "") : value;
    }

    private int[] parseIds(String[] values) {
        if (values == null) {
            return new int[0];
        }
        int[] ids = new int[values.length];
        for (int i = 0; i < values.length; i++) {
            ids[i] = Integer.parseInt(values[i]);
        }
        return ids;
    }

    private boolean isEditor(String role) {
        return "LIBRARIAN".equalsIgnoreCase(role);
    }

    private String normalizeStatus(String status) {
        return "available".equals(status) || "unavailable".equals(status) || "noCopies".equals(status)
                ? status : "";
    }

    private String normalizeSort(String sort) {
        return "title_asc".equals(sort) || "title_desc".equals(sort)
                || "available_desc".equals(sort) || "available_asc".equals(sort)
                || "published_desc".equals(sort) || "published_asc".equals(sort)
                ? sort : "updated_desc";
    }

    private String normalizeBookStatus(String status) {
        return "unavailable".equals(status) ? "unavailable" : "available";
    }

    private Integer parseOptionalInt(String value) {
        String normalized = trimToNull(value);
        if (normalized == null) {
            return null;
        }
        try {
            return Integer.valueOf(normalized);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return value.trim();
    }
}
