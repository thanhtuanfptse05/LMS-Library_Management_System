# Feature Specification: Tìm kiếm & Khám phá sách (Book Discovery & AI Recommendation)
# Version: 1.2 | Chủ sở hữu: @bao | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp giao diện tra cứu danh mục thư viện cho Sinh viên, Giảng viên và Khách vãng lai, cho phép tìm kiếm đa tiêu chí (tiêu đề, tác giả, ISBN, danh mục, thẻ tag, năm xuất bản), xem chi tiết sách kèm số lượng bản sao sẵn có tại các vị trí kệ, và nhận gợi ý sách thông minh hỗ trợ bởi AI dựa trên lịch sử mượn.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Khách (Guest) & Người dùng (All Roles):** Tìm kiếm sách, lọc danh mục, xem chi tiết sách.
* **Sinh viên (Student) & Giảng viên (Lecturer):** Xem danh sách gợi ý sách cá nhân hóa dựa trên AI.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-16 (Search Books):** Actor: Guest/User | Tìm kiếm sách theo từ khóa, lọc theo Danh mục, Tag, Trạng thái sẵn có và sắp xếp kết quả.
* **UC-17 (View Book Detail):** Actor: Guest/User | Xem chi tiết thông tin sách, ảnh bìa, danh sách các bản sao và vị trí kệ tương ứng.
* **UC-18 (AI Book Recommendation):** Actor: Student/Lecturer | Nhận danh sách gợi ý đọc sách cá nhân hóa do AI phân tích từ lịch sử mượn trả.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-17 (Search Privacy):** Tìm kiếm công khai chỉ hiển thị các sách có `status='active'`. Sách ở trạng thái `inactive` bị ẩn khỏi kết quả tìm kiếm của độc giả.
* **BR-18 (Real-time Availability):** Số lượng bản sao có sẵn (`availableQuantity`) và danh sách bản sao tại kệ phải phản ánh chính xác theo thời gian thực (Real-time).
* **BR-19 (AI Service Fallback):** Khi dịch vụ AI (Gemini/OpenAI) gặp sự cố hoặc timeout, hệ thống SHALL tự động fallback về danh sách sách phổ biến nhất (Top Borrowed) mà không làm ngắt gián đoạn trải nghiệm người dùng.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-26 (Tìm kiếm đa tiêu chí & Sắp xếp):** WHEN độc giả thực hiện tìm kiếm tại `BookSearchServlet`, THE system SHALL truy vấn CSDL theo từ khóa (title, author, ISBN), hỗ trợ lọc gộp theo `categoryId`, `tagId`, `publicationYear`, và sắp xếp theo: Mới nhất, Tiêu đề A-Z, Phổ biến nhất. Có phân trang (12/24/48 sách/trang).
  * *Mapping:* UC-16 / BR-17
* **FR-27 (Xem chi tiết sách & Vị trí bản sao):** WHEN độc giả chọn một đầu sách tại `BookDetailServlet`, THE system SHALL hiển thị chi tiết thông tin sách, danh mục, tag, cùng danh sách các `BookCopy` có `status='available'` kèm mã vạch và vị trí kệ (`location`).
  * *Mapping:* UC-17 / BR-18
* **FR-28 (Gợi ý sách bằng AI):** WHEN người dùng xem mục Gợi ý sách tại `RecommendationServlet`, THE system SHALL gọi `AiRecommendationService` phân tích lịch sử mượn từ `BorrowRecordDAO`. WHERE dịch vụ AI phản hồi thành công, hiển thị danh sách sách gợi ý kèm lý do. WHERE AI lỗi, hệ thống hiển thị top 5 sách được mượn nhiều nhất.
  * *Mapping:* UC-18 / BR-19

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