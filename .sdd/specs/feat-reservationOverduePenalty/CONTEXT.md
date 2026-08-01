# Context: Chế tài Đặt trước Quá hạn (Reservation Overdue Penalty)

## Feature Overview
Mở rộng `ReservationExpirationProcessor` (FR-67/FR-68) để bổ sung chế tài cho người vi phạm khi không đến nhận sách đặt trước trong thời hạn `RESERVATION_HOLD_DAYS` (3 ngày): khóa tài khoản 7 ngày, hủy toàn bộ hàng chờ, luân chuyển bản sao sách, ghi Audit Log, gửi email thông báo.

## Related Features
- **feat-Reservation&Renewal**: Feature gốc — logic quét quá hạn và hủy đơn hiện tại
- **feat-authentication**: AuthFilter kiểm tra `lockedUntil` để tự động mở khóa
- **feat-deskCirculationOperations**: `DeskCirculationService` dùng `UserLockReasonDAO` để khóa do quá hạn mượn

## Key Files
- `src/java/service/ReservationExpirationProcessor.java` — File chính cần sửa
- `src/java/dao/ReservationDAO.java` — Thêm 2 methods mới
- `src/java/dao/UserDAO.java` — Thêm 1 method mới
- `src/java/dao/UserLockReasonDAO.java` — Sử dụng method hiện có

## Dependencies
- `ReservationExpirationProcessor` đã hoạt động (FR-67/FR-68)
- `UserLockReasonDAO.insertLockReason()` đã sẵn sàng
- `EmailService.enqueue()` đã sẵn sàng
- `AuthFilter` đã kiểm tra `lockedUntil`
