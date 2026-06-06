# PLAN.md — Kế hoạch Thực thi Quản lý Sách
# Trạng thái: APPROVED

## 1. ARCHITECTURAL APPROACH
Áp dụng mô hình Servlet MVC + Repository Pattern. Logic đồng bộ tồn kho (Inventory Sync) BẮT BUỘC được xử lý tại tầng Service bằng cách kiểm soát Transaction (`setAutoCommit(false)`, `commit()`, `rollback()`) nhằm ngăn chặn rủi ro tranh chấp hoặc đứt gãy dữ liệu giữa bảng `Book` và `BookCopy`.

## 2. COMPONENTS
| Component | Trách nhiệm | Interface/Class |
| --- | --- | --- |
| BookController | Router cho luồng CRUD Book và hiển thị Catalog. | `BookServlet.java` |
| BookCopyController | Router cho luồng CRUD BookCopy. | `BookCopyServlet.java` |
| BookService | Xử lý logic nghiệp vụ, chặn sửa đổi định danh (ISBN/Barcode), điều phối Transaction. | `BookService.java` |
| BookDAO / BookCopyDAO | Lớp Data Access. Gồm các hàm `updateQuantities()`, `insert()`, `updateCondition()`. | `BookDAO.java`, `BookCopyDAO.java` |

## 3. DATA FLOW
- **Luồng Nhập Kho Bản Sao (Import Book Copy):** Librarian Submit Barcode -> `BookCopyServlet` -> `BookService.addBookCopy()` -> Mở Transaction -> `BookCopyDAO.insert()` -> `BookDAO.incrementQuantities()` -> Commit Transaction -> Trả về UI "Nhập kho thành công".

## 4. DEPENDENCIES
- Ràng buộc phân quyền: AuthFilter phải chặn và chỉ cấp phép truy cập cho người dùng có Role = `LIBRARIAN` hoặc `MANAGER`.

## 5. RISKS & MITIGATIONS
- **Risk:** Hiện tượng lệch kho (Data Inconsistency) nếu insert `BookCopy` thành công nhưng update `Book.availableQuantity` thất bại do mất kết nối.
- **Mitigation:** Áp dụng chặt chẽ khối lệnh `try...catch` ở Service, gọi `conn.rollback()` nếu xảy ra Exception.

## 6. QUESTIONS FOR HUMAN
- N/A
