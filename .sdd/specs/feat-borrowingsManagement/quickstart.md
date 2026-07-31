# Quickstart Validation Guide: Librarian Borrowings Management

**Feature**: `.sdd/specs/feat-borrowingsManagement`
**Date**: 2026-07-31

---

## 1. Hướng dẫn Kiểm thử Chức năng Tra cứu & Tìm kiếm (GET Flow)

1. **Khởi động Server NetBeans / Tomcat.**
2. **Đăng nhập với tài khoản Thủ thư:** Email `librarian1@lms.edu.vn`, Password `123`.
3. **Truy cập đường dẫn:** `http://localhost:8080/LMS-Library_Management_System/librarian/borrowings`.
4. **Kiểm tra hiển thị:**
   * Màn hình danh sách mượn sách hiển thị bảng phân trang (10 bản ghi/trang).
   * Thử nhập mã sinh viên (ví dụ `SE170001`) hoặc mã vạch sách vào ô tìm kiếm -> Nhấn "Tìm kiếm".
   * Xác nhận kết quả tìm kiếm được lọc chính xác.

---

## 2. Hướng dẫn Kiểm thử Gửi Gmail Yêu cầu Thu hồi (POST Flow)

1. Tại danh sách mượn sách, tìm một lượt mượn đang mượn (`status = 'borrowed'`).
2. Nhấn nút **"Gửi Gmail Thu hồi"** tại cột Thao tác.
3. Màn hình hiển thị Modal nhập lý do thu hồi -> Nhập: `"Yêu cầu phục vụ nghiên cứu khoa học cấp trường"`.
4. Nhấn **"Xác nhận Gửi Mail"**.
5. **Kế quả kỳ vọng:**
   * Thông báo Toast thành công hiển thị: *"Đã gửi email yêu cầu thu hồi tới độc giả"*.
   * Lượt mượn **giữ nguyên trạng thái `borrowed`**.
   * Kiểm tra log máy chủ / hàng đợi email: `EmailJob` gắn template `RECALL_NOTICE` được xử lý bất đồng bộ thành công.
   * Kiểm tra CSDL bảng `AuditLogs`: Có bản ghi mới với `actionType = 'SEND_RECALL_EMAIL'`.
