# Feature Specification: Chế tài Đặt trước Quá hạn (Reservation Overdue Penalty)

**Feature Directory**: `feat-reservationOverduePenalty`

**Created**: 2026-08-01

**Status**: Draft

**Input**: User description: "Xử lý đặt trước quá hạn 3 ngày: Khóa tài khoản 7 ngày & Hủy toàn bộ hàng chờ. Khi đơn readypickup vượt quá RESERVATION_HOLD_DAYS (3 ngày): chuyển đơn quá hạn → cancelled, khóa tài khoản 7 ngày, ghi UserLockReason, hủy toàn bộ Reservation khác (pending/readypickup) của user đó → cancelled, đôn người tiếp theo lên readypickup + gán bản sao; nếu hàng chờ trống → BookCopy.status = 'available'."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Tự động xử phạt khi không nhận sách đặt trước đúng hạn (Priority: P1)

Khi một Sinh viên hoặc Giảng viên có đơn đặt trước ở trạng thái "sẵn sàng nhận" (readypickup) nhưng không đến nhận sách trong vòng 3 ngày (theo cấu hình `RESERVATION_HOLD_DAYS`), hệ thống sẽ tự động:
1. **Hủy đơn đặt trước quá hạn** đó → chuyển trạng thái sang `cancelled`.
2. **Khóa giao dịch 7 ngày**: Cập nhật `"User".status = 'locked'`, `"User".lockedUntil = NOW() + 7 ngày`, ghi lý do vào bảng `UserLockReason` = "Tự động khóa 7 ngày do quá hạn nhận sách đặt trước (ReservationID: {reservationId})".
3. **Quyền Đăng nhập & Thanh toán**: Người dùng **VẪN ĐƯỢC ĐĂNG NHẬP** vào hệ thống để xem trang cá nhân, xem lịch sử và thanh toán tiền phạt trực tuyến. Khi đăng nhập, giao diện hiển thị cảnh báo banner nêu rõ lý do và thời gian tự động mở khóa.
4. **Chặn giao dịch lưu thông**: Trong 7 ngày bị phạt, người dùng bị **CHẶN TOÀN BỘ** các thao tác mượn sách mới, đặt trước sách mới và gia hạn sách.
5. **Hủy toàn bộ hàng chờ**: Tất cả các đơn `Reservation` khác của người dùng đó (ở trạng thái `pending` hoặc `readypickup`) đều bị chuyển sang `cancelled`.
6. **Luân chuyển bản sao sách**: Với mỗi đơn bị hủy có bản sao (`bookCopyId`), đôn người tiếp theo trong hàng chờ (queuePosition = 1) lên trạng thái `readypickup` + gán bản sao; nếu không có ai chờ → `BookCopy.status = 'available'` và trả `availableQuantity` về cho `Book`.

**Why this priority**: Đây là quy tắc chế tài cốt lõi nhằm ngăn chặn hành vi lạm dụng hệ thống đặt trước, đảm bảo tài nguyên thư viện được luân chuyển hiệu quả. Đồng thời vẫn cho phép người dùng đăng nhập để nộp tiền phạt trực tuyến nếu có.

**Independent Test**: Có thể kiểm tra độc lập bằng cách tạo một đơn đặt trước ở trạng thái `readypickup` với `endDate` < NOW(), sau đó kích hoạt Lazy Sweep và xác minh: (a) đơn chuyển sang `cancelled`, (b) tài khoản bị khóa giao dịch 7 ngày nhưng vẫn đăng nhập được để thanh toán, (c) tất cả đơn đặt trước khác của user bị hủy, (d) bản sao sách được luân chuyển đúng.

**Acceptance Scenarios**:

1. **Given** một đơn đặt trước ở trạng thái `readypickup` với `endDate` đã quá 3 ngày VÀ người dùng có 2 đơn `pending` khác, **When** Lazy Sweep quét đơn hết hạn, **Then** cả 3 đơn đều chuyển sang `cancelled`, tài khoản bị khóa giao dịch 7 ngày (`lockedUntil = NOW() + 7 ngày`), `UserLockReason` được ghi nhận, người dùng vẫn đăng nhập được nhưng bị chặn mượn/đặt/gia hạn.

