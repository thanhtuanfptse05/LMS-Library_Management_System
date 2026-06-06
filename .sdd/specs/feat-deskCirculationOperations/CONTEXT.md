# CONTEXT.md — Quản lý Luân chuyển tại quầy (Feature 6)
# Phiên bản: 1.0.0 | Ngày: 2026-06-06

## 1. PROBLEM STATEMENT
Thủ thư cần một phân hệ tập trung để xử lý nhanh các giao dịch vật lý tại quầy: quét mã vạch giao sách, nhận sách trả, đánh giá tình trạng hao mòn và thu tiền phạt. Quá trình này phải đảm bảo không xảy ra sai lệch dữ liệu kho (inventory) và ngăn chặn triệt để việc độc giả đang nợ phạt hoặc mượn sách đã có người khác đặt trước.

## 2. DOMAIN KNOWLEDGE
- **Check-out (Giao sách):** Có 2 kịch bản: (1) Độc giả đã đặt trước (Reservation queue 0), (2) Độc giả mượn trực tiếp (tự động tạo Reservation queue 0 tại chỗ để chuẩn hóa luồng cấp phát).
- **Check-in (Nhận sách):** Nếu tình trạng tốt ('good'), đẩy người xếp hàng tiếp theo (queue 1) lên nhận sách. Nếu hỏng/mất ('damaged'/'lost'), loại khỏi tổng tài sản thư viện (`totalQuantity - 1`) và tính phạt đền bù.
- **Locking Mechanism:** Một tài khoản có thể bị khóa bởi nhiều lý do lưu trong bảng `UserLockReason`. Xóa nợ phạt chỉ gỡ lý do 'unpaid', KHÔNG tự động mở khóa nếu đang tồn tại lý do khác (như vi phạm an ninh).

## 3. STAKEHOLDERS
- **Librarian (Thủ thư):** Tác nhân duy nhất thao tác trên phân hệ này để phục vụ Độc giả.

## 4. CONSTRAINTS (Ràng buộc cứng)
- **Data Integrity:** Mọi thao tác làm thay đổi `BorrowRecord`, `BookCopy`, `Book` và `Reservation` BẮT BUỘC phải nằm trong một Database Transaction (Atomic).
- **Strict Fine Enforcement (BR-22):** Chặn mượn sách tuyệt đối dựa trên sự tồn tại của bản ghi `reason = 'unpaid'` trong bảng `UserLockReason`.
