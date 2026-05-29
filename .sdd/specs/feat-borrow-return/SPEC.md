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
- **FR09 (Ghi nhận Mượn Sách):** Hệ thống ghi nhận việc mượn một cuốn sách vật lý thông qua mã vạch, đánh dấu cuốn sách đó đang được mượn. Quy trình bám sát luồng **Reservation-first**:
  - Khi thủ thư nhập mã thành viên (`student_code` hoặc `lecturer_code`) và quét barcode bản sao (`BookCopy`), hệ thống kiểm tra xem có bản ghi `Reservation` nào của người dùng này đối với tựa sách này đang ở trạng thái `'readypickup'` hay không.
    - **Nếu có:** Chuyển đổi trạng thái bản ghi `Reservation` đó từ `'readypickup'` sang `'fulfilled'`.
    - **Nếu không:** Tạo mới một bản ghi `Reservation` với trạng thái `'readypickup'` và lập tức chuyển đổi sang `'fulfilled'`.
  - Việc tạo mới `Reservation` ban đầu chỉ yêu cầu kiểm tra trạng thái tài khoản không bị khóa (`User.status != 'locked'`). Tuy nhiên, khi hệ thống thực hiện chuyển đổi sang `'fulfilled'` (bước tạo `BorrowRecord`), hệ thống bắt buộc kiểm tra đầy đủ các điều kiện tiên quyết:
    1. Số lượng sách còn khả dụng của tựa sách phải lớn hơn 0 (`available_quantity > 0`).
    2. Người dùng không có bất kỳ khoản nợ phạt nào chưa thanh toán (Tuân thủ BR04).
    3. Người dùng không vượt quá giới hạn số sách được mượn đồng thời (`BR-LMS-005`).
    4. Tài khoản thành viên phải ở trạng thái hoạt động (`status = 'active'`).
- **FR10 (Tính hạn trả sách - Hệ thống tự động):** Khi giao dịch mượn thành công (hệ thống chuyển `Reservation.status = 'fulfilled'`), hệ thống tự động tính toán và lưu ngày phải trả (`end_date = start_date + thời hạn tối đa`) dựa trên vai trò của người mượn theo cấu hình hệ thống (Tuân thủ BR06). Đồng thời:
  1. Tạo bản ghi `BorrowRecord` với trạng thái `'borrowed'`.
  2. Chuyển trạng thái bản sao `BookCopy.status = 'borrowed'`.
  3. Trừ số lượng sách khả dụng của tựa sách đó đi 1 (`Books.available_quantity = Books.available_quantity - 1`) nếu bản ghi `Reservation` là được tạo mới trực tiếp tại quầy (nếu là gán từ hàng chờ sẵn có, số lượng đã được trừ trước đó).
  4. Ghi nhận nhật ký hoạt động bất biến vào bảng `AuditLogs` (Tuân thủ BR19).

### UC-10 — Xử lý Trả Sách
- **FR22 (Quét mã Trả sách):** Thủ thư quét barcode bản sao sách được trả. Hệ thống ghi nhận cuốn sách vật lý đã được trả và chuyển nó về lại trạng thái sẵn sàng trong kho. Cụ thể:
  1. Cập nhật `BorrowRecord.returned_at = GETDATE()` và chuyển trạng thái `status = 'returned'`.
  2. Chuyển trạng thái bản sao `BookCopy.status = 'available'`.
  3. Cộng số lượng sách khả dụng của tựa sách đó thêm 1 (`Books.available_quantity = Books.available_quantity + 1`).
  4. Ghi nhận nhật ký vào bảng `AuditLogs` (Tuân thủ BR19).
- **FR23 (Phân bổ Hàng chờ - Hệ thống tự động):** Ngay khi sách được trả (và số lượng khả dụng tăng 1), hệ thống kiểm tra và tự động giữ cuốn sách đó cho người đứng đầu tiên trong hàng chờ (nếu có). Trạng thái của `Reservation` có `queue_position` nhỏ nhất và trạng thái `'pending'` của tựa sách đó sẽ được cập nhật thành `'readypickup'`. Gán `bookCopyId` cho `Reservation` đó, chuyển trạng thái `BookCopy.status = 'reserved'`, và đặt hạn nhận sách (Tuân thủ BR10, BR11). **Đồng thời, hệ thống tự động trừ số lượng sách khả dụng đi 1 (`Books.available_quantity = Books.available_quantity - 1`) để khóa bản sao này cho người đặt trước.**

---

## 4. Non-functional Requirements

- **Transaction Integrity:** Giao dịch mượn và trả sách phải được bảo bọc trong SQL Transactions (`commit`/`rollback` thủ công trong DAO) để tránh tình trạng bất nhất dữ liệu.
- **Auditability (BR19):** Bắt buộc lưu toàn bộ chi tiết thao tác mượn/trả vào bảng `AuditLogs`. Dữ liệu nhật ký này không thể bị sửa chữa hay xóa bỏ bởi bất kỳ ai. Không được phép Hard-delete bất kỳ bản ghi `BorrowRecord` nào.
- **Speed:** Thời gian xử lý giao dịch mượn/trả tại quầy ≤3 giây.

---

## 5. Data (Các bảng liên quan)

Tham chiếu các bảng từ database:
- `BorrowRecord`
- `BookCopy`
- `Books`
- `AuditLogs` (Tuân thủ BR19)
- `[User]`

---

## 6. Error Handling

| Điều kiện lỗi | Hành vi hệ thống |
|---|---|
| Có hóa đơn phạt quá hạn chưa thanh toán (BR04) | Báo lỗi và chặn giao dịch mượn/fulfilled. Yêu cầu thành viên thanh toán trước. |
| Vượt quá hạn mức mượn (BR05) | Báo lỗi và chặn giao dịch mượn/fulfilled. Yêu cầu trả bớt sách trước khi mượn tiếp. |
| Trả sách trễ hạn | Cập nhật ngày trả thực tế và tự động gọi module phạt (FR29) để tạo hóa đơn phạt mới (`Fine`). |

---

## 7. Acceptance Criteria

- [ ] Thực hiện mượn sách thành công: Tạo `Reservation` ở trạng thái 'readypickup', chuyển sang 'fulfilled', tạo `BorrowRecord`, copy đổi trạng thái sang 'borrowed', số lượng sách khả dụng giảm 1, ghi log AuditLogs (FR09, BR19).
- [ ] Thành viên có trạng thái 'locked' (BR01) hoặc có phạt chưa trả (BR04) -> Giao dịch mượn bị từ chối rõ ràng trên giao diện.
- [ ] Trả sách thành công: copy đổi trạng thái sang 'available', số lượng sách khả dụng tăng 1, ghi log AuditLogs (FR22, BR19).
- [ ] Mọi giao dịch mượn/trả đều chạy trong Database Transaction (Nếu một bước lỗi, tất cả được rollback).

---

## 8. Out of Scope

- Báo cáo thống kê tần suất mượn sách theo tháng/năm.
- Tự động trừ tiền phạt qua tài khoản liên kết (Sinh viên phải tự thanh toán online qua VNPAY).
