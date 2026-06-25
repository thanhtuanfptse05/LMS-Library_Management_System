# SPEC.md — Quản lý Đặt trước và Gia hạn trực tuyến
# Version: 1.1.0 | Owner: @tech-lead | Status: DRAFT | Ngày cập nhật: 2026-06-24
# Mapping: UC-16, UC-17, UC-43 | BR-19, BR-20, BR-21, BR-36 | FR-29..FR-33, FR-67, FR-68

## 1. Context & Goal
Số hóa trải nghiệm lưu thông tài nguyên. Đảm bảo luồng Self-service hoạt động mượt mà, phân bổ sách theo nguyên tắc FIFO (First In First Out) thông qua hàng đợi.
Đồng thời, tích hợp tiến trình ngầm tự động dọn dẹp hàng chờ quá hạn nhận sách để giải phóng và tái cấp phát tài nguyên công bằng cho độc giả khác.

## 2. Actors & Roles
- **Độc giả (Student/Lecturer):** Tạo yêu cầu đặt trước, gia hạn và hủy đơn đặt trước của chính mình.
- **Hệ thống (System):** Chạy tiến trình ngầm Reservation Expiration tự động định kỳ (mỗi 1 giờ) để dọn dẹp và tái cấp phát hàng chờ quá hạn.

## 3. Business Rules (Quy tắc nghiệp vụ)
- **BR-19 (Điều kiện đặt trước & gia hạn):** Độc giả chỉ được phép Đặt trước hoặc Gia hạn nếu tài khoản đang ở trạng thái hoạt động (`status = 'active'`) VÀ không có cờ lý do khóa `'unpaid'` (nợ phạt) trong bảng `UserLockReason`.
- **BR-20 (Nguyên tắc phân bổ hàng đợi):** Đơn đặt trước khi sách còn bản sao sẵn có sẽ nhận `queuePosition = 0` (status = `'readypickup'`). Khi sách hết, đơn mới nhận `queuePosition = MAX + 1` (status = `'pending'`).
- **BR-21 (Điều kiện gia hạn):** Bản ghi mượn chỉ được gia hạn khi chưa vượt quá số lần tối đa, thời gian mượn hiện tại đạt ngưỡng phần trăm quy định, VÀ không có bất kỳ ai đang xếp hàng chờ (`queuePosition > 0`) cho đầu sách đó.
- **BR-36 (Thời hạn nhận sách đặt trước):** Đơn đặt trước ở trạng thái `'readypickup'` chỉ được giữ tại quầy trong một khoảng thời gian giới hạn được xác định bởi cấu hình `RESERVATION_HOLD_DAYS` trong bảng `SystemConfigurations` (mặc định là 3 ngày). Nếu quá thời hạn này (`endDate < NOW()`), đơn hàng sẽ tự động bị hủy và giải phóng bản sao sách mà không phát sinh tiền phạt.

## 4. Functional Requirements (EARS)

### 4.1. Đặt trước trực tuyến (Online Reservation)
- **FR-F5-01 (Kiểm định tài khoản):** WHEN người dùng gửi yêu cầu đặt sách, THE system SHALL kiểm tra trạng thái tài khoản. WHERE `status` != 'active' HOẶC tồn tại lý do khóa `'unpaid'` trong `UserLockReason`, THE system SHALL chặn và báo lỗi (BR-19).
- **FR-F5-02 (Kiểm định số lượng):** WHERE tài khoản hợp lệ, THE system SHALL kiểm tra tổng số sách đang mượn/đặt của độc giả. WHERE vượt giới hạn quy định cho Role, THE system SHALL chặn giao dịch.
- **FR-F5-03 (Đặt trước sách có sẵn):** WHERE `Book.availableQuantity` > 0, THE system SHALL thực thi giao dịch: tạo `Reservation` (`queuePosition = 0`, `status = 'readypickup'`, `endDate = NOW() + INTERVAL '1 day' * (SELECT configValue::INTEGER FROM SystemConfigurations WHERE configKey = 'RESERVATION_HOLD_DAYS')`), cập nhật `Book.availableQuantity = availableQuantity - 1`, gán `bookCopyId` sẵn có, VÀ kích hoạt gửi email thông báo nhận sách (BR-20).
- **FR-F5-04 (Xếp hàng chờ sách hết bản sao):** WHERE `Book.availableQuantity` == 0, THE system SHALL tạo `Reservation` (`queuePosition = MAX + 1`, `status = 'pending'`), VÀ thông báo vị trí hàng đợi cho độc giả (BR-20).

