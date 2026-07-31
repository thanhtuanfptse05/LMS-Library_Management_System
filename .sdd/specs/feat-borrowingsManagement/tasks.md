# Tasks: Librarian Borrowings Management & Recall Request (Quản lý danh sách mượn & Gửi yêu cầu Thu hồi sách)

**Input**: Design documents from `.sdd/specs/feat-borrowingsManagement/`
**Prerequisites**: `spec.md`, `plan.md`, `research.md`, `data-model.md`, `contracts/api-contracts.md`, `quickstart.md`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Khởi tạo DTO và môi trường dữ liệu cho tính năng

- [x] T001 [P] Verify SQL seed template `RECALL_NOTICE` in `database/supabase/seeds/04_email_templates.sql`
- [x] T002 [P] Create DTO class `BorrowingManagementDTO` in `src/java/dto/BorrowingManagementDTO.java`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Hạ tầng cơ sở dữ liệu và DAO dùng chung

- [x] T003 Implement `searchBorrowingsPaginated(...)` method in `src/java/dao/BorrowRecordDAO.java` (depends on T002)
- [x] T004 Verify `AuditLogDAO` and `EmailService` integration readiness in `src/java/dao/AuditLogDAO.java` and `src/java/service/EmailService.java`

**Checkpoint**: Foundational layer complete - ready for user story implementation

---

## Phase 3: User Story 1 - Xem & Tìm kiếm danh sách mượn sách (Priority: P1) 🎯 MVP

**Goal**: Cho phép Thủ thư tra cứu, tìm kiếm theo từ khóa và xem danh sách mượn sách phân trang (10 bản ghi/trang).

**Independent Test**: Đăng nhập tài khoản Thủ thư, truy cập `/librarian/borrowings`, nhập từ khóa tìm kiếm (Mã SV/GV, Mã vạch) hoặc chọn lọc trạng thái, kiểm tra danh sách kết quả hiển thị khớp.

### Tests for User Story 1 (Unit & Integration)
- [x] T005 [P] [US1] Create unit test for `BorrowRecordDAO.searchBorrowingsPaginated()` in `test/f06_desk_circ/LibrarianBorrowingsManagementTest.java`

### Implementation for User Story 1
- [x] T006 [US1] Create `DeskBorrowingManagerServlet` handling `doGet` in `src/java/controllers/DeskBorrowingManagerServlet.java` (depends on T003)
- [x] T007 [US1] Create JSP view `borrowings-management.jsp` in `web/librarian/borrowings-management.jsp` (depends on T006)
- [x] T008 [US1] Add navigation sidebar link to `/librarian/borrowings` in `web/librarian/fragments/_sidebar.jsp`

**Checkpoint**: User Story 1 (MVP) is fully functional and independently testable

---

## Phase 4: User Story 2 - Gửi Yêu cầu Thu hồi sách qua Gmail (Priority: P2)

**Goal**: Cho phép Thủ thư gửi email bất đồng bộ yêu cầu độc giả mang sách tới quầy trả theo mẫu `RECALL_NOTICE` kèm lý do cụ thể và ghi vết AuditLog.

**Independent Test**: Nhấn nút "Gửi Gmail Thu hồi" tại một lượt mượn đang hoạt động, nhập lý do và gửi. Kiểm tra mail được đưa vào hàng đợi `EmailService`, lượt mượn giữ nguyên trạng thái `borrowed`/`overdue`, và `AuditLogs` lưu vết `SEND_RECALL_EMAIL`.

### Tests for User Story 2 (Unit & Integration)
- [x] T009 [P] [US2] Create unit test for `sendRecallEmail` flow in `test/f06_desk_circ/LibrarianBorrowingsManagementTest.java`

### Implementation for User Story 2
- [x] T010 [US2] Implement `doPost` action `sendRecallEmail` in `src/java/controllers/DeskBorrowingManagerServlet.java` (depends on T006)
- [x] T011 [US2] Add Recall Reason Modal & Toast notifications to `web/librarian/borrowings-management.jsp` (depends on T007, T010)

**Checkpoint**: User Story 2 is fully functional and independently testable

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Đảm bảo chất lượng mã nguồn và kiểm thử hệ thống

- [x] T012 Run quickstart validation scenarios in `quickstart.md`
- [x] T013 Verify 100% Vietnamese UI text compliance (`UI-01`) across `borrowings-management.jsp` and servlet error messages

---

## Dependencies & Execution Order

### Phase Dependencies
- **Setup (Phase 1)**: No dependencies - can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion.
- **User Story 1 (Phase 3)**: Depends on Foundational completion.
- **User Story 2 (Phase 4)**: Depends on User Story 1 completion.
- **Polish (Phase 5)**: Depends on User Story 1 and 2 completion.

---

## Implementation Strategy

### MVP First (User Story 1 Only)
1. Complete Setup & Foundational (T001 - T004).
2. Complete User Story 1 (T005 - T008).
3. Validate MVP: View & Filter borrowings list.

### Full Delivery
1. Complete User Story 2 (T009 - T011).
2. Complete Polish (T012 - T013).
3. All feature acceptance criteria satisfied.
