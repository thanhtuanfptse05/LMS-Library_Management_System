package controllers;

import dao.SystemConfigDAO;
import exception.DatabaseException;
import exception.ValidationException;
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
import model.SystemConfiguration;
import service.SystemConfigService;
import util.DatabaseConnection;

/**
 * PaymentConfigServlet — Quản lý cấu hình tích hợp thanh toán SePay QR.
 *
 * <p>Route: {@code /admin/payment-config} (GET + POST)</p>
 *
 * <p>Cho phép Admin xem và cập nhật các thông tin tích hợp SePay:
 * số tài khoản ngân hàng, mã ngân hàng, tên chủ tài khoản, API Key và URL QR
 * dùng để sinh mã QR chuyển khoản cho độc giả thanh toán tiền phạt trực tuyến.</p>
 *
 * <p>Kiểm tra phân quyền qua {@link filter.AuthFilter}: chỉ ADMIN được truy cập.</p>
 */
@WebServlet(name = "PaymentConfigServlet", urlPatterns = {"/admin/payment-config"})
public class PaymentConfigServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PaymentConfigServlet.class.getName());

    private SystemConfigService configService;
    private final SystemConfigDAO configDAO = new SystemConfigDAO();

    @Override
    public void init() throws ServletException {
        this.configService = new SystemConfigService();
    }

    /**
     * GET /admin/payment-config — Hiển thị trang cấu hình SePay.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!isAuthorized(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Lấy các cấu hình SEPAY từ nhóm 'library' (hoặc system nếu admin đã chuyển)
            List<SystemConfiguration> allConfigs = configDAO.findAll(conn);
            List<SystemConfiguration> sepayConfigs = allConfigs.stream()
                    .filter(c -> c.getConfigKey().startsWith("SEPAY_"))
                    .toList();
            request.setAttribute("sepayConfigs", sepayConfigs);

            // Tiện ích: lấy từng key thường dùng để hiển thị preview
            request.setAttribute("sepayAccountNumber",
                    configDAO.getValue(conn, "SEPAY_ACCOUNT_NUMBER", ""));
            request.setAttribute("sepayBankCode",
                    configDAO.getValue(conn, "SEPAY_BANK_CODE", ""));
            request.setAttribute("sepayAccountName",
                    configDAO.getValue(conn, "SEPAY_ACCOUNT_NAME", ""));
            request.setAttribute("sepayApiKey",
                    configDAO.getValue(conn, "SEPAY_API_KEY", ""));

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tải cấu hình SePay", e);
            session.setAttribute("errorMessage", "Lỗi hệ thống khi tải cấu hình thanh toán.");
        }

        request.getRequestDispatcher("/admin/payment-config.jsp").forward(request, response);
    }

    /**
     * POST /admin/payment-config — Cập nhật một key cấu hình SePay.
     *
     * <p>Nhận {@code configKey} và {@code configValue} từ form, validate và lưu vào DB.
     * Tuân thủ PRG pattern: redirect sau khi POST để tránh duplicate submission.</p>
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (!isAuthorized(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int adminId = (int) session.getAttribute("userId");
        String key = request.getParameter("configKey");
        String value = request.getParameter("configValue");

        try {
            // SystemConfigService.update() sẽ kiểm tra key có trong KEY_TYPES không
            // và từ chối nếu nhóm không phải 'library' hoặc 'sepay'
            configService.update(key, value, adminId, "ADMIN", getServletContext());
            session.setAttribute("successMessage",
                    "Cập nhật cấu hình \"" + key + "\" thành công!");

        } catch (ValidationException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (DatabaseException e) {
            LOGGER.log(Level.SEVERE, "Lỗi DB khi cập nhật config key=" + key, e);
            session.setAttribute("errorMessage",
                    "Lỗi hệ thống khi lưu cấu hình. Vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/payment-config");
    }

    private boolean isAuthorized(HttpSession session) {
        if (session == null || session.getAttribute("userId") == null) {
            return false;
        }
        String role = (String) session.getAttribute("role");
        return "ADMIN".equalsIgnoreCase(role);
    }
}
