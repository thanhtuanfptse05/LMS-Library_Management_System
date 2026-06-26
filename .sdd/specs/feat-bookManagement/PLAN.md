# PLAN.md — Kế hoạch Thực thi Quản lý Sách
# Trạng thái: APPROVED

## 1. ARCHITECTURAL APPROACH
Áp dụng mô hình Servlet MVC + DAO/Service Pattern. Logic đồng bộ tồn kho (Inventory Sync) BẮT BUỘC được xử lý tại tầng Service bằng cách kiểm soát Transaction (`setAutoCommit(false)`, `commit()`, `rollback()`), không dùng database trigger cho nghiệp vụ F4.

Mọi DAO tham gia cùng một nghiệp vụ thay đổi dữ liệu BẮT BUỘC nhận chung `java.sql.Connection` do Service mở. DAO không được tự mở connection riêng trong các luồng transaction như thêm BookCopy, cập nhật condition, import hàng loạt hoặc ghi Audit Log.

## 2. COMPONENTS
| Component | Trách nhiệm | Interface/Class |
| --- | --- | --- |
| BookController | Router cho luồng CRUD Book, hiển thị Catalog và chặn sửa ISBN/số lượng tồn kho trực tiếp. | `BookServlet.java` |
| BookCopyController | Router cho luồng thêm/cập nhật BookCopy; chỉ cho đổi `condition` khi BookCopy đang `available`. | `BookCopyServlet.java` |
| BookImportController | Router upload, validate, preview và xác nhận import file Excel `.xlsx`. | `BookImportServlet.java` |
| InventoryReconciliationController | Màn hình đối chiếu tồn kho cho Librarian xem phiên kiểm kê, lịch sử import, báo cáo hỏng/mất và cảnh báo lệch kho. | `InventoryReconciliationServlet.java` |
| BookService | Xử lý logic nghiệp vụ Book/BookCopy, chặn sửa định danh và điều phối transaction tồn kho. | `BookService.java` |
| BookImportService | Điều phối validate/import all-or-nothing cho file `.xlsx`, rollback Book/BookCopy/Category/Tag/link table/Audit Log khi có lỗi. | `BookImportService.java` |
| BookImportValidator | Đọc và kiểm tra cấu trúc sheet `Books`, `BookCopies`, dòng trống, duplicate nội bộ, giới hạn 5.000 BookCopy. | `BookImportValidator.java` |
| InventoryReconciliationService | Tính cảnh báo lệch kho trực tiếp khi Librarian mở/làm mới báo cáo; không tự sửa số lượng. | `InventoryReconciliationService.java` |
| AuditLogService | Ghi Audit Log tổng hợp phiên import và chi tiết từng entity được tạo/cập nhật. | `AuditLogService.java` |
| DAO Layer | Data Access bằng PreparedStatement, nhận chung Connection khi nằm trong transaction. | `BookDAO.java`, `BookCopyDAO.java`, `CategoryDAO.java`, `TagDAO.java`, `BookImportDAO.java`, `AuditLogDAO.java` |

## 3. DATA FLOW
- **Luồng Nhập Kho Bản Sao thủ công:** Librarian submit Barcode -> `BookCopyServlet` -> `BookService.addBookCopy()` -> mở Transaction -> `BookCopyDAO.insert(conn)` -> `BookDAO.updateQuantities(conn, +1, +1)` -> `AuditLogDAO.insert(conn)` -> commit -> trả về UI "Nhập kho thành công".
- **Luồng Cập nhật Condition:** Librarian submit update -> `BookCopyServlet` -> `BookService.updateCondition()` -> kiểm tra `BookCopy.status='available'` và không sửa Barcode -> mở Transaction -> update BookCopy -> cập nhật `availableQuantity` nếu chuyển `good` sang `damaged/lost` -> ghi Audit Log -> commit.
- **Luồng Import hàng loạt:** Librarian upload `.xlsx` -> `BookImportServlet` -> `BookImportValidator` kiểm tra sheet/cột/dòng/duplicate/giới hạn -> nếu có lỗi, lưu `BookImportBatch` + `BookImportError` và không tạo dữ liệu sách -> nếu hợp lệ, `BookImportService` mở Transaction -> tạo Book mới, Category/Tag mới, BookCopy mặc định `good/available`, cập nhật số lượng, ghi Audit Log tổng hợp và chi tiết -> commit.
- **Luồng truy cập trái quyền:** Admin, Library Manager hoặc các vai trò khác mở `/book-management/*` -> `AuthFilter` trả HTTP 403 trước khi vào servlet/JSP.

## 4. IMPORT TEMPLATE
- File import bắt buộc là Excel `.xlsx`.
- Sheet `Books`: `isbn`, `title`, `author`, `publisher`, `publicationYear`, `price`, `categories`, `tags`.
- Sheet `BookCopies`: `isbn`, `barcode`, `location`.
- `categories` và `tags` phân tách nhiều giá trị bằng dấu chấm phẩy `;`; hệ thống trim khoảng trắng và bỏ qua phần tử rỗng.
- Dòng trống hoàn toàn trong hai sheet được bỏ qua.
- Sheet `BookCopies` tối đa 5.000 dòng dữ liệu.
- ISBN đã tồn tại trong Database không cập nhật metadata Book; chỉ thêm BookCopy mới vào Book hiện hữu.
- ISBN/Barcode trùng nội bộ trong file hoặc Barcode trùng Database là lỗi validation và làm fail toàn bộ file.

## 5. ACCESS CONTROL
- `LIBRARIAN`: được xem, tạo, cập nhật và import dữ liệu F4.
- `ADMIN`, `MANAGER` và các vai trò khác: bị từ chối với HTTP 403 khi truy cập F4.

## 6. DATABASE CHANGES
- Bổ sung CHECK constraint cho `Book.totalQuantity >= 0`, `Book.availableQuantity >= 0`, `availableQuantity <= totalQuantity`, `BookCopy.condition`, `BookCopy.status` và `Book.price >= 0`.
- Bổ sung unique constraint cho `Category.name` để hỗ trợ tự tạo Category khi import.
- Bổ sung bảng `BookImportBatch` và `BookImportError`, lưu lịch sử import/lỗi trong 1 năm theo quy tắc nghiệp vụ.
- Bổ sung index hỗ trợ truy vấn danh mục và cảnh báo lệch kho theo `BookCopy.bookId`, `BookCopy.status`, `BookCopy.condition`.

## 7. RISKS & MITIGATIONS
- **Risk:** Lệch kho nếu insert `BookCopy` thành công nhưng update `Book.availableQuantity` thất bại.
  **Mitigation:** Service mở một transaction chung và truyền cùng Connection vào mọi DAO.
- **Risk:** File import lớn làm transaction kéo dài.
  **Mitigation:** Giới hạn 5.000 BookCopy/file, validate toàn bộ trước khi mở transaction, fail-fast khi sai cấu trúc.
- **Risk:** Admin, Manager hoặc role khác gửi request truy cập F4 bằng tay.
  **Mitigation:** `AuthFilter` kiểm tra role server-side trước mọi route `/book-management/*`, không chỉ ẩn nút UI.
- **Risk:** Audit Log quá nhiều khi import.
  **Mitigation:** Ghi một log tổng hợp theo batch và log chi tiết theo entity tạo mới để bảo đảm truy vết.

## 8. QUESTIONS FOR HUMAN
- N/A
