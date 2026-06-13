# Báo cáo thay đổi (Change Report) - Nhánh `dev` vs `main`

Dưới đây là Báo cáo thay đổi cấu trúc theo từng tầng kiến trúc, được phân tích từ nội dung Git Diff (nhánh `dev` so với `main` ở commit `97ac88b`). Báo cáo tập trung vào việc làm nổi bật các file nhạy cảm dễ xảy ra xung đột (conflict) để team có thể cross-check.

### 🔴 Tầng DAO (Nguy cơ conflict: CAO)
1. **Tên File:** `src/java/dao/UserDAO.java`
   - **Hàm/Method sửa đổi:** `unlockAccount()` và các hàm CRUD user.
   - **What:** Cập nhật logic thao tác với dữ liệu người dùng.
   - **How:** Thêm/sửa các câu lệnh SQL PreparedStatement để thực thi `UPDATE`, xử lý logic reset `failedLoginAttempts`, và phục vụ Import/Export.
   - **Why:** Phục vụ tính năng Quản lý người dùng (CRUD, Lock/Unlock) của role Admin.

2. **Tên File:** `src/java/dao/NotificationDAO.java`
   - **Hàm/Method sửa đổi:** `(Tạo mới)`
   - **What:** Truy xuất và cập nhật dữ liệu bảng tin/thông báo.
   - **How:** Chứa các câu query `INSERT`, `SELECT`, `DELETE` cho bảng Notification và hàm `insertAuditLog()` để ghi log.
   - **Why:** Hỗ trợ tính năng hiển thị Bảng tin (Notice board) và tính năng lưu vết Audit Log (đáp ứng tiêu chuẩn ARCH-02).

3. **Tên File:** `src/java/dao/DocumentTempDAO.java`
   - **Hàm/Method sửa đổi:** `(Tạo mới)`
   - **What:** Truy xuất cấu hình các mẫu thư (Email Templates).
   - **How:** Lấy toàn bộ mẫu và cập nhật nội dung văn bản (bodyContent/subject) bằng SQL.
   - **Why:** Cho phép Manager sửa đổi linh hoạt nội dung các mẫu email.

### 🟠 Tầng Controller (Nguy cơ conflict: TRUNG BÌNH)
1. **Tên File:** `src/java/controllers/LoginServlet.java` & `src/java/controllers/GoogleLoginServlet.java`
   - **Hàm/Method sửa đổi:** `doGet()`, `doPost()`
   - **What:** Cập nhật cơ chế hiển thị lỗi và mở khóa tự động.
   - **How:** Thêm điều kiện kiểm tra `lockedUntil` và thuộc tính `lockReason` (bị khóa do nợ tiền "unpaid" hay do Admin), tự động gọi hàm unlock nếu đã qua thời hạn phạt.
   - **Why:** Giải quyết yêu cầu cấm đăng nhập với các tài khoản đang bị hạn chế quyền.

2. **Tên File:** `src/java/controllers/CreateUserServlet.java`, `UpdateUserServlet.java`, `ExportUserServlet.java`, `ImportUserServlet.java`, `UserListServlet.java`
   - **Hàm/Method sửa đổi:** `(Tạo mới)`
   - **What:** Khởi tạo các API endpoints phục vụ quản lý người dùng.
   - **How:** Nhận dữ liệu form/CSV, gọi `UserService` để xử lý và điều hướng kết quả.
   - **Why:** Hoàn thiện bộ công cụ CRUD người dùng cho Admin.

3. **Tên File:** `src/java/controllers/NotificationManagerServlet.java`, `DocumentTempManagerServlet.java`, `NewsServlet.java`
   - **Hàm/Method sửa đổi:** `(Tạo mới)`
   - **What:** Điều hướng luồng thông báo hệ thống và quản trị viên.
   - **How:** `NewsServlet` phục vụ chung cho Student/Lecturer xem tin, các servlet còn lại cho phép Manager thao tác thêm/xóa.
   - **Why:** Triển khai các tính năng Bảng tin của hệ thống.

