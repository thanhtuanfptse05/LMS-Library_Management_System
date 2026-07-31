# Implementation Plan: Quản lý Hàng chờ Đặt trước dành cho Thủ thư (Librarian Reservation Queue Management)

**Branch**: `feat-reservationQueueManagement` | **Date**: 2026-07-31 | **Spec**: [spec.md](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/.sdd/specs/feat-reservationQueueManagement/spec.md)

**Input**: Feature specification from `.sdd/specs/feat-reservationQueueManagement/spec.md`

## Summary

Triển khai phân hệ **Quản lý Hàng chờ Đặt trước dành riêng cho Thủ thư (Librarian Reservation Queue Management)**. 
Cho phép Thủ thư tra cứu, tìm kiếm, lọc các đơn đặt trước trên toàn hệ thống, theo dõi thứ tự hàng chờ theo tựa sách, thực hiện hủy đơn tại quầy (kèm lý do) và tự động đôn vị trí `queuePosition` cho người xếp sau.

*Phạm vi loại trừ:* Thủ tục cấp/giao sách trực tiếp cho độc giả tại quầy thuộc về phân hệ **Check-out (Mượn sách)**.

## Technical Context

**Language/Version**: Java JDK 17, Servlet 4.0/5.0, JSP + JSTL (Không dùng Scriptlet Java `<% %>` trong JSP).

**Primary Dependencies**: JDBC, PostgreSQL Driver 42.7.3, BCrypt.

**Storage**: PostgreSQL (Supabase / Supavisor pooler port 6543). Các bảng: `Reservation`, `BookCopy`, `Book`, `"User"`, `MemberProfile`, `SystemConfigurations`, `AuditLogs`.

**Testing**: JUnit 5 (Unit tests cho `ReservationDAO`).

**Target Platform**: Apache Tomcat 9/10 / Monolith Web Application.

**Project Type**: Monolith Java Servlet Web Application.

**Performance Goals**: Tải danh sách hàng chờ phân trang dưới 300ms.

**Constraints**: Chống SQL Injection bằng `PreparedStatement`. Phân quyền nghiêm ngặt chặn role `Student`/`Lecturer` truy cập `/librarian/reservation-queue*`.

## Constitution Check

*GATE: Passed. Complies with AGENTS.md, GEMINI.md, and project architecture guidelines.*
1. **SEC-01 & SEC-03**: Sử dụng `PreparedStatement` và kiểm tra quyền qua `@WebFilter`.
2. **ARCH-01**: Monolith Servlet + JDBC thuần, không dùng ORM.
3. **DB-01**: Đồng bộ schema PostgreSQL từ `LMS_Schema_PostgreSQL.sql`.
4. **UI-01**: 100% tiếng Việt trên giao diện JSP của Thủ thư.

## Project Structure

### Documentation (this feature)

```text
.sdd/specs/feat-reservationQueueManagement/
├── spec.md              # Requirement specification
├── plan.md              # Implementation plan
├── research.md          # Phase 0 research
├── data-model.md        # Data model & DTO definitions
├── quickstart.md        # End-to-end validation scenarios
└── contracts/           # API contracts
    └── reservation_api_contract.md
```

### Source Code (repository root)

```text
src/java/
├── controllers/
│   └── LibrarianReservationQueueServlet.java # Controller quản lý hàng chờ cho Thủ thư (/librarian/reservation-queue)
├── dao/
│   └── ReservationDAO.java                   # Phương thức tra cứu & hủy lượt dành riêng cho Thủ thư
├── dto/
│   └── ReservationQueueItemDTO.java          # DTO tổng hợp thông tin hàng chờ cho Thủ thư
└── service/
    └── DeskCirculationService.java           # Service xử lý hủy/đôn vị trí hàng chờ nguyên tử

web/
└── librarian/
    ├── reservation-queue.jsp                 # Trang giao diện chính Quản lý hàng chờ cho Thủ thư
    └── fragments/
        └── _librarian-left-panel.jsp          # Thêm menu "Quản lý hàng chờ đặt trước" vào Sidebar
```

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| *Không có vi phạm* | N/A | N/A |
