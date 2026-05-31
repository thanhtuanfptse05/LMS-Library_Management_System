# PLAN.md — Feature: Authentication (feat-authentication)
# Version: 1.0.0 | Phase: Planning (Pha 2) | Status: DRAFT
# Author: Senior Java Web Developer (AI Agent)
# Tham chiếu: SPEC.md v1.0.0 | constitution.md v1.1.0
# Swimlane: Swimlane-UC-login.txt | Swimlane-UC-resetPassword.txt | Swimlane-authentication.txt

---

## 1. ARCHITECTURAL APPROACH

### 1.1 Tổng quan chiến lược tổ chức

Luồng Authentication được xây dựng theo mô hình **Servlet MVC thuần** (ARCH-01), không sử dụng bất
kỳ framework nào. Ba lớp chính được phân chia rõ ràng theo trách nhiệm:

```
[Browser / JSP View]
       │  HTTP Request
       ▼
[@WebFilter — AuthFilter]          ← Lớp bảo vệ tuyến đường
       │  Cho qua nếu public route
       ▼
[Servlet — Controller]             ← Tiếp nhận request, điều phối logic
       │  Gọi Service
       ▼
[Service Layer]                    ← Business logic (BCrypt, lock logic, password gen)
       │  Gọi DAO
       ▼
[DAO Layer — JDBC PreparedStatement] ← Truy vấn DB an toàn
       │
       ▼
[Microsoft SQL Server — Bảng [User]]
```

### 1.2 Tổ chức Filter (`@WebFilter`)

**`AuthFilter.java`** — Intercept mọi request vào hệ thống:
- **Public routes** (không cần session): `/login`, `/forgot-password`, `/css/*`, `/js/*`, `/images/*`
  → Cho qua ngay lập tức (`chain.doFilter()`).
- **Protected routes** (yêu cầu session hợp lệ):
  - `/admin/*` → Chỉ role `ADMIN`
  - `/librarian/*` → Chỉ role `LIBRARIAN`
  - `/manager/*` → Chỉ role `MANAGER`
  - `/student/*` → Chỉ role `STUDENT`
  → Nếu không có session hoặc sai role → `response.sendRedirect("/login")` hoặc 403 Forbidden.
- **Session check logic**: Đọc `HttpSession` attribute `userId` và `role`. Nếu null → coi là
  chưa đăng nhập (tương ứng `[Decision 1.2.2]` trong Swimlane-authentication.txt).

### 1.3 Tổ chức Servlet (Controller Layer)

**`LoginServlet.java`** (`/login`):
- `doGet()` → Forward tới `login.jsp` (hiển thị form).
- `doPost()` → Xử lý luồng theo `Swimlane-UC-login.txt`:
  1. Lấy `email`, `password` từ request.
  2. Gọi `UserDAO.findByEmail(email)` → `[Decision 1.2.2]`.
  3. Nếu không tìm thấy → nhảy thẳng tới bước 7 (tăng fail count + trả lỗi chung).
  4. Kiểm tra `user.getStatus()` → `[Decision 1.3.3]`.
  5. Gọi `AuthService.verifyPassword(rawPassword, passwordHash)` → `[Decision 1.4.4]`.
  6. Nếu đúng → tạo `HttpSession`, reset `failedLoginAttempts = 0`, redirect Dashboard.
  7. Nếu sai → gọi `AuthService.handleFailedLogin(userId)` → `[Action 1.5.5]` → `[Decision 1.6.6]`.

**`LogoutServlet.java`** (`/logout`):
- `doGet()` / `doPost()` → `session.invalidate()` → redirect `/login.jsp`.

**`ForgotPasswordServlet.java`** (`/forgot-password`):
- `doGet()` → Forward tới `forgot-password.jsp`.
- `doPost()` → Xử lý luồng theo `Swimlane-UC-resetPassword.txt`:
  1. Gọi `UserDAO.findByEmail(email)`.
  2. Nếu email không tồn tại → trả về thông báo thành công giả (chống User Enumeration — SPEC §6).
  3. Nếu tồn tại → gọi `AuthService.resetPassword(userId)` (tạo pass, hash, cập nhật DB).
  4. Đẩy tác vụ gửi email vào `ExecutorService` → **Async** (ARCH-03).

### 1.4 Tổ chức DAO Layer

**`UserDAO.java`** — Chỉ dùng `PreparedStatement` (SEC-03):
- `findByEmail(String email)` → `SELECT ... FROM [User] WHERE email = ?`
- `updateFailedAttempts(int userId, int attempts)` → `UPDATE [User] SET failedLoginAttempts = ? WHERE userId = ?`
- `lockAccount(int userId)` → `UPDATE [User] SET status = 'locked' WHERE userId = ?`
- `updatePassword(int userId, String newHash)` → `UPDATE [User] SET passwordHash = ? WHERE userId = ?`
- `resetFailedAttempts(int userId)` → `UPDATE [User] SET failedLoginAttempts = 0 WHERE userId = ?`

### 1.5 Tổ chức Service Layer

