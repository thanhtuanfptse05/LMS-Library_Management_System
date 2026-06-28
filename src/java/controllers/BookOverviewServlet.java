package controllers;

import dao.BookCopyDAO;
import dao.BookCopyIncidentDAO;
import dao.BookDAO;
import dao.BookImportDAO;
import dao.InventoryDAO;
import dto.BookCatalogSummaryDTO;
import dto.BookCopyIncidentSummaryDTO;
import dto.BookCopySummaryDTO;
import dto.BookOverviewTaskDTO;
import dto.InventorySummaryDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BookOverviewServlet", urlPatterns = {"/book-management/overview"})
public class BookOverviewServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();
    private final BookCopyIncidentDAO incidentDAO = new BookCopyIncidentDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final BookImportDAO importDAO = new BookImportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            BookCatalogSummaryDTO catalogSummary = bookDAO.getSummary();
            BookCopySummaryDTO copySummary = bookCopyDAO.getSummary();
            BookCopyIncidentSummaryDTO incidentSummary = incidentDAO.getSummary();
            InventorySummaryDTO inventorySummary = inventoryDAO.getSummary();
            int failedImports = importDAO.count(null, "failed");

            int openIncidents = incidentSummary.getPendingCount() + incidentSummary.getInvestigatingCount();
            int actionCount = openIncidents + inventorySummary.getUnresolvedItems()
                    + failedImports + catalogSummary.getBooksWithoutCopies();

            request.setAttribute("catalogSummary", catalogSummary);
            request.setAttribute("copySummary", copySummary);
            request.setAttribute("incidentSummary", incidentSummary);
            request.setAttribute("inventorySummary", inventorySummary);
            request.setAttribute("failedImports", failedImports);
            request.setAttribute("openIncidents", openIncidents);
            request.setAttribute("actionCount", actionCount);
            request.setAttribute("locationSummaries", bookCopyDAO.getLocationSummaries(5));
            request.setAttribute("tasks", buildTasks(openIncidents, inventorySummary.getUnresolvedItems(),
                    failedImports, catalogSummary.getBooksWithoutCopies()));
            request.setAttribute("overviewGeneratedAt", new Timestamp(System.currentTimeMillis()));

            request.getRequestDispatcher("/librarian/book-overview.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Không thể tải tổng quan quản lý sách.", e);
        }
    }

    private List<BookOverviewTaskDTO> buildTasks(int openIncidents, int unresolvedInventory,
            int failedImports, int booksWithoutCopies) {
        List<BookOverviewTaskDTO> tasks = new ArrayList<>();
        if (openIncidents > 0) {
            tasks.add(new BookOverviewTaskDTO("report", openIncidents + " sự cố hỏng/mất cần xử lý",
                    "Xác minh hoặc kết luận các bản sao đang bị ngừng lưu thông.",
                    "/book-management/incidents", "Mở danh sách hỏng & mất", "danger"));
        }
        if (unresolvedInventory > 0) {
            tasks.add(new BookOverviewTaskDTO("difference", unresolvedInventory + " lệch kho chưa xác minh",
                    "Đối chiếu lại các bản sao thiếu hoặc sai vị trí trước khi cập nhật kho.",
                    "/book-management/inventory", "Xem lệch kho", "warning"));
        }
        if (failedImports > 0) {
            tasks.add(new BookOverviewTaskDTO("upload_file", failedImports + " phiên nhập dữ liệu có lỗi",
                    "Kiểm tra file import thất bại để sửa dữ liệu và nhập lại nếu cần.",
                    "/book-management/import-history?status=failed", "Xem lịch sử xử lý", "warning"));
        }
        if (booksWithoutCopies > 0) {
            tasks.add(new BookOverviewTaskDTO("inventory_2", booksWithoutCopies + " đầu sách chưa có bản sao",
                    "Bổ sung bản sao vật lý để đầu sách có thể đưa vào lưu thông.",
                    "/book-management/titles?status=noCopies", "Mở danh sách đầu sách", "info"));
        }
        return tasks;
    }
}
