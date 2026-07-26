# Feature Specification: Tìm kiếm & Khám phá sách (Book Discovery & AI Recommendation)
# Version: 1.3 | Chủ sở hữu: Bao | Ngày cập nhật: 2026-07-26 (Chuẩn hóa UC-BR-FR registry)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp giao diện tra cứu danh mục thư viện cho Sinh viên, Giảng viên và Khách vãng lai, cho phép tìm kiếm đa tiêu chí (tiêu đề, tác giả, ISBN, danh mục, thẻ tag, năm xuất bản), xem chi tiết sách kèm số lượng bản sao sẵn có tại các vị trí kệ, và nhận gợi ý sách thông minh hỗ trợ bởi AI dựa trên lịch sử mượn.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Khách (Guest) & Người dùng (All Roles):** Tìm kiếm sách, lọc danh mục, xem chi tiết sách.
* **Sinh viên (Student) & Giảng viên (Lecturer):** Xem danh sách gợi ý sách cá nhân hóa dựa trên AI.

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-22 (Search & View Books):** Actor: User | (Tra cứu sách): Người dùng tìm kiếm đầu sách theo từ khóa, xem chi tiết tình trạng bản sao và gợi ý sách.
* **UC-23 (Get AI Recommendation):** Actor: User | (Nhận gợi ý sách từ AI): Người dùng nhận danh sách các tựa sách được AI (Gemini) đề xuất.

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F8 Book Discovery. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-65 (Book Visibility):** The system SHALL only display books with status='active' in public search results.
* **BR-66 (AI Fallback Policy):** The system SHALL fall back to trending books if the user lacks borrowing history or if the AI is unavailable.


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-43 (Tra cứu & Gợi ý sách với AI Recommendation):** WHEN BookSearchServlet.doGet() hoặc BookDetailServlet.doGet() được gọi, THE system SHALL: (1) **Search Logic**: BookDAO.search(keyword, categoryId, tagIds[], filterStatus, page, pageSize=12) thực thi SQL với ILIKE '%keyword%' trên title, author, publisher, ISBN, pagination OFFSET (page-1)*12 LIMIT 12, (2) **User Context**: WHERE user đã login: BorrowRecordDAO.findBorrowedBookIdsByUser(userId) và ReservationDAO.findReservedBookIdsByUser(userId) để đánh dấu sách đang mượn/đặt trước trên giao diện, (3) **AI Recommendation** (chỉ BookDetailServlet): Gọi RecommendationServlet.doGet() (API endpoint) để lấy recommendations từ AiRecommendationService.getRecommendationsForUser(userId, currentBookId), Service gọi Gemini API với prompt chứa lịch sử mượn, category/tags của sách hiện tại, danh sách ISBN sách có sẵn, Gemini trả về JSON array chứa 5-10 ISBN gợi ý, Service parse JSON và truy vấn BookDAO.findByIsbnList(isbns) để lấy thông tin đầy đủ, Cache recommendations trong session với TTL 30 phút, (4) Forward sang JSP với {books[], categories[], tags[], borrowedBookIds[], reservedBookIds[], recommendations[]}.
  * *Mapping:* UC-22, UC-23 / BR-65, BR-66


## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Hiệu năng:** Kết quả tìm kiếm phản hồi trong dưới 300ms. Dịch vụ AI có timeout 3.0 giây.
* **Độ tương thích:** Giao diện lưới sách (Grid View) và danh sách (List View) chuẩn hóa Responsive trên mọi thiết bị.
* **Giao diện:** 100% Tiếng Việt, hỗ trợ xem trước ảnh bìa sách kích thước lớn.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `Book`, `Category`, `Tag`, `BookCategory`, `BookTag`, `BookCopy`
* Đọc các thuộc tính tìm kiếm: `title`, `author`, `isbn`, `publisher`, `publicationYear`, `availableQuantity`, `location`.

### Bảng `BorrowRecord`
* Dùng cho AI phân tích lịch sử đọc: `userId`, `bookId`, `createdAt`.

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** không tìm thấy kết quả phù hợp, **THE system SHALL** hiển thị thông báo "Không tìm thấy sách phù hợp với từ khóa tìm kiếm" kèm gợi ý từ khóa khác.
* **WHERE** gọi API AI bị lỗi connection/timeout, **THE system SHALL** tự động chuyển sang hiển thị gợi ý danh mục sách nổi bật mà không báo lỗi ra màn hình.

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-DISC-01] Tìm kiếm sách theo từ khóa hiển thị đúng danh sách và phân trang chính xác.
- [ ] [TC-DISC-02] Lọc sách theo Danh mục và Tag trả về đúng các sách thuộc phân loại đó.
- [ ] [TC-DISC-03] Trang chi tiết sách hiển thị đúng vị trí kệ của các bản sao sẵn có.
- [ ] [TC-DISC-04] Gợi ý AI hiển thị danh sách sách phù hợp dựa trên lịch sử mượn của tài khoản.
- [ ] [TC-DISC-05] Ngắt kết nối AI API hệ thống vẫn hiển thị danh sách sách mượn nhiều nhất làm fallback.

## 8. Out of Scope (Phạm vi không thực hiện)
* Cho phép đọc nội dung E-book trực tiếp trên trình duyệt (chỉ tra cứu sách giấy).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã tích hợp thành công Gemini/OpenAI API cùng cơ chế Fallback an toàn.