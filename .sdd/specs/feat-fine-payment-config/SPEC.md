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

### UC-07 & UC-13 (Background Job) — Xử lý Phạt & Đọc nhắc hạn
- **FR-FIN-01 (Daily Batch):** Hằng ngày, một tiến trình chạy ngầm quét các `BorrowRecord` đang ở trạng thái `'borrowed'` và có `end_date < GETDATE()`.
- **FR-FIN-02:** Với mỗi bản ghi quá hạn, hệ thống tính toán tiền phạt:
  `amount = fine_per_day * số ngày quá hạn`.
  Mức phạt tối đa cho một cuốn sách được giới hạn ở mức: `min(fine_per_day * số ngày, giá sách * 1.5)` (theo quy tắc BR-LMS-028). Tạo bản ghi tương ứng vào bảng `Fine`.
- **FR-FIN-03 (Email Reminder):** Tiến trình ngầm tự động gửi email nhắc nhở trước 3 ngày đến hạn trả sách và khi có hóa đơn phạt mới được tạo.

### UC-07 — Thanh toán VNPAY
- **FR-PAY-01:** Người dùng chọn hóa đơn phạt cần trả, hệ thống tạo liên kết thanh toán chuyển hướng sang sandbox VNPAY.
- **FR-PAY-02:** Khi nhận phản hồi thành công (VNPAY Callback) có mã `transaction_reference` hợp lệ:
  1. Chuyển trạng thái `Fine.status = 'paid'`.
  2. Tạo bản ghi trong bảng `Payment` với trạng thái `'completed'`.
  3. Tự động mở khóa quyền mượn sách của người dùng nếu họ không còn hóa đơn phạt nào khác chưa thanh toán.

### UC-11 — Cấu hình Chính sách & Đăng thông báo
- **FR-CFG-01:** Quản lý thư viện thay đổi các tham số nghiệp vụ (như `fine_per_day`, `max_borrow_limit`, v.v.). Hệ thống cập nhật bảng `SystemConfigurations` và ghi nhật ký vào `AuditLogs`.
- **FR-CFG-02:** Quản lý tạo thông báo (`Notification`) để hiển thị banner chung cho tất cả các tài khoản khi đăng nhập.

### UC-12 — Quản trị Tài khoản & Audit Logs
- **FR-ADM-01:** Admin có thể khóa/mở khóa tài khoản người dùng (cập nhật `User.status = 'locked'`). Tuyệt đối không được xóa tài khoản khỏi cơ sở dữ liệu.
- **FR-ADM-02:** Hệ thống ghi lại toàn bộ hoạt động Create/Update/Delete quan trọng vào bảng `AuditLogs`. Admin có quyền tra cứu, tìm kiếm lọc nhật ký theo user, loại hành động, tên bảng hoặc khoảng thời gian.

---

## 4. Non-functional Requirements

- **Transaction & Security:** Thanh toán VNPAY phải kiểm tra chữ ký bảo mật (Secure Hash) trước khi cập nhật trạng thái hóa đơn phạt để tránh gian lận giao dịch.
- **Audit Logs Immutability:** Bảng `AuditLogs` chỉ được phép ghi vào (`INSERT`), tuyệt đối không được phép chỉnh sửa (`UPDATE`) hay xóa (`DELETE`) dữ liệu của bảng này.
- **Async Job Stability:** Tiến trình tính phạt quá hạn chạy nền vào ban đêm không được ảnh hưởng đến hiệu năng máy chủ lúc cao điểm.

---

## 5. Data (Các bảng liên quan)

Tham chiếu các bảng từ database:
- `Fine`
- `Payment`
- `SystemConfigurations`
- `AuditLogs`
- `Notification`
- `[User]`

---

## 6. Error Handling

| Điều kiện lỗi | Hành vi hệ thống |
|---|---|
| Chữ ký bảo mật VNPAY sai (Checksum failed) | Từ chối giao dịch thanh toán, ghi log lỗi bảo mật, giữ trạng thái hóa đơn là `'unpaid'`. |
| Thao tác cập nhật cấu hình hệ thống lỗi | Rollback giao dịch cấu hình, không ghi nhận thông số mới, báo lỗi cho quản lý. |

---

## 7. Acceptance Criteria

- [ ] Daily job chạy thành công: tính đúng số tiền phạt quá hạn và tạo đúng bản ghi `Fine` quá hạn theo công thức giới hạn.
- [ ] Bấm thanh toán VNPAY -> chuyển hướng đúng trang test của VNPAY -> trả kết quả thành công -> cập nhật hóa đơn phạt sang 'paid', tạo Payment record.
- [ ] Quản lý thay đổi cấu hình hệ thống -> Tham số thay đổi tức thì, AuditLogs ghi nhận tài khoản quản lý thực hiện thay đổi.
- [ ] Admin thao tác khóa tài khoản -> trạng thái chuyển sang 'locked', ghi log Admin thực hiện khóa.

---

## 8. Out of Scope

- Tích hợp thêm các phương thức thanh toán ví điện tử khác (Momo, ShopeePay) trong Milestone này.
- Cho phép người dùng khiếu nại mức phạt online (mọi thắc mắc giải quyết thủ công tại quầy).
