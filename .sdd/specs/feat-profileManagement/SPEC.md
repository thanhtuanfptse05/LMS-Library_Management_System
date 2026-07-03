# Feature Specification: Quản lý hồ sơ cá nhân (Profile Management)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp giao diện cho phép người dùng tự xem và cập nhật thông tin cá nhân của mình (họ tên, số điện thoại, giới tính, ngày sinh) và thực hiện đổi mật khẩu cá nhân để bảo vệ tài khoản.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Người dùng đã đăng nhập (User):** Xem và cập nhật thông tin cá nhân của mình, đổi mật khẩu.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-08 (Data Integrity):** Cập nhật hồ sơ cá nhân KHÔNG ĐƯỢC PHÉP thay đổi các trường định danh hệ thống (mã số, vai trò, trạng thái).\n* **BR-09 (Security):** Mật khẩu mới BẮT BUỘC đáp ứng tiêu chuẩn bảo mật.\n* **BR-15 (UPSERT Mechanism):** Tiến trình cập nhật hồ sơ cá nhân của người dùng BẮT BUỘC sử dụng cơ chế UPSERT (Cập nhật hoặc Chèn mới) để đảm bảo không đứt gãy dữ liệu đối với các tài khoản chưa có profile gốc.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-09 (Hiển thị hồ sơ):** WHEN người dùng truy cập trang cá nhân, THE system SHALL thực hiện truy vấn JOIN dữ liệu từ bảng User, MemberProfile và các bảng vai trò để hiển thị chi tiết.\n* **FR-10 (Cơ chế UPSERT hồ sơ):** WHEN người dùng lưu thay đổi hồ sơ, THE system SHALL kiểm tra; WHERE bản ghi MemberProfile chưa tồn tại, hệ thống SHALL thực thi lệnh INSERT thay vì UPDATE.\n* **FR-11 (Bảo mật sau đổi pass):** WHEN thay đổi mật khẩu thành công, THE system SHALL ghi nhật ký Audit Log, đồng thời vô hiệu hóa session hiện tại và buộc người dùng đăng nhập lại.\n* **FR-16 (Xác thực đầu vào mật khẩu):** WHEN người dùng yêu cầu thay đổi mật khẩu, THE system SHALL mã hóa BCrypt mật khẩu hiện tại và đối chiếu với CSDL. WHERE mật khẩu không khớp hoặc mật khẩu mới vi phạm chính sách bảo mật, hệ thống SHALL từ chối yêu cầu và hiển thị lỗi.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Bảo mật: Mật khẩu mới phải được hash BCrypt trước khi ghi đè vào CSDL.\n* Độ khả dụng: Giao diện trực quan, hiển thị thông báo lỗi/thành công rõ ràng bằng tiếng Việt.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng MemberProfile\n* `userId` (INT, PK, FK REFERENCES "User")\n* `fullName` (VARCHAR(255), NOT NULL)\n* `phoneNumber` (VARCHAR(20), NOT NULL)\n* `gender` (VARCHAR(10), NOT NULL)\n* `dateOfBirth` (DATE, NOT NULL)\n* `startDate` (DATE, NULL)\n* `endDate` (DATE, NULL)\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE số điện thoại nhập không đúng định dạng hoặc tuổi dưới 15, THE system SHALL hiển thị lỗi thông báo trên form.\n* WHERE mật khẩu cũ nhập sai, THE system SHALL hiển thị thông báo lỗi 'Mật khẩu cũ không chính xác' và giữ nguyên form.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Xem thông tin hồ sơ: Hiển thị đúng họ tên, SĐT, giới tính, ngày sinh và mã định danh theo vai trò.\n- [ ] Cập nhật thông tin cá nhân: Lưu thành công thông tin mới và cập nhật tức thì trên giao diện.\n- [ ] Đổi mật khẩu thành công: Đăng xuất tài khoản ngay lập tức, chuyển hướng về login và dùng mật khẩu mới đăng nhập thành công.

## 9. Out of Scope (Phạm vi không thực hiện)
* Thay đổi ảnh đại diện (avatar) cá nhân.\n* Thay đổi email cá nhân (email dùng làm ID duy nhất và chỉ có Admin mới sửa được).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
