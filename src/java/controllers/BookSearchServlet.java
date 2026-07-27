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

    BookDAO bookDAO = new BookDAO();
    private static final int PAGE_SIZE = 12;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // --- Guest vẫn được tra cứu sách bình thường ---
        jakarta.servlet.http.HttpSession session = request.getSession(false);
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
        
        String filterStatus = request.getParameter("filterStatus");
        if (filterStatus == null && request.getParameter("availableOnly") != null) {
            filterStatus = "true".equalsIgnoreCase(request.getParameter("availableOnly")) ? "available" : "";
        }
        boolean availableOnly = "available".equals(filterStatus);
        
        List<Category> categories = bookDAO.getAllCategories();
        List<Tag> tags = bookDAO.getAllTags();
        
        java.util.Set<Integer> borrowedBookIds = new java.util.HashSet<>();
        java.util.Set<Integer> pendingBookIds = new java.util.HashSet<>();
        java.util.Set<Integer> pickupBookIds = new java.util.HashSet<>();

        if (session != null && session.getAttribute("userId") != null) {
            int userId = (int) session.getAttribute("userId");
            try (java.sql.Connection conn = util.DatabaseConnection.getConnection()) {
                dao.BorrowRecordDAO borrowRecordDAO = new dao.BorrowRecordDAO();
                List<model.BorrowRecord> activeBorrows = borrowRecordDAO.findActiveBorrowRecordsByUserId(conn, userId);
                for (model.BorrowRecord br : activeBorrows) {
                    borrowedBookIds.add(br.getBookId());
                }

                dao.ReservationDAO reservationDAO = new dao.ReservationDAO();
                List<model.Reservation> activeReservations = reservationDAO.findActiveReservationsByUserId(conn, userId);
                for (model.Reservation res : activeReservations) {
                    if ("readypickup".equals(res.getStatus())) {
                        pickupBookIds.add(res.getBookId());
                    } else if ("pending".equals(res.getStatus())) {
                        pendingBookIds.add(res.getBookId());
                    }
                }
            } catch (java.sql.SQLException e) {
                e.printStackTrace();
            }
        }
        
        List<Book> books = new java.util.ArrayList<>();
        int totalBooks = 0;
        int totalPages = 1;

        if ("borrowed".equals(filterStatus) && !borrowedBookIds.isEmpty()) {
            for (Integer id : borrowedBookIds) {
                Book b = bookDAO.getBookById(id);
                if (b != null) books.add(b);
            }
            totalBooks = books.size();
        } else if ("pickup".equals(filterStatus) && !pickupBookIds.isEmpty()) {
            for (Integer id : pickupBookIds) {
                Book b = bookDAO.getBookById(id);
                if (b != null) books.add(b);
            }
            totalBooks = books.size();
        } else if ("pending".equals(filterStatus) && !pendingBookIds.isEmpty()) {
            for (Integer id : pendingBookIds) {
                Book b = bookDAO.getBookById(id);
                if (b != null) books.add(b);
            }
            totalBooks = books.size();
        } else if ("borrowed".equals(filterStatus) || "pickup".equals(filterStatus) || "pending".equals(filterStatus)) {
            // User selected a specific status but has none, so books is empty
            totalBooks = 0;
            totalPages = 1;
        } else {
            books = bookDAO.searchBooks(keyword, categoryId, tagIds, availableOnly, page, PAGE_SIZE);
            totalBooks = bookDAO.countSearchBooks(keyword, categoryId, tagIds, availableOnly);
            totalPages = (int) Math.ceil((double) totalBooks / PAGE_SIZE);
            if (totalPages < 1) {
                totalPages = 1;
            }
        }

        // Apply keyword/category filtering manually for custom status views to avoid confusion
        if (("borrowed".equals(filterStatus) || "pickup".equals(filterStatus) || "pending".equals(filterStatus)) && !books.isEmpty()) {
            java.util.Iterator<Book> it = books.iterator();
            while (it.hasNext()) {
                Book b = it.next();
                if (keyword != null && !keyword.trim().isEmpty() && !b.getTitle().toLowerCase().contains(keyword.trim().toLowerCase())) {
                    it.remove();
                    continue;
                }
                if (categoryId > 0) {
                    boolean hasCat = false;
                    for (Category c : b.getCategories()) {
                        if (c.getCategoryId() == categoryId) { hasCat = true; break; }
                    }
                    if (!hasCat) {
                        it.remove();
                        continue;
                    }
                }
                if (tagIds != null && tagIds.length > 0) {
                    boolean hasAllTags = true;
                    for (int tId : tagIds) {
                        boolean hasThisTag = false;
                        for (Tag t : b.getTags()) {
                            if (t.getTagId() == tId) { hasThisTag = true; break; }
                        }
                        if (!hasThisTag) { hasAllTags = false; break; }
                    }
                    if (!hasAllTags) {
                        it.remove();
                        continue;
                    }
                }
            }
            totalBooks = books.size();
            totalPages = (int) Math.ceil((double) totalBooks / PAGE_SIZE);
            if (totalPages < 1) {
                totalPages = 1;
            }
            if (page > totalPages) {
                page = totalPages;
            }
            int fromIndex = (page - 1) * PAGE_SIZE;
            int toIndex = Math.min(fromIndex + PAGE_SIZE, totalBooks);
            if (fromIndex >= 0 && fromIndex < totalBooks) {
                books = books.subList(fromIndex, toIndex);
            } else if (totalBooks == 0) {
                books = new java.util.ArrayList<>();
            }
        }
        
        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
        request.setAttribute("tags", tags);
        request.setAttribute("keyword", keyword);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("tagIds", tagIdParams); // Gửi mảng string cho URL
        request.setAttribute("selectedTags", selectedTags); // Gửi List Integer để dùng trong c:if
        request.setAttribute("availableOnly", availableOnly);
        request.setAttribute("filterStatus", filterStatus);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.setAttribute("borrowedBookIds", borrowedBookIds);
        request.setAttribute("pendingBookIds", pendingBookIds);
        request.setAttribute("pickupBookIds", pickupBookIds);
        
        request.getRequestDispatcher("/book-search.jsp").forward(request, response);
    }
}
