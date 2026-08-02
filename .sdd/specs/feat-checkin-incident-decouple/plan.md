# Implementation Plan: Tách Nghiệp Vụ Check-in Hỏng/Mất và Kết Luận Sự Cố (Checkin-Incident Decouple)

**Branch**: `feat/checkin-incident-decouple` | **Date**: 2026-08-01 | **Spec**: [SPEC.md](file:///c:/Users/ADMIN/OneDrive/Documents/SWP/LMS-Library_Management_System/.sdd/specs/feat-checkin-incident-decouple/SPEC.md)

## Summary

Tái thiết kế luồng Check-in Hỏng/Mất (F6 `DeskCirculationService.processCheckInDamagedOrLost`) để **chỉ ghi nhận nghi vấn** — tạo `BookCopyIncident(status='pending')`, tạm ngưng `BookCopy(status='unavailable')`, kết thúc `BorrowRecord(status='returned')` — mà **KHÔNG** tự động tạo Fine đền bù, khóa tài khoản hoặc giảm `totalQuantity` ngay lập tức.

Phần kết luận chính thức (tạo Fine, khóa tài khoản, loại khỏi kho) được chuyển sang F13 (`BookCopyIncidentService.resolve`). Bổ sung cột `borrowRecordId` vào bảng `BookCopyIncident` để F13 truy vết chính xác lượt mượn gây sự cố.

## Technical Context

**Language/Version**: Java JDK 17 + Java Servlet (Servlet 5.0)

**Primary Dependencies**: JDBC thuần, JSTL/EL, BCrypt, PostgreSQL Driver 42.7.3

**Storage**: PostgreSQL (Supabase, cổng 6543, Transaction Pooler)

**Testing**: JUnit 5

**Target Platform**: Java Web Monolith (Tomcat)

**Project Type**: Web Application (Monolith MVC)

**Performance Goals**: Thao tác quét barcode phản hồi < 200ms

**Constraints**: Không Framework (Spring/Hibernate cấm), 100% tiếng Việt, PreparedStatement bắt buộc

## Constitution Check

| Gate | Rule | Status |
|------|------|--------|
| SEC-03 | Mọi SQL dùng PreparedStatement | ✅ PASS — Tất cả SQL mới đều dùng `PreparedStatement` |
| ARCH-01 | Không ORM/Spring | ✅ PASS — JDBC thuần + DAO Pattern |
| ARCH-02 | Audit Log cho mọi C/U/D | ✅ PASS — Ghi AuditLog ở cả F6 (ghi nhận) và F13 (kết luận) |
| Soft-Delete | Không hard-delete giao dịch cốt lõi | ✅ PASS — Chỉ UPDATE status |
| UI-01 | 100% tiếng Việt | ✅ PASS — Mọi thông báo bằng tiếng Việt |
| DB-01 | Kiểm tra schema trước khi code | ✅ PASS — Đã kiểm tra `BookCopyIncident`, `BorrowRecord`, `BookCopy` |

## Project Structure

```text
database/supabase/
└── LMS_Schema_PostgreSQL.sql       # ALTER TABLE thêm cột borrowRecordId

src/java/
├── model/
│   └── BookCopyIncident.java       # Bổ sung field borrowRecordId
├── dao/
│   ├── BookCopyIncidentDAO.java    # Bổ sung insertPendingFromCheckIn(), sửa baseSelect/map
├── service/
│   ├── DeskCirculationService.java # Refactor processCheckInDamagedOrLost → ghi nhận only
│   └── BookCopyIncidentService.java# Bổ sung logic tạo Fine/khóa TK khi resolve
└── controllers/
    └── CheckInServlet.java         # Điều chỉnh thông báo thành công
```
