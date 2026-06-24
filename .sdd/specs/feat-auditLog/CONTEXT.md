# CONTEXT.md — Nhật ký Kiểm toán (Audit Log)
# Phiên bản: 1.0.0 | Ngày: 2026-06-24

## 1. PROBLEM STATEMENT
Hệ thống thư viện có nhiều vai trò (Admin, Librarian, Manager, Student, Lecturer) thực hiện các thao tác thay đổi dữ liệu trên nhiều phân hệ khác nhau. Khi xảy ra phá hoại, sai lầm hoặc tranh chấp, SysAdmin cần truy vết ai đã làm gì, lên đối tượng nào, và giá trị cũ/mới là gì. Hiện tại dữ liệu audit đã được ghi sẵn bởi các tính năng F1-F14 nhưng chưa có giao diện để xem và phân tích.

## 2. DOMAIN KNOWLEDGE
- **Audit Log (Nhật ký Kiểm toán):** Bản ghi ghi lại mỗi hành động C/U/D (Tạo/Sửa/Xóa) do con người thực hiện lên dữ liệu hệ thống. Gồm: người thực hiện, loại hành động, đối tượng bị tác động, giá trị cũ, giá trị mới, thời điểm.
- **Tiến trình ngầm GHI (Hệ thống con A):** Các Service/Controller của các tính năng khác đã ghi audit log vào bảng AuditLogs khi thao tác thành công. F12 KHÔNG tạo thêm logic ghi.
- **Giao diện ĐỌC (Hệ thống con B):** Trang web cho SysAdmin xem, lọc, tìm kiếm, và xuất CSV dữ liệu audit log đã được ghi.

## 3. STAKEHOLDERS
- **SysAdmin (Quản trị viên):** Người duy nhất được quyền truy cập trang Nhật ký Kiểm toán để giám sát và truy vết hành vi người dùng.

## 4. CONSTRAINTS (Ràng buộc cứng)
- **Tech Stack:** Java Servlet, JDBC, JSP.
- **Read-only:** F12 chỉ SELECT dữ liệu từ bảng AuditLogs và "User". Không Insert/Update/Delete bất kỳ bảng nào.
- **Schema:** Không thay đổi cấu trúc bảng đã có.

## 5. ASSUMPTIONS
- Dữ liệu audit log đã được ghi đầy đủ bởi các tính năng khác (F1, F3, F4, F5, F6, F7, F10, F13, F14...).
- oldValues và newValues sẽ được chuẩn hóa sang JSON bởi các tính năng liên quan (F6 DeskCirculationService, F1 ForgotPasswordServlet) để modal hiển thị cards nhất quán.
- Bảng AuditLogs có thể chứa >100K rows trong production, yêu cầu phân trang bắt buộc.

## 6. OPEN QUESTIONS
- N/A (Đã giải quyết toàn bộ 7 case đặc biệt trong quá trình lập kế hoạch)
