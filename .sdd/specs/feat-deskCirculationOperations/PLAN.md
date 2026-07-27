# PLAN.md — Kế hoạch Thực thi F6 (Desk Circulation)
# Trạng thái: APPROVED (Cập nhật 2026-07-27: Bổ sung DeskReservationServlet & Bắt buộc Reservation)

## 1. ARCHITECTURAL APPROACH
Áp dụng Servlet MVC Pattern. Tách biệt 4 luồng giao dịch vật lý thành các Servlet riêng rẽ tương tác qua `DeskCirculationService`. Toàn bộ thao tác ghi (Write) BẮT BUỘC đặt trong các block SQL Transaction (kiểm soát qua Connection `setAutoCommit(false)` ở tầng Service) để đảm bảo không sai lệch dữ liệu kho.

## 2. COMPONENTS
| Component | Trách nhiệm | File |
| --- | --- | --- |
| CheckOutServlet | Xử lý Request POST giao sách, nhận Barcode và MemberCode. Validate đơn Reservation bắt buộc có sẵn. | `CheckOutServlet.java` |
| CheckInServlet | Xử lý Request POST nhận sách và đánh giá Condition. | `CheckInServlet.java` |
| CashPaymentServlet | Xử lý Request POST duyệt thanh toán tại quầy. | `CashPaymentServlet.java` |
| DeskReservationServlet | Xử lý Request POST đăng ký đặt trước tại quầy thay độc giả (UC-51). | `DeskReservationServlet.java` |
| DeskCirculationService| Điều phối logic Transaction cốt lõi: xác thực đơn đặt trước, xử lý hàng đợi, luân chuyển kho, tự động tạo BookCopyIncident khi hỏng/mất. | `DeskCirculationService.java` |
| BookCopyIncidentDAO | INSERT bản ghi sự cố vào bảng `BookCopyIncident` khi check-in sách hỏng/mất. | `BookCopyIncidentDAO.java` |
| FineDAO | Truy vấn và cập nhật nợ phạt để chặn mượn sách. | `FineDAO.java` |
| Various DAOs | Các truy vấn INSERT, UPDATE cho Reservation, BorrowRecord, Book, BookCopy, Payment, Fine. | (Tái sử dụng & bổ sung) |

## 3. DATA FLOW
**Luồng Check-out Giao sách (Bắt buộc Reservation):**
`Client` -> `CheckOutServlet` -> `Service.processCheckOut()` -> `conn.setAutoCommit(false)` -> Check unpaid fine (BR-22) -> Validate barcode -> Check Reservation `readyPickup` (BR-23) [If NULL -> Throw error] -> INSERT `BorrowRecord` -> UPDATE `Reservation` (fulfilled) -> UPDATE `BookCopy` (borrowed) -> `conn.commit()` -> `EmailService.enqueue()` [async].

**Luồng Đăng ký Đặt trước tại quầy (UC-51):**
`Client` -> `DeskReservationServlet` -> `OnlineCirculationService.reserveBook()` -> `conn.setAutoCommit(false)` -> Validate fine (BR-22) & quota (BR-21) -> INSERT `Reservation` -> `conn.commit()`.

**Luồng Check-in Sách Hỏng/Mất (Atomic Block + Incident resolved):**
`Client` -> `CheckInServlet` -> `Service.processCheckIn()` -> `conn.setAutoCommit(false)` -> UPDATE `BorrowRecord` (condition) -> UPDATE `BookCopy.status='unavailable', condition=condition` -> IF lost: UPDATE `Book.totalQuantity - 1` và set `BookCopy.removedFromInventory=true`; IF damaged: giữ `totalQuantity` -> `BookCopyIncidentDAO.insertResolvedFromCheckIn(...)` với `status='resolved'` -> INSERT `Fine` + INSERT `Payment(pending)` -> INSERT `UserLockReason('unpaid')` -> UPDATE `User.status='locked'` -> INSERT `AuditLog` -> `conn.commit()`.

**Luồng Duyệt Thanh Toán (Atomic Block):**
`Client` -> `CashPaymentServlet` -> `Service.approveCashPayment()` -> `conn.setAutoCommit(false)` -> UPDATE `Payment` (completed) -> UPDATE `Fine` (paid) -> DELETE `UserLockReason('unpaid')` -> Check remaining locks (BR-25) -> `conn.commit()`.

## 4. DEPENDENCIES
- Cần có `EmailService` để trigger bất đồng bộ thông báo cho người dùng tiếp theo trong hàng đợi khi sách có sẵn.
- DeskCirculationService sử dụng BookCopyIncidentDAO.insertResolvedFromCheckIn(...) để ghi nhận incident đã kết luận khi check-in hỏng/mất tại quầy.
- AuthFilter cấu hình chỉ cấp quyền truy cập route `/librarian/*` cho role `LIBRARIAN` và `MANAGER`.

## 5. RISKS & MITIGATIONS
- **Risk:** Gỡ khóa nhầm tài khoản đang bị vi phạm kỷ luật hoặc bảo mật khi đóng tiền phạt.
- **Mitigation:** Đếm COUNT bản ghi trong UserLockReason trước khi gỡ khóa (BR-25). Chỉ chuyển status='active' nếu COUNT == 0.
