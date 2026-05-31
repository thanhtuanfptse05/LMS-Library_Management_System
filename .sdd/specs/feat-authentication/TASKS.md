# TASKS.md — Feature: Authentication (feat-authentication)
# Version: 1.0.0 | Phase: Task Decomposition (Pha 3) | Status: PENDING APPROVAL
# Tham chiếu: PLAN.md v1.0.0 | SPEC.md v1.0.0 | constitution.md v1.1.0
# Quyết định đã chốt:
#   [Q1-RESOLVED] Sử dụng HttpSession thuần — KHÔNG dùng JWT
#   [Q2-RESOLVED] Cơ chế mở khóa: Cột `lockedUntil DATETIME` (Phương án A)
# Ngày tạo: 2026-05-31

---

## NGUYÊN TẮC SẮP XẾP DEPENDENCY (Đọc trước khi implement)

```
TIER 0 — Infrastructure (Nền tảng)
  └── T-01: DatabaseConnection (utility JDBC)

TIER 1 — Data Layer (DAO + Model)
  ├── T-02: User model  ← phụ thuộc vào schema DB
  └── T-03: UserDAO     ← phụ thuộc vào T-01, T-02

TIER 2 — Service Layer (Business Logic)
  ├── T-04: EmailService (async)   ← phụ thuộc vào T-01
  └── T-05: AuthService            ← phụ thuộc vào T-03, T-04

TIER 3 — Web Layer (Servlet + Filter)
  ├── T-06: web.xml config         ← phụ thuộc vào T-03, T-05
  ├── T-07: AuthFilter             ← phụ thuộc vào T-05, T-06
  ├── T-08: LoginServlet           ← phụ thuộc vào T-05, T-06, T-07
  ├── T-09: LogoutServlet          ← phụ thuộc vào T-06
  └── T-10: ForgotPasswordServlet  ← phụ thuộc vào T-05, T-06

TIER 4 — View Layer (JSP)
  ├── T-11: login.jsp              ← phụ thuộc vào T-08
  ├── T-12: forgot-password.jsp    ← phụ thuộc vào T-10
  └── T-13: error-403.jsp          ← phụ thuộc vào T-07

TIER 5 — Integration & Verification
  └── T-14: End-to-end smoke test  ← phụ thuộc vào T-07 ~ T-13
```

---

## BẢNG PHÂN RÃ CÔNG VIỆC

