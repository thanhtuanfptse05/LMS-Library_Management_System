# CHANGELOG.md — Quản lý Luân chuyển tại quầy

## [1.2.0] - 2026-07-22
### Added
- **Tự động tạo BookCopyIncident khi check-in hỏng/mất (FR-37 bước 6):** Khi Thủ thư trả sách với condition='damaged' hoặc 'lost', hệ thống tự động INSERT bản ghi `BookCopyIncident` (incidentType=condition, status='pending', reportedBy=librarianId, description chứa mã mượn) trong cùng DB Transaction. Bản ghi sẽ xuất hiện ngay trên trang "Hỏng và mất" để quản lý tự động.
- Thêm task T-F6-07 vào TASK.md mô tả chi tiết các bước triển khai GAP FIX.
- Bổ sung schema bảng `BookCopyIncident` vào SPEC.md §6 (Data Models).
- Thêm `BookCopyIncidentDAO` vào bảng Components trong PLAN.md.

### Changed
- Cập nhật BR-24 nhấn mạnh INSERT `BookCopyIncident` là bước bắt buộc trong transaction.
- Cập nhật FR-37 chi tiết từng bước tuần tự với chỉ rõ GAP hiện tại (code thiếu bước 6).
- Cập nhật Acceptance Criteria bổ sung 2 tiêu chí nghiệm thu mới cho incident tự động.
- Cập nhật CONTEXT.md domain knowledge và PLAN.md data flow.

## [1.1.0] - 2026-07-21
### Changed
- Đồng bộ luồng check-in hỏng/mất với F13 `feat-bookMaintenance`: F6 chỉ ngừng lưu thông và tạo incident `pending`; vòng đời resolve/reject/restore thuộc F13.
- Loại bỏ mô tả incident status cũ `open` và tránh mâu thuẫn với schema PostgreSQL hiện hành.
- Làm rõ bản sao hỏng/mất không luân chuyển hàng chờ và không cộng lại `availableQuantity`.

## [1.0.0] - 2026-06-06
### Added
- Khởi tạo bộ hồ sơ SDD (CONTEXT, SPEC, PLAN, TASKS) cho Feature F6 (Desk Circulation Operations).
- Đặc tả luồng xử lý khóa/mở khóa tài khoản an toàn tuyệt đối dựa trên bảng `UserLockReason` (BR-25 / BR-30). Đếm COUNT lý do trước khi gỡ khóa.
- Bổ sung cơ chế Mượn trực tiếp (Direct Borrow) tự động sinh `Reservation` vị trí 0 (BR-23) để chuẩn hóa nguồn dữ liệu giao dịch.
- Thiết lập quy tắc kế toán kho đối với sách hư hỏng/mất (Damaged/Lost): Trừ vào `totalQuantity` thay vì `availableQuantity` để đảm bảo không âm kho (BR-24).

### Security & Integrity
- Tách biệt kiểm tra nợ phạt khỏi bảng `Fine`, truy vấn trực tiếp thông qua cờ khóa tài khoản ở `UserLockReason`.
- Đảm bảo mọi giao dịch thay đổi trạng thái tồn kho và hàng đợi đều được gói gọn trong Database Transaction.
