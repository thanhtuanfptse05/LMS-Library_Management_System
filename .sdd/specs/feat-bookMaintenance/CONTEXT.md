# CONTEXT.md — Bảo trì sách và Kiểm kê (Feature 13)
# Phiên bản: 1.5.0 | Ngày: 2026-08-04

## 1. PROBLEM STATEMENT
Sách vật lý có thể hỏng, mất, nằm sai vị trí hoặc xuất hiện trên kệ dù hệ thống ghi nhận đang mượn/không khả dụng/đã loại khỏi kho. Nếu loại các bản sao này khỏi thao tác quét, kiểm kê sẽ bỏ sót sai lệch vật lý; nếu chỉ sửa BookCopy mà không đồng bộ `availableQuantity`, hệ thống sẽ công bố sai khả năng phục vụ. F13 cung cấp quy trình có trạng thái, khóa bản ghi, transaction và Audit Log để xử lý sự cố và kiểm kê an toàn.

## 2. DOMAIN KNOWLEDGE
- **Incident:** Báo cáo `damaged/lost` do F13 tạo có vòng đời `pending -> investigating -> resolved/rejected`; incident do F6 tạo khi nhận trả hỏng/mất đã ở `resolved`.
- **Immediate Suspension:** Báo cáo hợp lệ làm BookCopy ngừng lưu thông và giảm tồn khả dụng ngay; condition chỉ chốt khi resolve.
- **Repair Restore:** Chỉ bản sao `damaged` đã resolved mới có thể trở lại `good/available`; bản sao `lost` không được restore.
- **Inventory Removal:** Bản sao `damaged` không còn khả năng sửa hoặc `lost` đã kết luận được loại khỏi tổng kho bằng `removedFromInventory`, nhưng record BookCopy vẫn được giữ để tra cứu lịch sử.
- **Inventory Session:** Có thể tạo nhiều draft nhưng toàn hệ thống chỉ một phiên `counting/reviewing`. Snapshot chỉ hình thành khi bấm bắt đầu; vòng đời `draft -> counting -> reviewing -> completed`, hoặc `cancelled` với timestamp/người thực hiện riêng cho từng mốc.
- **Expected Inventory Scope:** Snapshot dự kiến chỉ gồm bản sao tại vị trí kiểm kê đang `good/available` và chưa bị loại khỏi kho. Đây là số cần quét, không phải toàn bộ bản sao được đăng ký tại vị trí.
- **Inventory Item:** Snapshot/scan của BookCopy, có kết quả `pending/matched/missing/misplaced/unexpected/excluded`; `expectedInSession` phân biệt bản sao thuộc snapshot với bản sao chỉ được phát hiện khi quét; `excluded` dùng khi bản sao dự kiến đã đổi trạng thái hoặc ra ngoài phạm vi trong lúc kiểm đếm.
- **Unexpected Scan:** Bản sao hỏng, đang mượn, đã báo mất, đã loại khỏi kho hoặc không khả dụng vẫn được quét và phân loại bằng `anomalyType`. Thủ thư phải xác minh đã đưa bản sao khỏi kệ/chuyển sang quy trình phù hợp trước khi hoàn tất phiên; bước này không tự động sửa trạng thái BookCopy.
- **Location Summary:** Tình trạng tổng thể của vị trí được hiển thị riêng với tiến độ phiên để tránh nhầm “tổng bản sao kệ quản lý” với “số bản sao dự kiến cần quét”.
- **Misplaced Resolution:** Phát hiện sai vị trí không tự sửa `BookCopy.location`. Thủ thư chọn xác nhận đã đưa về vị trí gốc hoặc chủ động đổi vị trí đăng ký sang nơi tìm thấy; cả hai đều phải kiểm tra snapshot chưa lỗi thời.

## 3. STAKEHOLDERS
- **Librarian:** Báo và xử lý sự cố, quét kiểm kê và giải quyết chênh lệch.
- **Borrowers:** Phụ thuộc vào tồn kho khả dụng chính xác.
- **Auditor/Administrator:** Cần truy vết mọi chuyển trạng thái và thay đổi tồn kho.

## 4. CONSTRAINTS (Ràng buộc cứng)
- Java 17, Servlet, JSP/JSTL/EL, JDBC DAO, PostgreSQL; không ORM/Spring.
- Chỉ `LIBRARIAN` truy cập các route F13 dưới `/librarian/book-management/*`.
- Không hard-delete BookCopy/Incident/InventorySession.
- Mọi thay đổi nhiều bảng và Audit Log dùng cùng Connection/transaction.
- Resolve `missing/misplaced` phải khóa InventoryItem và BookCopy, xác nhận bản sao còn tồn tại, `available/good`, chưa thanh lý và location hiện tại còn khớp snapshot. Resolve `unexpected` phải khóa InventoryItem và chỉ ghi nhận xác minh vật lý, không âm thầm đổi trạng thái nghiệp vụ của BookCopy.
- Schema chuẩn: `database/supabase/LMS_Schema_PostgreSQL.sql`.
- UI và thông báo 100% tiếng Việt.

## 5. ASSUMPTIONS
- Barcode scanner hoạt động như bàn phím.
- Thủ thư quét mọi bản sao vật lý nhìn thấy tại khu vực kiểm kê, kể cả khi nhãn/trạng thái hệ thống cho biết bản sao không nên có trên kệ.
- F4 tạo Book/BookCopy; F13 chỉ xử lý tình trạng vật lý và kiểm kê.
- F6 có thể phát hiện hỏng/mất khi trả sách và kết luận ngay tại quầy: tạo incident `resolved`, `lost` trừ `totalQuantity` và set `removedFromInventory`, `damaged` giữ `totalQuantity` để có thể sửa hoặc loại khỏi kho qua F13.
- Mỗi BookCopy chỉ có một incident `pending/investigating`.

## 6. OPEN QUESTIONS
- N/A
