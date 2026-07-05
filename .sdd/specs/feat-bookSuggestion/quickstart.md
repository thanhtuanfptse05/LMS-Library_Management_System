# Quickstart Validation Guide: Book Suggestions (F20)

## Overview
Tài liệu này cung cấp các kịch bản kiểm thử (validation scenarios) để đảm bảo tính năng Quản lý Đề xuất sách (F20) hoạt động đúng như thiết kế từ đầu đến cuối.

## Prerequisites
- Server Tomcat đã khởi động và kết nối thành công với database Supabase.
- Bảng `BookSuggestion`, `SuggestionVote` đã được tạo trong CSDL, và thiết lập cấu hình `MAX_SUGGESTION_PER_LECTURER = 10`.
- Tài khoản test: 
  - 1 tài khoản Giảng viên (Lecturer): `lecturer1@university.edu.vn` (có quyền tạo & vote đề xuất)
  - 1 tài khoản Giảng viên khác (Lecturer): `lecturer2@university.edu.vn` (để kiểm tra chức năng vote)
  - 1 tài khoản Thủ thư (Librarian): `librarian1@university.edu.vn` (có quyền đổi trạng thái)

## Validation Scenarios

### Scenario 1: Giảng viên tạo đề xuất mới
1. Đăng nhập bằng tài khoản `lecturer1`.
2. Truy cập trang Đề xuất sách dành cho giảng viên (`/lecturer/book-suggestions`).
3. Điền form tạo đề xuất (Tiêu đề: "Clean Architecture", Tác giả: "Robert C. Martin", Lý do: "Sách tham khảo môn Software Engineering").
4. Bấm **Gửi đề xuất**.
5. **Expected Outcome**: Thông báo thành công hiển thị. Đề xuất xuất hiện trong danh sách với Trạng thái: `pending` và Vote: `1`. CSDL cập nhật 1 bản ghi `BookSuggestion` và 1 bản ghi `SuggestionVote`.

### Scenario 2: Giảng viên 2 vote cho đề xuất đã có
1. Đăng nhập bằng tài khoản `lecturer2`.
2. Truy cập `/lecturer/book-suggestions`.
3. Tìm đề xuất "Clean Architecture" vừa tạo ở Scenario 1.
4. Bấm nút **Tôi cũng cần (+1)**.
5. **Expected Outcome**: Số lượt vote tăng lên `2`. Nút vote ẩn đi và đổi thành **Hủy vote**.

### Scenario 3: Giảng viên đạt giới hạn đề xuất
1. Đăng nhập bằng tài khoản `lecturer1`.
2. Thực hiện tạo liên tục 10 đề xuất mới để đạt giới hạn `MAX_SUGGESTION_PER_LECTURER`.
3. Cố gắng tạo thêm đề xuất thứ 11.
4. **Expected Outcome**: Hệ thống chặn và hiển thị thông báo "Đã đạt giới hạn đề xuất (đang chờ duyệt)".

### Scenario 4: Thủ thư xét duyệt đề xuất
1. Đăng nhập bằng tài khoản `librarian1`.
2. Truy cập màn hình quản lý đề xuất (`/librarian/book-suggestions`).
3. Tìm đề xuất "Clean Architecture", chọn cập nhật trạng thái sang `acknowledged` kèm ghi chú "Sẽ nhập trong quý tới".
4. **Expected Outcome**: Đề xuất chuyển trạng thái thành `acknowledged`. Trong bảng `AuditLogs` có ghi nhận thao tác cập nhật này (oldValue="pending", newValue="acknowledged").

### Scenario 5: Giảng viên bị chặn vote khi đề xuất không còn pending
1. Đăng nhập lại bằng tài khoản `lecturer1` (hoặc `lecturer2`).
2. Xem danh sách đề xuất.
3. **Expected Outcome**: Đối với đề xuất "Clean Architecture" đã chuyển sang `acknowledged`, nút "+1" và "Hủy vote" bị ẩn. Không thể tương tác hay sửa xóa.

### Scenario 6: Giảng viên tự xóa đề xuất (Hard Delete)
1. Đăng nhập bằng tài khoản `lecturer1`.
2. Tạo 1 đề xuất mới tinh (Vote: 1, Trạng thái: `pending`).
3. Nhấn nút **Xóa**.
4. **Expected Outcome**: Hệ thống thực hiện xóa cứng (Hard Delete). Đề xuất hoàn toàn biến mất khỏi danh sách và CSDL. (Bảng `BookSuggestion` và `SuggestionVote` đều bị xóa). Audit Log ghi nhận hành động xóa.
