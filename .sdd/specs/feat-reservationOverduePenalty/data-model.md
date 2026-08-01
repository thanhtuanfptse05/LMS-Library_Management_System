# Data Model: Chế tài Đặt trước Quá hạn

**Feature**: feat-reservationOverduePenalty | **Date**: 2026-08-01

## Schema Changes

> **Không có thay đổi schema DB.** Feature này sử dụng 100% cấu trúc bảng hiện có.

## Entities Involved

### 1. `"User"` (Bảng tài khoản — nháy kép bắt buộc)

**Thao tác**: UPDATE

| Cột | Kiểu | Thay đổi |
|-----|------|----------|
| `status` | VARCHAR(50) | 'active' → 'locked' |
| `lockedUntil` | TIMESTAMP | NULL → NOW() + 7 days (dùng GREATEST để không ghi đè giá trị lớn hơn) |

**SQL mẫu**:
```sql
UPDATE "User" 
SET status = 'locked', 
    lockedUntil = GREATEST(COALESCE(lockedUntil, NOW()), NOW() + INTERVAL '7 days')
WHERE userId = ?
```

### 2. `UserLockReason` (Bảng lý do khóa)

**Thao tác**: INSERT

| Cột | Kiểu | Giá trị |
|-----|------|---------|
| `userId` | INT FK | ID user vi phạm |
| `reason` | VARCHAR | "Tự động khóa 7 ngày do quá hạn nhận sách đặt trước (ReservationID: {id})" |
| `createdAt` | TIMESTAMP | NOW() |

**Lưu ý**: Có thể có NHIỀU lý do khóa cho cùng 1 user (ví dụ: unpaid + overdue_reservation). Không xóa lý do cũ.

### 3. `Reservation` (Bảng đặt trước)

**Thao tác**: UPDATE (bulk cancel)

| Cột | Kiểu | Thay đổi |
|-----|------|----------|
| `status` | VARCHAR(50) | 'pending'/'readypickup' → 'cancelled' |

**SQL mẫu** (bulk cancel):
```sql
UPDATE Reservation 
SET status = 'cancelled' 
WHERE userId = ? 
  AND status IN ('pending', 'readypickup') 
  AND reservationId != ?
```

### 4. `BookCopy` (Bảng bản sao sách)

**Thao tác**: UPDATE (luân chuyển)

| Cột | Kiểu | Thay đổi |
|-----|------|----------|
| `status` | VARCHAR(50) | Không đổi; Reservation không gán BookCopy trước checkout |

### 5. `Book` (Bảng đầu sách)

**Thao tác**: UPDATE

| Cột | Kiểu | Thay đổi |
|-----|------|----------|
| `availableQuantity` | INT | +1 (khi bản sao được giải phóng) |

### 6. `AuditLogs` (Bảng nhật ký)

**Thao tác**: INSERT

| actionType | entityName | Mô tả |
|-----------|------------|-------|
| `LOCK_ACCOUNT_OVERDUE_RESERVATION` | User | Khóa tài khoản do quá hạn nhận sách |
| `CANCEL_ALL_RESERVATIONS_PENALTY` | Reservation | Hủy toàn bộ hàng chờ do chế tài |
| `CANCEL_EXPIRED_RESERVATION` | Reservation | Hủy đơn quá hạn gốc (đã có) |
| `PROMOTE_RESERVATION` | Reservation | Đôn người chờ tiếp theo (đã có) |

## State Transitions

### Reservation Status
```
readypickup ──[quá hạn]──> cancelled (đơn gốc)
pending ──[chế tài]──> cancelled (hàng chờ của user)
readypickup ──[chế tài]──> cancelled (hàng chờ khác của user)
pending ──[đôn lên]──> readypickup (người chờ tiếp theo)
```

### User Status
```
active ──[chế tài]──> locked (lockedUntil = NOW() + 7 days)
locked ──[lockedUntil hết hạn + AuthFilter check]──> active (tự động mở khóa khi đăng nhập)
```

### BookCopy Status
```
readypickup ──[hàng chờ trống]──> cancelled + availableQuantity tăng 1
readypickup ──[có người chờ]──> cancelled + chuyển suất cho người tiếp
```
