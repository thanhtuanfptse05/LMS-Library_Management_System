# PLAN.md — Kế hoạch & Thiết kế Kiến trúc Quản lý Phạt & Thanh toán
# Trạng thái: APPROVED | Cập nhật: 2026-06-24

## 1. ARCHITECTURAL APPROACH (Hướng tiếp cận kiến trúc)
Hệ thống sử dụng mô hình MVC Monolith thuần kết hợp JDBC và Service/DAO Layer:
- **Tiến trình ngầm (Overdue Processor):** Triển khai lớp `OverdueProcessor.java` chạy định kỳ bằng `ScheduledExecutorService` (đăng ký qua `AppContextListener`). Khi hoạt động, nó sẽ quét các bản ghi quá hạn, thực thi transaction cô lập cho từng user và gọi gửi mail bất đồng bộ.
- **Thanh toán Online (VietQR / SePay Webhook):** Cung cấp API servlet nhận webhook để tự động đối soát giao dịch chuyển khoản qua mã hóa đơn `LMSPF<paymentId>`, cập nhật trạng thái phạt, gỡ cờ khóa và tự động mở khóa tài khoản độc giả.
- **Thanh toán Tiền mặt (Cash Payment):** Thủ thư duyệt đóng phạt trực tiếp tại quầy, cập nhật trạng thái và tự động mở khóa tài khoản độc giả qua `DeskCirculationService`.

---

## 2. DETAILED BLUEPRINT: OVERDUE PROCESSOR (Thiết kế chi tiết Quét quá hạn)

### 2.1. Luồng hoạt động hệ thống (System Flow)
```
[System Timer / Trigger] 
       │
       ▼ (1. Khởi chạy tiến trình hằng đêm lúc 00:00 AM)
[OverdueProcessor.processOverdue()]
       │
       ▼ (2. Truy vấn dữ liệu)
Lấy danh sách BorrowRecord trễ hạn (status='borrowed' & endDate < NOW)
       │
       ▼ (3. Vòng lặp cô lập từng độc giả quá hạn)
Mở Database Connection & Transaction riêng biệt
       │
       ├─► 3.1. Cập nhật BorrowRecord.status = 'overdue'
       ├─► 3.2. Tính tiền phạt: trễ_ngày * FINE_RATE_PER_DAY (mặc định 5000đ/ngày)
       ├─► 3.3. INSERT vào bảng Fine (status='unpaid', reason = "Trễ hạn X ngày")
       ├─► 3.4. INSERT lý do khóa 'unpaid' vào UserLockReason (nếu chưa có)
       ├─► 3.5. UPDATE "User".status = 'locked'
       ├─► 3.6. INSERT Audit Log hành động khóa (actorId=NULL -> "Hệ thống")
       │
       ▼ (4. Commit / Rollback giao dịch)
Thành công -> Commit Transaction -> Đẩy email báo phạt vào hàng đợi gửi thư bất đồng bộ (EmailService.enqueue(new EmailJob("OVERDUE_NOTICE", ...))).
Thất bại   -> Rollback Transaction của user đó -> Ghi log lỗi -> Tiếp tục vòng lặp các user khác.
```

### 2.2. Phân tích tác động CSDL (Database Impact)
- **BorrowRecord:** Cập nhật `status = 'overdue'` cho các bản ghi trễ hạn.
- **Fine:** Chèn dòng mới (trạng thái `'unpaid'`, lý do phạt rõ ràng bằng tiếng Việt).
- **UserLockReason:** Chèn dòng mới với `reason = 'unpaid'` nếu chưa tồn tại cờ khóa nợ phạt.
- **"User":** Cập nhật `status = 'locked'` cho độc giả bị phạt.
- **AuditLogs:** Chèn log ghi nhận hành động khóa tài khoản tự động (`userId = NULL` biểu thị hệ thống tự thực thi).

