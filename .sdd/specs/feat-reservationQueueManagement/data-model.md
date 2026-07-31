# Data Model: Quản lý Hàng chờ Đặt trước dành cho Thủ thư (Tách biệt hoàn toàn với BookCopy)

## 1. Structure of `ReservationQueueItemDTO` (DTO thuần quản lý hàng chờ)

* `reservationId` (INT) - ID đơn đặt trước
* `userId` (INT) - ID người dùng đặt trước
* `userCode` (VARCHAR) - Mã sinh viên hoặc mã giảng viên
* `userFullName` (VARCHAR) - Họ tên độc giả
* `userRole` (VARCHAR) - Vai trò (`STUDENT` / `LECTURER`)
* `bookId` (INT) - ID tựa sách
* `bookTitle` (VARCHAR) - Tên tựa sách
* `isbn` (VARCHAR) - Mã ISBN của tựa sách
* `status` (VARCHAR) - Trạng thái đơn đặt trước (`'pending'`, `'readypickup'`, `'fulfilled'`, `'cancelled'`)
* `queuePosition` (INT) - Thứ tự hàng chờ (`0` là ready pickup, `1..N` là pending)
* `startDate` (Timestamp) - Ngày giờ đặt trước
* `endDate` (Timestamp) - Hạn chót đến lượt mượn sách

*(Lưu ý: Không chứa bất kỳ trường nào về `BookCopy` như `bookCopyId` hay `barcode`)*

---

## 2. Dynamic Configuration Access
* **Cấu hình**: `SystemConfigurations` (khóa `RESERVATION_HOLD_DAYS`).
* **Sử dụng**: Tính toán `endDate` cho người xếp đầu hàng chờ khi Thủ thư hủy lượt đặt trước phía trên.

---

## 3. Operations & Audit Logging
* Thao tác Hủy lượt của Thủ thư -> Ghi `AuditLogs` với `actionType = 'CANCEL_RESERVATION_BY_LIBRARIAN'`, `entityName = 'Reservation'`, `entityId = reservationId`.
