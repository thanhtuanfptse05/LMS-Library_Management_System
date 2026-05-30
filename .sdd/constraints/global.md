# .sdd/constraints/global.md
# Owner: @tech-lead | Phiên bản: 1.1.0 | Trạng thái: LOCKED

## 1. TECHNOLOGY STACK (Không thay đổi trừ khi có RFC được duyệt)

### Backend
* **Language:** Java JDK 17
* **HTTP Servlets:** Java Servlet Specification 4.0 / 5.0 (Jakarta/javax.servlet-api)
* **Database Driver:** Microsoft JDBC Driver for SQL Server (`mssql-jdbc`)
* **Database Access:** JDBC API thuần (`java.sql.Connection`, `java.sql.PreparedStatement`, `java.sql.ResultSet`)
* **Logging:** SLF4J + Logback (hoặc `java.util.logging`) để ghi log cấu trúc
* **Testing:** JUnit 5.x cho kiểm thử đơn vị (Unit testing)

### Frontend
* **View Engine:** JSP (Java Server Pages) 2.3+ kết hợp JSTL (JavaServer Pages Standard Tag Library 1.2+) và EL (Expression Language).
* **Styling & Layout:** CSS3 thuần (Vanilla CSS) đảm bảo responsive, tối ưu giao diện premium.
* **Client Logic:** Vanilla JavaScript (ES6+), Ajax tương tác không tải lại trang.

### Infrastructure & Server
* **Servlet Container:** Apache Tomcat 9.0.x (hoặc Tomcat 10.x tương ứng thư viện Jakarta)
* **Build Tool:** Maven (hoặc cấu hình NetBeans Ant Project chuẩn)

---

## 2. NAMING CONVENTIONS (Quy tắc đặt tên bắt buộc)
* **DB Tables (Tên bảng CSDL):** **PascalCase** (ví dụ: `BorrowRecord`, `SystemConfigurations`, `AuditLogs`).
* **DB Columns (Tên cột CSDL):** **camelCase** (ví dụ: `userId`, `passwordHash`, `startDate`, `returnedAt`).
* **Java Classes (Tên Class Java):**
  * Controllers: **PascalCase** + hậu tố `Servlet` (ví dụ: `LoginServlet.java`, `BorrowBookServlet.java`).
  * Data Access: **PascalCase** + hậu tố `DAO` (ví dụ: `BookDAO.java`, `UserDAO.java`).
  * Models/Entities: **PascalCase** tương ứng tên bảng (ví dụ: `User.java`, `BorrowRecord.java`, `Book.java`, `DocumentTemp.java`).
* **View Files (Tên file JSP):** **kebab-case** đặt trong `WEB-INF/views/[sub-folder]/` (ví dụ: `book-list.jsp`, `manage-configs.jsp`).
* **Java Variables & Methods:** **camelCase** (ví dụ: `failedLoginAttempts`, `getUserById()`).
* **Java Constants:** **SCREAMING_SNAKE_CASE** (ví dụ: `MAX_BORROW_LIMIT`).

> [!IMPORTANT]
> **Lưu ý đặc biệt về lỗi/bất cập trong SQL Schema (CẤM SỬA FILE SQL):**
> * **Bảng sách `Book`:** File SQL tạo bảng là `Book` (số ít), nhưng các ràng buộc khóa ngoại (Foreign Keys) ở các bảng khác lại tham chiếu nhầm tới `Books(bookId)`. Java code bắt buộc dùng tên bảng thực tế là `Book`, class thực thể là `Book.java` và DAO là `BookDAO.java` (không đặt tên là `Books`).
> * **Cột trong bảng `Payment`:** Cột thực tế là `processedBy`, nhưng khóa ngoại viết sai thành `processBy`. Java code bắt buộc map với trường `processedBy`.
> * **Bảng mẫu email `DocumentTemp`:** Được thêm vào CSDL để quản lý các mẫu email thông báo gửi cho người dùng, tổng cộng là 21 bảng.

---

## 3. APPROVED EXTERNAL PACKAGES (Danh sách thư viện được phép dùng)
Dưới đây là danh sách các thư viện bên ngoài duy nhất được chấp thuận sử dụng trong dự án:
1. `org.mindrot:jbcrypt` - Thư viện mã hóa và khớp mật khẩu bảo mật BCrypt.
2. `com.microsoft.sqlserver:mssql-jdbc` - Driver kết nối Microsoft SQL Server qua JDBC.
3. `javax.servlet:jstl` (hoặc `jakarta.servlet.jsp.jstl`) - Thư viện thẻ tiêu chuẩn cho JSP.
4. `com.google.code.gson:gson` (hoặc Jackson) - Xử lý dữ liệu JSON (được phép dùng khi trả dữ liệu AJAX hoặc Audit Log).
5. `com.sendgrid:sendgrid-java` (hoặc `javax.mail`) - Gửi OTP và email bất đồng bộ qua SendGrid SMTP.

---

## 4. BANNED PACKAGES & FRAMEWORKS (Danh sách cấm tuyệt đối)
Bất kỳ AI Agent hay Developer nào sử dụng các công nghệ dưới đây đều bị coi là **Vi phạm Hiến pháp nghiêm trọng** và code sẽ bị từ chối biên dịch/merge:
1. **Spring & Spring Boot (Mọi module):** `spring-core`, `spring-web`, `spring-security`, `spring-data-jpa`...
2. **ORMs & Cấu trúc tương tự:** Hibernate, JPA (`javax.persistence`), MyBatis.
3. **Template Engine khác JSP:** Thymeleaf, FreeMarker, Velocity.
4. **Framework bảo mật:** Spring Security, Apache Shiro (bắt buộc tự viết logic WebFilter).

---

## 5. QUY TRÌNH THÊM THƯ VIỆN MỚI
Nếu cần thêm một thư viện ngoài danh sách được phê duyệt:
1. Tạo một tài liệu RFC nhỏ giải trình lý do tại sao stdlib của Java JDK hoặc các thư viện hiện có không giải quyết được.
2. Nhận sự phê duyệt chính thức bằng văn bản (hoặc gõ APPROVE) từ Human.
3. Thêm thư viện vào `pom.xml` (hoặc thư mục `lib/` của Ant) và cập nhật file `global.md` này.