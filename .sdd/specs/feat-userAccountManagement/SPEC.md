# Feature Specification: Quản lý tài khoản người dùng (User Account Management)
# Version: 1.2 | Chủ sở hữu: @quyet | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Tính năng cho phép Quản trị viên (SysAdmin) quản lý toàn bộ vòng đời tài khoản người dùng trong hệ thống LMS (tạo mới đơn lẻ, nhập hàng loạt từ Excel, cập nhật quyền hạn/trạng thái, khóa/mở khóa tài khoản, xuất báo cáo danh sách người dùng) và truy vết lịch sử thao tác qua Audit Log.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản trị viên (SysAdmin):** Toàn quyền truy cập danh sách, tạo mới, chỉnh sửa, khóa/mở khóa, import/export tài khoản người dùng.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-07 (View User List):** Actor: Admin | Xem danh sách người dùng, tìm kiếm theo tên/email/mã số, lọc theo Vai trò và Trạng thái.
* **UC-08 (Create User Account):** Actor: Admin | Tạo tài khoản người dùng mới kèm hồ sơ và vai trò tương ứng.
* **UC-09 (Update User Account):** Actor: Admin | Cập nhật thông tin tài khoản, vai trò, hoặc khóa/mở khóa tài khoản.
* **UC-10 (Import Users from Excel):** Actor: Admin | Tải lên danh sách tài khoản từ file Excel (`.xlsx`) để chèn hàng loạt vào CSDL.
* **UC-11 (Export Users):** Actor: Admin | Xuất danh sách tài khoản ra định dạng file Excel hoặc CSV.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-10 (Email & Code Uniqueness):** Email và Mã định danh (studentCode/lecturerCode/staffCode) BẮT BUỘC là duy nhất trong toàn hệ thống.
* **BR-11 (Atomic User Creation):** Thao tác tạo tài khoản BẮT BUỘC phải thực hiện trong một DB Transaction (tạo `"User"` -> `MemberProfile` -> Bảng Vai Trò). Nếu một bước thất bại, toàn bộ Transaction phải được Rollback.
* **BR-12 (Locking Reasons):** Khóa tài khoản bởi Admin phải ghi rõ lý do (`adminban`, `unpaid`, `securitybreach`) vào bảng `UserLockReason` và tạo bản ghi trong `AuditLogs`.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-12 (Danh sách & Lọc tài khoản):** WHEN Admin truy cập `UserListServlet`, THE system SHALL hỗ trợ tìm kiếm theo từ khóa (name, email, code), lọc theo Role (STUDENT, LECTURER, LIBRARIAN, MANAGER, ADMIN) và Status (active, locked, inactive) có phân trang.
  * *Mapping:* UC-07
* **FR-13 (Tạo tài khoản giao dịch đơn lẻ):** WHEN Admin tạo người dùng mới qua `CreateUserServlet`, THE system SHALL mở DB Transaction để chèn dữ liệu đồng thời vào bảng `"User"`, `MemberProfile` và bảng vai trò chuyên biệt (`Student`/`Lecturer`/`Librarian`/`LibraryManager`/`Admin`). Ghi `AuditLogs` với action `CREATE_USER`.
  * *Mapping:* UC-08 / BR-10, BR-11
* **FR-14 (Cập nhật & Khóa/Mở khóa tài khoản):** WHEN Admin cập nhật tài khoản qua `UpdateUserServlet`, THE system SHALL cho phép cập nhật status, role, profile. WHERE status đổi thành `locked`, hệ thống ghi nhận bản ghi mới vào `UserLockReason`. WHERE status đổi thành `active`, hệ thống xóa các lý do khóa tương ứng. Ghi `AuditLogs` cho thao tác C/U/D.
  * *Mapping:* UC-09 / BR-12
* **FR-15 (Nhập dữ liệu hàng loạt từ Excel):** WHEN Admin tải lên file Excel tại `ImportUserServlet`, THE system SHALL dùng Apache POI đọc từng dòng, kiểm tra tính hợp lệ (email chưa trùng, mã số đúng định dạng). Dòng hợp lệ được chèn vào DB, dòng lỗi được ghi lại để xuất báo cáo preview kết quả import.
  * *Mapping:* UC-10 / BR-10
* **FR-17 (Xuất danh sách ra file):** WHEN Admin yêu cầu export tại `ExportUserServlet`, THE system SHALL truy vấn danh sách người dùng theo bộ lọc hiện tại và kết xuất ra file Excel (`.xlsx`) hoặc CSV với font Unicode tiếng Việt.
  * *Mapping:* UC-11

## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Chỉ role ADMIN mới có quyền truy cập các Servlet `/admin/*`. Mật khẩu mặc định khi tạo mới hoặc import phải được hash BCrypt.
* **Hiệu năng:** Xử lý file import Excel 1,000 dòng trong thời gian dưới 3 giây.
* **Giao diện:** Đầy đủ form validation, hiển thị modal xác nhận khi khóa tài khoản.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `"User"`, `MemberProfile`, `UserLockReason`
* Chuẩn PascalCase cho tên bảng, camelCase cho cột. `User` bắt buộc bọc nháy kép trong SQL.

### Bảng Vai Trò (`Student`, `Lecturer`, `Librarian`, `LibraryManager`, `Admin`)
* `userId` (INT, PK/FK), `studentCode`/`lecturerCode`/`staffCode` (VARCHAR, UNIQUE).

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** email hoặc mã định danh đã tồn tại, **THE system SHALL** báo lỗi "Email hoặc Mã người dùng đã tồn tại trong hệ thống".
* **WHERE** file import sai cấu trúc cột Excel, **THE system SHALL** từ chối xử lý và hiển thị hướng dẫn tải file mẫu.

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-USER-01] Hiển thị đúng danh sách tài khoản có phân trang và lọc theo vai trò/trạng thái.
- [ ] [TC-USER-02] Tạo thành công tài khoản Sinh viên mới (chèn đầy đủ 3 bảng: User, MemberProfile, Student).
- [ ] [TC-USER-03] Khóa tài khoản ghi lý do vào UserLockReason và cập nhật AuditLogs.
- [ ] [TC-USER-04] Import thành công danh sách từ Excel và thông báo số lượng dòng thành công/thất bại.
- [ ] [TC-USER-05] Export file Excel chứa đầy đủ thông tin tiếng Việt không lỗi font.

## 8. Out of Scope (Phạm vi không thực hiện)
* Tự động gửi SMS thông báo tài khoản cho người dùng.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện bộ Servlet và DAO quản lý người dùng với đầy đủ Audit Log.