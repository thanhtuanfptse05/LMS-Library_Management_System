# Context: Audit Log (Nhật ký hoạt động và Dashboard Admin)

## Problem Statement (Mô tả vấn đề)
Hệ thống thư viện LMS có nhiều vai trò người dùng (Admin, Librarian, Manager, Student, Lecturer) cùng tương tác và thực hiện các thao tác thay đổi dữ liệu cốt lõi trên CSDL. Khi xảy ra sự cố, phá hoại dữ liệu, sai sót hoặc tranh chấp nghiệp vụ, Quản trị viên (`SysAdmin`) cần một công cụ giám sát tập trung để truy vết ai đã làm gì, tác động lên đối tượng nào, vào thời điểm nào và giá trị thay đổi cụ thể ra sao. Hiện tại, dữ liệu nhật ký kiểm toán đã được ghi lại tự động từ các dịch vụ nghiệp vụ nền, nhưng cần một giao diện quản trị an toàn để truy vấn, phân tích, và kết xuất.

## Business Drivers (Động lực kinh doanh)
* **Truy vết sự cố & Minh bạch:** Hỗ trợ SysAdmin truy vết nguyên nhân gây lỗi hoặc thay đổi bất thường đối với các thực thể cốt lõi (như thông tin tài khoản, cấu hình hệ thống, sách và giao dịch mượn trả).
* **Bảo mật và Tuân thủ:** Đảm bảo toàn bộ nhật ký thay đổi dữ liệu không thể bị chỉnh sửa hay xóa bỏ từ ứng dụng web (Read-Only).
* **Hỗ trợ kiểm toán:** Cho phép kết xuất dữ liệu nhật ký ra tệp Excel (.xlsx) chuẩn phục vụ việc lưu trữ độc lập hoặc báo cáo cấp trên.
* **Giám sát trực quan:** Cung cấp Dashboard Admin tích hợp biểu đồ và thông số đo lường sức khỏe toàn hệ thống (tổng số tài khoản, giao dịch quá hạn, hoạt động gần đây).

## Associated Use Cases (Các Use Cases liên quan)
* **UC-40 (View Audit Log):** Xem nhật ký kiểm toán, lọc và xem chi tiết so sánh.
* **UC-41 (Export Audit Log):** Xuất tệp Excel nhật ký kiểm toán.
* **UC-46 (View Admin Dashboard):** Xem bảng điều khiển Admin tổng quan.