2. **Given** tài khoản bị khóa giao dịch 7 ngày do quá hạn đặt trước, **When** người dùng đăng nhập vào hệ thống, **Then** đăng nhập thành công, hiển thị banner cảnh báo thời hạn mở khóa, người dùng có thể xem nợ phạt và thanh toán online bình thường.

3. **Given** tài khoản đang trong thời gian phạt 7 ngày, **When** người dùng cố gắng đặt trước sách mới hoặc mượn sách tại quầy, **Then** hệ thống chặn và hiển thị thông báo lỗi "Tài khoản đang bị khóa giao dịch do quá hạn nhận sách đặt trước".

4. **Given** tài khoản người dùng hết 7 ngày phạt (`lockedUntil < NOW()`), **When** người dùng thực hiện giao dịch mượn/đặt sách, **Then** hệ thống tự động mở khóa và cho phép giao dịch bình thường (trừ khi còn nợ phạt chưa thanh toán).

---

### Edge Cases

- **Người dùng vừa bị khóa 7 ngày vừa có nợ phạt chưa thanh toán?** → Khi hết 7 ngày phạt (`lockedUntil < NOW()`), mốc thời gian phạt trôi qua nhưng tài khoản vẫn bị CHẶN giao dịch nếu chưa thanh toán hết nợ phạt (`UserLockReason` chứa nợ phạt). Nếu thanh toán nợ phạt xong trong 7 ngày → nợ phạt hết nhưng tài khoản vẫn bị CHẶN giao dịch cho đến khi hết 7 ngày (`lockedUntil`).
- **Điều gì xảy ra khi người dùng có nhiều đơn readypickup quá hạn cùng lúc?** → Hệ thống xử lý tuần tự từng đơn, chỉ khóa tài khoản 1 lần (nếu đã locked thì bổ sung lý do), vẫn hủy tất cả đơn và luân chuyển bản sao cho từng đơn.
- **Điều gì xảy ra khi bản sao sách (BookCopy) của đơn quá hạn đã bị mất/hỏng?** → Nếu `BookCopy.status` là `'lost'` hoặc `'damaged'`, bỏ qua bước luân chuyển bản sao. Chỉ hủy đơn + khóa tài khoản.
- **Điều gì xảy ra khi người tiếp theo trong hàng chờ cũng đang bị khóa giao dịch?** → Vẫn đôn lên `readypickup` bình thường (họ không thể thực hiện giao dịch mới nhưng có thể nhận sách đã đặt trước). Nếu hết hạn lần nữa → lặp lại chu kỳ chế tài.
- **Xử lý đồng thời (Race Condition)?** → Toàn bộ luồng xử lý phải nằm trong DB Transaction, sử dụng `SELECT ... FOR UPDATE` trên bảng `"User"` và `Reservation` để tránh xung đột khi nhiều Lazy Sweep chạy đồng thời.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-ROP-001**: Hệ thống BẮT BUỘC phải tự động hủy (chuyển `status = 'cancelled'`) mọi đơn đặt trước ở trạng thái `readypickup` khi `endDate` vượt quá thời điểm hiện tại (`endDate < NOW()`), tức đã quá hạn nhận theo `RESERVATION_HOLD_DAYS`.

- **FR-ROP-002**: Hệ thống BẮT BUỘC phải khóa giao dịch người vi phạm trong **7 ngày tính từ thời điểm xử lý hủy đơn quá hạn** (tức sau khi đã hết 3 ngày giữ sách, tổng cộng 10 ngày từ khi sách sẵn sàng nhận):
  - Cập nhật `"User".status = 'locked'`
  - Cập nhật `"User".lockedUntil = NOW() + 7 ngày` (tính trọn vẹn 7 ngày sau 3 ngày giữ sách)
  - Ghi bản ghi `UserLockReason` với `reason` = "Tự động khóa 7 ngày do quá hạn nhận sách đặt trước (ReservationID: {reservationId})"

