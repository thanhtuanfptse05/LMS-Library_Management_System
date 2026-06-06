# CHANGELOG.md — Quản lý Đặt trước và Gia hạn trực tuyến

## [1.0.0] - 2026-06-06
### Added
- Khởi tạo bộ hồ sơ SDD (CONTEXT, SPEC, PLAN, TASKS) cho Feature F5.
- Phân định cấu trúc Hàng đợi (Queue): Vị trí 0 = Đã có sách sẵn (readypickup), Vị trí >0 = Đang chờ (pending). Cập nhật theo BR-20.
- Bổ sung Transaction Locking pattern vào PLAN.md để ngăn ngừa Race Condition khi đặt sách.
- Định nghĩa rõ thuật toán Gia hạn (Renewal): Cập nhật `extensionCount = extensionCount + 1` (FR-F5-33).

### Changed
- Cập nhật Data Mapping: Kiểm tra nợ phạt mượn sách chuyển từ việc đọc bảng `Fine` hoặc `User.lockReason` sang truy vấn bảng `UserLockReason` nhằm đảm bảo hệ thống nhất quán (Consistency).
- Loại bỏ các luồng giao dịch Check-in, Check-out vật lý và Payment ra khỏi F5 để tách biệt trách nhiệm cho F6.
