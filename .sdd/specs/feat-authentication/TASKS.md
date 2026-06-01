# TASKS.md — Feature: Authentication (feat-authentication)
# Version: 2.0.0 | Phase: Task Decomposition | Status: DRAFT
# Tham chiếu: PLAN.md v2.0.0 | SPEC.md v2.0.0 | constitution.md v1.1.0
# Base: ActivityDiagramF1.txt
# Quyết định đã chốt:
#   [Q1-RESOLVED] Sử dụng HttpSession thuần — KHÔNG dùng JWT
#   [Q2-RESOLVED] Cơ chế mở khóa: Cột `lockedUntil DATETIME` + Auto-unlock tại login [Node 10.17]
#   [Q3-RESOLVED] Quên mật khẩu: Sinh mật khẩu 8 ký tự ngẫu nhiên — KHÔNG dùng OTP (giải quyết xung đột BR22)
# Tuân thủ nguyên tắc Atomic & Max 4h/task

---

## NGUYÊN TẮC SẮP XẾP DEPENDENCY (Đọc trước khi implement)

```
TIER 0 — Infrastructure (Nền tảng)
  └── T-AUTH-00: DatabaseConnection (utility JDBC)

TIER 1 — Data Layer (DAO + Model)
  ├── T-AUTH-01: UserDAO  ← phụ thuộc vào T-AUTH-00 + Schema [User]
  └── (Model User.java được implement trong T-AUTH-01)

TIER 2 — Service Layer (Business Logic)
  ├── T-AUTH-02: AuthService  ← phụ thuộc vào T-AUTH-01
  └── T-AUTH-03: EmailService (async)

TIER 3 — Web Layer (Filter + Servlet)
  ├── T-AUTH-04: AuthFilter             ← phụ thuộc vào T-AUTH-02
  ├── T-AUTH-05: LoginServlet           ← phụ thuộc vào T-AUTH-02, T-AUTH-04
  ├── T-AUTH-06: ForgotPasswordServlet  ← phụ thuộc vào T-AUTH-02, T-AUTH-03
  └── T-AUTH-07: LogoutServlet          ← standalone

TIER 4 — View Layer (JSP)
  └── T-AUTH-08: Views (login.jsp, forgot-password.jsp)  ← phụ thuộc vào T-AUTH-05, T-AUTH-06
```

---

## BẢNG PHÂN RÃ CÔNG VIỆC

| Task ID | Component | Mô tả công việc | Dependency | DoD (Definition of Done) |
| --- | --- | --- | --- | --- |
| **T-AUTH-01** | `UserDAO` | Implement `findByEmail`, `updateLoginAttempts`, `lockAccount` (ghi status='locked', lockedUntil=NOW+30min, lockReason='securitybreach', failedLoginAttempts=0), `unlockAccount` (ghi status='active', lockedUntil=NULL, lockReason=NULL) [Node 10.17], `updatePasswordHash`, `resetFailedAttempts`. Dùng `PreparedStatement`. | Bảng `[User]` + DatabaseConnection | 100% queries parameterized. Không có String concatenation SQL (SEC-03). Connection đóng đúng trong try-with-resources. |
| **T-AUTH-02** | `AuthService` | Implement: `verifyPassword()` (BCrypt.checkpw), `handleFailedLogin()` (tăng count → nếu >= 5 gọi lockAccount) [Node 13.20, 15.24], `isAccountLocked()` (kiểm tra lockedUntil so với LocalDateTime.now()), `generatePassword()` (8 ký tự ngẫu nhiên), `resetPassword()` (gen → hash → updatePasswordHash) [Node 7.12]. | T-AUTH-01 | Business logic map đúng với EARS và Node ID. Không có SQL trong Service. Không dùng MessageDigest. |
| **T-AUTH-03** | `EmailService` | Dùng `ExecutorService` tạo hàm `sendAsyncPasswordReset(String toEmail, String newPassword)`. Gọi async — không block HTTP Thread [Node 8.14]. KHÔNG log newPassword dạng plaintext. | — | Email task submit vào executor ngay, HTTP response trả về không chờ. Không log plaintext (NFR-01). |
| **T-AUTH-04** | `AuthFilter` | Viết logic check `HttpSession` và role-based access. Public routes cho qua. Protected routes redirect `/login` nếu chưa login, 403 nếu sai role. Đã login truy cập `/login` → redirect Dashboard. | — | Redirect `403` hoặc `/login` đúng trường hợp. Không bypass role check. |
| **T-AUTH-05** | `LoginServlet` | Mapping đúng với AuthService. Flow: findByEmail [Node 5.6] → checkStatus [Node 7.10] → autoUnlock [Node 10.17] → verifyBCrypt [Node 11.18] → updateAttempts/Lock [Node 13.20, 15.24] → createSession, redirect Dashboard [Node 13.21, 14.23]. Gọi BCrypt dummy khi email không tồn tại (chống Timing Attack). | T-AUTH-02, T-AUTH-04 | Flow chuẩn ActivityDiagramF1. Thông báo lỗi chung chống User Enumeration [Node 16.26]. |
| **T-AUTH-06** | `ForgotPasswordServlet` | Mapping với AuthService & EmailService. findByEmail [Node 5.7] → Fake Success nếu không tồn tại [Node 7.11] → resetPassword + sendAsync nếu tồn tại [Node 7.12, 8.14]. Response trả về ngay, không chờ email. | T-AUTH-02, T-AUTH-03 | Email gửi thành công ngầm. Fake Success trả về cho cả 2 nhánh. |
| **T-AUTH-07** | `LogoutServlet` | Gọi `session.invalidate()` [Node 16.27] và redirect `/login` [Node 17.28]. Dùng `getSession(false)` để không tạo session mới. | — | Session clear hoàn toàn. Không tạo session mới nếu không có session. |
| **T-AUTH-08** | Views (JSP) | Tạo/cập nhật `login.jsp` (form POST `/login`, hiển thị errorMessage, lockedMessage, link forgot-password) và `forgot-password.jsp` (form POST `/forgot-password`, hiển thị successMessage). KHÔNG dùng scriptlet `<% %>`. Dùng JSTL c:if và EL. | T-AUTH-05, T-AUTH-06 | Map đúng POST method. Không có Java scriptlet. Hiển thị đúng message từ requestScope. |

