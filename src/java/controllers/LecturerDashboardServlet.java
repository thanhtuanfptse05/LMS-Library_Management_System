package controllers;

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
import java.util.logging.Level;
import java.util.logging.Logger;
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
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING,
                    "Lỗi khi tải thống kê Dashboard cho Lecturer userId=" + userId, e);
        }

        request.getRequestDispatcher("/lecturer/dashboard.jsp").forward(request, response);
    }
}
