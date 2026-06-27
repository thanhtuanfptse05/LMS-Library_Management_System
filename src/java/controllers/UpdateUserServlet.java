package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import model.UserDTO;
import service.UserService;

/**
 * UpdateUserServlet — Controller xử lý cập nhật tài khoản và khóa/mở khóa.
 */
@WebServlet(name = "UpdateUserServlet", urlPatterns = {"/admin/user/update"})
public class UpdateUserServlet extends HttpServlet {

    private final UserService userService;

    public UpdateUserServlet() {
        this.userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int actorId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Mã người dùng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/user");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdStr.trim());
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Mã người dùng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/user");
            return;
        }

        try {
            if ("updateInfo".equals(action)) {
                String email = request.getParameter("email");
                String fullName = request.getParameter("fullName");
                String phoneNumber = request.getParameter("phoneNumber");
                String gender = request.getParameter("gender");
                String dateOfBirthStr = request.getParameter("dateOfBirth");
                String code = request.getParameter("code");
                String major = request.getParameter("major");
                String enrollmentYearStr = request.getParameter("enrollmentYear");
                String department = request.getParameter("department");
                String status = request.getParameter("status");
                String lockReason = request.getParameter("lockReason");

                UserDTO dto = new UserDTO();
                dto.setUserId(userId);
                dto.setEmail(email != null ? email.trim() : "");
                dto.setFullName(fullName != null ? fullName.trim() : "");
                dto.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : "");
                dto.setGender(gender != null ? gender.trim() : "Khác");
                
                if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
                    dto.setDateOfBirth(Date.valueOf(dateOfBirthStr.trim()));
                }
                
                dto.setCode(code != null ? code.trim() : "");
                dto.setMajor(major != null ? major.trim() : null);
                dto.setDepartment(department != null ? department.trim() : null);
                dto.setStatus(status != null ? status.trim() : "active");

                if (enrollmentYearStr != null && !enrollmentYearStr.trim().isEmpty()) {
                    dto.setEnrollmentYear(Integer.valueOf(enrollmentYearStr.trim()));
                }

                userService.updateUser(dto, actorId);
                session.setAttribute("successMessage", "Cập nhật tài khoản " + email + " thành công.");

            } else if ("toggleStatus".equals(action)) {
                String status = request.getParameter("status");
                String lockReason = request.getParameter("lockReason");

                userService.toggleUserStatus(userId, status, lockReason, actorId);

                String msg = "active".equals(status) ? "Mở khóa tài khoản thành công." : "Khóa tài khoản thành công.";
                session.setAttribute("successMessage", msg);
            } else {
                session.setAttribute("errorMessage", "Hành động không hợp lệ.");
            }
        } catch (IllegalArgumentException e) {
            session.setAttribute("errorMessage", "Ngày sinh không đúng định dạng YYYY-MM-DD.");
        } catch (Exception e) {
            session.setAttribute("errorMessage", e.getMessage());
        }

        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("/admin/dashboard")) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/user");
        }
    }
}
