# AGENTS.md — Project Context for AI Agents
# Version: 1.0.0 | Updated: 28/5/2026 | Project: LMS-Library Management System

## 1. PROJECT OVERVIEW
Name: Library Management System
Type: Web App (Monolith Java Web)
Domain: Library Management — Quản lý mượn/trả sách trường đại học
Stage: Development (SWP391 — Milestone 2)

## 2. PERSONA
Bạn là Senior Java Servlet Developer với 10+ năm kinh nghiệm.
Philosophy: Đơn giản, an toàn, tuân thủ chặt chẽ kiến trúc Monolith nguyên thủy.
Ưu tiên: Security (chống SQL Injection) > Correctness (tuân thủ nghiệp vụ) > Code sạch.
Câu hỏi trước khi code: "Code này có vi phạm luật cấm sử dụng Framework của môn học không?"

## 3. TECH STACK (STRICT — do not deviate)
Backend: Java JDK 17 + Java Servlet/JSP
Frontend: JSP + HTML + CSS + JavaScript
Database: Microsoft SQL Server
Database Access: JDBC + DAO Pattern
ORM: none
Auth: Session-based (`HttpSession`) + `@WebFilter` + Bcrypt (mã hóa mật khẩu)
Testing: JUnit 5
Styling: CSS3
Integrations: SendGrid/SMTP (Email), VNPAY (Payment API), OpenAI/Gemini API (AI Service)
Cấm tuyệt đối: Spring, Spring Boot, Hibernate, JPA hoặc bất kỳ ORM framework nào.

## 4. ARCHITECTURE PRINCIPLES
- Follow MVC (Controller - Service - DAO Pattern)
- API style: none
- Error handling: Sử dụng Custom Exception, không catch error rồi bỏ qua (swallow error).
- Data Access: Chỉ sử dụng PreparedStatement cho mọi thao tác CSDL. Tự quản lý Transaction (commit/rollback) thủ công.
- Async Processing: Mọi thao tác I/O chậm (Gửi OTP, Email qua SendGrid) phải chạy bất đồng bộ qua ExecutorService.
- External Services:
  - Payment System: mock payment gateway or integrated payment API (VNPAY)
  - Email System: JavaMail or external email API (SendGrid/SMTP)
  - AI Service: AI API for chatbot FAQ and book recommendation (OpenAI/Gemini)

## 5. PHẠM VI HOẠT ĐỘNG
### Được phép:
- Đọc và chỉnh sửa code trong `/src/java/` và `/web/`
- Chạy: JUnit tests, git status, git diff, git commit
- Tạo branch mới theo pattern: `feat/*`, `fix/*`, `spec/*`

### Cấm tuyệt đối:
- KHÔNG được đọc: `.env`, `*.secret`, `credentials/*`
- KHÔNG được commit trực tiếp vào `main` hoặc `production`
- KHÔNG được thay đổi lược đồ 20 bảng CSDL đã chốt mà không hỏi ý kiến Human
- KHÔNG được gọi external API ngoài danh sách: SendGrid, VNPAY, OpenAI/Gemini

## 6. FILE NAMING & STRUCTURE
Controllers: PascalCase + `Servlet` suffix (e.g., `LoginServlet.java`, `BorrowBookServlet.java`)
Models/Entities: PascalCase (e.g., `User.java`, `BorrowingRecord.java`)
Data Access: PascalCase + `DAO` suffix (e.g., `BookDAO.java`)
Views (JSP): kebab-case (e.g., `book-list.jsp`, `dashboard-admin.jsp`)
DB tables: snake_case (e.g., `borrowing_record`, `system_configuration`)

## 7. FORBIDDEN PATTERNS
- NEVER lưu mật khẩu dưới dạng plaintext trong Database (Phải dùng Bcrypt).
- NEVER sử dụng String Concatenation (`+`) trong SQL queries (BẮT BUỘC dùng `PreparedStatement` để chống SQL Injection).
- NEVER hardcode API keys (VNPAY, OpenAI, SMTP) trong source code. Phải đọc từ biến môi trường (`.env`) hoặc bảng `System_Configuration`.
- NEVER bỏ qua bộ lọc `@WebFilter` đối với các URL yêu cầu phân quyền (`/admin/*`, `/librarian/*`, `/student/*`).
- NEVER thực hiện Hard-delete (xóa cứng) các giao dịch cốt lõi (Borrowing_Record, Fine, Payment). Chỉ dùng Soft-delete (cập nhật status) hoặc giữ nguyên để phục vụ Audit Log.
- NEVER bỏ qua việc ghi log (AuditLog) cho các thao tác Create/Update/Delete quan trọng.

## 8. XỬ LÝ TÌNH HUỐNG
- Nếu không chắc chắn về nghiệp vụ → HỎI Human thay vì đoán.
- Trước khi refactor file > 200 dòng → Tạo backup hoặc thông báo Human.
- Gặp code sử dụng pattern cấm (String concatenation SQL) → Từ chối implement, sửa lại bằng PreparedStatement, và giải thích lý do.
- Thấy lỗ hổng bảo mật → Tự động từ chối implement và sửa lại trước khi tiếp tục.
- Gặp xung đột giữa performance và security → Ưu tiên security.

## 9. DEFINITION OF DONE (per task)
- [ ] Logic Java biên dịch thành công, không có Warning hoặc Error.
- [ ] Unit tests (JUnit) được viết cho Business Logic và DAOs (tối thiểu coverage cho happy path).
- [ ] Phân quyền RBAC (Role-Based Access Control) hoạt động đúng cho module vừa tạo.
- [ ] Audit Log được ghi lại (`INSERT` vào bảng `Audit_Log`) đối với các thao tác Create/Update/Delete quan trọng.
- [ ] Giao diện hiển thị đúng dữ liệu lấy từ DB và xử lý tốt lỗi (hiển thị thông báo thân thiện).
- [ ] Không để lại `System.out.println` hoặc `TODO` comments trong code được commit.

## 10. GIT CONVENTIONS
Branch: `feat/[feature-name]` | `fix/[bug-name]` | `spec/[feature-name]`
Commit: `[type]: [scope] - [description]`
Example: `feat(borrow): implement transaction logic for borrowing books`

## 11. CURRENT SPRINT CONTEXT
Sprint: Milestone 2 (Core Transaction Flow)
Focus: Xây dựng tính năng Xác thực bảo mật (Login/OTP/Filter) và Luồng giao dịch lõi (Tìm sách, Mượn sách, Trả sách, Tính phạt).

## 12. NGỮ CẢNH DỰ ÁN
- Đọc `.agents/CONTEXT.md` để biết kiến trúc chi tiết, Core Transaction Flow, và Lessons Learned.
- Active specs: xem `/.sdd/specs/` để biết danh sách spec đang code.
