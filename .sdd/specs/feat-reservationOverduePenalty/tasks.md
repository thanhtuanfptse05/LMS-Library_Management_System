# Tasks: Chế tài Đặt trước Quá hạn (Reservation Overdue Penalty)

**Input**: Design documents from `.sdd/specs/feat-reservationOverduePenalty/`

**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, quickstart.md ✅

**Tests**: Không yêu cầu tường minh trong spec — bỏ qua test tasks.

**Organization**: Tasks grouped by user story. US1 (P1) = MVP.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup

**Purpose**: Không cần setup mới — dự án đã có đầy đủ infrastructure (DAO pattern, DB connection, EmailService, AuditLog).

*(Phase này trống — feature mở rộng code hiện có, không tạo project mới.)*

---

## Phase 2: Foundational (DAO Methods cần bổ sung)

**Purpose**: Bổ sung các DAO methods cần thiết mà TẤT CẢ user stories đều phụ thuộc vào. Phải hoàn thành trước khi bắt đầu bất kỳ user story nào.

**⚠️ CRITICAL**: Không user story nào có thể bắt đầu cho đến khi phase này hoàn thành.

- [x] T001 [P] Thêm method `lockUserForDuration(Connection conn, int userId, int days)` vào `src/java/dao/UserDAO.java` — UPDATE `"User"` SET status='locked', lockedUntil = GREATEST(COALESCE(lockedUntil, NOW()), NOW() + INTERVAL 'N days') WHERE userId=?. Dùng PreparedStatement với `? * INTERVAL '1 day'` hoặc tính timestamp ở Java rồi truyền vào.

- [x] T002 [P] Thêm method `findAllActiveByUserId(Connection conn, int userId, int excludeReservationId)` vào `src/java/dao/ReservationDAO.java` — SELECT * FROM Reservation WHERE userId=? AND status IN ('pending','readypickup') AND reservationId != ?. Trả về `List<Reservation>`.

- [x] T003 [P] Thêm method `cancelAllActiveByUserId(Connection conn, int userId, int excludeReservationId)` vào `src/java/dao/ReservationDAO.java` — UPDATE Reservation SET status='cancelled' WHERE userId=? AND status IN ('pending','readypickup') AND reservationId != ?. Trả về số dòng bị ảnh hưởng (int).

**Checkpoint**: 3 DAO methods mới đã sẵn sàng để user stories sử dụng.

---

## Phase 3: User Story 1 — Tự động xử phạt khi không nhận sách đúng hạn (Priority: P1) 🎯 MVP

**Goal**: Khi đơn readypickup quá hạn, hệ thống tự động: hủy đơn, khóa tài khoản 7 ngày, hủy tất cả hàng chờ khác của user, luân chuyển bản sao sách.

**Independent Test**: Tạo 1 đơn readypickup quá hạn + 2 đơn pending của cùng user → kích hoạt Lazy Sweep → xác minh: đơn cancelled, tài khoản locked 7 ngày, UserLockReason ghi nhận, tất cả đơn khác cancelled, bản sao luân chuyển đúng.

### Implementation for User Story 1

- [x] T004 [US1] Mở rộng method `processExpiration()` trong `src/java/service/ReservationExpirationProcessor.java`: Sau bước hủy đơn quá hạn (dòng 77 hiện tại), thêm logic **khóa tài khoản** — gọi `UserDAO.lockUserForDuration(conn, userId, 7)`, sau đó gọi `UserLockReasonDAO.insertLockReason(conn, userId, "Tự động khóa 7 ngày do quá hạn nhận sách đặt trước (ReservationID: {id})")`. Kiểm tra nếu user đã locked thì chỉ update lockedUntil nếu giá trị mới lớn hơn (GREATEST logic đã có trong T001).

- [x] T005 [US1] Mở rộng method `processExpiration()` trong `src/java/service/ReservationExpirationProcessor.java`: Sau bước khóa tài khoản, thêm logic **hủy toàn bộ hàng chờ** — gọi `ReservationDAO.findAllActiveByUserId(conn, userId, currentReservationId)` để lấy danh sách, sau đó gọi `ReservationDAO.cancelAllActiveByUserId(conn, userId, currentReservationId)`. Log số lượng đơn bị hủy.

- [x] T006 [US1] Mở rộng method `processExpiration()` trong `src/java/service/ReservationExpirationProcessor.java`: Sau bước hủy hàng chờ, thêm logic **luân chuyển bản sao** cho từng đơn bị hủy — loop qua danh sách từ T005, với mỗi đơn có `bookCopyId != null`: gọi `ReservationDAO.findNextInQueue(conn, bookId)`. Nếu có người chờ → `updateToReadyPickup()` + `decrementQueuePositions()`. Nếu không → `BookCopyDAO.updateStatusToAvailable()` + `BookDAO.updateQuantities()`. (Tái sử dụng logic hiện có ở dòng 84-151).

- [x] T007 [US1] Thêm Audit Log chi tiết trong `src/java/service/ReservationExpirationProcessor.java`: Ghi 2 loại audit log mới — (1) `LOCK_ACCOUNT_OVERDUE_RESERVATION` vào `entityName=User` với `newValues` chứa userId + lockedUntil + reason, (2) `CANCEL_ALL_RESERVATIONS_PENALTY` vào `entityName=Reservation` với `newValues` chứa danh sách reservationId bị hủy. Dùng `UserDAO.insertAuditLog()` hiện có.

