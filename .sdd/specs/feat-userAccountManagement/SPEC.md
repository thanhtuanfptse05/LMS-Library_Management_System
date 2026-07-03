# Feature Specification: Quản trị tài khoản (User Account Management)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cho phép Quản trị viên (Admin) quản lý vòng đời tài khoản người dùng bao gồm tạo mới đơn lẻ, import hàng loạt từ Excel, cập nhật thông tin, xuất danh sách ra Excel và khóa/mở khóa tài khoản.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản trị viên (Admin):** Có toàn quyền xem danh sách, tạo mới, cập nhật, khóa/mở khóa và import/export tài khoản.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-07 (View User List):** Actor: Admin | (Xem danh sách người dùng): Quản trị viên truy vấn và xem danh sách tổng hợp mọi tài khoản trong hệ thống.
* **UC-08 (View User Detail):** Actor: Admin | (Xem chi tiết tài khoản): Quản trị viên trích xuất dữ liệu định danh chi tiết của một người dùng cụ thể.
* **UC-09 (Create Single Account):** Actor: Admin | (Cấp tài khoản đơn lẻ): Quản trị viên khởi tạo thủ công một tài khoản mới qua biểu mẫu nhập liệu.
* **UC-10 (Import Bulk Accounts):** Actor: Admin | (Nhập tài khoản hàng loạt): Quản trị viên tải tệp Excel để cấp phát tài khoản số lượng lớn.
* **UC-11 (Update User Account):** Actor: Admin | (Quản trị tài khoản): Quản trị viên thực hiện chỉnh sửa thông tin định danh hoặc thay đổi trạng thái (Khóa/Mở khóa) tài khoản.
* **UC-30 (Export User List):** Actor: Admin | (Xuất danh sách người dùng): Quản trị viên trích xuất danh sách tài khoản hiện tại ra tệp Excel.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-07 (View User List):** Actor: Admin | (Xem danh sách người dùng): Quản trị viên truy vấn và xem danh sách tổng hợp mọi tài khoản trong hệ thống.
* **UC-08 (View User Detail):** Actor: Admin | (Xem chi tiết tài khoản): Quản trị viên trích xuất dữ liệu định danh chi tiết của một người dùng cụ thể.
* **UC-09 (Create Single Account):** Actor: Admin | (Cấp tài khoản đơn lẻ): Quản trị viên khởi tạo thủ công một tài khoản mới qua biểu mẫu nhập liệu.
* **UC-10 (Import Bulk Accounts):** Actor: Admin | (Nhập tài khoản hàng loạt): Quản trị viên tải tệp Excel để cấp phát tài khoản số lượng lớn.
* **UC-11 (Update User Account):** Actor: Admin | (Quản trị tài khoản): Quản trị viên thực hiện chỉnh sửa thông tin định danh hoặc thay đổi trạng thái (Khóa/Mở khóa) tài khoản.
* **UC-30 (Export User List):** Actor: Admin | (Xuất danh sách người dùng): Quản trị viên trích xuất danh sách tài khoản hiện tại ra tệp Excel.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-07 (View User List):** Actor: Admin | (Xem danh sách người dùng): Quản trị viên truy vấn và xem danh sách tổng hợp mọi tài khoản trong hệ thống.
* **UC-08 (View User Detail):** Actor: Admin | (Xem chi tiết tài khoản): Quản trị viên trích xuất dữ liệu định danh chi tiết của một người dùng cụ thể.
* **UC-09 (Create Single Account):** Actor: Admin | (Cấp tài khoản đơn lẻ): Quản trị viên khởi tạo thủ công một tài khoản mới qua biểu mẫu nhập liệu.
* **UC-10 (Import Bulk Accounts):** Actor: Admin | (Nhập tài khoản hàng loạt): Quản trị viên tải tệp Excel để cấp phát tài khoản số lượng lớn.
* **UC-11 (Update User Account):** Actor: Admin | (Quản trị tài khoản): Quản trị viên thực hiện chỉnh sửa thông tin định danh hoặc thay đổi trạng thái (Khóa/Mở khóa) tài khoản.
* **UC-30 (Export User List):** Actor: Admin | (Xuất danh sách người dùng): Quản trị viên trích xuất danh sách tài khoản hiện tại ra tệp Excel.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-10 (Data Validation):** Dữ liệu định danh gồm Email và Mã số (MSSV, MSGV...) BẮT BUỘC là duy nhất trên toàn hệ thống.
* **BR-11 (Transaction):** Quy trình nhập danh sách tài khoản khối lượng lớn BẮT BUỘC tuân thủ chiến lược "Thành công toàn bộ hoặc Hủy bỏ toàn bộ".
* **BR-12 (Provisioning):** Tài khoản khi khởi tạo BẮT BUỘC dùng Email làm mật khẩu mặc định.
* **BR-13 (Role Assignment):** File Excel dùng để Import khối lượng lớn KHÔNG ĐƯỢC chứa định nghĩa phân quyền. Quản trị viên BẮT BUỘC phải cấu hình Role chung từ giao diện trước khi thực thi tải tệp.
* **BR-14 (Mandatory Audit):** Mọi thao tác làm thay đổi dữ liệu tài khoản (Thêm, Sửa, Khóa, Mở khóa, Import) từ Quản trị viên BẮT BUỘC phải được lưu vết vào hệ thống Audit Log.
* **BR-54 (User List Pagination):** Tính năng xem danh sách tài khoản BẮT BUỘC phải phân trang và hỗ trợ bộ lọc (Filter) theo Role/Status để chống tràn bộ nhớ.
* **BR-55 (Self-Lock Prevention):** Quản trị viên (Admin) KHÔNG ĐƯỢC PHÉP thực hiện thao tác Khóa (Lock), Xóa (Delete), hoặc thay đổi Role trên chính tài khoản mà họ đang đăng nhập để tránh tình trạng hệ thống bị vô chủ (orphaned system).

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
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
  * *Mapping:* UC-07, UC-08
