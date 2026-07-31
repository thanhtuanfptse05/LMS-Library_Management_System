# Implementation Plan: Quản lý danh sách mượn sách & Gửi yêu cầu Thu hồi sách cho Thủ thư (Librarian Borrowings Management & Recall Request)

**Branch**: `feat-borrowingsManagement` | **Date**: 2026-07-31 | **Spec**: [.sdd/specs/feat-borrowingsManagement/spec.md](file:///d:/LMS-Library_Management_System/.sdd/specs/feat-borrowingsManagement/spec.md)

---

## 1. Executive Summary

Xây dựng chức năng quản lý danh sách lượt mượn sách dành riêng cho Thủ thư tại giao diện `borrowings-management.jsp` kết hợp Servlet điều khiển `DeskBorrowingManagerServlet`. Hệ thống hỗ trợ tra cứu, tìm kiếm đa tiêu chí, phân trang dữ liệu kết hợp chức năng **Gửi Gmail Yêu cầu Thu hồi Sách** bất đồng bộ qua `EmailService` sử dụng mẫu `RECALL_NOTICE` đã được seed vào CSDL, đồng thời tự động lưu nhật ký thao tác `AuditLogs` (`SEND_RECALL_EMAIL`).

---

## 2. Technical Context

* **Language/Version**: Java JDK 17, Java Servlet 4.0/5.0, JSP + JSTL 2.0.
* **Primary Dependencies**: `jakarta.servlet-api`, `jakarta.servlet.jsp.jstl-api`, `jbcrypt`, `postgresql-42.7.3.jar`.
* **Storage**: PostgreSQL (Supabase / Session Pooler port 6543). Bảng tác động: `BorrowRecord`, `Book`, `BookCopy`, `MemberProfile`, `"User"`, `Student`, `Lecturer`, `EmailTemplate`, `AuditLogs`.
* **Testing**: JUnit 5 (Unit test cho DTO, DAO, Servlet logic).
* **Target Platform**: Apache Tomcat 10 / NetBeans IDE 17.
* **Project Type**: Monolith Java Web Application (MVC Pattern).
* **Performance Goals**: Phản hồi câu truy vấn tìm kiếm phân trang < 200ms, gửi mail ngầm non-blocking < 10ms HTTP latency.
* **Constraints**: 100% Tiếng Việt (`UI-01`), không dùng ORM/Spring Framework, dùng PreparedStatement chống SQL Injection (`SEC-03`).

---

## 3. Constitution & Architecture Rules Checklist

- [x] **SEC-01**: Bảo mật mật khẩu (dùng BCrypt).
- [x] **SEC-02**: Bảo vệ RBAC qua `@WebFilter` (`/librarian/*`).
- [x] **SEC-03**: Sử dụng `PreparedStatement` chống SQL Injection 100%.
- [x] **ARCH-02**: Ghi nhật ký `AuditLogs` (`SEND_RECALL_EMAIL`).
- [x] **UI-01**: Giao diện và thông báo 100% Tiếng Việt.
- [x] **DB-01**: Kiểm tra schema tệp `LMS_Schema_PostgreSQL.sql`.

---

## 4. Project Structure & Components

```text
src/java/
├── controllers/
│   └── DeskBorrowingManagerServlet.java  # Controller xử lý GET search/filter và POST sendRecallEmail
├── dao/
│   └── BorrowRecordDAO.java               # Bổ sung phương thức searchBorrowingsPaginated()
├── dto/
│   └── BorrowingManagementDTO.java        # DTO tổng hợp thông tin lượt mượn cho View
└── service/
    └── EmailService.java                  # Đã sẵn sàng, sử dụng EmailJob với template RECALL_NOTICE

web/
└── WEB-INF/views/librarian/
    └── borrowings-management.jsp         # Giao diện xem danh sách & Modal gửi Gmail thu hồi
```

---

## 5. Artifact Reference Index

* **Research & Architecture**: [research.md](file:///d:/LMS-Library_Management_System/.sdd/specs/feat-borrowingsManagement/research.md)
* **Data Model & SQL Query**: [data-model.md](file:///d:/LMS-Library_Management_System/.sdd/specs/feat-borrowingsManagement/data-model.md)
* **API Contracts**: [contracts/api-contracts.md](file:///d:/LMS-Library_Management_System/.sdd/specs/feat-borrowingsManagement/contracts/api-contracts.md)
* **Quickstart Validation**: [quickstart.md](file:///d:/LMS-Library_Management_System/.sdd/specs/feat-borrowingsManagement/quickstart.md)