- [x] T008 [US1] Cập nhật `ProcessResult` static class trong `src/java/service/ReservationExpirationProcessor.java`: Thêm 2 field mới `public int lockedAccountCount = 0;` và `public int penaltyCancelledCount = 0;` để tracking số tài khoản bị khóa và số đơn bị hủy do chế tài (tách biệt với `cancelledCount` hiện có cho đơn quá hạn gốc).

- [x] T008a [US1] Cập nhật `LoginServlet.java` và `AuthFilter.java`: Cho phép người dùng bị khóa do quá hạn đặt trước (có lý do lock chứa reservation) được **đăng nhập vào hệ thống**, gán cảnh báo `reservationPenaltyWarning` tương tự cơ chế `unpaidWarning` để hiển thị banner cảnh báo trên giao diện dashboard.

- [x] T008b [US1] Cập nhật điều kiện kiểm tra giao dịch trong `OnlineCirculationService.java` và các Circulation Servlets: Khi người dùng thực hiện mượn sách/đặt trước/gia hạn, kiểm tra nếu `user.getLockedUntil() > NOW()` AND có lý do `reservation` trong `UserLockReason` $\rightarrow$ CHẶN giao dịch và báo lỗi "Tài khoản đang trong thời gian bị khóa giao dịch do quá hạn nhận sách đặt trước".

**Checkpoint**: US1 hoàn thành — Lazy Sweep tự động khóa tài khoản + hủy hàng chờ + luân chuyển bản sao khi đơn quá hạn. Người dùng vẫn đăng nhập được để trả phạt nhưng bị chặn mượn/đặt/gia hạn. MVP ready.

---

## Phase 4: Polish & Cross-Cutting Concerns

**Purpose**: Cải thiện chất lượng code và xác minh kết quả

- [x] T009 Cập nhật log messages trong `src/java/service/ReservationExpirationProcessor.java`: Đảm bảo tất cả LOGGER.log() messages đều bằng tiếng Việt, rõ ràng, chứa userId và reservationId để dễ debug. Format: `[ReservationExpirationProcessor] {Mô tả hành động} — userId={id}, reservationId={id}`.

- [x] T010 Cập nhật `ProcessResult` logging trong các Servlet gọi `processExpiration()`: Thêm hiển thị `lockedAccountCount` và `penaltyCancelledCount` vào log output của `TriggerReservationExpirationServlet.java` và các nơi gọi processExpiration().

- [x] T011 Chạy kiểm tra quickstart.md validation theo kịch bản trong `.sdd/specs/feat-reservationOverduePenalty/quickstart.md` — xác minh tất cả 4 scenarios đều pass.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Trống — không cần setup mới
- **Foundational (Phase 2)**: T001, T002, T003 — CÓ THỂ chạy song song vì mỗi task sửa file khác nhau (UserDAO / ReservationDAO)
- **User Story 1 (Phase 3)**: Phụ thuộc Phase 2. T004 → T005 → T006 (tuần tự, cùng file/method). T007, T008 song song với T006.
- **Polish (Phase 4)**: Phụ thuộc Phase 3. T009, T010, T011 song song.

### Execution Flow

```
Phase 2 (Foundational) ──> Phase 3 (US1: Core Penalty) ──> Phase 4 (Polish)
      │                                                         │
      └── T001 ║ T002 ║ T003 (parallel)                         └── T009 ║ T010 ║ T011 (parallel)
```

### Parallel Opportunities

- **Phase 2**: T001, T002, T003 — tất cả parallel (files khác nhau: UserDAO, ReservationDAO)
- **Phase 3**: T007, T008 parallel với T006 (T007 audit log, T008 DTO update)
- **Phase 4**: T009, T010, T011 — tất cả parallel

---

## Parallel Example: Phase 2

```bash
# Launch all foundational DAO tasks together:
Task T001: "Thêm lockUserForDuration() vào UserDAO.java"
Task T002: "Thêm findAllActiveByUserId() vào ReservationDAO.java"
Task T003: "Thêm cancelAllActiveByUserId() vào ReservationDAO.java"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 2: Foundational (3 DAO methods)
2. Complete Phase 3: User Story 1 (Core penalty logic)
3. **STOP and VALIDATE**: Test theo quickstart.md Scenarios 1-3
4. Deploy/demo if ready — chế tài hoạt động, email chưa có

### Incremental Delivery

1. Phase 2 → Foundation ready (3 DAO methods)
2. Phase 3 → US1 Core Penalty → Test → Deploy (MVP!)
3. Phase 4 → Polish → Final Deploy

---

## Notes

- Feature này chủ yếu sửa 1 file chính: `ReservationExpirationProcessor.java` + 2 file DAO phụ
- Không tạo Model/Entity/Servlet mới
- Tất cả SQL phải dùng PreparedStatement (SEC-03)
- Bảng "User" bắt buộc nháy kép trong SQL (DB-01)
- Email gửi async qua EmailService.enqueue() — KHÔNG đồng bộ trong HTTP thread (Constitution IV)
- Giao diện hiện tại không cần thay đổi — feature chạy hoàn toàn background