### 4.2. Gia hạn sách trực tuyến (Online Renewal)
- **FR-F5-05 (Kiểm tra điều kiện gia hạn):** WHEN người dùng yêu cầu gia hạn, THE system SHALL kiểm tra: (1) Đã qua % thời gian quy định, (2) `extensionCount` chưa vượt mức tối đa. WHERE vi phạm, THE system SHALL chặn giao dịch (BR-21).
- **FR-F5-06 (Kiểm tra hàng đợi):** WHEN kiểm tra điều kiện gia hạn, THE system SHALL truy vấn bảng `Reservation`. WHERE tồn tại bất kỳ bản ghi nào có `queuePosition > 0` cho `bookId` này, THE system SHALL chặn gia hạn (BR-21).
- **FR-F5-07 (Thực thi gia hạn):** WHERE mọi điều kiện hợp lệ, THE system SHALL cập nhật `BorrowRecord` (thêm ngày vào `endDate` VÀ `extensionCount = extensionCount + 1`).

### 4.3. Tiến trình ngầm Hủy hàng chờ quá hạn (Reservation Expiration)
- **FR-67 (Quét đặt trước quá hạn):** WHEN tiến trình ngầm Reservation Expiration được kích hoạt (định kỳ mỗi 1 giờ hoặc do Admin click trigger thủ công), THE system SHALL truy vấn tất cả các bản ghi đặt trước có `status = 'readypickup'` VÀ `endDate < NOW()`.
- **FR-68 (Hủy đặt trước & Tái cấp phát):** For each expired reservation found, THE system SHALL thực thi một Database Transaction riêng lẻ:
  1. Cập nhật Reservation quá hạn thành `status = 'cancelled'` và `queuePosition = NULL`.
  2. Tìm kiếm độc giả tiếp theo đang đứng đầu hàng đợi của cùng đầu sách (`bookId` tương ứng có `queuePosition = 1` và `status = 'pending'`).
  3. WHERE tồn tại độc giả tiếp theo:
     * Cập nhật bản ghi đặt trước của người đó: `queuePosition = 0`, `status = 'readypickup'`, `endDate = NOW() + INTERVAL '1 day' * (SELECT configValue::INTEGER FROM SystemConfigurations WHERE configKey = 'RESERVATION_HOLD_DAYS')`, và gán `bookCopyId` vừa giải phóng.
     * Cập nhật `BookCopy.status = 'reserved'`.
     * Dịch chuyển các vị trí hàng đợi phía sau (`queuePosition = queuePosition - 1` cho các đơn pending của bookId đó).
     * Gọi gửi email thông báo nhận sách bất đồng bộ cho độc giả tiếp theo này.
  4. WHERE KHÔNG tồn tại độc giả tiếp theo:
     * Cập nhật trạng thái bản sao vật lý `BookCopy.status = 'available'`.
     * Tăng số lượng khả dụng của đầu sách `Book.availableQuantity = availableQuantity + 1`.
  5. Ghi Audit Log hành động tự động hủy (`actionType = 'CANCEL_EXPIRED_RESERVATION'`, `userId = NULL` đại diện cho Hệ thống).

## 5. Non-functional Requirements
- **Concurrency Prevention:** Thao tác kiểm tra tồn kho và tạo Reservation bắt buộc nằm trong một Atomic Transaction (sử dụng `FOR UPDATE` dòng sách).
- **Độ tin cậy của Tiến trình ngầm:** Tiến trình ngầm quét quá hạn phải cô lập transaction theo từng bản ghi để lỗi của một độc giả không gây treo toàn bộ tiến trình. Giải phóng kết nối JDBC trong khối `finally`.

## 6. Database Schema & Data Models
Xem chi tiết cấu trúc các bảng: `Reservation`, `BookCopy`, `Book`, `"User"`, `UserLockReason`, `AuditLogs` trong file `LMS_Schema_PostgreSQL.sql`.

## 7. Error Handling
- WHERE xảy ra lỗi kết nối hoặc ngoại lệ SQL trong tiến trình ngầm, hệ thống SHALL rollback giao dịch của bản ghi lỗi hiện tại, ghi nhận log lỗi và tiếp tục xử lý các đơn đặt trước tiếp theo.

## 8. Acceptance Criteria
- [ ] Đơn đặt trước `'readypickup'` đã vượt quá `endDate` -> Tiến trình ngầm đổi trạng thái sang `'cancelled'`.
- [ ] Nếu đầu sách đó có người đang xếp hàng (`queuePosition = 1`): Bản sao sách được tự động chuyển sang gán cho người mới (`queuePosition = 0`, status `'readypickup'`, `endDate` mới được tính cộng thêm số ngày lấy từ cấu hình `RESERVATION_HOLD_DAYS`). Hàng chờ phía sau tịnh tiến lên trước, hệ thống gửi email thông báo nhận sách cho người mới.
- [ ] Nếu đầu sách đó không có ai xếp hàng: Bản sao sách chuyển sang trạng thái `'available'`, availableQuantity của đầu sách được tăng thêm 1.
- [ ] Ghi Audit Log hành động hủy tự động với email thực hiện là "Hệ thống" (`userId = null`).

## 9. Out of Scope
- Hệ thống **SHALL NOT** phát sinh tiền phạt đối với các trường hợp độc giả đặt trước sách mà không đến lấy.
