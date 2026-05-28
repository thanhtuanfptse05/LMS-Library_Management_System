# Task Breakdown: feat-borrow-return

- [ ] **Transaction Model & DAO Setup**
  - [ ] Tạo Model `BorrowRecord` và `AuditLog` khớp với DB.
  - [ ] Viết `BorrowRecordDAO.java` tích hợp các câu query kiểm tra điều kiện mượn (đếm số sách đang mượn, kiểm tra nợ phạt).
  - [ ] Thiết kế cơ chế đóng mở Connection thủ công phục vụ SQL Transaction.

- [ ] **Borrow Transaction Logic (Librarian View)**
  - [ ] Tạo `BorrowBookServlet.java` nhận barcode và memberId.
  - [ ] Viết `BorrowService.java` xử lý transaction: kiểm tra điều kiện -> trừ kho -> đổi status copy -> tạo record mượn -> ghi audit log.
  - [ ] Tạo giao diện `/web/WEB-INF/views/librarian/borrow-transaction.jsp`.

- [ ] **Return Transaction Logic (Librarian View)**
  - [ ] Tạo `ReturnBookServlet.java` xử lý trả sách bằng quét barcode.
  - [ ] Code logic trả sách: đổi status copy -> cộng kho -> tạo ngày returned_at -> tính toán quá hạn -> ghi audit log.
  - [ ] Tạo giao diện `/web/WEB-INF/views/librarian/return-transaction.jsp`.

- [ ] **Student History & Verification**
  - [ ] Tạo servlet `BorrowHistoryServlet.java` lấy lịch sử giao dịch của người dùng hiện tại.
  - [ ] Thiết kế giao diện `borrow-history.jsp` hiển thị danh sách sách kèm trạng thái quá hạn rõ ràng.
  - [ ] Viết JUnit test giả lập các điều kiện mượn lỗi (nợ phạt, vượt hạn mức) để kiểm thử logic.