| ID | Tên Task (Component) | Files cần tạo / sửa | Est | Deps | Tiêu chí hoàn thành (Definition of Done) |
|----|----------------------|---------------------|-----|------|-------------------------------------------|
| **T-01** | **[UTIL] DatabaseConnection** | `CREATE` `src/java/util/DatabaseConnection.java` | 1h | — | (1) Class cấp `Connection` tới SQL Server qua JDBC URL đọc từ config. (2) Dùng singleton hoặc static factory, đóng connection bằng `try-with-resources`. (3) KHÔNG hardcode thông tin kết nối (SEC-01). (4) Compile thành công, không warning. |
| **T-02** | **[MODEL] User Entity** | `CREATE` `src/java/model/User.java` | 1h | — | (1) Các field đầy đủ: `userId`, `email`, `passwordHash`, `role`, `status`, `failedLoginAttempts`, `lockedUntil` (LocalDateTime). (2) Getter/Setter chuẩn JavaBean. (3) Không có logic business trong model. (4) Compile thành công. |
| **T-03** | **[DAO] UserDAO** | `CREATE` `src/java/dao/UserDAO.java` | 3h | T-01, T-02 | (1) Implement đầy đủ 5 phương thức: `findByEmail()`, `updateFailedAttempts()`, `lockAccount()` (ghi `lockedUntil = NOW + 30min`), `updatePassword()`, `resetFailedAttempts()`. (2) 100% câu SQL dùng `PreparedStatement` với `?` — KHÔNG có String concatenation (SEC-03). (3) Mọi `Connection`/`PreparedStatement`/`ResultSet` đóng trong `finally` hoặc `try-with-resources` (ENG-01). (4) Method `lockAccount()` ghi cả `status = 'locked'` và `lockedUntil = DATEADD(minute, 30, GETDATE())`. |
| **T-04** | **[SERVICE] EmailService (Async)** | `CREATE` `src/java/service/EmailService.java` | 2h | T-01 | (1) Class sử dụng `ExecutorService` (single-thread pool hoặc cached) để gửi email bất đồng bộ (ARCH-03). (2) Method `sendPasswordResetEmail(String toEmail, String newPassword)` — submit task vào executor, không block HTTP thread. (3) Đọc SMTP credentials từ config/`.env` — KHÔNG hardcode (SEC-01). (4) KHÔNG log `newPassword` dưới dạng plaintext (SPEC §4). (5) Xử lý `MessagingException` trong async task, log lỗi phía server (ENG-03). |
| **T-05** | **[SERVICE] AuthService (Business Logic)** | `CREATE` `src/java/service/AuthService.java` | 3h | T-03, T-04 | (1) `verifyPassword(String raw, String hash)` → gọi `BCrypt.checkpw()` từ `jbcrypt-0.4.jar` — KHÔNG tự chế `MessageDigest`. (2) `handleFailedLogin(int userId, int attempts)` → tăng count; nếu count >= 5 → gọi `UserDAO.lockAccount()`, reset `failedLoginAttempts = 0`. (3) `isAccountLocked(User user)` → kiểm tra `user.getLockedUntil() != null && lockedUntil.isAfter(LocalDateTime.now())`. (4) `generatePassword()` → tạo chuỗi ngẫu nhiên 8 ký tự (chữ + số). (5) `resetPassword(int userId)` → hash bằng BCrypt, gọi `UserDAO.updatePassword()`. (6) `getRedirectByRole(String role)` → trả về URL string tương ứng role. (7) KHÔNG có SQL trực tiếp trong Service layer. |
| **T-06** | **[CONFIG] web.xml — Session & Servlet Mapping** | `MODIFY` `web/WEB-INF/web.xml` | 1h | T-03, T-05 | (1) Thêm `<session-config><session-timeout>30</session-timeout></session-config>`. (2) Đăng ký `<servlet>` và `<servlet-mapping>` cho: `/login` → `LoginServlet`, `/logout` → `LogoutServlet`, `/forgot-password` → `ForgotPasswordServlet`. (3) Đăng ký `<error-page>` cho mã 403 → `error-403.jsp`. (4) Deploy descriptor hợp lệ, server khởi động không có lỗi parsing XML. |
| **T-07** | **[FILTER] AuthFilter — RBAC Protection** | `CREATE` `src/java/filter/AuthFilter.java` | 2h | T-05, T-06 | (1) Annotation `@WebFilter("/*")` — intercept toàn bộ request. (2) Public routes KHÔNG cần session: `/login`, `/logout`, `/forgot-password`, `/assets/*`, `/css/*`, `/js/*`, `/images/*`. (3) Protected routes kiểm tra `session.getAttribute("role")` và đối chiếu với đường dẫn: `/admin/*` → `ADMIN`, `/librarian/*` → `LIBRARIAN`, `/manager/*` → `MANAGER`, `/student/*` → `STUDENT`. (4) Không có session hoặc sai role → `response.sendError(403)` (trường hợp sai role) hoặc `response.sendRedirect("/login")` (chưa login). (5) Tài khoản đã có session hợp lệ truy cập `/login` → redirect về dashboard đúng role (chống load lại login khi đã đăng nhập). |
| **T-08** | **[CONTROLLER] LoginServlet** | `CREATE` `src/java/controller/LoginServlet.java` | 3h | T-05, T-06, T-07 | (1) `doGet()` → forward tới `/login.jsp`. (2) `doPost()` → thực hiện ĐÚNG luồng theo Swimlane-UC-login: Decision 1.2.2 → 1.3.3 → 1.4.4 → Action 1.5.5 → Decision 1.6.6 → Action 1.7.7/1.8.8/1.8.9. (3) Nếu email không tồn tại → PHẢI gọi BCrypt dummy verify để đồng đều thời gian phản hồi (chống Timing Attack — RISK-04). (4) Thông báo lỗi chung: `"Tài khoản hoặc mật khẩu không chính xác"` cho mọi trường hợp sai (SPEC §6 — chống User Enumeration). (5) Login thành công → tạo session với `userId`, `role`, `email`; gọi `UserDAO.resetFailedAttempts()`; redirect đúng Dashboard theo role. (6) Tài khoản locked và `lockedUntil` chưa hết → hiển thị thông báo "Tài khoản bị khóa, vui lòng thử lại sau X phút" — KHÔNG tiến hành verify password. (7) KHÔNG in stack trace ra response (ENG-03). |
| **T-09** | **[CONTROLLER] LogoutServlet** | `CREATE` `src/java/controller/LogoutServlet.java` | 0.5h | T-06 | (1) `doGet()` và `doPost()` đều xử lý logout. (2) Lấy session hiện tại với `getSession(false)` (không tạo session mới). (3) Nếu session tồn tại → gọi `session.invalidate()`. (4) Redirect về `/login`. (5) Compile và deploy thành công. |
| **T-10** | **[CONTROLLER] ForgotPasswordServlet** | `CREATE` `src/java/controller/ForgotPasswordServlet.java` | 2h | T-05, T-06 | (1) `doGet()` → forward tới `/forgot-password.jsp`. (2) `doPost()` → gọi `UserDAO.findByEmail()`. (3) Nếu email KHÔNG tồn tại → vẫn trả về thông báo thành công: `"Nếu email hợp lệ, hệ thống đã gửi mật khẩu mới"` (SPEC §6 — chống dò quét email). (4) Nếu email tồn tại → gọi `AuthService.resetPassword()` (hash + update DB), sau đó submit `EmailService.sendPasswordResetEmail()` vào ExecutorService (async — ARCH-03). (5) KHÔNG log plaintext password (SPEC §4). (6) Response trả về ngay sau khi submit email task — KHÔNG chờ email gửi xong. |
| **T-11** | **[VIEW] login.jsp** | `MODIFY` `web/login.jsp` *(file đã tồn tại — kiểm tra và cập nhật)* | 1.5h | T-08 | (1) Form POST tới `/login` với field `email` và `password`. (2) Hiển thị `${requestScope.errorMessage}` nếu có lỗi từ Servlet. (3) Hiển thị `${requestScope.lockedMessage}` nếu tài khoản bị khóa (với thời gian còn lại). (4) Link sang `/forgot-password`. (5) KHÔNG có scriptlet Java `<% %>` (ARCH-01). (6) Dùng JSTL `<c:if>` và EL để render điều kiện. (7) Giao diện phù hợp với `ui_rule.md`. |
| **T-12** | **[VIEW] forgot-password.jsp** | `MODIFY` `web/forgot-password.jsp` *(file đã tồn tại — kiểm tra và cập nhật)* | 1h | T-10 | (1) Form POST tới `/forgot-password` với field `email`. (2) Hiển thị `${requestScope.successMessage}` cho cả 2 nhánh (email tồn tại và không tồn tại). (3) Link quay lại `/login`. (4) KHÔNG có scriptlet Java `<% %>` (ARCH-01). (5) Dùng JSTL `<c:if>` và EL. |
| **T-13** | **[VIEW] error-403.jsp** | `CREATE` `web/error-403.jsp` | 0.5h | T-07 | (1) Trang báo lỗi thân thiện "403 — Bạn không có quyền truy cập trang này". (2) Có nút quay về trang chủ hoặc Dashboard. (3) KHÔNG lộ stack trace hay thông tin hệ thống (ENG-03). (4) Giao diện phù hợp `ui_rule.md`. |
| **T-14** | **[VERIFY] Smoke Test End-to-End** | Không tạo file mới — chạy thủ công + JUnit | 2h | T-07 ~ T-13 | Xem chi tiết bên dưới. |

