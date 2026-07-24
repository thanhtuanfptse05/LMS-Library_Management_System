# Feature Specification: Nhật ký hệ thống (Audit Log & Tracking)
# Version: 1.2 | Chủ sở hữu: @quyet | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp cơ chế tự động ghi nhật ký bất biến (`AuditLogs`) cho mọi thao tác Tạo mới, Cập nhật, Xóa (C/U/D) trên các thực thể dữ liệu quan trọng của hệ thống LMS, phục vụ công tác giám sát an ninh, truy vết sự cố và kiểm toán quản trị.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản trị viên (SysAdmin):** Tra cứu, tìm kiếm, lọc danh sách Nhật ký hệ thống.
* **Hệ thống (System Engine):** Tự động ghi nhận log khi xảy ra thao tác C/U/D.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-34 (View Audit Logs):** Actor: Admin | Xem danh sách nhật ký thao tác, lọc theo người thực hiện, loại hành động và khoảng thời gian.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-37 (Audit Immutability):** Các bản ghi trong bảng `AuditLogs` BẮT BUỘC là bất biến (Read-only). CẤM tuyệt đối mọi thao tác `UPDATE` hoặc `DELETE` bản ghi Audit Log (kể cả bởi Admin).
* **BR-38 (Mandatory CUD Auditing):** Tất cả các DAO/Service thực hiện thao tác Create, Update, Soft-delete dữ liệu cốt lõi (User, Book, BorrowRecord, Fine, Payment, Config) BẮT BUỘC phải gọi `AuditLogDAO.logAction()`.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-42 (Ghi vết nhật ký tự động):** WHEN bất kỳ tác vụ C/U/D dữ liệu quan trọng được thực hiện thành công, THE system SHALL gọi `AuditLogDAO.logAction(userId, actionType, entityName, entityId, oldValues, newValues)` để lưu lại vết thao tác.
  * *Mapping:* BR-38
* **FR-43 (Tra cứu & Lọc Audit Log):** WHEN Admin truy cập trang Audit Log, THE system SHALL hiển thị danh sách nhật ký có phân trang, hỗ trợ tìm kiếm theo `userId`, lọc theo `actionType` (CREATE/UPDATE/DELETE), `entityName` và khoảng thời gian `timestamp`.
  * *Mapping:* UC-34 / BR-37

## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Chỉ role ADMIN mới có quyền truy cập xem trang Audit Logs.
* **Hiệu năng:** Ghi nhật ký chạy tối ưu không làm ảnh hưởng đến thời gian phản hồi của request gốc.
* **Giao diện:** 100% Tiếng Việt, hiển thị rõ ràng dữ liệu cũ (`oldValues`) và dữ liệu mới (`newValues`) dưới dạng JSON/Text dễ đọc.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `AuditLogs`
* `auditLogId` (INT, PK, SERIAL), `userId` (FK REFERENCES `"User"`), `actionType` (VARCHAR(50)), `entityName` (VARCHAR(100)), `entityId` (VARCHAR(50)), `oldValues` (TEXT), `newValues` (TEXT), `timestamp` (TIMESTAMP, DEFAULT NOW())

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** ghi audit log thất bại do ngắt kết nối DB, **THE system SHALL** ghi log lỗi ra server console và rollback transaction chính để bảo toàn tính nhất quán.

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-AUDIT-01] Mọi thao tác thêm/sửa/khóa tài khoản hoặc mượn/trả sách đều tự động chèn bản ghi vào AuditLogs.
- [ ] [TC-AUDIT-02] Admin xem được danh sách Audit Logs và lọc chính xác theo từ khóa/hành động.
- [ ] [TC-AUDIT-03] Không có bất kỳ API hoặc Servlet nào cho phép sửa hoặc xóa bản ghi Audit Logs.

## 8. Out of Scope (Phạm vi không thực hiện)
* Lưu trữ log ra hệ thống SIEM bên ngoài (Splunk/Elasticsearch).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện toàn bộ AuditLogDAO tích hợp vào tất cả các module.