# Changelog: Audit Log

Tất cả các thay đổi đáng chú ý của tính năng này sẽ được ghi nhận tại đây.

## [1.1.0] - 2026-07-21

### Changed
- Cập nhật `SPEC.md`:
  - Khắc phục lỗi lặp lại danh sách Use Cases.
  - Đồng bộ hóa 5 quy tắc nghiệp vụ (`BR-14`, `BR-32`, `BR-33`, `BR-34`, `BR-38`) và 8 yêu cầu chức năng (`FR-55` -> `FR-60`, `FR-73`, `FR-74`) khớp với tài liệu tổng thể.
  - Làm rõ lược đồ bảng `AuditLogs`, logic so sánh 1-1 dạng card trong modal, và kịch bản nghiệm thu.
- Cập nhật `PLAN.md`:
  - Thay đổi tính năng xuất báo cáo từ định dạng CSV sang định dạng Excel (.xlsx) thông qua Apache POI khớp với đặc tả yêu cầu.
  - Đồng bộ hóa danh sách các components, mô tả chi tiết luồng xử lý và tối ưu hóa phân trang database.
- Cập nhật `TASK.md`:
  - Thay đổi cấu trúc bảng cũ sang dạng checklist phân nhóm chuyên nghiệp.
  - Đánh dấu hoàn thành (`[x]`) các task liên quan đến model, DTO, DAO, Servlet và các trang JSP đã được cài đặt thành công.

## [1.0.0] - 2026-06-22

### Added
- Khởi tạo cấu trúc tài liệu quy chuẩn cho tính năng Nhật ký hoạt động.
- Thêm `SPEC.md`: Định nghĩa yêu cầu chức năng (FR), yêu cầu phi chức năng (NFR) và tiêu chí nghiệm thu (Acceptance Criteria).
- Thêm `Swimlane-auditLog.txt` (Diagram) mô tả luồng xem và lọc log.
- Thêm `CONTEXT.md`: Xác định bối cảnh nghiệp vụ của tính năng.
- Thêm `PLAN.md`: Mô tả kế hoạch triển khai kiến trúc.
- Thêm `TASK.md`: Phân rã các task công việc.
