# CHANGELOG.md — Quản lý Sách và Kho vật lý

## [1.1.0] - 2026-07-09
### Fixed
- Xóa hai khối Use Case bị lặp, giữ đúng một danh sách UC-12, UC-13, UC-14, UC-15, UC-27, UC-52.
- Đồng bộ FR-22..28, FR-46, FR-47, FR-81 với schema PostgreSQL và hành vi code hiện tại.
- Loại bỏ field/trạng thái không có trong schema: `acquisitionDate`, `quantity`, batch `processing/completed`.
- Chốt import all-or-nothing; loại bỏ mô tả skip row/partial success và tự sinh Barcode.
- Sửa đường dẫn schema trong TASK thành `database/supabase/LMS_Schema_PostgreSQL.sql`.
- Tách đúng boundary: sự cố hỏng/mất và kiểm kê thuộc F13 `feat-bookMaintenance`.
- Sửa PLAN/TASK để dùng đúng class/service/DAO hiện hữu và mã FR toàn cục, không dùng hệ `FR-F4-*` song song.

### Changed
- Cập nhật Activity Diagram F4 theo cùng form node/action sẵn có, bao phủ catalog, Book, BookCopy, Category/Tag, import và lịch sử import.
- Bổ sung tiêu chí RBAC, Audit Log, tiếng Việt, transaction và hiệu năng vào DoD.

## [1.0.0] - 2026-06-06
### Added
- Khởi tạo bộ hồ sơ SDD (CONTEXT, SPEC, PLAN, TASKS) cho Feature F4.
- Áp dụng EARS Notation cho Functional Requirements.
- Quy định ISBN/Barcode bất biến và transaction cho Inventory Sync.
