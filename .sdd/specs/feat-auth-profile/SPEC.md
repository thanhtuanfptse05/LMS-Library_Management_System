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

### UC-01 — Xác thực (Authentication) & Đăng nhập/Đăng xuất
- **FR-AUTH-01:** Người dùng đăng nhập bằng `email` và `password`. Hệ thống mã hóa kiểm tra bằng BCrypt. Thành công sẽ lưu thông tin user vào `HttpSession` và chuyển hướng về Dashboard tương ứng.
- **FR-AUTH-02:** Đăng nhập sai quá 5 lần liên tiếp sẽ tự động chuyển `status = 'locked'`, gán `lock_reason = 'securitybreach'` và khóa tài khoản trong 30 phút (`locked_until = GETDATE() + 30 minutes`).
- **FR-AUTH-03:** Đăng xuất sẽ hủy bỏ (invalidate) session hiện tại của người dùng và chuyển hướng về trang chủ/login.
- **FR-AUTH-04 (Mã OTP):** Yêu cầu đặt lại mật khẩu sẽ tạo ra mã OTP gồm 6 chữ số ngẫu nhiên, lưu vào DB và gửi bất đồng bộ qua Email (ExecutorService). OTP có thời hạn 15 phút. Nhập sai OTP quá 5 lần sẽ khóa tài khoản trong 30 phút.

### UC-02 — Quản lý Hồ sơ (Profile Management)
- **FR-PROF-01:** Sau khi đăng nhập, Student và Lecturer có thể xem thông tin chi tiết tài khoản.
  - Student hiển thị thêm: `student_code`, `major`, `enrollment_year`.
  - Lecturer hiển thị thêm: `lecturer_code`, `department`.
- **FR-PROF-02:** Cập nhật Profile cần validate:
  - `full_name`: Chỉ chứa chữ cái và khoảng trắng, không rỗng.
  - `phone_number`: Đúng 10 chữ số.
  - `date_of_birth`: Phải từ 18 tuổi trở lên và không vượt quá ngày hiện tại.
  - `student_code`/`lecturer_code`: 10-15 ký tự chữ và số.
  - Kiểm tra trùng lặp số điện thoại (`phone_number`), mã số sinh viên/giảng viên. Nếu trùng sẽ báo lỗi.

---

## 4. Non-functional Requirements

- **Security:** Mọi endpoint bắt đầu với `/student/*`, `/librarian/*`, `/manager/*`, `/admin/*` phải được bảo vệ bởi `@WebFilter`.
- **Password Safety:** Tuyệt đối không lưu plaintext password, bắt buộc băm bằng BCrypt.
- **Performance:** Thời gian xử lý đăng nhập và cập nhật profile ≤1.5 giây. Việc gửi email OTP chạy trong Threadpool phụ, không gây treo UI.

---

## 5. Data (Các bảng liên quan)

Tham chiếu các bảng từ database:
- `[User]`
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
| Đăng nhập sai ≥ 5 lần | Đổi trạng thái User thành `'locked'`, cập nhật `locked_until`, trả về trang login với thông báo khóa tài khoản. |
| Người dùng chưa đăng nhập truy cập trang nội bộ | Chuyển hướng về trang `/login` và lưu lại URL yêu cầu ban đầu để quay lại sau khi đăng nhập. |
| Trùng mã code hoặc số điện thoại khi cập nhật profile | Hiển thị thông báo lỗi chi tiết trên form và giữ lại các dữ liệu đã nhập hợp lệ. |

---

## 7. Acceptance Criteria

- [ ] Đăng nhập thành công với tài khoản active -> Lưu session, redirect đúng dashboard theo vai trò.
- [ ] Nhập sai mật khẩu liên tiếp 5 lần -> Tài khoản bị khóa trong 30 phút, ghi nhận log.
- [ ] Gửi yêu cầu OTP thành công -> Nhận email trong vòng 60 giây, mã OTP có hiệu lực 15 phút.
- [ ] Đăng xuất -> Hủy session và không thể quay lại trang dashboard bằng nút Back của browser.
- [ ] Cập nhật hồ sơ với dữ liệu không hợp lệ -> Bị chặn ở cả phía Client (JS) và Backend (Java Servlet validation).

---

## 8. Out of Scope

- Xóa tài khoản vĩnh viễn (chỉ hỗ trợ khóa tài khoản).
- Đăng ký tài khoản tự do (Tài khoản sinh viên/giảng viên và nhân viên do Admin tạo sẵn).
