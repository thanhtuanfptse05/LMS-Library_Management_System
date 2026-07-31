# PLAN.md — Execution Plan: Authentication (feat-authentication)
# Version: 2.0.0 | Phase: Planning | Status: DRAFT
# Base: ActivityDiagramF1.txt
# Tham chiếu: SPEC.md v2.0.0 | constitution.md v1.1.0

---

## 1. ARCHITECTURAL APPROACH

### 1.1 Layered Servlet Architecture

```
[Browser / JSP View]
       │  HTTP Request
       ▼
[@WebFilter — AuthFilter]          ← Lớp bảo vệ tuyến đường (Kiểm tra HttpSession)
       │  Cho qua nếu public route
       ▼
[Servlet — Controller]             ← Tiếp nhận request, điều phối logic
       │  Gọi Service
       ▼
[Service Layer — AuthService]      ← Business logic (BCrypt, Lock, Password Gen)
       │  Gọi DAO                    [Node 7.10, 10.17, 11.18]
       ▼
[DAO Layer — JDBC PreparedStatement] ← Truy vấn DB an toàn
       │
       ▼
[Microsoft SQL Server — Bảng [User]]
```

- **Session Management**: Dùng `HttpSession` thuần, tuân thủ C-02. KHÔNG dùng JWT.
- **Security**: Tích hợp `jbcrypt-0.4.jar` tại tầng Service (tuyệt đối không dùng MessageDigest).

### 1.2 Tổ chức Filter (`@WebFilter`)

**`AuthFilter.java`** — Intercept mọi request vào hệ thống:
- **Public routes** (không cần session): `/login`, `/forgot-password`, `/css/*`, `/js/*`, `/images/*`
  → Cho qua ngay lập tức (`chain.doFilter()`).
- **Protected routes** (yêu cầu session hợp lệ):
  - `/admin/*` → Chỉ role `ADMIN`
  - `/librarian/*` → Chỉ role `LIBRARIAN`
  - `/admin/*` → Chỉ role `ADMIN`
  - `/student/*` → Chỉ role `STUDENT`
  → Nếu không có session → `response.sendRedirect("/login")`; sai role → `response.sendError(403)`.
- **Session check logic**: Đọc `HttpSession` attribute `userId` và `role`. Nếu null → coi là chưa đăng nhập.
- **Đã login truy cập `/login`**: redirect về Dashboard đúng role (chống load lại trang login).

### 1.3 Tổ chức Servlet (Controller Layer)

**`LoginServlet.java`** (`/login`) — Xử lý GET/POST [Node 4.4]:
- `doGet()` → Forward tới `login.jsp`.
- `doPost()` → Điều hướng logic theo ActivityDiagramF1.txt:
  1. Gọi `UserDAO.findByEmail(email)` → [Node 5.6].
  2. Nếu không tìm thấy → Return Auth Error chung → [Node 16.26] (chống User Enumeration).
  3. Kiểm tra `user.getStatus()` → [Node 7.10].
  4. Nếu `status='locked'` và `lockedUntil > NOW` → Return Lock Time Error → [Node 10.16].
  5. Nếu `lockedUntil <= NOW` → Auto-unlock (update status='active', lockReason=null, attempts=0) → [Node 10.17].
  6. Gọi `AuthService.verifyPassword()` → [Node 11.18].
  7. Nếu đúng → Tạo `HttpSession`, reset `failedLoginAttempts=0`, redirect Dashboard → [Node 13.21, 14.23].
  8. Nếu sai → `failedLoginAttempts += 1` → [Node 13.20]. Nếu >= 5 → Lock account → [Node 15.24].
  > ⚠️ Lưu ý: Nếu email không tồn tại, PHẢI gọi BCrypt dummy verify để đồng đều thời gian phản hồi (chống Timing Attack).

**`LogoutServlet.java`** (`/logout`):
- `doGet()` / `doPost()` → `session.invalidate()` → redirect `/login` [Node 16.27, 17.28].

