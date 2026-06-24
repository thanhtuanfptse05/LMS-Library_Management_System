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
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import model.UserDTO;
import service.UserService;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * ImportUserServlet — Controller xử lý import hàng loạt người dùng từ Excel (.xlsx).
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
        
        // Cung cấp chức năng tải file mẫu template Excel (.xlsx)
        if (path.endsWith("/template")) {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"template_import_users.xlsx\"");
            
            try (Workbook workbook = new XSSFWorkbook(); OutputStream out = response.getOutputStream()) {
                Sheet sheet = workbook.createSheet("Tài khoản mẫu");
                
                // Dòng tiêu đề
                Row header = sheet.createRow(0);
                String[] columns = {"Email", "Họ tên", "Số điện thoại", "Giới tính", "Ngày sinh", "Mã số", "Thông tin bổ sung 1", "Thông tin bổ sung 2"};
                for (int i = 0; i < columns.length; i++) {
                    header.createCell(i).setCellValue(columns[i]);
                }
                
                // Dòng mẫu 1 (Student)
                Row r1 = sheet.createRow(1);
                r1.createCell(0).setCellValue("student1@uni.edu.vn");
                r1.createCell(1).setCellValue("Nguyễn Văn A");
                r1.createCell(2).setCellValue("0912345678");
                r1.createCell(3).setCellValue("Nam");
                r1.createCell(4).setCellValue("2005-10-15");
                r1.createCell(5).setCellValue("HE170001");
                r1.createCell(6).setCellValue("Kỹ thuật phần mềm");
                r1.createCell(7).setCellValue("2023");
                
                // Dòng mẫu 2 (Student)
                Row r2 = sheet.createRow(2);
                r2.createCell(0).setCellValue("student2@uni.edu.vn");
                r2.createCell(1).setCellValue("Trần Thị B");
                r2.createCell(2).setCellValue("0987654321");
                r2.createCell(3).setCellValue("Nữ");
                r2.createCell(4).setCellValue("2005-08-20");
                r2.createCell(5).setCellValue("HE170002");
                r2.createCell(6).setCellValue("Khoa học máy tính");
                r2.createCell(7).setCellValue("2023");

                // Dòng mẫu 3 (Lecturer)
                Row r3 = sheet.createRow(3);
                r3.createCell(0).setCellValue("lecturer1@uni.edu.vn");
                r3.createCell(1).setCellValue("Lê Văn C");
                r3.createCell(2).setCellValue("0901234567");
                r3.createCell(3).setCellValue("Nam");
                r3.createCell(4).setCellValue("1980-05-12");
                r3.createCell(5).setCellValue("T10001");
                r3.createCell(6).setCellValue("Công nghệ thông tin");
                r3.createCell(7).setCellValue("");

                for (int i = 0; i < columns.length; i++) {
                    sheet.autoSizeColumn(i);
                }
                
                workbook.write(out);
            } catch (Exception e) {
                e.printStackTrace();
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
                session.setAttribute("errorMessage", "Vui lòng chọn tệp Excel để tải lên.");
                response.sendRedirect(request.getContextPath() + "/admin/user");
                return;
            }

            // Kiểm tra định dạng đuôi file Excel
            String submittedFileName = filePart.getSubmittedFileName();
            if (submittedFileName == null || !submittedFileName.toLowerCase().endsWith(".xlsx")) {
                session.setAttribute("errorMessage", "Hệ thống chỉ chấp nhận định dạng tệp Excel (.xlsx).");
                response.sendRedirect(request.getContextPath() + "/admin/user");
                return;
            }

            List<UserDTO> users = new ArrayList<>();
            try (InputStream is = filePart.getInputStream(); Workbook workbook = new XSSFWorkbook(is)) {
                Sheet sheet = workbook.getSheetAt(0);
                // Đọc từ dòng 1 (bỏ qua dòng tiêu đề ở dòng 0)
                for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                    Row row = sheet.getRow(i);
                    if (row == null) continue;
                    
                    // Kiểm tra dòng trống hoàn toàn
                    boolean isEmptyRow = true;
                    for (int c = 0; c < 8; c++) {
                        if (!getCellValue(row.getCell(c)).isEmpty()) {
                            isEmptyRow = false;
                            break;
                        }
                    }
                    if (isEmptyRow) continue;

                    UserDTO user = new UserDTO();
                    user.setEmail(getCellValue(row.getCell(0)));
                    user.setFullName(getCellValue(row.getCell(1)));
                    user.setPhoneNumber(getCellValue(row.getCell(2)));
                    user.setGender(getCellValue(row.getCell(3)));
                    
                    String dobStr = getCellValue(row.getCell(4));
                    if (dobStr != null && !dobStr.isEmpty()) {
                        try {
                            user.setDateOfBirth(java.sql.Date.valueOf(dobStr));
                        } catch (Exception e) {}
                    }
                    user.setCode(getCellValue(row.getCell(5)));
                    
                    // Thông tin bổ sung
                    String extra1 = getCellValue(row.getCell(6));
                    String extra2 = getCellValue(row.getCell(7));
                    
                    if ("STUDENT".equalsIgnoreCase(role)) {
                        user.setMajor(extra1);
                        try {
                            if (extra2 != null && !extra2.isEmpty()) {
                                // Xử lý nếu file Excel có số dạng 2023.0
                                if (extra2.endsWith(".0")) {
                                    extra2 = extra2.substring(0, extra2.length() - 2);
                                }
                                user.setEnrollmentYear(Integer.parseInt(extra2));
                            }
                        } catch (Exception e) {}
                    } else if ("LECTURER".equalsIgnoreCase(role)) {
                        user.setDepartment(extra1);
                    } else if ("LIBRARIAN".equalsIgnoreCase(role) || "LIBRARY_MANAGER".equalsIgnoreCase(role) || "ADMIN".equalsIgnoreCase(role)) {
                        // Extra info không áp dụng cho staff code, staff code được lưu vào Code ở cột 5
                    }
                    
                    user.setRole(role);
                    user.setStatus("active");
                    
                    users.add(user);
                }
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

    private String getCellValue(Cell cell) {
        if (cell == null) return "";
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                if (org.apache.poi.ss.usermodel.DateUtil.isCellDateFormatted(cell)) {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                    return sdf.format(cell.getDateCellValue());
                }
                // Convert double to long string to avoid scientific notation or .0 for IDs/phone numbers
                long longVal = (long) cell.getNumericCellValue();
                if (cell.getNumericCellValue() == longVal) {
                    return String.valueOf(longVal);
                }
                return String.valueOf(cell.getNumericCellValue());
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            default:
                return "";
        }
    }
}
