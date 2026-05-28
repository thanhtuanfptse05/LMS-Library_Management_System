# AGENTS.md — Project Context for AI Agents
# Version: 1.0 | Updated: [27/5/2026] | Project: [LMS-Library Management System]
## 1. PROJECT OVERVIEW
Name: [Library Management System]
Type: [Web App]
Domain: [Library]
Stage: [Development / Testing / Production]
## 2. TECH STACK (STRICT — do not deviate)
Backend: Java JDK 17 + Java Servlet/JSP
Frontend: JSP + HTML + CSS + JavaScript
Database: Microsoft SQL Server
Database Access: JDBC + DAO Pattern
ORM: none
Auth: Session-based (`HttpSession`) + `@WebFilter` + Bcrypt (mã hóa mật khẩu)
Testing: JUnit 5
Styling: CSS3
Integrations: SendGrid/SMTP (Email), VNPAY (Payment API), OpenAI/Gemini API (AI Service)
## 3. ARCHITECTURE PRINCIPLES
- Follow [MVC]
- API style: none
- Error handling: Sử dụng Custom Exception 
- External Services:
- Payment System: mock payment gateway or integrated payment API
- Email System: JavaMail or external email API
- AI Service: AI API for chatbot FAQ and book recommendation
## 4. FILE NAMING & STRUCTURE
Controllers: PascalCase + `Servlet` suffix (e.g., `LoginServlet.java`, `BorrowBookServlet.java`)
Models/Entities: PascalCase (e.g., `User.java`, `BorrowingRecord.java`)
Data Access: PascalCase + `DAO` suffix (e.g., `BookDAO.java`)
Views (JSP): kebab-case (e.g., `book-list.jsp`, `dashboard-admin.jsp`)
DB tables: snake_case (e.g., `borrowing_record`, `system_configuration`)
## 5. FORBIDDEN PATTERNS
- NEVER lưu mật khẩu dưới dạng plaintext trong Database (Phải dùng Bcrypt).
- NEVER sử dụng String Concatenation (`+`) trong SQL queries (BẮT BUỘC dùng `PreparedStatement` để chống SQL Injection).
- NEVER hardcode API keys (VNPAY, OpenAI, SMTP) trong source code. Phải đọc từ biến môi trường (`.env`) hoặc bảng `System_Configuration`.
- NEVER bỏ qua bộ lọc `@WebFilter` đối với các URL yêu cầu phân quyền (`/admin/*`, `/librarian/*`, `/student/*`).
- NEVER thực hiện Hard-delete (xóa cứng) các giao dịch cốt lõi (Borrowing_Record, Fine, Payment). Chỉ dùng Soft-delete (cập nhật status) hoặc giữ nguyên để phục vụ Audit Log.
## 6. DEFINITION OF DONE (per task)
- [ ] Logic Java biên dịch thành công, không có Warning hoặc Error.
- [ ] Unit tests (JUnit) được viết cho Business Logic và DAOs (tối thiểu coverage cho happy path).
- [ ] Phân quyền RBAC (Role-Based Access Control) hoạt động đúng cho module vừa tạo.
- [ ] Audit Log được ghi lại (`INSERT` vào bảng `Audit_Log`) đối với các thao tác Create/Update/Delete quan trọng.
- [ ] Giao diện hiển thị đúng dữ liệu lấy từ DB và xử lý tốt lỗi (hiển thị thông báo thân thiện).
- [ ] Không để lại `System.out.println` hoặc `TODO` comments trong code được commit.
## 7. GIT CONVENTIONS
Branch: feat/[feature-name] | fix/[bug-name] | spec/[feature-name]
Commit: [type]: [scope] - [description]
Example: feat(borrow): implement transaction logic for borrowing books
## 8. CURRENT SPRINT CONTEXT
Sprint: Milestone 2 (Core Transaction Flow)
Focus: Xây dựng tính năng Xác thực bảo mật (Login/OTP/Filter) và Luồng giao dịch lõi (Tìm sách, Mượn sách, Trả sách, Tính phạt).
Active specs: [Danh sách file spec đang code, ví dụ: /.sdd/specs/borrow-book/SPEC.md]


