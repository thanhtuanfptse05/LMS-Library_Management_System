# Quickstart & End-to-End Validation Guide: Librarian Reservation Queue Management

## Scenario 1: Thủ thư tra cứu toàn bộ hàng chờ đặt trước
1. Đăng nhập bằng tài khoản Thủ thư (`librarian1@lms.com`).
2. Điều hướng tới menu **Quản lý Hàng chờ Đặt trước** (`/librarian/reservation-queue`).
3. **Kỳ vọng**: Hiển thị bảng danh sách phân trang các đơn đặt trước của toàn bộ độc giả, xem được cột vị trí `queuePosition`, trạng thái `status`, và thời hạn `endDate`.

---

## Scenario 2: Thủ thư lọc danh sách theo tựa sách hoặc tên độc giả
1. Tại màn hình Quản lý Hàng chờ, nhập từ khóa tên sách (ví dụ "Lập trình Java") hoặc Mã sinh viên vào ô tìm kiếm.
2. Chọn trạng thái "Đang chờ" (`pending`).
3. Nhấn **Tìm kiếm**.
4. **Kỳ vọng**: Danh sách hiển thị chính xác các đơn thỏa mãn điều kiện lọc.

---

## Scenario 3: Thủ thư hủy đơn đặt trước của độc giả tại quầy
1. Nhấn nút **Hủy lượt** tại dải bản ghi của một độc giả đang chờ.
2. Nhập lý do hủy (ví dụ: "Độc giả báo hủy trực tiếp tại quầy").
3. Nhấn **Xác nhận hủy**.
4. **Kỳ vọng**:
   - Đơn đặt trước chuyển trạng thái thành `cancelled_librarian`.
   - Vị trí `queuePosition` của các độc giả xếp sau được tự động giảm đi 1.
   - Hiển thị thông báo thành công trên màn hình Thủ thư và ghi `AuditLogs`.

---

## Scenario 4: Phân quyền bảo vệ
1. Đăng nhập bằng tài khoản Sinh viên (`student1@lms.com`).
2. Truy cập trực tiếp URL `/librarian/reservation-queue`.
3. **Kỳ vọng**: `AuthFilter` chặn truy cập, chuyển hướng về trang báo lỗi phân quyền hoặc trang chủ.
