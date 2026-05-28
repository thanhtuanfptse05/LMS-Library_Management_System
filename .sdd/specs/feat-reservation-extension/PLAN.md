# Implementation Plan: feat-reservation-extension (Đặt trước & Gia hạn sách)

## 1. Database & Models
- `Reservation.java` (reservationId, userId, bookId, bookCopyId, status, queuePosition, startDate, endDate)

## 2. Service & DAO Layers
- **`ReservationDAO.java`**:
  - `createReservation(Reservation res)`: Tạo hàng chờ đặt trước mới.
  - `getNextInQueue(int bookId)`: Tìm người tiếp theo có status = 'pending' và queuePosition thấp nhất.
  - `updateReservationStatus(int reservationId, String status, int copyId, Date endDate)`
  - `getExpiredReservations()`: Tìm các reservation có status = 'readypickup' và endDate bé hơn ngày hiện tại.
  - `getReservationsByUserId(int userId)`
- **`ReservationService.java`**:
  - `reserveBook(int userId, int bookId)`: Thực hiện logic kiểm tra available_quantity == 0, tính toán `queuePosition` bằng cách đếm số người đang chờ + 1. Chạy trong transaction.
  - `processReturnQueue(int bookId, int bookCopyId)`: Được gọi khi trả sách để gán sách cho người tiếp theo.
  - `checkExpiredReservations()`: Tự động chạy hàng ngày hoặc gọi qua Scheduler/Batch để dọn dẹp các đặt trước quá hạn.
- **`ExtensionService.java`**:
  - `extendLoan(int borrowRecordId)`: Thực hiện logic kiểm tra giới hạn lần gia hạn, kiểm tra hàng chờ đặt trước sách của cuốn đó, kiểm tra nợ phạt người dùng trước khi cập nhật hạn trả.

## 3. Servlets (Controllers)
Đặt tại package `controller.transaction`:
- `ReserveBookServlet.java` (POST /student/reserve): Xử lý yêu cầu đặt trước sách.
- `ExtendBookServlet.java` (POST /student/extend): Tiếp nhận yêu cầu gia hạn thời gian mượn từ sinh viên/giảng viên.
- `ManageReservationServlet.java` (GET/POST /librarian/reservations): Cho phép thủ thư xem các hàng chờ đặt trước và xử lý trao sách khi người dùng đến lấy sách trạng thái 'readypickup'.

## 4. Views (JSPs)
- `/web/WEB-INF/views/student/my-reservations.jsp`: Trang hiển thị danh sách các sách đang chờ, vị trí trong hàng chờ.
- `/web/WEB-INF/views/librarian/manage-reservations.jsp`: Trang quản lý hàng chờ dành cho thủ thư.
