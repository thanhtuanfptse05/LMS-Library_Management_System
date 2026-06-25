# TASK.md — Phân rã công việc cho Quản lý Phạt & Thanh toán

| ID | Tên Task | Files liên quan | Est | Deps | Định nghĩa hoàn thành (DoD) |
|----|----------|-----------------|-----|------|-----------------------------|
| **T-ODP-01** | Bổ dung hàm truy vấn Overdue trong DAO | `src/java/dao/BorrowRecordDAO.java` | 1h | None | Thêm hàm `findOverdueRecords(Connection conn)` trả về `List<BorrowRecord>` có `status = 'borrowed'` và `endDate < NOW()`. Sử dụng `PreparedStatement`. |
| **T-ODP-02** | Tích hợp EmailService.enqueue() | `src/java/service/OverdueProcessor.java` | 1h | None | Gọi `EmailService.enqueue(new EmailJob("OVERDUE_NOTICE", ...))` trong logic quét quá hạn để gửi email thông báo trễ hạn và khóa tài khoản cho người dùng. |
| **T-ODP-03** | Xây dựng Service OverdueProcessor | `src/java/service/OverdueProcessor.java` | 3h | T-ODP-01, T-ODP-02 | Xử lý logic nghiệp vụ trong transaction riêng cho từng user: cập nhật BorrowRecord thành `'overdue'`, tính số ngày trễ, gọi `FineDAO.insertOverdueFine`, gọi `UserDAO` để chèn lý do nợ phạt vào `UserLockReason` và khóa tài khoản `"User"`, chèn AuditLog (`actionType='LOCK_USER'`, `userId=null`), và đẩy job gửi mail vào hàng đợi bất đồng bộ. |

| **T-ODP-04** | Đăng ký Executor Service trong Listener | `src/java/config/AppContextListener.java` | 1h | T-ODP-03 | Khởi tạo `ScheduledExecutorService` chạy ngầm. Tính toán delay để bắt đầu chạy vào lúc 00:00 AM hàng ngày. Đảm bảo shutdown executor service trong `contextDestroyed`. |
| **T-ODP-05** | Tạo TriggerOverdueServlet cho Admin | `src/java/controllers/TriggerOverdueServlet.java` | 1.5h | T-ODP-03 | Servlet nhận request POST tại `/admin/trigger-overdue`. Xác thực phân quyền ADMIN, gọi `OverdueProcessor.processOverdue(ServletContext)`, trả về JSON thống kê kết quả quét. |
| **T-ODP-06** | Thêm nút trigger thủ công trên Dashboard | `web/admin/dashboard-admin.jsp` | 1h | T-ODP-05 | Thêm nút bấm chạy quét quá hạn thủ công, sử dụng AJAX/Fetch gửi request tới servlet và hiển thị kết quả bằng Flash message hoặc Toast tiếng Việt. |

*Lưu ý:*
- Thực hiện commit nhỏ, commit sau khi hoàn thành mỗi hàm/file.
- Giữ nguyên luồng làm việc local trên nhánh `main`, không push lên remote vội.
