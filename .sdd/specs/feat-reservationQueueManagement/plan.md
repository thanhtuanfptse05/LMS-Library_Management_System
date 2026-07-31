# Implementation Plan: Quản lý Hàng chờ Đặt trước dành cho Thủ thư (Librarian Reservation Queue Management)

**Branch**: `feat-reservationQueueManagement` | **Date**: 2026-08-01 | **Spec**: [spec.md](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/.sdd/specs/feat-reservationQueueManagement/spec.md)

**Input**: Feature specification from `.sdd/specs/feat-reservationQueueManagement/spec.md` v1.5 (ADD-REORDER-QUEUE)

## Summary

Triển khai phân hệ **Quản lý Hàng chờ Đặt trước dành riêng cho Thủ thư (Librarian Reservation Queue Management)** dựa trên các thành phần **ĐÃ CÓ SẴN** trong hệ thống.
* **Tái sử dụng Service có sẵn**: `OnlineCirculationService.cancelReservationByLibrarian(librarianId, reservationId)` (đã có sẵn logic hủy, đôn hàng chờ nguyên tử, ghi `AuditLogs` và gửi email cho người tiếp theo).
* **Tái sử dụng Entity Model có sẵn**: `model.Reservation` (đã chứa sẵn các thuộc tính `memberName`, `memberCode`, `bookTitle`, `queuePosition`, `status`, `startDate`, `endDate`). Không tạo DTO mới dư thừa.
* **Tái sử dụng DAO có sẵn**: `ReservationDAO.java` (đã có sẵn `findPendingReservations`, `findReadyPickupReservations`, `shiftQueuePositions`, `decrementQueuePositions`, `findReservationQueueForLibrarian`, `countReservationQueueForLibrarian`).
* **Tính năng mới [FR-LIB-RES-04]**: Thay đổi vị trí hàng chờ (Reorder Queue Position) — cần tạo mới phương thức `reorderQueuePosition` tại `ReservationDAO`.

## Technical Context

**Language/Version**: Java JDK 17, Servlet 4.0/5.0, JSP + JSTL (Không dùng Scriptlet Java `<% %>` trong JSP).

**Primary Dependencies**: JDBC, PostgreSQL Driver 42.7.3, BCrypt.

**Storage**: PostgreSQL (Supabase / Supavisor pooler port 6543). Bảng chính: `Reservation`, `Book`, `"User"`, `MemberProfile`, `SystemConfigurations`, `AuditLogs`.

**Testing**: JUnit 5 (Unit tests cho `ReservationDAO`, `LibrarianReservationQueueServlet`).

**Target Platform**: Apache Tomcat 9/10 / Monolith Web Application.

**Project Type**: Monolith Java Servlet Web Application.

**Performance Goals**: Tải danh sách hàng chờ phân trang dưới 300ms. Thao tác reorder chạy trong 1 Transaction dưới 200ms.

**Constraints**: Chống SQL Injection bằng `PreparedStatement`. Phân quyền nghiêm ngặt chặn role `Student`/`Lecturer` truy cập `/librarian/reservation-queue*`.

## Code Reuse Inventory (Phân tích tái sử dụng CodeGraph)

| Thành phần / Phương thức | Trạng thái trong Codebase | Quyết định triển khai |
| :--- | :--- | :--- |
| `OnlineCirculationService.cancelReservationByLibrarian(librarianId, resId)` | **Đã có sẵn** | **Tái sử dụng 100%**, không viết lại service hủy. |
| `model.Reservation` (`memberName`, `memberCode`, `bookTitle`) | **Đã có sẵn** | **Tái sử dụng 100%**, không tạo DTO mới. |
| `ReservationDAO.findReservationQueueForLibrarian` | **Đã có sẵn** (đã implement Phase 1) | **Tái sử dụng 100%**. |
| `ReservationDAO.countReservationQueueForLibrarian` | **Đã có sẵn** (đã implement Phase 1) | **Tái sử dụng 100%**. |
| `ReservationDAO.shiftQueuePositions` / `decrementQueuePositions` | **Đã có sẵn** | Tham khảo pattern SQL cho reorder logic. |
| `ReservationDAO.findReservationByIdForUpdate` | **Đã có sẵn** | **Tái sử dụng 100%** trong reorder để lock row. |
| `AuditLogDAO.insert` | **Đã có sẵn** | **Tái sử dụng 100%**. |
| `ReservationDAO.reorderQueuePosition(conn, bookId, oldPos, newPos)` | **Chưa có** | **Tạo mới** — SQL dịch chuyển hàng loạt + gán vị trí mới. |
| `LibrarianReservationQueueServlet` (doPost action=reorder) | **Cần bổ sung** | **Bổ sung** action `reorder` vào Servlet đã có. |
| `reservation-queue.jsp` (modal đổi vị trí) | **Cần bổ sung** | **Bổ sung** modal nhập vị trí mới vào JSP đã có. |

## Constitution Check

*GATE: Passed. Complies with AGENTS.md, GEMINI.md, and project architecture guidelines.*
1. **SEC-01 & SEC-03**: Sử dụng `PreparedStatement` và kiểm tra quyền qua `@WebFilter`.
2. **ARCH-01**: Monolith Servlet + JDBC thuần, không dùng ORM.
3. **DB-01**: Đồng bộ schema PostgreSQL từ `LMS_Schema_PostgreSQL.sql`.
4. **UI-01**: 100% tiếng Việt trên giao diện JSP của Thủ thư.

## Project Structure

### Source Code Changes (Incremental — Reorder Feature)

```text
src/java/
├── controllers/
│   └── LibrarianReservationQueueServlet.java # [BỔ SUNG] Thêm action "reorder" vào doPost
├── dao/
│   └── ReservationDAO.java                   # [BỔ SUNG] Thêm reorderQueuePosition, getMaxPendingQueuePosition
└── service/
    └── OnlineCirculationService.java         # [TÁI SỬ DỤNG] cancelReservationByLibrarian (không thay đổi)

web/
└── librarian/
    └── reservation-queue.jsp                 # [BỔ SUNG] Thêm nút "Đổi vị trí" + modal nhập vị trí mới
```

## Reorder Algorithm (Chi tiết thuật toán dịch chuyển vị trí)

### Case 1: Đôn lên (Move Up) — `newPos < oldPos`
```
Ví dụ: Đổi #5 lên #2 (cùng bookId)
1. UPDATE Reservation SET queuePosition = queuePosition + 1
   WHERE bookId = ? AND queuePosition >= 2 AND queuePosition < 5 AND status = 'pending'
   → Kết quả: #2→#3, #3→#4, #4→#5
2. UPDATE Reservation SET queuePosition = 2 WHERE reservationId = ?
   → Lượt mục tiêu → #2
```

### Case 2: Đẩy xuống (Move Down) — `newPos > oldPos`
```
Ví dụ: Đổi #1 xuống #4 (cùng bookId)
1. UPDATE Reservation SET queuePosition = queuePosition - 1
   WHERE bookId = ? AND queuePosition > 1 AND queuePosition <= 4 AND status = 'pending'
   → Kết quả: #2→#1, #3→#2, #4→#3
2. UPDATE Reservation SET queuePosition = 4 WHERE reservationId = ?
   → Lượt mục tiêu → #4
```

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| *Không có vi phạm* | N/A | N/A |
