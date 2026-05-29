# Feature Specification: feat-reservation-extension (Đặt trước & Gia hạn sách)
# Version: 1.0.0 | Owner: Member 4 | Date: 2026-05-29

---

## 1. Context & Goal

**Mục tiêu:** Xử lý việc đặt trước sách khi số lượng sách khả dụng bằng 0 (`available_quantity = 0`) bằng cách đưa người dùng vào hàng chờ đặt trước. Khi có sách được trả, hệ thống tự động gán bản sao khả dụng cho người đầu hàng chờ, gửi email thông báo và quản lý hạn nhận sách. Đồng thời hỗ trợ tính năng tự gia hạn sách trực tuyến cho độc giả nếu đáp ứng đủ điều kiện chính sách thư viện.

---

## 2. Actors & Roles

- **Student / Lecturer:** Thực hiện yêu cầu đặt trước sách trực tuyến (khi sách hết bản sao sẵn có), tự gia hạn thời gian mượn của cuốn sách đang giữ. Nhận email thông báo khi sách đặt trước có sẵn.
- **Librarian:** Xem danh sách hàng chờ đặt trước, hỗ trợ người dùng nhận sách đã đặt trước tại quầy khi trạng thái chuyển sang `'readypickup'`.

---

## 3. Functional Requirements

### UC-06 — Đặt trước Sách (Reservation)
- **FR13 (Ghi danh Đặt trước):** Hệ thống ghi nhận người dùng vào hàng chờ của một tựa sách đã hết hoặc còn và cấp số thứ tự chờ (`queue_position` nếu hết). Quy tắc chi tiết:
  - Mọi yêu cầu mượn hoặc đặt trước sách đều bắt đầu bằng việc tạo một bản ghi `Reservation`.
  - Nếu tựa sách không còn bản sao khả dụng (`available_quantity = 0`), hệ thống tạo `Reservation` với trạng thái `status = 'pending'` và gán số thứ tự trong hàng chờ `queue_position`.
  - Nếu tựa sách còn bản sao khả dụng (`available_quantity > 0`), hệ thống tạo `Reservation` với trạng thái `status = 'readypickup'`, gán bản sao khả dụng (đổi status copy sang `'reserved'`), **và trừ `available_quantity` đi 1 (`Books.available_quantity = Books.available_quantity - 1`).**
  - Để tối ưu hiệu năng, mọi thao tác tạo mới `Reservation` chỉ cần kiểm tra trạng thái tài khoản `User.status != 'locked'` (không kiểm tra nợ phạt ở bước này). Tuy nhiên, hệ thống bắt buộc phải kiểm tra điều kiện `BR-LMS-005`: Tổng "Sách đang mượn" + "Sách đang đặt trước" < `max_borrow_limit` để chặn đặt trước nếu vượt hạn mức.
  - Chặn không cho người mới đặt trước nếu tựa sách đó đang ở trạng thái "quá hạn" (tất cả các bản sao đều chưa được trả dù đã lố ngày - Tuân thủ BR09).
- **FR14 (Hủy Đặt trước chủ động):** Hệ thống cho phép người dùng tự xóa tên mình khỏi hàng chờ nếu không còn nhu cầu. Khi hủy (chuyển `Reservation.status = 'cancelled'`), nếu đặt trước đó từng ở trạng thái `'readypickup'`, hệ thống giải phóng `bookCopyId`, chuyển trạng thái copy về `'available'`, và cộng trả `available_quantity` thêm 1 (`Books.available_quantity = Books.available_quantity + 1`).
- **Xử lý luân chuyển hàng chờ (Hệ thống tự động):**
  - Khi một cuốn sách được trả (hệ thống cộng khả dụng thêm 1), hệ thống tự động tìm bản ghi `Reservation` có `queue_position` nhỏ nhất và trạng thái `'pending'` để cập nhật thành `'readypickup'`. Gán `bookCopyId`, chuyển trạng thái copy sang `'reserved'`, đặt `end_date = GETDATE() + thời gian giữ sách` (Tuân thủ BR10), **và trừ `available_quantity` đi 1 (`Books.available_quantity = Books.available_quantity - 1`).** Gửi email thông báo tự động (FR31).
  - Nếu quá hạn giữ sách (mặc định là 3 ngày) mà người dùng không đến nhận sách (được dọn dẹp bởi tiến trình chạy ngầm FR30), hệ thống tự động hủy lượt đặt trước (`Reservation.status = 'cancelled'`), giải phóng `bookCopyId` (Copy status về `'available'`), **tăng `available_quantity` lên 1 (`Books.available_quantity = Books.available_quantity + 1`), và tiến hành luân chuyển sách cho thành viên hợp lệ tiếp theo trong hàng chờ (người tiếp theo khi được gán sẽ lại tự động trừ đi 1) (Tuân thủ BR11).**
  - Nếu người dùng có số lần "đặt sách nhưng không đến lấy" vượt quá mức cho phép (cấu hình `max_no_show_limit`), tài khoản sẽ bị phạt/khóa theo cấu hình của Admin (cấu hình `no_show_lock_duration_days` - Tuân thủ BR12).

