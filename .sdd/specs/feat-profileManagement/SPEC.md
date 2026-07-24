# Feature Specification: Quản lý hồ sơ cá nhân (Profile Management)
# Version: 1.2 | Chủ sở hữu: @tuan | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp giao diện cho phép tất cả các loại người dùng (Student, Lecturer, Librarian, Library Manager, Admin) tự xem và cập nhật thông tin cá nhân của mình (họ tên, số điện thoại, giới tính, ngày sinh) và thực hiện đổi mật khẩu cá nhân để bảo vệ tài khoản.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Người dùng đã đăng nhập (User - All Roles):** Xem hồ sơ cá nhân, cập nhật thông tin liên hệ được phép, thay đổi mật khẩu.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-04 (View Profile):** Actor: User | Xem dữ liệu cá nhân, thông tin liên lạc và thông tin chuyên môn/chức vụ theo vai trò.
* **UC-05 (Update Profile):** Actor: User | Cập nhật các thông tin cá nhân được phép (Họ tên, SĐT, Giới tính, Ngày sinh).
* **UC-06 (Change Password):** Actor: User | Tự đổi mật khẩu sau khi xác nhận thành công mật khẩu hiện tại.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-08 (Data Integrity):** Cập nhật hồ sơ cá nhân KHÔNG ĐƯỢC PHÉP thay đổi các trường định danh hệ thống (mã sinh viên/giảng viên, email, vai trò, trạng thái tài khoản).
* **BR-09 (Password Policy):** Mật khẩu mới bắt buộc từ 8 ký tự trở lên, chứa cả chữ cái và chữ số.
* **BR-15 (UPSERT Mechanism):** Tiến trình cập nhật thông tin profile BẮT BUỘC dùng cơ chế UPSERT (INSERT nếu chưa có bản ghi `MemberProfile`, UPDATE nếu đã tồn tại) để đảm bảo không đứt gãy dữ liệu đối với các tài khoản mới khởi tạo.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-09 (Xem hồ sơ theo vai trò):** WHEN người dùng truy cập trang Profile tương ứng (`/student/profile`, `/lecturer/profile`, `/librarian/profile`, `/manager/profile`, `/admin/profile`), THE system SHALL truy vấn gộp (JOIN) dữ liệu từ `"User"`, `MemberProfile` và bảng vai trò chuyên biệt (`Student`, `Lecturer`, `Librarian`, `LibraryManager`, `Admin`) để hiển thị thông tin đầy đủ.
  * *Mapping:* UC-04
* **FR-10 (Cơ chế UPSERT hồ sơ):** WHEN người dùng gửi yêu cầu cập nhật thông tin cá nhân, THE system SHALL kiểm tra sự tồn tại của `userId` trong `MemberProfile`. WHERE chưa có bản ghi, hệ thống thực thi `INSERT`. WHERE đã có bản ghi, hệ thống thực thi `UPDATE` các trường `fullName`, `phoneNumber`, `gender`, `dateOfBirth`.
  * *Mapping:* UC-05 / BR-15
* **FR-11 (Bảo mật sau Đổi mật khẩu):** WHEN người dùng thay đổi mật khẩu thành công, THE system SHALL: (1) Mã hóa BCrypt mật khẩu mới và lưu vào `"User"`, (2) Ghi nhật ký `AuditLogs` với action `CHANGE_PASSWORD`, (3) Hủy phiên làm việc `HttpSession.invalidate()` và buộc người dùng đăng nhập lại bằng mật khẩu mới.
  * *Mapping:* UC-06 / BR-09
* **FR-16 (Xác thực mật khẩu cũ):** WHEN người dùng gửi yêu cầu đổi mật khẩu, THE system SHALL đối chiếu mật khẩu cũ với `passwordHash` trong DB. WHERE mật khẩu cũ không đúng HOẶC mật khẩu mới không đáp ứng policy, hệ thống từ chối cập nhật và trả về thông báo lỗi chi tiết.
  * *Mapping:* UC-06 / BR-09

## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Mật khẩu mới được hash BCrypt trước khi ghi đè vào DB. Thông tin nhạy cảm được validate ở cả Server-side và Client-side.
* **Độ tương thích:** Responsive 100% trên thiết bị di động và máy tính.
* **Giao diện:** 100% Tiếng Việt với phản hồi toast notification khi cập nhật thành công.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `MemberProfile`
* `userId` (INT, PK, FK REFERENCES `"User"`)
* `fullName` (VARCHAR(255), NOT NULL)
* `phoneNumber` (VARCHAR(20), NOT NULL)
* `gender` (VARCHAR(10), NOT NULL)
* `dateOfBirth` (DATE, NOT NULL)

### Bảng Role Specs (`Student`, `Lecturer`, `Librarian`, `LibraryManager`, `Admin`)
* `userId` (INT, PK, FK REFERENCES `"User"`)
* `studentCode` / `lecturerCode` / `staffCode` (VARCHAR(50), UNIQUE)
* `major` / `department` (VARCHAR(100))

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** nhập mật khẩu cũ không chính xác, **THE system SHALL** giữ nguyên dữ liệu và hiển thị lỗi "Mật khẩu hiện tại không đúng".
* **WHERE** số điện thoại hoặc định dạng ngày sinh sai, **THE system SHALL** từ chối lưu và báo lỗi định dạng dữ liệu đầu vào.

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-PROF-01] Người dùng xem được đầy đủ thông tin cá nhân và thông tin vai trò của mình.
- [ ] [TC-PROF-02] Cập nhật thành công họ tên, SĐT, ngày sinh và thấy thông tin được phản hồi ngay lập tức.
- [ ] [TC-PROF-03] Tài khoản mới chưa có `MemberProfile` vẫn cập nhật thành công nhờ cơ chế UPSERT.
- [ ] [TC-PROF-04] Đổi mật khẩu thành công buộc session bị hủy và đăng nhập lại bằng mật khẩu mới thành công.
- [ ] [TC-PROF-05] Thay đổi mật khẩu tạo 1 bản ghi trong `AuditLogs`.

## 8. Out of Scope (Phạm vi không thực hiện)
* Người dùng tự thay đổi Email hoặc Vai trò (Role) từ giao diện cá nhân.
* Tải lên ảnh đại diện cá nhân (Avatar upload).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện toàn bộ Servlets profile cho 5 nhóm đối tượng.