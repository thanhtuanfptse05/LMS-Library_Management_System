# SPEC.md — Quản lý Luân chuyển tại quầy
# Version: 1.0.0 | Owner: @tech-lead | Status: APPROVED
# Mapping: UC-18, UC-19, UC-20 | BR-22, BR-23, BR-24, BR-25, BR-29 | FR-34..FR-41 (chi tiết: FR-F6-01..FR-F6-08)

## 1. Context & Goal
Số hóa quá trình giao nhận vật lý, thu tiền mặt tại quầy. Đảm bảo tính nhất quán dữ liệu giữa số lượng kho thực tế, trạng thái bản sao sách, hàng đợi đặt trước và trạng thái nợ phạt của tài khoản.

## 2. Actors & Roles
- **Librarian:** Người có thẩm quyền quét mã xuất/nhập kho và duyệt thanh toán tiền mặt.

## 3. Functional Requirements (EARS)
**Luồng Giao Sách (Check-out & Mượn trực tiếp)**
- **FR-F6-01:** WHEN Thủ thư quét mã định danh, THE system SHALL truy vấn bảng `Fine` tìm các khoản phạt chưa thanh toán. WHERE tồn tại bất kỳ khoản phạt `status` == 'unpaid', THE system SHALL từ chối giao dịch và báo lỗi: "Tài khoản đang nợ phạt" (BR-22).
- **FR-F6-02:** WHERE Độc giả mượn trực tiếp (không có đơn đặt trước), THE system SHALL kiểm tra `Reservation`. WHERE đang có người chờ (`queuePosition` > 0), THE system SHALL từ chối. WHERE hàng đợi trống, THE system SHALL tự động INSERT `Reservation` tại chỗ (`queuePosition` = 0) (BR-23).
- **FR-F6-03:** WHERE hợp lệ, THE system SHALL thực thi một Transaction: INSERT `BorrowRecord`, UPDATE `Reservation.status` = 'fulfilled', UPDATE `BookCopy.status` = 'borrowed'.

**Luồng Nhận Sách (Check-in)**
- **FR-F6-04:** WHEN Thủ thư nhận trả sách với Condition IN ('damaged', 'lost'), THE system SHALL thực thi Transaction: UPDATE `Book.totalQuantity` = `totalQuantity` - 1, UPDATE `BookCopy.status` = 'unavailable', INSERT `Fine` ('unpaid') (BR-24).
- **FR-F6-05:** WHEN Thủ thư trả sách Condition == 'good', THE system SHALL UPDATE `BorrowRecord.status` = 'returned' VÀ `BookCopy.condition` = 'good'.
- **FR-F6-06:** WHILE Check-in Condition == 'good', THE system SHALL tìm `Reservation` đang chờ (`queuePosition` = 1). WHERE có người chờ, THE system SHALL UPDATE `Reservation` (`queuePosition`=0, `status`='readypickup', gán `bookCopyId`) VÀ gửi Email. WHERE không có người chờ, THE system SHALL UPDATE `Book.availableQuantity` = `availableQuantity` + 1 VÀ `BookCopy.status` = 'available'.

**Luồng Thanh toán Tiền mặt (Cash Payment)**
- **FR-F6-07:** WHEN Thủ thư xác nhận duyệt đơn `Payment` tiền mặt, THE system SHALL thực thi Transaction: UPDATE `Payment.status` = 'completed', VÀ UPDATE `Fine.status` = 'paid'.
- **FR-F6-08:** WHILE duyệt thanh toán hoàn tất, tài khoản độc giả tự động không còn bị chặn mượn sách mới do nợ phạt (trừ khi tài khoản bị khóa bởi lý do kỷ luật khác trong `UserLockReason`).

## 4. Non-functional Requirements
- **Concurrency:** Luồng đẩy hàng chờ (đẩy queue 1 thành queue 0) tại Check-in BẮT BUỘC sử dụng Transaction lock để tránh việc 2 sách trả cùng lúc gán cho cùng 1 người chờ.

## 5. Data Model
- Tham chiếu bảng: `[User]`, `UserLockReason`, `Book`, `BookCopy`, `BorrowRecord`, `Reservation`, `Fine`, `Payment`.

## 6. Error Handling
- WHERE mã Barcode không khớp với bất kỳ `BookCopy` nào trên hệ thống, THE system SHALL chặn thao tác và hiển thị cảnh báo.

## 7. Acceptance Criteria
- [ ] Mượn sách khi tài khoản nợ phạt (Fine status='unpaid'): Bị chặn.
- [ ] Mượn trực tiếp tại quầy khi đang có người khác xếp hàng: Bị chặn.
- [ ] Trả sách 'good' khi có người xếp hàng: Người chờ (Queue=1) trở thành (Queue=0, readypickup).
- [ ] Trả sách 'damaged/lost': Sách chuyển thành 'unavailable', totalQuantity giảm 1, tạo khoản phạt unpaid, độc giả không bị khóa tài khoản.
- [ ] Thanh toán phạt: Trạng thái Fine chuyển thành 'paid', độc giả được phép mượn sách mới bình thường.

## 8. Out of Scope
- KHÔNG tích hợp thanh toán trực tuyến trực tiếp trên máy của Thủ thư (Thủ thư chỉ duyệt tiền mặt; độc giả tự quét QR SePay trên thiết bị cá nhân để thanh toán tự động).
- KHÔNG cho phép độc giả tự thao tác trên phân hệ này.
