package controllers;

import dao.BookCopyDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import model.BookCopy;
import util.CsvExportUtil;

@WebServlet(name = "BookCopyExportServlet", urlPatterns = {
    "/librarian/book-management/copies/export",
    "/book-management/copies/export"
})
public class BookCopyExportServlet extends HttpServlet {

    private static final int MAX_EXPORT_ROWS = 10000;
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String keyword = trimToNull(request.getParameter("q"));
        String location = trimToNull(request.getParameter("location"));
        String status = normalizeStatus(request.getParameter("status"));

        try {
            List<BookCopy> copies = bookCopyDAO.findForExport(keyword, location, status, MAX_EXPORT_ROWS);
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"danh-sach-ban-sao.csv\"");

            PrintWriter writer = CsvExportUtil.utf8BomWriter(response.getOutputStream());
            writer.println("Mã vạch,ISBN,Tên sách,Vị trí,Tình trạng,Trạng thái lưu thông,Ngày cập nhật");
            for (BookCopy copy : copies) {
                writer.print(CsvExportUtil.escape(copy.getBarcode()));
                writer.print(",");
                writer.print(CsvExportUtil.escape(copy.getIsbn()));
                writer.print(",");
                writer.print(CsvExportUtil.escape(copy.getBookTitle()));
                writer.print(",");
                writer.print(CsvExportUtil.escape(copy.getLocation()));
                writer.print(",");
                writer.print(CsvExportUtil.escape(formatCondition(copy.getCondition())));
                writer.print(",");
                writer.print(CsvExportUtil.escape(formatCopyStatus(copy.getStatus())));
                writer.print(",");
                Timestamp updated = copy.getUpdatedAt() == null ? copy.getCreatedAt() : copy.getUpdatedAt();
                writer.print(CsvExportUtil.escape(CsvExportUtil.formatTimestamp(updated)));
                writer.println();
            }
            writer.flush();
        } catch (SQLException e) {
            throw new ServletException("Không thể xuất danh sách bản sao.", e);
        }
    }

    private String formatCondition(String condition) {
        if ("damaged".equals(condition)) {
            return "Hỏng";
        }
        if ("lost".equals(condition)) {
            return "Mất";
        }
        return "Tốt";
    }

    private String formatCopyStatus(String status) {
        if ("available".equals(status)) {
            return "Sẵn sàng";
        }
        if ("borrowed".equals(status)) {
            return "Đang mượn";
        }
        if ("unavailable".equals(status)) {
            return "Ngừng lưu thông";
        }
        return "Ngừng lưu thông";
    }

    private String normalizeStatus(String status) {
        return "available".equals(status) || "borrowed".equals(status)
                || "unavailable".equals(status) || "incident".equals(status) ? status : null;
    }

    private String trimToNull(String value) {
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }
}
