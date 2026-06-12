package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.List;
import model.UserDTO;
import service.UserService;

/**
 * ExportUserServlet — Controller xử lý xuất danh sách người dùng ra file CSV (tương thích Excel).
 */
@WebServlet(name = "ExportUserServlet", urlPatterns = {"/admin/user/export"})
public class ExportUserServlet extends HttpServlet {

    private final UserService userService;

    public ExportUserServlet() {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy các tham số lọc hiện tại
        String search = request.getParameter("search");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        // Gọi service lấy toàn bộ dữ liệu khớp bộ lọc
        List<UserDTO> users = userService.getUsersForExport(search, role, status);

        // Chuẩn bị tên file xuất ra tương ứng vai trò
        String roleClean = (role != null && !role.trim().isEmpty() && !"ALL".equalsIgnoreCase(role)) ? role.trim().toUpperCase() : "ALL";
        String filename = "danh_sach_nguoi_dung_" + roleClean + ".csv";

        // Thiết lập header phản hồi
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        // Ghi dữ liệu ra response stream
        try (PrintWriter writer = new PrintWriter(response.getOutputStream(), true, StandardCharsets.UTF_8)) {
            // Ghi UTF-8 BOM để Excel mở trực tiếp nhận diện được tiếng Việt
            writer.write('\uFEFF');

            // Ghi Header dòng tiêu đề cột
            writer.println("Email,Họ và tên,Số điện thoại,Giới tính,Ngày sinh,Mã định danh,Vai trò,Trạng thái,Chuyên ngành hoặc Bộ môn,Năm nhập học");

            // Ghi từng dòng dữ liệu
            for (UserDTO u : users) {
                StringBuilder row = new StringBuilder();
                row.append(escapeCsv(u.getEmail())).append(",");
                row.append(escapeCsv(u.getFullName())).append(",");
                row.append(escapeCsv(u.getPhoneNumber())).append(",");
                row.append(escapeCsv(u.getGender())).append(",");
                row.append(u.getDateOfBirth() != null ? u.getDateOfBirth().toString() : "").append(",");
                row.append(escapeCsv(u.getCode())).append(",");
                row.append(u.getRole() != null ? u.getRole().toUpperCase() : "").append(",");
                
                String statusText = "active".equalsIgnoreCase(u.getStatus()) ? "Hoạt động" : "Đã khóa";
                row.append(statusText).append(",");

                // Chuyên ngành / Bộ môn tùy theo vai trò
                String extraInfo1 = "";
                if ("STUDENT".equalsIgnoreCase(u.getRole())) {
                    extraInfo1 = u.getMajor();
                } else if ("LECTURER".equalsIgnoreCase(u.getRole())) {
                    extraInfo1 = u.getDepartment();
                }
                row.append(escapeCsv(extraInfo1)).append(",");

                // Năm nhập học (chỉ cho Student)
                String extraInfo2 = "";
                if ("STUDENT".equalsIgnoreCase(u.getRole()) && u.getEnrollmentYear() != null) {
                    extraInfo2 = String.valueOf(u.getEnrollmentYear());
                }
                row.append(extraInfo2);

                writer.println(row.toString());
            }
        }
    }

    /**
     * Hàm tiện ích escape ký tự đặc biệt trong CSV.
     */
    private String escapeCsv(String val) {
        if (val == null) {
            return "";
        }
        String cleaned = val.trim();
        if (cleaned.contains(",") || cleaned.contains("\"") || cleaned.contains("\n") || cleaned.contains("\r")) {
            cleaned = cleaned.replace("\"", "\"\"");
            return "\"" + cleaned + "\"";
        }
        return cleaned;
    }
}
