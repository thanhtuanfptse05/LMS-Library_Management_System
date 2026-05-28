# Implementation Plan: feat-borrow-return (Giao dịch Mượn & Trả sách)

## 1. Database & Models
- `BorrowRecord.java` (borrowRecordId, userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, extensionCount, createdBy, createdAt)
- `AuditLog.java` (auditLogId, userId, actionType, entityName, entityId, oldValues, newValues, timestamp)

## 2. Service & DAO Layers
- **`BorrowRecordDAO.java`**:
  - `getActiveBorrowCount(int userId)`: Đếm số lượng sách user đang mượn chưa trả.
  - `hasUnpaidFine(int userId)`: Kiểm tra user có hóa đơn phạt nào chưa thanh toán.
  - `insertBorrowRecord(BorrowRecord record, Connection conn)`: Thực hiện trong transaction.
  - `updateReturnStatus(int borrowRecordId, Timestamp returnedAt, String status, Connection conn)`: Cập nhật trạng thái khi trả sách.
  - `getBorrowHistory(int userId)`: Lấy lịch sử mượn trả của thành viên.
- **`AuditLogDAO.java`**:
  - `insertAuditLog(AuditLog log, Connection conn)`: Ghi log thao tác hệ thống.
- **`BorrowService.java`**:
  - `borrowBook(int userId, String barcode, int librarianId)`: Quản lý transaction thủ công. Gọi `UserDAO`, `BookCopyDAO`, `BookDAO`, `BorrowRecordDAO` và `AuditLogDAO`. Thực hiện rollback nếu xảy ra bất kỳ lỗi runtime nào.
  - `returnBook(String barcode, int librarianId)`: Xử lý quy trình trả sách, giải phóng copy, cập nhật kho, tính phạt nếu trễ hạn.

## 3. Servlets (Controllers)
Đặt tại package `controller.transaction`:
- `BorrowBookServlet.java` (GET/POST /librarian/borrow): Giao diện mượn sách cho thủ thư. Nhận mã thành viên và barcode, kiểm tra và thực hiện mượn.
- `ReturnBookServlet.java` (GET/POST /librarian/return): Giao diện quét trả sách.
- `BorrowHistoryServlet.java` (GET /student/borrow-history): Cho phép học sinh/giảng viên xem danh sách sách đã và đang mượn.

## 4. Views (JSPs)
- `/web/WEB-INF/views/librarian/borrow-transaction.jsp`: Form cho thủ thư nhập mã thành viên và quét barcode sách để mượn.
- `/web/WEB-INF/views/librarian/return-transaction.jsp`: Form quét trả sách nhanh chóng.
- `/web/WEB-INF/views/student/borrow-history.jsp`: Bảng hiển thị danh sách sách đã mượn, trạng thái quá hạn/đã trả, ngày đến hạn.
