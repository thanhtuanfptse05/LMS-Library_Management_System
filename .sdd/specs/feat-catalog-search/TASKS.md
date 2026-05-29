# Task Breakdown: feat-catalog-search

- [ ] **Database Model & DAO Core**
  - [ ] Thiết lập model `Book`, `BookCopy`, `Category`, `Tag`.
  - [ ] Viết `BookDAO.java` có các hàm truy vấn tìm kiếm phân trang.
  - [ ] Viết `BookCopyDAO.java` để tương tác với các bản sao của sách.

- [ ] **Book Management & Validations (Librarian)**
  - [ ] Xây dựng Servlet và giao diện thêm/sửa sách (`BookManagementServlet.java`).
  - [ ] Triển khai validation ISBN trùng lặp và cộng dồn số lượng mượn khi trùng.
  - [ ] Xây dựng tính năng cập nhật bản sao (`BookCopyServlet.java`) và cập nhật tình trạng vật lý (`BookConditionServlet.java`).
  - [ ] Xây dựng tính năng xử lý tự động khi copy bị mất (`lost`) và áp dụng giá sách mặc định khi giá bị NULL.

- [ ] **Search Engine & Filter UI**
  - [ ] Thiết kế trang `search-results.jsp` responsive hiển thị số lượng sách khả dụng.
  - [ ] Code logic servlet tìm kiếm kết hợp nhiều tiêu chí (keyword, category, tag).
  - [ ] Tích hợp kiểm thử hiệu năng tìm kiếm với lượng bản ghi lớn.

- [ ] **AI Recommendation Integration**
  - [ ] Code `AIService.java` kết nối API OpenAI hoặc Gemini.
  - [ ] Triển khai cơ chế Async Task lấy kết quả gợi ý qua `AIRecommendServlet.java` không gây nghẽn UI.
  - [ ] Viết cơ chế dự phòng (fallback) sang sách hot nếu API lỗi/timeout.
