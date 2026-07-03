# Feature Specification: Bảng điều khiển Thủ thư (Dashboard Librarian)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp bảng thống kê và giám sát nhanh dành riêng cho Thủ thư (Librarian) ngay khi đăng nhập để theo dõi lượng giao dịch mượn/trả trong ngày, sách quá hạn, và tình trạng kho sách vật lý.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Xem thống kê giao dịch và hoạt động tại quầy.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-44 (View Librarian Dashboard):** Actor: Librarian | (Xem bảng điều khiển thủ thư): Thủ thư xem tổng quan hoạt động thư viện bao gồm số lượng sách đang được mượn, số giao dịch hôm nay, sách quá hạn, và các thống kê nhanh về kho sách.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-44 (View Librarian Dashboard):** Actor: Librarian | (Xem bảng điều khiển thủ thư): Thủ thư xem tổng quan hoạt động thư viện bao gồm số lượng sách đang được mượn, số giao dịch hôm nay, sách quá hạn, và các thống kê nhanh về kho sách.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-44 (View Librarian Dashboard):** Actor: Librarian | (Xem bảng điều khiển thủ thư): Thủ thư xem tổng quan hoạt động thư viện bao gồm số lượng sách đang được mượn, số giao dịch hôm nay, sách quá hạn, và các thống kê nhanh về kho sách.

## 3. Business Rules (Quy tắc nghiệp vụ)
*(Không có Business Rule riêng biệt)*

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-71 (Hiển thị Dashboard Thủ thư với stats hoạt động):** WHEN LibrarianDashboardServlet.doGet() được gọi, THE system SHALL tổng hợp dữ liệu: (1) activeBorrowsCount = BorrowRecordDAO.countAllActiveBorrows(), (2) todayCheckoutsCount = BorrowRecordDAO.countTodayCheckouts(), (3) todayCheckinsCount = BorrowRecordDAO.countTodayCheckins(), (4) overdueCount = BorrowRecordDAO.countAllOverdue(), (5) recentCheckouts = BorrowRecordDAO.findRecentCheckouts(limit=10) JOIN User, Book, (6) recentCheckins = BorrowRecordDAO.findRecentCheckins(limit=10), (7) inventoryStats = {totalBooks: BookCopyDAO.countAll(), available: COUNT(status='available'), borrowed: COUNT(status='borrowed'), unavailable: COUNT(status='unavailable'), byCondition: {good, damaged, lost}}, (8) Forward sang librarian/dashboard.jsp với tất cả stats + charts (hoạt động theo giờ trong ngày).
  * *Mapping:* UC-44 / BR-38

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Hiệu năng: Trang tải nhanh dưới 500ms.
* Độ chính xác: Số liệu giao dịch trong ngày phải được cập nhật tức thời theo thời gian thực.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng BorrowRecord
* `borrowRecordId` (INT, PK)
* `status` (VARCHAR(50))



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE lỗi truy xuất dữ liệu thống kê CSDL, THE system SHALL hiển thị thông báo lỗi chung và giữ nguyên giao diện khung dashboard.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Truy cập dashboard: Đăng nhập tài khoản Librarian -> Dashboard hiển thị đầy đủ 4 thẻ thống kê nhanh và biểu đồ hoạt động.

## 9. Out of Scope (Phạm vi không thực hiện)
* Xem báo cáo tài chính chi tiết hoặc cấu hình hệ thống trên dashboard này.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.