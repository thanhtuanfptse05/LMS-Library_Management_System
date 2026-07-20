# CONTEXT.md — Quản lý Sách và Kho vật lý (Feature 4)
# Phiên bản: 1.1.0 | Ngày: 2026-07-09

## 1. PROBLEM STATEMENT
Thư viện cần quản lý nhất quán metadata của đầu sách và từng bản sao vật lý. Nếu ISBN/Barcode bị trùng hoặc số lượng tổng hợp trên `Book` lệch với `BookCopy`, người dùng có thể thấy sách còn khả dụng trong khi kho không có bản sao đáp ứng. F4 cung cấp các thao tác danh mục, nhập kho và import hàng loạt để giữ dữ liệu này chính xác và có thể truy vết.

## 2. DOMAIN KNOWLEDGE
- **Book (Đầu sách):** Metadata dùng chung gồm ISBN, tiêu đề, tác giả, nhà xuất bản, năm xuất bản, giá, ảnh bìa và trạng thái. Đây không phải thực thể được mang đi mượn.
- **BookCopy (Bản sao):** Cuốn sách vật lý, có Barcode duy nhất, vị trí, condition và status. Đây là thực thể được lưu thông.
- **Category/Tag:** Phân loại nhiều-nhiều cho Book qua `BookCategory` và `BookTag`.
- **Inventory Metrics:** `totalQuantity` là tổng số BookCopy của Book; `availableQuantity` là số bản sao đang sẵn sàng lưu thông.
- **Bulk Import:** File `.xlsx` gồm hai sheet `Books` và `BookCopies`; dữ liệu nghiệp vụ được import theo chiến lược all-or-nothing.
- **Feature Boundary:** Báo hỏng/mất và kiểm kê kho thuộc F13 `feat-bookMaintenance`; F4 chỉ điều hướng các thay đổi condition sang quy trình đó.

## 3. STAKEHOLDERS
- **Librarian (Thủ thư):** Xem tổng quan, quản lý đầu sách, bản sao, thể loại, tag và import dữ liệu.
- **Borrowers (Độc giả/Giảng viên):** Phụ thuộc vào dữ liệu tồn kho chính xác khi tìm và đặt sách.
- **Auditor/Administrator:** Cần Audit Log cho mọi thao tác Create/Update quan trọng.

## 4. CONSTRAINTS (Ràng buộc cứng)
- **Tech Stack:** Java 17, Servlet, JSP/JSTL/EL, JDBC DAO, PostgreSQL; không dùng Spring hoặc ORM.
- **Schema Source:** Bắt buộc đối chiếu `database/supabase/LMS_Schema_PostgreSQL.sql`.
- **Access Control:** Toàn bộ `/librarian/book-management/*` được `AuthFilter` bảo vệ; chỉ `LIBRARIAN` truy cập F4.
- **Data Integrity:** Không hard-delete `Book` hoặc `BookCopy`; ISBN và Barcode bất biến sau khi tạo.
- **Transaction:** Mọi thay đổi gồm nhiều bảng và Audit Log phải dùng cùng một `Connection`.
- **UI:** Nhãn, lỗi và thông báo thành công phải 100% tiếng Việt.

## 5. ASSUMPTIONS
- Thiết bị quét Barcode hoạt động như bàn phím và không cần SDK riêng.
- Số lượng tồn kho được đồng bộ tại Service Layer, không dùng database trigger nghiệp vụ.
- ISBN đã tồn tại trong file import chỉ nhận thêm BookCopy; metadata Book hiện hữu không bị ghi đè.
- Lịch sử import lỗi được lưu để tra cứu nhưng không làm thay đổi Book/BookCopy.
- F13 chịu trách nhiệm thay đổi condition sang `damaged/lost`, xử lý sự cố và kiểm kê.

## 6. OPEN QUESTIONS
- N/A
