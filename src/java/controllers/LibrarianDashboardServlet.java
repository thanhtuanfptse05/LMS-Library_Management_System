package controllers;

import dao.BorrowRecordDAO;
import dao.ReservationDAO;
import dao.FineDAO;
import model.BorrowRecord;
import model.Reservation;
import model.Fine;
import service.OnlineCirculationService;
import util.DatabaseConnection;

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

@WebServlet(name = "LibrarianDashboardServlet", urlPatterns = {"/librarian/dashboard"})
public class LibrarianDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LibrarianDashboardServlet.class.getName());

    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final FineDAO fineDAO = new FineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"LIBRARIAN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // 1. KPI Counts
            int issuedToday = borrowRecordDAO.countIssuedToday(conn);
            int returnedToday = borrowRecordDAO.countReturnedToday(conn);
            int overdueCount = borrowRecordDAO.countOverdueAll(conn);
            int pendingReservations = reservationDAO.countPendingReservations(conn);

            request.setAttribute("issuedToday", issuedToday);
            request.setAttribute("returnedToday", returnedToday);
            request.setAttribute("overdueCount", overdueCount);
            request.setAttribute("pendingReservations", pendingReservations);

            // 2. Active Loans (Top 10)
            List<BorrowRecord> activeLoans = borrowRecordDAO.findActiveLoans(conn, 10);
            request.setAttribute("activeLoans", activeLoans);

            // 3. Pending Reservations (Top 10)
            List<Reservation> pendingReservationsList = reservationDAO.findPendingReservations(conn, 10);
            request.setAttribute("pendingReservationsList", pendingReservationsList);

            // 4. Unpaid Fines (Top 10)
            List<Fine> unpaidFinesList = fineDAO.findUnpaidFines(conn, 10);
            request.setAttribute("unpaidFinesList", unpaidFinesList);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi nạp dữ liệu cho trang chủ quầy thủ thư", e);
            request.setAttribute("errorMessage", "Không thể nạp dữ liệu từ hệ thống.");
        }

        // Tải thông báo flash từ session
        if (session != null) {
            String successMsg = (String) session.getAttribute("successMessage");
            if (successMsg != null) {
                request.setAttribute("successMessage", successMsg);
                session.removeAttribute("successMessage");
            }
            String errorMsg = (String) session.getAttribute("errorMessage");
            if (errorMsg != null) {
                request.setAttribute("errorMessage", errorMsg);
                session.removeAttribute("errorMessage");
            }
        }

        request.getRequestDispatcher("/librarian/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"LIBRARIAN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int librarianId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");
        if ("cancelReservation".equals(action)) {
            String resIdStr = request.getParameter("reservationId");
            try {
                int resId = Integer.parseInt(resIdStr);
                OnlineCirculationService circulationService = new OnlineCirculationService();
                circulationService.cancelReservationByLibrarian(librarianId, resId);
                session.setAttribute("successMessage", "Đã hủy đơn đặt trước thành công.");
            } catch (Exception e) {
                session.setAttribute("errorMessage", "Hủy đơn đặt trước thất bại: " + e.getMessage());
            }
        }
        response.sendRedirect(request.getContextPath() + "/librarian/dashboard");
    }
}
