# PLAN.md — Kế hoạch Thực thi Quản lý Sách
# Trạng thái: APPROVED | Cập nhật: 2026-07-09

## 1. ARCHITECTURAL APPROACH
Áp dụng Servlet MVC + DAO/Service Pattern theo stack hiện hữu. Controller xử lý request/response; Service chịu validation nghiệp vụ, transaction và Audit Log; DAO chỉ truy cập PostgreSQL bằng `PreparedStatement`; JSP dùng JSTL/EL.

Các nghiệp vụ nhiều bước BẮT BUỘC mở một `Connection` tại Service, `setAutoCommit(false)` và truyền cùng Connection vào mọi DAO. F4 không dùng database trigger để đồng bộ tồn kho. Thay đổi condition hỏng/mất không thực hiện trong BookCopy update mà chuyển sang F13 `feat-bookMaintenance`.

## 2. COMPONENTS
| Component | Trách nhiệm | Interface/Class |
| --- | --- | --- |
| BookOverviewController | Hiển thị số liệu tổng quan và liên kết điều hướng F4. | `BookOverviewServlet.java` |
| BookController | Tìm/lọc/sắp xếp/phân trang, tạo và cập nhật Book; quản lý ảnh bìa và liên kết phân loại. | `BookServlet.java` |
| BookCopyController | Tìm/lọc/phân trang, nhập BookCopy và cập nhật location của bản sao khả dụng. | `BookCopyServlet.java` |
| CategoryController / TagController | Quản lý thể loại, tag và thao tác gộp tag. | `CategoryServlet.java`, `TagServlet.java` |
| BookImportController | Tải mẫu, upload, validate, preview, confirm và clear import `.xlsx`. | `BookImportServlet.java` |
| BookImportHistoryController | Tìm kiếm, lọc, phân trang và xem lỗi từng batch. | `BookImportHistoryServlet.java` |
| BookService | Transaction tạo/cập nhật Book, liên kết Category/Tag và Audit Log. | `BookService.java` |
| BookCopyService | Transaction tạo/cập nhật BookCopy và đồng bộ số lượng. | `BookCopyService.java` |
| CategoryService / TagService | Transaction tạo/cập nhật soft state, Audit Log và gộp tag. | `CategoryService.java`, `TagService.java` |
| BookImportService | Validate lại và import all-or-nothing; lưu lịch sử thành công/thất bại. | `BookImportService.java` |
| BookImportValidator / WorkbookReader | Kiểm tra dữ liệu với DB và đọc đúng hai sheet Excel. | `BookImportValidator.java`, `BookImportWorkbookReader.java` |
| DAO Layer | Truy cập Book, BookCopy, Category, Tag, import batch/error và AuditLogs. | `BookDAO.java`, `BookCopyDAO.java`, `CategoryDAO.java`, `TagDAO.java`, `BookImportDAO.java`, `AuditLogDAO.java` |

## 3. DATA FLOW
- **Xem danh mục/tồn kho:** Librarian -> `AuthFilter` -> `BookOverviewServlet`/`BookServlet`/`BookCopyServlet` -> DAO search/count/summary -> JSP tiếng Việt.
- **Tạo/cập nhật Book:** `BookServlet` validate request và ảnh -> `BookService` mở transaction -> `BookDAO` insert/update + replace Category/Tag -> `AuditLogDAO` -> commit -> flash message.
- **Nhập BookCopy:** `BookCopyServlet` -> `BookCopyService` -> khóa/kiểm tra Book và Barcode -> insert BookCopy `good/available` -> tăng số lượng -> Audit Log -> commit.
- **Cập nhật BookCopy:** Chỉ nhận `bookCopyId` và `location`; Service tải bản ghi hiện tại, giữ nguyên Barcode/bookId/condition/status và chỉ cập nhật nếu status `available`.
- **Quản lý Category/Tag:** Controller -> Service transaction -> DAO create/update/merge -> Audit Log; tag nguồn sau merge chuyển `hidden`.
- **Import:** Upload -> WorkbookReader -> Validator -> preview session. Nếu lỗi: lưu batch `failed` + errors, không tạo Book/BookCopy. Nếu hợp lệ và được confirm: validate lại -> một transaction tạo dữ liệu + số lượng + batch `success` + Audit -> commit; lỗi ghi làm rollback toàn bộ.
- **Lịch sử import:** `BookImportHistoryServlet` -> `BookImportDAO.search/count/findErrors` -> JSP.
- **Condition hỏng/mất:** F4 chuyển người dùng sang F13; F4 không cập nhật condition trực tiếp.