### 2.3. Quy tắc kiểm định mở khóa tự động (BR-25)
- Khi độc giả thanh toán (bằng tiền mặt tại quầy hoặc qua SePay Webhook), hệ thống thực hiện xóa cờ khóa `'unpaid'` trong bảng `UserLockReason`.
- Hệ thống đếm số lý do khóa còn lại của người dùng (`SELECT COUNT(*) FROM UserLockReason WHERE userId = ?`).
- Chỉ cập nhật `"User".status = 'active'` khi và chỉ khi `COUNT == 0`. Nếu vẫn còn lý do khác (ví dụ: `'adminban'`, `'securitybreach'`), tài khoản phải được giữ nguyên trạng thái `'locked'`.

---

## 3. COMPONENTS MAPPING (Sơ đồ thành phần tham gia)

| Tên lớp/File | Trách nhiệm trong hệ thống | Trạng thái |
|---|---|---|
| `dao.BorrowRecordDAO` | Bổ sung hàm `findOverdueRecords(Connection conn)` trả về danh sách `BorrowRecord` quá hạn. | Cần sửa |
| `dao.FineDAO` | Cung cấp các hàm tạo phạt (`insertOverdueFine`), truy vấn phạt `unpaid`/`paid` và cập nhật Fine. | Đã có |
| `dao.PaymentDAO` | Quản lý các phiếu thanh toán tiền phạt, cập nhật trạng thái thanh toán trực tuyến. | Đã có |
| `dao.UserDAO` & `UserLockReasonDAO` | Cung cấp API cập nhật trạng thái User, quản lý lý do khóa và ghi Audit Logs. | Đã có |
| `service.OverdueProcessor` | Lớp dịch vụ chạy ngầm chính, điều phối toàn bộ transaction tính phạt, khóa user và gửi email. | **Tạo mới** |
| `service.EmailService` | Sử dụng phương thức `enqueue(EmailJob)` gửi thông báo trễ hạn bất đồng bộ thông qua mẫu `OVERDUE_NOTICE`. | Đã có |
| `config.AppContextListener` | Khởi tạo/hủy `ScheduledExecutorService` chạy `OverdueProcessor` định kỳ 00:00 AM hàng ngày theo thiết kế vòng đời chung tại [F-AsyncEmail SPEC Section 9](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/.sdd/specs/feat-asyncEmailSender/SPEC.md#9-thiet-ke-lifecycle-va-thu-tu-khoi-tao-appcontextlistener-lifecycle). | Cần sửa |
| `controllers.TriggerOverdueServlet` | Servlet `/admin/trigger-overdue` (POST) cho phép Admin chạy quét thủ công qua dashboard. | **Tạo mới** |
| `controllers.CashPaymentServlet` | Tiếp nhận và xử lý luồng duyệt thanh toán tiền mặt tại quầy bởi Thủ thư. | Đã có |
| `controllers.SePayWebhookServlet` | Tiếp nhận webhook SePay, tự động đối soát giao dịch, cập nhật Fine và mở khóa tài khoản. | Đã có |
| `web/admin/dashboard-admin.jsp` | Thêm nút kích hoạt tiến trình quét thủ công dành cho quản trị viên. | Cần sửa |

---

## 4. DEPENDENCIES & RISKS (Phụ thuộc & Rủi ro)
- **Rò rỉ kết nối (Connection Leak):** Vì tiến trình chạy độc lập với request-response, bắt buộc phải đóng `Connection` và `PreparedStatement` trong khối `finally`.
- **Khóa chết dữ liệu (Deadlock):** Xảy ra khi tiến trình quét ngầm khóa tài khoản đồng thời với lúc thủ thư mượn/trả sách. Giải quyết bằng cách cô lập giao dịch theo từng user (mỗi user một Transaction độc lập).
- **Gửi Email thất bại:** SMTP Server có thể bị quá tải hoặc chặn gửi. Tiến trình phải đẩy việc gửi mail vào hàng đợi bất đồng bộ (`EmailService.enqueue`) để được Worker gửi ngầm, không làm nghẽn tiến trình DB chính.