**`AuthService.java`** — Chứa toàn bộ business logic:
- `verifyPassword(String raw, String hash)` → Gọi `BCrypt.checkpw()` từ `jbcrypt-0.4.jar`.
- `handleFailedLogin(int userId, int currentAttempts)` → Tăng `failedLoginAttempts`. Nếu >= 5 → khóa tài khoản.
- `generatePassword()` → Tạo mật khẩu ngẫu nhiên 8 ký tự.
- `resetPassword(int userId)` → Hash mật khẩu mới bằng BCrypt, gọi `UserDAO.updatePassword()`.
- `redirectByRole(String role, HttpServletResponse response)` → Điều hướng Dashboard theo role.

### 1.6 Quản lý Session

Sau đăng nhập thành công, `HttpSession` lưu tối thiểu:
```
session.setAttribute("userId",   user.getUserId());   // int
session.setAttribute("role",     user.getRole());     // String: ADMIN/LIBRARIAN/MANAGER/STUDENT
session.setAttribute("email",    user.getEmail());    // String
```
Session timeout mặc định: **30 phút** (cấu hình trong `web.xml`).

---

## 2. COMPONENTS

### 2.1 Files Java sẽ TẠO MỚI (`src/java/`)

| File | Package | Mô tả |
|------|---------|-------|
| `LoginServlet.java` | `controller` | Xử lý đăng nhập GET/POST |
| `LogoutServlet.java` | `controller` | Vô hiệu hóa session, redirect login |
| `ForgotPasswordServlet.java` | `controller` | Xử lý quên mật khẩu GET/POST |
| `AuthFilter.java` | `filter` | Bảo vệ toàn bộ route, kiểm tra session + role |
| `AuthService.java` | `service` | Business logic: BCrypt verify, lock logic, password reset |
| `User.java` | `model` | Entity bean tương ứng bảng `[User]` |
| `UserDAO.java` | `dao` | JDBC DAO cho bảng `[User]` |
| `DatabaseConnection.java` | `util` | Singleton/Factory cấp `Connection` từ JDBC |
| `EmailService.java` | `service` | Gửi email qua SendGrid/SMTP (async) |

### 2.2 Files JSP sẽ TẠO MỚI (`web/`)

| File | Mô tả |
|------|-------|
| `login.jsp` | Form đăng nhập (email + password) |
| `forgot-password.jsp` | Form nhập email để reset mật khẩu |
| `error-403.jsp` | Trang báo lỗi truy cập bị từ chối (403 Forbidden) |

### 2.3 Files cấu hình sẽ CHỈNH SỬA

| File | Thay đổi |
|------|---------|
| `web/WEB-INF/web.xml` | Thêm `<session-config>` timeout 30 phút; đăng ký Servlet URL mappings |
| `build.xml` / `nbproject/` | Đảm bảo `allowedlib/jbcrypt-0.4.jar` được thêm vào classpath |

### 2.4 Files KHÔNG thay đổi trong sprint này

- Toàn bộ bảng CSDL (AGENTS.md: cấm thay đổi schema chưa được chốt).
- Các trang Dashboard (thuộc scope sprint sau).

---

## 3. RISKS & QUESTIONS

### ⚠️ RỦI RO 1 — XUNG ĐỘT KIẾN TRÚC: JWT vs HttpSession (MỨC ĐỘ: CAO)

**Phát hiện mâu thuẫn nghiêm trọng giữa Swimlane và SPEC:**

> `[Action 1.8.8]` trong `Swimlane-UC-login.txt`:
> *"Tạo JWT Token và Lưu Session vào DB"*

Điều này **trực tiếp mâu thuẫn** với:
- **SPEC.md §3** (Đăng nhập): *"Tạo `HttpSession` chứa thông tin cơ bản: userId, role, email"*
- **constitution.md — SEC-02**: *"xác thực bằng `HttpSession` kết hợp `@WebFilter`"*
- **AGENTS.md Tech Stack**: *"Auth: Session-based (`HttpSession`)"*

**Tác động nếu chọn sai:**
- JWT yêu cầu thêm bảng lưu token trong DB, logic refresh token, middleware kiểm tra chữ ký → **Scope tăng đáng kể**.
- HttpSession không cần bảng DB bổ sung, phù hợp với kiến trúc Monolith Servlet hiện tại.

**❓ CÂU HỎI 1 cho Human:**
> Swimlane đề cập **"Tạo JWT Token và Lưu Session vào DB"** — đây có phải là yêu cầu thực sự,
> hay là lỗi trong Swimlane? Kế hoạch hiện tại của tôi sẽ dùng **`HttpSession` thuần**
> (đúng với SPEC + Constitution). Bạn có đồng ý không?

---

### ⚠️ RỦI RO 2 — KHÓA TÀI KHOẢN: Tự động mở khóa sau 30 phút (MỨC ĐỘ: TRUNG BÌNH)

**Phân tích từ Swimlane:**

> `[Action 1.7.7]`: *"Khóa tài khoản 30p sau đó reset số lần đăng nhập"*

