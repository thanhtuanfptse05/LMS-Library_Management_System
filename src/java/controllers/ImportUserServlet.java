package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.List;
import model.UserDTO;
import service.UserService;
import util.CSVHelper;

/**
 * ImportUserServlet — Controller xử lý import hàng loạt người dùng từ CSV.
 */
@WebServlet(name = "ImportUserServlet", urlPatterns = {"/admin/user/import", "/admin/user/import/template"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 15     // 15 MB
)
public class ImportUserServlet extends HttpServlet {

    private final UserService userService;

    public ImportUserServlet() {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getRequestURI();
        
        // Cung cấp chức năng tải file mẫu template CSV
        if (path.endsWith("/template")) {
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"template_import_users.csv\"");
            
            // Ghi UTF-8 BOM để Excel hiển thị đúng tiếng Việt
            try (PrintWriter writer = new PrintWriter(response.getOutputStream(), true, java.nio.charset.StandardCharsets.UTF_8)) {
                writer.write('\uFEFF'); 
                writer.println("Email,Họ tên,Số điện thoại,Giới tính,Ngày sinh,Mã số,Thông tin bổ sung 1,Thông tin bổ sung 2");
                writer.println("student1@uni.edu.vn,Nguyễn Văn A,0912345678,Nam,2005-10-15,HE170001,Kỹ thuật phần mềm,2023");
                writer.println("student2@uni.edu.vn,Trần Thị B,0987654321,Nữ,2005-08-20,HE170002,Khoa học máy tính,2023");
                writer.println("lecturer1@uni.edu.vn,Lê Văn C,0901234567,Nam,1980-05-12,T10001,Công nghệ thông tin,");
            }
            return;
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/user");
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
        String role = request.getParameter("role");

        if (role == null || role.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Vui lòng lựa chọn vai trò cho đợt import này.");
            response.sendRedirect(request.getContextPath() + "/admin/user");
            return;
        }

        try {
            Part filePart = request.getPart("file");
            if (filePart == null || filePart.getSize() == 0) {
                session.setAttribute("errorMessage", "Vui lòng chọn tệp CSV để tải lên.");
                response.sendRedirect(request.getContextPath() + "/admin/user");
                return;
            }

            // Kiểm tra định dạng đuôi file
            String submittedFileName = filePart.getSubmittedFileName();
            if (submittedFileName == null || !submittedFileName.toLowerCase().endsWith(".csv")) {
                session.setAttribute("errorMessage", "Hệ thống chỉ chấp nhận định dạng tệp CSV (.csv) xuất bản từ Excel.");
                response.sendRedirect(request.getContextPath() + "/admin/user");
                return;
            }

            List<UserDTO> users;
            try (InputStream is = filePart.getInputStream()) {
                users = CSVHelper.parseCSV(is);
            }

            if (users.isEmpty()) {
                session.setAttribute("errorMessage", "Tệp tải lên không chứa dữ liệu hoặc sai cấu trúc.");
                response.sendRedirect(request.getContextPath() + "/admin/user");
                return;
            }

            // Thực thi xử lý import (gồm validate Phase 1 và Transaction Phase 2)
            userService.importUsers(users, role, actorId);

            session.setAttribute("successMessage", "Import thành công " + users.size() + " tài khoản vai trò: " + role.toUpperCase());
        } catch (Exception e) {
            // Đẩy lỗi chi tiết vào session để view hiển thị dạng bảng lỗi
            session.setAttribute("importErrors", e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/user");
    }
}