---

## CHI TIẾT: SMOKE TEST END-TO-END

### JUnit Unit Tests

| Test Case | Mô tả | Pass Condition |
|-----------|-------|----------------|
| `AuthServiceTest::testVerifyPasswordCorrect` | Nhập đúng password | `verifyPassword()` trả về `true` |
| `AuthServiceTest::testVerifyPasswordWrong` | Nhập sai password | `verifyPassword()` trả về `false` |
| `AuthServiceTest::testLockAfterFiveAttempts` | Mock 5 lần sai liên tiếp | `handleFailedLogin()` gọi `lockAccount()` ở lần thứ 5 |
| `AuthServiceTest::testGeneratePasswordLength` | Tạo password ngẫu nhiên | Chuỗi có độ dài == 8 |
| `AuthServiceTest::testIsAccountLockedTrue` | `lockedUntil` trong tương lai | `isAccountLocked()` trả về `true` |
| `AuthServiceTest::testIsAccountLockedExpired` | `lockedUntil` đã qua | `isAccountLocked()` trả về `false` → auto-unlock path |

### Manual Acceptance Tests (Map với SPEC §7)

| AC | Scenario | Expected Result |
|----|----------|-----------------|
| AC1 | Đăng nhập sai 5 lần liên tiếp | status='locked', lockReason='securitybreach', lockedUntil=now+30min trong DB |
| AC2 | Đăng nhập lại sau khi lockedUntil hết hạn | Tự động mở khóa [Node 10.17], đăng nhập thành công |
| AC3 | Gửi Forgot Password với email không tồn tại | Hiển thị Fake Success [Node 7.11] |
| AC4 | Nhấn Logout | Session invalidate hoàn toàn [Node 16.27], redirect login [Node 17.28] |
| AC-5 | Đăng nhập đúng, role=STUDENT | Redirect Dashboard STUDENT, session có userId, role, email |
| AC-6 | Truy cập `/admin/*` khi chưa login | Redirect `/login` |
| AC-7 | Truy cập `/admin/*` với role `STUDENT` | 403 Forbidden |
| AC-8 | Reset password với email hợp lệ | DB cập nhật passwordHash mới, nhận email (async) |
| AC-9 | Truy cập `/login` khi đã có session | Redirect về Dashboard đúng role |

---

## TỔNG THỜI GIAN ƯỚC TÍNH

| Tier | Tasks | Tổng Est |
|------|-------|----------|
| TIER 1 — Data Layer | T-AUTH-01 | 3h |
| TIER 2 — Service Layer | T-AUTH-02, T-AUTH-03 | 5h |
| TIER 3 — Web Layer | T-AUTH-04, T-AUTH-05, T-AUTH-06, T-AUTH-07 | 7.5h |
| TIER 4 — View Layer | T-AUTH-08 | 2.5h |
| **TỔNG** | **8 tasks** | **~18h** |

---

## CHECKLIST PHÊ DUYỆT

- [x] Số lượng task hợp lý, không task nào > 4h
- [x] Thứ tự dependency đúng (Tier 1 → 2 → 3 → 4)
- [x] Xung đột BR22 vs ActivityDiagramF1.txt đã được giải quyết (sinh mật khẩu 8 ký tự — không OTP)
- [x] Fake Success pattern [Node 7.11] được đặc tả rõ trong T-AUTH-06
- [x] Auto-unlock [Node 10.17] được implement trong T-AUTH-05 (LoginServlet)
- [ ] Bảng `[User]` có cột `lockReason` — cần xác nhận schema DB
- [ ] `jbcrypt-0.4.jar` đã có trong `allowedlib/`

**→ Sau khi phê duyệt TASKS.md này, chuyển sang Pha 4: Implementation.**