**`ForgotPasswordServlet.java`** (`/forgot-password`) — Xử lý [Node 4.5]:
- `doGet()` → Forward tới `forgot-password.jsp`.
- `doPost()` → Điều hướng theo ActivityDiagramF1.txt:
  1. Gọi `UserDAO.findByEmail(email)` → [Node 5.7].
  2. Nếu email không tồn tại → Return Fake Success: "Nếu email hợp lệ, hệ thống đã gửi mật khẩu mới" → [Node 7.11].
  3. Nếu tồn tại → Gọi `AuthService.resetPassword()` (gen 8 ký tự, BCrypt hash, update DB) → [Node 7.12].
  4. Submit `EmailService.sendAsync()` vào ExecutorService → [Node 8.14].

### 1.4 Tổ chức DAO Layer

**`UserDAO.java`** — Chỉ dùng `PreparedStatement` (SEC-03):
- `findByEmail(String email)` → `SELECT ... FROM [User] WHERE email = ?`
- `updateFailedAttempts(int userId, int attempts)` → `UPDATE [User] SET failedLoginAttempts = ? WHERE userId = ?`
- `lockAccount(int userId)` → `UPDATE [User] SET status = 'locked', lockedUntil = DATEADD(minute,30,GETDATE()), lockReason = 'securitybreach', failedLoginAttempts = 0 WHERE userId = ?`
- `unlockAccount(int userId)` → `UPDATE [User] SET status = 'active', lockedUntil = NULL, lockReason = NULL, failedLoginAttempts = 0 WHERE userId = ?` [Node 10.17]
- `updatePassword(int userId, String newHash)` → `UPDATE [User] SET passwordHash = ? WHERE userId = ?`
- `resetFailedAttempts(int userId)` → `UPDATE [User] SET failedLoginAttempts = 0 WHERE userId = ?`

### 1.5 Tổ chức Service Layer

**`AuthService.java`** — Chứa toàn bộ Business Rules [Node 7.10, 10.17, 11.18]:
- `verifyPassword(String raw, String hash)` → Gọi `BCrypt.checkpw()` từ `jbcrypt-0.4.jar`.
- `handleFailedLogin(int userId, int currentAttempts)` → Tăng `failedLoginAttempts`. Nếu >= 5 → gọi `UserDAO.lockAccount()`.
- `isAccountLocked(User user)` → Kiểm tra `user.getLockedUntil() != null && lockedUntil.isAfter(LocalDateTime.now())`.
- `generatePassword()` → Tạo chuỗi ngẫu nhiên 8 ký tự (chữ + số).
- `resetPassword(int userId)` → Gọi `generatePassword()`, BCrypt hash, gọi `UserDAO.updatePassword()`.
- `getRedirectByRole(String role)` → Trả về URL string tương ứng role.
- KHÔNG có SQL trực tiếp trong Service layer.

### 1.6 Quản lý Session

Sau đăng nhập thành công, `HttpSession` lưu tối thiểu:
```
session.setAttribute("userId",   user.getUserId());   // int
session.setAttribute("role",     user.getRole());     // String: ADMIN/LIBRARIAN/ADMIN/STUDENT
session.setAttribute("email",    user.getEmail());    // String
```
Session timeout mặc định: **30 phút** (cấu hình trong `web.xml`).

---

## 2. COMPONENTS

| Component | Nhiệm vụ |
| --- | --- |
| `AuthFilter` | Kiểm tra HttpSession. Chặn truy cập theo Role. |
| `LoginServlet` | Xử lý GET/POST [Node 4.4]. Điều hướng logic. |
| `LogoutServlet` | Xử lý invalidate session [Node 16.27]. |
| `ForgotPasswordServlet` | Xử lý email request [Node 4.5]. |
| `AuthService` | Chứa toàn bộ Business Rules (Locking, BCrypt, Password Gen) [Node 7.10, 10.17, 11.18]. |
| `UserDAO` | Tương tác bảng `[User]`. |
| `EmailService` | Chạy Background thread gửi email [Node 8.14]. |

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

### 2.2 Files JSP sẽ TẠO / CHỈNH SỬA (`web/`)

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

---

## 3. DATA FLOW (Theo ActivityDiagramF1.txt)

