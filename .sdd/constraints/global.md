# .sdd/constraints/global.md
# Owner: @tech-lead | Version: 2.0.0 | Project: Library Management System (LMS)

## TECHNOLOGY STACK (Immutable — không thay đổi trừ khi có RFC)

### Backend
Language:   Java JDK 17
Framework:  Java Servlet & JSP (MVC thuần — KHÔNG Spring/Spring Boot)
Database:   Microsoft SQL Server
Data Access: JDBC thuần kết hợp DAO Pattern (PreparedStatement only)
Auth:       Session-based (`HttpSession`) + `@WebFilter` + BCrypt (mã hóa mật khẩu)
Testing:    JUnit 5

### Frontend
View Engine: JSP + JSTL/EL
Styling:    HTML5, CSS3, JavaScript (Vanilla)
JSP Path:   `/WEB-INF/views/` (ẩn dưới WEB-INF để bảo mật)

### Integrations
Payment:    VNPAY (Sandbox) — Thanh toán phạt trực tuyến
Email:      SendGrid / JavaMail SMTP — Gửi OTP, nhắc hạn, thông báo
AI:         OpenAI / Gemini API — Gợi ý sách cá nhân hóa

### Infrastructure
IDE:        NetBeans (Project structure theo NetBeans conventions)
Server:     Apache Tomcat
Build:      Ant (build.xml)

## NAMING CONVENTIONS
Servlets (Controller):  PascalCase + hậu tố `Servlet` (VD: `BorrowBookServlet.java`)
Services:               PascalCase + hậu tố `Service` (VD: `BorrowService.java`)
DAOs:                   PascalCase + hậu tố `DAO` (VD: `BookDAO.java`)
Entities/Models:        PascalCase (VD: `BorrowRecord.java`, `User.java`)
JSP (Views):            kebab-case (VD: `book-list.jsp`, `dashboard-admin.jsp`)
Database Tables:        PascalCase hoặc snake_case theo schema hiện tại
                        (Xem: `database/LMS_Library_Management_System.sql`)
                        VD: `SystemConfigurations`, `BorrowRecord`, `BookCopy`
Database Columns:       camelCase hoặc snake_case theo schema hiện tại
                        VD: `borrowRecordId`, `start_date`, `available_quantity`

## APPROVED EXTERNAL PACKAGES (Danh sách cho phép)
Microsoft JDBC Driver for SQL Server    # Kết nối Database
JBcrypt                                 # Băm mật khẩu BCrypt
JavaMail API + Activation Framework     # Gửi email SMTP
VNPAY SDK (Sandbox)                     # Thanh toán trực tuyến
HTTP Client (java.net.http)             # Gọi API OpenAI/Gemini
JUnit 5                                 # Unit Testing
JSTL                                    # JSP Standard Tag Library

## BANNED PACKAGES / TECHNOLOGIES (Tối kỵ — với lý do)
Spring Boot / Spring MVC:       Bị cấm vì vi phạm yêu cầu MVC thuần của môn SWP391 (ADR-003)
Hibernate / JPA / bất kỳ ORM:   Bị cấm vì bắt buộc dùng JDBC thuần (ADR-001)
Statement (trong JDBC):         Cấm tuyệt đối. Bắt buộc dùng `PreparedStatement` chống SQL Injection
Lombok:                         Tránh dùng — viết getter/setter thủ công cho rõ ràng

## ADDING NEW PACKAGES
Quy trình: Đề xuất với justification → tech lead approve → update file này.
Agent KHÔNG được add package/jar mà không có human approval.