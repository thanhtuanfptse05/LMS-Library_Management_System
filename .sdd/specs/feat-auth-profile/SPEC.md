# Feature Specification: feat-auth-profile (Xác thực, Phân quyền & Quản lý hồ sơ)
# Version: 1.0.0 | Owner: Member 1 | Date: 2026-05-29

---

## 1. Context & Goal

**Mục tiêu:** Xây dựng hệ thống đăng nhập, đăng xuất bảo mật, cơ chế đặt lại mật khẩu bằng mã OTP (gửi qua email bất đồng bộ) và quản lý thông tin tài khoản chi tiết tương ứng với 5 phân hệ người dùng (Student, Lecturer, Librarian, Library Manager, Admin) cùng cơ chế lọc phân quyền RBAC sử dụng `@WebFilter` và lưu session bằng `HttpSession`.

---

## 2. Actors & Roles

Tất cả các tác nhân (Actors) trong hệ thống đều chịu ảnh hưởng trực tiếp từ tính năng này:
- **Guest (Chưa đăng nhập):** Chỉ được phép xem danh mục sách công khai, tìm kiếm sách. Truy cập các trang khác sẽ bị chuyển hướng đến trang Đăng nhập.
- **Student / Lecturer:** Xem và chỉnh sửa thông tin cá nhân (Profile riêng biệt).
- **Librarian / Library Manager / Admin:** Đăng nhập và được điều hướng về đúng Dashboard tương ứng.

---

## 3. Functional Requirements

### UC-01 — Xác thực (Authentication)
- **FR01 (Đăng nhập hệ thống):** Hệ thống cho phép người dùng xác thực bằng Email và Mật khẩu. Khi thành công sẽ lưu thông tin user vào `HttpSession` và chuyển hướng về Dashboard tương ứng (Tuân thủ BR03). **Đặc biệt, nếu mật khẩu mặc định trùng với tên đăng nhập (lần đăng nhập đầu tiên), hệ thống BẮT BUỘC chuyển hướng người dùng đến trang đổi mật khẩu và chặn mọi hoạt động khác cho đến khi mật khẩu mới được thiết lập (Tuân thủ BR30).**
- **FR02 (Xử lý đăng nhập sai - Hệ thống tự động):** Nếu phát hiện đăng nhập sai (Mật khẩu hoặc OTP) quá số lần quy định (5 lần liên tiếp), hệ thống tự động khóa tài khoản tạm thời (`User.status = 'locked'`, `lock_reason = 'securitybreach'`, khóa trong 30 phút theo BR01).
- **FR03 (Đăng xuất):** Hệ thống xóa phiên làm việc hiện tại, đưa người dùng về trạng thái chưa xác thực (invalidate session).
- **Lưu ý (Khôi phục mật khẩu qua OTP):** Yêu cầu reset mật khẩu sẽ tạo mã OTP 6 chữ số gửi bất đồng bộ qua Email (FR31). OTP hết hạn sau 15 phút.

### UC-02 — Quản lý Hồ sơ (Profile Management)
- **FR04 (Xem hồ sơ cá nhân):** Hệ thống hiển thị thông tin người dùng. Giao diện tự động thay đổi các trường dữ liệu tùy thuộc người dùng là Sinh viên hay Giảng viên:
  - Sinh viên: hiển thị thêm `student_code`, `major`, `enrollment_year`.
  - Giảng viên: hiển thị thêm `lecturer_code`, `department`.
- **FR05 (Cập nhật hồ sơ):** Hệ thống cho phép người dùng chỉnh sửa các thông tin cá nhân được phép thay đổi (ví dụ: số điện thoại). Cần validate:
  - `full_name`: Chỉ chứa chữ cái và khoảng trắng.
  - `phone_number`: Đúng 10 chữ số.
  - `date_of_birth`: Phải từ 18 tuổi trở lên.
  - Kiểm tra trùng lặp số điện thoại (`phone_number`), mã số sinh viên/giảng viên (nếu trùng sẽ báo lỗi).
- **Audit Logging PII mask (SEC-04):** Khi cập nhật profile, mọi dữ liệu lưu vào `oldValues` và `newValues` trong `AuditLogs` phải được ẩn danh/masking đối với Số điện thoại và Email.

---

## 4. Non-functional Requirements

- **Security (BR03, BR30):** Mọi endpoint bắt đầu với `/student/*`, `/librarian/*`, `/manager/*`, `/admin/*` phải được bảo vệ bởi `@WebFilter` để kiểm tra phân quyền và bắt buộc đổi mật khẩu lần đầu.
- **Password Safety:** Tuyệt đối không lưu plaintext password, bắt buộc băm bằng BCrypt.
- **Performance:** Thời gian xử lý đăng nhập và cập nhật profile ≤1.5 giây. Việc gửi email OTP chạy trong Threadpool phụ (FR31), không gây treo UI.

---

## 5. Data (Các bảng liên quan)

Tham chiếu các bảng từ database:
- `[User]` (Tuân thủ BR02 cho thuộc tính status, BR30 cho mật khẩu mặc định, BR31 cho lock safeguards)
- `MemberProfile`
- `Student`
- `Lecturer`
- `Librarian`
- `LibraryManager`
- `Admin`

---

## 6. Error Handling

| Điều kiện lỗi | Hành vi hệ thống |
|---|---|
| Đăng nhập sai ≥ 5 lần (BR01) | Đổi trạng thái User thành `'locked'`, cập nhật `locked_until`, trả về trang login với thông báo khóa tài khoản. |
| Người dùng chưa đăng nhập truy cập trang nội bộ (BR03) | Chuyển hướng về trang `/login` và lưu lại URL yêu cầu ban đầu để quay lại sau khi đăng nhập. |
| Trùng mã code hoặc số điện thoại khi cập nhật profile | Hiển thị thông báo lỗi chi tiết trên form và giữ lại các dữ liệu đã nhập hợp lệ. |

---

## 7. Acceptance Criteria

- [ ] Đăng nhập thành công với tài khoản active -> Lưu session, redirect đúng dashboard theo vai trò.
- [ ] Tài khoản đăng nhập lần đầu với default password -> Bắt buộc đổi mật khẩu thành công mới được tiếp tục (BR30).
- [ ] Nhập sai mật khẩu/OTP liên tiếp 5 lần -> Tài khoản bị khóa trong 30 phút (BR01), ghi nhận log.
- [ ] Gửi yêu cầu OTP thành công -> Nhận email trong vòng 60 giây (FR31), mã OTP có hiệu lực 15 phút.
- [ ] Đăng xuất -> Hủy session và không thể quay lại trang dashboard bằng nút Back của browser (FR03).
- [ ] Cập nhật hồ sơ với dữ liệu không hợp lệ -> Bị chặn ở cả phía Client (JS) và Backend (Java Servlet validation).
- [ ] Cập nhật hồ sơ thành công -> Audit log lưu trữ thông tin email và số điện thoại đã được mask (SEC-04).

---

## 8. Out of Scope

- Xóa tài khoản vĩnh viễn (BR02: chỉ hỗ trợ khóa tài khoản).
- Đăng ký tài khoản tự do (Tài khoản sinh viên/giảng viên và nhân viên do Admin tạo sẵn).
