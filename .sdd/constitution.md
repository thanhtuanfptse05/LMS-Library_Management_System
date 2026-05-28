# CONSTITUTION.md — Project Law: Library Management System (LMS)
# Ratified: [27/5/2026] | Team: [Group 6] | Version: 1.0
# RULE: Bất kỳ thay đổi nào trong file này đều cần sự đồng thuận của cả team và GVHD.

═══════════════════════════════════════════════════
  LAYER 1: HARD RULES — KHÔNG BAO GIỜ VI PHẠM (BLOCKING)
═══════════════════════════════════════════════════

## SEC-01: Password & Data Security
- THE system SHALL hash passwords bằng BCrypt. TUYỆT ĐỐI KHÔNG lưu plaintext password.
- API keys (VNPAY, SendGrid, OpenAI) PHẢI lưu trong `.env` hoặc `system_configuration`. TUYỆT ĐỐI KHÔNG hardcode trong source code.

## SEC-02: Authentication & Authorization
- Mọi endpoint bị giới hạn (dành cho Admin, Librarian, Manager, Student) PHẢI được bảo vệ bằng `@WebFilter` kiểm tra Session hợp lệ. TUYỆT ĐỐI KHÔNG bypass AuthFilter.

## SEC-03: SQL Injection Prevention (No ORM)
- THE system SHALL sử dụng JDBC thuần với `PreparedStatement` cho MỌI câu query. 
- TUYỆT ĐỐI KHÔNG dùng `Statement` hay nối chuỗi (string concatenation) để ghép tham số SQL.

## DATA-01: Soft-Delete Only cho Core Entities
- THE system SHALL sử dụng soft-delete (cập nhật status = inactive/deleted) cho các bảng lõi: `users`, `borrowing_record`, `fine`, `payment`, `reservation`.
- TUYỆT ĐỐI KHÔNG dùng lệnh `DELETE FROM` (Hard-delete) cho các bảng này để giữ toàn vẹn Audit Log.

═══════════════════════════════════════════════════
  LAYER 2: ARCHITECTURAL CONSTRAINTS
═══════════════════════════════════════════════════

## ARCH-01: Layer Boundaries (Pure MVC)
- THE system SHALL tuân thủ luồng: `Servlet (Controller)` -> `Service (Business Logic)` -> `DAO (Data Access)`.
- Servlet TUYỆT ĐỐI KHÔNG được gọi trực tiếp DAO mà phải đi qua Service layer.

## ARCH-02: Audit Trail (Nhật ký kiểm toán)
- Mọi thao tác Create/Update/Delete (C/U/D) quan trọng (mượn sách, trả sách, đóng phạt, đổi config) PHẢI gọi `AuditLogDAO.insert()` để ghi log bất biến.

## ARCH-03: AI Output is Advisory
- Mọi kết quả từ OpenAI/Gemini (Gợi ý sách, cảnh báo) chỉ mang tính tham khảo. Quá trình ra quyết định cuối cùng (như duyệt mượn) luôn phải do human xác nhận.

═══════════════════════════════════════════════════
  LAYER 3: ENGINEERING STANDARDS
═══════════════════════════════════════════════════

## TECH STACK (Immutable during SWP391)
- Backend: Java JDK 17, Java Servlet/JSP
- Database: Microsoft SQL Server (JDBC + DAO Pattern)
- Frontend: HTML/CSS/JS + JSP (JSTL/EL)
- Integrations: VNPAY (Sandbox), SendGrid, OpenAI.

## NAMING CONVENTIONS
- Servlet/Service/DAO/Model: `PascalCase` (VD: `BorrowBookServlet.java`)
- JSP View: `kebab-case` (VD: `book-list.jsp`)
- Database Tables/Columns: `snake_case` (VD: `borrowing_record`, `admin_id`).

## TESTING & QUALITY
- Unit Tests: Yêu cầu sử dụng JUnit cho các hàm tính toán phức tạp (VD: tính tiền phạt `FineCalculationService`).
- Error Handling: Dùng Custom Exception Pattern. Handle lỗi trả về JSP thân thiện, KHÔNG in Stack Trace ra giao diện người dùng.

═══════════════════════════════════════════════════
  AI AGENT SELF-CHECK PROTOCOL
═══════════════════════════════════════════════════
## TRƯỚC KHI SUBMIT BẤT KỲ CODE NÀO, AI PHẢI TỰ KIỂM TRA:
[ ] SEC-03: Có đang dùng PreparedStatement thay vì cộng chuỗi SQL không?
[ ] ARCH-01: Servlet có đang gọi thẳng DAO không? (Nếu có -> Sửa ngay sang gọi Service)
[ ] SEC-01: Có hardcode mật khẩu hay API key nào không?
[ ] DATA-01: Có dùng lệnh `DELETE` cứng cho User hay BorrowingRecord không?
[ ] ENG-01: Đã xóa toàn bộ System.out.println() và thay bằng Logger chưa?

AI SHALL báo cáo kết quả Self-Check này vào cuối câu trả lời. KHÔNG BAO GIỜ trả về code vi phạm Layer 1.