* **FR-19 (Khởi tạo tài khoản đơn lẻ):** WHEN Quản trị viên gửi biểu mẫu tạo tài khoản đơn lẻ hợp lệ, THE system SHALL thực thi lệnh INSERT tuần tự vào các bảng [User], MemberProfile, và bảng Role đã chọn, ĐỒNG THỜI cấp mật khẩu mặc định.
  * *Mapping:* UC-09 / BR-12
* **FR-20 (Cập nhật và Trạng thái tài khoản):** WHEN Quản trị viên thao tác cập nhật tài khoản, THE system SHALL cho phép chỉnh sửa thông tin liên lạc tại MemberProfile, VÀ cho phép cập nhật status/lockReason tại bảng [User] để thực thi việc Khóa hoặc Mở khóa tài khoản.
  * *Mapping:* UC-11
* **FR-21 (Rollback ngoại lệ Phase 2):** WHERE xảy ra lỗi SQLException bất ngờ trong quá trình thực thi Batch Insert (Phase 2) của tiến trình Import, THE system SHALL Rollback toàn bộ Database Transaction VÀ trả về HTTP 500 kèm lỗi hệ thống chung (ẩn stack trace).
  * *Mapping:* UC-10 / BR-11
* **FR-45 (Bulk Excel Export với 10 cột):** WHEN ExportUserServlet.doGet(search, role, status) được gọi, THE system SHALL: (1) Gọi UserService.getUsersForExport(search, role, status) để lấy toàn bộ danh sách user KHÔNG phân trang, (2) Build file Excel (.xlsx) bằng Apache POI với 10 cột: [Email, Họ tên, SĐT, Giới tính, Ngày sinh, Vai trò, Mã số (MSSV/MSGV/Staff), Chuyên ngành/Khoa, Năm nhập học/Năm vào, Trạng thái], (3) Set header Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, (4) Set header Content-Disposition: attachment; filename="danh_sach_nguoi_dung_{ROLE}_{YYYYMMDD}.xlsx", (5) Write workbook to response OutputStream, (6) Ghi AuditLog(EXPORT_USER_LIST, actorId).
  * *Mapping:* UC-30

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Bảo mật: Mã hóa mật khẩu bằng BCrypt, chống SQL Injection trong truy vấn tìm kiếm.
* Hiệu năng: Xuất file Excel 10,000 dòng trong dưới 3 giây.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng User
* `userId` (INT, PK)
* `email` (VARCHAR(255))
* `passwordHash` (VARCHAR(255))
* `status` (VARCHAR(50))
* `role` (VARCHAR(50))

### Bảng MemberProfile
* `userId` (INT, PK, FK)

### Bảng Student
* `userId` (INT, PK, FK)
* `studentCode` (VARCHAR(50))
* `major` (VARCHAR(255))
* `enrollmentYear` (INT)

### Bảng Lecturer
* `userId` (INT, PK, FK)
* `lecturerCode` (VARCHAR(50))
* `department` (VARCHAR(255))



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE Email hoặc Mã số sinh viên/giảng viên bị trùng lặp, THE system SHALL thông báo lỗi cụ thể cho Quản trị viên.
* WHERE file Excel tải lên sai định dạng cột, THE system SHALL từ chối import và hiển thị cấu trúc mẫu đúng.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Tạo tài khoản đơn lẻ: Email và Mã số hợp lệ -> Tạo thành công, ghi Audit Log.
- [ ] Khóa tài khoản sinh viên: Trạng thái sinh viên chuyển sang 'locked', không thể đăng nhập.
- [ ] Import Excel không hợp lệ: Có 1 dòng sai định dạng -> Hủy toàn bộ đợt import, hiển thị thông báo lỗi dòng tương ứng.
- [ ] Tự khóa bản thân: Admin cố tình khóa tài khoản chính mình -> Hệ thống chặn và hiển thị lỗi 'Không thể tự khóa tài khoản của mình'.

## 9. Out of Scope (Phạm vi không thực hiện)
* Xóa vĩnh viễn tài khoản khỏi cơ sở dữ liệu (chỉ sử dụng soft-delete bằng cách cập nhật status sang locked).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.