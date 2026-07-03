# PROJECT CONSTITUTION — LMS Library Management System
# Version: 1.2.0 | Owner: @tech-lead | Updated: 2026-06-06
# Status: LOCKED — Chỉ được phép thay đổi qua RFC process có chữ ký của Human
# Áp dụng cho: Mọi AI Agent, mọi Developer, mọi Pull Request của dự án LMS

═══════════════════════════════════════════════
  LAYER 1: HARD RULES — KHÔNG BAO GIỜ VI PHẠM
═══════════════════════════════════════════════

## SEC-01: Bảo mật thông tin & Cấm Hardcode
* THE system SHALL NOT lưu bất kỳ secret, API Key hay thông tin nhạy cảm nào dưới dạng plaintext trong source code, JSP, Java class hay database plaintext.
* Các khóa như `vnp_HashSecret`, `SendGrid_API_Key`, `OpenAI_API_Key` bắt buộc phải lưu trong file cấu hình môi trường `.env` hoặc mã hóa an toàn khi lưu trữ.
* Enforcement: Tự động quét và block Pull Request nếu phát hiện chuỗi nghi vấn.

## SEC-02: Phân quyền & Chặn truy cập trái phép
* THE system SHALL bắt buộc xác thực (Authentication) và phân quyền (Authorization) bằng `HttpSession` kết hợp `@WebFilter` cho mọi yêu cầu truy cập tài nguyên thuộc các vùng: `/admin/*`, `/librarian/*`, `/manager/*`, `/student/*`.
* Mọi hành vi bypass filter hoặc truy cập trái phép vai trò (Role-Based Access Control) phải bị block ngay lập tức và trả về trang báo lỗi `403 Forbidden`.

## SEC-03: Chống SQL Injection tuyệt đối
* THE system SHALL sử dụng JDBC `PreparedStatement` kết hợp parameterize (?) cho **mọi câu truy vấn SQL** tương tác với cơ sở dữ liệu.
* TUYỆT ĐỐI NGHIÊM CẤM sử dụng phép cộng chuỗi (String Concatenation) để chèn user input trực tiếp vào câu lệnh SQL. 

## DATA-01: Soft-Delete cho các giao dịch cốt lõi
* THE system SHALL sử dụng cơ chế Soft-delete (cập nhật trạng thái `status` thành `'inactive'`, `'cancelled'`, `'lost'`,...) thay vì dùng câu lệnh `DELETE FROM` SQL cho các bảng dữ liệu giao dịch cốt lõi (`"User"`, `Book`, `BookCopy`, `BorrowRecord`, `Fine`, `Payment`, `Reservation`).
* Hard-delete chỉ được phép áp dụng cho các file tạm (temporary files) hoặc dữ liệu log hệ thống vượt quá 90 ngày.

## DB-01: Ràng buộc PostgreSQL & Supabase
* **Bắt buộc viết `"User"` có nháy kép**: Vì `User` là từ khóa hệ thống của PostgreSQL, các truy vấn SQL tác động lên bảng này phải viết rõ dạng `"User"`. Các bảng khác tuyệt đối không bọc nháy kép để tránh lỗi phân biệt hoa/thường (`relation does not exist`).
* **Cấu hình Pooler cổng 6543**: Để tránh lỗi không phân giải được IPv6 (`UnknownHostException`), JDBC kết nối qua cổng **6543** (Transaction/Session Pooler) của Supabase để được hỗ trợ định tuyến IPv4 mặc định.
* **Cột processedBy trong Payment**: Cột được lưu thực tế là `processedBy INT NULL`. Mã nguồn Java (DAO, DTO, Model) cần map chính xác với tên này.
* **Hàm thời gian**: Sử dụng hàm `NOW()` hoặc `CURRENT_TIMESTAMP` của PostgreSQL thay cho `GETDATE()` của SQL Server.
* **Driver JDBC**: Sử dụng driver `org.postgresql.Driver` thay thế hoàn toàn cho SQL Server Driver.

═══════════════════════════════════════════════
  LAYER 2: ARCHITECTURAL CONSTRAINTS
═══════════════════════════════════════════════

## ARCH-01: Kiến trúc Monolith MVC thuần và cấm Framework
* THE system SHALL tuân thủ mô hình Model-View-Controller (MVC) nguyên thủy:
  * **Model:** Chứa Java Beans và DTO.
  * **View:** Sử dụng JSP kết hợp JSTL và EL (cấm viết code Java `<% %>` trực tiếp trong JSP).
  * **Controller:** Chỉ sử dụng Java Servlet (`HttpServlet`).
* TUYỆT ĐỐI NGHIÊM CẤM sử dụng các framework như Spring, Spring Boot, Hibernate, JPA, MyBatis hoặc bất kỳ công cụ ORM nào khác ngoài JDBC thuần của Java JDK.

## ARCH-02: Ghi nhật ký hệ thống (Audit Logs) bắt buộc
* THE system SHALL tự động ghi nhận vết (Audit Logs) vào bảng `AuditLogs` đối với mọi thao tác Create, Update, Delete (C/U/D) quan trọng, bao gồm: mượn sách, trả sách, tạo phạt, thanh toán phạt, thay đổi cấu hình hệ thống, và khóa/mở khóa tài khoản thành viên.
* Bản ghi nhật ký hệ thống là bất biến, không một vai trò nào (kể cả Admin) được quyền sửa hoặc xóa.

