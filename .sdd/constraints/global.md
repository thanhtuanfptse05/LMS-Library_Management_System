### .sdd/constraints/global.md
### Owner: @tech-lead | Project: Library Management System (LMS)

#### TECHNOLOGY STACK (Immutable)
- **Backend:** Java JDK 17, Java Servlet & JSP (MVC thuần).
- **Database:** Microsoft SQL Server.
- **Data Access:** JDBC thuần kết hợp DAO Pattern.
- **Frontend:** JSP, HTML, CSS, JavaScript (Vanilla).
- **Integrations:** VNPAY (Thanh toán), SendGrid/SMTP (Email), OpenAI/Gemini (AI).

#### NAMING CONVENTIONS
- **Servlets (Controller):** PascalCase + hậu tố Servlet (VD: `BorrowBookServlet.java`).
- **Services:** PascalCase + hậu tố Service (VD: `BorrowService.java`).
- **DAOs:** PascalCase + hậu tố DAO (VD: `BookDAO.java`).
- **Entities/Models:** PascalCase trùng tên bảng (VD: `BorrowRecord.java`).
- **JSP (Views):** kebab-case (VD: `book-list.jsp`).
- **Database Tables:** PascalCase hoặc snake_case tùy db_lms.txt (VD: `SystemConfigurations`, `BorrowRecord`).

#### BANNED PACKAGES / TECHNOLOGIES (Tối kỵ)
- **Spring Boot / Spring MVC:** Bị cấm vì vi phạm yêu cầu MVC thuần của môn học (ADR-003).
- **Hibernate / JPA / Bất kỳ ORM nào:** Bị cấm vì bắt buộc dùng JDBC thuần (ADR-001).
- **Statement (trong JDBC):** Cấm tuyệt đối. Bắt buộc dùng `PreparedStatement` để chống SQL Injection.

#### ADDING NEW PACKAGES
Không được tự ý thêm file `.jar` hoặc dependency vào `pom.xml` (nếu dùng Maven) mà không hỏi human.
 