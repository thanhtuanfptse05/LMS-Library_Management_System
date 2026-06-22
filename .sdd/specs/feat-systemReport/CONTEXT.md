# Context: System Report

## Problem Statement
Hệ thống Thư viện cần có một trang tổng hợp dữ liệu thống kê để `LibraryManager` có thể theo dõi tình hình hoạt động, doanh thu tiền phạt, số lượng mượn trả và rủi ro mất mát sách. Hiện tại, quá trình này đang thiếu công cụ báo cáo tổng quan trực quan và chức năng kết xuất dữ liệu để hỗ trợ công việc kiểm toán.

## Business Drivers
* **Nâng cao hiệu quả quản trị**: Thông qua dữ liệu thực tế (real-time) để đưa ra quyết định mua sắm sách hoặc thay đổi chính sách thư viện.
* **Minh bạch tài chính**: Theo dõi các khoản thu từ tiền phạt một cách chính xác dựa trên dữ liệu thanh toán đã hoàn tất (`status = 'paid'`).
* **Quản lý rủi ro**: Phát hiện nhanh các đầu sách thường xuyên hỏng hóc hoặc bị thất lạc để có phương án bảo trì kịp thời.
* **Tiện ích xuất file**: Hỗ trợ việc in ấn và báo cáo cấp trên qua định dạng Excel (.xlsx).
