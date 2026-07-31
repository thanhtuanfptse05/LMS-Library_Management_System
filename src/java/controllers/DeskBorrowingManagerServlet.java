package controllers;

import dao.AuditLogDAO;
import dao.BookCopyDAO;
import dao.BookDAO;
import dao.BorrowRecordDAO;
import dao.MemberProfileDAO;
import dao.UserDAO;
import dto.BorrowingManagementDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Book;
import model.BookCopy;
import model.BorrowRecord;
import model.EmailJob;
import model.MemberProfile;
import model.User;
import service.EmailService;
import util.DatabaseConnection;

/**
 * DeskBorrowingManagerServlet — Controller quản lý danh sách mượn sách & Gửi yêu cầu Thu hồi sách cho Thủ thư.
 *
 * <p>Traceability: SPEC.md (feat-borrowingsManagement), FR-103, FR-104, BR-82, BR-83.</p>
 */
@WebServlet(name = "DeskBorrowingManagerServlet", urlPatterns = {"/librarian/borrowings"})
public class DeskBorrowingManagerServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DeskBorrowingManagerServlet.class.getName());
    private static final int PAGE_SIZE = 10;

    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();
    private final UserDAO userDAO = new UserDAO();
    private final MemberProfileDAO profileDAO = new MemberProfileDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();
    private final AuditLogDAO auditLogDAO = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String userKeyword = req.getParameter("userKeyword");
        String barcodeKeyword = req.getParameter("barcodeKeyword");
        String status = req.getParameter("status");
        String fromDateStr = req.getParameter("fromDate");
        String toDateStr = req.getParameter("toDate");
        String pageStr = req.getParameter("page");

        int page = 1;
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr.trim());
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        Timestamp fromTs = null;
        Timestamp toTs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
                Date d = sdf.parse(fromDateStr.trim());
                fromTs = new Timestamp(d.getTime());
            }
            if (toDateStr != null && !toDateStr.trim().isEmpty()) {
                Date d = sdf.parse(toDateStr.trim());
                // Thêm 23:59:59 cho ngày kết thúc
                toTs = new Timestamp(d.getTime() + (24 * 60 * 60 * 1000 - 1));
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi định dạng ngày tháng lọc mượn sách", e);
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            int totalRecords = borrowRecordDAO.countSearchBorrowings(
                    conn, userKeyword, barcodeKeyword, status, fromTs, toTs);

            int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
            if (totalPages < 1) totalPages = 1;
            if (page > totalPages) page = totalPages;

            int offset = (page - 1) * PAGE_SIZE;

            List<BorrowingManagementDTO> borrowings = borrowRecordDAO.searchBorrowingsPaginated(
                    conn, userKeyword, barcodeKeyword, status, fromTs, toTs, offset, PAGE_SIZE);

            req.setAttribute("borrowings", borrowings);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalRecords", totalRecords);
            req.setAttribute("userKeyword", userKeyword != null ? userKeyword.trim() : "");
            req.setAttribute("barcodeKeyword", barcodeKeyword != null ? barcodeKeyword.trim() : "");
            req.setAttribute("status", status != null ? status.trim() : "all");
            req.setAttribute("fromDate", fromDateStr != null ? fromDateStr.trim() : "");
            req.setAttribute("toDate", toDateStr != null ? toDateStr.trim() : "");

            req.getRequestDispatcher("/librarian/borrowings-management.jsp").forward(req, resp);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách mượn sách cho thủ thư", e);
            req.getSession().setAttribute("errorMessage", "Lỗi hệ thống khi tải danh sách mượn sách: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/librarian/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        Integer librarianUserId = (Integer) session.getAttribute("userId");
        if (librarianUserId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if ("sendRecallEmail".equalsIgnoreCase(action)) {
            handleSendRecallEmail(req, resp, session, librarianUserId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/librarian/borrowings");
        }
    }

    private void handleSendRecallEmail(HttpServletRequest req, HttpServletResponse resp,
                                       HttpSession session, int librarianUserId) throws IOException {

        String recordIdStr = req.getParameter("borrowRecordId");
        String recallReason = req.getParameter("recallReason");

        if (recallReason == null || recallReason.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Vui lòng nhập lý do thu hồi sách!");
            resp.sendRedirect(req.getContextPath() + "/librarian/borrowings");
            return;
        }

        int borrowRecordId = 0;
        try {
            borrowRecordId = Integer.parseInt(recordIdStr);
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Mã lượt mượn sách không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/librarian/borrowings");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            BorrowRecord record = borrowRecordDAO.findById(conn, borrowRecordId);
            if (record == null) {
                session.setAttribute("errorMessage", "Không tìm thấy lượt mượn sách ID=" + borrowRecordId);
                resp.sendRedirect(req.getContextPath() + "/librarian/borrowings");
                return;
            }

            if (!"borrowed".equalsIgnoreCase(record.getStatus()) && !"overdue".equalsIgnoreCase(record.getStatus())) {
                session.setAttribute("errorMessage", "Chỉ có thể gửi yêu cầu thu hồi đối với các lượt mượn đang mượn hoặc quá hạn!");
                resp.sendRedirect(req.getContextPath() + "/librarian/borrowings");
                return;
            }

            User borrower = userDAO.findByUserId(record.getUserId());
            if (borrower == null || borrower.getEmail() == null || borrower.getEmail().trim().isEmpty()) {
                session.setAttribute("errorMessage", "Không tìm thấy địa chỉ email của độc giả để gửi thông báo!");
                resp.sendRedirect(req.getContextPath() + "/librarian/borrowings");
                return;
            }

            MemberProfile profile = profileDAO.findByUserId(record.getUserId());
            String borrowerName = (profile != null && profile.getFullName() != null)
                    ? profile.getFullName() : borrower.getEmail();

            Book book = bookDAO.findById(conn, record.getBookId());
            String bookTitle = (book != null) ? book.getTitle() : "Sách mượn";

            BookCopy copy = bookCopyDAO.findById(conn, record.getBookCopyId());
            String barcode = (copy != null) ? copy.getBarcode() : "N/A";

            // Lắp ráp EmailJob với mẫu RECALL_NOTICE
            Map<String, String> placeholders = new HashMap<>();
            placeholders.put("userName", borrowerName);
            placeholders.put("bookTitle", bookTitle);
            placeholders.put("barcode", barcode);
            placeholders.put("recallReason", recallReason.trim());

            EmailJob job = new EmailJob("RECALL_NOTICE", borrower.getEmail(), borrowerName, placeholders);
            EmailService.enqueue(job);

            // Ghi nhật ký AuditLog
            auditLogDAO.insert(conn, librarianUserId, "SEND_RECALL_EMAIL", "BorrowRecord",
                    borrowRecordId, null, "reason=" + recallReason.trim() + "; recipient=" + borrower.getEmail());

            LOGGER.log(Level.INFO, "[RECALL EMAIL] Librarian userId={0} đã enqueue email thu hồi cho borrowRecordId={1}, email={2}",
                    new Object[]{librarianUserId, borrowRecordId, borrower.getEmail()});

            session.setAttribute("successMessage", "Đã gửi email yêu cầu thu hồi sách thành công tới độc giả " + borrower.getEmail());

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xử lý gửi email thu hồi sách", e);
            session.setAttribute("errorMessage", "Lỗi hệ thống khi gửi email thu hồi: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/librarian/borrowings");
    }
}
