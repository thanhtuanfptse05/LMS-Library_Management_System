package controllers;

import dao.DocumentTempDAO;
import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import model.DocumentTemp;

/**
 * DocumentTempManagerServlet — Servlet quản lý Mẫu Email cho Manager.
 *
 * <p>URL Pattern: /manager/email-templates</p>
 * <p>Quyền truy cập: MANAGER (kiểm tra qua {@link filter.AuthFilter}).</p>
 *
 * <p>Hỗ trợ các thao tác:</p>
 * <ul>
 *   <li>GET: Hiển thị danh sách mẫu Email.</li>
 *   <li>GET action=edit&amp;tempId=X: Hiển thị form chỉnh sửa một mẫu Email.</li>
 *   <li>POST action=update: Lưu lại nội dung mẫu Email đã sửa.</li>
 * </ul>
 *
 * <p>Ghi AuditLog: Thao tác UPDATE ghi vào bảng AuditLogs (ARCH-02).</p>
 */
@WebServlet(name = "DocumentTempManagerServlet", urlPatterns = {"/manager/email-templates"})
public class DocumentTempManagerServlet extends HttpServlet {

    private final DocumentTempDAO documentTempDAO = new DocumentTempDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO(); // Dùng để ghi AuditLog

    /**
     * GET — Hiển thị danh sách mẫu Email hoặc form chỉnh sửa.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorizedManager(request, response)) return;

        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            // Hiển thị form chỉnh sửa một mẫu cụ thể
            String idParam = request.getParameter("tempId");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/manager/email-templates?error=ID+không+hợp+lệ");
                return;
            }
            try {
                int tempId = Integer.parseInt(idParam.trim());
                DocumentTemp dt = documentTempDAO.findById(tempId);
                if (dt == null) {
                    response.sendRedirect(request.getContextPath() + "/manager/email-templates?error=Không+tìm+thấy+mẫu+email");
                    return;
                }
                request.setAttribute("editTemplate", dt);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/manager/email-templates?error=ID+không+hợp+lệ");
                return;
            }
        }

        // Luôn load danh sách để hiển thị sidebar/table
        List<DocumentTemp> templates = documentTempDAO.getAll();
        request.setAttribute("templates", templates);
        request.getRequestDispatcher("/manager/manage-email-templates.jsp").forward(request, response);
    }

    /**
     * POST — Cập nhật nội dung mẫu Email.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorizedManager(request, response)) return;

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        int managerId = (int) session.getAttribute("userId");

        if ("update".equals(action)) {
            handleUpdate(request, response, managerId);
        } else if ("create".equals(action)) {
            handleCreate(request, response, managerId);
        } else if ("delete".equals(action)) {
            handleDelete(request, response, managerId);
        } else {
            response.sendRedirect(request.getContextPath() + "/manager/email-templates");
        }
    }

    /**
     * Xử lý tạo mới mẫu Email (POST action=create). Ghi AuditLog sau INSERT.
     */
    private void handleCreate(HttpServletRequest request, HttpServletResponse response, int managerId)
            throws IOException {

        String tempName   = request.getParameter("tempName");
        String subject    = request.getParameter("subject");
        String bodyContent = request.getParameter("bodyContent");

        if (tempName == null || tempName.trim().isEmpty()
                || subject == null || subject.trim().isEmpty()) {
            redirectTo(response, request, "error", "Dữ liệu không hợp lệ");
            return;
        }

        DocumentTemp dt = new DocumentTemp();
        dt.setTempName(tempName.trim().toUpperCase().replace(" ", "_"));
        dt.setSubject(subject.trim());
        dt.setBodyContent(bodyContent != null ? bodyContent.trim() : "");
        dt.setManagerId(managerId);

        int newId = documentTempDAO.insert(dt);
        if (newId > 0) {
            notificationDAO.insertAuditLog(managerId, "CREATE_EMAIL_TEMPLATE", "DocumentTemp", newId,
                    null, "tempName=" + dt.getTempName() + "; subject=" + subject);
            redirectTo(response, request, "success", "Đã tạo mẫu email thành công");
        } else {
            redirectTo(response, request, "error", "Tạo mẫu thất bại hoặc mã định danh đã tồn tại");
        }
    }

