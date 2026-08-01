package controllers;

import dao.BookCopyDAO;
import dao.BookDAO;
import dao.BorrowRecordDAO;
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
import model.BorrowRecord;
import model.Reservation;
import util.DatabaseConnection;

/**
 * MyBorrowingsServlet — Hiển thị danh sách sách đang mượn và đang đặt trước của Student/Lecturer.
 */
@WebServlet(name = "MyBorrowingsServlet", urlPatterns = {"/student/my-borrowings", "/lecturer/my-borrowings"})
public class MyBorrowingsServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(MyBorrowingsServlet.class.getName());

    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final BookCopyDAO bookCopyDAO = new BookCopyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        String borrowSortBy = request.getParameter("borrowSortBy");
        String borrowSortOrder = request.getParameter("borrowSortOrder");
        String resSortBy = request.getParameter("resSortBy");
        String resSortOrder = request.getParameter("resSortOrder");

        if (borrowSortBy == null || borrowSortBy.isBlank()) borrowSortBy = "startDate";
        if (borrowSortOrder == null || borrowSortOrder.isBlank()) borrowSortOrder = "DESC";
        if (resSortBy == null || resSortBy.isBlank()) resSortBy = "queuePosition";
        if (resSortOrder == null || resSortOrder.isBlank()) resSortOrder = "ASC";

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Lấy danh sách đang mượn
            List<BorrowRecord> borrows = borrowRecordDAO.findActiveBorrowRecordsByUserId(conn, userId);
            for (BorrowRecord br : borrows) {
                br.setBook(bookDAO.findById(conn, br.getBookId()));
                br.setBookCopy(bookCopyDAO.findById(conn, br.getBookCopyId()));
            }

            // Sắp xếp danh sách đang mượn
            final String finalBorrowSortBy = borrowSortBy;
            final boolean isBorrowAsc = "ASC".equalsIgnoreCase(borrowSortOrder);
            borrows.sort((b1, b2) -> {
                int cmp = 0;
                if ("endDate".equalsIgnoreCase(finalBorrowSortBy)) {
                    if (b1.getEndDate() == null && b2.getEndDate() == null) cmp = 0;
                    else if (b1.getEndDate() == null) cmp = 1;
                    else if (b2.getEndDate() == null) cmp = -1;
                    else cmp = b1.getEndDate().compareTo(b2.getEndDate());
                } else if ("title".equalsIgnoreCase(finalBorrowSortBy)) {
                    String t1 = b1.getBook() != null && b1.getBook().getTitle() != null ? b1.getBook().getTitle() : "";
                    String t2 = b2.getBook() != null && b2.getBook().getTitle() != null ? b2.getBook().getTitle() : "";
                    cmp = t1.compareToIgnoreCase(t2);
                } else if ("id".equalsIgnoreCase(finalBorrowSortBy)) {
                    cmp = Integer.compare(b1.getBorrowRecordId(), b2.getBorrowRecordId());
                } else { // startDate
                    if (b1.getStartDate() == null && b2.getStartDate() == null) cmp = 0;
                    else if (b1.getStartDate() == null) cmp = 1;
                    else if (b2.getStartDate() == null) cmp = -1;
                    else cmp = b1.getStartDate().compareTo(b2.getStartDate());
                }
                return isBorrowAsc ? cmp : -cmp;
            });

            // Lấy danh sách đặt trước
            List<Reservation> reservations = reservationDAO.findActiveReservationsByUserId(conn, userId);
            for (Reservation res : reservations) {
                res.setBook(bookDAO.findById(conn, res.getBookId()));
                if (res.getBookCopyId() != null) {
                    res.setBookCopy(bookCopyDAO.findById(conn, res.getBookCopyId()));
                }
            }

            // Sắp xếp danh sách đặt trước
            final String finalResSortBy = resSortBy;
            final boolean isResAsc = "ASC".equalsIgnoreCase(resSortOrder);
            reservations.sort((r1, r2) -> {
                int cmp = 0;
                if ("startDate".equalsIgnoreCase(finalResSortBy)) {
                    if (r1.getStartDate() == null && r2.getStartDate() == null) cmp = 0;
                    else if (r1.getStartDate() == null) cmp = 1;
                    else if (r2.getStartDate() == null) cmp = -1;
                    else cmp = r1.getStartDate().compareTo(r2.getStartDate());
                } else if ("endDate".equalsIgnoreCase(finalResSortBy)) {
                    if (r1.getEndDate() == null && r2.getEndDate() == null) cmp = 0;
                    else if (r1.getEndDate() == null) cmp = 1;
                    else if (r2.getEndDate() == null) cmp = -1;
                    else cmp = r1.getEndDate().compareTo(r2.getEndDate());
                } else if ("title".equalsIgnoreCase(finalResSortBy)) {
                    String t1 = r1.getBook() != null && r1.getBook().getTitle() != null ? r1.getBook().getTitle() : "";
                    String t2 = r2.getBook() != null && r2.getBook().getTitle() != null ? r2.getBook().getTitle() : "";
                    cmp = t1.compareToIgnoreCase(t2);
                } else { // queuePosition
                    Integer q1 = r1.getQueuePosition() != null ? r1.getQueuePosition() : 99999;
                    Integer q2 = r2.getQueuePosition() != null ? r2.getQueuePosition() : 99999;
                    cmp = q1.compareTo(q2);
                }
                return isResAsc ? cmp : -cmp;
            });

            request.setAttribute("borrows", borrows);
            request.setAttribute("reservations", reservations);
            request.setAttribute("borrowSortBy", borrowSortBy);
            request.setAttribute("borrowSortOrder", borrowSortOrder);
            request.setAttribute("resSortBy", resSortBy);
            request.setAttribute("resSortOrder", resSortOrder);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy thông tin sách đang mượn/đặt trước của userId=" + userId, e);
            request.setAttribute("errorMessage", "Không thể tải dữ liệu mượn sách từ hệ thống.");
        }

        // Forward sang đúng view tương ứng với vai trò
        if ("LECTURER".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/lecturer/my-borrowings.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/student/my-borrowings.jsp").forward(request, response);
        }
    }
}
