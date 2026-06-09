# TASKS.md — Task Breakdown F6

| ID | Task | Files liên quan | Est | Deps | DoD / Spec Refs |
|---|---|---|---|---|---|
| **T-F6-01** | Bổ sung/Cập nhật các hàm DAOs | `UserLockReasonDAO.java`, `PaymentDAO.java`, `BookCopyDAO.java`, `BorrowRecordDAO.java`, `ReservationDAO.java`, `FineDAO.java`, `BookDAO.java`v.v. | 2h | None | Hàm COUNT lock reasons, DELETE 'unpaid' lock reason. |
| **T-F6-02** | Service Layer (Check-out Logic) | `DeskCirculationService.java` | 3h | T-F6-01 | Transaction xử lý giao sách: Check nợ phạt (UserLockReason), tạo Reservation ảo nếu mượn trực tiếp, Insert BorrowRecord. |
| **T-F6-03** | Service Layer (Check-in Logic) | `DeskCirculationService.java` | 3h | T-F6-01 | Phân nhánh Condition: (1) Sách hỏng/mất: trừ `totalQuantity`, insert Fine, insert Lock. (2) Sách tốt: check next queue, allocate/return to inventory. |
| **T-F6-04** | Service Layer (Cash Payment) | `DeskCirculationService.java` | 2h | T-F6-01 | Transaction update Payment/Fine, xóa 'unpaid' lock, trigger Auto-Unlock dựa trên đếm COUNT. |
| **T-F6-05** | Controller (Servlets) | `CheckOutServlet.java`, `CheckInServlet.java`, `CashPaymentServlet.java` | 2h | T-F6-02,03,04 | Bắt Exception và trả Flash messages (thành công/lỗi) cho giao diện. |
| **T-F6-06** | View (Librarian Dashboard UI) | `desk-checkout.jsp`, `desk-checkin.jsp`, `desk-payment.jsp` | 3h | T-F6-05 | Xây dựng UI form nhập mã Sinh viên, quét mã Barcode, chọn Condition. Nút duyệt Payment. |
