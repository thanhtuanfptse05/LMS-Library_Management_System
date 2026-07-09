# CHANGELOG.md — Bảo trì sách và Kiểm kê

## [1.1.0] - 2026-07-09
### Fixed
- Xóa hai khối Use Case bị lặp.
- Đồng bộ incident type/status với schema: `damaged/lost` và `pending/investigating/resolved/rejected`.
- Đồng bộ inventory state: `draft/counting/reviewing/completed/cancelled` và item result `pending/matched/missing/misplaced`.
- Sửa luồng report: nhận Barcode, ngừng lưu thông ngay nhưng chỉ đổi condition khi resolve.
- Sửa reject/restore để cộng lại `availableQuantity` đúng một lần; loại bỏ trạng thái `disposed`.
- Làm rõ `missing` là kết quả kiểm kê và được chuyển thành incident `lost`.
- Bổ sung CONTEXT, PLAN, TASK và Activity Diagram theo form hiện hữu.

## [1.0.0] - 2026-07-03
### Added
- Khởi tạo SPEC cho UC-28, UC-29, BR-28 và FR-48..51.
