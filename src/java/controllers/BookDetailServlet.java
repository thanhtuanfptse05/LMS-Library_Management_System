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

            // Kiểm tra phân quyền để chặn Guest truy cập trang chi tiết
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                // Kéo Guest về trang Login kèm tham số redirect có chủ ý
                response.sendRedirect(request.getContextPath() + "/login?redirect=book-detail?id=" + bookId);
                return;
            }

            boolean isBorrowButtonEnabled = true;

            request.setAttribute("book", book);
            request.setAttribute("isBorrowButtonEnabled", isBorrowButtonEnabled);
            
            request.getRequestDispatcher("/book-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/book-search");
        }
    }
}
