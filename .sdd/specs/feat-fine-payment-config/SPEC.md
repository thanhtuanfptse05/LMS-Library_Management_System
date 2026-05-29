# Feature Specification: feat-fine-payment-config (Xử lý Phạt, VNPAY, Cấu hình & Nhật ký hệ thống)
# Version: 1.0.0 | Owner: Member 5 | Date: 2026-05-29

---

## 1. Context & Goal

**Mục tiêu:** Xây dựng module quản lý tài chính và cấu hình hệ thống bao gồm: tự động quét sách quá hạn và tính phạt hàng ngày (Daily Fine batch), tích hợp cổng thanh toán trực tuyến VNPAY để đóng phạt, quản lý các tham số cấu hình chính sách thư viện, ghi nhật ký hoạt động hệ thống (Audit Logs) bất biến và quản lý trạng thái tài khoản của người dùng.

---

## 2. Actors & Roles

- **Student / Lecturer:** Xem thông tin phạt trên dashboard, chọn thanh toán trực tuyến qua VNPAY, nhận thông báo nhắc nhở qua Email.
- **Library Manager:** Điều chỉnh các thông số cấu hình chính sách (như mức phạt/ngày, số ngày gia hạn tối đa, v.v.), đăng thông báo hệ thống đến bảng tin chung.
- **System Administrator (SysAdmin):** Quản lý khóa/mở khóa tài khoản người dùng, xem và lọc danh sách nhật ký Audit Logs toàn bộ hệ thống để phục vụ đối soát, cấu hình các biến môi trường (VNPAY, Email SMTP, AI).

---

## 3. Functional Requirements

### UC-07 — Xử lý Phạt & Thanh toán VNPAY
- **FR15 (Hiển thị Cảnh báo - Giao diện động):** Hệ thống tính toán realtime và hiển thị cảnh báo trực quan trên màn hình (dashboard) khi người dùng có sách sắp đến hạn, quá hạn hoặc có nợ phạt (Không lưu database).
- **FR16 (Khởi tạo Thanh toán):** Hệ thống đóng gói thông tin khoản phạt ( fineId, amount) và tạo link điều hướng người dùng sang cổng thanh toán sandbox VNPAY. Giao dịch VNPAY có timeout thanh toán mặc định là 15 phút (Tuân thủ BR17).
- **FR17 (Xử lý Kết quả VNPAY - Hệ thống tự động):** Hệ thống nhận phản hồi từ VNPAY (IPN / Callback) để ghi nhận trạng thái giao dịch:
  1. Kiểm tra chữ ký bảo mật. Nếu thành công: chuyển `Fine.status = 'paid'`, tạo bản ghi trong bảng `Payment` với trạng thái `'completed'`.
  2. Mở khóa quyền mượn sách của tài khoản nếu đã sạch nợ phạt và không bị các khóa bảo mật khác (Tuân thủ logic giải quyết nợ phạt).
  3. Nếu quá 15 phút không nhận được thanh toán thành công, hệ thống tự động hủy giao dịch thanh toán (Tuân thủ BR17).

### UC-11 — Cấu hình & Thông báo
- **FR24 (Quản lý Thông báo):** Quản lý thư viện đăng tải các thông báo chung (Lễ, Tết) lưu vào bảng `Notification`, hiển thị trên bảng tin/banner của toàn bộ người dùng khi đăng nhập.
- **FR25 (Cấu hình Chính sách):** Quản lý thư viện thay đổi các quy tắc hệ thống (như `max_borrow_limit`, `fine_per_day`, `max_extensions`, v.v.) được lưu tập trung trong bảng `SystemConfigurations` (Tuân thủ BR20). Mọi cấu hình thay đổi được hệ thống ghi nhận vào `AuditLogs` và áp dụng ngay lập tức cho các giao dịch mới.

### UC-12 — Quản trị & Audit Logs
- **FR26 (Quản lý Danh sách User):** Quản trị viên xem danh sách và thông tin chi tiết của người dùng (bao gồm lịch sử hoạt động, trạng thái tài khoản).
- **FR27 (Xử lý Vi phạm thủ công):** Quản trị viên thực hiện khóa hoặc mở khóa tài khoản người dùng bằng tay khi có sự cố. Cập nhật `User.status = 'locked'`, tuyệt đối không dùng lệnh DELETE SQL cứng để bảo toàn dữ liệu (Tuân thủ BR02).
- **FR28 (Xem Nhật ký Audit):** Quản trị viên xem lịch sử vết của các thao tác thay đổi dữ liệu trong hệ thống (tra cứu, tìm kiếm lọc nhật ký `AuditLogs` bất biến theo user, loại hành động, tên bảng hoặc khoảng thời gian).

