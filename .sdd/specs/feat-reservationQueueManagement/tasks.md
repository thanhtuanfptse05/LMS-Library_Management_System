# Tasks: Quản lý Hàng chờ Đặt trước dành cho Thủ thư (Librarian Reservation Queue Management)

**Feature**: Quản lý Hàng chờ Đặt trước dành cho Thủ thư  
**Spec**: [spec.md](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/.sdd/specs/feat-reservationQueueManagement/spec.md) v1.5 | **Plan**: [plan.md](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/.sdd/specs/feat-reservationQueueManagement/plan.md)

---

## Phase 1: Setup & Code Reuse Inspection (Tái sử dụng các thành phần sẵn có) — ĐÃ HOÀN THÀNH

- [x] **Task 1: XÁC NHẬN TÁI SỬ DỤNG Entity Model `model.Reservation`**
  - Target: `src/java/model/Reservation.java`
  - **Tái sử dụng 100%**, không tạo class DTO mới.

- [x] **Task 2: XÁC NHẬN TÁI SỬ DỤNG Service `OnlineCirculationService.cancelReservationByLibrarian`**
  - Target: `src/java/service/OnlineCirculationService.java`
  - **Tái sử dụng 100%**, không viết lại logic hủy đơn.

---

## Phase 2: DAO Layer (Đã hoàn thành + Bổ sung Reorder)

- [x] **Task 3: Bổ sung phương thức tra cứu phân trang `findReservationQueueForLibrarian` vào `ReservationDAO.java`**
  - Target: `src/java/dao/ReservationDAO.java`
  - Đã bổ sung `findReservationQueueForLibrarian` và `countReservationQueueForLibrarian`.

- [ ] **Task 10: Bổ sung phương thức `reorderQueuePosition` vào `ReservationDAO.java`**
  - Target: `src/java/dao/ReservationDAO.java`
  - Tạo hàm `reorderQueuePosition(Connection conn, int bookId, int reservationId, int oldPos, int newPos)`:
    - **Move Up** (`newPos < oldPos`): `UPDATE SET queuePosition = queuePosition + 1 WHERE bookId = ? AND queuePosition >= newPos AND queuePosition < oldPos AND status = 'pending'`, sau đó `UPDATE SET queuePosition = newPos WHERE reservationId = ?`.
    - **Move Down** (`newPos > oldPos`): `UPDATE SET queuePosition = queuePosition - 1 WHERE bookId = ? AND queuePosition > oldPos AND queuePosition <= newPos AND status = 'pending'`, sau đó `UPDATE SET queuePosition = newPos WHERE reservationId = ?`.
  - Tạo hàm `getMaxPendingQueuePositionForBook(Connection conn, int bookId)` để lấy giá trị `MAX(queuePosition)` của các lượt `pending` cùng `bookId`, dùng cho validation.

---

## Phase 3: Controller Layer (Đã hoàn thành + Bổ sung Reorder)

- [x] **Task 4: Tạo `LibrarianReservationQueueServlet.java` (GET Request - Danh sách hàng chờ)**
  - Target: `src/java/controllers/LibrarianReservationQueueServlet.java`

- [x] **Task 5: Xử lý Hủy lượt đặt trước trong `LibrarianReservationQueueServlet.java` (POST Request)**
  - Target: `src/java/controllers/LibrarianReservationQueueServlet.java`

- [ ] **Task 11: Xử lý Thay đổi vị trí hàng chờ trong `LibrarianReservationQueueServlet.java` (POST action=reorder)**
  - Target: `src/java/controllers/LibrarianReservationQueueServlet.java`
  - Tiếp nhận `action = "reorder"`, `reservationId`, `newPosition`.
  - Validation:
    - Đơn phải ở trạng thái `pending` (`queuePosition >= 1`).
    - `newPosition` phải nằm trong khoảng `1 ≤ newPos ≤ maxPendingPosition` và khác `oldPos`.
  - Gọi `ReservationDAO.reorderQueuePosition(conn, bookId, reservationId, oldPos, newPos)` trong 1 Transaction.
  - Ghi `AuditLogs` với `actionType = 'REORDER_RESERVATION_BY_LIBRARIAN'`, `oldValues = {"queuePosition": oldPos}`, `newValues = {"queuePosition": newPos}`.
  - Redirect về `/librarian/reservation-queue` kèm thông báo thành công/lỗi.

---

## Phase 4: View Layer (Đã hoàn thành + Bổ sung Reorder)

- [x] **Task 6: Xây dựng trang giao diện `reservation-queue.jsp`**
  - Target: `web/librarian/reservation-queue.jsp`

- [x] **Task 7: Gắn Menu điều hướng vào Sidebar Thủ thư**
  - Target: `web/librarian/fragments/_sidebar.jsp`

- [ ] **Task 12: Bổ sung nút "Đổi vị trí" và modal nhập vị trí mới vào `reservation-queue.jsp`**
  - Target: `web/librarian/reservation-queue.jsp`
  - Thêm nút **"Đổi vị trí"** ở cột Thao tác cho các đơn có `status = 'pending'` và `queuePosition >= 1`.
  - Modal nhập vị trí mới: input số nguyên dương, label hiển thị vị trí hiện tại, nút "Xác nhận đổi vị trí".
  - Form POST gửi `action=reorder`, `reservationId`, `newPosition` về Servlet.

---

## Phase 5: Verification & Testing (Đã hoàn thành + Bổ sung Reorder)

- [x] **Task 8: Viết Unit Test kiểm thử Servlet & DAO**
  - Target: `test/f05_reservation/LibrarianReservationQueueTest.java`

- [x] **Task 9: Kiểm thử Phân quyền RBAC (`AuthFilter`)**
  - Target: `src/java/filter/AuthFilter.java`

- [ ] **Task 13: Bổ sung Unit Test cho tính năng Reorder**
  - Target: `test/f05_reservation/LibrarianReservationQueueTest.java`
  - Test case:
    - Đổi vị trí #5 → #2 (Move Up): kiểm tra dịch chuyển đúng.
    - Đổi vị trí #1 → #4 (Move Down): kiểm tra dịch chuyển đúng.
    - Nhập vị trí bằng vị trí hiện tại → lỗi validation.
    - Nhập vị trí vượt max → lỗi validation.
    - Đổi vị trí cho đơn `readypickup` (queuePosition=0) → lỗi "chỉ áp dụng cho pending".
