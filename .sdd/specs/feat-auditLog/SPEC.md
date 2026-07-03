# Feature Specification: Nhật ký hoạt động và Dashboard Admin (Audit Log)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Ghi nhận và hiển thị tất cả các hành động thay đổi dữ liệu cốt lõi (Thêm, Sửa, Xóa, Import, Giao dịch) của mọi tài khoản trong hệ thống dưới dạng nhật ký kiểm toán so sánh giá trị cũ và mới chi tiết.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản trị viên (Admin):** Xem danh sách audit log, xem chi tiết so sánh 1-1, xuất nhật ký ra Excel.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-32 (Audit Log Read-Only):** Tính năng Nhật ký Kiểm toán KHÔNG ĐƯỢC PHÉP Insert, Update hoặc Delete dữ liệu trong bất kỳ bảng nào. Chỉ được thực hiện SELECT.\n* **BR-33 (Audit Log JSON Format):** Tất cả oldValues và newValues trong bảng AuditLogs BẮT BUỘC được ghi ở dạng JSON hợp lệ để đảm bảo hiển thị nhất quán.\n* **BR-34 (Audit Log Pagination):** Danh sách Nhật ký Kiểm toán BẮT BUỘC phải phân trang (20 bản ghi/trang) để bảo vệ hiệu năng hệ thống.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-73 (Hiển thị Dashboard Admin):** WHEN Admin truy cập dashboard, THE system SHALL hiển thị tổng quan hệ thống (tổng tài khoản, tổng sách, tiền phạt chưa thu) và 5 log mới nhất.\n* **FR-55 (Truy vấn Danh sách Audit Log phân trang):** WHEN Admin truy cập trang nhật ký, THE system SHALL tải danh sách phân trang 20 bản ghi/trang, sắp xếp giảm dần theo thời gian.\n* **FR-56 (Lọc Nhật ký Kiểm toán với 7 filter params):** WHEN Admin thực hiện lọc, THE system SHALL xây dựng câu lệnh truy vấn động theo actionType, entityName, email người thực hiện, thời gian và từ khóa JSON.\n* **FR-57 (Chi tiết Nhật ký dạng Card so sánh 1-1):** WHEN Admin click xem chi tiết log, THE system SHALL hiển thị modal so sánh 2 cột Cũ và Mới tương ứng với từng key thuộc JSON.\n* **FR-58 (Hiển thị đặc biệt theo actionType):** THE system SHALL hiển thị hợp lý: action CREATE thì cột Cũ để trống, action DELETE thì cột Mới để trống, đổi mật khẩu ẩn giá trị thô.\n* **FR-59 (Xuất Excel Nhật ký Kiểm toán):** WHEN Admin yêu cầu xuất log, THE system SHALL xuất tối đa 10,000 dòng ra file Excel và ghi Audit Log.\n* **FR-60 (Badge màu hành động theo nhóm):** SYSTEM SHALL hiển thị màu sắc tương ứng cho từng nhóm hành động (CREATE-xanh lá, UPDATE-vàng, DELETE-đỏ, SECURITY-tím...).

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Bảo mật: Nhật ký kiểm toán là read-only đối với người dùng (kể cả Admin qua giao diện không thể xóa log).\n* Ràng buộc: Giá trị thay đổi bắt buộc lưu định dạng JSON.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng AuditLogs\n* `auditLogId` (INT, PK, Identity)\n* `userId` (INT, FK REFERENCES "User")\n* `actionType` (VARCHAR(100))\n* `entityName` (VARCHAR(255))\n* `entityId` (INT)\n* `oldValues` (TEXT - JSON format)\n* `newValues` (TEXT - JSON format)\n* `timestamp` (TIMESTAMP)\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE dữ liệu JSON trong log bị lỗi cú pháp, THE system SHALL hiển thị thẻ đơn kèm viền đỏ cảnh báo thay vì làm crash giao diện.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Ghi nhận log: Tạo sách mới -> Hệ thống tự động insert 1 log hành động 'CREATE_BOOK' chứa JSON thông tin sách mới.\n- [ ] Xem chi tiết log: Nhấn xem chi tiết cập nhật -> Modal mở ra hiển thị rõ cột trái giá trị cũ, cột phải giá trị mới song song.

## 9. Out of Scope (Phạm vi không thực hiện)
* Xóa hoặc sửa đổi bất kỳ dòng nhật ký nào trong bảng AuditLogs thông qua ứng dụng web.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
