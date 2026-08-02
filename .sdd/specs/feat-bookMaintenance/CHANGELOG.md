# CHANGELOG.md — Bảo trì sách và Kiểm kê

## [1.3.0] - 2026-08-02
### Changed
- Snapshot kiểm kê chỉ tạo khi start; tách đúng created/started/completed/cancelled và chỉ cho một phiên counting/reviewing trên toàn hệ thống.
- Bổ sung kết quả `excluded`, chặn quét trùng và chặn finish-counting khi chưa quét bản sao kỳ vọng nào.
- Resolve misplaced có hai lựa chọn: đưa sách về vị trí gốc hoặc chủ động đổi vị trí đăng ký; không tự động cập nhật location khi chỉ phát hiện sai vị trí.
- Mọi resolve misplaced/missing khóa bản ghi và kiểm tra copy còn available/good/chưa thanh lý, location chưa lệch snapshot.
- Resolve missing đồng bộ sức chứa theo reservation trừu tượng, không làm `availableQuantity` âm.

## [1.2.0] - 2026-07-23
### Added
- Bổ sung luồng loại bản sao hỏng nặng khỏi tổng kho bằng `BookCopy.removedFromInventory`, `removedFromInventoryAt`, `removedFromInventoryBy`; giữ record BookCopy để tra cứu lịch sử, không hard-delete.
- Thêm action F13 `removeFromInventory` cho incident `damaged/resolved` chưa bị loại khỏi kho.

### Changed
- Kết luận sự cố `lost` trong F13 sẽ loại khỏi tổng kho và giảm `Book.totalQuantity` đúng một lần.
- F13 tiếp nhận incident `resolved` từ F6 và cho phép bản sao `damaged` được khôi phục hoặc loại khỏi kho tùy khả năng sửa chữa.

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
