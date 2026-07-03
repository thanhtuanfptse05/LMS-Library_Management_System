# Feature Specification: Tra cứu và Gợi ý sách (Book Discovery)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp giao diện tra cứu sách đa tiêu chí cho độc giả và tích hợp hệ thống gợi ý sách thông minh sử dụng AI (Gemini) dựa trên lịch sử mượn và thông tin cuốn sách đang xem.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Độc giả & Khách (Guest/User):** Tìm kiếm đầu sách, xem chi tiết sách, nhận gợi ý từ AI.

## 3. Business Rules (Quy tắc nghiệp vụ)
* Không có cấu hình quy tắc nghiệp vụ riêng.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-43 (Tra cứu & Gợi ý sách AI):** WHEN người dùng tìm kiếm, THE system SHALL thực thi tìm kiếm đa lọc (từ khóa, danh mục, tag) và phân trang 12 cuốn/trang. WHERE người dùng xem chi tiết sách, THE system SHALL gọi AiRecommendationService để lấy danh sách ISBN gợi ý từ Gemini API, JOIN thông tin sách và hiển thị. Kết quả gợi ý được cache trong session 30 phút. WHERE AI lỗi hoặc lịch sử mượn ít hơn 3 cuốn, SHALL dùng thuật toán Fallback hiển thị sách hot thịnh hành.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Thời gian đáp ứng: Kết quả tìm kiếm và gợi ý phải hiển thị dưới 1 giây (nhờ cơ chế cache session).\n* Chất lượng: Chống ảo tưởng (Anti-Hallucination) từ kết quả AI bằng cách đối chiếu ISBN trả về với DB thực tế.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng Book\n* `bookId` (INT, PK)\n* `isbn` (VARCHAR(20))\n* `title` (VARCHAR(500))\n* `availableQuantity` (INT)\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE API Gemini gặp sự cố kết nối, THE system SHALL tự động chuyển sang hiển thị danh sách sách hot thịnh hành và ghi log.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Tra cứu sách: Nhập từ khóa 'Java' -> Trả về danh sách sách liên quan, hỗ trợ phân trang đúng 12 bản ghi.\n- [ ] Xem gợi ý sách AI: Xem chi tiết sách -> Hiển thị phần 'Sách gợi ý dành cho bạn' tương thích với thể loại.

## 9. Out of Scope (Phạm vi không thực hiện)
* Đánh giá và viết nhận xét (review) sách của độc giả trong sprint này.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
