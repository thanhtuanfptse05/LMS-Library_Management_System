# Feature Specification: Quản trị tài khoản (User Account Management)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cho phép Quản trị viên (Admin) quản lý vòng đời tài khoản người dùng bao gồm tạo mới đơn lẻ, import hàng loạt từ Excel, cập nhật thông tin, xuất danh sách ra Excel và khóa/mở khóa tài khoản.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản trị viên (Admin):** Có toàn quyền xem danh sách, tạo mới, cập nhật, khóa/mở khóa và import/export tài khoản.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-10 (Data Validation):** Dữ liệu định danh gồm Email và Mã số (MSSV, MSGV...) BẮT BUỘC là duy nhất trên toàn hệ thống.\n* **BR-11 (Transaction):** Quy trình nhập danh sách tài khoản khối lượng lớn BẮT BUỘC tuân thủ chiến lược 'Thành công toàn bộ hoặc Hủy bỏ toàn bộ'.\n* **BR-12 (Provisioning):** Tài khoản khi khởi tạo BẮT BUỘC dùng Email làm mật khẩu mặc định.\n* **BR-13 (Role Assignment):** File Excel dùng để Import khối lượng lớn KHÔNG ĐƯỢC chứa định nghĩa phân quyền. Quản trị viên BẮT BUỘC phải cấu hình Role chung từ giao diện trước khi thực thi tải tệp.\n* **BR-14 (Mandatory Audit):** Mọi thao tác làm thay đổi dữ liệu tài khoản (Thêm, Sửa, Khóa, Mở khóa, Import) từ Quản trị viên BẮT BUỘC phải được lưu vết vào hệ thống Audit Log.\n* **BR-54 (User List Pagination):** Tính năng xem danh sách tài khoản BẮT BUỘC phải phân trang và hỗ trợ bộ lọc (Filter) theo Role/Status để chống tràn bộ nhớ.\n* **BR-55 (Self-Lock Prevention):** Quản trị viên (Admin) KHÔNG ĐƯỢC PHÉP thực hiện thao tác Khóa (Lock), Xóa (Delete), hoặc thay đổi Role trên chính tài khoản mà họ đang đăng nhập.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-12 (Đối chiếu dữ liệu trùng):** WHEN Admin thực hiện tạo hoặc cập nhật tài khoản, THE system SHALL quét toàn bộ CSDL để đảm bảo Email và Mã định danh là duy nhất.\n* **FR-13 (Rà soát danh sách Import với 2 Phase Validation):** WHEN ImportUserServlet.doPost(action=upload) nhận file Excel, THE system SHALL thực hiện Phase 1 (Pre-Validation) trên RAM để đọc và kiểm tra định dạng tất cả các dòng dữ liệu. WHERE có lỗi, báo lỗi chi tiết.\n* **FR-14 (Báo cáo lỗi Import):** WHERE Phase 1 phát hiện bất kỳ dữ liệu không hợp lệ nào, THE system SHALL hủy bỏ toàn bộ tiến trình và hiển thị danh sách dòng bị lỗi.\n* **FR-15 (Lưu trữ hàng loạt với DB Transaction):** WHEN Admin xác nhận preview hợp lệ, THE system SHALL mở DB Transaction để ghi toàn bộ người dùng vào DB, mã hóa mật khẩu mặc định bằng BCrypt, cập nhật hạn thẻ mặc định 1 năm, và ghi Audit Log.\n* **FR-17 (Ghi nhận Audit Log Quản trị):** WHEN Admin tạo mới, chỉnh sửa hoặc khóa tài khoản, THE system SHALL tự động insert bản ghi vào bảng AuditLogs.\n* **FR-18 (Truy xuất danh sách và chi tiết):** WHEN Admin yêu cầu xem danh sách hoặc chi tiết, THE system SHALL JOIN các bảng User, MemberProfile, Student, Lecturer, Librarian để lấy đầy đủ thông tin.\n* **FR-19 (Khởi tạo tài khoản đơn lẻ):** WHEN Admin gửi form tạo tài khoản đơn lẻ hợp lệ, THE system SHALL insert vào bảng User, MemberProfile, và bảng vai trò tương ứng.\n* **FR-20 (Cập nhật thông tin tài khoản):** WHEN Admin gửi thông tin chỉnh sửa tài khoản, THE system SHALL cập nhật thông tin trong DB và ghi log.\n* **FR-21 (Khóa/Mở khóa tài khoản):** WHEN Admin thực hiện khóa hoặc mở khóa tài khoản, THE system SHALL cập nhật trạng thái User thành 'locked'/'active' và ghi nhận UserLockReason là 'adminban'.\n* **FR-45 (Bulk Excel Export):** WHEN Admin yêu cầu xuất dữ liệu, THE system SHALL tạo tệp Excel (.xlsx) gồm 10 cột thông tin chi tiết của người dùng theo bộ lọc và tải xuống máy.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Bảo mật: Mã hóa mật khẩu bằng BCrypt, chống SQL Injection trong truy vấn tìm kiếm.\n* Hiệu năng: Xuất file Excel 10,000 dòng trong dưới 3 giây.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng User\n* `userId` (INT, PK)\n* `email` (VARCHAR(255))\n* `passwordHash` (VARCHAR(255))\n* `status` (VARCHAR(50))\n* `role` (VARCHAR(50))\n\n### Bảng MemberProfile\n* `userId` (INT, PK, FK)\n\n### Bảng Student\n* `userId` (INT, PK, FK)\n* `studentCode` (VARCHAR(50))\n* `major` (VARCHAR(255))\n* `enrollmentYear` (INT)\n\n### Bảng Lecturer\n* `userId` (INT, PK, FK)\n* `lecturerCode` (VARCHAR(50))\n* `department` (VARCHAR(255))\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE Email hoặc Mã số sinh viên/giảng viên bị trùng lặp, THE system SHALL thông báo lỗi cụ thể cho Quản trị viên.\n* WHERE file Excel tải lên sai định dạng cột, THE system SHALL từ chối import và hiển thị cấu trúc mẫu đúng.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Tạo tài khoản đơn lẻ: Email và Mã số hợp lệ -> Tạo thành công, ghi Audit Log.\n- [ ] Khóa tài khoản sinh viên: Trạng thái sinh viên chuyển sang 'locked', không thể đăng nhập.\n- [ ] Import Excel không hợp lệ: Có 1 dòng sai định dạng -> Hủy toàn bộ đợt import, hiển thị thông báo lỗi dòng tương ứng.\n- [ ] Tự khóa bản thân: Admin cố tình khóa tài khoản chính mình -> Hệ thống chặn và hiển thị lỗi 'Không thể tự khóa tài khoản của mình'.

## 9. Out of Scope (Phạm vi không thực hiện)
* Xóa vĩnh viễn tài khoản khỏi cơ sở dữ liệu (chỉ sử dụng soft-delete bằng cách cập nhật status sang locked).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
