# Task Breakdown: feat-reservation-extension

- [ ] **Reservation Database Models & DAO**
  - [ ] Khai báo model `Reservation`.
  - [ ] Viết `ReservationDAO.java` chứa các hàm thao tác hàng chờ đặt trước (FIFO).
  - [ ] Thiết kế logic xác định vị trí tiếp theo trong hàng chờ.

- [ ] **Online Book Extension & Reservation (Gia hạn & Đặt trước)**
  - [ ] Viết `ReservationServlet.java` (POST /reservation) tiếp nhận yêu cầu đặt trước từ UI.
  - [ ] Viết `CancelReservationServlet.java` (POST /cancel-reservation) tiếp nhận yêu cầu hủy đặt trước.
  - [ ] Viết `ExtendBookServlet.java` (POST /extend-book) tiếp nhận yêu cầu gia hạn.
  - [ ] Implement logic kiểm tra tại `ExtensionService.java`: check `extension_count`, check nợ phạt, check hàng chờ (`Reservation.status = 'pending'`).
  - [ ] Implement logic kiểm tra tại `ReservationService.java`: check borrow limit (`BR-LMS-005`) trước khi tạo đặt trước.
  - [ ] Viết unit tests kiểm thử các trường hợp gia hạn và đặt trước hợp lệ/bất hợp lệ.

- [ ] **Reservation Queue & Return Book Linkage**
  - [ ] Bổ sung logic vào hàm trả sách: khi thủ thư nhận sách trả -> tự động gọi `ReservationService.processReturnQueue()` để chuyển trạng thái reservation cũ nhất thành 'readypickup', gán copy ID, và gửi email bất đồng bộ.
  - [ ] Viết unit tests giả lập luồng trả sách tự động gán cho người đặt trước.

- [ ] **Expiration Job & Librarian UI**
  - [ ] Tạo cơ chế chạy ngầm (hoặc daily task) quét các reservation quá hạn 3 ngày mà không đến lấy -> tự động cancel và gán cho người kế tiếp.
  - [ ] Thiết kế các trang JSP hiển thị danh sách đặt trước: `my-reservations.jsp` cho sinh viên và `manage-reservations.jsp` cho thủ thư.
