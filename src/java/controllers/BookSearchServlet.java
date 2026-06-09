package controllers;

import dao.BookDAO;
import model.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * BookSearchServlet — Controller xử lý tìm kiếm và khám phá sách (FR-42).
 * Mapped tới URL: /books/search
 */
@WebServlet(name = "BookSearchServlet", urlPatterns = {"/books/search"})
public class BookSearchServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();

    /**
     * Xử lý HTTP GET cho chức năng tìm kiếm sách.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
        keyword = keyword.trim();
        
        try {
            // Giới hạn 20 kết quả để phân trang tạm thời
            List<Book> bookList = bookDAO.searchBooks(keyword, 20);
            
            // Đẩy dữ liệu sang JSP
            request.setAttribute("bookList", bookList);
            request.setAttribute("keyword", keyword);
            
            request.getRequestDispatcher("/book-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống khi tìm kiếm sách.");
        }
    }
}
