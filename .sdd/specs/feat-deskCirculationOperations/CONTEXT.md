# CONTEXT.md — Quản lý Luân chuyển tại quầy (Feature 6)
# Phiên bản: 1.1.0 | Ngày: 2026-07-27 (Chuẩn hóa luồng Check-out yêu cầu BẮT BUỘC Reservation)

## 1. PROBLEM STATEMENT
Thủ thư cần một phân hệ tập trung để xử lý nhanh các giao dịch vật lý tại quầy: quét mã vạch giao sách, nhận sách trả, đăng ký đặt trước tại quầy, đánh giá tình trạng hao mòn và thu tiền phạt. Quá trình này phải đảm bảo không xảy ra sai lệch dữ liệu kho (inventory) và ngăn chặn triệt để việc độc giả đang nợ phạt hoặc mượn sách đã có người khác đặt trước.

## 2. DOMAIN KNOWLEDGE
- **Check-out (Giao sách):** Yêu cầu BẮT BUỘC độc giả phải có đơn đặt trước sách (Reservation ở trạng thái `readypickup`). Nếu độc giả mượn trực tiếp tại quầy chưa có đơn đặt trước, Thủ thư (hoặc độc giả) phải thực hiện Đăng ký đặt trước tại quầy (UC-51 / `DeskReservationServlet`) cho độc giả trước khi thực hiện giao sách.
- **Check-in (Nhận sách):** Nếu tình trạng tốt (`good`), đẩy người xếp hàng tiếp theo (queue 1) lên nhận sách. Nếu hỏng/mất (`damaged`/`lost`), F6 kết luận ngay tại quầy: ngừng lưu thông bản sao, tạo `BookCopyIncident(status='resolved')`, tính phạt/khóa theo chính sách lưu thông; `lost` trừ `totalQuantity` và set `removedFromInventory`, `damaged` giữ `totalQuantity` để có thể sửa, khôi phục hoặc loại khỏi kho qua F13.
- **Locking Mechanism:** Một tài khoản có thể bị khóa bởi nhiều lý do lưu trong bảng `UserLockReason`. Xóa nợ phạt chỉ gỡ lý do 'unpaid', KHÔNG tự động mở khóa nếu đang tồn tại lý do khác (như vi phạm an ninh).

## 3. STAKEHOLDERS
- **Librarian (Thủ thư):** Tác nhân duy nhất thao tác trên phân hệ này để phục vụ Độc giả.

## 4. CONSTRAINTS (Ràng buộc cứng)
- **Data Integrity:** Mọi thao tác làm thay đổi `BorrowRecord`, `BookCopy`, `Book` và `Reservation` BẮT BUỘC phải nằm trong một Database Transaction (Atomic).
- **Strict Fine Enforcement (BR-22):** Chặn mượn sách tuyệt đối dựa trên sự tồn tại của bản ghi `reason = 'unpaid'` trong bảng `UserLockReason` hoặc khoản phạt chưa trả trong `Fine`.
- **Pre-reservation Enforced Policy (BR-23):** Bắt buộc phải có Reservation khả dụng trước khi thực hiện Check-out giao sách.
