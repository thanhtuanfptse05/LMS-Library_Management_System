# Tasks: Quản lý Hàng chờ Đặt trước dành cho Thủ thư (Librarian Reservation Queue Management)

**Feature**: Quản lý Hàng chờ Đặt trước dành cho Thủ thư  
**Spec**: [spec.md](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/.sdd/specs/feat-reservationQueueManagement/spec.md) | **Plan**: [plan.md](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/.sdd/specs/feat-reservationQueueManagement/plan.md)

---

## Phase 1: Setup & Foundational Tasks (Khởi tạo DTO & Cấu hình)

- [ ] **Task 1: Kiểm tra CSDL & Khóa Cấu hình Giữ sách**
  - Target: `database/supabase/seeds/02_system_configurations.sql`
  - Đảm bảo bảng `SystemConfigurations` có khóa `RESERVATION_HOLD_DAYS` để truy vấn thời gian giữ sách động (mặc định 3 ngày).

- [ ] **Task 2: Tạo `ReservationQueueItemDTO.java`**
  - Target: `src/java/dto/ReservationQueueItemDTO.java`
  - Khai báo DTO tổng hợp thông tin hàng chờ (thuần Reservation, không có BookCopy): `reservationId`, `userId`, `userCode`, `userFullName`, `userRole`, `bookId`, `bookTitle`, `isbn`, `status`, `queuePosition`, `startDate`, `endDate`.

---

## Phase 2: DAO Layer Enhancements (Tầng Truy xuất CSDL)

- [ ] **Task 3: Bổ sung các hàm tra cứu hàng chờ cho Thủ thư trong `ReservationDAO.java`**
  - Target: `src/java/dao/ReservationDAO.java`
  - Viết hàm `findReservationQueueForLibrarian(Connection conn, String keyword, String status, int offset, int limit)` sử dụng `PreparedStatement`.
  - Viết hàm `countReservationQueueForLibrarian(Connection conn, String keyword, String status)`.

- [ ] **Task 4: Bổ sung hàm Hủy lượt đặt trước bởi Thủ thư trong `ReservationDAO.java`**
  - Target: `src/java/dao/ReservationDAO.java`
  - Viết hàm `cancelReservationByLibrarian(Connection conn, int reservationId, int librarianId, String reason)` gọi service hủy và đôn hàng chờ trong Transaction.

---

## Phase 3: Controller Layer (Tầng Servlet Controller)

- [ ] **Task 5: Tạo `LibrarianReservationQueueServlet.java` (GET Request)**
  - Target: `src/java/controllers/LibrarianReservationQueueServlet.java`
  - Annotation `@WebServlet(name = "LibrarianReservationQueueServlet", urlPatterns = {"/librarian/reservation-queue"})`.
  - Tiếp nhận tham số `keyword`, `status`, `page`, tính toán `offset` và gọi `ReservationDAO` để lấy danh sách hiển thị.

- [ ] **Task 6: Xử lý thao tác Hủy lượt trong `LibrarianReservationQueueServlet.java` (POST Request)**
  - Target: `src/java/controllers/LibrarianReservationQueueServlet.java`
  - Tiếp nhận `action = "cancel"`, bắt buộc nhập `reason`, gọi `OnlineCirculationService.cancelReservationByLibrarian` thực thi trong Transaction và ghi log vào `AuditLogs`.

---

## Phase 4: View Layer (Giao diện JSP cho Thủ thư)

- [ ] **Task 7: Xây dựng trang giao diện `reservation-queue.jsp`**
  - Target: `web/librarian/reservation-queue.jsp`
  - Thiết kế bảng danh sách hàng chờ phân trang, bộ lọc từ khóa/trạng thái, hiển thị `queuePosition` màu nổi bật.
  - Tích hợp Modal nhập lý do hủy lượt dành cho Thủ thư.

- [ ] **Task 8: Gắn Menu điều hướng vào Sidebar Thủ thư**
  - Target: `web/librarian/fragments/_librarian-left-panel.jsp`
  - Bổ sung tab **"Quản lý hàng chờ đặt trước"** dẫn đến URL `/librarian/reservation-queue`.

---

## Phase 5: Verification & Testing (Kiểm thử & Nghiệm thu)

- [ ] **Task 9: Viết Unit Test cho DAO và Servlet**
  - Target: `test/f06_desk/LibrarianReservationQueueTest.java`
  - Kiểm thử happy path (tra cứu, hủy lượt, đôn vị trí hàng chờ) và các edge cases (nhập lý do rỗng, hủy lượt ở vị trí 0).

- [ ] **Task 10: Kiểm thử Phân quyền & RBAC**
  - Target: `src/java/filter/AuthFilter.java`
  - Đảm bảo đường dẫn `/librarian/reservation-queue*` được bảo vệ và chặn các tài khoản Sinh viên/Giảng viên bypass.
