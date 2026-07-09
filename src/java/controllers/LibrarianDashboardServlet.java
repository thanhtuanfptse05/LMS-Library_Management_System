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

        int librarianId = (int) session.getAttribute("userId");

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
            request.setAttribute("now", new java.util.Date());

            // 2. Giao dịch do thủ thư này xử lý (borrowed + returned gần đây, createdBy = librarianId)
            List<BorrowRecord> myLoans = borrowRecordDAO.findLoansByLibrarian(conn, librarianId, 15);
            request.setAttribute("myLoans", myLoans);

            // 3. Unpaid Fines (Top 10)
            List<Fine> unpaidFinesList = fineDAO.findUnpaidFines(conn, 10);
            request.setAttribute("unpaidFinesList", unpaidFinesList);

            // 4. Overdue Loans detail list (Top 8 — quá hạn lâu nhất ưu tiên trước)
            List<BorrowRecord> overdueLoans = borrowRecordDAO.findOverdueLoans(conn, 8);
            request.setAttribute("overdueLoans", overdueLoans);

            // 5. Ready Pickup Reservations (Top 8 — sắp hết hạn ưu tiên trước)
            List<Reservation> readyPickupList = reservationDAO.findReadyPickupReservations(conn, 8);
            request.setAttribute("readyPickupList", readyPickupList);

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
