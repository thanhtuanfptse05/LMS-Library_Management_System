# Feature Specification: Quản lý hồ sơ cá nhân (Profile Management)
# Version: 1.3 | Chủ sở hữu: Tuan | Ngày cập nhật: 2026-07-26 (Chuẩn hóa UC-BR-FR registry)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp giao diện cho phép tất cả các loại người dùng (Student, Lecturer, Librarian, Library Manager, Admin) tự xem và cập nhật thông tin cá nhân của mình (họ tên, số điện thoại, giới tính, ngày sinh) và thực hiện đổi mật khẩu cá nhân để bảo vệ tài khoản.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Người dùng đã đăng nhập (User - All Roles):** Xem hồ sơ cá nhân, cập nhật thông tin liên hệ được phép, thay đổi mật khẩu.

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-04 (View Profile):** Actor: User | (Xem hồ sơ cá nhân): Người dùng trích xuất và hiển thị dữ liệu định danh cùng thông tin liên lạc của bản thân.
* **UC-05 (Update Profile):** Actor: User | (Cập nhật hồ sơ): Người dùng thay đổi các thông tin cá nhân được phép (SĐT, Ngày sinh...).
* **UC-06 (Change Password):** Actor: User | (Thay đổi mật khẩu): Người dùng tự thiết lập mật khẩu mới sau khi xác thực mật khẩu hiện tại thành công.

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F2 Profile Management. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-08 (Data Integrity):** Cập nhật hồ sơ cá nhân KHÔNG ĐƯỢC PHÉP thay đổi các trường định danh hệ thống (mã số, vai trò, trạng thái).
* **BR-09 (Security):** Mật khẩu mới BẮT BUỘC đáp ứng tiêu chuẩn bảo mật.
* **BR-15 (UPSERT Mechanism):** Tiến trình cập nhật hồ sơ cá nhân của người dùng BẮT BUỘC sử dụng cơ chế UPSERT (Cập nhật hoặc Chèn mới) để đảm bảo không đứt gãy dữ liệu đối với các tài khoản chưa có profile gốc.


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-09 (Hiển thị hồ sơ):** WHEN người dùng truy cập trang cá nhân, THE system SHALL thực hiện truy vấn gộp (Join) dữ liệu để hiển thị thông tin định danh và thông tin liên lạc tương ứng.
  * *Mapping:* UC-04
* **FR-10 (Cơ chế UPSERT hồ sơ):** WHEN người dùng lưu thay đổi hồ sơ, THE system SHALL kiểm tra; WHERE bản ghi MemberProfile chưa tồn tại, hệ thống SHALL thực thi lệnh INSERT thay vì UPDATE.
  * *Mapping:* UC-05 / BR-15
* **FR-11 (Bảo mật sau đổi pass):** WHEN thay đổi mật khẩu thành công, THE system SHALL ghi nhật ký Audit Log, đồng thời vô hiệu hóa session hiện tại và buộc người dùng đăng nhập lại.
  * *Mapping:* UC-06 / BR-09
* **FR-16 (Xác thực đầu vào mật khẩu):** WHEN người dùng yêu cầu thay đổi mật khẩu, THE system SHALL mã hóa BCrypt mật khẩu hiện tại và đối chiếu với CSDL. WHERE mật khẩu không khớp HOẶC mật khẩu mới vi phạm chính sách bảo mật, hệ thống SHALL từ chối yêu cầu và hiển thị lỗi tương ứng.
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
