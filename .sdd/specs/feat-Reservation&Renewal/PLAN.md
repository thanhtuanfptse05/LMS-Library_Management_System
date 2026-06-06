# PLAN.md — Kế hoạch Thực thi F5 (Online Circulation)
# Trạng thái: APPROVED

## 1. ARCHITECTURAL APPROACH
Áp dụng mô hình MVC với Servlet. Business Logic được tập trung toàn bộ tại `OnlineCirculationService` để dễ dàng quản lý Database Transaction (chống Race Condition).

## 2. COMPONENTS
| Component | Trách nhiệm | File |
| --- | --- | --- |
| ReservationServlet | Xử lý request POST /reserve. Fetch UI constraints. | `ReservationServlet.java` |
| RenewalServlet | Xử lý request POST /renew. | `RenewalServlet.java` |
| OnlineCirculationService| Điều phối logic kiểm tra lock, tính toán Queue, thực thi Transaction. | `OnlineCirculationService.java` |
| ReservationDAO | Tìm Max queue, insert Reservation, kiểm tra pending queue. | `ReservationDAO.java` |
| BorrowRecordDAO | Lấy record, update endDate & extensionCount. | `BorrowRecordDAO.java` |

## 3. DATA FLOW
**Luồng Reservation (Atomic Block):**
`Client` -> `ReservationServlet` -> `Service.reserveBook()` -> `conn.setAutoCommit(false)` -> Check `UserLockReason` -> Check Limit -> `SELECT availableQuantity FOR UPDATE` -> Nếu > 0: `Insert Reservation(0)` + `Update Book` -> Nếu = 0: `Select Max Queue` + `Insert Reservation(Max+1)` -> `conn.commit()`.

**Luồng Renewal:**
`Client` -> `RenewalServlet` -> `Service.renewBook()` -> Check rules -> `ReservationDAO.hasPendingQueue(bookId)` -> `BorrowRecordDAO.incrementExtension()` -> Trả kết quả.

## 4. DEPENDENCIES
- Cần `SystemConfigDAO` để fetch các biến: MAX_RESERVATIONS, MAX_EXTENSIONS, RENEW_THRESHOLD_PERCENT.

## 5. RISKS & MITIGATIONS
- **Risk:** Race Condition (2 người đặt sách cùng lúc khi availableQuantity = 1).
- **Mitigation:** Trong `OnlineCirculationService`, hàm tạo Reservation BẮT BUỘC dùng SQL Transaction mức `READ COMMITTED` kết hợp `SELECT ... FOR UPDATE` trên bảng Book.
