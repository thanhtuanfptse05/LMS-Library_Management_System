# Feature Specification: Trang công khai & Tin tức (Public Pages & News)
# Version: 1.3 | Chủ sở hữu: Tuan | Ngày cập nhật: 2026-07-26 (Chuẩn hóa UC-BR-FR registry)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp các trang công khai (Cổng thông tin Thư viện, Trang chủ, Trang tin tức & thông báo công cộng, Tra cứu danh mục sách công khai, Hướng dẫn & Quy định thư viện) cho Độc giả và Khách vãng lai truy cập mà không yêu cầu đăng nhập.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Khách vãng lai (Guest) & Độc giả (All Users):** Truy cập trang chủ, tra cứu sách công khai, xem bản tin tin tức, đọc nội quy & chính sách thư viện.

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-47 (View Public Homepage):** Actor: Guest | (Xem trang chủ công khai): Khách truy cập xem trang chủ với thông tin giới thiệu thư viện, tin tức, thông báo quan trọng được ghim.
* **UC-48 (View Library Policies):** Actor: Guest, User | (Xem nội quy thư viện): Người dùng và khách truy cập tra cứu các quy định, chính sách mượn trả, và hướng dẫn sử dụng dịch vụ thư viện.

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F18 Public Pages. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-76 (Homepage Content Priority):** The system SHALL prioritize pinned system announcements over general news on the public homepage.
* **BR-77 (Policy Accessibility):** The system SHALL make library policies publicly accessible without requiring authentication.


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-75 (Hiển thị Trang Chủ Công Khai với thông báo ghim):** WHEN NewsServlet.doGet() hoặc user truy cập index.jsp, THE system SHALL: (1) NotificationDAO.findPinnedNotifications() WHERE isPinned=true AND status='published' ORDER BY createdAt DESC LIMIT 5 → lấy thông báo quan trọng được ghim, (2) NotificationDAO.findRecentNews(limit=10) WHERE type='news' AND status='published' ORDER BY createdAt DESC → tin tức mới nhất, (3) BookDAO.findFeaturedBooks(limit=6) WHERE bookStatus='available' ORDER BY viewCount DESC → sách nổi bật, (4) Render index.jsp với sections: Hero banner (giới thiệu thư viện), Pinned notifications carousel, Recent news cards, Featured books grid, Quick links (Tra cứu sách, Đăng nhập, Xem nội quy).
  * *Mapping:* UC-47 / BR-76
* **FR-76 (Hiển thị Nội Quy Thư Viện chi tiết):** WHEN user hoặc guest truy cập trang policies.jsp hoặc services.jsp, THE system SHALL hiển thị nội dung đầy đủ: (1) **Chính sách mượn trả**: Số ngày mượn theo role (STUDENT_MAX_BORROW_DAYS, LECTURER_MAX_BORROW_DAYS từ SystemConfig), Hạn mức sách (STUDENT_MAX_BORROW_BOOKS, LECTURER_MAX_BORROW_BOOKS), Quy định gia hạn (MAX_EXTENSION_COUNT, RENEWAL_MIN_DAYS_BEFORE_DUE), Quy định đặt trước (RESERVATION_HOLD_DAYS), (2) **Chính sách tiền phạt**: Phạt trễ hạn (FINE_RATE_PER_DAY VNĐ/ngày), Phạt sách hư hỏng/mất (theo giá sách), Hình thức thanh toán (tiền mặt tại quầy, online qua VietQR), (3) **Quyền lợi và nghĩa vụ**: Quyền của độc giả, Nghĩa vụ bảo quản sách, Xử lý vi phạm, (4) **Hướng dẫn sử dụng**: Cách tra cứu sách online, Cách đặt trước và gia hạn, Liên hệ thư viện. Content MUST được format rõ ràng với headings, lists, tables, và được viết hoàn toàn bằng **tiếng Việt**.
  * *Mapping:* UC-48 / BR-77


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