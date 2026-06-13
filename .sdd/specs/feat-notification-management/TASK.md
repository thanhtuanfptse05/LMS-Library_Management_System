# TASK.md — Phân rã Công việc (Atomic Tasks)
Mỗi task được thiết kế hoàn thành trong < 4 giờ.

| ID | Tên Task | File liên quan | DoD |
|---|---|---|---|
| T01 | Tạo DB Migration | migrations/ | Tạo bảng Notification và insert dữ liệu mẫu cho DocumentTemp. |
| T02 | Implement DAO | NotificationDAO.java | Hoàn thành hàm insert(), findAll(), updateTemplate(). |
| T03 | Service Layer Logic | NotificationService.java | Xử lý logic kiểm tra placeholder hợp lệ trước khi gọi DAO. |
| T04 | Controller Implementation | NotificationServlet.java | Phân nhánh action create, editTemplate, viewList. |
| T05 | Xây dựng Giao diện | notification-mgmt.jsp | Hiển thị danh sách thông báo và form sửa template bằng JSTL. |
| T06 | Integration Test | tests/notification/ | Verify thông báo tạo mới được hiển thị đúng trên Dashboard Sinh viên. |
