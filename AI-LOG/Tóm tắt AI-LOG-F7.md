# BÁO CÁO TÓM TẮT NHẬT KÝ LÀM VIỆC VỚI AI

## 📌 Thông tin chung
*   **Sinh viên thực hiện:** Lê Thế Bảo
*   **Môn học:** SWP391 - Dự án Phần mềm Đại học
*   **Đầu mục công việc:** F7 - Notification Management
*   **Thời gian kết xuất:** 26/06/2026 10:35:00

---

## 📊 Bảng tổng hợp các lượt tương tác (Interaction Summary)

| Lượt | Mốc thời gian | Yêu cầu chính của Sinh viên | Tóm tắt giải quyết & Kết quả của AI |
| :--- | :--- | :--- | :--- |
| 1 | 07/06/2026 15:20:00 | làm nốt F7 notification management. Admin có thể tạo thông báo chung hoặc riêng. | Đề xuất 2 phương án lưu trữ bảng UserNotificationStatus cho các thông báo Global để lựa chọn tối ưu về truy vấn và code. |
| 2 | 07/06/2026 15:28:15 | Dùng addBatch() đi, insert 1 lần ko chết DB đâu, logic sẽ dễ và nhất quán hơn. | Viết code NotificationManagerServlet dùng PreparedStatement.addBatch() để insert đồng loạt trạng thái nhận thông báo cho mọi User. |
| 3 | 07/06/2026 15:45:00 | làm cái chuông thông báo trên Header của học sinh. Có nút "đánh dấu đã đọc tất cả". | Cập nhật header.jsp tích hợp Vanilla JS (Fetch API) để kiểm tra thông báo mỗi phút, tạo chuông báo chấm đỏ và gọi API markAllRead. |
