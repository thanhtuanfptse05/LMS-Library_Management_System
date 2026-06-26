# BÁO CÁO TÓM TẮT NHẬT KÝ LÀM VIỆC VỚI AI

## 📌 Thông tin chung
*   **Sinh viên thực hiện:** Lê Thế Bảo
*   **Môn học:** SWP391 - Dự án Phần mềm Đại học
*   **Đầu mục công việc:** F4 - Book Management
*   **Thời gian kết xuất:** 26/06/2026 10:25:00

---

## 📊 Bảng tổng hợp các lượt tương tác (Interaction Summary)

| Lượt | Mốc thời gian | Yêu cầu chính của Sinh viên | Tóm tắt giải quyết & Kết quả của AI |
| :--- | :--- | :--- | :--- |
| 1 | 05/06/2026 08:10:00 | triển khai F4: Quản lý sách. Bắt đầu từ giao diện thêm sách, chọn danh mục và tag. | Lên phương án xây dựng BookServlet, lấy danh sách Category và Tag để load lên giao diện, cấu hình thư mục lưu ảnh. |
| 2 | 05/06/2026 08:18:22 | lưu trong thư mục web/assets/images/books. Nhưng đổi tên file ảnh thành mã ISBN. | Code logic xử lý Multipart upload, tự động đổi tên ảnh theo chuẩn ISBN, lưu metadata vào Book, BookCategory, BookTag. |
| 3 | 05/06/2026 08:35:10 | ảnh bị vỡ khi upload kìa, có cách nào resize ảnh bằng java thuần không? | Hỗ trợ ImageUtil dùng BufferedImage để cắt/resize ảnh theo tỷ lệ 2:3 chuẩn trước khi lưu trữ nhằm chống vỡ ảnh. |
| 4 | 05/06/2026 09:00:45 | làm tiếp phần BookCopy đi. Tự động sinh mã vạch ngẫu nhiên khi ấn "Thêm bản sao". | Viết logic trong BookCopyServlet, vòng lặp sinh barcode tự động (LIB-ISBN-XXX) và đổ dữ liệu quản lý trạng thái từng bản sao. |
