# Task Breakdown: feat-reservation-extension

- [ ] **Reservation Database Models & DAO**
  - [ ] Khai báo model `Reservation`.
  - [ ] Viết `ReservationDAO.java` chứa các hàm thao tác hàng chờ đặt trước (FIFO).
  - [ ] Thiết kế logic xác định vị trí tiếp theo trong hàng chờ.

- [ ] **Online Book Extension (Gia hạn sách)**
  - [ ] Viết `ExtendBookServlet.java` tiếp nhận yêu cầu gia hạn từ UI.
  - [ ] Implement logic kiểm tra tại `ExtensionService.java`: check `extension_count`, check nợ phạt, check xem tựa sách có đang bị người khác đặt trước (`Reservation.status = 'pending'`).
  - [ ] Viết unit tests kiểm thử các trường hợp gia hạn hợp lệ và bất hợp lệ.

- [ ] **Reservation Queue & Return Book Linkage**
  - [ ] Bổ sung logic vào hàm trả sách: khi thủ thư nhận sách trả -> tự động gọi `ReservationService.processReturnQueue()` để chuyển trạng thái reservation cũ nhất thành 'readypickup', gán copy ID, và gửi email bất đồng bộ.
  - [ ] Viết unit tests giả lập luồng trả sách tự động gán cho người đặt trước.

- [ ] **Expiration Job & Librarian UI**
  - [ ] Tạo cơ chế chạy ngầm (hoặc daily task) quét các reservation quá hạn 3 ngày mà không đến lấy -> tự động cancel và gán cho người kế tiếp.
  - [ ] Thiết kế các trang JSP hiển thị danh sách đặt trước: `my-reservations.jsp` cho sinh viên và `manage-reservations.jsp` cho thủ thư.