---

## CHI TIẾT T-14: SMOKE TEST END-TO-END

### 14A. JUnit Unit Tests (Viết test cho business logic)

| Test Case | Mô tả | Pass Condition |
|-----------|-------|----------------|
| `AuthServiceTest::testVerifyPasswordCorrect` | Nhập đúng password | `verifyPassword()` trả về `true` |
| `AuthServiceTest::testVerifyPasswordWrong` | Nhập sai password | `verifyPassword()` trả về `false` |
| `AuthServiceTest::testLockAfterFiveAttempts` | Mock 5 lần sai liên tiếp | `handleFailedLogin()` gọi `lockAccount()` ở lần thứ 5 |
| `AuthServiceTest::testGeneratePasswordLength` | Tạo password ngẫu nhiên | Chuỗi có độ dài == 8 |
| `AuthServiceTest::testIsAccountLockedTrue` | `lockedUntil` trong tương lai | `isAccountLocked()` trả về `true` |
| `AuthServiceTest::testIsAccountLockedExpired` | `lockedUntil` đã qua | `isAccountLocked()` trả về `false` |

### 14B. Manual Acceptance Tests

| AC | Scenario | Expected Result |
|----|----------|-----------------|
| AC-1 | Đăng nhập đúng email + password, role = STUDENT | Redirect `/student/dashboard.jsp`, session có `userId`, `role`, `email` |
| AC-2 | Đăng nhập sai password 1 lần | Hiển thị "Tài khoản hoặc mật khẩu không chính xác", `failedLoginAttempts = 1` trong DB |
| AC-3 | Đăng nhập sai 5 lần liên tiếp | `status = 'locked'`, `lockedUntil = now + 30min` trong DB; thông báo tài khoản bị khóa |
| AC-4 | Đăng nhập khi tài khoản đang bị khóa | Bị chặn ngay, hiển thị thời gian còn lại — KHÔNG verify password |
| AC-5 | Đăng nhập khi `lockedUntil` đã hết hạn | Tự động mở khóa, xử lý login bình thường |
| AC-6 | Truy cập `/admin/*` khi chưa login | Redirect về `/login` |
| AC-7 | Truy cập `/admin/*` với role `STUDENT` | Trả về `error-403.jsp` |
| AC-8 | Đăng xuất | Session bị invalidate, redirect `/login` |
| AC-9 | Reset password với email hợp lệ | DB cập nhật `passwordHash` mới, nhận email (async) |
| AC-10 | Reset password với email không tồn tại | Vẫn hiển thị thông báo thành công (chống dò quét) |
| AC-11 | Truy cập `/login` khi đã có session | Redirect về Dashboard đúng role (không load lại login) |

