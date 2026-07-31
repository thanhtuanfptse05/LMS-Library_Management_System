# Phase 0 Research: Quản lý Hàng chờ Đặt trước dành cho Thủ thư (Librarian Reservation Queue Management)

## Research Findings & Decisions

### 1. Phân định ranh giới tính năng (Feature Scope Boundary)
* **Status Quo (Đã có sẵn)**:
  - Sinh viên/Giảng viên đã có Servlet `ReservationServlet` (`/student/reserve`), `CancelReservationServlet` (`/student/cancel-reservation`) và màn hình `my-borrowings.jsp`.
* **New Scope (Tính năng mới cần phát triển)**:
  - Phân hệ quản lý hàng chờ dành cho Thủ thư (Librarian Queue Management Portal).
  - URL Pattern: `/librarian/reservation-queue`, `/librarian/reservation-queue/cancel`, `/librarian/reservation-queue/fulfill`.

### 2. Xử lý logic đôn vị trí hàng chờ khi Thủ thư can thiệp
* **Decision**: Khi Thủ thư hủy lượt đặt trước hoặc chuyển cấp sách tại quầy:
  - Tầng Service (`DeskCirculationService`) thực hiện Transaction nguyên tử (`connection.setAutoCommit(false)`).
  - Gọi `ReservationDAO.cancelReservationByLibrarian(conn, reservationId, librarianId, reason)` hoặc `ReservationDAO.fulfillReservationAtDesk(conn, reservationId, librarianId, barcode)`.
  - Nếu đơn bị hủy đang giữ `BookCopy` (`ready_for_pickup`), tìm ngay người có `queuePosition = 1` của cùng `bookId` để chuyển `BookCopy` sang người đó và đặt `endDate = NOW() + RESERVATION_HOLD_DAYS` (đọc từ `SystemConfigurations`).
* **Rationale**: Tránh thất thoát sách và đảm bảo hàng chờ liên tục không bị gián đoạn.

### 3. Thiết kế Giao diện Thủ thư (JSP View)
* **Decision**: Tạo file `web/librarian/reservation-queue.jsp` nằm trong nhánh giao diện quản trị của Thủ thư, sử dụng JSTL `<c:forEach>`, `<c:if>`, tích hợp modal xem sơ đồ hàng chờ theo tựa sách và modal nhập lý do hủy lượt đặt trước.
