# Feature Specification: Quản lý tài khoản người dùng (User Account Management)
# Version: 1.3 | Chủ sở hữu: Quyet | Ngày cập nhật: 2026-07-26 (Chuẩn hóa UC-BR-FR registry)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Tính năng cho phép Quản trị viên (SysAdmin) quản lý toàn bộ vòng đời tài khoản người dùng trong hệ thống LMS (tạo mới đơn lẻ, nhập hàng loạt từ Excel, cập nhật quyền hạn/trạng thái, khóa/mở khóa tài khoản, xuất báo cáo danh sách người dùng) và truy vết lịch sử thao tác qua Audit Log.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản trị viên (SysAdmin):** Toàn quyền truy cập danh sách, tạo mới, chỉnh sửa, khóa/mở khóa, import/export tài khoản người dùng.

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-07 (View User List):** Actor: Admin | (Xem danh sách người dùng): Quản trị viên truy vấn và xem danh sách tổng hợp mọi tài khoản trong hệ thống.
* **UC-08 (View User Detail):** Actor: Admin | (Xem chi tiết tài khoản): Quản trị viên trích xuất dữ liệu định danh chi tiết của một người dùng cụ thể.
* **UC-09 (Create Single Account):** Actor: Admin | (Cấp tài khoản đơn lẻ): Quản trị viên khởi tạo thủ công một tài khoản mới qua biểu mẫu nhập liệu.
* **UC-10 (Import Bulk Accounts):** Actor: Admin | (Nhập tài khoản hàng loạt): Quản trị viên tải tệp Excel để cấp phát tài khoản số lượng lớn.
* **UC-11 (Update User Account):** Actor: Admin | (Quản trị tài khoản): Quản trị viên thực hiện chỉnh sửa thông tin định danh hoặc thay đổi trạng thái (Khóa/Mở khóa) tài khoản.
* **UC-30 (Export User List):** Actor: Admin | (Xuất danh sách người dùng): Quản trị viên trích xuất danh sách tài khoản hiện tại ra tệp Excel.

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F3 User Account Management. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-10 (Data Validation):** Dữ liệu định danh gồm Email và Mã số (MSSV, MSGV...) BẮT BUỘC là duy nhất trên toàn hệ thống.
* **BR-11 (Transaction):** Quy trình nhập danh sách tài khoản khối lượng lớn BẮT BUỘC tuân thủ chiến lược "Thành công toàn bộ hoặc Hủy bỏ toàn bộ".
* **BR-12 (Provisioning):** Tài khoản khi khởi tạo BẮT BUỘC dùng Email làm mật khẩu mặc định.
* **BR-13 (Role Assignment):** File Excel dùng để Import khối lượng lớn KHÔNG ĐƯỢC chứa định nghĩa phân quyền. Quản trị viên BẮT BUỘC phải cấu hình Role chung từ giao diện trước khi thực thi tải tệp.
* **BR-14 (Mandatory Audit):** Mọi thao tác làm thay đổi dữ liệu tài khoản (Thêm, Sửa, Khóa, Mở khóa, Import) từ Quản trị viên BẮT BUỘC phải được lưu vết vào hệ thống Audit Log.
* **BR-54 (User List Pagination):** Tính năng xem danh sách tài khoản BẮT BUỘC phải phân trang và hỗ trợ bộ lọc (Filter) theo Role/Status để chống tràn bộ nhớ.
* **BR-55 (Self-Lock Prevention):** Quản trị viên (Admin) KHÔNG ĐƯỢC PHÉP thực hiện thao tác Khóa (Lock), Xóa (Delete), hoặc thay đổi Role trên chính tài khoản mà họ đang đăng nhập để tránh tình trạng hệ thống bị vô chủ (orphaned system).
* **BR-71 (Data Export Authorization):** The system SHALL restrict full user list data exports to the Admin role only.


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-12 (Đối chiếu dữ liệu trùng):** WHEN Admin thực hiện tạo hoặc cập nhật tài khoản, THE system SHALL quét toàn bộ CSDL để đảm bảo Email và Mã định danh là duy nhất.
  * *Mapping:* UC-09, UC-11 / BR-10
* **FR-13 (Rà soát danh sách Import với 2 Phase Validation):** WHEN ImportUserServlet.doPost(action=upload) nhận file Excel (.xlsx ≤10MB, tên ≤255 ký tự), THE system SHALL thực hiện Phase 1 (Pre-Validation) trên RAM: (1) Parse Excel bằng Apache POI, đọc từng sheet (Student/Lecturer/Admin), (2) Validate từng dòng: email unique (không trùng DB và không trùng trong file), memberCode unique, phoneNumber format, dateOfBirth hợp lệ, role-specific fields (major/enrollmentYear cho Student, department cho Lecturer), (3) WHERE phát hiện lỗi: thêm vào List<ImportError> với format "Sheet {sheetName} - Row {rowIndex}: {field} - {error detail}", (4) WHERE có lỗi: lưu errors vào session + redirect error page, (5) WHERE không lỗi: lưu List<UserImportDTO> vào session attribute "userImportPreview" + redirect confirmation page.
  * *Mapping:* UC-10 / BR-10, BR-11
