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

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Lấy danh sách đang mượn
            List<BorrowRecord> borrows = borrowRecordDAO.findActiveBorrowRecordsByUserId(conn, userId);
            for (BorrowRecord br : borrows) {
                br.setBook(bookDAO.findById(conn, br.getBookId()));
                br.setBookCopy(bookCopyDAO.findById(conn, br.getBookCopyId()));
            }

            // Lấy danh sách đặt trước
            List<Reservation> reservations = reservationDAO.findActiveReservationsByUserId(conn, userId);
            for (Reservation res : reservations) {
                res.setBook(bookDAO.findById(conn, res.getBookId()));
                if (res.getBookCopyId() != null) {
                    res.setBookCopy(bookCopyDAO.findById(conn, res.getBookCopyId()));
                }
            }

            request.setAttribute("borrows", borrows);
            request.setAttribute("reservations", reservations);

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
