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
import dto.UserDTO;
import service.UserService;
import dao.UserDAO;
import java.util.HashSet;
import java.util.Set;
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
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int actorId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "upload";
        }

        try {
            if ("upload".equals(action)) {
                String role = request.getParameter("role");
                if (role == null || role.trim().isEmpty()) {
                    throw new Exception("Vui lòng lựa chọn vai trò cho đợt import này.");
                }

                Part filePart = request.getPart("file");
                if (filePart == null || filePart.getSize() == 0) {
                    throw new Exception("Vui lòng chọn tệp Excel để tải lên.");
                }

                String submittedFileName = filePart.getSubmittedFileName();
                if (submittedFileName == null || !submittedFileName.toLowerCase().endsWith(".xlsx")) {
                    throw new Exception("Hệ thống chỉ chấp nhận định dạng tệp Excel (.xlsx).");
                }

                List<UserDTO> users = new ArrayList<>();
                try (InputStream is = filePart.getInputStream(); Workbook workbook = new XSSFWorkbook(is)) {
                    Sheet sheet = workbook.getSheetAt(0);
                    for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                        Row row = sheet.getRow(i);
                        if (row == null) continue;
                        
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
                        
                        String extra1 = getCellValue(row.getCell(6));
                        String extra2 = getCellValue(row.getCell(7));
                        
                        if ("STUDENT".equalsIgnoreCase(role)) {
                            user.setMajor(extra1);
                            try {
                                if (extra2 != null && !extra2.isEmpty()) {
                                    if (extra2.endsWith(".0")) {
                                        extra2 = extra2.substring(0, extra2.length() - 2);
                                    }
                                    user.setEnrollmentYear(Integer.parseInt(extra2));
                                }
                            } catch (Exception e) {}
                        } else if ("LECTURER".equalsIgnoreCase(role)) {
                            user.setDepartment(extra1);
                        }
                        
                        user.setRole(role);
                        user.setStatus("active");
                        
                        users.add(user);
                    }
                }

                if (users.isEmpty()) {
                    throw new Exception("Tệp tải lên không chứa dữ liệu hoặc sai cấu trúc.");
                }

                // Chạy kiểm tra Phase 1
                List<String> errors = validateUsers(users, role);

                session.setAttribute("userImportList", users);
                session.setAttribute("userImportRole", role);
                session.setAttribute("userImportFileName", submittedFileName);
                session.setAttribute("userImportErrors", errors);

            } else if ("confirm".equals(action)) {
                @SuppressWarnings("unchecked")
                List<UserDTO> users = (List<UserDTO>) session.getAttribute("userImportList");
                String role = (String) session.getAttribute("userImportRole");
                @SuppressWarnings("unchecked")
                List<String> errors = (List<String>) session.getAttribute("userImportErrors");

                if (users == null || role == null) {
                    throw new Exception("Không có tệp hợp lệ đang chờ xác nhận.");
                }
                if (errors != null && !errors.isEmpty()) {
                    throw new Exception("Tệp dữ liệu vẫn còn lỗi, không thể xác nhận.");
                }

                // Thực thi xử lý import
                userService.importUsers(users, role, actorId);

                // Dọn dẹp session
                session.removeAttribute("userImportList");
                session.removeAttribute("userImportRole");
                session.removeAttribute("userImportFileName");
                session.removeAttribute("userImportErrors");

                session.setAttribute("successMessage", "Import thành công " + users.size() + " tài khoản vai trò: " + role.toUpperCase());
            } else if ("clear".equals(action)) {
                // Dọn dẹp session
                session.removeAttribute("userImportList");
                session.removeAttribute("userImportRole");
                session.removeAttribute("userImportFileName");
                session.removeAttribute("userImportErrors");
            } else {
                throw new Exception("Thao tác import không hợp lệ.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/user");
    }

    private List<String> validateUsers(List<UserDTO> users, String role) {
        List<String> errors = new ArrayList<>();
        Set<String> emailsInFile = new HashSet<>();
        Set<String> codesInFile = new HashSet<>();
        String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";
        UserDAO userDAO = new UserDAO();

        for (int i = 0; i < users.size(); i++) {
            UserDTO u = users.get(i);
            int rowNum = i + 2;

            // 1. Validate Email
            if (u.getEmail() == null || u.getEmail().trim().isEmpty()) {
                errors.add("Dòng " + rowNum + ": Email không được để trống.");
            } else {
                String email = u.getEmail().trim().toLowerCase();
                if (!email.matches(emailPattern)) {
                    errors.add("Dòng " + rowNum + ": Email '" + u.getEmail() + "' sai định dạng.");
                } else if (emailsInFile.contains(email)) {
                    errors.add("Dòng " + rowNum + ": Email '" + u.getEmail() + "' bị trùng lặp trong file tải lên.");
                } else {
                    emailsInFile.add(email);
                    if (userDAO.existsByEmail(email, null)) {
                        errors.add("Dòng " + rowNum + ": Email '" + u.getEmail() + "' đã tồn tại trong hệ thống.");
                    }
                }
            }

            // 2. Validate Họ và tên
            if (u.getFullName() == null || u.getFullName().trim().isEmpty()) {
                errors.add("Dòng " + rowNum + ": Họ và tên không được để trống.");
            }

            // 3. Validate Mã số định danh
            if (u.getCode() == null || u.getCode().trim().isEmpty()) {
                errors.add("Dòng " + rowNum + ": Mã số định danh không được để trống.");
            } else {
                String code = u.getCode().trim().toUpperCase();
                if (codesInFile.contains(code)) {
                    errors.add("Dòng " + rowNum + ": Mã số '" + u.getCode() + "' bị trùng lặp trong file tải lên.");
                } else {
                    codesInFile.add(code);
                    if (userDAO.existsByCode(code, role, null)) {
                        errors.add("Dòng " + rowNum + ": Mã số '" + u.getCode() + "' đã tồn tại trong hệ thống.");
                    }
                }
            }

            // 4. Validate Ngày sinh
            if (u.getDateOfBirth() == null) {
                errors.add("Dòng " + rowNum + ": Ngày sinh trống hoặc sai định dạng (yêu cầu yyyy-MM-dd).");
            }

            // 5. Validate Giới tính
            if (u.getGender() != null && !u.getGender().trim().isEmpty()) {
                String g = u.getGender().trim();
                if (!"Nam".equalsIgnoreCase(g) && !"Nữ".equalsIgnoreCase(g) && !"Khác".equalsIgnoreCase(g)) {
                    errors.add("Dòng " + rowNum + ": Giới tính '" + u.getGender() + "' không hợp lệ (chỉ chấp nhận: Nam, Nữ, Khác).");
                }
            }
        }
        return errors;
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
