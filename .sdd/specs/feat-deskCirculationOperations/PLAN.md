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
| DeskCirculationService| Điều phối logic Transaction cốt lõi: xử lý hàng đợi, luân chuyển kho, **tự động tạo BookCopyIncident khi hỏng/mất**. | `DeskCirculationService.java` |
| BookCopyIncidentDAO | **[BỔ SUNG]** INSERT bản ghi sự cố vào bảng `BookCopyIncident` khi check-in sách hỏng/mất. Hàm `insert(Connection, BookCopyIncident)` đã tồn tại, chưa được gọi từ Service. | `BookCopyIncidentDAO.java` |
| FineDAO | Truy vấn và cập nhật nợ phạt để chặn mượn sách. | `FineDAO.java` |
| Various DAOs | Các truy vấn INSERT, UPDATE cho Reservation, BorrowRecord, Book, BookCopy, Payment, Fine. | (Tái sử dụng & bổ sung) |

## 3. DATA FLOW
**Luồng Check-in Sách Hỏng/Mất (Atomic Block + Incident resolved):**
`Client` -> `CheckInServlet` -> `Service.processCheckIn()` -> `conn.setAutoCommit(false)` -> UPDATE `BorrowRecord` (condition) -> UPDATE `BookCopy.status='unavailable', condition=condition` -> IF lost: UPDATE `Book.totalQuantity - 1` và set `BookCopy.removedFromInventory=true`; IF damaged: giữ `totalQuantity` -> `BookCopyIncidentDAO.insertResolvedFromCheckIn(...)` với `status='resolved'` -> INSERT `Fine` + INSERT `Payment(pending)` -> INSERT `UserLockReason('unpaid')` -> UPDATE `User.status='locked'` -> INSERT `AuditLog` -> `conn.commit()`. Không cộng `availableQuantity`, không luân chuyển hàng chờ; F13 chỉ xem và khôi phục sau sửa hoặc loại khỏi kho nếu là damaged.

**Luồng Duyệt Thanh Toán (Atomic Block):**
`Client` -> `CashPaymentServlet` -> `Service.approveCashPayment()` -> `conn.setAutoCommit(false)` -> UPDATE `Payment` (completed) -> UPDATE `Fine` (paid) -> `conn.commit()`.

## 4. DEPENDENCIES
- Cần có `EmailService` để trigger bất đồng bộ thông báo cho người dùng tiếp theo trong hàng đợi khi sách có sẵn.
- DeskCirculationService sử dụng BookCopyIncidentDAO.insertResolvedFromCheckIn(...) để ghi nhận incident đã kết luận khi check-in hỏng/mất tại quầy.
- Cần import model `BookCopyIncident` để tạo đối tượng incident trước khi truyền vào DAO.
- Cần dùng chung state machine sự cố F13 cho mọi trường hợp hỏng/mất phát hiện tại quầy.
- AuthFilter cấu hình chỉ cấp quyền truy cập route `/desk/*` cho role `LIBRARIAN` và `MANAGER`.

## 5. RISKS & MITIGATIONS
- **Risk:** Gỡ khóa nhầm tài khoản đang bị vi phạm kỷ luật hoặc bảo mật khi đóng tiền phạt.
- **Mitigation:** Loại bỏ hoàn toàn liên kết giữa tiền phạt và trạng thái khóa tài khoản của User. Độc giả nợ phạt vẫn ở trạng thái tài khoản active nhưng bị chặn mượn sách bằng cách truy vấn trực tiếp bảng `Fine` (status='unpaid'). Việc cấm/khóa tài khoản chỉ áp dụng độc lập cho các lý do kỷ luật/bảo mật.
- **Risk:** F6 và F13 xử lý hỏng/mất theo hai state machine khác nhau.
- **Mitigation:** F6 tạo incident `resolved` cho hỏng/mất tại quầy; F13 không resolve/reject lại, chỉ tra cứu và khôi phục sau sửa hoặc loại khỏi kho nếu là damaged.
