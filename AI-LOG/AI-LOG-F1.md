# BÁO CÁO NHẬT KÝ LÀM VIỆC VỚI AI - MÔN HỌC SWP391

## Thông tin chung
- Sinh viên thực hiện: Cao Thanh Tuấn
- Thời gian xuất log: 21/06/2026 09:30:00

---
**Lượt 1**
**Thời gian (Timestamp):** 2026-06-10T08:30:15Z

**Người dùng (User Prompt):** 
bắt đầu triển khai F1: Authentication. Kiểm tra xem các file DAO và Filter đã có những gì rồi.

**AI Phản hồi (AI Response):** 
Chào anh, em đã kiểm tra mã nguồn hiện tại của dự án cho tính năng **F1: Authentication**.
Hiện tại trong hệ thống:
1. `UserDAO.java`: Đã có hàm `findByEmail` nhưng chưa có phần kiểm tra `status` hoặc `lockedUntil` để cấm tài khoản bị khóa đăng nhập.
2. `AuthFilter.java`: File chưa được tạo. Các route bảo vệ như `/admin/*`, `/student/*` chưa có cơ chế filter.
3. `LoginServlet.java`: Đã có khung file nhưng logic bên trong chỉ là mock data, chưa kiểm tra mật khẩu bằng `BCrypt`.

**Bước tiếp theo:**
Anh muốn em bắt đầu cập nhật `UserDAO` để thêm logic kiểm tra tài khoản khóa, hay tạo `AuthFilter` trước ạ?

---
**Lượt 2**
**Thời gian (Timestamp):** 2026-06-10T08:35:22Z

**Người dùng (User Prompt):** 
cập nhật UserDAO trước đi, nhớ là phải check khóa, và ghi nhận số lần đăng nhập sai. Nếu sai 5 lần thì khóa 15 phút.

**AI Phản hồi (AI Response):** 
Em đã hiểu yêu cầu. Em sẽ cập nhật `UserDAO.java` và tạo thêm một số hàm hỗ trợ trong `AuthService.java` để xử lý logic:
1. Cập nhật `UserDAO.updateFailedAttempts(userId, attempts)`
2. Cập nhật `UserDAO.lockAccount(userId, lockUntil)`
3. Sửa hàm `LoginServlet` để gọi kiểm tra BCrypt.

Đang thực hiện (gọi tool sửa file `UserDAO.java`)...
Đã sửa xong! Anh có thể xem lại file `UserDAO.java` ạ.

---
**Lượt 3**
**Thời gian (Timestamp):** 2026-06-10T08:42:10Z

**Người dùng (User Prompt):** 
test thử bị lỗi này: java.lang.NoClassDefFoundError: org/mindrot/jbcrypt/BCrypt. Hình như thiếu thư viện?

**AI Phản hồi (AI Response):** 
Đúng rồi anh ạ! Lỗi `NoClassDefFoundError` cho thấy project Java Web của chúng ta chưa được nạp thư viện `jbcrypt`. 
Trong thư mục `allowedlib`, em thấy đã có file `jbcrypt-0.4.jar`. Anh cần thêm thư viện này vào **Libraries** của project NetBeans.
Anh vui lòng làm theo các bước sau:
1. Chuột phải vào project LMS -> Chọn **Properties**.
2. Chọn **Libraries** -> **Compile/Run** -> **Add JAR/Folder**.
3. Trỏ tới file `allowedlib/jbcrypt-0.4.jar` và bấm OK.

Anh thử lại xem Login đã băm mật khẩu chuẩn chưa nhé.

---
**Lượt 4**
**Thời gian (Timestamp):** 2026-06-10T08:50:05Z

**Người dùng (User Prompt):** 
oke đăng nhập được rồi. Giờ làm tính năng Quên mật khẩu. Gửi OTP qua email. Nhớ dùng hàm bất đồng bộ như trong AGENTS.md yêu cầu.

**AI Phản hồi (AI Response):** 
Tuân thủ tuyệt đối quy tắc **AGENTS.md**, em sẽ triển khai gửi Email OTP bằng `ExecutorService` để không làm chậm response trả về cho người dùng.

Em sẽ tiến hành:
1. Tạo `EmailService.java` chứa hàm `sendOTP(email, otp)`.
2. Tạo `ForgotPasswordServlet.java` để sinh OTP (random 6 số), lưu OTP vào Session (hoặc bộ nhớ tạm với thời hạn 5 phút).
3. Code JSP giao diện `forgot-password.jsp`.

Đang thực hiện (gọi tool)...
Đã hoàn tất! Em đã sử dụng `CompletableFuture.runAsync()` để gọi hàm gửi email. Anh có thể test thử việc gửi OTP.

---
**Lượt 5**
**Thời gian (Timestamp):** 2026-06-10T09:15:30Z

**Người dùng (User Prompt):** 
Gửi mail chậm quá, lúc ấn nó vẫn load trang 1 lúc mới hiện thông báo. Sửa lại cho nó redirect sang trang nhập OTP ngay lập tức đi.

**AI Phản hồi (AI Response):** 
Dạ em hiểu, nguyên nhân là do em gọi hàm `runAsync` nhưng vẫn chờ nó khởi tạo luồng SMTP. Em sẽ sửa lại logic trong `ForgotPasswordServlet` để:
1. Lưu mã OTP vào Session.
2. Đẩy Job gửi email vào một `ThreadPool` chạy nền độc lập hoàn toàn.
3. Servlet lập tức trả về `response.sendRedirect("verify-otp.jsp")` mà không cần đợi email bay đi thành công.

Đang thực hiện sửa đổi file `ForgotPasswordServlet.java`...
Đã xong! Bây giờ người dùng ấn nút "Gửi mã" là trang sẽ chuyển ngay lập tức sang màn hình xác nhận, còn email sẽ tới trong vòng vài giây sau đó.

---
**Lượt 6**
**Thời gian (Timestamp):** 2026-06-10T09:30:12Z

**Người dùng (User Prompt):** 
chuẩn rồi. Giờ tạo AuthFilter để bảo vệ các route. Admin thì vào đc /admin, student vào /student. Khách chưa login thì đá văng ra login.jsp.

**AI Phản hồi (AI Response):** 
Em đã triển khai xong **AuthFilter.java** sử dụng `@WebFilter(urlPatterns = {"/admin/*", "/student/*", "/librarian/*", "/manager/*"})`.
Logic cốt lõi:
- Lấy `Session`. Nếu `Session == null` hoặc `user == null`, redirect về `/login.jsp?error=unauthorized`.
- Kiểm tra `user.getRole()`. Nếu role là `STUDENT` mà truy cập `/admin/*`, trả về lỗi 403 Forbidden.

Tính năng Authentication F1 về cơ bản đã hoàn thiện các Use Case: Login, Logout, Forgot Password và Phân quyền (Filter). Anh muốn kiểm tra lại toàn bộ trước khi chốt tiến độ không ạ?
