# CHANGELOG.md — Quản lý Sách và Kho vật lý

## [1.0.0] - 2026-06-06
### Added
- Khởi tạo bộ hồ sơ SDD (CONTEXT, SPEC, PLAN, TASKS) cho Feature F4.
- Áp dụng EARS Notation chuẩn hóa toàn bộ các Functional Requirements.
- Quy định cấm thay đổi cấu trúc định danh lõi (ISBN, Barcode) bằng mọi giá (Bất biến/Immutable) sau khi khởi tạo thành công.
- Bổ sung cơ chế Transaction Management chặt chẽ cho Inventory Sync (Book `availableQuantity` & `totalQuantity`).

### Changed
- Phân định ranh giới tính năng: Thao tác Update `condition` thành 'damaged'/'lost' thông qua F4 (bảo trì kho thủ công) sẽ lập tức trừ `availableQuantity`. Thao tác Check-in trừ sách bị đẩy hẳn sang Module F6.
