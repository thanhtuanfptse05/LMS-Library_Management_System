# TASKS.md — Task Breakdown F6

| ID | Task | Files liên quan | Est | Deps | DoD / Spec Refs |
|---|---|---|---|---|---|
| **T-F6-01** | Bổ sung/Cập nhật các hàm DAOs | `UserLockReasonDAO.java`, `PaymentDAO.java`, v.v. | 2h | None | Hàm COUNT lock reasons, DELETE 'unpaid' lock reason. |
| **T-F6-02** | Service Layer (Check-out Logic) | `DeskCirculationService.java` | 3h | T-F6-01 | Transaction xử lý giao sách: Check nợ phạt (UserLockReason/Fine), validate đơn Reservation bắt buộc sẵn có (BR-23), validate max quota (BR-21), Insert BorrowRecord, UPDATE Reservation fulfilled, UPDATE BookCopy borrowed. |
| **T-F6-03** | Service Layer (Check-in Logic) | `DeskCirculationService.java` | 3h | T-F6-01 | Phân nhánh Condition: (1) Sách hỏng/mất: ngừng lưu thông, tạo incident `resolved` tại quầy, ghi phạt/khóa nếu có, không luân chuyển hàng chờ. (2) Sách tốt: check next queue, allocate/return to inventory. |
| **T-F6-04** | Service Layer (Cash Payment) | `DeskCirculationService.java` | 2h | T-F6-01 | Transaction update Payment/Fine, xóa 'unpaid' lock, trigger Auto-Unlock dựa trên đếm COUNT (BR-25). |
| **T-F6-05** | Controller (Servlets) | `CheckOutServlet.java`, `CheckInServlet.java`, `CashPaymentServlet.java` | 2h | T-F6-02,03,04 | Bắt Exception và trả Flash messages (thành công/lỗi) cho giao diện. |
| **T-F6-06** | View (Librarian Dashboard UI) | `desk-dashboard.jsp`, `_desk-action-forms.jsp` | 3h | T-F6-05 | Xây dựng UI form nhập mã Sinh viên, quét mã Barcode, chọn Condition. Nút duyệt Payment. |
| **T-F6-07** | Tự động tạo BookCopyIncident resolved khi check-in hỏng/mất | `DeskCirculationService.java`, `BookCopyIncidentDAO.java` | 1.5h | T-F6-03 | F6 tạo incident `resolved`; `damaged` giữ `totalQuantity`, `lost` trừ `totalQuantity` và set `removedFromInventory`; F13 khôi phục hoặc loại khỏi kho với damaged sau kết luận. |
| **T-F6-08** | Controller & Service (Desk Reservation UC-51) | `DeskReservationServlet.java`, `DeskCirculationService.java` | 2h | T-F6-01 | Xử lý đăng ký đặt trước tại quầy thay độc giả: validate nợ phạt, kiểm tra hạn mức mượn/đặt, tạo bản ghi Reservation ở trạng thái readypickup. |
| **T-F6-09** | Cập nhật SQL Query Lọc sách đang mượn | `BorrowRecordDAO.java` | 1.5h | None | Sửa `searchBorrowingsPaginated` & `countSearchBorrowings`: khi `status='borrowed'` thì lấy `br.status IN ('borrowed', 'overdue') AND br.returnedAt IS NULL`; bổ sung xử lý lọc riêng `status='overdue'`. |
| **T-F6-10** | Cập nhật Giao diện & Badge Quản lý sách đang mượn | `borrowings-management.jsp`, `DeskBorrowingManagerServlet.java` | 1.5h | T-F6-09 | Cập nhật dropdown bộ lọc trạng thái "Đang mượn" (gồm cả quá hạn chưa trả) và "Quá hạn chưa trả" (`overdue`); phân biệt Badge màu sắc rõ ràng (Mượn trong hạn / Quá hạn chưa trả). |
