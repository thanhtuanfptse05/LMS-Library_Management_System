# Implementation Plan: feat-catalog-search (Danh mục, Kho sách & Tìm kiếm, Gợi ý AI)

## 1. Database & Models
- `Category.java` (categoryId, name, description)
- `Tag.java` (tagId, name)
- `Book.java` (bookId, isbn, title, author, publisher, publicationYear, price, totalQuantity, availableQuantity, status, createdAt, updatedAt)
- `BookCopy.java` (bookCopyId, bookId, location, condition, status, barcode, createdAt, updatedAt)

## 2. Service & DAO Layers
- **`BookDAO.java`**:
  - `searchBooks(String keyword, int categoryId, int page, int pageSize)`: Dùng PreparedStatement với toán tử `LIKE %keyword%` để tìm kiếm. Cần tối ưu hóa câu query phân trang.
  - `addBook(Book book)` / `updateBook(Book book)`
  - `isIsbnExists(String isbn, int excludeBookId)`
- **`BookCopyDAO.java`**:
  - `getCopiesByBookId(int bookId)`
  - `updateCopyCondition(int copyId, String condition)`
  - `getCopyByBarcode(String barcode)`
- **`CategoryDAO.java` & `TagDAO.java`**:
  - Quản lý danh sách thể loại và tag.
- **`AIService.java`**:
  - Gọi API OpenAI hoặc Gemini. Đọc API Key từ bảng `SystemConfigurations` hoặc biến môi trường. Chạy luồng Asynchronous để không chặn giao dịch người dùng.

## 3. Servlets (Controllers)
Đặt tại package `controller.book` và `controller.search`:
- `BookSearchServlet.java` (GET `/book-search`): Tiếp nhận từ khóa, categoryId, thực hiện tìm kiếm, phân trang và forward về `search-results.jsp`.
- `BookManagementServlet.java` (POST `/librarian/book-management`): Cho phép Librarian thêm, cập nhật sách (hỗ trợ các tham số từ form: isbn, title, author, publisher, publicationYear, price, categoryIds).
- `BookCopyServlet.java` (POST `/librarian/book-copy`): Cho phép tạo bản sao mới và sinh barcode tự động.
- `BookConditionServlet.java` (POST `/librarian/book-condition`): Cập nhật tình trạng hao mòn thực tế của bản sao vật lý.
- `AIRecommendServlet.java` (GET /student/ai-recommend): Gọi API lấy danh sách gợi ý dạng JSON.

## 4. Views (JSPs)
- `/web/WEB-INF/views/search/search-results.jsp`: Giao diện tìm kiếm, có bộ lọc theo Category/Tag và phân trang.
- `/web/WEB-INF/views/librarian/manage-books.jsp`: Form CRUD thông tin sách cho thủ thư.
- `/web/WEB-INF/views/librarian/manage-copies.jsp`: Form cập nhật trạng thái bản sao vật lý.
