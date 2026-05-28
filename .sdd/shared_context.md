# .sdd/shared_context.md
# File này là NGUỒN SỰ THẬT CHUNG cho mọi agents trong dự án LMS
# Read bởi: Tất cả agents trước khi bắt đầu code JSP hoặc Servlet
# Version: 2026-05-27 10:00 UTC
# Updated by: Lead Agent (Task: T015 - Tích hợp mượn sách và xử lý lỗi)

## 1. SERVLET & JSP CONTRACTS (Source of Truth)
# Quy định chính xác tên biến từ Form gửi lên và thuộc tính trả về View

POST /borrow-book (BorrowBookServlet)
  Form Parameters: 
    - bookId: String (NOT book_id)
    - memberId: String (Mã sinh viên/Giảng viên)
  View Attributes (trả về borrow-result.jsp):
    - successMessage: String
    - errorMessage: String (Chứa thông báo lỗi nếu vi phạm BR-LMS-018)
  Status: ✅ IMPLEMENTED (backend-agent, commit: a1b2c3d)

GET /book-list (BookServlet)
  Request Parameters: 
    - keyword: String (optional)
    - categoryId: int (optional)
  View Attributes (trả về book-list.jsp):
    - books: List<Book>
    - totalPages: int
  Status: 🔄 IN PROGRESS (frontend-agent, ETA: 2h)
  Note: Field name cho list sách đổi từ "bookList" thành "books" — 2026-05-27 09:30

## 2. DATA TYPES (Java Model ↔ SQL Database)
# Ánh xạ chính xác giữa Java CamelCase và DB Snake_case

BorrowingRecord:
  id: int (DB: transaction_id)
  memberId: String (DB: member_id)
  bookId: String (DB: book_id)
  borrowDate: java.sql.Date (DB: borrow_date)
  status: enum ["active", "returned", "overdue"]
  isDeleted: boolean (DB: is_deleted - dùng cho Soft Delete)

## 3. KNOWN BREAKING CHANGES
# Log mọi thay đổi ảnh hưởng đến logic giữa JSP và Servlet
2026-05-27 09:00: Cập nhật logic "Return Book"
Impact: Khi trả sách, không dùng DELETE query nữa. Trạng thái trong DB sẽ chuyển thành status = 'returned'. Frontend Agent cần cập nhật UI không hiển thị nút "Trả sách" với các record có status này.
Status: ⚠️ Frontend agent CHƯA UPDATE — pending

## 4. SHARED DEPENDENCIES & FORMATS
# Đảm bảo nhất quán thư viện và định dạng hiển thị
Date Format: Dùng 'dd/MM/yyyy' trên toàn bộ JSP (Sử dụng JSTL <fmt:formatDate>). Backend trả về java.sql.Date thuần.
Currency Format: Dùng 'VND' cho Tiền phạt (Fine) (Ví dụ: 10,000 VND).

## 5. ENVIRONMENT
Dev DB: jdbc:sqlserver://localhost:1433;databaseName=LMS_DB
JSP Folder: /WEB-INF/views/ (Tất cả JSP phải giấu trong WEB-INF để bảo mật)