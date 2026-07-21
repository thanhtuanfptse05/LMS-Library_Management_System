package controllers;

import dao.BookDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Book;
import model.Category;
import model.Tag;
import util.CsvExportUtil;

@WebServlet(name = "BookExportServlet", urlPatterns = {
    "/librarian/book-management/titles/export",
    "/book-management/titles/export"
})
public class BookExportServlet extends HttpServlet {

    private static final int MAX_EXPORT_ROWS = 10000;
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String keyword = trimToNull(request.getParameter("q"));
        Integer categoryId = parseOptionalInt(request.getParameter("categoryId"));
        Integer tagId = parseOptionalInt(request.getParameter("tagId"));
        String status = normalizeStatus(request.getParameter("status"));
        String sort = normalizeSort(request.getParameter("sort"));

        try {
            List<Book> books = bookDAO.findForExport(keyword, categoryId, tagId, status, sort, MAX_EXPORT_ROWS);
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"danh-sach-dau-sach.csv\"");

            PrintWriter writer = CsvExportUtil.utf8BomWriter(response.getOutputStream());
            writer.println("ISBN,Tên sách,Tác giả,Nhà xuất bản,Năm xuất bản,Thể loại,Nhãn,Tổng bản sao,Sẵn sàng,Trạng thái,Ngày cập nhật");
            for (Book book : books) {
                writer.print(CsvExportUtil.escape(book.getIsbn()));
                writer.print(",");
                writer.print(CsvExportUtil.escape(book.getTitle()));
                writer.print(",");
                writer.print(CsvExportUtil.escape(book.getAuthor()));
                writer.print(",");
                writer.print(CsvExportUtil.escape(book.getPublisher()));
                writer.print(",");
                writer.print(book.getPublicationYear() == null ? "" : book.getPublicationYear());
                writer.print(",");
                writer.print(CsvExportUtil.escape(joinCategoryNames(book.getCategories())));
                writer.print(",");
                writer.print(CsvExportUtil.escape(joinTagNames(book.getTags())));
                writer.print(",");
                writer.print(book.getTotalQuantity());
                writer.print(",");
                writer.print(book.getAvailableQuantity());
                writer.print(",");
                writer.print(CsvExportUtil.escape(formatBookStatus(book)));
                writer.print(",");
                writer.print(CsvExportUtil.escape(CsvExportUtil.formatTimestamp(
                        book.getUpdatedAt() == null ? book.getCreatedAt() : book.getUpdatedAt())));
                writer.println();
            }
            writer.flush();
        } catch (SQLException e) {
            throw new ServletException("Không thể xuất danh sách đầu sách.", e);
        }
    }

    private String joinCategoryNames(List<Category> categories) {
        List<String> names = new ArrayList<>();
        if (categories != null) {
            for (Category category : categories) {
                names.add(category.getName());
            }
        }
        return String.join(" | ", names);
    }

    private String joinTagNames(List<Tag> tags) {
        List<String> names = new ArrayList<>();
        if (tags != null) {
            for (Tag tag : tags) {
                names.add(tag.getName());
            }
        }
        return String.join(" | ", names);
    }

    private String formatBookStatus(Book book) {
        if (book.getTotalQuantity() == 0) {
            return "Chưa có bản sao";
        }
        return "unavailable".equals(book.getStatus()) ? "Ngừng sử dụng" : "Đang sử dụng";
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

    private String trimToNull(String value) {
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }
}
