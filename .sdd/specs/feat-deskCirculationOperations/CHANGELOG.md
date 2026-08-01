# CHANGELOG.md — Quản lý Luân chuyển tại quầy

## [1.5.0] - 2026-08-01
### Added
- **FR-138 (Gửi email thu hồi sách - RECALL_NOTICE):** Thêm phương thức `EmailService.sendRecallNoticeEmail(borrowRecord, librarianId, recallReason)`. Khi Thủ thư click "Gửi email thu hồi" trên màn hình `/librarian/borrowings`, hệ thống enqueue EmailJob với template `RECALL_NOTICE` (placeholders: `{{userName}}`, `{{bookTitle}}`, `{{recallReason}}`, `{{dueDate}}`) và ghi AuditLog(RECALL_NOTICE, librarianId).
- **Template RECALL_NOTICE:** Bổ sung vào `EmailService.java` fallback template và `04_email_templates.sql` seed data.
- **Template RESERVATION_CANCELLED:** Bổ sung vào `EmailService.java` fallback và `04_email_templates.sql` (được trigger khi Thủ thư hủy lượt đặt trước kèm lý do).
- **Template RESERVATION_EXPIRED:** Bổ sung vào `EmailService.java` fallback (được trigger bởi FR-68 khi đơn hết hạn).

### Changed
- **FR-71 (Dashboard Thủ thư):** Danh sách sách quá hạn trong panel "Danh sách Đơn Phạt" chỉ hiển thị các bản ghi có khoản phạt CHƯA thanh toán (`Fine.status != 'paid'` hoặc chưa có Fine), loại bỏ các khoản đã xử lý xong.
- **Dashboard Layout:** Panel "Sẵn sàng nhận sách" (readypickup + Countdown Timer) được đặt TRÊN panel "Danh sách Đơn Phạt" (thu tiền); cả hai ngang nhau (col-6). Tên view đổi thành "Danh sách Đơn Phạt" (thay cho "Danh sách vi phạm"). Bổ sung chức năng search và filter theo tên, mã sinh viên, khoảng ngày.
- **UC-57 & UC-58** chính thức đưa vào phạm vi F6 (Desk Circulation Operations).
- Cập nhật SPEC.md: Bổ sung FR-138, làm rõ UC-57, UC-58 và layout dashboard.

## [1.4.0] - 2026-08-01
### Added
- Bổ sung hàm `BorrowRecordDAO.findAllRecentLoans` hỗ trợ hiển thị danh sách mượn trả mới nhất toàn hệ thống cho Librarian Dashboard.
- Mở rộng bộ lọc sắp xếp đa tiêu chí linh hoạt (sortBy, sortOrder) trong `BorrowRecordDAO.searchBorrowingsPaginated` và `DeskBorrowingManagerServlet`.
- Đồng bộ chuẩn thiết kế giao diện theo `DESIGN.md` và `ui_rule.md` cho các view luân chuyển tại quầy.

## [1.3.0] - 2026-07-27
### Changed
- **Chuẩn hóa luồng Check-out yêu cầu BẮT BUỘC Reservation trước (BR-23 / FR-35):** Cập nhật toàn bộ spec khớp 100% với mã nguồn `DeskCirculationService.java` hiện tại. Loại bỏ hoàn toàn logic tự động tạo Reservation ảo ngầm trong Check-out. Nếu độc giả chưa có đơn đặt trước, hệ thống chặn giao dịch và báo lỗi yêu cầu Thủ thư dùng chức năng Đặt trước sách tại quầy (`DeskReservationServlet` / UC-51) trước khi tiến hành giao sách.
- **Cập nhật SPEC.md:** Điều chỉnh BR-23, FR-34, FR-35, FR-36, Error Handling và Acceptance Criteria.
- **Cập nhật CONTEXT.md:** Điều chỉnh phần Domain Knowledge về kịch bản Giao sách (Check-out).
- **Cập nhật PLAN.md:** Bổ sung `DeskReservationServlet.java` vào bảng Components và cập nhật Data Flow Check-out.
- **Cập nhật TASK.md:** Điều chỉnh Task T-F6-02 và bổ sung Task T-F6-08 cho UC-51.

## [1.2.0] - 2026-07-22
### Added
- **Tự động tạo BookCopyIncident đã kết luận khi check-in hỏng/mất (FR-37 bước 6):** Khi Thủ thư trả sách với condition='damaged' hoặc 'lost', hệ thống tự động INSERT bản ghi `BookCopyIncident` (incidentType=condition, status='resolved', reportedBy/resolvedBy=librarianId, description chứa mã mượn, resolution ghi rõ kết luận tại quầy) trong cùng DB Transaction. Bản ghi sẽ xuất hiện ngay trên trang "Hỏng và mất" để tra cứu và khôi phục hoặc loại khỏi kho nếu là `damaged`.
- Thêm task T-F6-07 vào TASK.md mô tả chi tiết các bước triển khai đồng bộ F6/F13.
- Bổ sung schema bảng `BookCopyIncident` vào SPEC.md §6 (Data Models).
- Thêm `BookCopyIncidentDAO` vào bảng Components trong PLAN.md.

### Changed
- Cập nhật BR-24 nhấn mạnh INSERT `BookCopyIncident(status='resolved')` là bước bắt buộc trong transaction.
- Cập nhật FR-37 chi tiết từng bước tuần tự cho luồng check-in hỏng/mất đã kết luận tại quầy.
- Cập nhật Acceptance Criteria bổ sung 2 tiêu chí nghiệm thu mới cho incident tự động.
- Cập nhật CONTEXT.md domain knowledge và PLAN.md data flow.

## [1.1.0] - 2026-07-21
### Changed
- Đồng bộ luồng check-in hỏng/mất với F13 `feat-bookMaintenance`: F6 ngừng lưu thông và tạo incident `resolved` vì Thủ thư đã kết luận tình trạng khi nhận trả; F13 tra cứu và chỉ khôi phục sau sửa hoặc loại khỏi kho nếu là `damaged`.
- Loại bỏ mô tả incident status cũ `open` và tránh mâu thuẫn với schema PostgreSQL hiện hành.
- Làm rõ bản sao hỏng/mất không luân chuyển hàng chờ và không cộng lại `availableQuantity`.

## [1.0.0] - 2026-06-06
### Added
- Khởi tạo bộ hồ sơ SDD (CONTEXT, SPEC, PLAN, TASKS) cho Feature F6 (Desk Circulation Operations).
- Đặc tả luồng xử lý khóa/mở khóa tài khoản an toàn tuyệt đối dựa trên bảng `UserLockReason` (BR-25 / BR-30). Đếm COUNT lý do trước khi gỡ khóa.
- Bổ sung cơ chế Mượn trực tiếp (Direct Borrow) tự động sinh `Reservation` vị trí 0 (BR-23) để chuẩn hóa nguồn dữ liệu giao dịch.
- Thiết lập quy tắc kế toán kho đối với sách hư hỏng/mất (Damaged/Lost): không cộng lại `availableQuantity`; `lost` trừ `totalQuantity` và set `removedFromInventory`, còn `damaged` giữ `totalQuantity` để có thể sửa, khôi phục hoặc loại khỏi kho (BR-24).

### Security & Integrity
- Tách biệt kiểm tra nợ phạt khỏi bảng `Fine`, truy vấn trực tiếp thông qua cờ khóa tài khoản ở `UserLockReason`.
- Đảm bảo mọi giao dịch thay đổi trạng thái tồn kho và hàng đợi đều được gói gọn trong Database Transaction.
