# .sdd/shared_context.md
# File này là NGUỒN SỰ THẬT CHUNG cho mọi agents trong dự án LMS
# Read bởi: Tất cả agents trước khi bắt đầu code JSP hoặc Servlet
# Version: 1.0.1 | Updated: 28/5/2026
# Updated by: Audit — sửa data mapping khớp DB schema thực tế

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
# Ánh xạ chính xác giữa Java CamelCase và DB columns
# Tham chiếu: database/LMS_Library_Management_System.sql

BorrowRecord:
  borrowRecordId: int (DB: borrowRecordId INT IDENTITY PK)
  userId: int (DB: userId INT FK → User)
  bookCopyId: int (DB: bookCopyId INT FK → BookCopy)
  bookId: int (DB: bookId INT FK → Books)
  startDate: java.sql.Date (DB: start_date DATE)
  endDate: java.sql.Date (DB: end_date DATE)
  returnedAt: java.sql.Timestamp (DB: returned_at DATETIME, nullable)
  status: String (DB: status NVARCHAR(50) — values: 'borrowed', 'returned', 'overdue', 'lost')
  extensionCount: int (DB: extension_count INT DEFAULT 0)
  createdBy: int (DB: created_by INT FK → User, nullable)
  createdAt: java.sql.Timestamp (DB: created_at DATETIME DEFAULT GETDATE())

Fine:
  fineId: int (DB: fineId INT IDENTITY PK)
  borrowRecordId: int (DB: borrowRecordId INT FK → BorrowRecord)
  userId: int (DB: userId INT FK → User)
  amount: BigDecimal (DB: amount DECIMAL(18,2))
  reason: String (DB: reason NVARCHAR(500), nullable)
  status: String (DB: status NVARCHAR(50) — values: 'unpaid', 'paid')
  createdAt: java.sql.Timestamp (DB: created_at DATETIME DEFAULT GETDATE())

Payment:
  paymentId: int (DB: paymentId INT IDENTITY PK)
  fineId: int (DB: fineId INT FK → Fine)
  paidAmount: BigDecimal (DB: paid_amount DECIMAL(18,2))
  paymentMethod: String (DB: payment_method NVARCHAR(100), nullable)
  transactionReference: String (DB: transaction_reference NVARCHAR(255) UNIQUE, nullable)
  processBy: int (DB: process_by INT FK → User, nullable)
  status: String (DB: status NVARCHAR(50) — values: 'completed', 'pending', 'canceled')
  paidAt: java.sql.Timestamp (DB: paid_at DATETIME DEFAULT GETDATE())

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
Dev DB: Sử dụng biến môi trường `$DB_URL` từ `.env`. Cấu trúc mong đợi: `jdbc:sqlserver://{host}:{port};databaseName={dbName}`
JSP Folder: /WEB-INF/views/ (Tất cả JSP phải giấu trong WEB-INF để bảo mật)