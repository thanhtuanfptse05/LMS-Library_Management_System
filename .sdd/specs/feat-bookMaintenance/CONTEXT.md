# CONTEXT.md — Bảo trì sách và Kiểm kê (Feature 13)
# Phiên bản: 1.1.0 | Ngày: 2026-07-09

## 1. PROBLEM STATEMENT
Sách vật lý có thể hỏng, mất hoặc nằm sai vị trí. Nếu chỉ sửa BookCopy mà không đồng bộ `availableQuantity`, hệ thống sẽ công bố sai khả năng phục vụ. F13 cung cấp quy trình có trạng thái, khóa bản ghi, transaction và Audit Log để xử lý sự cố và kiểm kê an toàn.

## 2. DOMAIN KNOWLEDGE
- **Incident:** Báo cáo `damaged/lost` có vòng đời `pending -> investigating -> resolved/rejected`.
- **Immediate Suspension:** Báo cáo hợp lệ làm BookCopy ngừng lưu thông và giảm tồn khả dụng ngay; condition chỉ chốt khi resolve.
- **Repair Restore:** Chỉ bản sao `damaged` đã resolved mới có thể trở lại `good/available`.
- **Inventory Session:** Phiên theo một location với vòng đời `draft -> counting -> reviewing -> completed`, hoặc `cancelled`.
- **Inventory Item:** Snapshot/scan của BookCopy, có kết quả `pending/matched/missing/misplaced`; resolution được ghi bằng `resolvedAt`.

## 3. STAKEHOLDERS
- **Librarian:** Báo và xử lý sự cố, quét kiểm kê và giải quyết chênh lệch.
- **Borrowers:** Phụ thuộc vào tồn kho khả dụng chính xác.
- **Auditor/Administrator:** Cần truy vết mọi chuyển trạng thái và thay đổi tồn kho.

## 4. CONSTRAINTS (Ràng buộc cứng)
- Java 17, Servlet, JSP/JSTL/EL, JDBC DAO, PostgreSQL; không ORM/Spring.
- Chỉ `LIBRARIAN` truy cập các route F13 dưới `/librarian/book-management/*`.
- Không hard-delete BookCopy/Incident/InventorySession.
- Mọi thay đổi nhiều bảng và Audit Log dùng cùng Connection/transaction.
- Schema chuẩn: `database/supabase/LMS_Schema_PostgreSQL.sql`.
- UI và thông báo 100% tiếng Việt.

## 5. ASSUMPTIONS
- Barcode scanner hoạt động như bàn phím.
- F4 tạo Book/BookCopy; F13 chỉ xử lý tình trạng vật lý và kiểm kê.
- F6 có thể phát hiện hỏng/mất khi trả sách nhưng phải tuân theo cùng bất biến tồn kho.
- Mỗi BookCopy chỉ có một incident `pending/investigating`.

## 6. OPEN QUESTIONS
- N/A
