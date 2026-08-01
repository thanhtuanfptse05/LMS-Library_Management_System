package controllers;

import dao.FineDAO;
import model.Fine;
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

@WebServlet(name = "LibrarianFinesServlet", urlPatterns = {"/librarian/fines"})
public class LibrarianFinesServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LibrarianFinesServlet.class.getName());
    private final FineDAO fineDAO = new FineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"LIBRARIAN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String search = request.getParameter("search");
        String status = request.getParameter("status");

        try (Connection conn = DatabaseConnection.getConnection()) {
            List<Fine> allFines = fineDAO.searchAndFilterFines(conn, search, status);
            request.setAttribute("allFines", allFines);
            request.setAttribute("searchKeyword", search != null ? search.trim() : "");
            request.setAttribute("selectedStatus", status != null ? status.trim() : "all");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách vi phạm/phạt", e);
            request.setAttribute("errorMessage", "Không thể nạp danh sách vi phạm.");
        }

        request.getRequestDispatcher("/librarian/fines.jsp").forward(request, response);
    }
}
