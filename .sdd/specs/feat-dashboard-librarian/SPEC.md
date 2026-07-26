# Feature Specification: Bảng điều khiển theo vai trò (Role-Based Dashboards)
# Version: 1.3 | Chủ sở hữu: Thai | Ngày cập nhật: 2026-07-26 (Chuẩn hóa UC-BR-FR registry)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp màn hình Bảng điều khiển (Dashboard) tổng quan được tùy biến theo từng vai trò người dùng (Admin, Librarian, Manager, Student, Lecturer), hiển thị các chỉ số đo lường nhanh (KPI metrics), lối tắt thao tác nhanh (Quick Actions), danh sách cảnh báo (Quá hạn, Chờ duyệt, Nợ phạt) và thông báo mới nhất.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản trị viên (SysAdmin):** Xem Dashboard tổng quan hệ thống, chỉ số người dùng, trạng thái dịch vụ và Audit Logs mới nhất.
* **Thủ thư (Librarian):** Xem Dashboard quầy lưu thông (lượt mượn/trả trong ngày, sách chờ trả, đơn đặt trước chờ nhận).
* **Quản lý Thư viện (Library Manager):** Xem Dashboard quản lý (thống kê tổng quan sách, danh mục, đề xuất mua sách chờ duyệt).
* **Sinh viên & Giảng viên:** Xem Dashboard cá nhân (sách đang mượn, ngày đến hạn trả, lịch sử mượn, thông báo nợ phạt).

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-44 (View Librarian Dashboard):** Actor: Librarian | (Xem bảng điều khiển thủ thư): Thủ thư xem tổng quan hoạt động thư viện bao gồm số lượng sách đang được mượn, số giao dịch hôm nay, sách quá hạn, và các thống kê nhanh về kho sách.

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F15 Dashboard — Librarian. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-38 (Dashboard Data Isolation):** Mỗi Dashboard (Admin/Manager/Librarian/Student/Lecturer) BẮT BUỘC chỉ hiển thị dữ liệu và chỉ số phù hợp với role của người dùng. Dashboard KHÔNG ĐƯỢC PHÉP truy xuất hoặc hiển thị dữ liệu ngoài phạm vi quyền hạn của role.


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-71 (Hiển thị Dashboard Thủ thư với stats hoạt động):** WHEN LibrarianDashboardServlet.doGet() được gọi, THE system SHALL tổng hợp dữ liệu: (1) activeBorrowsCount = BorrowRecordDAO.countAllActiveBorrows(), (2) todayCheckoutsCount = BorrowRecordDAO.countTodayCheckouts(), (3) todayCheckinsCount = BorrowRecordDAO.countTodayCheckins(), (4) overdueCount = BorrowRecordDAO.countAllOverdue(), (5) recentCheckouts = BorrowRecordDAO.findRecentCheckouts(limit=10) JOIN User, Book, (6) recentCheckins = BorrowRecordDAO.findRecentCheckins(limit=10), (7) inventoryStats = {totalBooks: BookCopyDAO.countAll(), available: COUNT(status='available'), borrowed: COUNT(status='borrowed'), unavailable: COUNT(status='unavailable'), byCondition: {good, damaged, lost}}, (8) Forward sang librarian/dashboard.jsp với tất cả stats + charts (hoạt động theo giờ trong ngày).
  * *Mapping:* UC-44 / BR-38


## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Phân quyền nghiêm ngặt bởi `AuthFilter`.
* **Hiệu năng:** Tải trang Dashboard trong dưới 250ms.
* **Giao diện:** Đồ họa thẻ thông tin (Metric Cards) hiện đại, màu sắc trực quan, 100% tiếng Việt.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
* Truy vấn tổng hợp từ `BorrowRecord`, `Reservation`, `Fine`, `BookCopy`, `Notification`, `"User"`.

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** người dùng truy cập Dashboard không đúng vai trò, **THE system SHALL** chuyển hướng về Dashboard chính xác của vai trò đó.

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-DASH-01] Đăng nhập bằng tài khoản Thủ thư chuyển hướng đến Dashboard Thủ thư với đầy đủ lối tắt Check-out/Check-in.
- [ ] [TC-DASH-02] Đăng nhập Sinh viên hiển thị đúng danh sách các sách Sinh viên đó đang mượn và ngày hẹn trả.
- [ ] [TC-DASH-03] Các chỉ số Metric Cards trên Dashboard đếm chuẩn xác theo DB.

## 8. Out of Scope (Phạm vi không thực hiện)
* Tùy biến vị trí kéo thả các widget trên Dashboard (Drag & Drop UI customization).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện toàn bộ các Servlet Dashboard cho 5 phân hệ vai trò.