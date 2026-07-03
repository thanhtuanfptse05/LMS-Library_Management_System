# Feature Specification: Các trang công khai (Public Pages)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp trang chủ công khai giới thiệu về thư viện, danh sách tin tức, thông báo mới nhất từ ban quản lý và bảng tra cứu nội quy mượn trả trực quan cho khách vãng lai chưa đăng nhập.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Khách truy cập (Guest):** Xem trang chủ, đọc tin tức, tra cứu nội quy chính sách thư viện.

## 3. Business Rules (Quy tắc nghiệp vụ)
* Không có cấu hình quy tắc nghiệp vụ riêng.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-75 (Hiển thị Trang Chủ Công Khai):** WHEN khách truy cập trang chủ, THE system SHALL truy vấn 5 thông báo quan trọng được ghim, 10 tin tức mới nhất, và 6 tựa sách nổi bật để hiển thị lên giao diện.\n* **FR-76 (Hiển thị Nội Quy Thư Viện chi tiết):** WHEN truy cập trang nội quy, THE system SHALL đọc các cấu hình liên quan (hạn mức mượn, phí phạt) từ cache và hiển thị bảng biểu chi tiết, rõ ràng bằng tiếng Việt.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* SEO & Khả dụng: Đầy đủ các thẻ meta SEO, giao diện responsive mượt mà trên điện thoại và máy tính.\n* Độ khả dụng: 100% nội dung hiển thị bằng tiếng Việt chuẩn.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng Notification\n* `notificationId` (INT, PK)\n* `isPinned` (BOOLEAN)\n* `status` (VARCHAR(50))\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE CSDL không hoạt động, THE system SHALL hiển thị trang tĩnh giới thiệu thư viện cơ bản kèm thông tin liên hệ offline.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Truy cập trang chủ: Khách vãng lai mở trang -> Trang chủ hiển thị slide tin tức và danh sách sách nổi bật.\n- [ ] Xem chính sách phạt: Xem chính sách phạt -> Hiển thị đúng bảng giá phạt trễ hạn 5,000đ/ngày.

## 9. Out of Scope (Phạm vi không thực hiện)
* Đăng ký tài khoản trực tuyến từ trang công khai.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
