# Context: System Report (Báo cáo hệ thống và Dashboard Admin)

## Problem Statement (Mô tả vấn đề)
Hệ thống Thư viện trường đại học cần có các công cụ báo cáo và phân tích dữ liệu tổng hợp trực quan để Quản trị viên (`Admin`) và Admin có thể dễ dàng theo dõi hiệu suất vận hành, giám sát doanh thu tiền phạt trễ hạn hoặc hỏng sách, quản lý rủi ro mất mát sách, và đánh giá hiệu suất làm việc của các thủ thư. Hiện tại, hệ thống cần được trang bị bảng điều khiển (`Dashboard`) thời gian thực, các biểu đồ xu hướng trực quan và tính năng kết xuất dữ liệu báo cáo ra Excel phục vụ mục đích kiểm toán và in ấn báo cáo ngoại tuyến.

## Business Drivers (Động lực kinh doanh)
* **Nâng cao hiệu quả quản trị:** Cung cấp số liệu thống kê thời gian thực (real-time KPIs) về tỷ lệ lưu thông sách để hỗ trợ Admin đưa ra quyết định mua sắm sách mới hoặc điều chỉnh chính sách mượn/trả.
* **Minh bạch tài chính:** Đối chiếu chính xác tiền phạt đã thu (paid) và tiền phạt chưa thu (unpaid) từ các giao dịch trễ hạn hoặc làm hỏng/mất bản sao sách.
* **Tối ưu hóa quản lý kho:** Đưa ra thống kê thất thoát, rách hỏng sách dựa trên dữ liệu đối soát thực tế của phiên kiểm kê gần nhất.
* **Đánh giá hiệu suất nhân viên:** Thống kê chi tiết lượng giao dịch thực hiện bởi từng Thủ thư (Librarian) để khen thưởng hoặc tối ưu hóa nhân sự.
* **Tiện ích kết xuất:** Xuất báo cáo ra định dạng Excel (.xlsx) chuẩn chỉnh phục vụ in ấn và lưu trữ ngoài hệ thống.

## Associated Use Cases (Các Use Cases liên quan)
* **UC-34 (View System Reports):** Xem báo cáo hệ thống với biểu đồ xu hướng.
* **UC-35 (Export Reports):** Xuất báo cáo hệ thống ra file Excel.
* **UC-45 (View Admin Dashboard):** Xem bảng điều khiển Admin với các chỉ số KPI.
* **UC-54 (View Staff Performance Report):** Xem báo cáo hiệu suất nhân viên thủ thư.
