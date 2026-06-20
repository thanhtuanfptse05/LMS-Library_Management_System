# SPEC.md — Quản lý Đặt trước và Gia hạn trực tuyến
# Version: 1.0.0 | Owner: @tech-lead | Status: APPROVED

## 1. Context & Goal
Số hóa trải nghiệm lưu thông tài nguyên. Đảm bảo luồng Self-service hoạt động mượt mà, phân bổ sách theo nguyên tắc FIFO (First In First Out) thông qua hàng đợi.

## 2. Actors & Roles
- **Authenticated User (Student/Lecturer):** Được phép tạo yêu cầu Đặt trước và Gia hạn.

## 3. Functional Requirements (EARS)
**Luồng Đặt trước trực tuyến (Online Reservation)**
- **FR-F5-01:** WHEN người dùng gửi yêu cầu đặt sách, THE system SHALL kiểm tra trạng thái bảng `[User]` và bảng `Fine`. WHERE `status` != 'active' HOẶC tồn tại nợ phạt `status` = 'unpaid', THE system SHALL từ chối và báo lỗi (BR-19).
- **FR-F5-02:** WHERE tài khoản hợp lệ, THE system SHALL đọc cấu hình và kiểm tra tổng số sách đang mượn/đặt có vượt giới hạn không. WHERE vượt giới hạn, THE system SHALL chặn giao dịch.
- **FR-F5-03:** WHERE `Book.availableQuantity` > 0, THE system SHALL tạo `Reservation` (`queuePosition` = 0, `status` = 'readypickup'), UPDATE `Book.availableQuantity` = `availableQuantity` - 1, VÀ trigger Email "Sách sẵn sàng" (BR-20).
- **FR-F5-04:** WHERE `Book.availableQuantity` == 0, THE system SHALL tạo `Reservation` (`queuePosition` = MAX + 1, `status` = 'pending'), VÀ thông báo vị trí hàng đợi cho người dùng (BR-20).

**Luồng Gia hạn (Renewal)**
- **FR-F5-05:** WHEN người dùng yêu cầu gia hạn `BorrowRecord`, THE system SHALL kiểm tra: (1) Đã qua % thời gian quy định, (2) `extensionCount` < Max allowed. WHERE vi phạm, THE system SHALL từ chối giao dịch (BR-21).
- **FR-F5-06:** WHERE thỏa mãn thời gian, THE system SHALL truy vấn bảng `Reservation`. WHERE tồn tại bất kỳ bản ghi nào có `queuePosition` > 0 cho `bookId` này, THE system SHALL từ chối gia hạn với lỗi: "Đang có người xếp hàng chờ" (BR-21).
- **FR-F5-07:** WHERE mọi điều kiện hợp lệ, THE system SHALL thực thi UPDATE `BorrowRecord` (cộng thêm số ngày vào `endDate` VÀ `extensionCount` = `extensionCount` + 1).

## 4. Non-functional Requirements
- **Concurrency Prevention:** Thao tác kiểm tra `availableQuantity` và CREATE `Reservation` BẮT BUỘC nằm trong một Atomic Transaction (Sử dụng `SELECT FOR UPDATE` hoặc Double Check).
- **Audit:** Mọi thay đổi trạng thái đều phải truy vết được qua `updatedAt`.

## 5. Data Model
- **[User] & Fine:** Định danh và trạng thái nợ phạt.
- **Reservation:** `reservationId`, `userId`, `bookId`, `queuePosition`, `status`.
- **BorrowRecord:** `borrowRecordId`, `endDate`, `extensionCount`, `status`.
- **Book:** `bookId`, `availableQuantity`.

## 6. Error Handling
- WHERE người dùng nợ phạt, THE system SHALL hiển thị lỗi rõ ràng thay vì lỗi 500: "Tính năng bị vô hiệu hóa. Bạn đang có khoản phạt chưa thanh toán."
- WHERE có 2 request đặt trước cùng lúc nhưng chỉ còn 1 sách, THE system SHALL cấp `queuePosition=0` cho request commit trước, request còn lại tự động fallback sang `queuePosition=1`.

## 7. Acceptance Criteria
- [ ] User nợ phạt (tồn tại khoản `Fine`='unpaid') không thể Đặt trước hay Gia hạn.
- [ ] Sách còn tồn kho: Đặt trước thành công, sinh Reservation queue 0, kho trừ 1.
- [ ] Sách hết tồn kho: Đặt trước thành công, sinh Reservation queue MAX + 1, kho không trừ.
- [ ] Gia hạn sớm hơn thời gian quy định bị chặn.
- [ ] Gia hạn quá số lần quy định bị chặn.
- [ ] Gia hạn khi có người đứng chờ ở queuePosition > 0 bị chặn.
- [ ] Gia hạn thành công: endDate tăng, extensionCount tăng +1.

## 8. Out of Scope
- Hệ thống KHÔNG tự động hủy đơn đặt trước khi quá hạn (Đây là job chạy ngầm của Module khác).
- Hệ thống KHÔNG thực hiện check-out giao sách vật lý tại giao diện này (Thuộc F6).
