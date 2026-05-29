# PROJECT CONSTITUTION — Library Management System (LMS)
# Version: 2.0.0 | Ratified: 29/5/2026 | Team: Group 6
# Status: LOCKED — chỉ thay đổi qua RFC process (đồng thuận cả team + GVHD)
# Áp dụng cho: mọi AI agent, mọi developer, mọi PR

═══════════════════════════════════════════════════
  LAYER 1: HARD RULES — KHÔNG BAO GIỜ VI PHẠM (BLOCKING)
═══════════════════════════════════════════════════

## SEC-01: Password & Data Security
- THE system SHALL hash passwords bằng BCrypt (`BCryptUtil.hash`). TUYỆT ĐỐI KHÔNG lưu plaintext password, MD5, SHA1, SHA256 cho passwords.
- THE system SHALL bắt buộc người dùng thay đổi mật khẩu khi đăng nhập lần đầu tiên nếu mật khẩu mặc định trùng với tên đăng nhập, chặn mọi thao tác khác cho đến khi việc đổi mật khẩu thành công.
- API keys (VNPAY Secret, SendGrid Key, OpenAI/Gemini Key, DB Password) PHẢI lưu trong `.env` hoặc `SystemConfigurations`. TUYỆT ĐỐI KHÔNG hardcode trong source code, `.java`, `.jsp`, hoặc logs.
- Tham chiếu: BR22 (Password Policy), BR28 (Data Encryption), BR30 (First Login Password Change)

## SEC-02: Authentication & Authorization (RBAC)
- Mọi endpoint bị giới hạn (dành cho Admin, Librarian, Manager, Student, Lecturer) PHẢI được bảo vệ bằng `@WebFilter` kiểm tra `HttpSession` hợp lệ.
- TUYỆT ĐỐI KHÔNG bypass `AuthorizationFilter` cho các URL: `/admin/*`, `/librarian/*`, `/student/*`, `/manager/*`.
- Tiến trình khóa tài khoản do nợ phạt không được phép ghi đè lên các lý do khóa nghiêm trọng hơn đang có hiệu lực (như adminban hoặc securitybreach).
- Khi người dùng đóng hết tiền phạt, tài khoản chỉ được tự động mở khóa nếu lý do khóa hiện tại là unpaid và không còn bất kỳ điều kiện khóa nào khác.
- Unauthorized access attempts PHẢI bị chặn VÀ ghi log vào `AuditLogs` (BR03, BR19).
- Tham chiếu: BR03 (Authorization), FR02 (Login lockout), BR31 (Fine Lock/Unlock Safeguards)

## SEC-03: SQL Injection Prevention (No ORM)
- THE system SHALL sử dụng JDBC thuần với `PreparedStatement` cho MỌI câu query.
- TUYỆT ĐỐI KHÔNG dùng `Statement` hay nối chuỗi (string concatenation) để ghép tham số SQL.
- Tham chiếu: AGENTS.md SEC-03, ADR-001

## SEC-04: Data Encryption & Privacy
- THE system SHALL mã hóa data in-transit (TLS 1.2+) và at-rest theo chính sách bảo mật trường đại học (BR28).
- KHÔNG được log PII đầy đủ: phone mask "0912***456", email mask "use***@domain.com". KHÔNG BAO GIỜ log password, payment card, national ID.
- Mọi dữ liệu ghi vào `oldValues` và `newValues` trong bảng `AuditLogs` (ví dụ: khi cập nhật hồ sơ) PHẢI được áp dụng thuật toán ẩn danh/masking tương ứng đối với Email và Số điện thoại trước khi lưu trữ dưới dạng JSON.
- Tham chiếu: BR28 (Security), BR19 (Immutable Audit Log)

## DATA-01: Soft-Delete Only cho Core Entities
- THE system SHALL sử dụng soft-delete (cập nhật `status` = inactive/locked/cancelled/void) cho các bảng lõi: `User`, `Books`, `BorrowRecord`, `Fine`, `Payment`, `Reservation`.
- TUYỆT ĐỐI KHÔNG dùng lệnh `DELETE FROM` (Hard-delete) cho các bảng này để giữ toàn vẹn Audit Log.
- Admin KHÔNG ĐƯỢC PHÉP xóa vĩnh viễn tài khoản — chỉ thay đổi status (BR02).
- Tham chiếu: BR02 (Soft-delete only), BR19 (Immutable Audit Log)

═══════════════════════════════════════════════════
  LAYER 2: ARCHITECTURAL CONSTRAINTS
═══════════════════════════════════════════════════

## ARCH-01: Layer Boundaries (Pure MVC — Controller → Service → DAO)
- THE system SHALL tuân thủ luồng: `Servlet (Controller)` → `Service (Business Logic)` → `DAO (Data Access)`.
- Servlet TUYỆT ĐỐI KHÔNG được gọi trực tiếp DAO mà phải đi qua Service layer.
- Service TUYỆT ĐỐI KHÔNG chứa câu lệnh SQL. DAO TUYỆT ĐỐI KHÔNG chứa logic nghiệp vụ.
- Exception process: Nếu cần bypass → RFC + tech lead sign-off.
- Tham chiếu: ADR-001, AGENTS.md Section 4

