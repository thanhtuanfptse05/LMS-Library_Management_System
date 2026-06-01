# SPEC.md — Quản lý hồ sơ người dùng (feat-profileManagement)
# Version: 1.1.0 | Status: LOCKED | Risk Level: MEDIUM

## 1. Context & Goal
Cho phép người dùng đã xác thực truy vấn thông tin cá nhân, cập nhật dữ liệu liên lạc và thay đổi mật khẩu an toàn trực tiếp từ giao diện hệ thống.

## 2. Actors & Roles
* User (Mọi Role): Truy cập route `/profile` được bảo vệ bởi phiên làm việc (session).

## 3. Functional Requirements (EARS)

### FR04: Xem hồ sơ cá nhân
* WHEN User truy cập endpoint quản lý hồ sơ, THE system SHALL truy vấn và hiển thị dữ liệu gộp từ bảng `[User]` và bảng `MemberProfile` dựa trên `userId` hiện tại.

### FR05: Cập nhật thông tin cá nhân
* WHEN User gửi biểu mẫu cập nhật thông tin cá nhân (`fullName`, `phoneNumber`, `gender`, `dateOfBirth`), THE system SHALL cập nhật các trường dữ liệu tương ứng vào bảng `MemberProfile`.
* WHEN tiến trình cập nhật cơ sở dữ liệu hoàn tất, THE system SHALL trả về thông báo "Cập nhật thông tin cá nhân thành công".

### Thay đổi mật khẩu
* WHEN User gửi biểu mẫu đổi mật khẩu với "Mật khẩu hiện tại", "Mật khẩu mới", "Xác nhận mật khẩu mới", THE system SHALL mã hóa BCrypt mật khẩu hiện tại và đối chiếu với `passwordHash` trong bảng `[User]`.
* WHERE mật khẩu hiện tại khớp VÀ mật khẩu mới đáp ứng chính sách bảo mật, THE system SHALL mã hóa BCrypt mật khẩu mới và ghi đè vào bảng `[User]`.
* WHEN tiến trình cập nhật mật khẩu thành công, THE system SHALL trả về thông báo "Đổi mật khẩu thành công".
* WHEN tiến trình đổi mật khẩu hoàn tất thành công, THE system SHALL ghi log vào bảng `AuditLogs` với `actionType='CHANGE_PASSWORD'`.
* WHEN tiến trình đổi mật khẩu hoàn tất thành công, THE system SHALL vô hiệu hóa `HttpSession` hiện tại và yêu cầu người dùng đăng nhập lại.

## 4. Non-functional Requirements
* Data Integrity: Transaction cập nhật hồ sơ KHÔNG ĐƯỢC làm thay đổi hoặc xóa bỏ các trường dữ liệu không nằm trong biểu mẫu (ví dụ: `startDate`, `endDate`).
* Security: Không lưu trữ hoặc log plaintext password dưới bất kỳ hình thức nào.

## 5. Data Model (Tham chiếu)
* Table `[User]`: `userId` (PK), `passwordHash`.
* Table `MemberProfile`: `userId` (PK), `fullName`, `phoneNumber`, `gender`, `dateOfBirth`.

## 6. Error Handling (Unwanted)
* WHERE "Mật khẩu hiện tại" không chính xác, THE system SHALL từ chối cập nhật mật khẩu và hiển thị lỗi: "Mật khẩu hiện tại không chính xác".
* WHERE "Mật khẩu mới" vi phạm chính sách định dạng (không đủ 8 ký tự, thiếu chữ/số/ký tự đặc biệt), THE system SHALL từ chối cập nhật và hiển thị lỗi: "Mật khẩu mới không đáp ứng tiêu chuẩn bảo mật".
* WHERE "Xác nhận mật khẩu mới" không khớp với "Mật khẩu mới", THE system SHALL từ chối cập nhật và hiển thị lỗi: "Xác nhận mật khẩu không khớp".
* WHERE bản ghi `MemberProfile` của `userId` chưa tồn tại, THE system SHALL thực thi lệnh `INSERT` thay vì `UPDATE` (Cơ chế UPSERT — ưu tiên nhất quán dữ liệu).

## 7. Acceptance Criteria
* [ ] Hồ sơ hiển thị chính xác và đầy đủ dữ liệu hiện tại của user đang đăng nhập.
* [ ] Cập nhật thành công số điện thoại, họ tên và giới tính phản ánh ngay lập tức trên UI và Database.
* [ ] User mới chưa có bản ghi `MemberProfile` vẫn cập nhật thông tin thành công (cơ chế UPSERT hoạt động đúng).
* [ ] Nhập sai mật khẩu hiện tại bị chặn và báo lỗi rõ ràng.
* [ ] Đổi mật khẩu thành công, mật khẩu cũ bị vô hiệu hóa, người dùng có thể đăng nhập lại bằng mật khẩu mới.
* [ ] Sau khi đổi mật khẩu thành công, bảng `AuditLogs` ghi nhận bản ghi mới với `actionType='CHANGE_PASSWORD'`.
* [ ] Sau khi đổi mật khẩu thành công, session hiện tại bị hủy và người dùng bị chuyển hướng về trang đăng nhập.

## 8. Out of Scope (Ngoài phạm vi)
* Hệ thống SHALL NOT cho phép user tự thay đổi Email, `studentCode`, hoặc `staffCode` (Thẩm quyền của Admin).
* Hệ thống SHALL NOT yêu cầu hoặc gửi mã OTP khi đổi mật khẩu từ trang Profile.
* Hệ thống SHALL NOT xử lý cập nhật Avatar (Ảnh đại diện) trong phạm vi tài liệu này.
