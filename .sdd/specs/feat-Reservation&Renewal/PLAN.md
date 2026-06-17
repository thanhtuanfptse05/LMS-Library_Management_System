# PLAN.md — Kế hoạch Thực thi F5 (Online Circulation)
# Trạng thái: APPROVED

## 1. ARCHITECTURAL APPROACH
Áp dụng mô hình MVC thuần với Servlet. Business Logic được tập trung toàn bộ tại `OnlineCirculationService` để dễ dàng quản lý Database Transaction, qua đó chống Race Condition khi hệ thống có nhiều yêu cầu mượn/đặt trước đồng thời.

## 2. COMPONENTS
| Component | Trách nhiệm | File |
| --- | --- | --- |
| ReservationServlet | Xử lý request POST đặt trước. Map với `@WebServlet({"/student/reserve", "/lecturer/reserve"})` để tuân thủ tuyệt đối `AuthFilter`. | `ReservationServlet.java` |
| RenewalServlet | Xử lý request POST gia hạn. Map với `@WebServlet({"/student/renew", "/lecturer/renew"})`. | `RenewalServlet.java` |
| MyBorrowingsServlet | Lấy danh sách sách đang mượn và đặt trước để hiển thị trên UI. Map với `@WebServlet({"/student/my-borrowings", "/lecturer/my-borrowings"})`. | `MyBorrowingsServlet.java` |
| OnlineCirculationService| Điều phối logic kiểm tra lock, tính toán Queue, gọi DAO và commit/rollback Transaction. | `OnlineCirculationService.java` |
| ReservationDAO | Tái sử dụng/thêm các hàm: `insertOnlineReservation`, `cancelReservation`. | `ReservationDAO.java` |
| BorrowRecordDAO | Tái sử dụng/thêm hàm: `incrementExtension`, `countActiveBorrowsByUser`. | `BorrowRecordDAO.java` |
| SystemConfigDAO | Đọc các cài đặt hệ thống (MAX_BORROW_LIMIT, RENEW_THRESHOLD_PERCENT, v.v.). | `SystemConfigDAO.java` |

## 3. DATA FLOW
**Luồng Reservation (Atomic Block):**
`Client` -> `ReservationServlet` -> `Service.reserveBook()` 
  -> Mở `conn.setAutoCommit(false)` 
  -> Cố tình check defensive `UserLockReason` (dù `AuthFilter` đã chặn)
  -> Check Limit mượn/đặt (từ `SystemConfigDAO`)
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
  -> `BorrowRecordDAO.incrementExtension(conn, borrowRecordId, days)` 
  -> `conn.commit()`.

## 4. DEPENDENCIES & EXISTING CODE
- **Cơ sở dữ liệu:** PostgreSQL (Supabase). Mọi query lock phải dùng `FOR UPDATE`.
- **Hàm DAO có sẵn:** `ReservationDAO.hasQueuedReservation`, `BorrowRecordDAO.findActiveBorrowRecord` đã được code từ luồng F6, cần tái sử dụng.
- **RBAC:** Dùng Multiple URL mapping thay vì tạo route ngoài vùng phủ sóng của `AuthFilter`. Không được sửa `AuthFilter.java`.

## 5. RISKS & MITIGATIONS
- **Risk:** Race Condition (2 người đặt sách cùng lúc khi `availableQuantity = 1`).
- **Mitigation:** Trong `OnlineCirculationService`, hàm tạo Reservation BẮT BUỘC dùng Connection chung truyền vào các DAO, kết hợp `SELECT ... FOR UPDATE` trên bảng Book để khóa record sách.
- **Risk:** Lỗ hổng double submit form gia hạn/đặt trước.
- **Mitigation:** POST-Redirect-GET pattern. Sau khi POST thành công ở Servlet, ném Flash Message vào Session và `sendRedirect` về trang danh sách.