## ARCH-02: Audit Trail (Nhật ký kiểm toán bất biến)
- Mọi thao tác Create/Update/Delete (C/U/D) quan trọng PHẢI gọi `AuditLogDAO.insert()` để ghi log bất biến.
- Các thao tác bắt buộc audit: mượn sách, trả sách, tạo phạt, thanh toán phạt, thay đổi config, khóa/mở khóa tài khoản, thay đổi hồ sơ, thêm/sửa sách.
- Dữ liệu Audit Log KHÔNG THỂ bị sửa đổi hay xóa bỏ bởi bất kỳ ai (BR19).
- Tham chiếu: BR19 (Immutable Audit Log), BR27 (Notification triggers)

## ARCH-03: AI Output is Advisory Only
- Mọi kết quả từ OpenAI/Gemini (gợi ý sách, phân tích thói quen) chỉ mang tính tham khảo.
- Quyết định cuối cùng (duyệt mượn, phạt, khóa tài khoản) PHẢI do hệ thống luật định sẵn hoặc Thủ thư thực hiện (BR18).
- Tham chiếu: BR18 (AI Advisory Only)

## ARCH-04: Asynchronous I/O cho Long-running Operations
- Mọi thao tác I/O chậm (gửi OTP, gửi Email qua SendGrid, gọi API AI) PHẢI chạy bất đồng bộ qua `ExecutorService`.
- Sync operations mà block UI > 2 giây là architectural violation.
- Tham chiếu: AGENTS.md Section 4 (Async Processing)

═══════════════════════════════════════════════════
  LAYER 3: ENGINEERING STANDARDS
═══════════════════════════════════════════════════

## TECH STACK (Immutable during SWP391)
- Backend: Java JDK 17, Java Servlet/JSP (MVC thuần)
- Database: Microsoft SQL Server (JDBC + DAO Pattern)
- Frontend: HTML/CSS/JS + JSP (JSTL/EL)
- Integrations: VNPAY (Sandbox), SendGrid/SMTP, OpenAI/Gemini
- CẤM: Spring, Spring Boot, Hibernate, JPA, bất kỳ ORM framework nào

## NAMING CONVENTIONS
- Servlet/Service/DAO/Model: `PascalCase` (VD: `BorrowBookServlet.java`, `BorrowService.java`)
- JSP View: `kebab-case` (VD: `book-list.jsp`, `dashboard-admin.jsp`)
- Database Tables/Columns: Theo schema hiện tại (VD: `BorrowRecord`, `borrowRecordId`)

## ENG-01: Testing & Quality
- Unit Tests: JUnit 5 cho các hàm tính toán phức tạp (VD: `FineCalculationService`, validation helpers).
- Minimum coverage: Happy path + Error cases cho Business Logic.

## ENG-02: Error Handling
- Dùng Custom Exception Pattern. Handle lỗi trả về JSP thân thiện.
- KHÔNG expose internal error details (stack trace) ra giao diện người dùng.
- Error response phải chứa thông báo user-friendly bằng tiếng Việt.

## ENG-03: Code Hygiene
- KHÔNG để lại `System.out.println()` hoặc `TODO` comments trong code được commit.
- KHÔNG dùng `System.out.println()` để in dữ liệu nhạy cảm khi test.
- Thay thế bằng structured Logger.

## ENG-04: Dependency Management
- KHÔNG được tự ý thêm file `.jar` hoặc dependency mà không hỏi human.
- Third-party library cần security review trước khi thêm.

═══════════════════════════════════════════════════
  AI AGENT SELF-CHECK PROTOCOL
═══════════════════════════════════════════════════

## TRƯỚC KHI SUBMIT BẤT KỲ CODE NÀO, AI PHẢI TỰ KIỂM TRA:

CHECKLIST SEC (Layer 1 — BLOCKING):
  [ ] SEC-01: Không có hardcoded secrets (grep: password=, key=, token=, secret=)
  [ ] SEC-02: Mọi endpoint mutating có auth middleware (@WebFilter)
  [ ] SEC-03: 100% SQL queries dùng PreparedStatement (không có string concatenation)
  [ ] SEC-04: Không log PII đầy đủ (password, email nguyên, phone nguyên)
  [ ] DATA-01: Không có lệnh DELETE cứng cho User, BorrowRecord, Fine, Payment, Reservation

CHECKLIST ARCH (Layer 2 — BLOCKING):
  [ ] ARCH-01: Servlet không gọi thẳng DAO (phải qua Service)
  [ ] ARCH-02: C/U/D quan trọng có INSERT vào AuditLogs
  [ ] ARCH-04: I/O chậm (email, AI API) dùng ExecutorService

CHECKLIST ENG (Layer 3 — WARNING):
  [ ] ENG-01: Unit tests cover happy path + error cases
  [ ] ENG-02: Error responses không chứa stack trace
  [ ] ENG-03: Đã xóa toàn bộ System.out.println() và TODO comments

## Nếu vi phạm phát hiện:
AI SHALL báo cáo: "[CONSTITUTION VIOLATION] Rule: {ID}
  File: {file}, Line: {n}. Action taken: {description}"
AI SHALL KHÔNG submit code vi phạm Layer 1.
AI SHALL hỏi human approval cho Layer 2 violations.