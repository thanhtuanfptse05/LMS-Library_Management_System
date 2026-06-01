# TASKS.md — Phân rã công việc feat-profileManagement
# Status: LOCKED | Last Updated: 2026-06-01 (v1.1.0)

## BẢNG PHÂN RÃ CÔNG VIỆC
| ID | Tên Task | Files cần tạo/sửa | Est | Deps | Definition of Done (DoD) |
| --- | --- | --- | --- | --- | --- |
| **T-01** | **[MODEL&DAO] Tạo MemberProfileDAO** | `src/model/MemberProfile.java`, `src/dao/MemberProfileDAO.java` | 2h | — | (1) Viết hàm `upsertProfile(MemberProfile)` xử lý cả Insert/Update (kiểm tra tồn tại trước rồi INSERT hoặc UPDATE). (2) Định nghĩa Model `MemberProfile`. (3) Viết hàm `findByUserId(int)`. (4) 100% PreparedStatement. |
| **T-02** | **[DAO] Bổ sung UserDAO** | `src/dao/UserDAO.java` (Modify) | 0.5h | — | (1) Bổ sung hàm `updatePasswordHash(int userId, String newHash)` để phục vụ đổi pass. |
| **T-03** | **[SERVICE] Tạo ProfileService** | `src/service/ProfileService.java` | 2h | T-01, T-02 | (1) Hàm `updateUserInfo` hợp lệ hóa dữ liệu và gọi DAO. (2) Hàm `changeUserPassword` check BCrypt pass cũ, check Regex `^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$` cho pass mới, hash và gọi DAO. (3) Cập nhật hàm `changeUserPassword` để gọi thêm hàm ghi log vào bảng `AuditLogs` với `actionType='CHANGE_PASSWORD'` sau khi đổi pass thành công. Ném Exception kèm message nếu lỗi. |
| **T-04** | **[CONTROLLER] ProfileServlet (GET)** | `src/controller/ProfileServlet.java` | 1h | T-03 | (1) Bắt `userId` từ Session. (2) Gọi Service fetch dữ liệu. (3) Đẩy object vào request. (4) Forward tới `profile.jsp`. |
| **T-05** | **[CONTROLLER] ProfileUpdateServlet (POST)**| `src/controller/ProfileUpdateServlet.java`| 2.5h | T-04 | (1) Đọc tham số `action`. (2) Phân nhánh gọi Service. (3) Xử lý Exception để đẩy `errorMessage` vào Session (Flash message). (4) Đẩy `successMessage` vào Session nếu OK. (5) Gọi `session.invalidate()` sau khi đổi pass thành công trước khi redirect về trang đăng nhập. (6) `sendRedirect` về `/profile` (hoặc `/login` nếu đổi pass). |
| **T-06** | **[VIEW] Giao diện profile.jsp** | `web/member/profile.jsp` | 1.5h | T-05 | (1) Khởi tạo 2 form riêng biệt. (2) Render giá trị hồ sơ hiện tại vào các field input. (3) Xử lý hiển thị Flash message từ Session thông qua JSTL `<c:if>` và EL. |