### System Jobs (Hệ thống chạy ngầm bất đồng bộ)
- **FR29 (Tính Phạt Trễ hạn):** Mỗi đêm (Daily Batch), hệ thống rà soát các `BorrowRecord` đang mượn (`status = 'borrowed'`) có `end_date < GETDATE()`. Tự động tính phạt trễ hạn: `amount = số ngày trễ * fine_per_day` (Tuân thủ BR14), giới hạn mức phạt trần không vượt quá 150% giá trị sách (Tuân thủ BR15). Tạo bản ghi tương ứng vào bảng `Fine` và tự động cập nhật `User.status = 'locked'`.
- **FR30 (Dọn dẹp Hàng chờ):** Hủy bỏ các phiếu đặt trước đã có sách sẵn sàng (`Reservation.status = 'readypickup'`) nhưng người dùng quá hạn (mặc định là 3 ngày) không đến lấy (chuyển sang `'cancelled'` và luân chuyển sách cho người tiếp theo - Tuân thủ BR11).
- **FR31 (Gửi Email):** Gửi Email thông báo bất đồng bộ (sắp đến hạn trả sách trước 3 ngày, có sách chờ sẵn sàng nhận, hoặc có hóa đơn phạt mới phát sinh).

---

## 4. Non-functional Requirements

- **Transaction & Security:** Thanh toán VNPAY phải kiểm tra chữ ký bảo mật (Secure Hash) trước khi cập nhật trạng thái hóa đơn phạt để tránh gian lận giao dịch.
- **Audit Logs Immutability (BR19):** Bảng `AuditLogs` chỉ được phép ghi vào (`INSERT`), tuyệt đối không được phép chỉnh sửa (`UPDATE`) hay xóa (`DELETE`) dữ liệu của bảng này để đảm bảo tính bất biến.
- **Async Job Stability:** Tiến trình tính phạt quá hạn (FR29) và dọn dẹp hàng chờ (FR30) chạy nền vào ban đêm không được ảnh hưởng đến hiệu năng máy chủ lúc cao điểm.

---

## 5. Data (Các bảng liên quan)

Tham chiếu các bảng từ database:
- `Fine` (Tuân thủ BR14, BR15)
- `Payment` (Tuân thủ BR17)
- `SystemConfigurations` (Tuân thủ BR20)
- `AuditLogs` (Tuân thủ BR19)
- `Notification`
- `[User]`

---

## 6. Error Handling

| Điều kiện lỗi | Hành vi hệ thống |
|---|---|
| Chữ ký bảo mật VNPAY sai (Checksum failed) | Từ chối giao dịch thanh toán, ghi log lỗi bảo mật, giữ trạng thái hóa đơn là `'unpaid'`. |
| Giao dịch VNPAY quá 15 phút không hoàn tất (BR17) | Tự động hủy giao dịch, trạng thái của Payment chuyển thành `'canceled'`. |
| Thao tác cập nhật cấu hình hệ thống lỗi | Rollback giao dịch cấu hình, không ghi nhận thông số mới, báo lỗi cho quản lý. |

---

## 7. Acceptance Criteria

- [ ] Daily job chạy thành công: tính đúng số tiền phạt quá hạn và tạo đúng bản ghi `Fine` quá hạn theo công thức giới hạn (FR29, BR14, BR15).
- [ ] Bấm thanh toán VNPAY -> chuyển hướng đúng trang test của VNPAY -> trả kết quả thành công -> cập nhật hóa đơn phạt sang 'paid', tạo Payment record (FR16, FR17).
- [ ] Quản lý thay đổi cấu hình hệ thống -> Tham số thay đổi tức thì và được lưu tập trung (FR25, BR20), AuditLogs ghi nhận tài khoản quản lý thực hiện thay đổi (BR19).
- [ ] Admin thao tác khóa tài khoản -> trạng thái chuyển sang 'locked', ghi log Admin thực hiện khóa (FR27, BR02).
- [ ] Xem nhật ký kiểm toán lọc được theo đúng tiêu chí (FR28).

---

## 8. Out of Scope

- Tích hợp thêm các phương thức thanh toán ví điện tử khác (Momo, ShopeePay) trong Milestone này.
- Cho phép người dùng khiếu nại mức phạt online (mọi thắc mắc giải quyết thủ công tại quầy).