## 4. IMPORT TEMPLATE
- Chỉ nhận Excel `.xlsx`, dung lượng tối đa 10 MB, tên file tối đa 255 ký tự.
- Sheet `Books`: `isbn`, `title`, `author`, `publisher`, `publicationYear`, `price`, `categories`, `tags`.
- Sheet `BookCopies`: `isbn`, `barcode`, `location`.
- Header đúng tên và thứ tự; không chấp nhận cột dư có dữ liệu.
- Dòng trống được bỏ qua; `categories`/`tags` tách bằng `;`, trim và loại trùng nội bộ.
- Tối đa 5.000 dòng BookCopy.
- Mỗi BookCopy phải có Barcode trong file; không tự sinh Barcode.
- ISBN đã tồn tại chỉ nhận thêm BookCopy, không cập nhật metadata Book hiện hữu.
- Duplicate ISBN trong sheet Books, duplicate Barcode trong file hoặc Database làm fail toàn bộ file.

## 5. ACCESS CONTROL
- `AuthFilter` bảo vệ `/book-management` và `/book-management/*`.
- Chưa đăng nhập: redirect `/login`.
- `LIBRARIAN`: được xem và thực hiện toàn bộ thao tác F4.
- `ADMIN`, `MANAGER`, `STUDENT`, `LECTURER` và vai trò khác: HTTP 403 trước khi vào servlet/JSP.
- Controller vẫn kiểm tra session/role cho thao tác POST như lớp phòng vệ bổ sung.

## 6. DATABASE CHANGES
- Nguồn chuẩn là `database/supabase/LMS_Schema_PostgreSQL.sql`; không tham chiếu schema SQL Server hoặc đường dẫn cũ.
- Giữ CHECK constraint: số lượng không âm, `availableQuantity <= totalQuantity`, giá không âm, status/condition theo tập giá trị schema.
- Giữ unique constraint cho `Book.isbn`, `BookCopy.barcode`, `Tag.name`; xác minh/bổ sung unique không phân biệt hoa thường cho `Category.name` nếu import đồng thời có thể tạo trùng.
- Giữ `BookImportBatch.status IN ('success','failed')`, `BookImportError.sheetName IN ('Books','BookCopies')`, và thời hạn lịch sử 1 năm.
- Xác minh index cho ISBN, Barcode, `BookCopy.bookId/status`, import history theo `createdAt`.
- Không hard-delete Book/BookCopy; các liên kết nhiều-nhiều chỉ được thay thế trong transaction cập nhật Book.

## 7. RISKS & MITIGATIONS
- **Risk:** Lệch số lượng nếu insert BookCopy thành công nhưng update Book thất bại.
  **Mitigation:** Một transaction và cùng Connection cho BookCopy, Book và Audit Log.
- **Risk:** Hai request đồng thời tạo ISBN/Barcode/Category trùng.
  **Mitigation:** Validate ở Service kết hợp unique constraint tại DB; rollback và trả lỗi thân thiện.
- **Risk:** Mô tả import partial success trái BR-27.
  **Mitigation:** Chỉ có hai batch status `success/failed`; không skip row khi confirm.
- **Risk:** BookCopy update vô tình sửa condition hoặc Barcode.
  **Mitigation:** Controller không nhận các trường này; Service nạp và giữ giá trị từ DB.
- **Risk:** File import lớn giữ transaction lâu.
  **Mitigation:** Validate toàn bộ trước transaction, giới hạn 5.000 BookCopy và 10 MB.
- **Risk:** F4 và F13 chồng lấn nghiệp vụ hỏng/mất.
  **Mitigation:** F4 chỉ cập nhật location; mọi condition/incident/inventory thuộc F13.

## 8. QUESTIONS FOR HUMAN
- N/A