### UC-05 — Gia hạn Sách (Extension)
- **FR11 (Yêu cầu Gia hạn):** Hệ thống tiếp nhận yêu cầu kéo dài thời gian mượn sách từ người dùng và tính toán ngày trả mới (`endDate` tăng thêm `extension_duration_days` và `extension_count` tăng thêm 1).
- **FR12 (Chặn Gia hạn - Hệ thống tự động):** Hệ thống từ chối gia hạn nếu vi phạm một trong các điều kiện sau:
  - Số lần gia hạn hiện tại đạt giới hạn (`extension_count >= max_extensions` - Tuân thủ BR08).
  - Tựa sách đó HIỆN ĐANG CÓ người khác đang xếp hàng chờ đặt trước ở trạng thái `'pending'` hoặc `'readypickup'` (Tuân thủ BR07).
  - Thành viên đang có hóa đơn phạt chưa thanh toán (Tuân thủ BR04).

---

## 4. Non-functional Requirements

- **Concurrency Control:** Hàng chờ đặt trước phải bảo đảm tính tuần tự chính xác (FIFO) bằng cách đồng bộ hóa logic gán hàng chờ hoặc sử dụng cơ chế transaction khóa dòng trong DB khi cập nhật số thứ tự `queue_position`.
- **Asynchronous Processing:** Việc gửi email thông báo sách sẵn sàng nhận phải chạy trên thread phụ để tránh kéo dài thời gian xử lý trả sách của thủ thư.

---

## 5. Data (Các bảng liên quan)

Tham chiếu các bảng từ database:
- `Reservation`
- `BorrowRecord`
- `BookCopy`
- `Books`
- `[User]`

---

## 6. Error Handling

| Điều kiện lỗi | Hành vi hệ thống |
|---|---|
| Người dùng yêu cầu gia hạn sách có người đang đặt trước (BR07) | Báo lỗi: "Không thể gia hạn do sách này đang có hàng chờ đặt trước." |
| Gia hạn vượt quá số lần cho phép (BR08) | Báo lỗi và chặn gia hạn. |
| Người dùng có hóa đơn phạt chưa đóng muốn gia hạn (BR04) | Chặn gia hạn và chuyển hướng tới trang thanh toán phạt. |
| Đặt trước tựa sách đang bị quá hạn (BR09) | Chặn đặt trước tựa sách và thông báo lý do. |
| Đặt trước khi vượt quá giới hạn (BR-LMS-005) | Chặn đặt trước và thông báo: "Bạn đã vượt quá giới hạn mượn và đặt trước tối đa." |

---

## 7. Acceptance Criteria

- [ ] Sách hết bản copy -> Người dùng bấm "Đặt trước" -> Tạo hàng chờ thành công, gán vị trí đúng thứ tự tăng dần (FR13, BR09).
- [ ] Trả sách -> Người đầu hàng chờ chuyển trạng thái thành 'readypickup', nhận email thông báo (FR23, BR10, FR31).
- [ ] Quá hạn nhận sách đặt trước -> Bản ghi tự động chuyển thành 'cancelled', luân chuyển sách cho người tiếp theo (FR30, BR11).
- [ ] Gia hạn sách hợp lệ -> Hạn trả tăng thêm theo cấu hình, số lần gia hạn tăng 1 (FR11, BR08).
- [ ] Tài khoản bị khóa nợ phạt hoặc lạm dụng đặt trước không thể thực hiện giao dịch mới (BR04, BR12).
- [ ] Đặt trước khi tổng mượn + đặt >= max_borrow_limit -> Bị chặn và báo lỗi rõ ràng trên giao diện (BR05).

---

## 8. Out of Scope

- Thay đổi thứ tự ưu tiên trong hàng chờ (ví dụ: Giảng viên được ưu tiên trước Sinh viên).
- Đặt trước nhiều cuốn sách cùng một lúc bằng 1 nút bấm (chỉ hỗ trợ đặt trước từng cuốn riêng lẻ).
