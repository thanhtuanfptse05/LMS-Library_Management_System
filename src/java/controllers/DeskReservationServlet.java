package controllers;

import dao.BookDAO;
import dao.UserDAO;
import dao.UserLookupDAO;
import exception.DatabaseException;
import exception.ValidationException;
import model.Book;
import model.User;
import service.OnlineCirculationService;
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
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DeskReservationServlet — Controller xử lý luồng đặt trước sách trực tiếp tại quầy của Thủ thư.
 * Phân quyền: LIBRARIAN.
 */
@WebServlet(name = "DeskReservationServlet", urlPatterns = {"/librarian/reserve"})
public class DeskReservationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DeskReservationServlet.class.getName());

    private UserLookupDAO userLookupDAO;
    private UserDAO userDAO;
    private BookDAO bookDAO;
    private dao.BookCopyDAO bookCopyDAO;
    private OnlineCirculationService onlineCirculationService;

    @Override
    public void init() throws ServletException {
        this.userLookupDAO = new UserLookupDAO();
        this.userDAO = new UserDAO();
        this.bookDAO = new BookDAO();
        this.bookCopyDAO = new dao.BookCopyDAO();
        this.onlineCirculationService = new OnlineCirculationService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorized(request, response)) return;

        HttpSession session = request.getSession(false);
        String memberCodeRaw = request.getParameter("memberCode");
        String bookIdOrIsbnRaw = request.getParameter("bookIdOrIsbn");

        if (memberCodeRaw == null || memberCodeRaw.isBlank()) {
            session.setAttribute("errorMessage", "Vui lòng nhập hoặc quét mã số độc giả.");
            response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard");
            return;
        }

        if (bookIdOrIsbnRaw == null || bookIdOrIsbnRaw.isBlank()) {
            session.setAttribute("errorMessage", "Vui lòng nhập Mã đầu sách hoặc mã ISBN.");
            response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCodeRaw.trim());
            return;
        }

        String memberCode = memberCodeRaw.trim();
        String bookIdOrIsbn = bookIdOrIsbnRaw.trim();

        try {
            Integer userId = null;
            String role = null;
            Integer bookId = null;

            try (Connection conn = DatabaseConnection.getConnection()) {
                // 1. Ánh xạ mã số độc giả sang userId
                userId = userLookupDAO.findUserIdByMemberCode(conn, memberCode);
                if (userId == null) {
                    session.setAttribute("errorMessage", "Mã số độc giả '" + memberCode + "' không tồn tại trong hệ thống.");
                    response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCode);
                    return;
                }

                // 2. Tìm thông tin tài khoản để xác định vai trò (role)
                User user = userDAO.findByUserId(userId);
                if (user == null) {
                    session.setAttribute("errorMessage", "Tài khoản của độc giả không tồn tại.");
                    response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCode);
                    return;
                }
                role = user.getRole();

                // 3. Tìm đầu sách dựa trên bookId (nếu là số), barcode hoặc ISBN
                try {
                    int parsedId = Integer.parseInt(bookIdOrIsbn);
                    Book bookById = bookDAO.findById(conn, parsedId);
                    if (bookById != null) {
                        bookId = bookById.getBookId();
                    }
                } catch (NumberFormatException e) {
                    // Không phải số
                }

                // Thử tìm theo Barcode (Mã vạch bản sao)
                if (bookId == null) {
                    model.BookCopy copy = bookCopyDAO.findByBarcode(conn, bookIdOrIsbn);
                    if (copy != null) {
                        bookId = copy.getBookId();
                    }
                }

                // Thử tìm theo ISBN
                if (bookId == null) {
                    Book bookByIsbn = bookDAO.findByIsbn(conn, bookIdOrIsbn);
                    if (bookByIsbn != null) {
                        bookId = bookByIsbn.getBookId();
                    }
                }
            }

            if (bookId == null) {
                session.setAttribute("errorMessage", "Không tìm thấy đầu sách với Mã đầu sách, Barcode hoặc ISBN: '" + bookIdOrIsbn + "'.");
                response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCode);
                return;
            }

            // 4. Gọi Service thực hiện nghiệp vụ đặt trước sách
            onlineCirculationService.reserveBook(userId, bookId, role);

            session.setAttribute("successMessage", "Đã đăng ký đặt trước sách thành công cho độc giả " + memberCode + ".");
            response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCode);

        } catch (ValidationException e) {
            // Lỗi nghiệp vụ (tài khoản khóa, nợ phạt, quá giới hạn, trùng đặt trước...)
            session.setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCode);
        } catch (DatabaseException | SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi hệ thống khi tạo đặt trước cho độc giả: " + memberCode, e);
            session.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống khi xử lý đặt trước sách.");
            response.sendRedirect(request.getContextPath() + "/librarian/desk-dashboard?memberCode=" + memberCode);
        }
    }

    private boolean isAuthorized(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null
                || session.getAttribute("userId") == null
                || !"LIBRARIAN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
