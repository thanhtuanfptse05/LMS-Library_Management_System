package controllers;

import dao.BookDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Book;
import model.User;

/**
 * BookDetailServlet — Xử lý hiển thị chi tiết sách.
 */
@WebServlet(name = "BookDetailServlet", urlPatterns = {"/book-detail"})
public class BookDetailServlet extends HttpServlet {

    BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/book-search");
            return;
        }

        try {
            int bookId = Integer.parseInt(idParam);

            // [LAZY LOAD] Dọn dẹp đơn quá hạn nhận sách trước khi lấy dữ liệu chi tiết sách & số lượng sẵn có
            try {
                new service.ReservationExpirationProcessor().processExpiration();
            } catch (Exception e) {
                java.util.logging.Logger.getLogger(BookDetailServlet.class.getName())
                    .log(java.util.logging.Level.WARNING, "[LAZY LOAD] Lỗi khi dọn đơn quá hạn trên BookDetailServlet", e);
            }

            Book book = bookDAO.getBookById(bookId);

            if (book == null) {
                // Không tìm thấy sách
                response.sendRedirect(request.getContextPath() + "/book-search");
                return;
            }

            // Kiểm tra phân quyền để chặn Guest truy cập trang chi tiết
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                // Kéo Guest về trang Login kèm tham số redirect có chủ ý
                response.sendRedirect(request.getContextPath() + "/login?redirect=book-detail?id=" + bookId);
                return;
            }

            int userId = (int) session.getAttribute("userId");
            boolean hasActiveBorrow = false;
            boolean hasActiveReservation = false;

            try (Connection conn = util.DatabaseConnection.getConnection()) {
                dao.BorrowRecordDAO borrowRecordDAO = new dao.BorrowRecordDAO();
                hasActiveBorrow = borrowRecordDAO.hasActiveBorrowRecord(conn, userId, bookId);

                String checkResSql = "SELECT COUNT(*) FROM Reservation WHERE userId = ? AND bookId = ? AND status IN ('pending', 'readypickup')";
                try (java.sql.PreparedStatement ps = conn.prepareStatement(checkResSql)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, bookId);
                    try (java.sql.ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            hasActiveReservation = rs.getInt(1) > 0;
                        }
                    }
                }
            } catch (SQLException e) {
                java.util.logging.Logger.getLogger(BookDetailServlet.class.getName()).log(Level.SEVERE, "Lỗi kiểm tra trạng thái mượn/đặt của người dùng", e);
            }

            boolean isBookUnavailable = "unavailable".equals(book.getStatus());
            boolean isBorrowButtonEnabled = !isBookUnavailable;

            request.setAttribute("book", book);
            request.setAttribute("isBookUnavailable", isBookUnavailable);
            request.setAttribute("isBorrowButtonEnabled", isBorrowButtonEnabled);
            request.setAttribute("hasActiveBorrow", hasActiveBorrow);
            request.setAttribute("hasActiveReservation", hasActiveReservation);

            
            request.getRequestDispatcher("/book-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/book-search");
        }
    }
}
