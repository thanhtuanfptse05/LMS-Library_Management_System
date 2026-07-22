# CONTEXT.md — Quản lý Sách và Kho vật lý (Feature 4)
# Phiên bản: 1.1.0 | Ngày: 2026-07-09

## 1. PROBLEM STATEMENT
Thư viện cần quản lý nhất quán metadata của đầu sách và từng bản sao vật lý. Nếu ISBN/Barcode bị trùng hoặc số lượng tổng hợp trên `Book` lệch với `BookCopy`, người dùng có thể thấy sách còn khả dụng trong khi kho không có bản sao đáp ứng. F4 cung cấp các thao tác danh mục, nhập kho và import hàng loạt để giữ dữ liệu này chính xác và có thể truy vết.

## 2. DOMAIN KNOWLEDGE
- **Book (Đầu sách):** Metadata dùng chung gồm ISBN, tiêu đề, tác giả, nhà xuất bản, năm xuất bản, giá, ảnh bìa và trạng thái. Đây không phải thực thể được mang đi mượn.
- **BookCopy (Bản sao):** Cuốn sách vật lý, có Barcode duy nhất, vị trí, condition, status và cờ `removedFromInventory`. Đây là thực thể được lưu thông; lịch sử mượn/trả của bản sao được xem read-only để hỗ trợ tra cứu.
- **Category/Tag:** Phân loại nhiều-nhiều cho Book qua `BookCategory` và `BookTag`.
- **Inventory Metrics:** `totalQuantity` là tổng số BookCopy của Book; `availableQuantity` là số bản sao đang sẵn sàng lưu thông.
- **Bulk Import:** File `.xlsx` gồm hai sheet `Books` và `BookCopies`; dữ liệu nghiệp vụ được import theo chiến lược all-or-nothing.
- **CSV Export:** Danh sách đầu sách và bản sao có thể xuất CSV theo filter hiện tại; dữ liệu text phải được escape và trung hòa công thức để an toàn khi mở bằng Excel.
- **Feature Boundary:** F4 không cập nhật condition trực tiếp. Báo hỏng/mất phát hiện từ màn quản lý bản sao đi qua F13 `feat-bookMaintenance`; hỏng/mất phát hiện khi nhận trả sách tại quầy thuộc F6 check-in.

## 3. STAKEHOLDERS
- **Librarian (Thủ thư):** Xem tổng quan, quản lý đầu sách, bản sao, thể loại, tag và import dữ liệu.
- **Borrowers (Độc giả/Giảng viên):** Phụ thuộc vào dữ liệu tồn kho chính xác khi tìm và đặt sách.
- **Auditor/Administrator:** Cần Audit Log cho mọi thao tác Create/Update quan trọng.

## 4. CONSTRAINTS (Ràng buộc cứng)
- **Tech Stack:** Java 17, Servlet, JSP/JSTL/EL, JDBC DAO, PostgreSQL; không dùng Spring hoặc ORM.
- **Schema Source:** Bắt buộc đối chiếu `database/supabase/LMS_Schema_PostgreSQL.sql`.
- **Access Control:** Toàn bộ `/librarian/book-management/*` được `AuthFilter` bảo vệ; chỉ `LIBRARIAN` truy cập F4.
- **Data Integrity:** Không hard-delete `Book` hoặc `BookCopy`; ISBN và Barcode bất biến sau khi tạo.
- **Barcode Input:** Barcode nhập từ form hoặc import file không tự sinh; cả hai dùng cùng rule chỉ cho chữ, số và `- _ . /` để phù hợp in/scan.
- **Transaction:** Mọi thay đổi gồm nhiều bảng và Audit Log phải dùng cùng một `Connection`.
- **UI:** Nhãn, lỗi và thông báo thành công phải 100% tiếng Việt.

## 5. ASSUMPTIONS
- Thiết bị quét Barcode hoạt động như bàn phím và không cần SDK riêng.
- Số lượng tồn kho được đồng bộ tại Service Layer, không dùng database trigger nghiệp vụ.
- ISBN đã tồn tại trong file import chỉ nhận thêm BookCopy; metadata Book hiện hữu không bị ghi đè.
- Lịch sử import lỗi được lưu để tra cứu nhưng không làm thay đổi Book/BookCopy.
- F13 chịu trách nhiệm thay đổi condition sang `damaged/lost` cho sự cố báo thủ công/kiểm kê và loại bản sao hỏng nặng khỏi tổng kho; F6 chịu trách nhiệm trường hợp Thủ thư kết luận hỏng/mất ngay khi nhận trả sách.
- Export CSV phục vụ rà soát ngoại tuyến, không thay đổi dữ liệu nghiệp vụ.

## 6. OPEN QUESTIONS
- N/A
