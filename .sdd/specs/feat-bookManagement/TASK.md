# TASKS.md — Task Breakdown Quản lý Sách

| ID | Task | Files liên quan | Est | Deps | DoD / Spec Refs |
|---|---|---|---|---|---|
| **T-F4-01** | Tạo DAO cho Book và siêu dữ liệu | `BookDAO.java`, `CategoryDAO.java` | 2h | None | Hàm CRUD đầy đủ. Viết hàm `updateQuantities(int bookId, int totalChange, int availableChange)`. 100% PreparedStatement. |
| **T-F4-02** | Tạo DAO cho BookCopy | `BookCopyDAO.java` | 1h | T-F4-01 | Hàm CRUD. Viết hàm check Barcode isUnique. |
| **T-F4-03** | Service Layer (Inventory Sync) | `BookService.java` | 3h | T-F4-02 | Gói lệnh Insert `BookCopy` và Update `Book` vào chung 1 Transaction. Bắt lỗi thay đổi ISBN/Barcode (FR-F4-04, FR-F4-09). |
| **T-F4-04** | Xử lý Controller (Book) | `BookServlet.java` | 2h | T-F4-03 | Xử lý GET danh sách (Catalog), POST tạo mới/cập nhật. Catch Exception báo lỗi trùng lặp ISBN. |
| **T-F4-05** | Xử lý Controller (BookCopy) | `BookCopyServlet.java` | 2h | T-F4-03 | Xử lý POST quét mã thêm bản sao, cập nhật trạng thái `condition` (good/damaged/lost). |
| **T-F4-06** | Xây dựng View (JSP) | `book-list.jsp`, `book-detail.jsp` | 3h | T-F4-04 | Dựng UI Form tạo sách và nhập kho bản sao. Hiển thị Flash messages (Success/Error). |
