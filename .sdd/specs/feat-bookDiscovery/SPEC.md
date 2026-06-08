# Book Discovery Spec
# Version: 1.0 | Owner: @Antigravity | Date: 2026-06-08

## 1. Context & Goal
Tính năng F8 cung cấp khả năng tìm kiếm, lọc, xem chi tiết sách và nhận các gợi ý cá nhân hóa dựa trên dữ liệu người dùng. Mục tiêu là hỗ trợ người dùng khám phá sách trong thư viện một cách nhanh chóng, thông minh, đồng thời tối ưu chi phí sử dụng API AI thông qua các cơ chế Fallback và Threshold an toàn.

## 2. Actors & Roles
- **Guest**: Có thể tra cứu, xem chi tiết sách, nhận gợi ý Top Trending. Không có quyền tạo giao dịch mượn sách.
- **Authenticated User**: Có quyền tra cứu, xem chi tiết, nhận gợi ý Top Trending hoặc AI Recommendation (nếu đạt đủ số lượt mượn). Có quyền kích hoạt nút đặt mượn.

## 3. Functional Requirements
- **FR-42**: WHEN người dùng submit từ khóa văn bản (tiêu đề, tác giả) hoặc chọn bộ lọc (Danh mục, Thẻ), THE system SHALL thực hiện truy vấn `LIKE` trên bảng `Book` kết hợp `JOIN` với `BookCategory`, `BookTag` và trả về danh sách kết quả phân trang.
- **FR-43 (Part 1)**: WHEN người dùng chọn xem một tựa sách, THE system SHALL trích xuất dữ liệu metadata từ bảng `Book` VÀ tính toán số lượng khả dụng (`availableQuantity`) hiện tại từ bảng `BookCopy`.
- **FR-43 (Part 2)**: WHERE người dùng là Guest (chưa đăng nhập), THE system SHALL thay đổi đích đến của nút "Đặt mượn" thành hành động điều hướng (Redirect) về trang Đăng nhập. WHERE người dùng là Authenticated User, THE system SHALL hiển thị nút "Đặt mượn" trỏ tới Module giao dịch.
- **FR-44**: WHEN người dùng truy cập trang chủ, THE system SHALL render ngay lập tức các thành phần tĩnh VÀ kích hoạt một HTTP Request bất đồng bộ (AJAX/Fetch) để lấy danh sách gợi ý nhằm tránh block UI.
- **FR-45**: WHERE Request tới trang chủ đến từ Guest HOẶC User có `COUNT(BorrowRecord) < 3`, THE system SHALL thực thi SQL nội bộ lấy Top 10 sách thịnh hành có sẵn.
- **FR-46**: WHEN người dùng đạt ngưỡng kích hoạt AI (`COUNT(BorrowRecord) >= 3`), THE system SHALL trích xuất ngữ cảnh (Chuyên ngành, Tần suất phân bổ Danh mục/Thẻ, Lịch sử 3 cuốn gần nhất). ĐỒNG THỜI, THE system SHALL dùng SQL lấy TỐI ĐA 50 Candidate Books làm dữ liệu nguồn gửi tới AI Service.
- **FR-47**: WHEN nhận phản hồi JSON từ AI Service, THE system SHALL parse danh sách TỐI ĐA 10 `book_id` hợp lệ kèm lý do. THE system SHALL xác thực mọi `book_id` trả về ĐỀU PHẢI nằm trong Candidate Pool đã cung cấp (Chống Hallucination).
- **FR-48**: WHERE kết nối AI bị Timeout HOẶC trả về HTTP 5xx HOẶC trả về `book_id` vi phạm xác thực, THE system SHALL tự động fallback sang thực thi FR-45 (Top Trending SQL) VÀ ghi log cảnh báo sự cố AI.

## 4. Non-functional Requirements
- **Performance**: API phục vụ gợi ý sách bất đồng bộ SHALL phản hồi `< 500ms` (đối với SQL) và `< 3000ms` (đối với AI Endpoint).
- **Security**: Mọi truy vấn tìm kiếm SHALL sử dụng `PreparedStatement` (SEC-03). Mọi API nhận tham số từ bên ngoài SHALL kiểm tra tính hợp lệ của input.
- **Usability (BR-27)**: Giao diện hiển thị sách (Unified Component) SHALL được thiết kế đồng nhất để tái sử dụng độc lập với nguồn gốc dữ liệu.

## 5. Data Model
- `Book` (bookId, title, author, categoryId, tagId, status)
- `BookCopy` (copyId, bookId, status)
- `BorrowRecord` (recordId, copyId, userId, status)

## 6. Error Handling (Unwanted)
- WHERE Service AI Timeout hoặc lỗi HTTP 5xx, THE system SHALL không ném Exception về Frontend mà catch lỗi, ghi Audit Log cảnh báo, sau đó tự động trả về list SQL Top Trending.
- WHERE AI trả về ID sách không nằm trong Candidate Pool, THE system SHALL ghi Audit Log cảnh báo "Hallucination" và kích hoạt fallback SQL Top Trending.
- WHERE Guest bấm "Đặt mượn" trên thẻ sách, THE system SHALL ngăn chặn quyền truy cập và redirect về trang `/login` với thông báo tương ứng.

## 7. Acceptance Criteria
- [ ] Tính năng tìm kiếm theo text và filter danh mục hoạt động, hiển thị kết quả phân trang đúng.
- [ ] Hiển thị chi tiết sách có tính toán và hiển thị đúng thông số `availableQuantity`.
- [ ] Trang chủ nạp dữ liệu sách gợi ý bằng AJAX thành công mà không làm chậm việc tải cấu trúc trang.
- [ ] Guest và User (< 3 lần mượn) nhận được kết quả SQL Top Trending.
- [ ] User (>= 3 lần mượn) nhận được kết quả phân tích cá nhân hóa từ AI Recommendation.
- [ ] Giả lập ngắt mạng AI hoặc Fake response sai ID -> Hệ thống tự fallback về SQL Top Trending thành công và hiển thị UI bình thường.
- [ ] Thành phần UI hiển thị thẻ sách (Unified Book Card) được tái sử dụng thành công trên cả màn hình Tìm kiếm và màn hình Trang chủ.

## 8. Out of Scope
- KHÔNG chặn luồng tải trang UI để chờ API AI.
- KHÔNG hiển thị sách do AI ảo giác sinh ra (Chống Hallucination).
- KHÔNG cho phép Guest thực hiện bất kỳ giao dịch đặt/mượn sách trực tiếp nào.

## Notes / Open Questions
- Quy tắc BR-26 và BR-27 đã được xác định và đóng vai trò làm rule chốt (locked). Không có open question mới.
