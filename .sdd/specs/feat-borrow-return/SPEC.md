# Feature Specification: feat-borrow-return (Giao dịch Mượn & Trả sách)
# Version: 1.0.0 | Owner: Member 3 | Date: 2026-05-29

---

## 1. Context & Goal

**Mục tiêu:** Xây dựng quy trình xử lý giao dịch mượn và trả sách trực tiếp tại quầy bởi thủ thư (Librarian). Hệ thống cần hỗ trợ quét barcode bản sao vật lý của sách, kiểm tra giới hạn mượn, kiểm tra nợ phạt của thành viên, tạo lịch sử mượn trả (`BorrowRecord`), và lưu dấu vết mọi thao tác vào bảng nhật ký kiểm toán (`AuditLogs`).

---

## 2. Actors & Roles

- **Librarian:** Người thực hiện chính. Quét barcode sách, nhập mã thành viên để xác nhận giao dịch mượn và trả sách.
- **Student / Lecturer:** Người thụ hưởng. Được hệ thống kiểm tra điều kiện mượn, xem lịch sử giao dịch cá nhân.

---

## 3. Functional Requirements

### UC-04 — Ghi nhận Mượn Sách
- **FR-BRW-01:** Thủ thư quét barcode bản sao (`BookCopy`) và nhập mã thành viên (`student_code` hoặc `lecturer_code`).
- **FR-BRW-02:** Hệ thống thực hiện kiểm tra các điều kiện tiên quyết trước khi cho mượn:
  1. Số lượng sách còn khả dụng của tựa sách phải lớn hơn 0 (`available_quantity > 0`).
  2. Thành viên không vượt quá số lượng sách mượn tối đa đồng thời (lấy từ cấu hình `max_borrow_limit`).
  3. Thành viên không có bất kỳ khoản phạt nào chưa thanh toán (`status = 'unpaid'` trong bảng `Fine`).
  4. Tài khoản thành viên phải ở trạng thái hoạt động (`status = 'active'`).
- **FR-BRW-03:** Khi các điều kiện được đáp ứng, hệ thống tiến hành:
  1. Tạo bản ghi `BorrowRecord` với `start_date = GETDATE()`, `end_date = start_date + max_loan_days` (lấy từ cấu hình).
  2. Chuyển trạng thái bản sao `BookCopy.status = 'borrowed'`.
  3. Trừ số lượng sách khả dụng của tựa sách đó đi 1 (`Books.available_quantity = Books.available_quantity - 1`).
  4. Ghi nhận nhật ký vào bảng `AuditLogs`.

### UC-10 — Xử lý Trả Sách
- **FR-RET-01:** Thủ thư quét barcode bản sao sách được trả.
- **FR-RET-02:** Hệ thống thực hiện:
  1. Cập nhật `BorrowRecord.returned_at = GETDATE()` và chuyển trạng thái `status = 'returned'`.
  2. Chuyển trạng thái bản sao `BookCopy.status = 'available'`.
  3. Cộng số lượng sách khả dụng của tựa sách đó thêm 1 (`Books.available_quantity = Books.available_quantity + 1`).
  4. Ghi nhận nhật ký vào bảng `AuditLogs`.
  5. Kích hoạt luồng kiểm tra quá hạn và luồng kiểm tra hàng chờ đặt trước sách (Reservation).

---

## 4. Non-functional Requirements

- **Transaction Integrity:** Giao dịch mượn và trả sách phải được bảo bọc trong SQL Transactions (`commit`/`rollback` thủ công trong DAO) để tránh tình trạng trừ/cộng số lượng sách nhưng không tạo được bản ghi giao dịch hoặc ngược lại.
- **Auditability:** Bắt buộc lưu toàn bộ chi tiết thao tác mượn/trả vào bảng `AuditLogs`. Không được phép Hard-delete bất kỳ bản ghi `BorrowRecord` nào.
- **Speed:** Thời gian xử lý giao dịch mượn/trả tại quầy ≤3 giây.

---

## 5. Data (Các bảng liên quan)

Tham chiếu các bảng từ database:
- `BorrowRecord`
- `BookCopy`
- `Books`
- `AuditLogs`
- `[User]`

---

## 6. Error Handling

| Điều kiện lỗi | Hành vi hệ thống |
|---|---|
| Có hóa đơn phạt quá hạn chưa thanh toán | Báo lỗi và chặn giao dịch mượn. Yêu cầu thành viên thanh toán trước. |
| Vượt quá hạn mức mượn | Báo lỗi và chặn giao dịch mượn. Yêu cầu trả bớt sách trước khi mượn tiếp. |
| Trả sách trễ hạn | Cập nhật ngày trả thực tế và tự động gọi module phạt để tạo hóa đơn phạt mới (`Fine`). |

---

## 7. Acceptance Criteria

- [ ] Thực hiện mượn sách thành công: copy đổi trạng thái sang 'borrowed', số lượng sách khả dụng giảm 1, ghi log AuditLogs.
- [ ] Thành viên có trạng thái 'locked' hoặc có phạt chưa trả -> Giao dịch mượn bị từ chối rõ ràng trên giao diện.
- [ ] Trả sách thành công: copy đổi trạng thái sang 'available', số lượng sách khả dụng tăng 1, ghi log AuditLogs.
- [ ] Mọi giao dịch mượn/trả đều chạy trong Database Transaction (Nếu một bước lỗi, tất cả được rollback).

---

## 8. Out of Scope

- Báo cáo thống kê tần suất mượn sách theo tháng/năm.
- Tự động trừ tiền phạt qua tài khoản liên kết (Sinh viên phải tự thanh toán online qua VNPAY).
