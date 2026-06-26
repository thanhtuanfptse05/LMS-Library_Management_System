# BÁO CÁO TÓM TẮT NHẬT KÝ LÀM VIỆC VỚI AI

## 📌 Thông tin chung
*   **Sinh viên thực hiện:** Lê Thế Bảo
*   **Môn học:** SWP391 - Dự án Phần mềm Đại học
*   **Đầu mục công việc:** F1 - Authentication
*   **Thời gian kết xuất:** 26/06/2026 10:15:00

---

## 📊 Bảng tổng hợp các lượt tương tác (Interaction Summary)

| Lượt | Mốc thời gian | Yêu cầu chính của Sinh viên | Tóm tắt giải quyết & Kết quả của AI |
| :--- | :--- | :--- | :--- |
| 1 | 02/06/2026 08:30:15 | bắt đầu triển khai F1: Authentication. Kiểm tra xem các file DAO và Filter đã có những gì rồi. | Kiểm tra file UserDAO, AuthFilter, LoginServlet và đề xuất bước tiếp theo. |
| 2 | 02/06/2026 08:35:22 | cập nhật UserDAO trước đi, nhớ là phải check khóa, và ghi nhận số lần đăng nhập sai. | Cập nhật UserDAO, bổ sung logic đếm số lần sai và khóa tài khoản, tích hợp BCrypt. |
| 3 | 02/06/2026 08:42:10 | test thử bị lỗi này: java.lang.NoClassDefFoundError: org/mindrot/jbcrypt/BCrypt | Phân tích lỗi thiếu thư viện jbcrypt, hướng dẫn cách add JAR vào NetBeans. |
| 4 | 02/06/2026 08:50:05 | oke đăng nhập được rồi. Giờ làm tính năng Quên mật khẩu. Gửi OTP qua email bất đồng bộ. | Viết chức năng quên mật khẩu, sử dụng CompletableFuture để gửi email bất đồng bộ. |
| 5 | 02/06/2026 09:15:30 | Gửi mail chậm quá, lúc ấn nó vẫn load trang 1 lúc mới hiện thông báo. Sửa lại cho nó redirect ngay. | Sửa logic đẩy job gửi email vào background thread độc lập, giúp servlet phản hồi và redirect ngay lập tức. |
| 6 | 02/06/2026 09:30:12 | chuẩn rồi. Giờ tạo AuthFilter để bảo vệ các route theo đúng role. | Triển khai AuthFilter chặn các route /admin, /student, xử lý redirect báo lỗi 403. |
