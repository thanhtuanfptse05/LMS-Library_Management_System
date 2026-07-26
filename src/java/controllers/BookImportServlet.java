package controllers;

import exception.DatabaseException;
import exception.ValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.OutputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import dto.BookImportPreviewDTO;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import service.BookImportService;
import util.BookImportWorkbookReader;

@WebServlet(name = "BookImportServlet", urlPatterns = {
    "/librarian/book-management/import",
    "/book-management/import"
})
@MultipartConfig(maxFileSize = 10 * 1024 * 1024, maxRequestSize = 11 * 1024 * 1024)
public class BookImportServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(BookImportServlet.class.getName());
    private final BookImportService importService = new BookImportService();
    private final BookImportWorkbookReader workbookReader = new BookImportWorkbookReader();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = requireEditor(request, response);
        if (session == null) {
            return;
        }
        if ("template".equals(request.getParameter("action"))) {
            writeTemplate(response);
            return;
        }
        request.setAttribute("preview", session.getAttribute("bookImportPreview"));
        request.getRequestDispatcher("/librarian/book-import.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = requireEditor(request, response);
        if (session == null) {
            return;
        }
        try {
            String action = request.getParameter("action");
            int actorId = (Integer) session.getAttribute("userId");
            if ("upload".equals(action)) {
                Part file = request.getPart("importFile");
                String fileName = submittedFileName(file);
                if (file == null || file.getSize() == 0) {
                    throw new ValidationException("Hãy chọn tệp Excel cần kiểm tra.");
                }
                if (fileName == null || !fileName.toLowerCase().endsWith(".xlsx")) {
                    throw new ValidationException("Hệ thống chỉ nhận tệp Excel định dạng .xlsx.");
                }
                if (fileName.length() > 255) {
                    throw new ValidationException("Tên tệp không được vượt quá 255 ký tự.");
                }
                BookImportPreviewDTO preview = workbookReader.read(file.getInputStream(), fileName);
                importService.validate(preview, actorId);
                session.setAttribute("bookImportPreview", preview);
                if (preview.isValid() && preview.hasWarnings()) {
                    session.setAttribute("successMessage",
                            "Tệp hợp lệ nhưng có " + preview.getSkippedBookRows()
                            + " đầu sách đã tồn tại sẽ được bỏ qua. Hãy xem phần cảnh báo trước khi xác nhận.");
                } else if (preview.isValid()) {
                    session.setAttribute("successMessage",
                            "Tệp hợp lệ. Hãy kiểm tra phần xem trước và xác nhận import.");
                } else {
                    session.setAttribute("errorMessage",
                            "Tệp có " + preview.getErrors().size() + " lỗi. Không có dữ liệu sách nào được lưu.");
                }
            } else if ("confirm".equals(action)) {
                BookImportPreviewDTO preview = (BookImportPreviewDTO) session.getAttribute("bookImportPreview");
                if (preview == null || !preview.isValid()) {
                    throw new ValidationException("Không có tệp hợp lệ đang chờ xác nhận.");
                }
                if (preview.getImportableRows() <= 0) {
                    throw new ValidationException("Tệp không còn dòng nào để lưu vì toàn bộ đầu sách "
                            + "đã tồn tại trên hệ thống.");
                }
                int batchId = importService.confirm(preview, actorId);
                int skippedBooks = preview.getSkippedBookRows();
                session.removeAttribute("bookImportPreview");
                session.setAttribute("successMessage", "Import dữ liệu thành công. Đã lưu "
                        + (preview.getTotalRows() - skippedBooks) + "/" + preview.getTotalRows() + " dòng"
                        + (skippedBooks > 0
                                ? ", bỏ qua " + skippedBooks + " đầu sách đã tồn tại trên hệ thống"
                                : "")
                        + ". Mã phiên IMP-" + batchId + ".");
                response.sendRedirect(request.getContextPath() + "/librarian/book-management/import-history?batchId=" + batchId);
                return;
            } else if ("clear".equals(action)) {
                session.removeAttribute("bookImportPreview");
            } else {
                throw new ValidationException("Thao tác import không hợp lệ.");
            }
        } catch (ValidationException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (DatabaseException | IOException | ServletException | IllegalStateException e) {
            LOGGER.log(Level.SEVERE, "Không thể xử lý tệp import.", e);
            session.setAttribute("errorMessage", "Không thể xử lý tệp import. Vui lòng kiểm tra tệp và thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/librarian/book-management/import");
    }

    private HttpSession requireEditor(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        String role = (String) session.getAttribute("role");
        if (!"LIBRARIAN".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền import dữ liệu sách.");
            return null;
        }
        return session;
    }

    private String submittedFileName(Part file) {
        if (file == null || file.getSubmittedFileName() == null) {
            return null;
        }
        return java.nio.file.Paths.get(file.getSubmittedFileName()).getFileName().toString();
    }

    private void writeTemplate(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"mau-import-sach.xlsx\"");
        try (XSSFWorkbook workbook = new XSSFWorkbook(); OutputStream output = response.getOutputStream()) {
            Sheet books = workbook.createSheet("Books");
            writeHeader(books, BookImportWorkbookReader.BOOK_HEADERS);
            Row book = books.createRow(1);
            // ISBN mẫu phải qua được IsbnValidator, nếu không thủ thư tải tệp mẫu về rồi
            // tải lên ngay sẽ nhận lỗi "ISBN không hợp lệ" dù chưa sửa gì.
            // 978-604 là dải ISBN của Việt Nam; chữ số cuối là số kiểm tra.
            String[] bookExample = {"9786040000002", "Lập trình Java", "Nguyễn Văn A", "NXB Giáo dục",
                "2026", "120000", "Công nghệ thông tin;Giáo trình", "Java;Lập trình"};
            writeValues(book, bookExample);
            Sheet copies = workbook.createSheet("BookCopies");
            writeHeader(copies, BookImportWorkbookReader.COPY_HEADERS);
            writeValues(copies.createRow(1), new String[]{"9786040000002", "BC-000001", "Kho A · Kệ A01"});
            workbook.write(output);
        }
    }

    private void writeHeader(Sheet sheet, java.util.List<String> headers) {
        Row row = sheet.createRow(0);
        for (int i = 0; i < headers.size(); i++) {
            row.createCell(i).setCellValue(headers.get(i));
            sheet.setColumnWidth(i, 5500);
        }
    }

    private void writeValues(Row row, String[] values) {
        for (int i = 0; i < values.length; i++) {
            row.createCell(i).setCellValue(values[i]);
        }
    }
}
