# PLAN.md — Kế hoạch Thực thi Nhật ký Kiểm toán
# Trạng thái: APPROVED

## 1. ARCHITECTURAL APPROACH
Áp dụng mô hình Servlet MVC + DAO Pattern. F12 là tính năng **chỉ đọc** (read-only) — toàn bộ logic nằm trong 1 Servlet duy nhất gọi trực tiếp DAO, không cần tầng Service riêng vì không có logic nghiệp vụ phức tạp (không có transaction ghi).

Modal chi tiết sử dụng JavaScript client-side để parse JSON từ data attributes và render cards so sánh, không gọi thêm AJAX request.

## 2. COMPONENTS
| Component | Trách nhiệm | Interface/Class |
| --- | --- | --- |
| AuditLogModel | Entity thuần map 1:1 bảng AuditLogs (7 trường) | `AuditLog.java` |
| AuditLogDTO | Mở rộng AuditLog thêm userEmail từ JOIN | `AuditLogDTO.java` |
| AuditLogDAO | Truy vấn: list + filter + count + detail + distinct values | `AuditLogDAO.java` (bổ sung methods) |
| AuditLogController | Router GET: nhánh list/filter hoặc nhánh export CSV | `AuditLogServlet.java` |
| AuditLogView | Trang danh sách + filter + phân trang + modal + JS | `audit-log-list.jsp` |

## 3. DATA FLOW
- **Luồng Xem danh sách:** SysAdmin → `GET /admin/audit-log` → `AuthFilter` (check ADMIN) → `AuditLogServlet.doGet()` → parse filter params → `AuditLogDAO.countWithFilters()` + `AuditLogDAO.findWithFilters()` → set attributes → forward `audit-log-list.jsp`.
- **Luồng Xem chi tiết:** Click [🔍] trên `<tr>` → JavaScript đọc `data-old`, `data-new` → `JSON.parse()` → render cards trong modal (client-side, không gọi server).
- **Luồng Xuất CSV:** SysAdmin → `GET /admin/audit-log?action=export&...filters` → `AuditLogServlet.doGet()` → `AuditLogDAO.findWithFilters(max=10000)` → set response headers CSV → ghi BOM + header + data rows → flush.

## 4. DATABASE IMPACT
- Bảng `AuditLogs`: SELECT only (list, count, detail, distinct).
- Bảng `"User"`: SELECT only (LEFT JOIN lấy email).
- KHÔNG thay đổi schema (không thêm cột, bảng, index).
- KHÔNG Insert/Update/Delete bất kỳ bảng nào.

## 5. ACCESS CONTROL
- `ADMIN`: được truy cập route `/admin/audit-log` để xem, lọc, xuất CSV.
- Các vai trò khác: bị từ chối bởi `AuthFilter` (đã bảo vệ `/admin/*` sẵn).

## 6. CHUẨN HÓA JSON (Tác động lên các tính năng khác)
Để modal card-based hiển thị nhất quán, cần chuẩn hóa 2 file ngoài F12:
- `DeskCirculationService.java` (F6): 6 chỗ ghi audit log (CHECK_OUT, CHECK_IN_*, CASH_PAYMENT) từ plain text → JSON.
- `ForgotPasswordServlet.java` (F1): CHANGE_PASSWORD từ `old=null, new="text"` → `old="{}", new="{}"`.

## 7. RISKS & MITIGATIONS
- **Risk:** Bảng AuditLogs quá lớn (>100K rows) gây chậm truy vấn.
  **Mitigation:** Phân trang bắt buộc (20/trang), giới hạn export 10,000. Cân nhắc index trên timestamp nếu cần.
- **Risk:** oldValues/newValues cũ vẫn còn plain text (trước khi chuẩn hóa).
  **Mitigation:** Modal JS có fallback hiển thị raw text trong card đơn khi parse JSON thất bại.
- **Risk:** CSV export file quá lớn.
  **Mitigation:** Giới hạn cứng 10,000 bản ghi, stream trực tiếp vào OutputStream.

## 8. QUESTIONS FOR HUMAN
- N/A (Đã giải quyết toàn bộ)
