# BÁO CÁO TÓM TẮT NHẬT KÝ LÀM VIỆC VỚI AI

## 📌 Thông tin chung
*   **Sinh viên thực hiện:** Lê Thế Bảo
*   **Môn học:** SWP391 - Dự án Phần mềm Đại học
*   **Đầu mục công việc:** F2 - Profile Management
*   **Thời gian kết xuất:** 26/06/2026 10:15:00

---

## 📊 Bảng tổng hợp các lượt tương tác (Interaction Summary)

| Lượt | Mốc thời gian | Yêu cầu chính của Sinh viên | Tóm tắt giải quyết & Kết quả của AI |
| :--- | :--- | :--- | :--- |
| 1 | 03/06/2026 14:10:00 | triển khai F2 profile management đi. Có các file JSP nào cần sửa? | Lên danh sách các file cần tạo/sửa: MemberProfileDAO, ProfileService, Servlet và file jsp. |
| 2 | 03/06/2026 14:15:20 | ok bắt đầu đi. lấy thông tin từ DB lên và điền vào các form trong jsp bằng tiếng việt. | Cập nhật MemberProfileDAO và Servlet, viết code hiển thị ra trang JSP tiếng Việt bằng JSTL. |
| 3 | 03/06/2026 14:25:40 | bị lỗi 500 ở JSP rồi. Cannot find any information on property 'fullName' | Phát hiện thiếu Getter trong class MemberProfile, bổ sung đầy đủ Getter/Setter. |
| 4 | 03/06/2026 14:40:12 | giờ làm phần đổi mật khẩu trong trang profile. Kiểm tra mật khẩu cũ bằng BCrypt. | Viết chức năng đổi mật khẩu, so khớp BCrypt, băm mật khẩu mới và lưu vào DB. |
| 5 | 03/06/2026 15:00:20 | Audit log chưa được ghi lại kìa. Cột actionType trong DB bị rỗng nên lỗi SQL insert. | Cập nhật hàm gọi AuditLogDAO, truyền đúng tham số actionType = UPDATE_PASSWORD để xử lý SQL Insert. |
