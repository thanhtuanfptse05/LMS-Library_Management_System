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
| DeskCirculationService| Điều phối logic Transaction cốt lõi: xử lý hàng đợi và luân chuyển kho. | `DeskCirculationService.java` |
| FineDAO | Truy vấn và cập nhật nợ phạt để chặn mượn sách. | `FineDAO.java` |
| Various DAOs | Các truy vấn INSERT, UPDATE cho Reservation, BorrowRecord, Book, BookCopy, Payment, Fine. | (Tái sử dụng & bổ sung) |

## 3. DATA FLOW
**Luồng Check-in Sách Nguyên Vẹn (Atomic Block):**
`Client` -> `CheckInServlet` -> `Service.processCheckIn()` -> `conn.setAutoCommit(false)` -> UPDATE `BorrowRecord` (returned) -> UPDATE `BookCopy` (good) -> `ReservationDAO.findNextInQueue()` -> Nếu có: UPDATE `Reservation` (0, readypickup) -> Nếu không: UPDATE `Book.availableQuantity + 1`, UPDATE `BookCopy` (available) -> `conn.commit()`.

**Luồng Check-in Sách Hỏng/Mất (Atomic Block + F13 Handoff):**
`Client` -> `CheckInServlet` -> `Service.processCheckIn()` -> `conn.setAutoCommit(false)` -> UPDATE `BorrowRecord` (returned) -> UPDATE `BookCopy.status='unavailable'` -> INSERT `BookCopyIncident(status='pending')` theo F13 -> ghi phạt/khóa theo chính sách lưu thông -> Audit -> `conn.commit()`. Không cộng `availableQuantity`, không luân chuyển hàng chờ, không dùng incident status cũ `open`; xử lý resolve/reject/restore thuộc F13.

**Luồng Duyệt Thanh Toán (Atomic Block):**
`Client` -> `CashPaymentServlet` -> `Service.approveCashPayment()` -> `conn.setAutoCommit(false)` -> UPDATE `Payment` (completed) -> UPDATE `Fine` (paid) -> `conn.commit()`.

## 4. DEPENDENCIES
- Cần có `EmailService` để trigger bất đồng bộ thông báo cho người dùng tiếp theo trong hàng đợi khi sách có sẵn.
- Cần dùng chung state machine sự cố F13 cho mọi trường hợp hỏng/mất phát hiện tại quầy.
- AuthFilter cấu hình chỉ cấp quyền truy cập route `/desk/*` cho role `LIBRARIAN` và `MANAGER`.

## 5. RISKS & MITIGATIONS
- **Risk:** Gỡ khóa nhầm tài khoản đang bị vi phạm kỷ luật hoặc bảo mật khi đóng tiền phạt.
- **Mitigation:** Loại bỏ hoàn toàn liên kết giữa tiền phạt và trạng thái khóa tài khoản của User. Độc giả nợ phạt vẫn ở trạng thái tài khoản active nhưng bị chặn mượn sách bằng cách truy vấn trực tiếp bảng `Fine` (status='unpaid'). Việc cấm/khóa tài khoản chỉ áp dụng độc lập cho các lý do kỷ luật/bảo mật.
- **Risk:** F6 và F13 xử lý hỏng/mất theo hai state machine khác nhau.
- **Mitigation:** F6 chỉ tạo incident `pending` và ngừng lưu thông bản sao; mọi xác minh, kết luận, bác bỏ hoặc khôi phục dùng F13/BR-28.
