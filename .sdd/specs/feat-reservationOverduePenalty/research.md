# Research: Chế tài Đặt trước Quá hạn

**Feature**: feat-reservationOverduePenalty | **Date**: 2026-08-01

## Research Findings

### R1: Vị trí tích hợp logic chế tài

- **Decision**: Tích hợp trực tiếp vào `ReservationExpirationProcessor.processExpiration()`, mở rộng vòng lặp xử lý hiện tại (dòng 61-172).
- **Rationale**: Logic chế tài phải chạy trong cùng DB Transaction với logic hủy đơn quá hạn để đảm bảo tính nguyên tử (atomicity). Tách ra service riêng buộc phải truyền Connection object và quản lý transaction ngoài, tăng phức tạp không cần thiết.
- **Alternatives considered**: 
  - `ReservationPenaltyService` riêng → Reject: coupling cao, phải chia sẻ transaction.
  - Scheduled cron job riêng → Reject: duplicate logic quét quá hạn, race condition với Lazy Sweep.

### R2: Pattern khóa giao dịch & Cho phép Đăng nhập

- **Decision**: Người dùng bị phạt quá hạn đặt trước **VẪN ĐƯỢC ĐĂNG NHẬP** vào hệ thống (để xem tài khoản, lịch sử và nộp tiền phạt trực tuyến). Hệ thống hiển thị banner cảnh báo thời gian mở khóa. Trong suốt 7 ngày (`lockedUntil > NOW()`), hệ thống **CHẶN MỌI THAO TÁC LƯU THÔNG** (mượn sách tại quầy, đặt trước sách mới, gia hạn sách).
- **Rationale**: Đảm bảo trải nghiệm người dùng — không chặn đăng nhập hoàn toàn để độc giả có thể vào nộp tiền phạt trực tuyến (SePay/VNPAY).
- **Existing code reference**:
  - `LoginServlet.java` và `AuthFilter.java` đã có logic cho phép login khi chỉ nợ phạt (`isLockedOnlyForUnpaid`). Mở rộng cho phép login khi bị khóa do `reservation_penalty` (hoặc mở rộng `hasNonUnpaidLockReason`).
  - `UserLockReasonDAO.insertLockReason(conn, userId, reason)` — ghi nhận lý do khóa.
  - `UserDAO` cần thêm method `lockUserForDuration(conn, userId, days)`.

### R3: Bulk cancel reservations

- **Decision**: Dùng 2-step approach: (1) SELECT tất cả active reservations của user trước để lấy danh sách bookId/bookCopyId, (2) Bulk UPDATE status='cancelled', (3) Loop qua danh sách để luân chuyển từng bản sao.
- **Rationale**: Cần biết bookCopyId/bookId của từng đơn để luân chuyển đúng bản sao. Không thể dùng chỉ 1 UPDATE vì cần xử lý side-effect cho từng đơn.

### R4: Email template cho chế tài

- **Decision**: Tạo email template `RESERVATION_PENALTY_NOTICE` trong bảng `DocumentTemp` hoặc hardcode trong EmailWorker.
- **Rationale**: Phù hợp với pattern hiện tại — `EmailWorker` đã hỗ trợ lookup template từ `DocumentTemp` theo `tempName`.
- **Placeholders cần**: `{{userName}}`, `{{lockDays}}`, `{{unlockDate}}`, `{{cancelledReservationCount}}`, `{{triggerReservationId}}`

## Unresolved Items

Không có — tất cả unknowns đã được giải quyết dựa trên pattern hiện có trong codebase.
