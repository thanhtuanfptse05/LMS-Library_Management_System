### .sdd/constraints/safety.md

### Owner: @tech-lead | Project: Library Management System (LMS)

#### DATA SAFETY (Dữ liệu)

- **KHÔNG ĐƯỢC:** Sinh ra các script `DROP TABLE` hoặc `TRUNCATE TABLE` mà không hỏi human.
- **KHÔNG ĐƯỢC:** Update database (đặc biệt các bảng cấu hình `SystemConfigurations`) bằng lệnh SQL tĩnh (hardcode) thay vì dùng logic UI/Service.
- **KHÔNG ĐƯỢC:** Thực thi lệnh DELETE trực tiếp bằng JDBC Statement.

#### CODE SAFETY (Mã nguồn)

- **KHÔNG ĐƯỢC:** Bỏ qua (bypass) `AuthFilter` hoặc `RoleFilter` với lý do "code cho nhanh để test".
- **KHÔNG ĐƯỢC:** Hardcode API Keys (VNPAY Secret, SendGrid Key, OpenAI Key, DB Password) vào các file `.java` hoặc `.jsp`. Mọi secrets phải được lấy từ `.env` hoặc Context Listener.
- **KHÔNG ĐƯỢC:** Dùng `System.out.println()` để in dữ liệu nhạy cảm của người dùng khi đang test luồng đăng nhập.

#### KHI KHÔNG CHẮC CHẮN (When in doubt)

- Nếu logic mượn/trả có vẻ mâu thuẫn với thiết kế CSDL -> DỪNG LẠI và hỏi Human (Developer).
- Tốt nhất là hỏi để làm chậm lại, còn hơn tự assume (giả định) và code sai Business Rule.
