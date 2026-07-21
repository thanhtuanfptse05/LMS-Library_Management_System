# TASK.md — Danh sách Task Thực thi: feat-auditLog
# Version: 1.1 | Trạng thái: COMPLETED (Except Tests) | Ngày cập nhật: 2026-07-21

## Ghi chú thực thi
- Ký hiệu: `[ ]` chưa làm | `[/]` đang làm | `[x]` hoàn thành | `[!]` bị block

---

## PHASE 0 — Khởi động & Kiểm tra thiết lập
- [x] **TASK-AL-00:** Kiểm tra bảng CSDL `AuditLogs` và cơ chế ghi log thô đã được kích hoạt tại tầng Service/Servlet nghiệp vụ (F1-F14).
- [x] **TASK-AL-01:** Kiểm tra cấu hình bảo mật `AuthFilter.java` bảo vệ nghiêm ngặt các URL `/admin/*`.

---

## PHASE 1 — Xây dựng Lớp Dữ liệu (Data Layer)
- [x] **TASK-AL-10:** Tạo thực thể model `src/java/model/AuditLog.java` tương ứng bảng CSDL.
- [x] **TASK-AL-11:** Tạo DTO `src/java/dto/AuditLogDTO.java` gộp thông tin email người thực hiện.
- [x] **TASK-AL-12:** Mở rộng `src/java/dao/AuditLogDAO.java` triển khai các phương thức đọc:
  * `findWithFilters(filters, page, pageSize)`
  * `countWithFilters(filters)`
  * `getDistinctActionTypes()`
  * `getDistinctEntityNames()`

---

## PHASE 2 — Phát triển Lớp Điều khiển (Controller Layer)
- [x] **TASK-AL-20:** Tạo Servlet `src/java/controllers/AuditLogServlet.java` (@WebServlet("/admin/audit-log")) xử lý:
  * Nhận các param lọc động và phân trang.
  * Phân nhánh `action=export` để xuất Excel (.xlsx) thông qua Apache POI (FR-59).
  * Phân nhánh mặc định truy vấn danh sách, forward sang `audit-log-list.jsp`.
- [x] **TASK-AL-21:** Phát triển Servlet `src/java/controllers/AdminDashboardServlet.java` (@WebServlet("/admin/dashboard")) phục vụ tổng hợp chỉ số KPI toàn hệ thống (UC-46).

---

## PHASE 3 — Thiết kế Giao diện (View Layer - JSP)
- [x] **TASK-AL-30:** Xây dựng trang `web/admin/audit-log-list.jsp` chứa:
  * Form lọc nâng cao 7 tiêu chí.
  * Bảng hiển thị kết quả phân trang, badge màu sắc theo nhóm hành động.
  * Script JavaScript client-side: parse JSON từ data-attribute, render so sánh 1-1 dạng cột màu hồng/xanh trong Modal.
- [x] **TASK-AL-31:** Xây dựng trang `web/admin/dashboard.jsp` hiển thị panel KPI tổng hợp, panel cấu hình quan trọng và bảng hiển thị 5 log hoạt động gần nhất.
- [x] **TASK-AL-32:** Cập nhật liên kết menu thanh Sidebar `web/admin/fragments/_sidebar.jsp` trỏ đến đúng trang Audit Log.

---

## PHASE 4 — Kiểm thử (Testing)
- [ ] **TASK-AL-40:** Viết Unit Test (JUnit 5) kiểm tra các câu lệnh truy vấn lọc động và đếm số lượng của `AuditLogDAO` (Đang chờ thực hiện).
- [x] **TASK-AL-41:** Thực hiện kiểm thử chấp nhận thủ công (Manual Acceptance Test) xác nhận parse JSON modal, xuất file Excel và phân trang hoạt động hoàn hảo.
