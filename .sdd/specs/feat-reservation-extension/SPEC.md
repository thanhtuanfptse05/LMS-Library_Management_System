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
- **FR-RES-01:** Khi người dùng muốn mượn sách nhưng `available_quantity = 0`, hệ thống cho phép tạo một bản ghi `Reservation` với trạng thái `status = 'pending'` và gán số thứ tự trong hàng chờ `queue_position`.
- **FR-RES-02:** Nếu sách vẫn còn bản sao khả dụng, chặn không cho đặt trước và yêu cầu người dùng mượn trực tiếp.
- **FR-RES-03:** Khi một cuốn sách được trả (`status` của `BorrowRecord` chuyển thành `'returned'`), hệ thống tự động:
  1. Tìm kiếm bản ghi `Reservation` có `queue_position` nhỏ nhất và trạng thái `'pending'`.
  2. Cập nhật `Reservation.status = 'readypickup'`.
  3. Gán `bookCopyId` của bản sao vừa trả cho Reservation đó.
  4. Đặt `end_date = GETDATE() + reservation_validity_days` (số ngày giữ sách, mặc định là 3 ngày).
  5. Gửi email thông báo tự động (Asynchronous Email) cho người dùng đó biết sách đã sẵn sàng để đến lấy.
- **FR-RES-04 (Release reservation):** Nếu người dùng không đến nhận sách trong vòng `reservation_validity_days`, hệ thống tự động hủy lượt đặt trước (`Reservation.status = 'cancelled'`), giải phóng `bookCopyId` và gán cho người tiếp theo trong hàng chờ.

### UC-05 — Gia hạn Sách (Extension)
- **FR-EXT-01:** Người dùng có thể nhấn nút "Gia hạn" trên giao diện lịch sử mượn sách.
- **FR-EXT-02:** Điều kiện để gia hạn thành công:
  1. Số lần gia hạn hiện tại nhỏ hơn giới hạn (`extension_count < max_extensions`, mặc định tối đa 2 lần).
  2. Tựa sách đó không có bất kỳ hàng chờ `Reservation` nào ở trạng thái `'pending'` hoặc `'readypickup'`.
  3. Thành viên không có hóa đơn phạt nào chưa thanh toán.
- **FR-EXT-03:** Khi được duyệt gia hạn, `endDate` của `BorrowRecord` tăng thêm `extension_duration_days` (mặc định là 7 ngày), và `extension_count` tăng thêm 1.

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
| Người dùng yêu cầu gia hạn sách có người đang đặt trước | Báo lỗi: "Không thể gia hạn do sách này đang có hàng chờ đặt trước." |
| Đặt trước sách vẫn còn bản sao tại thư viện | Chặn tạo hàng chờ và thông báo người dùng tới quầy để mượn trực tiếp. |
| Người dùng có hóa đơn phạt chưa đóng muốn gia hạn | Chặn gia hạn và chuyển hướng tới trang thanh toán phạt. |

---

## 7. Acceptance Criteria

- [ ] Sách hết bản copy -> Người dùng bấm "Đặt trước" -> Tạo hàng chờ thành công, gán vị trí đúng thứ tự tăng dần.
- [ ] Trả sách -> Người đầu hàng chờ chuyển trạng thái thành 'readypickup', nhận email thông báo.
- [ ] Quá hạn nhận sách đặt trước -> Bản ghi tự động chuyển thành 'cancelled', chuyển sách cho người tiếp theo.
- [ ] Gia hạn sách hợp lệ -> Hạn trả tăng thêm 7 ngày, số lần gia hạn tăng 1.

---

## 8. Out of Scope

- Thay đổi thứ tự ưu tiên trong hàng chờ (ví dụ: Giảng viên được ưu tiên trước Sinh viên).
- Đặt trước nhiều cuốn sách cùng một lúc bằng 1 nút bấm (chỉ hỗ trợ đặt trước từng cuốn riêng lẻ).
