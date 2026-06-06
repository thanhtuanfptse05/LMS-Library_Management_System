# PLAN.md — Kế hoạch Thực thi F6 (Desk Circulation)
# Trạng thái: APPROVED

## 1. ARCHITECTURAL APPROACH
Áp dụng Servlet MVC Pattern. Tách biệt 3 luồng giao dịch vật lý thành 3 Servlet riêng rẽ tương tác qua `DeskCirculationService`. Toàn bộ thao tác ghi (Write) BẮT BUỘC đặt trong các block SQL Transaction (kiểm soát qua Connection `setAutoCommit(false)` ở tầng Service) để đảm bảo không sai lệch dữ liệu kho.

## 2. COMPONENTS
| Component | Trách nhiệm | File |
| --- | --- | --- |
| CheckOutServlet | Xử lý Request POST giao sách, nhận Barcode và UserId. | `CheckOutServlet.java` |
| CheckInServlet | Xử lý Request POST nhận sách và đánh giá Condition. | `CheckInServlet.java` |
| CashPaymentServlet | Xử lý Request POST duyệt thanh toán tại quầy. | `CashPaymentServlet.java` |
| DeskCirculationService| Điều phối logic Transaction cốt lõi: xử lý khóa/mở khóa tài khoản, đẩy hàng đợi và luân chuyển kho. | `DeskCirculationService.java` |
| UserLockReasonDAO | Thêm, xóa và đếm (COUNT) số lý do khóa của User. | `UserLockReasonDAO.java` |
| Various DAOs | Các truy vấn INSERT, UPDATE cho Reservation, BorrowRecord, Book, BookCopy, Payment, Fine. | (Tái sử dụng & bổ sung) |

## 3. DATA FLOW
**Luồng Check-in Sách Nguyên Vẹn (Atomic Block):**
`Client` -> `CheckInServlet` -> `Service.processCheckIn()` -> `conn.setAutoCommit(false)` -> UPDATE `BorrowRecord` (returned) -> UPDATE `BookCopy` (good) -> `ReservationDAO.findNextInQueue()` -> Nếu có: UPDATE `Reservation` (0, readypickup) -> Nếu không: UPDATE `Book.availableQuantity + 1`, UPDATE `BookCopy` (available) -> `conn.commit()`.

**Luồng Duyệt Thanh Toán (Atomic Block):**
`Client` -> `CashPaymentServlet` -> `Service.approveCashPayment()` -> `conn.setAutoCommit(false)` -> UPDATE `Payment` (completed) -> UPDATE `Fine` (paid) -> DELETE `UserLockReason` (unpaid) -> SELECT COUNT `UserLockReason` -> Nếu = 0: UPDATE `User` (active) -> `conn.commit()`.

## 4. DEPENDENCIES
- Cần có `EmailService` để trigger bất đồng bộ thông báo cho người dùng tiếp theo trong hàng đợi khi sách có sẵn.
- AuthFilter cấu hình chỉ cấp quyền truy cập route `/desk/*` cho role `LIBRARIAN` và `MANAGER`.

## 5. RISKS & MITIGATIONS
- **Risk:** Cập nhật khóa/mở khóa sai trạng thái (User đang bị cấm vì bảo mật lại được mở khóa khi đóng phạt).
- **Mitigation:** Logic mở khóa kiểm tra chặt chẽ đếm COUNT bảng `UserLockReason` trong Database Transaction (FR-F6-08 / BR-25).
