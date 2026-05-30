# .sdd/constraints/safety.md
# Phiên bản: 1.1.0 | Owner: @tech-lead | Trạng thái: LOCKED

Đây là "tuyến phòng thủ cuối cùng" (Last Line of Defense) của dự án LMS. AI Agent và mọi Developer bắt buộc phải tuân thủ nghiêm ngặt để đảm bảo an toàn tuyệt đối cho mã nguồn và dữ liệu thực tế.

---

## 1. AN TOÀN DỮ LIỆU (DATA SAFETY)

### Tuyệt đối CẤM (Block - Cần Human xác nhận rõ ràng):
* **KHÔNG ĐƯỢC PHÉP:** Sử dụng lệnh SQL `DELETE FROM` để xóa dữ liệu giao dịch cốt lõi (tài khoản, sách, mượn trả, phạt, thanh toán). Bắt buộc chỉ dùng Soft-delete bằng cách cập nhật cột `status`.
* **KHÔNG ĐƯỢC PHÉP:** Thực hiện các câu lệnh thay đổi lược đồ database phá hủy dữ liệu như `DROP TABLE`, `TRUNCATE TABLE` trực tiếp trong môi trường đang chạy thử nghiệm hoặc production.
* **KHÔNG ĐƯỢC PHÉP:** Sử dụng lệnh `UPDATE` hoặc `DELETE` SQL mà thiếu mệnh đề `WHERE` (Đây là lỗi thảm họa làm phá hủy toàn bộ dữ liệu).
* **KHÔNG ĐƯỢC PHÉP:** Tự ý thay đổi kiểu dữ liệu (data type) của các cột đã có sẵn dữ liệu thực tế (dẫn đến rủi ro mất mát dữ liệu hoặc lỗi ép kiểu trong Java).

### Bắt buộc PHẢI LÀM:
* **Tạo Checkpoint:** Tạo git checkpoint hoặc backup schema SQL trước khi thực hiện bất kỳ lệnh thay đổi cấu trúc bảng nào.
* **Reminder kiểm tra:** Nhắc nhở backup trước khi chạy script SQL: *"Bạn đã kiểm tra và backup dữ liệu SQL Server chưa?"*

---

## 2. AN TOÀN MÃ NGUỒN (CODE SAFETY)

### Tuyệt đối CẤM tự ý:
* **Thêm Dependency:** Thêm các thư viện bên ngoài (`.jar` hoặc trong `pom.xml`) mà chưa có sự đồng ý bằng văn bản (hoặc gõ APPROVE) của Human.
* **Bypass WebFilter:** Tự ý bypass hoặc viết mã ngoại lệ bỏ qua lớp lọc bảo mật `@WebFilter` cho các đường dẫn nhạy cảm `/admin/*`, `/librarian/*`, `/manager/*` "để test cho nhanh".
* **Thay đổi CI/CD:** Sửa đổi các file workflow tự động trong `.github/workflows/` vì đây là vùng nhạy cảm liên quan đến cấu hình kiểm tra chất lượng bảo mật.
* **Commit trực tiếp:** Commit trực tiếp mã nguồn vào nhánh `main` hoặc `production`. Bắt buộc phải tạo branch mới `feat/*`, `fix/*` và tạo Pull Request.

---

## 3. AN TOÀN MÔI TRƯỜNG CHẠY THỰC TẾ (PRODUCTION SAFETY)
* **Không Hardcode thông tin nhạy cảm:** Không lưu trữ mật khẩu DB, API keys, cổng thanh toán VNPAY trực tiếp trong code Java hoặc file JSP. Bắt buộc dùng biến môi trường hoặc bảng cấu hình bảo mật `SystemConfigurations` có nhóm bảo mật.
* **Không ghi log nhạy cảm:** Không in ra file logs thông tin mật khẩu của người dùng, số thẻ tín dụng hoặc các thông tin cá nhân PII chưa được che mặt (masking).
  * *Ví dụ che mặt PII:* Email ghi logs dưới dạng `tu***@fpt.edu.vn`, số điện thoại ghi logs dưới dạng `091***789`.

---

## 4. NGUYÊN TẮC KHI KHÔNG CHẮC CHẮN (WHEN IN DOUBT)
* Khi gặp bất cứ xung đột nào giữa hiệu năng (Performance) và bảo mật (Security), **luôn luôn ưu tiên bảo mật hàng đầu**.
* Khi không chắc chắn về cách xử lý nghiệp vụ của thư viện trường học (ví dụ: cách tính phạt khi đền bù): **Dừng lại và báo cáo cho Human**, không tự giả định hoặc assume bừa bãi.
* *"Báo cáo chậm mà đúng còn hơn làm nhanh mà sai"* là nguyên tắc hành xử tối cao của AI Agent trong dự án này.
