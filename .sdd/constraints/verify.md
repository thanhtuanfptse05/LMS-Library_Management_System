
# Prompt: Verify constraint compliance sau khi agent submit code

Review toàn bộ code bạn vừa viết và xác nhận tuân thủ tuyệt đối với các constraints của dự án LMS:

## Global Constraints check (Java/JDBC):
- [ ] Có tự ý import hay sử dụng framework cấm (Spring Boot, Spring MVC, Hibernate, JPA) không?
- [ ] Naming conventions có đúng chuẩn không (PascalCase cho Controller/Service/DAO/Model, kebab-case cho views .jsp)?
- [ ] 100% các câu lệnh SQL có dùng `PreparedStatement` thay cho `Statement` (chống SQL Injection) không?

## Business Constraints check (LMS Logic):
- [ ] Mật khẩu có được băm bằng `BCrypt` (tuyệt đối không dùng plaintext, MD5, SHA) không?
- [ ] Luồng mượn/đặt sách có đi qua bảng `Reservation` trước khi tạo `BorrowRecord` không?
- [ ] Cơ chế Soft-delete (cập nhật `status` thay vì xóa) có được áp dụng cho các bảng cốt lõi (`User`, `Books`, `BorrowRecord`, `Fine`, `Payment`) không?
- [ ] Các hành động thay đổi dữ liệu quan trọng (Create/Update/Delete) có được `INSERT` thêm một dòng vào bảng `AuditLogs` không?
- [ ] PII data (mật khẩu) có bị in ra Console hoặc log file không?

## Safety Constraints check (Security & Access):
- [ ] Có lệnh `DROP TABLE`, `TRUNCATE` hay lệnh `DELETE` cứng nào bị sinh ra không?
- [ ] Có hardcode các thông tin nhạy cảm (DB Password, SendGrid Key, VNPAY Secret) thẳng vào file `.java` hoặc `.jsp` không?
- [ ] Các URL yêu cầu phân quyền (`/admin/*`, `/librarian/*`, `/student/*`) có bị bypass (bỏ qua) `@WebFilter` không?

**Format yêu cầu:**
Liệt kê mỗi check với ✅ PASS hoặc ❌ FAIL kèm theo giải thích ngắn gọn (details). 
Nếu có bất kỳ ❌ FAIL nào: DỪNG LẠI, tự động sửa code ngay lập tức để đạt PASS, sau đó mới submit kết quả cuối cùng cho tôi.