## ARCH-03: Bất đồng bộ hóa (Async) cho I/O chậm
* THE system SHALL thực thi bất đồng bộ thông qua `ExecutorService` cho các tác vụ I/O chậm như gửi mã OTP qua email, gửi email thông báo nhắc nợ phạt hoặc sắp đến hạn trả sách. 
* Cấm thực hiện đồng bộ (Sync) các dịch vụ email bên thứ ba trực tiếp trong HTTP Request Thread vì có thể làm đơ/treo giao diện người dùng.

═══════════════════════════════════════════════
  LAYER 3: ENGINEERING STANDARDS
═══════════════════════════════════════════════

## ENG-01: Triết lý thiết kế và Clean Code
* Thiết kế mã nguồn đơn giản, tường minh (Explicit over Implicit).
* Đóng gói kết nối CSDL và giải phóng tài nguyên (`Connection`, `PreparedStatement`, `ResultSet`) ngay lập tức trong khối `finally` hoặc dùng cú pháp try-with-resources để tránh rò rỉ bộ nhớ (connection leak).

## ENG-02: Naming Conventions thống nhất
* Tên bảng CSDL: **PascalCase** (`BorrowRecord`, `SystemConfigurations`).
* Tên cột CSDL: **camelCase** (`userId`, `passwordHash`, `startDate`).
* Tên Class Java: **PascalCase** với hậu tố tương ứng (`LoginServlet`, `BookDAO`, `User`).
* Tên file View: **kebab-case** JSP (`book-list.jsp`).

## ENG-03: Quản lý lỗi & Phản hồi an toàn
* THE system SHALL NOT hiển thị stack trace lỗi hệ thống hoặc chi tiết SQL trực tiếp ra màn hình giao diện của người dùng.
* Mọi lỗi phải được log chi tiết ở phía server và hiển thị thông báo lỗi thân thiện, dễ hiểu cho người dùng ở client kèm theo mã lỗi (error code) để hỗ trợ truy vết.

## ENG-04: Chia nhỏ file để dễ bảo trì
* THE system SHALL bắt buộc chia nhỏ các file source code (Java Class, JSP, CSS, JS) thành các component, fragment hoặc helper class nhỏ gọn, có tính chuyên biệt cao (Single Responsibility).
* TUYỆT ĐỐI NGHIÊM CẤM viết các file quá dài hoặc ôm đồm quá nhiều logic/giao diện phức tạp. Trong JSP, sử dụng `<jsp:include>` hoặc `@include` để tách biệt các thành phần giao diện dùng chung hoặc các khối hiển thị độc lập.

═══════════════════════════════════════════════
  AI AGENT SELF-CHECK PROTOCOL
═══════════════════════════════════════════════

### Trước khi submit bất kỳ thay đổi nào, AI Agent PHẢI tự động chạy Checklist sau:

* **CHECKLIST SECURITY (Bảo mật):**
  - [ ] Không có API keys hay mật khẩu plaintext bị hardcode trong source code.
  - [ ] Mọi Servlet thay đổi dữ liệu đều được bảo vệ bởi Filter kiểm tra quyền (RBAC).
  - [ ] Mọi câu SQL tương tác DB đều dùng `PreparedStatement` với dấu `?` (Không có cộng chuỗi).
* **CHECKLIST ARCHITECTURE (Kiến trúc):**
  - [ ] Không sử dụng bất cứ thư viện Framework cấm nào (Spring, Hibernate, JPA).
  - [ ] Mọi hành động C/U/D dữ liệu cốt lõi đều được ghi Audit Log thành công.
  - [ ] Các I/O chậm (Gửi OTP, gửi email) chạy async qua `ExecutorService`.
* **CHECKLIST ENGINEERING (Kỹ thuật):**
  - [ ] Tên bảng dạng PascalCase, tên cột dạng camelCase, tên JSP dạng kebab-case.
  - [ ] Mọi kết nối CSDL đều được đóng an toàn bằng try-with-resources hoặc khối `finally`.
  - [ ] Trả về thông báo lỗi thân thiện, không in stack trace ra màn hình giao diện.
  - [ ] Các file code (JSP fragments, Java classes, CSS, JS) được chia nhỏ hợp lý và không ôm đồm nhiều nhiệm vụ.
  - [ ] Bảng `"User"` bắt buộc được bọc nháy kép trong các câu lệnh SQL, các bảng khác không bọc.
  - [ ] Sử dụng hàm `NOW()` hoặc `CURRENT_TIMESTAMP` thay thế hoàn toàn cho `GETDATE()`.
  - [ ] Cấu hình kết nối DB qua cổng 6543 (Supabase Transaction Pooler) và driver `org.postgresql.Driver`.
  - [ ] Cột `processedBy` trong Payment/DAO/DTO được đặt đúng camelCase (chữ B viết thường: `processedBy`).

### Quy trình xử lý vi phạm:
Nếu phát hiện vi phạm Hiến pháp trong codebase:
1. **AI Agent SHALL** dừng công việc, từ chối triển khai tiếp.
2. **AI Agent SHALL** gửi thông báo vi phạm cụ thể cho Human: `[CONSTITUTION VIOLATION] Rule: {ID} tại File: {path}, Line: {line}.`
3. **AI Agent SHALL** tự động sửa lỗi vi phạm trước khi tiếp tục thực hiện yêu cầu mới của Human.
