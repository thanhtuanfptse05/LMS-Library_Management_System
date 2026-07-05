# Tasks: Book Suggestions (F20)

**Input**: Design documents from `/specs/feat-bookSuggestion/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and database schema updates

- [X] T001 Create database schema with `CHECK (voteCount >= 0)` constraint, essential Indexes for `< 200ms` SLA (title, status, voteCount, createdAt), and insert `MAX_SUGGESTION_PER_LECTURER` config into `database/supabase/LMS_Schema_PostgreSQL.sql`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 [P] Create `BookSuggestion` model in `src/java/model/BookSuggestion.java`
- [X] T003 [P] Create `SuggestionVote` model in `src/java/model/SuggestionVote.java`
- [X] T004 Create foundational CRUD operations in `src/java/dao/BookSuggestionDAO.java`
- [X] T005 Create foundational CRUD operations in `src/java/dao/SuggestionVoteDAO.java`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Giảng viên gửi đề xuất sách mới (Priority: P1) 🎯 MVP

**Goal**: Giảng viên có thể đề xuất sách mới, tự sửa hoặc tự xóa cứng đề xuất của mình khi `voteCount=1`.

**Independent Test**: Giảng viên đăng nhập, submit form tạo mới thành công, và tự xóa đề xuất thành công.

### Implementation for User Story 1

- [X] T006 [US1] Implement creation with DB Transaction (insert Suggestion + Vote), validation (incl. similar title check), config limit check, and add `@WebFilter("/lecturer/*")` in `src/java/controllers/BookSuggestionServlet.java` (POST create)
- [X] T007 [US1] Implement edit and hard-delete (with Audit Log) in `src/java/controllers/BookSuggestionServlet.java` (POST update/delete)
- [X] T008 [US1] Create the UI form for submission in `web/lecturer/book-suggestions.jsp`

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently (can verify DB records).

---

## Phase 4: User Story 3 - Giảng viên xem danh sách đề xuất (Priority: P2)

**Goal**: Giảng viên có thể xem danh sách đề xuất với phân trang, lọc theo trạng thái và tìm kiếm theo tiêu đề. (Được đẩy lên trước US2 để hỗ trợ UI cho việc Vote).

**Independent Test**: Giảng viên truy cập `/lecturer/book-suggestions`, thấy danh sách các đề xuất đã tạo, và có thể tìm kiếm.

### Implementation for User Story 3

- [X] T009 [US3] Implement `getPaginatedSuggestions` with search/filter in `src/java/dao/BookSuggestionDAO.java`
- [X] T010 [US3] Implement GET request handling for list view in `src/java/controllers/BookSuggestionServlet.java`
- [X] T011 [US3] Update `web/lecturer/book-suggestions.jsp` to display the data table, pagination, and search/filter controls

**Checkpoint**: Danh sách hiển thị đầy đủ, cho phép tương tác trực quan.

---

## Phase 5: User Story 2 - Giảng viên vote cho đề xuất có sẵn (Priority: P1)

**Goal**: Giảng viên có thể vote (+1) cho các đề xuất "pending" của người khác và hủy vote của chính mình.

**Independent Test**: Giảng viên bấm nút "+1" trên danh sách, voteCount tăng và nút chuyển thành "Hủy vote".

### Implementation for User Story 2

- [X] T012 [P] [US2] Implement vote transaction (insert vote + increment voteCount) in `src/java/dao/SuggestionVoteDAO.java`
- [X] T013 [P] [US2] Implement unvote transaction (delete vote + decrement voteCount) in `src/java/dao/SuggestionVoteDAO.java`
- [X] T014 [US2] Handle POST requests for vote/unvote in `src/java/controllers/BookSuggestionServlet.java`
- [X] T015 [US2] Update `web/lecturer/book-suggestions.jsp` to render "+1" / "Hủy vote" buttons based on user's vote history

**Checkpoint**: Tính năng Vote và Hủy vote hoạt động hoàn chỉnh trên danh sách.

---

## Phase 6: User Story 4 - Thủ thư quản lý trạng thái đề xuất (Priority: P2)

**Goal**: Thủ thư có thể đổi trạng thái đề xuất (pending/acknowledged/rejected) kèm ghi chú, và ghi Audit Log.

**Independent Test**: Thủ thư truy cập list, đổi trạng thái 1 đề xuất sang `acknowledged` với ghi chú, trạng thái cập nhật trên DB và Audit Log.

### Implementation for User Story 4

- [X] T016 [US4] Implement `updateStatus` with librarianNote and AuditLog insertion in `src/java/dao/BookSuggestionDAO.java`
- [X] T017 [US4] Create `src/java/controllers/LibrarianBookSuggestionServlet.java` to serve the librarian view and handle status updates, ensuring `@WebFilter("/librarian/*")` is applied
- [X] T018 [US4] Create dashboard view `web/librarian/book-suggestions.jsp` with status management UI

**Checkpoint**: Toàn bộ luồng quản lý đề xuất (Giảng viên <-> Thủ thư) đã hoàn tất.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [X] T019 [P] Thêm link truy cập "Đề xuất sách" vào sidebar của `web/lecturer/dashboard.jsp` và `web/librarian/dashboard.jsp`
- [X] T020 Thực hiện kiểm thử toàn bộ các scenarios trong `quickstart.md`
- [X] T021 Code cleanup and refactoring (kiểm tra JSTL, EL, đóng kết nối DB)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion
- **User Stories (Phase 3-6)**: 
  - US1 (Phase 3) depends on Foundational.
  - US3 (Phase 4) depends on US1.
  - US2 (Phase 5) depends on US3 (requires list UI to vote easily).
  - US4 (Phase 6) depends on Foundational (can be done in parallel with US1/2/3).
- **Polish (Final Phase)**: Depends on all user stories being complete

### Parallel Opportunities

- T002 and T003 can run in parallel (independent models).
- T012 and T013 can run in parallel (independent DAO methods).
- Phase 6 (Librarian features) can be developed in parallel with Phase 3/4/5 if multiple developers are assigned.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 & 2 (SQL Schema & Models/DAOs).
2. Complete Phase 3 (US1 - Submit form & self-manage).
3. Validate US1 via direct DB checks.

### Incremental Delivery

1. Add Phase 4 (US3 - View list) -> Now lecturers can see suggestions.
2. Add Phase 5 (US2 - Vote mechanism) -> Now lecturers can collaborate.
3. Add Phase 6 (US4 - Librarian management) -> Now librarians can respond.
4. Phase 7 (Polish).
