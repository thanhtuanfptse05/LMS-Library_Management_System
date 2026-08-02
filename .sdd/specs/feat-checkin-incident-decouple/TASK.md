# Implementation Tasks: Tách Nghiệp Vụ Check-in Hỏng/Mất (Checkin-Incident Decouple)

**Feature Directory**: `.sdd/specs/feat-checkin-incident-decouple`
**Feature Branch**: `feat/checkin-incident-decouple`
**Spec**: [SPEC.md](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/.sdd/specs/feat-checkin-incident-decouple/SPEC.md)
**Plan**: [PLAN.md](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/.sdd/specs/feat-checkin-incident-decouple/PLAN.md)

## Phase 1: Database & Model (Setup)

- [x] T001 [P] ALTER TABLE BookCopyIncident ADD COLUMN borrowRecordId INT NULL với FK → BorrowRecord trong [LMS_Schema_PostgreSQL.sql](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/database/supabase/LMS_Schema_PostgreSQL.sql)
- [x] T002 [P] Bổ sung field `borrowRecordId` (Integer, nullable) và getter/setter trong [BookCopyIncident.java](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/src/java/model/BookCopyIncident.java)

## Phase 2: DAO Foundation

- [x] T003 [P] Cập nhật `baseSelect()` và `map()` để load `borrowRecordId` từ ResultSet trong [BookCopyIncidentDAO.java](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/src/java/dao/BookCopyIncidentDAO.java)
- [x] T004 [P] Bổ sung method `insertPendingFromCheckIn(conn, incident, borrowRecordId)` trong [BookCopyIncidentDAO.java](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/src/java/dao/BookCopyIncidentDAO.java)

## Phase 3: User Story 1 — Thủ thư nhận trả sách nghi hỏng/mất tại quầy (P1)

- [x] T005 [US1] Refactor `processCheckInDamagedOrLost()` trong [DeskCirculationService.java](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/src/java/service/DeskCirculationService.java) — chuyển `BorrowRecord → returned`, `BookCopy → unavailable`, tạo `BookCopyIncident pending` qua `insertPendingFromCheckIn`, bỏ các bước tạo Fine đền bù / khóa tài khoản / giảm totalQuantity.
- [x] T006 [US1] Cập nhật `processCheckIn()` trong [DeskCirculationService.java](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/src/java/service/DeskCirculationService.java) — vẫn tính và tạo phạt quá hạn (overdue fine) nếu trả trễ hạn cho mọi condition, bỏ trigger email phạt đền bù ở F6.
- [x] T007 [US1] Cập nhật thông báo thành công khi check-in damaged/lost trong [CheckInServlet.java](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/src/java/controllers/CheckInServlet.java) — thông báo sách đã ghi nhận nghi vấn và chuyển F13 xác minh.

## Phase 4: User Story 2 — F13 xác minh sự cố và kết luận (P1)

- [x] T008 [US2] Inject các DAO phụ thuộc (`FineDAO`, `PaymentDAO`, `UserLockReasonDAO`, `UserDAO`) vào [BookCopyIncidentService.java](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/src/java/service/BookCopyIncidentService.java)
- [x] T009 [US2] Bổ sung logic khi `resolve` incident có `borrowRecordId != null` trong [BookCopyIncidentService.java](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/src/java/service/BookCopyIncidentService.java) — tính Fine đền bù, tạo Payment pending, thêm UserLockReason 'unpaid', khóa tài khoản `User.status='locked'`.
- [x] T010 [US2] Bổ sung gửi email thông báo phạt bất đồng bộ sau commit trong `resolve` tại [BookCopyIncidentService.java](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/src/java/service/BookCopyIncidentService.java)
- [x] T011 [US2] Kiểm tra logic `reject` trong [BookCopyIncidentService.java](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/src/java/service/BookCopyIncidentService.java) — khôi phục `BookCopy → available`, không đụng đến Fine/UserLockReason.

## Phase 5: User Story 3 — Truy vết liên kết giữa Sự cố và Lượt mượn (P2)

- [x] T012 [US3] Hiển thị mã lượt mượn (`borrowRecordId`) và thông tin người mượn trên danh sách/chi tiết sự cố tại F13 JSP
- [x] T013 [US3] Ghi Audit Log kèm `borrowRecordId` khi F13 kết luận sự cố

## Phase 6: Polish & Verification

- [x] T014 Chạy manual verification theo [quickstart.md](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/.sdd/specs/feat-checkin-incident-decouple/quickstart.md) cho 4 kịch bản
- [x] T015 Chạy JUnit test suite để đảm bảo không rách regression
