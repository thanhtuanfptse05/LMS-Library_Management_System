# Implementation Plan: F20 - Book Suggestions

**Branch**: `feat-bookSuggestion` | **Date**: 2026-07-05 | **Spec**: [SPEC.md](file:///D:/Data/NetBeansIDE17/LMS-Library_Management_System/.sdd/specs/feat-bookSuggestion/SPEC.md)

**Input**: Feature specification from `/specs/feat-bookSuggestion/spec.md`

## Summary

Tính năng Quản lý Đề xuất sách (F20) cho phép Giảng viên (Lecturer) đề xuất sách mới hoặc vote (+1) cho đề xuất đã có nhằm giúp thư viện thu thập nhu cầu tài liệu. Thủ thư (Librarian) có nhiệm vụ quản lý, chuyển trạng thái của các đề xuất (pending/acknowledged/rejected). Tính năng bao gồm tạo mới, quản lý lượt vote, chỉnh sửa/xóa đề xuất và xem danh sách hỗ trợ phân trang/tìm kiếm.

## Technical Context

**Language/Version**: Java JDK 17

**Primary Dependencies**: Java Servlet (Servlet 4.0/5.0), JSP, JSTL, JDBC thuần (không ORM)

**Storage**: PostgreSQL (Supabase) thông qua `org.postgresql.Driver` cổng 6543

**Testing**: JUnit 5

**Target Platform**: Monolith Java Web App (chạy trên Tomcat)

**Project Type**: Web Application

**Performance Goals**: SC-004: Danh sách đề xuất (phân trang, tìm kiếm) phản hồi (P95) < 200ms (điều kiện: tạo Index cho các trường lọc/sắp xếp).

**Constraints**: 
- NGHIÊM CẤM dùng các Framework như Spring, Hibernate, JPA.
- Chống SQL Injection bằng `PreparedStatement`.
- Soft-delete khi Thủ thư từ chối (chuyển status='rejected').
- Hard-delete khi Giảng viên tự xóa đề xuất (yêu cầu status='pending' và voteCount=1).
- Kiểm soát cấu hình bằng `MAX_SUGGESTION_PER_LECTURER` (mặc định 10).

**Scale/Scope**: Quy mô nội bộ trường đại học; mỗi Giảng viên tối đa 10 đề xuất đang `pending`.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] **I. Security-First**: Servlet được bảo vệ bởi `@WebFilter` và `HttpSession` phân quyền cho `Lecturer` và `Librarian`. Mọi truy vấn DB đều dùng `PreparedStatement` chống SQL Injection.
- [x] **II. Monolith MVC**: Không sử dụng framework. Controller là `BookSuggestionServlet`, Model là `BookSuggestion` / `SuggestionVote`, và View bằng JSP/JSTL.
- [x] **III. Audit Log**: Mọi thao tác Create, Update, Update Status, Delete đề xuất đều ghi nhật ký vào `AuditLogs`.
- [x] **IV. Async cho I/O chậm**: F20 không dùng notification email ở phiên bản này, bỏ qua.
- [x] **V. Soft-Delete**: Đề xuất bị thủ thư từ chối sẽ chuyển `status = 'rejected'`. Xóa cứng chỉ cho phép khi Giảng viên tự xóa đề xuất chưa ai vote (voteCount=1) theo ngoại lệ ở Spec.
- [x] **VI. Ngôn ngữ giao diện**: Toàn bộ UI `book-suggestions.jsp` và thông báo lỗi hiển thị bằng tiếng Việt.
- [x] **DB-01 PostgreSQL Constraints**: Cột FK/PK dùng camelCase, tuân thủ `NOW()` để lấy timestamp, kết nối cổng 6543.
- [x] **ENG Standards**: Đóng connection trong `finally`/try-with-resources, không in stack trace.

## Project Structure

### Documentation (this feature)

```text
specs/feat-bookSuggestion/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
src/java/
├── controllers/
│   └── BookSuggestionServlet.java
├── dao/
│   ├── BookSuggestionDAO.java
│   └── SuggestionVoteDAO.java
└── model/
    ├── BookSuggestion.java
    └── SuggestionVote.java

web/
├── lecturer/
│   └── book-suggestions.jsp
└── librarian/
    └── book-suggestions.jsp
```

**Structure Decision**: Tuân theo Option 1 (Monolith project). Controller đặt trong `src/java/controllers/`, data access layer trong `dao/`, entity trong `model/`, và views tách riêng trong `web/lecturer/` và `web/librarian/` để AuthFilter áp dụng bảo vệ theo URL pattern.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A       | N/A        | N/A                                 |