```
Login Flow:
  DAO.findByEmail() → Service.checkStatus() [Node 7.10]
    → (if locked & expired) DAO.unlockAccount() [Node 10.17]
    → Service.verifyBCrypt() [Node 11.18]
    → (if correct) DAO.resetAttempts() → Session creation → Redirect [Node 13.21, 14.23]
    → (if wrong) DAO.updateAttempts() → (if >= 5) DAO.lockAccount() [Node 13.20, 15.24]

Forgot Password Flow:
  DAO.findByEmail() [Node 5.7]
    → (not found) Return Fake Success [Node 7.11]
    → (found) Service.genPassword() → BCrypt.hash() → DAO.updatePassword() [Node 7.12]
    → Async EmailService.send() [Node 8.14]

Logout Flow:
  HttpSession.invalidate() [Node 16.27] → Redirect Login [Node 17.28]
```

---

## 4. DEPENDENCIES

- Yêu cầu cấu hình xong Connection Pool / `DatabaseConnection`.
- Bảng `[User]` phải có sẵn schema với đủ cột: `email`, `passwordHash`, `status`, `lockReason`, `failedLoginAttempts`, `lockedUntil`.
- Import `jbcrypt-0.4.jar` vào `allowedlib/`.

---

## 5. RISKS & MITIGATIONS

| Rủi ro | Mô tả | Mitigation |
|--------|-------|-----------|
| Timezone mismatch | Hàm `NOW` tại [Node 15.24] có thể lệch giữa JVM và SQL Server | Đồng bộ Timezone. Dùng `DATEADD(minute,30,GETDATE())` tại SQL hoặc `LocalDateTime.now()` tại Java |
| Timing Attack | Nhánh "email không tồn tại" trả về nhanh hơn → lộ thông tin | Gọi BCrypt dummy `checkpw()` trước khi return lỗi để cân bằng thời gian |
| User Enumeration | Thông báo lỗi khác nhau cho sai email vs sai password | Luôn trả lỗi chung "Tài khoản hoặc mật khẩu không chính xác" [Node 16.26] |
| Plaintext Password in Email | Gửi mật khẩu mới dạng plaintext qua email là anti-pattern | Tuân thủ SPEC — Hash BCrypt trước khi lưu DB; không log plaintext; email gửi Async |

---

## 6. DEPENDENCY MAP

```
AuthFilter
  └── (đọc) HttpSession → [userId, role]

LoginServlet
  ├── UserDAO.findByEmail()
  ├── UserDAO.unlockAccount()               ← [Node 10.17]
  ├── AuthService.verifyPassword()          ← BCrypt (jbcrypt-0.4.jar)
  ├── AuthService.handleFailedLogin()
  │     └── UserDAO.updateFailedAttempts()
  │     └── UserDAO.lockAccount()           ← [Node 15.24]
  └── UserDAO.resetFailedAttempts()

ForgotPasswordServlet
  ├── UserDAO.findByEmail()
  ├── AuthService.resetPassword()
  │     ├── AuthService.generatePassword()  ← [Node 7.12]
  │     ├── BCrypt.hashpw()
  │     └── UserDAO.updatePassword()
  └── EmailService.sendAsyncPasswordReset() ← ExecutorService [Node 8.14]

LogoutServlet
  └── HttpSession.invalidate()              ← [Node 16.27]
```

---

## 7. SESSION TIMEOUT & web.xml

```xml
<!-- web.xml — Cấu hình session timeout 30 phút (SPEC §4) -->
<session-config>
    <session-timeout>30</session-timeout>
</session-config>
```

---

## 8. CHECKLIST TRƯỚC KHI IMPLEMENT

- [x] Xác nhận: **HttpSession** — KHÔNG dùng JWT (C-02).
- [x] Xác nhận: Cơ chế **tự động mở khóa** tại thời điểm đăng nhập bằng cột `lockedUntil` [Node 10.17].
- [x] Xác nhận: Quên mật khẩu dùng **sinh mật khẩu 8 ký tự ngẫu nhiên** (không dùng OTP — giải quyết xung đột BR22).
- [ ] `jbcrypt-0.4.jar` đã có trong `allowedlib/` — đảm bảo classpath được cập nhật.
- [ ] Bảng `[User]` có đủ cột cần thiết: `email`, `passwordHash`, `status`, `lockReason`, `failedLoginAttempts`, `lockedUntil`.
- [ ] Cấu hình SMTP/SendGrid có trong `.env` (không hardcode — SEC-01).
