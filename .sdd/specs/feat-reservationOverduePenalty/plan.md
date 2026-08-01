# Implementation Plan: Chế tài Đặt trước Quá hạn (Reservation Overdue Penalty)

**Branch**: `feat-reservationOverduePenalty` | **Date**: 2026-08-01 | **Spec**: [SPEC.md](./SPEC.md)

**Input**: Feature specification from `.sdd/specs/feat-reservationOverduePenalty/SPEC.md`

## Summary

Mở rộng logic xử lý đơn đặt trước quá hạn trong `ReservationExpirationProcessor` (FR-67/FR-68 hiện tại) để bổ sung **chế tài cho người vi phạm**: tự động khóa tài khoản 7 ngày, hủy toàn bộ hàng chờ của người vi phạm, ghi lý do khóa vào `UserLockReason`, luân chuyển bản sao sách, ghi Audit Log chi tiết và gửi email thông báo chế tài.

## Technical Context

**Language/Version**: Java JDK 17 + Java Servlet (Servlet 4.0/5.0)

**Primary Dependencies**: JDBC thuần (PreparedStatement), JSTL, BCrypt, Log4j

**Storage**: PostgreSQL (Supabase) — kết nối qua cổng 6543 (Session Pooler)

**Testing**: JUnit 5

**Target Platform**: Java Web Application — Apache Tomcat

**Project Type**: Monolith Java Web App (MVC Pattern)

**Performance Goals**: Lazy Sweep xử lý ≤ 500ms cho ≤ 50 đơn quá hạn

**Constraints**: Toàn bộ xử lý chế tài cho 1 user phải trong 1 DB Transaction, SELECT...FOR UPDATE chống race condition

**Scale/Scope**: ~1000 users, ~200 concurrent active reservations

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Status | Notes |
|------|--------|-------|
| SEC-01 — Cấm Hardcode bí mật | ✅ PASS | Không có API key/secret nào trong feature này |
| SEC-02 — Phân quyền RBAC | ✅ PASS | Xử lý bởi hệ thống tự động (Lazy Sweep), không cần endpoint user-facing mới |
| SEC-03 — Chống SQL Injection | ✅ PASS | Toàn bộ SQL dùng PreparedStatement |
| III — Audit Log bắt buộc | ✅ PASS | Ghi Audit Log cho: LOCK_ACCOUNT, CANCEL_RESERVATION, PROMOTE_RESERVATION |
| IV — Async cho I/O chậm | ✅ PASS | Email gửi qua EmailService.enqueue() — async |
| V — Soft-Delete | ✅ PASS | Reservation chuyển status='cancelled', không xóa cứng |
| VI — 100% Tiếng Việt | ✅ PASS | Log message, email, lock reason đều tiếng Việt |
| DB-01 — Bảng "User" nháy kép | ✅ PASS | SQL sẽ viết `"User"` khi thao tác |
| ENG-01 — Clean Code | ✅ PASS | Connection quản lý qua try-finally, không leak |

## Project Structure

### Documentation (this feature)

```text
.sdd/specs/feat-reservationOverduePenalty/
├── SPEC.md                  # Feature specification
├── plan.md                  # This file (Implementation Plan)
├── research.md              # Phase 0 — Research findings
├── data-model.md            # Phase 1 — Data model changes
├── quickstart.md            # Phase 1 — Validation guide
└── tasks.md                 # Phase 2 — Task breakdown
```

### Source Code (files to modify/create)

```text
src/java/
├── service/
│   └── ReservationExpirationProcessor.java  # [MODIFY] Core — thêm logic chế tài
├── dao/
│   ├── ReservationDAO.java                  # [MODIFY] Thêm findAllActiveByUserId(), cancelAllByUserId()
│   ├── UserDAO.java                         # [MODIFY] Thêm lockUserForDuration()
│   └── UserLockReasonDAO.java               # [EXISTING] Dùng insertLockReason() có sẵn
└── model/
    └── (Không thay đổi Model — sử dụng các entity hiện có)

test/
└── feat-reservationOverduePenalty/
    └── ReservationPenaltyTest.java          # [NEW] Unit test cho logic chế tài
```

**Structure Decision**: Feature này chủ yếu mở rộng `ReservationExpirationProcessor` hiện có. Không tạo Service class mới — logic chế tài tích hợp trực tiếp vào processor vì đây là phần mở rộng tự nhiên của luồng xử lý quá hạn hiện tại.

## Phase 0: Research

### Findings

**Decision 1: Nơi đặt logic chế tài**
- **Decision**: Tích hợp vào `ReservationExpirationProcessor.processExpiration()`, ngay sau bước hủy đơn quá hạn (dòng 77).
- **Rationale**: Logic chế tài là phần mở rộng tự nhiên của luồng xử lý quá hạn. Tách ra class riêng sẽ tạo thêm phức tạp không cần thiết vì cả hai luồng đều chạy trong cùng một transaction.
- **Alternatives**: Tạo `ReservationPenaltyService` riêng → bị reject vì tăng coupling giữa 2 service phải chia sẻ cùng 1 DB transaction.

