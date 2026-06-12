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
 * CreateUserServlet — Controller xử lý tạo tài khoản đơn lẻ.
 */
@WebServlet(name = "CreateUserServlet", urlPatterns = {"/admin/user/create"})
public class CreateUserServlet extends HttpServlet {

    private final UserService userService;

    public CreateUserServlet() {
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

        int creatorId = (Integer) session.getAttribute("userId");

        // Nhận dữ liệu từ form
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String gender = request.getParameter("gender");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String role = request.getParameter("role");
        String code = request.getParameter("code");
        String major = request.getParameter("major");
        String enrollmentYearStr = request.getParameter("enrollmentYear");
        String department = request.getParameter("department");

        try {
            UserDTO dto = new UserDTO();
            dto.setEmail(email != null ? email.trim() : "");
            dto.setFullName(fullName != null ? fullName.trim() : "");
            dto.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : "");
            dto.setGender(gender != null ? gender.trim() : "Khác");
            
            if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
                dto.setDateOfBirth(Date.valueOf(dateOfBirthStr.trim()));
            }
            
            dto.setRole(role != null ? role.trim().toUpperCase() : "");
            dto.setCode(code != null ? code.trim() : "");
            dto.setMajor(major != null ? major.trim() : null);
            dto.setDepartment(department != null ? department.trim() : null);

            if (enrollmentYearStr != null && !enrollmentYearStr.trim().isEmpty()) {
                dto.setEnrollmentYear(Integer.valueOf(enrollmentYearStr.trim()));
            }

            dto.setStatus("active"); // Mặc định hoạt động

            userService.createUser(dto, creatorId);

            session.setAttribute("successMessage", "Tạo tài khoản thành công cho người dùng: " + email);
        } catch (IllegalArgumentException e) {
            session.setAttribute("errorMessage", "Ngày sinh không đúng định dạng YYYY-MM-DD.");
        } catch (Exception e) {
            session.setAttribute("errorMessage", e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/user");
    }
}
