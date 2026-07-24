# Feature Specification: Trang công khai & Tin tức (Public Pages & News)
# Version: 1.2 | Chủ sở hữu: @bao | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp các trang công khai (Cổng thông tin Thư viện, Trang chủ, Trang tin tức & thông báo công cộng, Tra cứu danh mục sách công khai, Hướng dẫn & Quy định thư viện) cho Độc giả và Khách vãng lai truy cập mà không yêu cầu đăng nhập.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Khách vãng lai (Guest) & Độc giả (All Users):** Truy cập trang chủ, tra cứu sách công khai, xem bản tin tin tức, đọc nội quy & chính sách thư viện.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-41 (View Public Portal):** Actor: Guest/All Users | Xem thông tin trang chủ, sách mới cập nhật, thông báo công khai.
* **UC-42 (View News & Rules):** Actor: Guest/All Users | Xem tin tức, bài viết hướng dẫn và quy định thư viện.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-47 (Public Access Scope):** Trang công khai chỉ cho phép xem thông tin không nhạy cảm (Tin tức, Sách công khai). KHÔNG hiển thị thông tin cá nhân của người mượn hoặc dữ liệu giao dịch tài chính.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-52 (Trang chủ & Sách nổi bật):** WHEN người dùng truy cập trang chủ `/`, THE system SHALL hiển thị biểu banner giới thiệu thư viện, sách mới cập nhật, sách được mượn nhiều nhất và thanh tìm kiếm nhanh.
  * *Mapping:* UC-41 / BR-47
* **FR-53 (Trang Tin tức & Nội quy):** WHEN người dùng xem `NewsServlet`, THE system SHALL tải danh sách tin tức và thông báo công khai từ CSDL, hỗ trợ xem chi tiết từng bài viết.
  * *Mapping:* UC-42

## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Hiệu năng:** Tải trang công khai cực nhanh dưới 200ms để tối ưu SEO và trải nghiệm người dùng.
* **Độ tương thích:** Responsive chuẩn 100% trên giao diện di động, tablet, máy tính.
* **Giao diện:** Đẹp mắt, chuyên nghiệp, 100% tiếng Việt.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
* Truy vấn từ `Book`, `Category`, `Notification` (`type='system'` hoặc `'academic'`).

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** truy cập bài viết tin tức không tồn tại, **THE system SHALL** hiển thị trang 404 thân thiện và nút quay về trang chủ.

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-PUB-01] Khách vãng lai chưa đăng nhập truy cập thành công trang chủ và xem danh sách sách mới.
- [ ] [TC-PUB-02] Đọc tin tức công khai hiển thị đầy đủ nội dung bài viết và ngày đăng.
- [ ] [TC-PUB-03] Tìm kiếm công khai trả về kết quả đúng mà không yêu cầu đăng nhập.

## 8. Out of Scope (Phạm vi không thực hiện)
* Cho phép khách vãng lai gửi bình luận dưới các bài viết tin tức.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện toàn bộ trang chủ và cổng thông tin công khai.