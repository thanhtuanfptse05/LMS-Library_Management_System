package controllers;

import dao.BorrowRecordDAO;
import model.BorrowRecord;
import util.DatabaseConnection;

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

@WebServlet(name = "LibrarianMyCirculationHistoryServlet", urlPatterns = {"/librarian/my-circulations"})
public class LibrarianMyCirculationHistoryServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LibrarianMyCirculationHistoryServlet.class.getName());
    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"LIBRARIAN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int librarianId = (int) session.getAttribute("userId");

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Lấy danh sách giao dịch mượn/trả do thủ thư này tạo. Giới hạn đủ lớn để xem.
            List<BorrowRecord> myLoans = borrowRecordDAO.findLoansByLibrarian(conn, librarianId, 500);
            request.setAttribute("myLoans", myLoans);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách giao dịch cho thủ thư", e);
            request.setAttribute("errorMessage", "Không thể nạp dữ liệu từ hệ thống.");
        }

        request.getRequestDispatcher("/librarian/my-circulations.jsp").forward(request, response);
    }
}
