# TASKS.md — Task Breakdown F5

| ID | Task | Files liên quan | Est | Deps | DoD / Spec Refs |
|---|---|---|---|---|---|
| **T-F5-01** | Bổ sung hàm cho DAOs có sẵn | `ReservationDAO.java`, `BorrowRecordDAO.java` | 2h | None | Thêm hàm `insertOnlineReservation`, `cancelReservation`, `findNextInQueue`, `promoteQueuePosition`, `incrementExtension`, `countActiveBorrowsByUser`. Đảm bảo dùng syntax PostgreSQL. |
| **T-F5-02** | Tạo Config Fetcher | `SystemConfigDAO.java` | 1h | None | Đọc các limit (STUDENT_MAX_BORROW_LIMIT, LECTURER_MAX_BORROW_LIMIT, RENEW_THRESHOLD_PERCENT, MAX_EXTENSION_COUNT, RENEW_DURATION_DAYS). |
| **T-F5-03** | Service Layer (Reservation & Cancel) | `OnlineCirculationService.java` | 3h | T-F5-01,02 | Bọc Transaction. Check limit theo role. `SELECT FOR UPDATE` chia nhánh `queuePosition = 0` và `>0`. Xử lý Cancel Reservation đôn hàng đợi và gửi email. |
| **T-F5-04** | Service Layer (Renewal) | `OnlineCirculationService.java` | 2h | T-F5-01,02 | Logic: Check %, check count, check queue. Execute update `extensionCount + 1` (FR-F5-05,06,07). |
| **T-F5-05** | Servlets (Controller) | `ReservationServlet.java`, `RenewalServlet.java`, `CancelReservationServlet.java`, `MyBorrowingsServlet.java` | 2h | T-F5-03,04 | Điều hướng HTTP bằng multiple paths (`/student/...`, `/lecturer/...`). Xử lý POST-Redirect-GET và map Flash messages. |
| **T-F5-06** | Views (JSP Portal) | `book-detail.jsp`, `my-borrowings.jsp` | 3h | T-F5-05 | Nút bấm "Đặt trước". Bảng "Sách đang mượn" và "Sách đặt trước" hiển thị rõ ràng nút Gia hạn / Hủy. Submit qua form POST. |
