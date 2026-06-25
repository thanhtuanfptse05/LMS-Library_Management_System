package controllers;

import dao.AuditLogDAO;
import dto.AuditLogDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

/**
 * Controller cho tính năng Nhật ký Kiểm toán (F12).
 * Chỉ hỗ trợ đọc dữ liệu (SELECT only) — không ghi, không sửa, không xóa.
 * Route: /admin/audit-log (được bảo vệ bởi AuthFilter cho role ADMIN).
 */
@WebServlet(name = "AuditLogServlet", urlPatterns = {"/admin/audit-log"})
public class AuditLogServlet extends HttpServlet {

    private static final int PAGE_SIZE = 20;
    private static final int EXPORT_MAX_ROWS = 10000;

    private final AuditLogDAO auditLogDAO = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("export".equals(action)) {
            handleExportCSV(request, response);
        } else {
            handleListView(request, response);
        }
    }

    /**
     * Nhánh mặc định: hiển thị danh sách audit log với bộ lọc và phân trang.
     */
    private void handleListView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String actionType = request.getParameter("actionType");
            String entityName = request.getParameter("entityName");
            String email = request.getParameter("email");
            String fromDateStr = request.getParameter("fromDate");
            String toDateStr = request.getParameter("toDate");
            String keyword = request.getParameter("keyword");
            String pageStr = request.getParameter("page");

            int page = 1;
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr.trim());
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException ignored) {
                    page = 1;
                }
            }

            Timestamp fromDate = parseTimestamp(fromDateStr, true);
            Timestamp toDate = parseTimestamp(toDateStr, false);

            int totalRecords = auditLogDAO.countWithFilters(actionType, entityName, email, fromDate, toDate, keyword);
            int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
            if (totalPages < 1) {
                totalPages = 1;
            }
            if (page > totalPages) {
                page = totalPages;
            }

            List<AuditLogDTO> auditLogs = auditLogDAO.findWithFilters(
                    actionType, entityName, email, fromDate, toDate, keyword, page, PAGE_SIZE);

            List<String> actionTypes = auditLogDAO.getDistinctActionTypes();
            List<String> entityNames = auditLogDAO.getDistinctEntityNames();

            request.setAttribute("auditLogs", auditLogs);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("actionTypes", actionTypes);
            request.setAttribute("entityNames", entityNames);

            request.setAttribute("filterActionType", actionType);
            request.setAttribute("filterEntityName", entityName);
            request.setAttribute("filterEmail", email);
            request.setAttribute("filterFromDate", fromDateStr);
            request.setAttribute("filterToDate", toDateStr);
            request.setAttribute("filterKeyword", keyword);

            request.getRequestDispatcher("/admin/audit-log-list.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Lỗi truy vấn nhật ký kiểm toán", e);
        }
    }

    /**
     * Nhánh export: xuất CSV UTF-8 BOM, giới hạn tối đa 10,000 bản ghi.
     */
    private void handleExportCSV(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String actionType = request.getParameter("actionType");
            String entityName = request.getParameter("entityName");
            String email = request.getParameter("email");
            String fromDateStr = request.getParameter("fromDate");
            String toDateStr = request.getParameter("toDate");
            String keyword = request.getParameter("keyword");

            Timestamp fromDate = parseTimestamp(fromDateStr, true);
            Timestamp toDate = parseTimestamp(toDateStr, false);

            List<AuditLogDTO> records = auditLogDAO.findWithFilters(
                    actionType, entityName, email, fromDate, toDate, keyword, 1, EXPORT_MAX_ROWS);

            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"nhat-ky-kiem-toan.csv\"");

            OutputStreamWriter osw = new OutputStreamWriter(response.getOutputStream(), StandardCharsets.UTF_8);
            osw.write('\uFEFF');

            PrintWriter writer = new PrintWriter(osw);

            writer.println("ID,Thời gian,Người thực hiện,Loại hành động,Đối tượng,ID Đối tượng,Giá trị cũ,Giá trị mới");

            for (AuditLogDTO log : records) {
                writer.print(log.getAuditLogId());
                writer.print(",");
                writer.print(csvEscape(log.getTimestamp() != null ? log.getTimestamp().toString() : ""));
                writer.print(",");
                writer.print(csvEscape(log.getUserEmail() != null ? log.getUserEmail() : "Hệ thống"));
                writer.print(",");
                writer.print(csvEscape(log.getActionType() != null ? log.getActionType() : ""));
                writer.print(",");
                writer.print(csvEscape(log.getEntityName() != null ? log.getEntityName() : ""));
                writer.print(",");
                writer.print(log.getEntityId() != null ? log.getEntityId() : "");
                writer.print(",");
                writer.print(csvEscape(formatAuditValues(log.getOldValues(), log.getActionType())));
                writer.print(",");
                writer.print(csvEscape(formatAuditValues(log.getNewValues(), log.getActionType())));
                writer.println();
            }

            writer.flush();
            osw.flush();

        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xuất CSV nhật ký kiểm toán");
        }
    }

    /**
     * Định dạng chuỗi JSON thô thành định dạng thuộc tính thân thiện với người đọc trong Excel.
     */
    private String formatAuditValues(String json, String actionType) {
        if (json == null || json.trim().isEmpty() || "{}".equals(json.trim())) {
            return "";
        }
        if ("CHANGE_PASSWORD".equalsIgnoreCase(actionType) || "RESET_PASSWORD".equalsIgnoreCase(actionType)) {
            return "Mật khẩu đã được thay đổi (Bảo mật)";
        }
        try {
            Gson gson = new Gson();
            JsonObject obj = gson.fromJson(json, JsonObject.class);
            if (obj == null || obj.entrySet().isEmpty()) {
                return json;
            }
            List<String> pairs = new ArrayList<>();
            for (Map.Entry<String, JsonElement> entry : obj.entrySet()) {
                String key = entry.getKey();
                JsonElement valElem = entry.getValue();
                String valueStr = "";
                if (valElem != null && !valElem.isJsonNull()) {
                    if (valElem.isJsonPrimitive()) {
                        valueStr = valElem.getAsString();
                    } else {
                        valueStr = valElem.toString();
                    }
                }
                
                if ("passwordHash".equalsIgnoreCase(key) || "password".equalsIgnoreCase(key)) {
                    valueStr = "[Đã mã hóa bảo mật]";
                } else {
                    valueStr = translateValue(key, valueStr);
                }
                
                String translatedKey = translateKey(key);
                pairs.add(translatedKey + ": " + valueStr);
            }
            return String.join("; ", pairs);
        } catch (Exception e) {
            return json;
        }
    }

    private String translateKey(String key) {
        if (key == null) return "";
        switch (key) {
            case "userId": return "ID người dùng";
            case "email": return "Email";
            case "passwordHash":
            case "password": return "Mật khẩu";
            case "status": return "Trạng thái";
            case "role": return "Vai trò";
            case "failedLoginAttempts": return "Số lần đăng nhập sai";
            case "lockedUntil": return "Khóa đến";
            case "fullName": return "Họ và tên";
            case "phoneNumber": return "Số điện thoại";
            case "gender": return "Giới tính";
            case "dateOfBirth": return "Ngày sinh";
            case "studentCode": return "Mã sinh viên";
            case "major": return "Chuyên ngành";
            case "enrollmentYear": return "Năm nhập học";
            case "lecturerCode": return "Mã giảng viên";
            case "department": return "Bộ môn";
            case "staffCode": return "Mã nhân viên";
            case "name": return "Tên";
            case "description": return "Mô tả";
            case "isbn": return "ISBN";
            case "title": return "Tên sách";
            case "author": return "Tác giả";
            case "publisher": return "Nhà xuất bản";
            case "publicationYear": return "Năm xuất bản";
            case "price": return "Giá tiền";
            case "location": return "Vị trí";
            case "condition": return "Tình trạng";
            case "barcode": return "Mã vạch";
            case "amount": return "Số tiền";
            case "reason": return "Lý do";
            case "paidAmount": return "Số tiền đã trả";
            case "paymentMethod": return "Phương thức thanh toán";
            case "transactionReference": return "Mã giao dịch";
            case "actionType": return "Loại hành động";
            case "entityName": return "Tên thực thể";
            case "entityId": return "ID thực thể";
            case "startDate": return "Ngày bắt đầu";
            case "endDate": return "Hạn trả";
            case "returnedAt": return "Ngày trả thực tế";
            case "extensionCount": return "Số lần gia hạn";
            case "configKey": return "Khóa cấu hình";
            case "configValue": return "Giá trị cấu hình";
            case "resolvedAt": return "Ngày giải quyết";
            case "resolution": return "Hướng giải quyết";
            default: return key;
        }
    }

    private String translateValue(String key, String value) {
        if (value == null || value.trim().isEmpty() || "—".equals(value)) {
            return value;
        }
        String valLower = value.toLowerCase().trim();
        if ("status".equalsIgnoreCase(key)) {
            switch (valLower) {
                case "active": return "Hoạt động";
                case "locked": return "Bị khóa";
                case "inactive": return "Không hoạt động";
                case "available": return "Sẵn có";
                case "unavailable": return "Không sẵn có";
                case "good": return "Tốt";
                case "damaged": return "Hỏng";
                case "lost": return "Mất";
                case "borrowed": return "Đang mượn";
                case "returned_good": return "Đã trả (Tốt)";
                case "returned_damaged": return "Đã trả (Hỏng)";
                case "overdue": return "Quá hạn";
                case "paid": return "Đã thanh toán";
                case "unpaid": return "Chưa thanh toán";
                case "pending": return "Chờ xử lý";
                case "approved": return "Đã duyệt";
                case "rejected": return "Đã từ chối";
            }
        } else if ("gender".equalsIgnoreCase(key)) {
            switch (valLower) {
                case "male": return "Nam";
                case "female": return "Nữ";
            }
        }
        return value;
    }

    /**
     * Parse chuỗi ngày thành Timestamp.
     * isStart=true → thêm 00:00:00, isStart=false → thêm 23:59:59.
     */
    private Timestamp parseTimestamp(String dateStr, boolean isStart) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }
        try {
            String timePart = isStart ? " 00:00:00" : " 23:59:59";
            return Timestamp.valueOf(dateStr.trim() + timePart);
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    /**
     * Escape giá trị CSV: bọc nháy kép nếu chứa dấu phẩy, xuống dòng hoặc nháy kép.
     */
    private String csvEscape(String value) {
        if (value == null) {
            return "";
        }
        if (value.contains(",") || value.contains("\"") || value.contains("\n") || value.contains("\r")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }
}