* **FR-14 (Báo cáo lỗi Import):** WHERE Phase 1 phát hiện bất kỳ dữ liệu không hợp lệ nào, THE system SHALL hủy bỏ toàn bộ tiến trình (All-or-Nothing) và xuất báo cáo JSON chi tiết vị trí lỗi.
  * *Mapping:* UC-10 / BR-11
* **FR-15 (Lưu trữ hàng loạt với DB Transaction):** WHEN ImportUserServlet.doPost(action=import-{role}) được gọi sau khi user xác nhận preview, THE system SHALL thực hiện Phase 2 (DB Transaction): (1) Lấy userImportPreview từ session, lọc theo role, (2) Mở DB Transaction (conn.setAutoCommit(false)), (3) Với mỗi UserImportDTO: gọi UserService.createUser(dto, actorId) để BCrypt hash mật khẩu (= email), INSERT User, INSERT MemberProfile, INSERT role-specific table (Student/Lecturer/Admin), tạo thẻ thư viện mặc định 1 năm (libraryCardExpiry = NOW() + 31536000000ms), (4) INSERT AuditLog(BULK_USER_IMPORT, actorId, entityName='User', entityId=batchId), (5) conn.commit(), (6) WHERE SQLException: conn.rollback() + trả lỗi HTTP 500, (7) Clear session preview + redirect với flash success.
  * *Mapping:* UC-10 / BR-11, BR-12
* **FR-17 (Ghi nhận Audit Log Quản trị):** WHEN Quản trị viên thực hiện tạo mới, cập nhật thông tin, thay đổi trạng thái (Khóa/Mở khóa), hoặc Import hàng loạt tài khoản thành công, THE system SHALL tự động ghi nhận bản ghi vào bảng AuditLogs chứa thông tin actor, actionType, và dữ liệu thay đổi.
  * *Mapping:* UC-09, UC-10, UC-11 / BR-14
* **FR-18 (Truy xuất danh sách và chi tiết):** WHEN Quản trị viên yêu cầu xem danh sách hoặc chi tiết một tài khoản, THE system SHALL thực hiện truy vấn gộp (JOIN) dữ liệu từ bảng [User], MemberProfile và bảng phân quyền tương ứng (Student/Lecturer/Librarian) để hiển thị.
  * *Mapping:* UC-07, UC-08 / BR-54
* **FR-19 (Khởi tạo tài khoản đơn lẻ):** WHEN Quản trị viên gửi biểu mẫu tạo tài khoản đơn lẻ hợp lệ, THE system SHALL thực thi lệnh INSERT tuần tự vào các bảng [User], MemberProfile, và bảng Role đã chọn, ĐỒNG THỜI cấp mật khẩu mặc định.
  * *Mapping:* UC-09 / BR-12
* **FR-20 (Cập nhật và Trạng thái tài khoản):** WHEN Quản trị viên thao tác cập nhật tài khoản, THE system SHALL cho phép chỉnh sửa thông tin liên lạc tại MemberProfile, VÀ cho phép cập nhật status/lockReason tại bảng [User] để thực thi việc Khóa hoặc Mở khóa tài khoản.
  * *Mapping:* UC-11 / BR-14, BR-55
* **FR-21 (Rollback ngoại lệ Phase 2):** WHERE xảy ra lỗi SQLException bất ngờ trong quá trình thực thi Batch Insert (Phase 2) của tiến trình Import, THE system SHALL Rollback toàn bộ Database Transaction VÀ trả về HTTP 500 kèm lỗi hệ thống chung (ẩn stack trace).
  * *Mapping:* UC-10 / BR-11
* **FR-45 (Bulk Excel Export với 10 cột):** WHEN ExportUserServlet.doGet(search, role, status) được gọi, THE system SHALL: (1) Gọi UserService.getUsersForExport(search, role, status) để lấy toàn bộ danh sách user KHÔNG phân trang, (2) Build file Excel (.xlsx) bằng Apache POI với 10 cột: [Email, Họ tên, SĐT, Giới tính, Ngày sinh, Vai trò, Mã số (MSSV/MSGV/Staff), Chuyên ngành/Khoa, Năm nhập học/Năm vào, Trạng thái], (3) Set header Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, (4) Set header Content-Disposition: attachment; filename="danh_sach_nguoi_dung_{ROLE}_{YYYYMMDD}.xlsx", (5) Write workbook to response OutputStream, (6) Ghi AuditLog(EXPORT_USER_LIST, actorId).
  * *Mapping:* UC-30 / BR-71


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