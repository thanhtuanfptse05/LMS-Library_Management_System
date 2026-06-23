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
            
            // ── 2.5. Recent Activity (Hoạt động gần đây) ──
            loadRecentLoans(conn, userId, request);
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
     * Tải danh sách hoạt động gần đây (recent loans) kèm thông tin Book đầy đủ.
     */
    private void loadRecentLoans(Connection conn, int userId, HttpServletRequest request) {
        try {
            List<BorrowRecord> recentLoans = borrowRecordDAO.findRecentBorrowRecordsByUserId(conn, userId, 5);
            for (BorrowRecord record : recentLoans) {
                Book book = bookDAO.getBookById(record.getBookId());
                record.setBook(book);
            }
            request.setAttribute("recentLoans", recentLoans);
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING,
                    "Lỗi khi tải danh sách hoạt động gần đây cho userId=" + userId, e);
        }
    }

    private static final String REASONS_CACHE_KEY = "cachedRecommendationReasons";
    private static final String IS_AI_CACHE_KEY = "cachedIsAiPowered";

    /**
     * Tải danh sách sách gợi ý: Session Cache → AI → Fallback Top Trending.
     * Logic tương tự từ RecommendationServlet để đồng bộ nhất quán.
     */
    @SuppressWarnings("unchecked")
    private void loadRecommendedBooks(HttpSession session, int userId, HttpServletRequest request) {
        List<Book> recommendedBooks = new ArrayList<>();
        java.util.Map<Integer, String> recommendationReasons = new java.util.HashMap<>();
        boolean isAiPowered = false;

        try {
            // Bước 1: Kiểm tra Session Cache
            List<Book> cached = (List<Book>) session.getAttribute(CACHE_KEY);
            java.util.Map<Integer, String> cachedReasons = (java.util.Map<Integer, String>) session.getAttribute(REASONS_CACHE_KEY);
            Boolean cachedIsAi = (Boolean) session.getAttribute(IS_AI_CACHE_KEY);
            
            if (cached != null && !cached.isEmpty()) {
                LOGGER.log(Level.FINE,
                        "[Dashboard-REC] Cache HIT - Trả về gợi ý đã cache ({0} sách).", cached.size());
                request.setAttribute("recommendedBooks", cached);
                request.setAttribute("recommendationReasons", cachedReasons != null ? cachedReasons : new java.util.HashMap<>());
                request.setAttribute("isAiPowered", cachedIsAi != null ? cachedIsAi : false);
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

                java.util.Map<Integer, String> aiRecommendations
                        = aiService.getRecommendationsWithReasons(freqProfile, recentHistory, candidatePool);

                if (aiRecommendations != null && !aiRecommendations.isEmpty()) {
                    for (java.util.Map.Entry<Integer, String> entry : aiRecommendations.entrySet()) {
                        int id = entry.getKey();
                        Book book = bookDAO.getBookById(id);
                        if (book != null) {
                            recommendedBooks.add(book);
                            recommendationReasons.put(id, entry.getValue());
                        }
                    }
                    isAiPowered = true;
                }

                // Lưu cache nếu AI trả về kết quả
                if (!recommendedBooks.isEmpty()) {
                    session.setAttribute(CACHE_KEY, recommendedBooks);
                    session.setAttribute(REASONS_CACHE_KEY, recommendationReasons);
                    session.setAttribute(IS_AI_CACHE_KEY, isAiPowered);
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
                isAiPowered = false;
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING,
                    "Lỗi khi tải sách gợi ý cho userId=" + userId + ". Fallback Top Trending.", e);
            try {
                recommendedBooks = bookDAO.getTopTrendingBooks(4);
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Lỗi nghiêm trọng khi tải fallback books", ex);
            }
            isAiPowered = false;
        }

        request.setAttribute("recommendedBooks", recommendedBooks);
        request.setAttribute("recommendationReasons", recommendationReasons);
        request.setAttribute("isAiPowered", isAiPowered);
    }
}
