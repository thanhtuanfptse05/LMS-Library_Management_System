# CHANGELOG.md — Feature 3: User Account Management
# Phiên bản: 1.1.0 | Cập nhật: 2026-06-01 | Khởi tạo: 1.0.0 — 2026-06-01

## [1.1.0] — 2026-06-01 (GAP Resolution)

### Changed — Import Strategy & Error Reporting
* **[GAP-01 Resolution — Import Strategy]**: Thay đổi chiến lược Import từ "Validate-then-Insert" mơ hồ sang **2-Phase All-or-Nothing**:
  * **Phase 1 (Pre-Validation / RAM-only)**: Toàn bộ dữ liệu Excel được quét đầy đủ (local HashSet + 1 batch DB query) *trước khi* mở bất kỳ DB Transaction nào. Phát hiện BẤT KỲ lỗi nào → dừng hẳn, không ghi dòng nào.
  * **Phase 2 (DB Transaction)**: Chỉ thực thi khi Phase 1 trả về empty error list. Đảm bảo DB nhận dữ liệu sạch 100%.
  * *Quyết định*: Chọn All-or-Nothing thay vì Partial Success vì độ phức tạp thấp hơn, dễ kiểm soát tính toàn vẹn dữ liệu, phù hợp với ràng buộc Foreign Key 3-bảng.
* **[GAP-02 Resolution — Error Reporting]**: Thay thế phản hồi lỗi chung chung (HTTP 400 + message string) bằng **JSON structured error array**:
  * Response body: `{ status, totalRows, errorCount, errors: [{ row, field, errorCode, message }] }`.
  * `errorCode` enum: `DUPLICATE_EMAIL`, `DUPLICATE_CODE`, `INVALID_FORMAT`, `MISSING_REQUIRED_FIELD`.
  * Admin nhận đủ thông tin (`row`, `field`, lý do) để sửa file Excel mà không cần đoán mò.

### Added
* **`ImportErrorDTO`** (`dto/ImportErrorDTO.java`): POJO response-only mới, chứa 4 trường `row`, `field`, `errorCode`, `message`. Không map với bảng DB.

### Updated Estimates
* **T-UAM-04** (`UserService`): Tăng estimate từ 3h → **4h** do bổ sung logic Phase 1 (`validateImportList()`).

---

## [1.0.0] — 2026-06-01 (Khởi tạo)

## Added
* [SPEC] Khởi tạo SPEC.md tuân thủ EARS Notation và 8 thành phần cốt lõi của SDD.
* [FLOW] Thiết lập luồng phân nhánh độc lập cho Xem/Cập nhật, Tạo đơn lẻ, và Import hàng loạt.
* [TECH] Bổ sung kỹ thuật JDBC Batch Insert để xử lý Import Excel tối ưu hiệu năng.

## Changed (Kiến trúc & Quyết định hệ thống)
* [Logic Update 01]: Tích hợp trạng thái Khóa/Mở khóa tài khoản trực tiếp vào luồng Cập nhật (`updateUserAccount`), không tách thành tính năng riêng.
* [Logic Update 02]: Luồng Import Excel BẮT BUỘC Admin chọn cấu hình Role trên UI trước khi upload file. File template KHÔNG chứa cột Role để loại bỏ rủi ro sai lệch dữ liệu phân quyền.
