# CLAUDE.md — Claude Code Project Memory
# Đọc file AGENTS.md ở root và .agents/AGENTS.md trước để hiểu full project context

## 1. MANUAL MEMORY (human-maintained)

### Architecture Decisions (ADR)
* **ADR-001: Java Web Monolith thuần**
  * Lý do: Yêu cầu bắt buộc của môn học (SWP391 Milestone 2) cấm sử dụng Spring Boot, Hibernate, JPA. Sử dụng Java Servlet/JSP + JDBC thuần để đạt điểm tối đa.
* **ADR-002: Authentication & RBAC thông qua Session và WebFilter**
  * Lý do: Sử dụng `HttpSession` để lưu thông tin đăng nhập và viết `@WebFilter` bảo vệ các thư mục `/student/*`, `/librarian/*`, `/manager/*`, `/admin/*`. Chặn bypass filter tuyệt đối.
* **ADR-003: Chống SQL Injection triệt để bằng PreparedStatement**
  * Lý do: Triệt tiêu hoàn toàn lỗi SQL Injection. Cấm sử dụng String Concatenation khi tạo câu truy vấn SQL.
* **ADR-004: Bất đồng bộ hóa (Async) cho I/O chậm**
  * Lý do: Gửi OTP, email qua SMTP/SendGrid tốn từ 2-5 giây. Bắt buộc chạy bất đồng bộ qua `ExecutorService` của Java để tránh làm treo luồng HTTP Request của người dùng.
* **ADR-005: Đồng bộ hóa Naming Database**
  * Lý do: Bảng đặt theo dạng `PascalCase` (ví dụ `BorrowRecord`, `SystemConfigurations`), còn cột đặt theo dạng `camelCase` (ví dụ `userId`, `passwordHash`) để đồng bộ hoàn hảo với các thực thể Java (Java Beans).

### Lessons Learned (từ các pha review và sửa lỗi)
* **LESSON-001: Phạt trễ hạn và lệch kiểu dữ liệu ngày tháng**
  * Luôn sử dụng kiểu dữ liệu `DATETIME` cho ngày mượn (`startDate`), ngày hẹn trả (`endDate`) và ngày trả thực tế (`returnedAt`) để tránh lỗi làm tròn ngày gây phạt oan sinh viên khi so sánh trực tiếp.
* **LESSON-002: Thiết kế Cấu hình tập trung (Centralized Config)**
  * Thay vì tách bảng `LibraryConfigurations` vật lý gây dư thừa DAO/Model, sử dụng duy nhất một bảng `SystemConfigurations` và phân loại bằng cột `configGroup` ('system' hoặc 'library') rồi phân quyền ở tầng Servlet.
* **LESSON-003: Ràng buộc duy nhất cho mã vạch (Barcode)**
  * Bắt buộc khai báo `UNIQUE` cho trường `barcode` trong `BookCopy` để tránh lỗi trùng mã sách khi thủ thư quét mã vạch làm thủ tục mượn/trả.
* **LESSON-004: Bất cập Schema SQL cố định (SQL Schema Quirks)**
  * Bảng sách thực tế là `Book` (số ít), nhưng các bảng khác tham chiếu ngoại tới `Books(bookId)`. Bắt buộc dùng tên bảng thực tế `Book`, class entity là `Book.java` và DAO là `BookDAO.java`.
  * Cột trong bảng `Payment` thực tế là `processedBy`, nhưng khóa ngoại viết nhầm là `processBy`. Bắt buộc dùng `processedBy` trong Java.
  * Bảng `DocumentTemp` (21 bảng) dùng để quản lý các mẫu email thông báo, được quản lý bởi `LibraryManager`.

### Current Sprint Notes
* **Sprint:** Milestone 2 (Core Transaction Flow).
* **Focus:** Hoàn thiện luồng Xác thực bảo mật (Login/OTP/Filter) và luồng giao dịch cốt lõi (Tìm sách, đặt trước, mượn sách, trả sách và tính tiền phạt).
* **Next:** Implement `SystemConfigServlet` hỗ trợ phân quyền nhóm cấu hình cho Admin và Library Manager.

## 2. PATTERNS TO FOLLOW
* **DAO Pattern:** Viết trong `/src/java/dao/[Name]DAO.java`. Tự quản lý connection, commit/rollback thủ công bằng JDBC PreparedStatement.
* **Entity/Model Pattern:** Viết trong `/src/java/model/[Name].java` (đặt tên PascalCase, các thuộc tính map chuẩn camelCase với Database).
* **Controller/Servlet Pattern:** Viết trong `/src/java/controller/[Name]Servlet.java` (kèm annotation `@WebServlet`).
* **View JSP Pattern:** Đặt trong `/web/WEB-INF/views/[sub-folder]/[name-kebab-case].jsp`. Dùng JSTL để hiển thị dữ liệu động, tránh viết mã Java scriptlet (`<% %>`) trực tiếp trong JSP.

## 3. AUTO MEMORY (Claude Code appends here)
# [Claude Code tự động thêm các entry tại đây khi làm việc]
