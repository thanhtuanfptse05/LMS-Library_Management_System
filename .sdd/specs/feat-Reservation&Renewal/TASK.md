# TASKS.md — Task Breakdown F5

| ID | Task | Files liên quan | Est | Deps | DoD / Spec Refs |
|---|---|---|---|---|---|
| **T-F5-01** | Bổ sung hàm cho DAOs có sẵn | `ReservationDAO.java`, `BorrowRecordDAO.java` | 2h | None | Thêm hàm `insertOnlineReservation`, `cancelReservation`, `incrementExtension`, `countActiveBorrowsByUser`. Đảm bảo dùng syntax PostgreSQL. |
| **T-F5-02** | Tạo Config Fetcher | `SystemConfigDAO.java` | 1h | None | Đọc các limit (MAX_BORROW_LIMIT, RENEW_THRESHOLD_PERCENT...) cho mượn và gia hạn từ CSDL. |
| **T-F5-03** | Service Layer (Reservation) | `OnlineCirculationService.java` | 3h | T-F5-01,02 | Bao bọc Transaction chặt chẽ (`conn.setAutoCommit(false)`). Check limit. Dùng `SELECT FOR UPDATE` chia nhánh `queuePosition = 0` và `>0` (FR-F5-03, 04). Bắt lỗi User bị lock. |
| **T-F5-04** | Service Layer (Renewal) | `OnlineCirculationService.java` | 2h | T-F5-01,02 | Logic: Check %, check count, check queue. Execute update `extensionCount + 1` (FR-F5-05,06,07). |
| **T-F5-05** | Servlets (Controller) | `ReservationServlet.java`, `RenewalServlet.java`, `MyBorrowingsServlet.java` | 2h | T-F5-03,04 | Điều hướng HTTP bằng multiple paths (`/student/reserve`, `/lecturer/reserve`). Xử lý POST-Redirect-GET và map Flash messages. |
| **T-F5-06** | Views (JSP Portal) | `book-detail.jsp`, `my-borrowings.jsp` | 3h | T-F5-05 | Nút bấm "Đặt trước" ẩn nếu user đang mượn/đặt, submit via POST. Bảng "Sách đang mượn" và "Sách đặt trước" hiển thị rõ ràng nút Gia hạn / Hủy. |
