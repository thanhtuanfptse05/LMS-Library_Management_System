# CHANGELOG.md — Fine & Payment Management (Quản lý Phạt & Thanh toán)

## [1.0.0] - 2026-06-24
### Added
- Khởi tạo bộ hồ sơ SDD (CONTEXT, SPEC, PLAN, TASK) cho Feature F9.
- Định nghĩa UC-31 (Xem Hàng mượn & chờ sách), UC-38 (Xem lịch sử phạt), UC-39 (Thanh toán phạt trực tuyến), UC-42 (Quét quá hạn tự động).
- Định nghĩa BR-22 (Chặn giao dịch khi nợ phạt), BR-24 (Nhận sách Hỏng/Mất), BR-25 (Mở khóa có điều kiện), BR-35 (Quy tắc quét quá hạn).
- Thiết lập Functional Requirements FR-53, FR-54 (Dashboard), FR-40, FR-41 (Tiền mặt tại quầy), FR-61, FR-62, FR-63 (Quét quá hạn ngầm), FR-64, FR-65, FR-66 (Thanh toán online SePay).

## [1.1.0] - 2026-06-26
### Added
- **Tính năng: Tiến trình ngầm Quét quá hạn tự động (Overdue Processor - F9)**
- **Ngày yêu cầu & Thực hiện:** 2026-06-25 & 2026-06-26.
- **Nội dung thay đổi:**
  - **Logic chạy ngầm chính (`OverdueProcessor.java`):** Quét các lượt mượn quá hạn (`endDate < NOW()`), tự động chuyển status sang `overdue`, tính tiền phạt (`5,000 VND / ngày`), tạo bản ghi Fine trễ hạn, khóa tài khoản người dùng (`status = 'locked'`), chèn cờ lock reason `'unpaid'`, ghi Audit Log và gửi email thông báo bất đồng bộ qua template `OVERDUE_NOTICE`.
  - **Lập lịch tự động (`AppContextListener.java`):** Đăng ký ScheduledExecutorService kích hoạt quét tự động vào đúng **00:00 AM hằng đêm** và tắt an toàn khi dừng ứng dụng.
  - **Mở khóa tự động theo BR-25:** Khôi phục logic gỡ cờ khóa `'unpaid'` và tự động kích hoạt lại tài khoản độc giả (`status = 'active'`) khi đóng phạt tiền mặt thành công (`DeskCirculationService.java`) hoặc đóng phạt online thành công qua webhook (`SePayWebhookServlet.java`).
  - **Kích hoạt thủ công (`TriggerOverdueServlet.java` & `dashboard.jsp`):** Tạo API `/admin/trigger-overdue` (chỉ cho phép ADMIN) và tích hợp nút bấm AJAX Fetch tiếng Việt trên Admin Dashboard để kích hoạt quét quá hạn thủ công tức thời.
  - **Kiểm thử tự động (`OverdueProcessorTest.java`):** Suite kiểm thử tích hợp JUnit 4 kiểm tra toàn bộ luồng xử lý không có quá hạn và có quá hạn (pass 100%).

