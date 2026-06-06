# TASKS.md — Task Breakdown F5

| ID | Task | Files liên quan | Est | Deps | DoD / Spec Refs |
|---|---|---|---|---|---|
| **T-F5-01** | Tạo DAOs (Reservation, BorrowRecord) | `ReservationDAO.java`, `BorrowRecordDAO.java` | 2h | None | Các hàm cơ bản: `insert`, `getMaxQueue`, `hasPendingQueue`, `updateRenewal`. |
| **T-F5-02** | Implement Config Fetcher | `SystemConfigDAO.java` | 1h | None | Đọc các limit cho mượn và gia hạn từ CSDL. |
| **T-F5-03** | Service Layer (Reservation Logic) | `OnlineCirculationService.java` | 3h | T-F5-01,02 | Bao bọc Transaction chặt chẽ. Xử lý chia nhánh `queuePosition = 0` và `>0` (FR-F5-03, 04). Bắt lỗi User bị lock. |
| **T-F5-04** | Service Layer (Renewal Logic) | `OnlineCirculationService.java` | 2h | T-F5-01,02 | Code block logic: Check %, check count, check queue. Execute update `extensionCount + 1` (FR-F5-05,06,07). |
| **T-F5-05** | Servlets (Controller) | `ReservationServlet.java`, `RenewalServlet.java` | 2h | T-F5-03,04 | Điều hướng HTTP, gọi Service, map Exception thành Flash messages. |
| **T-F5-06** | Views (JSP Portal) | `book-detail.jsp`, `my-borrowings.jsp` | 3h | T-F5-05 | Nút bấm "Đặt trước" (ẩn nếu user locked). Nút "Gia hạn" có render validation messages nếu không đủ điều kiện. |