4. **Tên File:** `src/java/filter/AuthFilter.java`
   - **Hàm/Method sửa đổi:** `doFilter()`
   - **What:** Bổ sung việc chặn bắt quyền truy cập (RBAC).
   - **How:** Bắt thêm các URL patterns mới thuộc `/admin/user/*`, `/manager/*` để check role hợp lệ.
   - **Why:** Tuân thủ quy định bảo mật (SEC-02).

### 🟡 Tầng Model / Service (Nguy cơ conflict: THẤP)
1. **Tên File:** `src/java/model/UserDTO.java`, `Notification.java`, `DocumentTemp.java`
   - **Hàm/Method sửa đổi:** `(Tạo mới hoặc thêm/sửa thuộc tính)`
   - **What:** Khởi tạo cấu trúc các thực thể dữ liệu mới hoặc bổ sung thuộc tính cho DTO.
   - **How:** Định nghĩa các class Java thuần với Getter/Setter.
   - **Why:** Để mapping dữ liệu từ database và trung chuyển giữa các layer.

2. **Tên File:** `src/java/service/UserService.java`, `AuthService.java`
   - **Hàm/Method sửa đổi:** Các hàm business tương ứng.
   - **What:** Gom nhóm logic nghiệp vụ phức tạp.
   - **How:** Xử lý validate file CSV (ở `importUsers()`), chuẩn hóa đầu vào.
   - **Why:** Tuân thủ MVC thuần, không để logic tính toán lọt vào Servlet hoặc DAO.

### 🟢 Tầng Views (Nguy cơ conflict: CAO)
1. **Tên File:** `web/admin/user-list.jsp` và thư mục `web/admin/fragments/` (`_user_create_modal.jsp`, `_user_edit_modal.jsp`,...)
   - **Hàm/Method sửa đổi:** `(Tạo mới)`
   - **What:** Xây dựng màn hình danh sách người dùng.
   - **How:** Tách cấu trúc file JSP ra nhiều fragment nhỏ để dùng chung `include` thay vì viết một file dài.
   - **Why:** Tuân thủ quy tắc chia nhỏ file (File Splitting & Modularity) trong dự án.

2. **Tên File:** `web/student/notifications.jsp`, `web/lecturer/notifications.jsp`
   - **Hàm/Method sửa đổi:** `(Thay thế nội dung HTML)`
   - **What:** Sửa giao diện đọc thông báo cá nhân thành Bảng tin chung.
   - **How:** Gỡ bỏ các nút UI (Đánh dấu đã đọc / Xóa thư) và thay bằng UI dạng List / Notice board.
   - **Why:** Thay đổi luồng nghiệp vụ UX/UI theo yêu cầu.

3. **Tên File:** `web/manager/manage-notifications.jsp`, `web/manager/manage-email-templates.jsp` (cùng các sidebar.jsp)
   - **Hàm/Method sửa đổi:** `(Tạo mới / Sửa)`
   - **What:** Thêm tính năng cấu hình nội dung cho Manager.
   - **How:** Bổ sung giao diện thẻ form nhập liệu, thêm menu điều hướng vào sidebar.
   - **Why:** Cung cấp công cụ trực quan hóa cho Quản lý thư viện.

### ⚪ Khác (Config / Utils / Tests)
1. **Tên File:** `src/java/util/CSVHelper.java`
   - **What:** Tiện ích thao tác file.
   - **How:** Parse nội dung Stream thành các List Entities.
   - **Why:** Phục vụ logic import file danh sách user.

2. **Tên File:** `nbproject/project.properties`, `nbproject/project.xml`, `nbproject/genfiles.properties`
   - **What:** File cấu hình tự động của IDE NetBeans.
   - **How:** Bổ sung thư viện mới (`jakarta.mail-2.0.1.jar`).
   - **Why:** Hỗ trợ tính năng gửi email xác thực và nhắc nhở.
   - **Chú ý:** *Cần cẩn thận khi merge vì file IDE sinh ra rất hay gây conflict (NetBeans).*

3. **Tên File:** Thư mục `test/service/` (`AuthServiceTest.java`, `UserServiceTest.java`)
   - **What:** File JUnit Tests.
   - **Why:** Đảm bảo code coverage cho các Business Logic theo Definition of Done.
