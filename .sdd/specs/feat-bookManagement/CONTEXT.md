# CONTEXT.md — Quản lý Sách và Kho vật lý (Feature 4)
# Phiên bản: 1.0.0 | Ngày: 2026-06-06

## 1. PROBLEM STATEMENT
Thư viện cần quản lý danh mục sách và số lượng bản sao vật lý một cách chính xác. Lỗi đồng bộ giữa dữ liệu ảo và số lượng sách thực tế trong kho gây ra tình trạng độc giả đặt trước trực tuyến nhưng không có sách vật lý đáp ứng. Quá trình nhập kho và cập nhật tình trạng sách phải được theo dõi sát sao.

## 2. DOMAIN KNOWLEDGE
- **Book (Đầu sách):** Thông tin thư mục chung (ISBN, Tác giả, Tiêu đề, Giá). Không được phép mượn thực thể này.
- **BookCopy (Bản sao):** Cuốn sách vật lý cụ thể, định danh bằng Barcode duy nhất. Đây là thực thể được mang đi mượn.
- **Inventory Metrics:** `totalQuantity` (tổng tài sản đã nhập) và `availableQuantity` (sách đang nằm trong kho, sẵn sàng cho mượn).

## 3. STAKEHOLDERS
- **Librarian (Thủ thư):** Người vận hành chính, thêm/sửa Đầu sách và nhập kho Bản sao vật lý.

## 4. CONSTRAINTS (Ràng buộc cứng)
- **Tech Stack:** Java Servlet, JDBC, JSP.
- **Data Integrity:** Không cho phép Hard Delete đối với bảng `Book` và `BookCopy`.
- **Inventory Lock:** Không được phép chỉnh sửa định danh `ISBN` (Book) và `Barcode` (BookCopy) sau khi đã tạo (Tuân thủ BR-18).

## 5. ASSUMPTIONS
- Dữ liệu mã vạch (Barcode) được hệ thống tự động sinh hoặc quét từ thiết bị phần cứng đảm bảo định dạng chuẩn.
- Thao tác chuyển đổi tình trạng `Condition` của `BookCopy` từ 'good' sang 'damaged' hoặc 'lost' tại phân hệ F4 xảy ra khi Librarian đi kiểm kho định kỳ, tách biệt với luồng Check-in của F6.

## 6. OPEN QUESTIONS
- N/A