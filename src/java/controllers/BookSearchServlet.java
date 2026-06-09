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
import model.Category;
import model.Tag;

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
        // --- KIỂM TRA PHÂN QUYỀN (Auth Check) ---
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=book-search");
            return;
        }
        // ----------------------------------------
        
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
        
        String[] tagIdParams = request.getParameterValues("tagId");
        int[] tagIds = null;
        java.util.List<Integer> selectedTags = new java.util.ArrayList<>();
        if (tagIdParams != null && tagIdParams.length > 0) {
            tagIds = new int[tagIdParams.length];
            for (int i = 0; i < tagIdParams.length; i++) {
                try {
                    int tId = Integer.parseInt(tagIdParams[i]);
                    tagIds[i] = tId;
                    selectedTags.add(tId);
                } catch (NumberFormatException e) {
                    tagIds[i] = 0;
                }
            }
        }
        
        String availableOnlyParam = request.getParameter("availableOnly");
        boolean availableOnly = "true".equalsIgnoreCase(availableOnlyParam);

        List<Book> books = bookDAO.searchBooks(keyword, categoryId, tagIds, availableOnly, page, PAGE_SIZE);
        
        // Cần tính tổng số trang nếu cần, nhưng tạm thời chỉ trả list.
        // Tương lai có thể thêm hàm countSearchBooks vào BookDAO để làm Pagination đầy đủ.
        
        List<Category> categories = bookDAO.getAllCategories();
        List<Tag> tags = bookDAO.getAllTags();
        
        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
        request.setAttribute("tags", tags);
        request.setAttribute("keyword", keyword);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("tagIds", tagIdParams); // Gửi mảng string cho URL
        request.setAttribute("selectedTags", selectedTags); // Gửi List Integer để dùng trong c:if
        request.setAttribute("availableOnly", availableOnly);
        request.setAttribute("currentPage", page);
        
        request.getRequestDispatcher("/book-search.jsp").forward(request, response);
    }
}
