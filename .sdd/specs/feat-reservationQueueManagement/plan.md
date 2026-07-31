# Implementation Plan: Quản lý Hàng chờ Đặt trước dành cho Thủ thư (Librarian Reservation Queue Management)

**Branch**: `feat-reservationQueueManagement` | **Date**: 2026-07-31 | **Spec**: [spec.md](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/.sdd/specs/feat-reservationQueueManagement/spec.md)

**Input**: Feature specification from `.sdd/specs/feat-reservationQueueManagement/spec.md`

## Summary

Triển khai phân hệ **Quản lý Hàng chờ Đặt trước dành riêng cho Thủ thư (Librarian Reservation Queue Management)** dựa trên các thành phần **ĐÃ CÓ SẴN** trong hệ thống.
* **Tái sử dụng Service có sẵn**: `OnlineCirculationService.cancelReservationByLibrarian(librarianId, reservationId)` (đã có sẵn logic hủy, đôn hàng chờ nguyên tử, ghi `AuditLogs` và gửi email cho người tiếp theo).
* **Tái sử dụng Entity Model có sẵn**: `model.Reservation` (đã chứa sẵn các thuộc tính `memberName`, `memberCode`, `bookTitle`, `queuePosition`, `status`, `startDate`, `endDate`). Không tạo DTO mới dư thừa.
* **Tái sử dụng DAO có sẵn**: `ReservationDAO.java` (đã có sẵn `findPendingReservations`, `findReadyPickupReservations`, `shiftQueuePositions`, `decrementQueuePositions`). Chỉ bổ sung thêm phương thức phân trang/lọc từ khóa `findReservationQueueForLibrarian`.

## Technical Context

**Language/Version**: Java JDK 17, Servlet 4.0/5.0, JSP + JSTL (Không dùng Scriptlet Java `<% %>` trong JSP).

**Primary Dependencies**: JDBC, PostgreSQL Driver 42.7.3, BCrypt.

**Storage**: PostgreSQL (Supabase / Supavisor pooler port 6543). Bảng chính: `Reservation`, `Book`, `"User"`, `MemberProfile`, `SystemConfigurations`, `AuditLogs`.

**Testing**: JUnit 5 (Unit tests cho `ReservationDAO`, `LibrarianReservationQueueServlet`).

**Target Platform**: Apache Tomcat 9/10 / Monolith Web Application.

**Project Type**: Monolith Java Servlet Web Application.

**Performance Goals**: Tải danh sách hàng chờ phân trang dưới 300ms.

**Constraints**: Chống SQL Injection bằng `PreparedStatement`. Phân quyền nghiêm ngặt chặn role `Student`/`Lecturer` truy cập `/librarian/reservation-queue*`.

## Code Reuse Inventory (Phân tích tái sử dụng CodeGraph)

| Thành phần / Phương thức | Trạng thái trong Codebase | Quyết định triển khai |
| :--- | :--- | :--- |
| `OnlineCirculationService.cancelReservationByLibrarian(librarianId, resId)` | **Đã có sẵn** (dòng 320 `OnlineCirculationService.java`) | **Tái sử dụng 100%**, không viết lại service hủy. |
| `model.Reservation` (`memberName`, `memberCode`, `bookTitle`) | **Đã có sẵn** (`src/java/model/Reservation.java`) | **Tái sử dụng 100%**, không tạo DTO mới. |
| `ReservationDAO.findPendingReservations` / `findReadyPickupReservations` | **Đã có sẵn** (dòng 919 & 978 `ReservationDAO.java`) | Tham khảo và **bổ sung hàm phân trang `findReservationQueueForLibrarian`** vào `ReservationDAO`. |
| `AuditLogDAO.insert` | **Đã có sẵn** (`src/java/dao/AuditLogDAO.java`) | **Tái sử dụng 100%** (đã được gọi sẵn trong `OnlineCirculationService`). |
| `SystemConfigurationsDAO` | **Đã có sẵn** (`src/java/dao/SystemConfigurationsDAO.java`) | **Tái sử dụng 100%** để đọc `RESERVATION_HOLD_DAYS`. |
| `LibrarianReservationQueueServlet` | **Chưa có** | **Tạo mới** tại `src/java/controllers/LibrarianReservationQueueServlet.java`. |
| `reservation-queue.jsp` | **Chưa có** | **Tạo mới** tại `web/librarian/reservation-queue.jsp`. |

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
├── plan.md              # Implementation plan (Code Reuse Focus)
├── research.md          # Phase 0 research
├── data-model.md        # Data model definitions
├── quickstart.md        # End-to-end validation scenarios
└── contracts/           # API contracts
    └── reservation_api_contract.md
```

### Source Code (repository root)

```text
src/java/
├── controllers/
│   └── LibrarianReservationQueueServlet.java # [MỚI] Controller quản lý hàng chờ cho Thủ thư (/librarian/reservation-queue)
├── dao/
│   └── ReservationDAO.java                   # [BỔ SUNG] Bổ sung hàm findReservationQueueForLibrarian phân trang
├── model/
│   └── Reservation.java                  # [TÁI SỬ DỤNG] Entity Model đã có sẵn memberName, memberCode, bookTitle
└── service/
    └── OnlineCirculationService.java         # [TÁI SỬ DỤNG] Tái sử dụng cancelReservationByLibrarian

web/
└── librarian/
    ├── reservation-queue.jsp                 # [MỚI] Trang giao diện chính Quản lý hàng chờ cho Thủ thư
    └── fragments/
        └── _librarian-left-panel.jsp          # [BỔ SUNG] Thêm menu "Quản lý hàng chờ đặt trước" vào Sidebar
```

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| *Không có vi phạm* | N/A | N/A |
