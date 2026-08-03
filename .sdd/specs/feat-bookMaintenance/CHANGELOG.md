# CHANGELOG.md — Bảo trì sách và Kiểm kê

## [1.5.0] - 2026-08-04
### Added
- Cho phép ghi nhận bản sao vật lý bất thường trong lúc quét với kết quả `unexpected` và năm loại `anomalyType`: sách hỏng trên kệ, sách đang mượn trên kệ, tìm thấy sách đã báo mất, tìm thấy sách đã loại khỏi kho và sách không khả dụng trên kệ.
- Bổ sung `expectedInSession` để tách bản sao thuộc snapshot dự kiến khỏi bản sao chỉ được phát hiện khi quét.
- Bổ sung action `resolve-unexpected` để Thủ thư xác nhận đã đưa bản sao khỏi kệ và chuyển sang quy trình phù hợp mà không tự động sửa trạng thái BookCopy.
- Bổ sung tổng hợp tình trạng theo vị trí: kệ quản lý, đang mượn, hỏng/đang xử lý và dự kiến có trên kệ.

### Changed
- Snapshot dự kiến chỉ gồm BookCopy `good/available/chưa thanh lý` tại vị trí kiểm kê, nhưng thao tác scan vẫn ghi nhận mọi Barcode tồn tại trên hệ thống.
- Tiến độ phiên tách `Cần quét`, `Đã quét dự kiến`, `Bất thường` và `Còn lại`; bản sao bất thường không làm tăng tổng dự kiến.
- Complete phiên bị chặn khi còn bất kỳ `missing`, `misplaced` hoặc `unexpected` chưa xử lý.

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
