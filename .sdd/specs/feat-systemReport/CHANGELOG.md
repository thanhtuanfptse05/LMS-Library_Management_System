# Changelog: System Report

Tất cả các thay đổi đáng chú ý của tính năng này sẽ được ghi nhận tại đây.

## [1.1.0] - 2026-07-21

### Changed
- Cập nhật `SPEC.md`: 
  - Khắc phục lỗi lặp lại danh sách Use Cases.
  - Đồng bộ và làm chi tiết hóa 7 yêu cầu chức năng (`FR-72`, `FR-83`, `FR-98`, `FR-99`, `FR-100`, `FR-101`, `FR-102`) khớp với tài liệu tổng thể `spec-UC-BR-FR.txt`.
  - Khai báo đầy đủ các quy tắc nghiệp vụ (`BR-38`, `BR-43`, `BR-44`, `BR-45`, `BR-52`, `BR-73`).
  - Chi tiết hóa lược đồ dữ liệu cơ sở dữ liệu và tiêu chí nghiệm thu.
- Cập nhật `CONTEXT.md`: Bổ sung phần ánh xạ các Use Cases liên quan để làm rõ mục tiêu.
- Cập nhật `PLAN.md`: Cập nhật cấu trúc thư mục file mã nguồn (Servlets, DAOs, DTOs, JSPs) khớp 100% với mã nguồn triển khai thực tế trên đĩa.
- Cập nhật `TASKS.md`: Chuẩn hóa danh sách công việc và ánh xạ các task theo các FR và BR của spec mới.

## [1.0.0] - 2026-06-22

### Added
- Khởi tạo cấu trúc tài liệu quy chuẩn cho tính năng Báo cáo hệ thống.
- Thêm `SPEC.md`: Định nghĩa yêu cầu chức năng (FR), yêu cầu phi chức năng (NFR) và tiêu chí nghiệm thu (Acceptance Criteria).
- Thêm `Swimlane-systemReport.txt` (Diagram): Mô tả luồng hoạt động xem biểu đồ và xuất báo cáo Excel.
- Thêm `CONTEXT.md`: Định nghĩa mục tiêu kinh doanh.
- Thêm `PLAN.md`: Mô tả kiến trúc mã nguồn và thư viện (Apache POI, Chart.js) sẽ sử dụng.
- Thêm `TASKS.md`: Danh sách công việc phân rã theo Giai đoạn (Data Layer -> Service -> Controller -> View).