**Vấn đề kỹ thuật:**
Không có cơ chế nào trong Java Servlet thuần tự động mở khóa tài khoản sau 30 phút
mà không cần:
- (A) **Cột `lockedUntil` (DATETIME) trong bảng `[User]`** — Kiểm tra mỗi lần login.
- (B) **Scheduled Job** (`Timer` / `ScheduledExecutorService`) chạy ngầm để update DB.

SPEC.md §6 chỉ nói *"thông báo tài khoản bị khóa 30 phút"* nhưng không chỉ rõ cơ chế mở khóa.

**❓ CÂU HỎI 2 cho Human:**
> Cơ chế mở khóa tài khoản sau 30 phút sẽ hoạt động như thế nào?
> - **Phương án A (Khuyến nghị — không đổi schema):** Thêm cột `lockedUntil DATETIME` vào bảng
>   `[User]`. Khi login, nếu `lockedUntil < NOW()` thì tự động mở khóa. Đây là cách đơn giản nhất.
> - **Phương án B (Phức tạp hơn):** Dùng `ScheduledExecutorService` chạy background job cập nhật DB.
>
> Bạn chọn phương án nào, hoặc bạn muốn lock vĩnh viễn cho đến khi Admin mở thủ công?

---

### ⚠️ RỦI RO 3 — RESET PASSWORD: Gửi mật khẩu plaintext qua email (MỨC ĐỘ: TRUNG BÌNH)

**Phân tích từ Swimlane-UC-resetPassword.txt + SPEC §3:**

SPEC yêu cầu: *"Gửi email chứa mật khẩu mới cho người dùng"*.

Việc gửi mật khẩu plaintext qua email là **thực hành bảo mật yếu** (anti-pattern), tuy nhiên đây
là yêu cầu đã được đặc tả rõ ràng trong SPEC và nằm trong scope sprint này. Phương án thay thế
(gửi link reset có token tạm thời) đã bị liệt vào "Out of Scope" (SPEC §8 không đề cập nhưng
tính năng OTP/2FA bị loại trừ).

**Quyết định:** Tuân thủ SPEC — thực hiện gửi mật khẩu mới qua email, đảm bảo:
- Mật khẩu được hash bằng BCrypt trước khi lưu DB (SEC-01).
- Gửi email **async** qua `ExecutorService` (ARCH-03).
- Không log plaintext password (SPEC §4 Non-functional).

---

### ⚠️ RỦI RO 4 — CHỐNG USER ENUMERATION: Nhất quán giữa 2 luồng (MỨC ĐỘ: THẤP)

**Phân tích từ Swimlane UC-login:**

`[Decision 1.2.2]` tách nhánh "email không tồn tại" thành một path riêng (→ `[Action 1.8.9]`).
Nhưng nhánh này phải hiển thị **cùng một thông báo lỗi** với trường hợp sai mật khẩu:
*"Tài khoản hoặc mật khẩu không chính xác"* (SPEC §6 — Chống User Enumeration).

Lưu ý: Bất kể email tìm thấy hay không, **thời gian phản hồi** phải tương đương để tránh
timing attack (nhánh "không tìm thấy" trả về nhanh hơn → attacker có thể phát hiện email hợp lệ).
Cần thêm `Thread.sleep()` giả hoặc gọi BCrypt dummy verify để cân bằng thời gian.

---

## 4. DEPENDENCY MAP

```
AuthFilter
  └── (đọc) HttpSession → [userId, role]

LoginServlet
  ├── UserDAO.findByEmail()
  ├── AuthService.verifyPassword()        ← BCrypt (jbcrypt-0.4.jar)
  ├── AuthService.handleFailedLogin()
  │     └── UserDAO.updateFailedAttempts()
  │     └── UserDAO.lockAccount()
  └── UserDAO.resetFailedAttempts()

ForgotPasswordServlet
  ├── UserDAO.findByEmail()
  ├── AuthService.resetPassword()
  │     ├── AuthService.generatePassword()
  │     ├── BCrypt.hashpw()               ← BCrypt (jbcrypt-0.4.jar)
  │     └── UserDAO.updatePassword()
  └── EmailService.sendPasswordResetEmail()  ← ExecutorService (Async)

LogoutServlet
  └── HttpSession.invalidate()
```

---

## 5. SESSION TIMEOUT & web.xml

```xml
<!-- web.xml — Cấu hình session timeout 30 phút (SPEC §4) -->
<session-config>
    <session-timeout>30</session-timeout>
</session-config>
```

---

## 6. CHECKLIST TRƯỚC KHI IMPLEMENT

- [ ] Human xác nhận: **HttpSession** hay JWT (Câu hỏi 1)?
- [ ] Human xác nhận: Cơ chế **tự động mở khóa** tài khoản (Câu hỏi 2)?
- [ ] `jbcrypt-0.4.jar` đã có trong `allowedlib/` — đảm bảo classpath được cập nhật.
- [ ] Bảng `[User]` có đủ cột cần thiết: `email`, `passwordHash`, `status`, `failedLoginAttempts`.
- [ ] Cấu hình SMTP/SendGrid có trong `.env` (không hardcode — SEC-01).
