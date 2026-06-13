# PLAN.md — Kế hoạch Kiến trúc
Kiến trúc: Servlet MVC Pattern

## 1. Architectural Approach
Sử dụng NotificationService để điều phối logic giữa hai bảng dữ liệu. Áp dụng AuthFilter để chặn truy cập trái phép từ các role không phải Manager.

## 2. Components
* **NotificationServlet:** Xử lý Request CRUD cho thông báo và templates.
* **NotificationDAO:** Thực thi SQL INSERT/SELECT trên bảng Notification.
* **TemplateDAO:** Thực thi SQL UPDATE/SELECT trên bảng DocumentTemp.
* **JSP Views:** manage-broadcast.jsp và edit-template.jsp.

## 3. Risks & Mitigations
* **Risk:** SQL Injection qua nội dung thông báo.
* **Mitigation:** Sử dụng PreparedStatement tuyệt đối cho mọi câu lệnh SQL [SEC-03, 798].
