package controllers;

import dao.BookDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Book;

/**
 * BookSearchServlet — Xử lý tìm kiếm và phân trang sách.
 */
@WebServlet(name = "BookSearchServlet", urlPatterns = {"/book-search"})
public class BookSearchServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private static final int PAGE_SIZE = 12;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
        
        String categoryIdParam = request.getParameter("categoryId");
        int categoryId = 0;
        if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdParam);
            } catch (NumberFormatException e) {
                categoryId = 0;
            }
        }
        
        String pageParam = request.getParameter("page");
        int page = 1;
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Book> books = bookDAO.searchBooks(keyword, categoryId, page, PAGE_SIZE);
        
        // Cần tính tổng số trang nếu cần, nhưng tạm thời chỉ trả list.
        // Tương lai có thể thêm hàm countSearchBooks vào BookDAO để làm Pagination đầy đủ.
        
        request.setAttribute("books", books);
        request.setAttribute("keyword", keyword);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("currentPage", page);
        
        request.getRequestDispatcher("/book-search.jsp").forward(request, response);
    }
}
