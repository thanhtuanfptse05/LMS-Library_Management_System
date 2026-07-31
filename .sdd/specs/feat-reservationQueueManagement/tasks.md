# Tasks: Quản lý Hàng chờ Đặt trước dành cho Thủ thư (Librarian Reservation Queue Management)

**Feature**: Quản lý Hàng chờ Đặt trước dành cho Thủ thư  
**Spec**: [spec.md](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/.sdd/specs/feat-reservationQueueManagement/spec.md) | **Plan**: [plan.md](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/.sdd/specs/feat-reservationQueueManagement/plan.md)

---

## Phase 1: Setup & Code Reuse Inspection (Tái sử dụng các thành phần sẵn có)

- [ ] **Task 1: XÁC NHẬN TÁI SỬ DỤNG Entity Model `model.Reservation`**
  - Target: `src/java/model/Reservation.java`
  - Đã có sẵn các thuộc tính `memberName`, `memberCode`, `bookTitle`, `status`, `queuePosition`, `startDate`, `endDate`.
  - **Tái sử dụng 100%**, không tạo class DTO mới để tránh dư thừa.

- [ ] **Task 2: XÁC NHẬN TÁI SỬ DỤNG Service `OnlineCirculationService.cancelReservationByLibrarian`**
  - Target: `src/java/service/OnlineCirculationService.java` (dòng 320)
  - Phương thức `cancelReservationByLibrarian(librarianId, reservationId)` **ĐÃ CÓ SẴN** đầy đủ logic: Hủy đơn đặt trước, ghi `AuditLogs`, tự động đôn hàng chờ (`decrementQueuePositions` / `shiftQueuePositions`) và gửi email cho độc giả tiếp theo.
  - **Tái sử dụng 100%**, không viết lại logic hủy đơn.

---

## Phase 2: DAO Layer Enhancements (Bổ sung phương thức phân trang vào DAO có sẵn)

- [ ] **Task 3: Bổ sung phương thức tra cứu phân trang `findReservationQueueForLibrarian` vào `ReservationDAO.java`**
  - Target: `src/java/dao/ReservationDAO.java`
  - Bổ sung hàm `findReservationQueueForLibrarian(Connection conn, String keyword, String status, int offset, int limit)` truy vấn danh sách `Reservation` JOIN `MemberProfile`, `Book`, `Student`, `Lecturer` để lấy danh sách hàng chờ phân trang cho Thủ thư.
  - Bổ sung hàm `countReservationQueueForLibrarian(Connection conn, String keyword, String status)` đếm tổng số dòng phục vụ tính số trang.

---

## Phase 3: Controller Layer (Tầng Servlet Controller mới)

- [ ] **Task 4: Tạo `LibrarianReservationQueueServlet.java` (GET Request - Danh sách hàng chờ)**
  - Target: `src/java/controllers/LibrarianReservationQueueServlet.java`
  - Annotation `@WebServlet(name = "LibrarianReservationQueueServlet", urlPatterns = {"/librarian/reservation-queue"})`.
  - Kiểm tra session quyền `LIBRARIAN`, tiếp nhận tham số `keyword`, `status`, `page`, gọi `ReservationDAO.findReservationQueueForLibrarian` và forward sang JSP.

- [ ] **Task 5: Xử lý Hủy lượt đặt trước trong `LibrarianReservationQueueServlet.java` (POST Request)**
  - Target: `src/java/controllers/LibrarianReservationQueueServlet.java`
  - Tiếp nhận `action = "cancel"` và `reservationId`, gọi trực tiếp hàm có sẵn `onlineCirculationService.cancelReservationByLibrarian(librarianId, reservationId)`.
  - Thiết lập thông báo thành công/lỗi và redirect về `/librarian/reservation-queue`.

---

## Phase 4: View Layer (Giao diện JSP cho Thủ thư)

- [ ] **Task 6: Xây dựng trang giao diện `reservation-queue.jsp`**
  - Target: `web/librarian/reservation-queue.jsp`
  - Thiết kế bảng danh sách hàng chờ phân trang, thanh tìm kiếm từ khóa, bộ lọc trạng thái (`ALL`, `PENDING`, `READYPICKUP`), hiển thị badge vị trí `queuePosition`.
  - Nút **"Hủy lượt"** mở modal xác nhận gọi action cancel về Servlet.

- [ ] **Task 7: Gắn Menu điều hướng vào Sidebar Thủ thư**
  - Target: `web/librarian/fragments/_librarian-left-panel.jsp`
  - Thêm tab menu **"Quản lý hàng chờ đặt trước"** dẫn tới URL `/librarian/reservation-queue`.

---

## Phase 5: Verification & Testing (Kiểm thử & Nghiệm thu)

- [ ] **Task 8: Viết Unit Test kiểm thử Servlet & DAO**
  - Target: `test/f06_desk/LibrarianReservationQueueServletTest.java`
  - Kiểm thử phân trang, tìm kiếm từ khóa, và gọi hàm `cancelReservationByLibrarian`.

- [ ] **Task 9: Kiểm thử Phân quyền RBAC (`AuthFilter`)**
  - Target: `src/java/filter/AuthFilter.java`
  - Đảm bảo URL `/librarian/reservation-queue` chỉ cho phép tài khoản `LIBRARIAN` / `ADMIN` truy cập, chặn `STUDENT` và `LECTURER`.
