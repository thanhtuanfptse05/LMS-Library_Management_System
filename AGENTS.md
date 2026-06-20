# AGENTS.md — Project Context for AI Agents
# Version: 1.2.0 | Updated: 2026-06-06 | Project: LMS-Library Management System

## 1. PROJECT OVERVIEW
* **Name:** Library Management System (LMS)
* **Type:** Monolith Java Web App
* **Domain:** Library Management — Quản lý mượn/trả sách trường đại học
* **Stage:** Development (SWP391 — Milestone 2)

## 2. TECH STACK (STRICT — do not deviate)
* **Backend:** Java JDK 17 + Java Servlet (Servlet 4.0/5.0)
* **Frontend:** JSP (Java Server Pages) + HTML5 + CSS3 + Vanilla JavaScript
* **Database:** PostgreSQL (Supabase)
* **Database Access:** JDBC + DAO Pattern (Không dùng Spring JDBC, không ORM)
* **ORM:** None (Tuyệt đối không dùng Hibernate, JPA, MyBatis)
* **Auth:** Session-based (`HttpSession`) + `@WebFilter` + BCrypt (mã hóa mật khẩu)
* **Testing:** JUnit 5
* **Integrations:** SendGrid/SMTP (Email), SePay (Payment API), OpenAI/Gemini API (AI Service)

## 3. ARCHITECTURE PRINCIPLES
* **Model-View-Controller (MVC) Pattern:**
  * **Model:** Chứa các entity thuần và DTO (Data Transfer Objects).
  * **View:** Sử dụng các file JSP kết hợp JSTL và EL. Cấm viết Scriptlet Java `<% %>` trong JSP.
  * **Controller:** Các Servlet tiếp nhận request, gọi Service/DAO xử lý và forward dữ liệu sang JSP.
* **File Splitting & Modularity (Chia nhỏ file):** Bắt buộc chia nhỏ các file (JSP, CSS, JS, Java Class) thành các thành phần (components/fragments/helper classes) nhỏ gọn, chuyên biệt, tránh để một file quá dài hoặc ôm đồm nhiều nhiệm vụ để dễ bảo trì và tái sử dụng. Sử dụng cơ chế `<jsp:include>` hoặc `@include` trong JSP để tách các phần giao diện dùng chung (như header, footer, sidebar, head).
* **Error Handling:** Sử dụng custom Exception (ví dụ: `DatabaseException`, `ValidationException`). Cấm nuốt lỗi (catch error rồi bỏ qua).
* **Data Access:** Chỉ sử dụng `PreparedStatement` và parameterize mọi đầu vào để chống SQL Injection. Tự quản lý `Connection` và Transaction (commit/rollback) thủ công.
* **Async Processing:** Các tác vụ I/O chậm (Gửi OTP qua email, Gửi email báo phạt) phải chạy bất đồng bộ thông qua `ExecutorService` của Java.

## 4. FILE NAMING & STRUCTURE
* **Controllers:** PascalCase + `Servlet` suffix (ví dụ: `LoginServlet.java`, `BorrowBookServlet.java`)
* **Models/Entities:** PascalCase (ví dụ: `User.java`, `BorrowRecord.java`)
* **Data Access:** PascalCase + `DAO` suffix (ví dụ: `BookDAO.java`, `UserDAO.java`)
* **Views (JSP):** kebab-case (ví dụ: `book-list.jsp`, `dashboard-admin.jsp`)
* **DB Tables:** PascalCase (ví dụ: `BorrowRecord`, `SystemConfigurations`)
* **DB Columns:** camelCase (ví dụ: `userId`, `passwordHash`, `startDate`)

## 5. FORBIDDEN PATTERNS (Cấm tuyệt đối)
* **SEC-01 (Bảo mật):** KHÔNG bao giờ lưu mật khẩu dưới dạng plaintext hoặc mã hóa đơn giản (MD5, SHA). Bắt buộc dùng BCrypt.
* **SEC-02 (Phân quyền):** KHÔNG bypass `@WebFilter` bảo vệ các thư mục `/admin/*`, `/librarian/*`, `/manager/*`, `/student/*`.
* **SEC-03 (Bảo mật SQL):** KHÔNG dùng phép cộng chuỗi (String Concatenation) để tạo câu lệnh SQL. Bắt buộc dùng PreparedStatement.
* **DATA-01 (An toàn dữ liệu):** KHÔNG Hard-delete (DELETE SQL) các giao dịch cốt lõi. Sử dụng Soft-delete bằng cách cập nhật cột `status`.
* **ARCH-02 (Ghi nhật ký):** KHÔNG bỏ qua Audit Log cho các thao tác C/U/D (Create/Update/Delete) quan trọng.
* **UI-01 (Ngôn ngữ giao diện):** KHÔNG viết giao diện người dùng bằng tiếng Anh hoặc ngôn ngữ khác. Bắt buộc sinh giao diện (JSP, HTML, thông báo lỗi, thông báo thành công, nhãn) hoàn toàn bằng **tiếng Việt (100% Vietnamese)**.
* **DB-01 (Kiểm tra Schema CSDL):** Bắt buộc đọc và kiểm tra tệp schema CSDL mới tại [LMS_Schema_PostgreSQL.sql](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/database/supabase/LMS_Schema_PostgreSQL.sql) trước khi thao tác viết/sửa code Java Model và DAO để đảm bảo cấu trúc bảng và kiểu dữ liệu chính xác, tránh các giả định sai lệch nếu schema có sự thay đổi.

## 6. DEFINITION OF DONE (per task)
- [ ] Logic Java biên dịch thành công, không có Warning hoặc Error nghiêm trọng.
- [ ] Unit tests (JUnit) được viết cho Business Logic và các hàm DAO (tối thiểu coverage cho happy path).
- [ ] Phân quyền kiểm soát truy cập (RBAC) hoạt động đúng thông qua Filter bảo vệ.
- [ ] Ghi Audit Log (`INSERT` vào bảng `AuditLogs`) cho mọi thao tác Create/Update/Delete dữ liệu cốt lõi.
- [ ] Giao diện hiển thị đúng dữ liệu lấy từ DB và xử lý tốt lỗi (hiển thị thông báo thân thiện với người dùng).
- [ ] Không để lại mã lệnh debug `System.out.println` hoặc comments `TODO` trong code được commit.

## 7. GIT CONVENTIONS
* **Branch naming:** `feat/[feature-name]` \| `fix/[bug-name]` \| `spec/[feature-name]`
* **Commit message:** `[type]: [scope] - [description]`
  * *Ví dụ:* `feat(borrow): implement transaction logic for borrowing books`

## 8. CURRENT SPRINT CONTEXT
* **Sprint:** Milestone 2 (Core Transaction Flow)
* **Focus:** Thiết lập hệ thống Xác thực bảo mật (Login/OTP/Filter) và luồng giao dịch cốt lõi (Tìm sách, Mượn sách, Trả sách, Tính tiền phạt).
* **Active specs:** `/.sdd/specs/`

<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
<!-- SPECKIT END -->
