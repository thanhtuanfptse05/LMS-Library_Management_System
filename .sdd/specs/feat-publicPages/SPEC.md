# Feature Specification: Các trang công khai (Public Pages)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp trang chủ công khai giới thiệu về thư viện, danh sách tin tức, thông báo mới nhất từ ban quản lý và bảng tra cứu nội quy mượn trả trực quan cho khách vãng lai chưa đăng nhập.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Khách truy cập (Guest):** Xem trang chủ, đọc tin tức, tra cứu nội quy chính sách thư viện.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-47 (View Public Homepage):** Actor: Guest | (Xem trang chủ công khai): Khách truy cập xem trang chủ với thông tin giới thiệu thư viện, tin tức, thông báo quan trọng được ghim.
* **UC-48 (View Library Policies):** Actor: Guest, User | (Xem nội quy thư viện): Người dùng và khách truy cập tra cứu các quy định, chính sách mượn trả, và hướng dẫn sử dụng dịch vụ thư viện.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-47 (View Public Homepage):** Actor: Guest | (Xem trang chủ công khai): Khách truy cập xem trang chủ với thông tin giới thiệu thư viện, tin tức, thông báo quan trọng được ghim.
* **UC-48 (View Library Policies):** Actor: Guest, User | (Xem nội quy thư viện): Người dùng và khách truy cập tra cứu các quy định, chính sách mượn trả, và hướng dẫn sử dụng dịch vụ thư viện.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-47 (View Public Homepage):** Actor: Guest | (Xem trang chủ công khai): Khách truy cập xem trang chủ với thông tin giới thiệu thư viện, tin tức, thông báo quan trọng được ghim.
* **UC-48 (View Library Policies):** Actor: Guest, User | (Xem nội quy thư viện): Người dùng và khách truy cập tra cứu các quy định, chính sách mượn trả, và hướng dẫn sử dụng dịch vụ thư viện.

## 3. Business Rules (Quy tắc nghiệp vụ)
*(Không có Business Rule riêng biệt)*

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-75 (Hiển thị Trang Chủ Công Khai với thông báo ghim):** WHEN NewsServlet.doGet() hoặc user truy cập index.jsp, THE system SHALL: (1) NotificationDAO.findPinnedNotifications() WHERE isPinned=true AND status='published' ORDER BY createdAt DESC LIMIT 5 → lấy thông báo quan trọng được ghim, (2) NotificationDAO.findRecentNews(limit=10) WHERE type='news' AND status='published' ORDER BY createdAt DESC → tin tức mới nhất, (3) BookDAO.findFeaturedBooks(limit=6) WHERE bookStatus='available' ORDER BY viewCount DESC → sách nổi bật, (4) Render index.jsp với sections: Hero banner (giới thiệu thư viện), Pinned notifications carousel, Recent news cards, Featured books grid, Quick links (Tra cứu sách, Đăng nhập, Xem nội quy).
  * *Mapping:* UC-47
* **FR-76 (Hiển thị Nội Quy Thư Viện chi tiết):** WHEN user hoặc guest truy cập trang policies.jsp hoặc services.jsp, THE system SHALL hiển thị nội dung đầy đủ: (1) **Chính sách mượn trả**: Số ngày mượn theo role (STUDENT_MAX_BORROW_DAYS, LECTURER_MAX_BORROW_DAYS từ SystemConfig), Hạn mức sách (STUDENT_MAX_BORROW_BOOKS, LECTURER_MAX_BORROW_BOOKS), Quy định gia hạn (MAX_EXTENSION_COUNT, RENEWAL_MIN_DAYS_BEFORE_DUE), Quy định đặt trước (RESERVATION_HOLD_DAYS), (2) **Chính sách tiền phạt**: Phạt trễ hạn (FINE_RATE_PER_DAY VNĐ/ngày), Phạt sách hư hỏng/mất (theo giá sách), Hình thức thanh toán (tiền mặt tại quầy, online qua VietQR), (3) **Quyền lợi và nghĩa vụ**: Quyền của độc giả, Nghĩa vụ bảo quản sách, Xử lý vi phạm, (4) **Hướng dẫn sử dụng**: Cách tra cứu sách online, Cách đặt trước và gia hạn, Liên hệ thư viện. Content MUST được format rõ ràng với headings, lists, tables, và được viết hoàn toàn bằng **tiếng Việt**.
  * *Mapping:* UC-48

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* SEO & Khả dụng: Đầy đủ các thẻ meta SEO, giao diện responsive mượt mà trên điện thoại và máy tính.
* Độ khả dụng: 100% nội dung hiển thị bằng tiếng Việt chuẩn.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng Notification
* `notificationId` (INT, PK)
* `isPinned` (BOOLEAN)
* `status` (VARCHAR(50))



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE CSDL không hoạt động, THE system SHALL hiển thị trang tĩnh giới thiệu thư viện cơ bản kèm thông tin liên hệ offline.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Truy cập trang chủ: Khách vãng lai mở trang -> Trang chủ hiển thị slide tin tức và danh sách sách nổi bật.
- [ ] Xem chính sách phạt: Xem chính sách phạt -> Hiển thị đúng bảng giá phạt trễ hạn 5,000đ/ngày.

## 9. Out of Scope (Phạm vi không thực hiện)
* Đăng ký tài khoản trực tuyến từ trang công khai.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.