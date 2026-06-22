package controllers;

import dao.BookCopyDAO;
import dao.BookDAO;
import dao.BorrowRecordDAO;
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
import util.DatabaseConnection;

/**
 * BorrowHistoryServlet — Hiển thị toàn bộ lịch sử mượn và trả sách của Student/Lecturer.
 */
@WebServlet(name = "BorrowHistoryServlet", urlPatterns = {"/student/borrow-history", "/lecturer/borrow-history"})
public class BorrowHistoryServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(BorrowHistoryServlet.class.getName());

    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();
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
            // Lấy toàn bộ lịch sử mượn trả
            List<BorrowRecord> history = borrowRecordDAO.findAllBorrowRecordsByUserId(conn, userId);
            for (BorrowRecord br : history) {
                br.setBook(bookDAO.findById(conn, br.getBookId()));
                br.setBookCopy(bookCopyDAO.findById(conn, br.getBookCopyId()));
            }

            request.setAttribute("history", history);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy lịch sử mượn trả sách của userId=" + userId, e);
            request.setAttribute("errorMessage", "Không thể tải lịch sử mượn trả từ hệ thống.");
        }

        // Forward sang đúng view tương ứng với vai trò
        if ("LECTURER".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/lecturer/borrow-history.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/student/borrow-history.jsp").forward(request, response);
        }
    }
}
