# PLAN.md — Kế hoạch Thực thi F5 (Online Circulation)
# Trạng thái: APPROVED

## 1. ARCHITECTURAL APPROACH
Áp dụng mô hình MVC thuần với Servlet. Business Logic được tập trung toàn bộ tại `OnlineCirculationService` để dễ dàng quản lý Database Transaction, qua đó chống Race Condition khi hệ thống có nhiều yêu cầu mượn/đặt trước đồng thời.

## 2. COMPONENTS
| Component | Trách nhiệm | File |
| --- | --- | --- |
| ReservationServlet | Xử lý request POST đặt trước. Map với `@WebServlet({"/student/reserve", "/lecturer/reserve"})` để tuân thủ tuyệt đối `AuthFilter`. | `ReservationServlet.java` |
| RenewalServlet | Xử lý request POST gia hạn. Map với `@WebServlet({"/student/renew", "/lecturer/renew"})`. | `RenewalServlet.java` |
| CancelReservationServlet | Xử lý request POST Hủy đặt trước. Phân phối hàng đợi cho người kế tiếp. Map với `@WebServlet({"/student/cancel-reservation", "/lecturer/cancel-reservation"})`. | `CancelReservationServlet.java` |
| MyBorrowingsServlet | Lấy danh sách sách đang mượn và đặt trước để hiển thị trên UI. Map với `@WebServlet({"/student/my-borrowings", "/lecturer/my-borrowings"})`. | `MyBorrowingsServlet.java` |
| OnlineCirculationService| Điều phối logic kiểm tra lock, tính toán Queue, Hủy đặt trước đôn hàng đợi, gọi DAO và commit/rollback Transaction. | `OnlineCirculationService.java` |
| ReservationDAO | Tái sử dụng/thêm các hàm: `insertOnlineReservation`, `cancelReservation`, `findNextInQueue`, `promoteQueuePosition`. | `ReservationDAO.java` |
| BorrowRecordDAO | Tái sử dụng/thêm hàm: `incrementExtension`, `countActiveBorrowsByUser`. | `BorrowRecordDAO.java` |
| SystemConfigDAO | Đọc cài đặt (STUDENT_MAX_BORROW_LIMIT, LECTURER_MAX_BORROW_LIMIT, MAX_EXTENSION_COUNT, RENEW_THRESHOLD_PERCENT, RENEW_DURATION_DAYS). | `SystemConfigDAO.java` |

## 3. DATA FLOW
**Luồng Reservation (Atomic Block):**
`Client` -> `ReservationServlet` -> `Service.reserveBook()` 
   -> Mở `conn.setAutoCommit(false)` 
   -> Check Limit mượn/đặt (từ `SystemConfigDAO` theo Role của User)
  -> Gọi `SELECT availableQuantity FROM Book WHERE bookId=? FOR UPDATE` (Lock dòng của sách)
  -> Phân nhánh:
     - Nếu `availableQuantity > 0`: `Insert Reservation (queuePosition=0, status='readypickup')` + `UPDATE Book.availableQuantity -= 1`. Gửi Email/Notification.
     - Nếu `availableQuantity == 0`: `SELECT MAX(queuePosition)` + `Insert Reservation (queuePosition=MAX+1, status='pending')`. Gửi Notification.
  -> `conn.commit()`.

**Luồng Renewal:**
`Client` -> `RenewalServlet` -> `Service.renewBook()` 
  -> Mở `conn.setAutoCommit(false)`
  -> Check % thời gian đã qua >= `RENEW_THRESHOLD_PERCENT`
  -> Check `extensionCount < MAX_EXTENSION_COUNT`
  -> Check `ReservationDAO.hasQueuedReservation(conn, bookId)` (Từ chối nếu có người xếp hàng)
   -> `BorrowRecordDAO.incrementExtension(conn, borrowRecordId, RENEW_DURATION_DAYS)` 
   -> `conn.commit()`.

**Luồng Cancel Reservation (Atomic Block):**
`Client` -> `CancelReservationServlet` -> `Service.cancelReservation()`
  -> Mở `conn.setAutoCommit(false)`
  -> Lấy Reservation đang muốn hủy. Cập nhật status = 'cancelled'.
  -> Phân nhánh:
     - Nếu Reservation cũ là `queue=0` (readypickup): Tìm người `queue=1`. Nếu có, chuyển người đó lên `queue=0` (readypickup) và gửi Email Sách sẵn sàng. Nếu không, `UPDATE Book.availableQuantity += 1`.
     - Nếu Reservation cũ là `queue>0` (pending): Bỏ qua.
  -> `conn.commit()`.

**Thiết kế Mẫu Email Sách Sẵn Sàng (DocumentTemp):**
Hệ thống sử dụng bảng `DocumentTemp` (mã `RESERVATION_READY`) để quản lý nội dung email.
- **Loại nội dung:** HTML hoàn chỉnh.
- **Biến tham số (Placeholders):** Hệ thống sẽ map dữ liệu vào các biến `{{userName}}` và `{{bookTitle}}` thông qua hàm `replace()`.
- **Cách gửi:** Gọi `EmailService.sendAsyncHtmlEmail()` để gửi bất đồng bộ, tránh làm chậm luồng UX.

## 4. DEPENDENCIES & EXISTING CODE
- **Cơ sở dữ liệu:** PostgreSQL (Supabase). Mọi query lock phải dùng `FOR UPDATE`.
- **Hàm DAO có sẵn:** `ReservationDAO.hasQueuedReservation`, `BorrowRecordDAO.findActiveBorrowRecord` đã được code từ luồng F6, cần tái sử dụng.
- **RBAC:** Dùng Multiple URL mapping thay vì tạo route ngoài vùng phủ sóng của `AuthFilter`. Không được sửa `AuthFilter.java`.

## 5. RISKS & MITIGATIONS
- **Risk:** Race Condition (2 người đặt sách cùng lúc khi `availableQuantity = 1`).
- **Mitigation:** Trong `OnlineCirculationService`, hàm tạo Reservation BẮT BUỘC dùng Connection chung truyền vào các DAO, kết hợp `SELECT ... FOR UPDATE` trên bảng Book để khóa record sách.
- **Risk:** Lỗ hổng double submit form gia hạn/đặt trước.
- **Mitigation:** POST-Redirect-GET pattern. Sau khi POST thành công ở Servlet, ném Flash Message vào Session và `sendRedirect` về trang danh sách.
