# Danh sách các Điểm Sao lưu (Rollback Tags) hiện có

Dưới đây là danh sách các thẻ (tags) được tạo ra trong quá trình phát triển dự án. Nếu code gặp lỗi nghiêm trọng hoặc đi sai hướng, bạn có thể tra cứu file này và chọn một mốc thời gian an toàn để khôi phục (Rollback).

## Lịch sử Rollback Tags

### 0. `rollback/before-f8-views`
- **Thời gian tạo:** 2026-06-09
- **Mô tả:** Trạng thái hệ thống trước khi bắt tay vào thiết kế tầng View (JSP, JSTL, JS) cho F8 (Book Discovery).

### 0.1 `rollback/before-f8-controller-step3`
- **Thời gian tạo:** 2026-06-09
- **Mô tả:** Trạng thái hệ thống trước khi bắt tay vào code các Servlet Controller cho F8 (RecommendationServlet, BookSearchServlet, BookDetailServlet).

### 1. `rollback/before-f8-tests`
- **Thời gian tạo:** 2026-06-08
- **Mô tả:** Trạng thái hệ thống trước khi bắt tay vào tự động sinh các Unit Tests (DAO, Service, Controller) cho tính năng Khám phá Sách (F8).
- **Trạng thái Code:** Đã bao gồm toàn bộ thiết kế cơ sở dữ liệu (`LMS_Library_Management_System.sql`) và file mô tả `SPEC.md`, `PLAN.md` của F8, nhưng chưa có các file Test và Java Class mới.

### 2. `rollback/before-nav-linking-v2`
- **Thời gian tạo:** 2026-06-04
- **Mô tả:** Trạng thái trước khi thực hiện liên kết Navigation bar (phiên bản 2) / sau khi gộp nhánh `Quyet` vào `dev`.

### 3. `rollback/before-nav-linking-session`
- **Thời gian tạo:** 2026-06-04
- **Mô tả:** Trạng thái trước khi khôi phục thiết kế thanh sidebar `_sidebar.jsp` cho Book Management.

---

## Cách Khôi phục (Rollback)

Nếu bạn muốn quay lại một trong các mốc trên, hãy mở Terminal (Git Bash hoặc VS Code / NetBeans Terminal) và chạy lệnh sau:

**BƯỚC 1: Xóa bỏ mọi thay đổi hiện tại và đưa code về đúng mốc tag mong muốn:**
```bash
# Thay thế <tên-tag> bằng tên tag ở trên (ví dụ: rollback/before-f8-tests)
git reset --hard <tên-tag>
```

**BƯỚC 2: Cập nhật ép buộc (Force push) lên nhánh GitHub của bạn (Bắt buộc nếu bạn đã lỡ push code lỗi lên GitHub):**
```bash
# Cảnh báo: Lệnh này sẽ ghi đè lịch sử GitHub của nhánh Bao bằng code cũ từ Tag!
git push -f origin Bao
```

> **Lưu ý an toàn:** Lệnh `git reset --hard` sẽ xóa sạch vĩnh viễn toàn bộ code chưa được commit. Nếu bạn có code nào quan trọng vừa viết dở, hãy copy ra chỗ khác trước khi thực hiện Rollback!
