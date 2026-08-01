# Quickstart Validation: Chế tài Đặt trước Quá hạn

**Feature**: feat-reservationOverduePenalty | **Date**: 2026-08-01

## Prerequisites

1. PostgreSQL (Supabase) đang chạy với schema LMS đầy đủ.
2. Có ít nhất 1 user Student/Lecturer với `status = 'active'`.
3. Có ít nhất 1 đơn Reservation `readypickup` với `endDate < NOW()` (đã quá hạn).
4. Có ít nhất 2 đơn Reservation `pending` khác của cùng user đó.
5. EmailService / EmailWorker đang hoạt động.

## Setup Test Data (SQL)

```sql
-- 1. Tạo đơn quá hạn (readypickup, endDate 4 ngày trước)
UPDATE Reservation 
SET status = 'readypickup', 
    endDate = NOW() - INTERVAL '4 days',
    queuePosition = 0
WHERE reservationId = {TEST_RESERVATION_ID};

-- 2. Tạo thêm 2 đơn pending cho cùng user
INSERT INTO Reservation (userId, bookId, status, queuePosition, startDate)
VALUES ({TEST_USER_ID}, {BOOK_ID_1}, 'pending', 1, NOW());

INSERT INTO Reservation (userId, bookId, status, queuePosition, startDate)
VALUES ({TEST_USER_ID}, {BOOK_ID_2}, 'pending', 1, NOW());
```

## Validation Scenarios

### Scenario 1: Kích hoạt Lazy Sweep

**Trigger**: Truy cập 1 trong các trang sau:
- `/librarian/dashboard`
- `/librarian/desk-dashboard`
- `/librarian/check-in`

**Expected**:
1. Console log: `[ReservationExpirationProcessor] Tìm thấy N đơn quá hạn cần xử lý.`
2. Console log: `[ReservationExpirationProcessor] Khóa tài khoản userId={id} do quá hạn nhận sách.`
3. Console log: `[ReservationExpirationProcessor] Hủy {N} đơn đặt trước khác của userId={id}.`

### Scenario 2: Kiểm tra DB sau khi xử lý

```sql
-- Kiểm tra đơn quá hạn đã bị hủy
SELECT * FROM Reservation WHERE reservationId = {TEST_RESERVATION_ID};
-- Expected: status = 'cancelled'

-- Kiểm tra tài khoản bị khóa
SELECT status, lockedUntil FROM "User" WHERE userId = {TEST_USER_ID};
-- Expected: status = 'locked', lockedUntil ≈ NOW() + 7 days

-- Kiểm tra lý do khóa
SELECT * FROM UserLockReason WHERE userId = {TEST_USER_ID} ORDER BY createdAt DESC LIMIT 1;
-- Expected: reason LIKE '%quá hạn nhận sách đặt trước%'

-- Kiểm tra các đơn khác đã bị hủy
SELECT * FROM Reservation WHERE userId = {TEST_USER_ID} AND status != 'cancelled';
-- Expected: Không có kết quả (tất cả đều cancelled)

-- Kiểm tra Audit Log
SELECT * FROM AuditLogs 
WHERE entityName = 'User' AND actionType = 'LOCK_ACCOUNT_OVERDUE_RESERVATION'
ORDER BY timestamp DESC LIMIT 1;
-- Expected: 1 bản ghi

SELECT * FROM AuditLogs 
WHERE entityName = 'Reservation' AND actionType = 'CANCEL_ALL_RESERVATIONS_PENALTY'
ORDER BY timestamp DESC LIMIT 1;
-- Expected: 1 bản ghi
```

### Scenario 3: Kiểm tra luân chuyển bản sao

```sql
-- Nếu đơn quá hạn có bookCopyId VÀ có người chờ tiếp theo:
SELECT * FROM Reservation 
WHERE bookId = {BOOK_ID} AND status = 'readypickup' AND queuePosition = 0;
-- Expected: 1 bản ghi mới (người chờ tiếp theo)

-- Nếu đơn quá hạn có bookCopyId VÀ không có người chờ:
SELECT status FROM BookCopy WHERE bookCopyId = {COPY_ID};
-- Expected: status = 'available'
```

### Scenario 4: Kiểm tra Đăng nhập & Chặn giao dịch

1. Thử đăng nhập với user bị phạt quá hạn trong 7 ngày $\rightarrow$ Expected: **Đăng nhập THÀNH CÔNG**, hiển thị banner cảnh báo thời gian tự động mở khóa giao dịch.
2. Cho phép vào xem trang cá nhân, lịch sử mượn trả, thực hiện nộp tiền phạt trực tuyến $\rightarrow$ Expected: **Hoạt động bình thường**.
3. Cố gắng bấm "Đặt trước sách" hoặc "Gia hạn sách" $\rightarrow$ Expected: **Bị CHẶN**, hiển thị thông báo lỗi "Tài khoản đang bị khóa giao dịch 7 ngày do quá hạn nhận sách đặt trước".
4. Chờ hết 7 ngày hoặc UPDATE `lockedUntil = NOW() - INTERVAL '1 day'` $\rightarrow$ Đặt trước / mượn sách lại $\rightarrow$ Expected: **Giao dịch THÀNH CÔNG**.

## Run Tests

```bash
# Unit test (sau khi implement)
mvn test -pl test/feat-reservationOverduePenalty
```
