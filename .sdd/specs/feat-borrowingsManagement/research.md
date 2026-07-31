# Research & Architecture Decisions: Librarian Borrowings Management & Recall Request

**Feature**: `.sdd/specs/feat-borrowingsManagement`
**Date**: 2026-07-31

---

## 1. Controller & Security Filter Architecture

### Decision
* Triển khai `DeskBorrowingManagerServlet` kế thừa `HttpServlet` với annotation `@WebServlet("/librarian/borrowings")`.
* Bảo vệ đường dẫn qua `AuthFilter` (`/librarian/*`), chỉ cho phép các tài khoản có role `'librarian'`, `'manager'`, hoặc `'admin'` truy cập.

### Rationale
* Tuân thủ triệt để kiến trúc Monolith Servlet 4.0/5.0 không dùng Spring framework.
* Đảm bảo phân quyền truy cập chặt chẽ (RBAC) thông qua `@WebFilter`.

### Alternatives Considered
* gộp chung vào `DeskDashboardServlet`: Bị từ chối vì vi phạm nguyên tắc Chia nhỏ file và Single Responsibility Principle (SRP).

---

## 2. Data Transfer Object (DTO) & Multi-Table SQL Join

### Decision
* Tạo DTO `BorrowingManagementDTO.java` trong gói `dto` để mang dữ liệu tổng hợp cho tầng View.
* Các thuộc tính bao gồm: `borrowRecordId`, `userId`, `userFullName`, `userCode` (Mã sinh viên/giảng viên), `userEmail`, `userRole`, `bookId`, `bookTitle`, `isbn`, `bookCopyId`, `barcode`, `startDate`, `endDate`, `status`.
* Sử dụng `PreparedStatement` với SQL JOIN giữa 7 bảng: `BorrowRecord`, `MemberProfile`, `"User"`, `Book`, `BookCopy`, `Student`, `Lecturer`.

### Rationale
* Tránh N+1 query problem khi render danh sách mượn sách.
* `PreparedStatement` chống lỗi SQL Injection tuyệt đối (tuân thủ `SEC-03`).

---

## 3. Email Notification & Async Processing

### Decision
* Nút "Gửi Gmail Thu hồi" gọi `doPost(action='sendRecallEmail')`.
* Tái sử dụng `EmailService.enqueue(job)` sử dụng `LinkedBlockingQueue` chạy ngầm.
* Sử dụng mẫu `EmailTemplate` với `tempName = 'RECALL_NOTICE'`. Các placeholders: `{{userName}}`, `{{bookTitle}}`, `{{barcode}}`, `{{recallReason}}`.

### Rationale
* Phản hồi HTTP cực nhanh (<10ms), không làm treo trang web của Thủ thư khi gửi mail qua SMTP.
* Đảm bảo tính nhất quán với tệp Seed `04_email_templates.sql`.

---

## 4. Audit Logging & Compliance

### Decision
* Sau khi đẩy email vào hàng đợi thành công, gọi `AuditLogDAO.insert(conn, librarianId, "SEND_RECALL_EMAIL", "BorrowRecord", borrowRecordId, oldValues, newValues)`.

### Rationale
* Tuân thủ quy tắc `ARCH-02` (Mandatory Audit Log) của hệ thống LMS.
