# Feature Specification: Tra cứu và Gợi ý sách (Book Discovery)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp giao diện tra cứu sách đa tiêu chí cho độc giả và tích hợp hệ thống gợi ý sách thông minh sử dụng AI (Gemini) dựa trên lịch sử mượn và thông tin cuốn sách đang xem.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Độc giả & Khách (Guest/User):** Tìm kiếm đầu sách, xem chi tiết sách, nhận gợi ý từ AI.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-22 (Search & View Books):** Actor: User | (Tra cứu sách): Người dùng tìm kiếm đầu sách theo từ khóa, xem chi tiết tình trạng bản sao và gợi ý sách.
* **UC-23 (Get AI Recommendation):** Actor: User | (Nhận gợi ý sách từ AI): Người dùng nhận danh sách các tựa sách được AI (Gemini) đề xuất.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-22 (Search & View Books):** Actor: User | (Tra cứu sách): Người dùng tìm kiếm đầu sách theo từ khóa, xem chi tiết tình trạng bản sao và gợi ý sách.
* **UC-23 (Get AI Recommendation):** Actor: User | (Nhận gợi ý sách từ AI): Người dùng nhận danh sách các tựa sách được AI (Gemini) đề xuất.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-22 (Search & View Books):** Actor: User | (Tra cứu sách): Người dùng tìm kiếm đầu sách theo từ khóa, xem chi tiết tình trạng bản sao và gợi ý sách.
* **UC-23 (Get AI Recommendation):** Actor: User | (Nhận gợi ý sách từ AI): Người dùng nhận danh sách các tựa sách được AI (Gemini) đề xuất.

## 3. Business Rules (Quy tắc nghiệp vụ)
*(Không có Business Rule riêng biệt)*

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-43 (Tra cứu & Gợi ý sách với AI Recommendation):** WHEN BookSearchServlet.doGet() hoặc BookDetailServlet.doGet() được gọi, THE system SHALL: (1) **Search Logic**: BookDAO.search(keyword, categoryId, tagIds[], filterStatus, page, pageSize=12) thực thi SQL với ILIKE '%keyword%' trên title, author, publisher, ISBN, pagination OFFSET (page-1)*12 LIMIT 12, (2) **User Context**: WHERE user đã login: BorrowRecordDAO.findBorrowedBookIdsByUser(userId) và ReservationDAO.findReservedBookIdsByUser(userId) để đánh dấu sách đang mượn/đặt trước trên giao diện, (3) **AI Recommendation** (chỉ BookDetailServlet): Gọi RecommendationServlet.doGet() (API endpoint) để lấy recommendations từ AiRecommendationService.getRecommendationsForUser(userId, currentBookId), Service gọi Gemini API với prompt chứa lịch sử mượn, category/tags của sách hiện tại, danh sách ISBN sách có sẵn, Gemini trả về JSON array chứa 5-10 ISBN gợi ý, Service parse JSON và truy vấn BookDAO.findByIsbnList(isbns) để lấy thông tin đầy đủ, Cache recommendations trong session với TTL 30 phút, (4) Forward sang JSP với {books[], categories[], tags[], borrowedBookIds[], reservedBookIds[], recommendations[]}.
  * *Mapping:* UC-22, UC-23

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Thời gian đáp ứng: Kết quả tìm kiếm và gợi ý phải hiển thị dưới 1 giây (nhờ cơ chế cache session).
* Chất lượng: Chống ảo tưởng (Anti-Hallucination) từ kết quả AI bằng cách đối chiếu ISBN trả về với DB thực tế.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng Book
* `bookId` (INT, PK)
* `isbn` (VARCHAR(20))
* `title` (VARCHAR(500))
* `availableQuantity` (INT)



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE API Gemini gặp sự cố kết nối, THE system SHALL tự động chuyển sang hiển thị danh sách sách hot thịnh hành và ghi log.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Tra cứu sách: Nhập từ khóa 'Java' -> Trả về danh sách sách liên quan, hỗ trợ phân trang đúng 12 bản ghi.
- [ ] Xem gợi ý sách AI: Xem chi tiết sách -> Hiển thị phần 'Sách gợi ý dành cho bạn' tương thích với thể loại.

## 9. Out of Scope (Phạm vi không thực hiện)
* Đánh giá và viết nhận xét (review) sách của độc giả trong sprint này.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.