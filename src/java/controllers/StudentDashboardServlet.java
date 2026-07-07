package controllers;

import dao.BookDAO;
import dao.BorrowRecordDAO;
import dao.FineDAO;
import dao.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Book;
import model.BorrowRecord;
import model.BookSummaryDTO;
import util.DatabaseConnection;

@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/student/dashboard"})
public class StudentDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(StudentDashboardServlet.class.getName());

    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final FineDAO fineDAO = new FineDAO();
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null
                || !"STUDENT".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try (Connection conn = DatabaseConnection.getConnection()) {
            // ── 1. Stats Cards (4 KPI metrics) ──
            request.setAttribute("activeLoansCount",
                    borrowRecordDAO.countActiveBorrowsByUser(conn, userId));
            request.setAttribute("dueSoonCount",
                    borrowRecordDAO.countDueSoonByUser(conn, userId, 3));
            request.setAttribute("reservedCount",
                    reservationDAO.countActiveReservationsByUser(conn, userId));
            request.setAttribute("totalFines",
                    fineDAO.getTotalUnpaidFinesByUser(conn, userId));

            // ── 2. Active Loans (Sách đang đọc) ──
            loadActiveLoans(conn, userId, request);
            
            // ── 2.5. Recent Activity (Hoạt động gần đây) ──
            loadRecentLoans(conn, userId, request);
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING,
                    "Lỗi khi tải thống kê Dashboard cho Student userId=" + userId, e);
        }

        // ── 3. Popular Books (Sách phổ biến) ──
        List<Book> topBooks = bookDAO.getTopTrendingBooks(5);
        request.setAttribute("topBooks", topBooks);

        request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
    }

    /**
     * Tải danh sách sách đang mượn (active loans) kèm thông tin Book đầy đủ.
     */
    private void loadActiveLoans(Connection conn, int userId, HttpServletRequest request) {
        try {
            List<BorrowRecord> activeLoans = borrowRecordDAO.findActiveBorrowRecordsByUserId(conn, userId);
            for (BorrowRecord record : activeLoans) {
                Book book = bookDAO.getBookById(record.getBookId());
                record.setBook(book);
            }
            request.setAttribute("activeLoans", activeLoans);
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING,
                    "Lỗi khi tải danh sách sách đang mượn cho userId=" + userId, e);
        }
    }

    /**
     * Tải danh sách hoạt động gần đây (recent loans) kèm thông tin Book đầy đủ.
     */
    private void loadRecentLoans(Connection conn, int userId, HttpServletRequest request) {
        try {
            List<BorrowRecord> recentLoans = borrowRecordDAO.findRecentBorrowRecordsByUserId(conn, userId, 5);
            for (BorrowRecord record : recentLoans) {
                Book book = bookDAO.getBookById(record.getBookId());
                record.setBook(book);
            }
            request.setAttribute("recentLoans", recentLoans);
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING,
                    "Lỗi khi tải danh sách hoạt động gần đây cho userId=" + userId, e);
        }
    }

}
