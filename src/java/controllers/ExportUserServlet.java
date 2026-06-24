package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import model.UserDTO;
import service.UserService;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * ExportUserServlet — Controller xử lý xuất danh sách người dùng ra file Excel (.xlsx).
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
        String filename = "danh_sach_nguoi_dung_" + roleClean + ".xlsx";

        // Thiết lập header phản hồi
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        // Tạo file Excel
        try (Workbook workbook = new XSSFWorkbook(); OutputStream out = response.getOutputStream()) {
            Sheet sheet = workbook.createSheet("Danh sách người dùng");

            // Tạo Header dòng tiêu đề cột
            Row headerRow = sheet.createRow(0);
            String[] columns = {"Email", "Họ và tên", "Số điện thoại", "Giới tính", "Ngày sinh", "Mã định danh", "Vai trò", "Trạng thái", "Chuyên ngành hoặc Bộ môn", "Năm nhập học"};
            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
            }

            // Ghi từng dòng dữ liệu
            int rowNum = 1;
            for (UserDTO u : users) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(u.getEmail() != null ? u.getEmail() : "");
                row.createCell(1).setCellValue(u.getFullName() != null ? u.getFullName() : "");
                row.createCell(2).setCellValue(u.getPhoneNumber() != null ? u.getPhoneNumber() : "");
                row.createCell(3).setCellValue(u.getGender() != null ? u.getGender() : "");
                row.createCell(4).setCellValue(u.getDateOfBirth() != null ? u.getDateOfBirth().toString() : "");
                row.createCell(5).setCellValue(u.getCode() != null ? u.getCode() : "");
                row.createCell(6).setCellValue(u.getRole() != null ? u.getRole().toUpperCase() : "");
                
                String statusText = "active".equalsIgnoreCase(u.getStatus()) ? "Hoạt động" : "Đã khóa";
                row.createCell(7).setCellValue(statusText);

                // Chuyên ngành / Bộ môn tùy theo vai trò
                String extraInfo1 = "";
                if ("STUDENT".equalsIgnoreCase(u.getRole())) {
                    extraInfo1 = u.getMajor() != null ? u.getMajor() : "";
                } else if ("LECTURER".equalsIgnoreCase(u.getRole())) {
                    extraInfo1 = u.getDepartment() != null ? u.getDepartment() : "";
                }
                row.createCell(8).setCellValue(extraInfo1);

                // Năm nhập học (chỉ cho Student)
                String extraInfo2 = "";
                if ("STUDENT".equalsIgnoreCase(u.getRole()) && u.getEnrollmentYear() != null) {
                    extraInfo2 = String.valueOf(u.getEnrollmentYear());
                }
                row.createCell(9).setCellValue(extraInfo2);
            }
            
            // Tự động điều chỉnh kích thước cột
            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(out);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
