# 📋 PROMPT TEMPLATE — Hướng Dẫn Cho Thành Viên Khác Tạo Script Demo

> **Cách dùng:** Copy toàn bộ mẫu prompt bên dưới, sửa 2 thông tin trong dấu `[ ]` (Tên/Mã định danh và Luồng nghiệp vụ), sau đó gửi cho AI Agent (Claude/Gemini/Cursor).

---

```markdown
Tôi muốn tạo Script Demo CSDL và Tài liệu Thuyết trình cho luồng nghiệp vụ của tôi. Hãy tuân thủ các quy định sau:

### 1. Thông tin cá nhân & Luồng nghiệp vụ
- **Họ tên & Mã định danh:** [Nhập tên và mã định danh, ví dụ: Nguyễn Việt Thái - Mã V]
- **Tên phân hệ / Luồng đảm nhận:** [Nhập tên luồng, ví dụ: F6 - Luồng xử lý mượn/trả sách tại quầy Check-in & Check-out]
- **Mô tả ngắn gọn luồng:** [Nhập các chức năng chính, ví dụ: Thủ thư giao sách check-out theo reservation, nhận trả sách check-in, xử lý quá hạn tính phạt tiền mặt, ghi nhận sự cố hỏng/mất sách]

### 2. Quy tắc Naming & Tài khoản
- Dùng convention tài khoản mã định danh tương ứng từ `database/supabase/seeds/02_users.sql` (Ví dụ: `adminV1@lms.com`, `librarianV1@lms.com`, `lecturerV1@lms.com`, `studentV1@lms.com`).
- Nếu cần thêm các tài khoản sinh viên phụ để demo các test case FAIL (như chạm quota, nợ phạt, tài khoản bị khóa), tự động tạo thêm dạng `studentV2@lms.com`, `studentV3@lms.com` trong script SQL với hash BCrypt chuẩn.

### 3. Yêu cầu Phân tích Code & CSDL (BẮT BUỘC DÙNG CODEGRAPH)
- **Dùng CodeGraph** (`codegraph_explore` / `codegraph explore`) để truy vết chính xác các Controller, Servlet, Service và DAO liên quan đến luồng nghiệp vụ của tôi.
- Kiểm tra các tham số cấu hình liên quan trong `SystemConfigurations` (như mức phạt, số ngày mượn tối đa, hệ số hỏng/mất sách...).
- Read file `SciptDemo/Script_Demo_Bao.sql` và các file seeds để **KHÔNG chọn trùng cuốn sách (ISBN / Barcode)** mà luồng F5 của Bảo đã dùng (Tránh xung đột dữ liệu khi chạy chung).

### 4. Yêu cầu Đầu ra (Output)
Hãy sinh ra 2 file lưu trực tiếp vào thư mục `SciptDemo/`:

1. **`SciptDemo/Script_Demo_[Tên].sql`**:
   - Viết thành khối `DO $$ DECLARE v_uid INT; BEGIN ... END $$;` duy nhất chuẩn PostgreSQL.
   - Giả định chạy trên CSDL vừa được reset bởi các seeds mặc định (`01_truncate_all.sql` -> `06_email_templates.sql`).
   - Thiết lập đầy đủ trạng thái dữ liệu (User, Reservation, BorrowRecord, Fine...) cho các test cases.

2. **`SciptDemo/Demo_[Tên]_[MãLuồng].md`**:
   - Danh sách tài khoản demo & vai trò.
   - Các tham số `SystemConfigurations` được chứng minh.
   - Chi tiết các Test Cases (bao gồm cả case **PASS** thành công và các case **FAIL** chứng minh ràng buộc/cấu hình).
   - Từng bước thao tác UI + SQL Verify kết quả sau từng test case.
   - Sơ đồ Mermaid timeline trình bày thuyết trình ~12 phút.
```
