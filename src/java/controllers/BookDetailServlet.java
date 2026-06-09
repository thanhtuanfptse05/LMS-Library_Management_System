package controllers;

import dao.BookDAO;
import java.io.IOException;
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

    private final BookDAO bookDAO = new BookDAO();

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
            Book book = bookDAO.getBookById(bookId);

            if (book == null) {
                // Không tìm thấy sách
                response.sendRedirect(request.getContextPath() + "/book-search");
                return;
            }

            // Kiểm tra phân quyền để disable nút Đặt mượn nếu là Guest
            HttpSession session = request.getSession(false);
            boolean isBorrowButtonEnabled = false;
            
            if (session != null) {
                User user = (User) session.getAttribute("user");
                if (user != null) {
                    isBorrowButtonEnabled = true; // Có thể kiểm tra thêm role nếu cần
                }
            }

            request.setAttribute("book", book);
            request.setAttribute("isBorrowButtonEnabled", isBorrowButtonEnabled);
            
            request.getRequestDispatcher("/book-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/book-search");
        }
    }
}
