# PLAN.md — Kế hoạch thực thi feat-profileManagement
# Status: LOCKED

## 1. ARCHITECTURAL APPROACH
Hệ thống tuân thủ mô hình Servlet MVC Pattern (Model-View-Controller) kết hợp Repository Pattern (DAO).
Phân tách Controller thành 2 Servlet độc lập nhằm tuân thủ nguyên tắc Single Responsibility:
1. `ProfileServlet`: Chỉ xử lý phương thức GET để truy xuất và hiển thị View.
2. `ProfileUpdateServlet`: Chỉ xử lý phương thức POST để nhận dữ liệu biểu mẫu, thực thi nghiệp vụ và điều hướng.

## 2. COMPONENTS
| Component | Trách nhiệm | Interface/Class |
| --- | --- | --- |
| `ProfileServlet` | Xử lý GET. Ràng buộc Authentication. Fetch data và render view. | `src/controller/ProfileServlet.java` |
| `ProfileUpdateServlet`| Xử lý POST. Định tuyến logic theo tham số `action` (`updateInfo` hoặc `changePw`). | `src/controller/ProfileUpdateServlet.java`|
| `ProfileService` | Chứa Business Logic: Validate Regex, BCrypt hashing và verify. | `src/service/ProfileService.java` |
| `MemberProfileDAO` | Truy vấn và cập nhật dữ liệu cá nhân tại bảng `MemberProfile`. | `src/dao/MemberProfileDAO.java` |
| `UserDAO` | Tái sử dụng để cập nhật `passwordHash` (Đã có từ feat-authentication). | `src/dao/UserDAO.java` |
| `profile.jsp` | UI chứa 2 biểu mẫu độc lập (Cập nhật thông tin & Đổi mật khẩu). | `web/member/profile.jsp` |

## 3. DATA FLOW
* **Xem hồ sơ:** Request `GET /profile` -> `ProfileServlet` -> `MemberProfileDAO` + `UserDAO` -> Gán vào `requestScope` -> Render `profile.jsp`.
* **Cập nhật hồ sơ:** Request `POST /profile-update?action=updateInfo` -> `ProfileUpdateServlet` -> `ProfileService.updateInfo()` -> `MemberProfileDAO.update()` -> Redirect `GET /profile` kèm success message.
* **Đổi mật khẩu:** Request `POST /profile-update?action=changePw` -> `ProfileUpdateServlet` -> `ProfileService.changePassword()` (Verify BCrypt -> Regex Match -> Hash BCrypt) -> `UserDAO.updatePasswordHash()` -> Redirect `GET /profile` kèm success message.

## 4. DEPENDENCIES
* Yêu cầu `AuthFilter` hoạt động đúng để bảo vệ endpoint `/profile` và cung cấp `userId` trong `HttpSession`.
* Phụ thuộc thư viện `jbcrypt-0.4.jar` cho mã hóa mật khẩu.
