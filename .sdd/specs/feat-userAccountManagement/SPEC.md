# SPEC.md — User Account Management
# Version: 1.1.0 | Status: APPROVED | Risk Level: HIGH
# Changelog: v1.1.0 — Giải quyết GAP-01 (Import Strategy) và GAP-02 (Error Reporting)

## 1. Context & Goal
Cung cấp công cụ CRUD và Bulk Import cho Admin để quản trị tài khoản, kiểm soát quyền truy cập và giải quyết bài toán nhập liệu khối lượng lớn.

## 2. Actors & Roles
* **Admin**: Role duy nhất được phép truy cập (`/admin/users/*`).

## 3. Functional Requirements (EARS)

### UBIQUITOUS (Luật chung)
* THE system SHALL mã hóa toàn bộ mật khẩu mới bằng thuật toán BCrypt trước khi lưu.
* THE system SHALL cấp mật khẩu mặc định (Email) cho tài khoản mới VÀ đánh dấu `lockReason = 'RequirePasswordChange'` nếu cần ép đổi pass lần đầu (BR29).

### EVENT-DRIVEN (Thao tác Đọc/Ghi)
* WHEN Admin truy cập danh sách, THE system SHALL hiển thị dữ liệu từ bảng `[User]` join với `MemberProfile`.
* WHEN Admin submit form tạo đơn lẻ, THE system SHALL thực thi lệnh INSERT tuần tự vào `[User]`, `MemberProfile`, và bảng Role đã chọn.
* WHEN Admin chọn Role và upload file Excel, THE system SHALL thực thi **Phase 1 (Pre-Validation)**: parse toàn bộ file, quét tính hợp lệ (format, regex, trùng lặp email/code) trên RAM — KHÔNG mở DB Transaction.
* WHEN Phase 1 phát hiện BẤT KỲ lỗi nào, THE system SHALL CHẶN toàn bộ Import, KHÔNG ghi bất kỳ dòng nào vào DB, VÀ trả về HTTP 400 kèm JSON array danh sách lỗi chi tiết.
* WHEN Phase 1 pass hoàn toàn (zero error), THE system SHALL thực thi **Phase 2 (DB Transaction)**: mở Transaction, Batch Insert toàn bộ list đã xác thực, sinh mật khẩu mặc định, VÀ Commit.

### STATE-DRIVEN (Trạng thái)
* WHILE tài khoản có `status = 'locked'`, THE system SHALL từ chối mọi yêu cầu xác thực đăng nhập từ tài khoản đó.

## 4. Non-functional Requirements
* **Performance**: Luồng Import Excel xử lý thành công file 1,000 dòng trong < 5 giây (P95).
* **Memory**: File upload phải được parse bằng SAX parser hoặc chunk processing để tránh OutOfMemoryError.

## 5. Data Model
* `[User]`: userId, email, passwordHash, status, role
* `MemberProfile`: userId, fullName, phoneNumber
* Bảng liên kết Role: `Student` (studentCode), `Lecturer` (lecturerCode), `Admin`, `Librarian`, `LibraryManager`.
* **`ImportErrorDTO`** *(Response-only, không map DB)*: `{ int row, String field, String errorCode, String message }`
  * `errorCode` nhận các giá trị: `DUPLICATE_EMAIL`, `DUPLICATE_CODE`, `INVALID_FORMAT`, `MISSING_REQUIRED_FIELD`.

## 6. Error Handling (UNWANTED)

### 6.1 — Form Tạo Đơn Lẻ
* WHERE Form chứa Email hoặc Mã định danh đã tồn tại, THE system SHALL từ chối ghi dữ liệu VÀ trả về HTTP 400 kèm JSON `{ "error": "DUPLICATE_EMAIL" | "DUPLICATE_CODE", "message": "..." }`.

### 6.2 — Import Excel (GAP-01 & GAP-02 Resolution)
* WHERE Phase 1 (Pre-Validation) phát hiện lỗi trong file Excel, THE system SHALL:
  1. Dừng toàn bộ Import (ALL-OR-NOTHING — không ghi bất kỳ dòng nào).
  2. Trả về HTTP 400 với body JSON:
     ```json
     {
       "status": "VALIDATION_FAILED",
       "totalRows": 1000,
       "errorCount": 3,
       "errors": [
         { "row": 5,  "field": "email",       "errorCode": "DUPLICATE_EMAIL",       "message": "Email đã tồn tại trong hệ thống." },
         { "row": 12, "field": "studentCode",  "errorCode": "DUPLICATE_CODE",        "message": "Mã sinh viên đã tồn tại." },
         { "row": 47, "field": "phoneNumber",  "errorCode": "INVALID_FORMAT",        "message": "Số điện thoại không đúng định dạng 10 chữ số." }
       ]
     }
     ```
* WHERE SQL Exception xảy ra trong Phase 2 (Batch Insert), THE system SHALL Rollback toàn bộ Transaction VÀ trả về HTTP 500 với message hệ thống (không lộ stack trace ra client).

## 7. Acceptance Criteria (Theo Activity Diagram)
* [ ] Admin xem được danh sách và chi tiết User (Node 4 - 6).
* [ ] Admin tạo tài khoản đơn lẻ thành công, DB ghi đúng 3 bảng phụ thuộc (Node 7, 10, 13, 16).
* [ ] Admin cập nhật thông tin/Khóa tài khoản thành công (Node 12, 15, 18, 20, 22).
* [ ] Nhập trùng Email/Code trong Form bị chặn lại — trả về JSON lỗi (Node 24).
* [ ] Admin Import Excel 100 dòng hợp lệ → Phase 1 pass → Phase 2 Batch Insert thành công (Node 8, 11, 14, 17, 19, 21, 23).
* [ ] **[GAP-01]** Upload file Excel có ≥ 1 dòng sai → Phase 1 chặn, DB KHÔNG ghi bất kỳ dòng nào.
* [ ] **[GAP-02]** Response HTTP 400 chứa JSON array `errors[]` với đúng `row`, `field`, `errorCode`, `message` cho từng dòng lỗi.

## 8. Out of Scope (Ngoài phạm vi)
* THE system SHALL NOT ghi nhận Audit Logs cho module này (Override BR19).
* THE system SHALL NOT cho phép thao tác "Xóa vĩnh viễn" (Hard Delete) bản ghi trong DB.
* THE system SHALL NOT cung cấp tính năng Export Excel.
* THE system SHALL NOT xử lý file Excel chứa nhiều Role lẫn lộn.