- **FR-ROP-003**: Hệ thống BẮT BUỘC phải hủy toàn bộ các đơn `Reservation` khác của người vi phạm (tất cả đơn ở trạng thái `pending` hoặc `readypickup`) khi chế tài được kích hoạt, chuyển chúng sang `status = 'cancelled'`.

- **FR-ROP-004**: Hệ thống BẮT BUỘC phải luân chuyển bản sao sách sau khi hủy mỗi đơn đặt trước:
  - Nếu có người tiếp theo trong hàng chờ (`queuePosition = 1`, `status = 'pending'`): đôn lên `queuePosition = 0`, `status = 'readypickup'`, gán `bookCopyId` từ đơn bị hủy, đặt `endDate = NOW() + RESERVATION_HOLD_DAYS`.
  - Nếu không có ai chờ: chuyển `BookCopy.status = 'available'` và tăng `Book.availableQuantity` lên 1.

- **FR-ROP-005**: Hệ thống BẮT BUỘC **cho phép đăng nhập** cho người dùng bị khóa do quá hạn đặt trước hoặc nợ phạt, hiển thị banner cảnh báo trên giao diện và cho phép thực hiện thanh toán phạt trực tuyến, nhưng **chặn toàn bộ thao tác mượn/đặt/gia hạn sách** trong suốt thời gian phạt.

- **FR-ROP-007**: Hệ thống BẮT BUỘC xử lý đúng trường hợp tài khoản đã bị khóa trước đó: chỉ cập nhật `lockedUntil` nếu giá trị mới lớn hơn giá trị hiện tại, và ghi thêm `UserLockReason` mới (không ghi đè lý do cũ).

- **FR-ROP-008**: Toàn bộ luồng xử lý chế tài cho MỘT người dùng BẮT BUỘC phải thực thi trong một DB Transaction duy nhất với cơ chế `SELECT ... FOR UPDATE` chống race condition.

### Key Entities *(include if feature involves data)*

- **Reservation**: Đơn đặt trước sách — bị hủy khi quá hạn, thuộc tính quan trọng: `status`, `endDate`, `bookCopyId`, `queuePosition`.
- **User**: Tài khoản người dùng — bị khóa khi vi phạm, thuộc tính quan trọng: `status`, `lockedUntil`.
- **UserLockReason**: Lý do khóa tài khoản — ghi nhận chi tiết lý do chế tài.
- **BookCopy**: Bản sao sách — được luân chuyển cho người tiếp theo hoặc giải phóng về kho.
- **Book**: Đầu sách — cập nhật `availableQuantity` khi bản sao được giải phóng.


## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% đơn đặt trước readypickup quá hạn `RESERVATION_HOLD_DAYS` ngày đều được tự động hủy trong vòng 1 lần quét Lazy Sweep tiếp theo.
- **SC-002**: Tài khoản vi phạm bị khóa chính xác 7 ngày — tự động mở khóa sau thời gian này mà không cần thao tác thủ công.
- **SC-003**: Toàn bộ đơn đặt trước còn lại (pending/readypickup) của người vi phạm bị hủy 100% khi chế tài kích hoạt.
- **SC-004**: Bản sao sách được luân chuyển cho người chờ tiếp theo trong vòng cùng lần quét Lazy Sweep, hoặc giải phóng về kho nếu không có ai chờ.


## Assumptions

- Cơ chế Lazy Sweep (FR-67) đã được triển khai và hoạt động ổn định — feature này mở rộng logic xử lý của FR-67/FR-68.
- Cấu hình `RESERVATION_HOLD_DAYS` đã tồn tại trong bảng `SystemConfigurations` (mặc định 3 ngày).
- Thời gian khóa 7 ngày là cố định (hardcode), không lấy từ `SystemConfigurations` — trừ khi có yêu cầu thay đổi sau.
- `EmailService` và `EmailWorker` đã hoạt động và hỗ trợ enqueue email async.
- Luồng đăng nhập (`AuthService`) đã kiểm tra `lockedUntil` để tự động mở khóa khi hết hạn.
- Bảng `UserLockReason` đã tồn tại trong schema với các cột: `lockReasonId`, `userId`, `reason`, `createdAt`.
