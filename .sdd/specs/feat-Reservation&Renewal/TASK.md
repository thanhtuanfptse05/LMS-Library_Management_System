# TASK.md — Phân rã công việc cho Quản lý Đặt trước và Gia hạn trực tuyến

## Giao diện & Nghiệp vụ chính (Hiện có)
| ID | Tên Task | Files liên quan | Est | Deps | Định nghĩa hoàn thành (DoD) |
|---|---|---|---|---|---|
| **T-F5-01** | Bổ sung hàm cho DAOs có sẵn | `ReservationDAO.java`, `BorrowRecordDAO.java` | 2h | None | Thêm các hàm `insertOnlineReservation`, `cancelReservation`, `findNextInQueue`, `decrementQueuePositions`, `incrementExtension`, `countActiveBorrowsByUser`. Đảm bảo dùng syntax PostgreSQL. |
| **T-F5-02** | Tạo Config Fetcher | `SystemConfigDAO.java` | 1h | None | Đọc các cấu hình giới hạn mượn/đặt từ CSDL. |
| **T-F5-03** | Service Layer (Reservation & Cancel) | `OnlineCirculationService.java` | 3h | T-F5-01,02 | Xử lý logic đặt trước và hủy đặt trước chủ động từ phía độc giả. |
| **T-F5-04** | Service Layer (Renewal) | `OnlineCirculationService.java` | 2h | T-F5-01,02 | Logic gia hạn sách trực tuyến. |
| **T-F5-05** | Servlets (Controller) | `ReservationServlet.java`, `RenewalServlet.java`, `CancelReservationServlet.java`, `MyBorrowingsServlet.java` | 2h | T-F5-03,04 | Tiếp nhận và điều phối HTTP requests. |
| **T-F5-06** | Views (JSP Portal) | `book-detail.jsp`, `my-borrowings.jsp` | 3h | T-F5-05 | Hiển thị giao diện Đặt trước/Gia hạn/Hủy đặt trước trên cổng độc giả. |

## Tiến trình ngầm Hủy hàng chờ đặt trước quá hạn (Reservation Expiration)
| ID | Tên Task | Files liên quan | Est | Deps | Định nghĩa hoàn thành (DoD) |
|---|---|---|---|---|---|
| **T-F5-07** | Refactor/Bổ sung hàm hủy quá hạn trong DAO | `src/java/dao/ReservationDAO.java` | 1.5h | None | Sửa đổi hoặc tạo mới cơ chế hủy đơn quá hạn: đôn hàng chờ kế tiếp (`queuePosition = 1`) lên `queuePosition = 0`, status='readypickup', giữ `bookCopyId=NULL`, thiết lập `endDate` theo `RESERVATION_HOLD_DAYS`; BookCopy vẫn `'available'`, chỉ chuyển suất khả dụng trừu tượng. |
| **T-F5-08** | Xây dựng Service ReservationExpirationProcessor | `src/java/service/ReservationExpirationProcessor.java` | 3h | T-F5-07 | Xử lý logic tiến trình quét ngầm: quét đơn `readypickup` quá hạn, thực thi transaction cô lập cho từng đơn quá hạn, đôn hàng chờ, ghi Audit Log (`actionType='CANCEL_EXPIRED_RESERVATION'`, `userId=null`), và gọi `EmailService` gửi email thông báo bất đồng bộ. |
| **T-F5-09** | Đăng ký lập lịch chạy trong Listener | `src/java/config/AppContextListener.java` | 1h | T-F5-08 | Cấu hình `ScheduledExecutorService` chạy định kỳ `ReservationExpirationProcessor` mỗi 1 giờ. Đảm bảo shutdown executor service khi ứng dụng tắt. |
| **T-F5-10** | Tạo Servlet Trigger cho Admin | `src/java/controllers/TriggerReservationExpirationServlet.java` | 1.5h | T-F5-08 | Nhận POST request tại `/admin/trigger-reservation-expiration`. Xác thực quyền ADMIN, gọi chạy tiến trình đồng bộ, trả về JSON thống kê kết quả quét. |
| **T-F5-11** | Thêm nút kích hoạt thủ công trên Admin Dashboard | `web/admin/dashboard-admin.jsp` | 1h | T-F5-10 | Thêm nút bấm chạy dọn dẹp đặt trước quá hạn thủ công, gửi request AJAX/Fetch và hiển thị Flash message báo kết quả thành công bằng tiếng Việt. |
