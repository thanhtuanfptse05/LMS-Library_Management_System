# Changelog: System Configuration

Tất cả các thay đổi đáng chú ý của tính năng này sẽ được ghi nhận tại đây.

## [1.1.0] - 2026-07-21

### Changed
- Cập nhật `SPEC.md`:
  - Khắc phục lỗi lặp lại danh sách Use Cases.
  - Tích hợp đầy đủ các quy tắc nghiệp vụ (`BR-30`, `BR-31`, `BR-40`, `BR-53`) và 14 yêu cầu chức năng (`FR-84` -> `FR-97`) từ đặc tả tổng thể.
  - Làm rõ lược đồ bảng `SystemConfigurations`, cơ chế validate định dạng lỗi và kịch bản nghiệm thu.
- Cập nhật `PLAN.md`:
  - Thay đổi thông tin cache sang `SystemConfigCache` khớp với code Java thực tế.
  - Cập nhật danh sách key whitelist thực tế và các Servlets tương ứng (`SystemConfigServlet`, `AdminSystemConfigServlet`, `ManagerPaymentConfigServlet`).
  - Làm chi tiết luồng xử lý phân quyền và validate tại Service Layer.
- Cập nhật `TASK.md`:
  - Đánh dấu hoàn thành (`[x]`) cho tất cả các tác vụ đã triển khai thành công trên codebase.
  - Đồng bộ hóa mô tả các task kiểm thử đơn vị (`SystemConfigServiceTest`).

## [1.0.0] - 2026-06-22

### Added
- Khởi tạo cấu trúc tài liệu quy chuẩn cho tính năng Cấu hình hệ thống.
- Thêm `SPEC.md`: Định nghĩa yêu cầu chức năng (FR), yêu cầu phi chức năng (NFR) và tiêu chí nghiệm thu (Acceptance Criteria).
- Thêm `PLAN.md`: Mô tả kế hoạch triển khai và lớp cache AppConfig.
- Thêm `TASK.md`: Danh sách công việc cần làm cho tính năng.
