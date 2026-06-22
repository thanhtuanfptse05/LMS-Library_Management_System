package controllers;

import dao.BookDAO;
import dao.BorrowRecordDAO;
import dao.FineDAO;
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
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Book;
import model.BorrowRecord;
import model.BookSummaryDTO;
import service.AiRecommendationService;
import util.DatabaseConnection;

@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/student/dashboard"})
public class StudentDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(StudentDashboardServlet.class.getName());

    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final FineDAO fineDAO = new FineDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final AiRecommendationService aiService = new AiRecommendationService();

    private static final String CACHE_KEY = "cachedRecommendations";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null
                || !"STUDENT".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try (Connection conn = DatabaseConnection.getConnection()) {
            // ── 1. Stats Cards (4 KPI metrics) ──
            request.setAttribute("activeLoansCount",
                    borrowRecordDAO.countActiveBorrowsByUser(conn, userId));
            request.setAttribute("dueSoonCount",
                    borrowRecordDAO.countDueSoonByUser(conn, userId, 3));
            request.setAttribute("reservedCount",
                    reservationDAO.countActiveReservationsByUser(conn, userId));
            request.setAttribute("totalFines",
                    fineDAO.getTotalUnpaidFinesByUser(conn, userId));

            // ── 2. Active Loans (Sách đang đọc) ──
            loadActiveLoans(conn, userId, request);
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING,
                    "Lỗi khi tải thống kê Dashboard cho Student userId=" + userId, e);
        }

        // ── 3. Recommended Books (Gợi ý cho bạn) ──
        loadRecommendedBooks(session, userId, request);

        request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
    }

    /**
     * Tải danh sách sách đang mượn (active loans) kèm thông tin Book đầy đủ.
     */
    private void loadActiveLoans(Connection conn, int userId, HttpServletRequest request) {
        try {
            List<BorrowRecord> activeLoans = borrowRecordDAO.findActiveBorrowRecordsByUserId(conn, userId);
            for (BorrowRecord record : activeLoans) {
                Book book = bookDAO.getBookById(record.getBookId());
                record.setBook(book);
            }
            request.setAttribute("activeLoans", activeLoans);
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING,
                    "Lỗi khi tải danh sách sách đang mượn cho userId=" + userId, e);
        }
    }

    /**
     * Tải danh sách sách gợi ý: Session Cache → AI → Fallback Top Trending.
     * Logic tái sử dụng từ RecommendationServlet để đồng bộ nhất quán.
     */
    @SuppressWarnings("unchecked")
    private void loadRecommendedBooks(HttpSession session, int userId, HttpServletRequest request) {
        List<Book> recommendedBooks = new ArrayList<>();

        try {
            // Bước 1: Kiểm tra Session Cache
            List<Book> cached = (List<Book>) session.getAttribute(CACHE_KEY);
            if (cached != null && !cached.isEmpty()) {
                LOGGER.log(Level.FINE,
                        "[Dashboard-REC] Cache HIT - Trả về gợi ý đã cache ({0} sách).", cached.size());
                request.setAttribute("recommendedBooks", cached);
                return;
            }

            // Bước 2: Kiểm tra lịch sử mượn >= 3 để gọi AI
            int borrowCount = borrowRecordDAO.countUserBorrowHistory(userId);
            LOGGER.log(Level.FINE,
                    "[Dashboard-REC] userId={0}, borrowCount={1} (cần >= 3)",
                    new Object[]{userId, borrowCount});

            if (borrowCount >= 3) {
                java.util.Map<String, java.util.Map<String, Integer>> freqProfile
                        = bookDAO.getUserTagCategoryFrequency(userId);
                List<BookSummaryDTO> recentHistory = bookDAO.getRecentBorrowedSummary(userId, 3);
                List<BookSummaryDTO> candidatePool
                        = bookDAO.getCandidatePoolWithTagsAndCategories(userId, 30);

                List<Integer> aiRecommendedIds
                        = aiService.getRecommendations(freqProfile, recentHistory, candidatePool);

                if (aiRecommendedIds != null && !aiRecommendedIds.isEmpty()) {
                    for (Integer id : aiRecommendedIds) {
                        Book book = bookDAO.getBookById(id);
                        if (book != null) {
                            recommendedBooks.add(book);
                        }
                    }
                }

                // Lưu cache nếu AI trả về kết quả
                if (!recommendedBooks.isEmpty()) {
                    session.setAttribute(CACHE_KEY, recommendedBooks);
                    LOGGER.log(Level.FINE,
                            "[Dashboard-REC] Cached {0} sách gợi ý AI cho userId={1}.",
                            new Object[]{recommendedBooks.size(), userId});
                }
            }

            // Bước 3: Fallback — nếu AI không trả hoặc chưa đủ lịch sử
            if (recommendedBooks.isEmpty()) {
                LOGGER.log(Level.FINE,
                        "[Dashboard-REC] FALLBACK -> Top Trending (userId={0})", userId);
                recommendedBooks = bookDAO.getTopTrendingBooks(4);
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING,
                    "Lỗi khi tải sách gợi ý cho userId=" + userId + ". Fallback Top Trending.", e);
            recommendedBooks = bookDAO.getTopTrendingBooks(4);
        }

        request.setAttribute("recommendedBooks", recommendedBooks);
    }
}
