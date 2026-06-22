package controllers;

import dao.BookDAO;
import dao.BorrowRecordDAO;
import dao.FineDAO;
import dao.LecturerDAO;
import dao.MemberProfileDAO;
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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Book;
import model.BorrowRecord;
import model.Lecturer;
import model.MemberProfile;
import util.DatabaseConnection;

/**
 * LecturerDashboardServlet — Servlet xử lý hiển thị Dashboard cho Giảng viên.
 * Mapped tới URL: /lecturer/dashboard
 */
@WebServlet(name = "LecturerDashboardServlet", urlPatterns = {"/lecturer/dashboard"})
public class LecturerDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LecturerDashboardServlet.class.getName());

    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final FineDAO fineDAO = new FineDAO();
    private final MemberProfileDAO memberProfileDAO = new MemberProfileDAO();
    private final LecturerDAO lecturerDAO = new LecturerDAO();
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null
                || !"LECTURER".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // Truy vấn các thông tin thống kê và dữ liệu giao dịch từ CSDL
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Stats
            request.setAttribute("activeLoansCount",
                    borrowRecordDAO.countActiveBorrowsByUser(conn, userId));
            request.setAttribute("dueSoonCount",
                    borrowRecordDAO.countDueSoonByUser(conn, userId, 3));
            request.setAttribute("reservedCount",
                    reservationDAO.countActiveReservationsByUser(conn, userId));
            request.setAttribute("totalFines",
                    fineDAO.getTotalUnpaidFinesByUser(conn, userId));

            // Sách đang mượn (myLoans)
            List<BorrowRecord> myLoans = borrowRecordDAO.findActiveBorrowRecordsByUserId(conn, userId);
            for (BorrowRecord record : myLoans) {
                Book book = bookDAO.getBookById(record.getBookId());
                record.setBook(book);
            }
            request.setAttribute("myLoans", myLoans);

            // Hoạt động gần đây (recentLoans) - Tối đa 5 hoạt động
            List<BorrowRecord> recentLoans = borrowRecordDAO.findRecentBorrowRecordsByUserId(conn, userId, 5);
            for (BorrowRecord record : recentLoans) {
                Book book = bookDAO.getBookById(record.getBookId());
                record.setBook(book);
            }
            request.setAttribute("recentLoans", recentLoans);

            // Thông tin cá nhân của giảng viên
            Lecturer lecturerInfo = lecturerDAO.findByUserId(userId);
            request.setAttribute("lecturerInfo", lecturerInfo);

            MemberProfile profile = memberProfileDAO.findByUserId(userId);
            request.setAttribute("profile", profile);

        } catch (SQLException e) {
            LOGGER.log(Level.WARNING,
                    "Lỗi khi tải dữ liệu Dashboard cho Lecturer userId=" + userId, e);
        }

        request.getRequestDispatcher("/lecturer/dashboard.jsp").forward(request, response);
    }
}
