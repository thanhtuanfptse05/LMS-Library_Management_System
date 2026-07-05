# LMS Library Management System Constitution
<!-- Synced from .sdd/constitution.md | Version: 1.2.0 | Last Sync: 2026-07-05 -->

## Core Principles

### I. Security-First (BẮT BUỘC — Không bao giờ vi phạm)
- **SEC-01 — Cấm Hardcode bí mật**: Tuyệt đối không lưu API Key, secret, mật khẩu dưới dạng plaintext trong source code, JSP, Java class. Phải lưu trong `.env` hoặc mã hóa an toàn.
- **SEC-02 — Phân quyền RBAC bắt buộc**: Mọi endpoint trong `/admin/*`, `/librarian/*`, `/manager/*`, `/student/*` PHẢI được bảo vệ bởi `@WebFilter` + `HttpSession`. Bypass → 403 Forbidden.
- **SEC-03 — Chống SQL Injection tuyệt đối**: Chỉ dùng `PreparedStatement` với parameterize `?`. NGHIÊM CẤM cộng chuỗi tạo SQL.

### II. Monolith MVC — Cấm Framework
- Kiến trúc bắt buộc: **Model** (Java Beans/DTO) → **View** (JSP + JSTL/EL, cấm `<% %>`) → **Controller** (Java Servlet thuần).
- NGHIÊM CẤM: Spring, Spring Boot, Hibernate, JPA, MyBatis hoặc bất kỳ ORM nào. Chỉ dùng JDBC thuần.

### III. Audit Log — Bắt buộc cho mọi C/U/D
- Mọi thao tác Create/Update/Delete quan trọng (mượn sách, trả sách, phạt, thanh toán, cấu hình hệ thống, khóa/mở tài khoản) PHẢI ghi vào bảng `AuditLogs`.
- Bản ghi Audit Log là bất biến — không ai được sửa/xóa, kể cả Admin.

### IV. Async cho I/O chậm
- Gửi email OTP, email thông báo, email nhắc phạt PHẢI chạy bất đồng bộ qua `ExecutorService`.
- NGHIÊM CẤM gọi đồng bộ dịch vụ email trong HTTP Request Thread.

### V. Soft-Delete — Không xóa giao dịch cốt lõi
- Không dùng `DELETE FROM` cho các bảng cốt lõi (`"User"`, `Book`, `BookCopy`, `BorrowRecord`, `Fine`, `Payment`, `Reservation`, `BookSuggestion`).
- Thay bằng Soft-delete: cập nhật `status = 'inactive'/'cancelled'/'lost'/'deleted'`.
- Hard-delete chỉ cho file tạm và log quá 90 ngày.

### VI. Ngôn ngữ giao diện — 100% Tiếng Việt
- **UI-01**: NGHIÊM CẤM viết giao diện người dùng bằng tiếng Anh hoặc ngôn ngữ khác. Toàn bộ JSP, HTML, thông báo lỗi, thông báo thành công, nhãn phải bằng **tiếng Việt**.

## PostgreSQL & Supabase Constraints (DB-01)

- **Bảng `"User"` bắt buộc nháy kép**: `User` là từ khóa PostgreSQL — mọi câu SQL phải viết `"User"`. Các bảng khác KHÔNG bọc nháy kép.
- **Cổng kết nối 6543**: JDBC kết nối qua Transaction/Session Pooler cổng `6543` của Supabase (tránh lỗi IPv6 `UnknownHostException`).
- **Driver JDBC**: Dùng `org.postgresql.Driver` (`postgresql-42.7.3.jar`). Không dùng SQL Server driver.
- **Hàm thời gian**: Dùng `NOW()` hoặc `CURRENT_TIMESTAMP` — NGHIÊM CẤM dùng `GETDATE()`.
- **Cột `processedBy`**: Trong bảng `Payment` là `processedBy INT NULL` — Java DAO/DTO phải map chính xác.
- **Tên bảng PascalCase, tên cột camelCase**: `BorrowRecord`, `userId`, `passwordHash`, `startDate`.

## Engineering Standards

- **ENG-01 — Clean Code**: Đóng `Connection`, `PreparedStatement`, `ResultSet` ngay trong `finally` hoặc try-with-resources. Không để connection leak.
- **ENG-02 — Naming**: Bảng PascalCase, cột camelCase, Class PascalCase + suffix (`LoginServlet`, `BookDAO`), file JSP kebab-case (`book-list.jsp`).
- **ENG-03 — Error Handling**: KHÔNG hiển thị stack trace ra giao diện. Log chi tiết ở server, hiển thị thông báo thân thiện + error code ở client.
- **ENG-04 — File Splitting**: Chia nhỏ Java Class, JSP, CSS, JS thành component chuyên biệt (Single Responsibility). Dùng `<jsp:include>` để tách giao diện dùng chung.

## AI Agent Self-Check Protocol

Trước mỗi lần submit thay đổi, AI Agent PHẢI tự kiểm tra:

**SECURITY:**
- [ ] Không hardcode API key / mật khẩu trong source code
- [ ] Servlet CUD được bảo vệ bởi AuthFilter (RBAC)
- [ ] Mọi SQL dùng `PreparedStatement` với `?` (không cộng chuỗi)

**ARCHITECTURE:**
- [ ] Không dùng Spring / Hibernate / JPA / ORM nào
- [ ] Mọi C/U/D quan trọng đều ghi Audit Log
- [ ] Email/OTP chạy async qua `ExecutorService`

**ENGINEERING — PostgreSQL:**
- [ ] Bảng `"User"` bọc nháy kép trong SQL, các bảng khác không bọc
- [ ] Dùng `NOW()` / `CURRENT_TIMESTAMP` (không dùng `GETDATE()`)
- [ ] Kết nối DB qua cổng 6543 với driver `org.postgresql.Driver`
- [ ] Cột `processedBy` trong Payment map đúng camelCase

**ENGINEERING — Code Quality:**
- [ ] Tên bảng PascalCase, cột camelCase, JSP kebab-case
- [ ] Kết nối CSDL đóng an toàn bằng try-with-resources / `finally`
- [ ] Không in stack trace ra giao diện người dùng
- [ ] File code chia nhỏ hợp lý, không ôm đồm
- [ ] Giao diện JSP/HTML viết 100% bằng tiếng Việt

## Governance

Constitution này là **Luật tối cao** của dự án LMS. Mọi AI Agent, Developer và Pull Request đều phải tuân thủ.

**Quy trình xử lý vi phạm:**
1. AI Agent SHALL dừng công việc, từ chối triển khai.
2. AI Agent SHALL báo cáo: `[CONSTITUTION VIOLATION] Rule: {ID} tại File: {path}, Line: {line}.`
3. AI Agent SHALL tự sửa vi phạm trước khi tiếp tục yêu cầu mới.

Sửa đổi Constitution chỉ được thực hiện qua RFC process có xác nhận của Human (Owner: @tech-lead).

**Version**: 1.3.0 | **Ratified**: 2026-06-06 | **Last Amended**: 2026-07-05