---

## TỔNG THỜI GIAN ƯỚC TÍNH

| Tier | Tasks | Tổng Est |
|------|-------|----------|
| TIER 0 — Infrastructure | T-01 | 1h |
| TIER 1 — Data Layer | T-02, T-03 | 4h |
| TIER 2 — Service Layer | T-04, T-05 | 5h |
| TIER 3 — Web Layer | T-06, T-07, T-08, T-09, T-10 | 8.5h |
| TIER 4 — View Layer | T-11, T-12, T-13 | 3h |
| TIER 5 — Verification | T-14 | 2h |
| **TỔNG** | **14 tasks** | **~23.5h** |

> ⚠️ Lưu ý: T-11 và T-12 là MODIFY (file JSP đã tồn tại trong `web/`), cần đọc nội dung
> hiện tại trước khi sửa để không mất code giao diện đang có.

---

## CHECKLIST PHÊ DUYỆT (Dành cho Human review)

- [ ] Số lượng task hợp lý, không task nào > 4h
- [ ] Thứ tự dependency đúng (Tier 0 → 1 → 2 → 3 → 4 → 5)
- [ ] T-11 và T-12: Xác nhận MODIFY (không tạo mới) vì JSP đã tồn tại
- [ ] T-14 test coverage đủ cho happy path (AGENTS.md §6)
- [ ] Cột `lockedUntil DATETIME` cần được thêm vào bảng `[User]` trong DB (cần xác nhận)

**→ Sau khi phê duyệt TASKS.md này, chuyển sang Pha 4: Implementation.**
