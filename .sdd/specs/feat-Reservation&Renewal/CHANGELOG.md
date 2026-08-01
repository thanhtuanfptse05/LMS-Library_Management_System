# CHANGELOG.md — Quản lý Đặt trước và Gia hạn trực tuyến

## [1.4.0] - 2026-08-01
### Added
- Bổ sung bộ lọc sắp xếp đa tiêu chí linh hoạt và chiều sắp xếp (ASC/DESC) cho danh sách sách đang mượn và đang đặt trước ở phía Độc giả và Thủ thư.
- Tích hợp bộ đếm ngược thời gian thực (Countdown Timer) cho suất đặt trước sẵn sàng nhận (`queuePosition == 0`), tự động reload trang sau 1.5s để kích hoạt Lazy Sweep khi hết hạn.
- Cập nhật quy trình Thủ thư hủy lượt đặt trước kèm lý do hủy (`reason`), tự động ghi `AuditLogs` và gửi email mẫu `RESERVATION_CANCELLED` tới độc giả.
- Đồng bộ chuẩn giao diện theo `DESIGN.md` và `ui_rule.md` (`raised-card`, `table-lms`, `badge-pill`, Terracotta Orange buttons, sidebar navigation titles).

## [1.1.0] - 2026-06-24
### Added
- Bổ sung đặc tả tiến trình ngầm **Reservation Expiration (Hủy hàng chờ)** chạy định kỳ mỗi 1 giờ để quét các đặt trước quá hạn nhận sách (`endDate < NOW` và trạng thái `'readypickup'`).
- Tích hợp luật nghiệp vụ **BR-36** về thời hạn nhận sách và giải phóng cờ đặt trước.
- Định nghĩa luồng dữ liệu tái phân bổ hàng chờ: Khi một đơn hàng chờ bị hủy, hệ thống tự động đôn người ở `queuePosition = 1` lên nhận sách, gán bản sao vật lý và cập nhật trạng thái bản sao thành `'reserved'`, dịch chuyển hàng đợi phía sau và gửi email thông báo. Nếu không có ai chờ, hoàn trả sách về kho vật lý (`status = 'available'`) và tăng `availableQuantity` của Book.
- Thêm các nhiệm vụ triển khai từ **T-F5-07** đến **T-F5-11** vào `TASK.md` để lập kế hoạch code.

### Changed
- Sửa đổi quy định thời gian giữ sách đặt trước chờ lấy (mặc định ban đầu là 3 ngày) thành lấy động từ bảng `SystemConfigurations` qua khóa `RESERVATION_HOLD_DAYS` (BR-36, FR-F5-03, FR-68, T-F5-07).

## [1.0.0] - 2026-06-06
### Added
- Khởi tạo bộ hồ sơ SDD (CONTEXT, SPEC, PLAN, TASKS) cho Feature F5.
- Phân định cấu trúc Hàng đợi (Queue): Vị trí 0 = Đã có sách sẵn (readypickup), Vị trí >0 = Đang chờ (pending). Cập nhật theo BR-20.
- Bổ sung Transaction Locking pattern vào PLAN.md để ngăn ngừa Race Condition khi đặt sách.
- Định nghĩa rõ thuật toán Gia hạn (Renewal): Cập nhật `extensionCount = extensionCount + 1` (FR-F5-33).
- Cập nhật Data Mapping: Kiểm tra nợ phạt mượn sách chuyển từ việc đọc bảng `Fine` hoặc `User.lockReason` sang truy vấn bảng `UserLockReason` nhằm đảm bảo hệ thống nhất quán (Consistency).
- Loại bỏ các luồng giao dịch Check-in, Check-out vật lý và Payment ra khỏi F5 để tách biệt trách nhiệm cho F6.
