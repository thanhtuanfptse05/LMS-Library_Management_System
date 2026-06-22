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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Book;
import model.BorrowRecord;
import model.Reservation;
import util.DatabaseConnection;

/**
 * LecturerDashboardServlet — Servlet xử lý hiển thị Dashboard cho Giảng viên.
 * Mapped tới URL: /lecturer/dashboard
 */
@WebServlet(name = "LecturerDashboardServlet", urlPatterns = {"/lecturer/dashboard"})
public class LecturerDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LecturerDashboardServlet.class.getName());

    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final FineDAO fineDAO = new FineDAO();
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null
                || !"LECTURER".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // Truy vấn 4 metric thống kê cho Stats Cards trên Dashboard
        try (Connection conn = DatabaseConnection.getConnection()) {
            request.setAttribute("activeLoansCount",
                    borrowRecordDAO.countActiveBorrowsByUser(conn, userId));
            request.setAttribute("dueSoonCount",
                    borrowRecordDAO.countDueSoonByUser(conn, userId, 3));
            request.setAttribute("reservedCount",
                    reservationDAO.countActiveReservationsByUser(conn, userId));
            request.setAttribute("totalFines",
                    fineDAO.getTotalUnpaidFinesByUser(conn, userId));

            // Nạp dữ liệu thực tế cho các danh sách của Giảng viên
            loadActiveLoans(conn, userId, request);
            loadRecentLoans(conn, userId, request);
            loadActiveReservations(conn, userId, request);

        } catch (SQLException e) {
            LOGGER.log(Level.WARNING,
                    "Lỗi khi tải dữ liệu Dashboard cho Lecturer userId=" + userId, e);
        }

        request.getRequestDispatcher("/lecturer/dashboard.jsp").forward(request, response);
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
            LOGGER.log(Level.WARNING, "Lỗi khi tải danh sách sách đang mượn cho lecturer userId=" + userId, e);
        }
    }

    /**
     * Tải danh sách hoạt động gần đây (recent activity) kèm thông tin Book đầy đủ.
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
            LOGGER.log(Level.WARNING, "Lỗi khi tải danh sách hoạt động gần đây cho lecturer userId=" + userId, e);
        }
    }

    /**
     * Tải danh sách đặt trước đang hoạt động kèm thông tin Book đầy đủ.
     */
    private void loadActiveReservations(Connection conn, int userId, HttpServletRequest request) {
        try {
            List<Reservation> activeReservations = reservationDAO.findActiveReservationsByUserId(conn, userId);
            for (Reservation record : activeReservations) {
                Book book = bookDAO.getBookById(record.getBookId());
                record.setBook(book);
            }
            request.setAttribute("activeReservations", activeReservations);
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Lỗi khi tải danh sách đặt trước hoạt động cho lecturer userId=" + userId, e);
        }
    }
}
