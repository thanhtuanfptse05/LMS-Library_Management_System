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
        if (key == null || key.isEmpty()) return "";
        switch (key) {
            case "userId": return "ID người dùng (userId)";
            case "email": return "Email (email)";
            case "passwordHash":
            case "password": return "Mật khẩu (password)";
            case "status": return "Trạng thái (status)";
            case "role": return "Vai trò (role)";
            case "failedLoginAttempts": return "Số lần đăng nhập sai (failedLoginAttempts)";
            case "lockedUntil": return "Khóa đến (lockedUntil)";
            case "fullName": return "Họ và tên (fullName)";
            case "phoneNumber": return "Số điện thoại (phoneNumber)";
            case "gender": return "Giới tính (gender)";
            case "dateOfBirth": return "Ngày sinh (dateOfBirth)";
            case "studentCode": return "Mã sinh viên (studentCode)";
            case "major": return "Chuyên ngành (major)";
            case "enrollmentYear": return "Năm nhập học (enrollmentYear)";
            case "lecturerCode": return "Mã giảng viên (lecturerCode)";
            case "department": return "Bộ môn (department)";
            case "staffCode": return "Mã nhân viên (staffCode)";
            case "name": return "Tên (name)";
            case "description": return "Mô tả (description)";
            case "isbn": return "Mã ISBN (isbn)";
            case "title": return "Tên sách (title)";
            case "author": return "Tác giả (author)";
            case "publisher": return "Nhà xuất bản (publisher)";
            case "publicationYear": return "Năm xuất bản (publicationYear)";
            case "price": return "Giá tiền (price)";
            case "location": return "Vị trí (location)";
            case "condition": return "Tình trạng (condition)";
            case "barcode": return "Mã vạch (barcode)";
            case "amount": return "Số tiền (amount)";
            case "reason": return "Lý do (reason)";
            case "paidAmount": return "Số tiền đã trả (paidAmount)";
            case "paymentMethod": return "Phương thức thanh toán (paymentMethod)";
            case "transactionReference": return "Mã giao dịch (transactionReference)";
            case "actionType": return "Loại hành động (actionType)";
            case "entityName": return "Tên thực thể (entityName)";
            case "entityId": return "ID thực thể (entityId)";
            case "startDate": return "Ngày bắt đầu (startDate)";
            case "endDate": return "Hạn trả (endDate)";
            case "returnedAt": return "Ngày trả thực tế (returnedAt)";
            case "extensionCount": return "Số lần gia hạn (extensionCount)";
            case "configKey": return "Khóa cấu hình (configKey)";
            case "configValue": return "Giá trị cấu hình (configValue)";
            case "resolvedAt": return "Ngày giải quyết (resolvedAt)";
            case "resolution": return "Hướng giải quyết (resolution)";
            case "incidentType": return "Loại sự cố (incidentType)";
            case "reportedBy": return "Người báo cáo (reportedBy)";
            case "reportedAt": return "Thời gian báo cáo (reportedAt)";
            case "resolvedBy": return "Người giải quyết (resolvedBy)";
            case "activeCount": return "Số lượt hoạt động (activeCount)";
            case "cancelledCount": return "Số lượt đã hủy (cancelledCount)";
            case "subject": return "Tiêu đề (subject)";
            case "bodyContent": return "Nội dung mẫu (bodyContent)";
            case "missingCount": return "Số lượng thiếu (missingCount)";
            case "excludedCount": return "Số lượng loại trừ (excludedCount)";
            case "scannedCount": return "Số lượng đã quét (scannedCount)";
            case "expectedCount": return "Số lượng dự kiến (expectedCount)";
            case "reconciledCount": return "Số lượng đối soát (reconciledCount)";
            case "inventorySessionId": return "ID phiên kiểm kê (inventorySessionId)";
            case "scannedLocation": return "Vị trí đã quét (scannedLocation)";
            case "expectedLocation": return "Vị trí dự kiến (expectedLocation)";
            case "scannedBy": return "Người quét (scannedBy)";
            case "completedBy": return "Người hoàn thành (completedBy)";
            case "startedBy": return "Người khởi tạo (startedBy)";
            case "note": return "Ghi chú (note)";
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
                case "active": return "Hoạt động (active)";
                case "locked": return "Bị khóa (locked)";
                case "inactive": return "Không hoạt động (inactive)";
                case "available": return "Sẵn có (available)";
                case "unavailable": return "Không sẵn có (unavailable)";
                case "good": return "Tốt (good)";
                case "damaged": return "Hỏng (damaged)";
                case "lost": return "Mất (lost)";
                case "borrowed": return "Đang mượn (borrowed)";
                case "returned_good": return "Đã trả tốt (returned_good)";
                case "returned_damaged": return "Đã trả hỏng (returned_damaged)";
                case "overdue": return "Quá hạn (overdue)";
                case "paid": return "Đã thanh toán (paid)";
                case "unpaid": return "Chưa thanh toán (unpaid)";
                case "pending": return "Chờ xử lý (pending)";
                case "approved": return "Đã duyệt (approved)";
                case "rejected": return "Đã từ chối (rejected)";
                case "counting": return "Đang kiểm đếm (counting)";
                case "reviewing": return "Đang đối soát (reviewing)";
                case "reconciled": return "Đã đối soát (reconciled)";
                case "draft": return "Bản nháp (draft)";
                case "scanned": return "Đã quét (scanned)";
            }
        } else if ("gender".equalsIgnoreCase(key)) {
            switch (valLower) {
                case "male": return "Nam (male)";
                case "female": return "Nữ (female)";
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
            String timePart = isStart ? " 00:00:00" : " 23:59:59.999";
            return Timestamp.valueOf(dateStr.trim() + timePart);
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    /**
     * Escape giá trị CSV: chống CSV Injection (nếu bắt đầu bằng =, +, -, @) và bọc nháy kép nếu chứa dấu phẩy, xuống dòng.
     */
    private String csvEscape(String value) {
        if (value == null) {
            return "";
        }
        if (value.startsWith("=") || value.startsWith("+") || value.startsWith("-") || value.startsWith("@")) {
            value = "'" + value;
        }
        if (value.contains(",") || value.contains("\"") || value.contains("\n") || value.contains("\r")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }
}
