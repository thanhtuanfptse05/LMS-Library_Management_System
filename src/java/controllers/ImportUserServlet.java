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
import java.util.logging.Level;
import java.util.logging.Logger;
import dto.UserDTO;
import service.UserService;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * ImportUserServlet — Controller xử lý import hàng loạt người dùng từ Excel (.xlsx).
 *
 * <p>Chức năng:</p>
 * <ul>
 *   <li>GET /admin/user/import/template — Tải file mẫu Excel template</li>
 *   <li>POST action=upload — Parse file Excel, gọi Service validate (Phase 1), lưu preview vào Session</li>
 *   <li>POST action=confirm — Xác nhận import, gọi Service thực thi Phase 2 (DB Transaction)</li>
 *   <li>POST action=clear — Hủy bỏ phiên import, dọn dẹp Session</li>
 * </ul>
 *
 * <p>Validate logic DUY NHẤT nằm ở {@link UserService#validateImportData(List, String)}.
 * Servlet chỉ đảm nhận Parse Excel và điều phối request.</p>
 */
@WebServlet(name = "ImportUserServlet", urlPatterns = {"/admin/user/import", "/admin/user/import/template"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 15     // 15 MB
)
public class ImportUserServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ImportUserServlet.class.getName());
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
                LOGGER.log(Level.SEVERE, "Lỗi khi tạo file template import user", e);
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
                handleUpload(request, session);

            } else if ("confirm".equals(action)) {
                handleConfirm(session, actorId);

            } else if ("clear".equals(action)) {
                clearImportSession(session);
            } else {
                throw new Exception("Thao tác import không hợp lệ.");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/user");
    }

    /**
     * Xử lý action=upload: Parse file Excel → validate Phase 1 qua Service → lưu Session.
     */
    private void handleUpload(HttpServletRequest request, HttpSession session) throws Exception {
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

        // Parse Excel → List<UserDTO>
        List<UserDTO> users = parseExcelFile(filePart, role);

        if (users.isEmpty()) {
            throw new Exception("Tệp tải lên không chứa dữ liệu hoặc sai cấu trúc.");
        }

        // Gọi Service validate Phase 1 (DUY NHẤT tại đây, không validate ở Servlet nữa)
        List<String> errors = userService.validateImportData(users, role);

        session.setAttribute("userImportList", users);
        session.setAttribute("userImportRole", role);
        session.setAttribute("userImportFileName", submittedFileName);
        session.setAttribute("userImportErrors", errors);
    }

    /**
     * Xử lý action=confirm: Kiểm tra không còn lỗi → gọi Service import Phase 2.
     */
    private void handleConfirm(HttpSession session, int actorId) throws Exception {
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

        // Thực thi Phase 2: Hash BCrypt + DB Transaction (All-or-Nothing)
        userService.importUsers(users, role, actorId);

        // Dọn dẹp session sau khi import thành công
        clearImportSession(session);

        session.setAttribute("successMessage", "Import thành công " + users.size() + " tài khoản vai trò: " + role.toUpperCase());
    }

    /**
     * Dọn dẹp toàn bộ dữ liệu import khỏi Session.
     */
    private void clearImportSession(HttpSession session) {
        session.removeAttribute("userImportList");
        session.removeAttribute("userImportRole");
        session.removeAttribute("userImportFileName");
        session.removeAttribute("userImportErrors");
    }

    /**
     * Parse file Excel (.xlsx) thành danh sách UserDTO.
     * Xử lý lỗi parse ngày tháng và năm nhập học một cách tường minh (không nuốt lỗi).
     */
    private List<UserDTO> parseExcelFile(Part filePart, String role) throws Exception {
        List<UserDTO> users = new ArrayList<>();

        try (InputStream is = filePart.getInputStream(); Workbook workbook = new XSSFWorkbook(is)) {
            Sheet sheet = workbook.getSheetAt(0);
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                // Bỏ qua dòng trống hoàn toàn
                boolean isEmptyRow = true;
                for (int c = 0; c < 8; c++) {
                    if (!getCellValue(row.getCell(c)).isEmpty()) {
                        isEmptyRow = false;
                        break;
                    }
                }
                if (isEmptyRow) continue;

                int rowNum = i + 1;
                UserDTO user = new UserDTO();
                user.setEmail(getCellValue(row.getCell(0)));
                user.setFullName(getCellValue(row.getCell(1)));
                user.setPhoneNumber(getCellValue(row.getCell(2)));
                user.setGender(getCellValue(row.getCell(3)));

                // Parse Ngày sinh — báo lỗi tường minh thay vì nuốt lỗi
                String dobStr = getCellValue(row.getCell(4));
                if (dobStr != null && !dobStr.isEmpty()) {
                    try {
                        user.setDateOfBirth(java.sql.Date.valueOf(dobStr));
                    } catch (IllegalArgumentException e) {
                        throw new Exception("Dòng " + rowNum + ": Ngày sinh '" + dobStr
                                + "' sai định dạng. Yêu cầu định dạng yyyy-MM-dd (ví dụ: 2005-10-15).");
                    }
                }

                user.setCode(getCellValue(row.getCell(5)));

                String extra1 = getCellValue(row.getCell(6));
                String extra2 = getCellValue(row.getCell(7));

                if ("STUDENT".equalsIgnoreCase(role)) {
                    user.setMajor(extra1);
                    if (extra2 != null && !extra2.isEmpty()) {
                        // Xử lý giá trị số từ Excel có thể kèm ".0"
                        if (extra2.endsWith(".0")) {
                            extra2 = extra2.substring(0, extra2.length() - 2);
                        }
                        try {
                            user.setEnrollmentYear(Integer.parseInt(extra2));
                        } catch (NumberFormatException e) {
                            throw new Exception("Dòng " + rowNum + ": Năm nhập học '" + extra2
                                    + "' không phải là số nguyên hợp lệ (ví dụ: 2023).");
                        }
                    }
                } else if ("LECTURER".equalsIgnoreCase(role)) {
                    user.setDepartment(extra1);
                }

                user.setRole(role);
                user.setStatus("active");

                users.add(user);
            }
        }

        return users;
    }

    /**
     * Đọc giá trị ô Excel thành String, hỗ trợ các kiểu dữ liệu String/Numeric/Boolean.
     */
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
