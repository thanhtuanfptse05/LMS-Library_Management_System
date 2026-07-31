# CONTEXT.md — Fine & Payment Management (Quản lý Phạt & Thanh toán)
# Phiên bản: 1.0.0 | Ngày: 2026-06-24

## 1. PROBLEM STATEMENT (Bài toán nghiệp vụ)
- Độc giả trả sách trễ hạn, làm hỏng hoặc mất sách gây thiệt hại trực tiếp đến tài nguyên và tài chính của thư viện. 
- Hệ thống cần một phân hệ quản lý phạt minh bạch để:
  1. Tự động phát hiện trễ hạn và tính tiền phạt thông qua tiến trình ngầm hàng đêm.
  2. Cho phép độc giả tự tra cứu lịch sử phạt và nợ phạt trên Dashboard.
  3. Cung cấp phương thức thanh toán trực tuyến VietQR tích hợp SePay để tự động gỡ cờ khóa tài khoản khi đóng phạt thành công.
  4. Hỗ trợ Thủ thư thu tiền mặt trực tiếp tại quầy và xác nhận đóng phạt thủ công.

## 2. DOMAIN KNOWLEDGE (Kiến thức nghiệp vụ)
- **Fine (Khoản phạt):** Mỗi khoản phạt gắn liền với một bản ghi mượn (`BorrowRecord`) cụ thể của độc giả. Trạng thái: `unpaid` (chưa thanh toán) và `paid` (đã thanh toán).
- **Payment (Giao dịch thanh toán):** Mỗi lần độc giả quét mã VietQR để đóng phạt, hệ thống tạo bản ghi `Payment` liên kết với khoản phạt (`Fine`). Trạng thái: `pending` (đang chờ) và `completed` (thành công).
- **SePay Webhook:** Cổng thanh toán chuyển khoản ngân hàng tự động. Khi có biến động số dư, SePay gửi thông tin giao dịch qua webhook POST. Hệ thống trích xuất mã hóa đơn `LMSPF<paymentId>` trong nội dung để đối soát và tự động xử lý.
- **User Locking System:** Tài khoản nợ phạt tự động bị chèn lý do `'unpaid'` vào bảng `UserLockReason` và khóa trạng thái đăng nhập. Việc mở khóa chỉ được kích hoạt khi tổng số lý do khóa trong bảng này bằng 0 (BR-25).

## 3. STAKEHOLDERS (Các bên liên quan)
- **Độc giả (Student/Lecturer):** Đối tượng nộp phạt, tự tra cứu và thanh toán online.
- **Thủ thư (Librarian):** Tra cứu nợ phạt và xác nhận thanh toán bằng tiền mặt tại quầy.
- **SysAdmin & Admin:** Quản trị cấu hình mức phạt (`FINE_RATE_PER_DAY`) và giám sát audit trail.

## 4. CONSTRAINTS (Ràng buộc kỹ thuật)
- **Tech Stack:** Java Servlet, JDBC, JSP. Không dùng ORM hay Spring Framework.
- **Transaction:** Mọi giao dịch duyệt thanh toán (online/tiền mặt) phải đảm bảo tính nguyên tử (Atomic transaction) trên connection JDBC.
- **Security:** Xác thực Webhook của SePay bằng API Key qua header `Authorization`.

## 5. ASSUMPTIONS (Giả định thiết kế)
- Cấu hình ngân hàng (Số tài khoản, Tên chủ tài khoản, Mã ngân hàng) trong `SystemConfigurations` đã được thiết lập chính xác để sinh QR VietQR.
- Độc giả chuyển khoản ghi đúng nội dung chuyển khoản tự sinh (`LMSPF<paymentId>`). Nếu sai cú pháp, giao dịch sẽ được Thủ thư đối soát thủ công (out of scope).
- Tiến trình ngầm Overdue Processor được kích hoạt đều đặn hàng đêm thông qua `ScheduledExecutorService` của Java Web Container.

## 6. PHỤ THUỘC HỆ THỐNG CHÉO (Cross-cutting Dependencies)
- **Hạ tầng gửi Email:** Việc gửi email báo nợ phạt và khóa tài khoản phụ thuộc trực tiếp vào phân hệ hạ tầng chung `feat-asyncEmailSender` (`F-AsyncEmail`). Thay vì trực tiếp kết nối SMTP hay chạy thread pool riêng, `OverdueProcessor` sẽ tạo `EmailJob` với template `OVERDUE_NOTICE` và đẩy vào hàng đợi thông qua `EmailService.enqueue(job)`.