    /**
     * Xử lý cập nhật nội dung mẫu Email.
     * Ghi AuditLog sau khi UPDATE thành công (ARCH-02).
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, int managerId)
            throws IOException {

        String idParam = request.getParameter("tempId");
        String subject = request.getParameter("subject");
        String bodyContent = request.getParameter("bodyContent");

        if (idParam == null || idParam.trim().isEmpty() || subject == null || subject.trim().isEmpty()) {
            redirectTo(response, request, "error", "Dữ liệu không hợp lệ");
            return;
        }

        try {
            int tempId = Integer.parseInt(idParam.trim());

            // Lấy dữ liệu cũ để ghi AuditLog
            DocumentTemp old = documentTempDAO.findById(tempId);

            DocumentTemp dt = new DocumentTemp();
            dt.setTempId(tempId);
            dt.setSubject(subject.trim());
            dt.setBodyContent(bodyContent != null ? bodyContent.trim() : "");

            boolean updated = documentTempDAO.update(dt);

            if (updated) {
                String oldVal = old != null ? "subject=" + old.getSubject() : null;
                String newVal = "subject=" + subject;
                notificationDAO.insertAuditLog(managerId, "UPDATE_EMAIL_TEMPLATE", "DocumentTemp", tempId, oldVal, newVal);
                redirectTo(response, request, "success", "Đã cập nhật mẫu email thành công");
            } else {
                redirectTo(response, request, "error", "Cập nhật thất bại");
            }
        } catch (NumberFormatException e) {
            redirectTo(response, request, "error", "ID không hợp lệ");
        }
    }

    /**
     * Xử lý xóa mẫu Email.
     * Mẫu hệ thống ({@link dao.DocumentTempDAO#PROTECTED_TEMPLATES}) KHÔNG ĐƯỢC PHÉP xóa.
     * Ghi AuditLog sau khi DELETE thành công (ARCH-02).
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, int managerId)
            throws IOException {
        String idParam = request.getParameter("tempId");
        if (idParam == null || idParam.trim().isEmpty()) {
            redirectTo(response, request, "error", "ID không hợp lệ");
            return;
        }

        try {
            int tempId = Integer.parseInt(idParam.trim());
            DocumentTemp old = documentTempDAO.findById(tempId);
            if (old == null) {
                redirectTo(response, request, "error", "Không tìm thấy mẫu email");
                return;
            }

            // Kiểm tra bảo vệ mẫu hệ thống — KHÔNG ĐƯỢC PHÉP XÓA
            if (documentTempDAO.isProtected(tempId)) {
                redirectTo(response, request, "error",
                        "Không thể xóa mẫu email hệ thống '" + old.getTempName()
                        + "'. Đây là mẫu cốt lõi được dùng bởi tiến trình tự động. Bạn chỉ có thể chỉnh sửa nội dung.");
                return;
            }

            boolean deleted = documentTempDAO.delete(tempId);
            if (deleted) {
                String oldVal = "tempName=" + old.getTempName() + "; subject=" + old.getSubject();
                notificationDAO.insertAuditLog(managerId, "DELETE_EMAIL_TEMPLATE", "DocumentTemp", tempId, oldVal, null);
                redirectTo(response, request, "success", "Đã xóa mẫu email thành công");
            } else {
                redirectTo(response, request, "error", "Xóa thất bại");
            }
        } catch (NumberFormatException e) {
            redirectTo(response, request, "error", "ID không hợp lệ");
        }
    }


    /** Helper: redirect với message đã được URL-encode đúng chuẩn UTF-8. */
    private void redirectTo(HttpServletResponse response, HttpServletRequest request,
                            String paramName, String message) throws IOException {
        String encoded = URLEncoder.encode(message, StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/manager/email-templates?" + paramName + "=" + encoded);
    }

    /**
     * Kiểm tra xác thực và phân quyền Manager.
     *
     * @return true nếu hợp lệ, false nếu đã redirect/error
     */
    private boolean isAuthorizedManager(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String role = (String) session.getAttribute("role");
        if (!"MANAGER".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập.");
            return false;
        }
        return true;
    }
}