**Decision 2: Xử lý nhiều đơn readypickup quá hạn của cùng 1 user**
- **Decision**: Xử lý tuần tự từng đơn. Khóa tài khoản chỉ 1 lần cho user đầu tiên, các đơn sau kiểm tra `if ("locked".equals(user.status))` thì skip khóa nhưng vẫn hủy đơn + luân chuyển bản sao.
- **Rationale**: Đảm bảo idempotent — không ghi đè lockedUntil với giá trị nhỏ hơn.

**Decision 3: Thời gian khóa 7 ngày — cố định hay cấu hình**
- **Decision**: Hardcode 7 ngày (constant `PENALTY_LOCK_DAYS = 7`). Có thể nâng cấp lên SystemConfigurations sau nếu cần.
- **Rationale**: User yêu cầu rõ "7 ngày". Cấu hình hóa tạo thêm scope không cần thiết cho sprint hiện tại.

**Decision 4: Hủy toàn bộ hàng chờ — bulk update hay loop**
- **Decision**: Dùng bulk query `UPDATE Reservation SET status='cancelled' WHERE userId=? AND status IN ('pending','readypickup') AND reservationId != ?` để hủy toàn bộ trong 1 lần. Sau đó loop qua danh sách vừa hủy để luân chuyển bản sao cho từng đơn.
- **Rationale**: Bulk cancel hiệu quả hơn loop N lần, nhưng luân chuyển bản sao phải loop vì mỗi đơn liên quan đến bookId/bookCopyId khác nhau.

## Phase 1: Design & Data Model

### data-model.md — Tóm tắt

Không cần thay đổi schema DB. Sử dụng các bảng và cột hiện có:

| Bảng | Thao tác | Cột |
|------|----------|-----|
| `"User"` | UPDATE | `status` → 'locked', `lockedUntil` → NOW() + 7 days |
| `UserLockReason` | INSERT | `userId`, `reason`, `createdAt` |
| `Reservation` | UPDATE (bulk) | `status` → 'cancelled' cho tất cả pending/readypickup của user |
| `Reservation` | UPDATE (promote) | `queuePosition` → 0, `status` → 'readypickup', `bookCopyId`, `endDate` |
| `BookCopy` | UPDATE | `status` → 'available' (khi hàng chờ trống) |
| `Book` | UPDATE | `availableQuantity` + 1 (khi hàng chờ trống) |
| `AuditLogs` | INSERT | `actionType`: LOCK_ACCOUNT_OVERDUE_RESERVATION, CANCEL_ALL_RESERVATIONS_PENALTY, etc. |

### Contracts — Không có interface mới

Feature này không tạo endpoint user-facing mới. Tất cả logic chạy trong background (Lazy Sweep).

### DAO Methods cần thêm

**ReservationDAO** (thêm 2 methods):
1. `findAllActiveByUserId(Connection conn, int userId, int excludeReservationId)` — Lấy tất cả Reservation pending/readypickup của user (trừ đơn đang xử lý).
2. `cancelAllActiveByUserId(Connection conn, int userId, int excludeReservationId)` — Bulk cancel tất cả đơn active của user.

**UserDAO** (thêm 1 method):
1. `lockUserForDuration(Connection conn, int userId, int days)` — UPDATE "User" SET status='locked', lockedUntil = GREATEST(lockedUntil, NOW() + days) WHERE userId=?

### Luồng xử lý mới trong processExpiration() & Hệ thống

```
Vòng lặp quá hạn (processExpiration):
  1. Khóa dòng Reservation FOR UPDATE
  2. Hủy đơn quá hạn gốc → status='cancelled'
  3. Khóa giao dịch tài khoản:
     a. SELECT "User" FOR UPDATE WHERE userId = expired.userId
     b. UPDATE "User" SET status = 'locked', lockedUntil = GREATEST(COALESCE(lockedUntil, NOW()), NOW() + 7 days)
     c. INSERT UserLockReason(userId, reason='Tự động khóa 7 ngày do quá hạn nhận sách đặt trước (ReservationID: {id})')
  4. Hủy toàn bộ hàng chờ khác của user:
     a. Lấy danh sách active reservations của user
     b. Bulk UPDATE tất cả → status='cancelled'
     c. Luân chuyển bản sao cho từng đơn có bookCopyId (đôn người tiếp theo hoặc trả về kho)
  5. Ghi Audit Log chi tiết

Đăng nhập & Phân quyền (LoginServlet / AuthFilter / Circulation Services):
  1. LoginServlet: Cho phép người dùng bị phạt quá hạn đặt trước đăng nhập vào hệ thống, hiển thị banner cảnh báo thời hạn mở khóa giao dịch (lockedUntil).
  2. Trang cá nhân & Thanh toán: Cho phép xem hồ sơ, lịch sử mượn trả và nộp phạt trực tuyến (SePay/VNPAY).
  3. Mượn / Đặt trước / Gia hạn: Chặn mọi thao tác lưu thông khi lockedUntil > NOW() và có lý do phạt quá hạn đặt trước.
```

## Complexity Tracking

Không có vi phạm Constitution cần justification.
