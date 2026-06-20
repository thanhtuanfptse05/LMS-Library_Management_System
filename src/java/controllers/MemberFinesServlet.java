package controllers;

import dao.FineDAO;
import dao.SystemConfigDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Fine;
import util.DatabaseConnection;

/**
 * MemberFinesServlet — Hiển thị danh sách phạt và thông tin thanh toán QR
 * cho cả Student và Lecturer.
 *
 * <p>Route: {@code /student/fines} và {@code /lecturer/fines}</p>
 * <p>Lấy danh sách phạt từ FineDAO, tổng tiền nợ chưa thanh toán,
 * và cấu hình SePay (số tài khoản, ngân hàng, tên chủ TK) để sinh VietQR
 * động trên giao diện.</p>
 */
@WebServlet(name = "MemberFinesServlet", urlPatterns = {"/student/fines", "/lecturer/fines"})
public class MemberFinesServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(MemberFinesServlet.class.getName());

    private final FineDAO fineDAO = new FineDAO();
    private final SystemConfigDAO systemConfigDAO = new SystemConfigDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String role = ((String) session.getAttribute("role")).toLowerCase();

        try (Connection conn = DatabaseConnection.getConnection()) {

            // 1. Lấy danh sách phạt (cả paid và unpaid) kèm tên sách
            List<Fine> fines = fineDAO.findFinesByUserId(conn, userId);
            request.setAttribute("fines", fines);

            // 2. Tính tổng tiền phạt chưa thanh toán
            BigDecimal totalUnpaid = fineDAO.getTotalUnpaidFinesByUser(conn, userId);
            request.setAttribute("totalUnpaid", totalUnpaid);

            // 3. Đếm số khoản phạt unpaid
            long unpaidCount = fines.stream().filter(f -> "unpaid".equals(f.getStatus())).count();
            request.setAttribute("unpaidCount", unpaidCount);

            // 4. Lấy cấu hình SePay để sinh VietQR
            String sepayAccountNumber = systemConfigDAO.getValue(conn, "SEPAY_ACCOUNT_NUMBER", "");
            String sepayBankCode = systemConfigDAO.getValue(conn, "SEPAY_BANK_CODE", "MBBank");
            String sepayAccountName = systemConfigDAO.getValue(conn, "SEPAY_ACCOUNT_NAME", "");

            request.setAttribute("sepayAccountNumber", sepayAccountNumber);
            request.setAttribute("sepayBankCode", sepayBankCode);
            request.setAttribute("sepayAccountName", sepayAccountName);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách phạt cho userId=" + userId, e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống khi tải dữ liệu. Vui lòng thử lại sau.");
        }

        // Forward tới JSP tương ứng theo vai trò
        String jspPath = "/" + role + "/fines.jsp";
        request.getRequestDispatcher(jspPath).forward(request, response);
    }
}
