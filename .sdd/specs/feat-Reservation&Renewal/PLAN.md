# PLAN.md — Kế hoạch & Thiết kế Kiến trúc F5 (Online Reservation & Renewal)
# Trạng thái: APPROVED | Cập nhật: 2026-06-24

## 1. ARCHITECTURAL APPROACH
Hệ thống sử dụng mô hình MVC Monolith thuần với Servlet:
- Business Logic được tập trung tại `OnlineCirculationService` để dễ dàng quản lý Database Transaction và chống Race Condition khi đặt sách.
- **Tiến trình ngầm Reservation Expiration (Hủy hàng chờ):** Triển khai lớp `ReservationExpirationProcessor.java` chạy định kỳ mỗi 1 giờ (đăng ký qua `AppContextListener` bằng `ScheduledExecutorService`). Khi chạy, tiến trình quét các đơn đặt trước quá hạn nhận sách, thực thi transaction cô lập cho từng bản ghi quá hạn, gán bản sao sách cho người đang xếp hàng tiếp theo nếu có, hoặc trả sách về kho chung.

---

## 2. COMPONENTS MAPPING (Sơ đồ thành phần tham gia)

| Tên lớp/File | Trách nhiệm trong hệ thống | Trạng thái |
|---|---|---|
| `dao.ReservationDAO` | Quản lý các đơn đặt trước. Bổ sung/refactor hàm `cancelExpiredReservations` để thực hiện hủy và đôn hàng chờ trong Transaction (lấy động cấu hình giữ sách từ `SystemConfigurations`). | Cần sửa |
| `service.OnlineCirculationService` | Phụ trách logic đặt trước, gia hạn và hủy đặt trước của người dùng. | Đã có |
| `service.ReservationExpirationProcessor` | Lớp dịch vụ chạy ngầm chính, điều phối toàn bộ transaction hủy đặt trước quá hạn, đôn hàng chờ và gửi email. | **Tạo mới** |
| `controllers.ReservationServlet` | Tiếp nhận yêu cầu đặt trước sách của độc giả. | Đã có |
| `controllers.RenewalServlet` | Tiếp nhận yêu cầu gia hạn sách của độc giả. | Đã có |
| `controllers.CancelReservationServlet` | Tiếp nhận yêu cầu hủy đơn đặt sách chủ động từ độc giả. | Đã có |
| `controllers.TriggerReservationExpirationServlet` | Servlet `/admin/trigger-reservation-expiration` (POST) cho phép Admin chạy quét thủ công qua dashboard. | **Tạo mới** |
| `config.AppContextListener` | Khởi tạo/hủy `ScheduledExecutorService` chạy `ReservationExpirationProcessor` định kỳ 1 giờ/lần theo thiết kế vòng đời chung tại [F-AsyncEmail SPEC Section 9](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/.sdd/specs/feat-asyncEmailSender/SPEC.md#9-thiet-ke-lifecycle-va-thu-tu-khoi-tao-appcontextlistener-lifecycle). | Cần sửa |
| `service.EmailService` | Tái sử dụng API gửi email thông báo nhận sách sẵn có cho độc giả mới được đôn hàng chờ. | Đã có |
| `web/admin/dashboard-admin.jsp` | Thêm nút kích hoạt tiến trình quét hủy đặt trước thủ công dành cho quản trị viên. | Cần sửa |

---

## 3. DATA FLOW (Luồng dữ liệu giao dịch)

### 3.1. Luồng chạy Reservation Expiration (Background & Trigger)
1. **Trigger:** Đến chu kỳ (mỗi 1 giờ hoặc Admin nhấn nút trigger thủ công) -> `ReservationExpirationProcessor.processExpiration()` được gọi.
2. **Select:** Gọi `ReservationDAO` quét danh sách đơn hàng có `status = 'readypickup' AND endDate < NOW()`.
3. **Vòng lặp cô lập từng đơn quá hạn:**
   - Mở Database Transaction riêng biệt (`setAutoCommit(false)`).
   - Cập nhật đơn đặt trước quá hạn: `status = 'cancelled'`, `queuePosition = NULL`.
   - Kiểm tra hàng chờ của đầu sách (`bookId`): Tìm xem có người đang chờ tiếp theo (`queuePosition = 1` và `status = 'pending'`).
   - Phân nhánh:
     - **Nhánh A (Có người xếp hàng tiếp theo):**
       * Cập nhật Reservation người mới: `queuePosition = 0`, `status = 'readypickup'`, `endDate = NOW() + INTERVAL '1 day' * (SELECT configValue::INTEGER FROM SystemConfigurations WHERE configKey = 'RESERVATION_HOLD_DAYS')`, gán `bookCopyId` vừa giải phóng.
       * Giữ `BookCopy.status = 'available'`; Reservation chỉ giữ suất trừu tượng.
       * Dịch chuyển các vị trí hàng đợi phía sau (`queuePosition = queuePosition - 1` cho các đơn pending của bookId đó).
       * Ghi Audit Log (`actionType = 'CANCEL_EXPIRED_RESERVATION'`, `userId = NULL`).
       * Commit Transaction.
       * Đẩy job gửi thư thông báo sách sẵn sàng cho người dùng mới vào hàng đợi bất đồng bộ (`EmailService.enqueue(new EmailJob("RESERVATION_READY", ...))`).
     - **Nhánh B (Hàng chờ trống):**
       * Cập nhật trạng thái bản sao vật lý `BookCopy.status = 'available'`.
       * Tăng availableQuantity của đầu sách: `Book.availableQuantity = availableQuantity + 1`.
       * Ghi Audit Log (`actionType = 'CANCEL_EXPIRED_RESERVATION'`, `userId = NULL`).
       * Commit Transaction.
   - Nếu xảy ra lỗi -> Rollback cho đơn hiện tại, log lỗi và tiếp tục vòng lặp xử lý các đơn quá hạn khác.

---

## 4. DEPENDENCIES & RISKS (Phụ thuộc & Rủi ro)
- **Tranh chấp Transaction (Locking):** Khi tiến trình ngầm đang cập nhật trạng thái đơn hàng của cuốn sách, thủ thư cũng có thể đang thực hiện Check-out cuốn sách đó tại quầy. Bắt buộc sử dụng `FOR UPDATE` khi quét danh sách quá hạn và khóa dòng bản sao sách liên quan.
- **Rò rỉ Connection:** Bắt buộc đóng Connection trong khối `finally` của vòng lặp tiến trình để ngăn ngừa cạn kiệt connection pool Supabase.
