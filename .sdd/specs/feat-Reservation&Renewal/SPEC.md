# Feature Specification: Đặt trước và Gia hạn trực tuyến (Online Reservation & Renewal)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cho phép Độc giả (Sinh viên/Giảng viên) đặt trước sách trực tuyến khi sách đã hết hoặc gia hạn thời gian mượn đối với các cuốn sách đang mượn trực tiếp trên tài khoản cá nhân.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Độc giả (Student/Lecturer):** Đặt trước sách, hủy đặt trước, gia hạn mượn sách trực tuyến.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-16 (Reserve Book Online):** Actor: User (Student/Lecturer) | (Đặt trước trực tuyến): Người dùng khởi tạo yêu cầu đặt sách. Nếu sách còn khả dụng, hệ thống cấp phát ngay (vào vị trí 0). Nếu sách hết, người dùng được xếp vào hàng đợi chờ (vị trí > 0).
* **UC-17 (Renew Book Online):** Actor: User (Student/Lecturer) | (Gia hạn trực tuyến): Người dùng tự động kéo dài thời gian mượn của một cuốn sách đang giữ, với điều kiện không có ai khác đang xếp hàng chờ cuốn sách đó.
* **UC-43 (Auto-cancel Expired Reservations):** Actor: System, SysAdmin | (Hủy đặt trước quá hạn): Hệ thống chạy định kỳ (hoặc SysAdmin kích hoạt thủ công) để quét các đơn đặt trước sẵn sàng nhận quá hạn, hủy bỏ chúng, đôn hàng chờ cho người tiếp theo hoặc trả sách về kho.
* **UC-49 (View Full Borrow/Return History):** Actor: Student, Lecturer | (Xem lịch sử mượn trả đầy đủ): Độc giả xem danh sách tất cả các bản ghi mượn sách trong lịch sử (đang mượn và đã trả) của bản thân.
* **UC-50 (Cancel Online Reservation):** Actor: Student, Lecturer | (Hủy đặt trước trực tuyến): Độc giả chủ động hủy yêu cầu đặt trước sách khi đang trong hàng đợi hoặc trạng thái sẵn sàng nhận sách.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-16 (Reserve Book Online):** Actor: User (Student/Lecturer) | (Đặt trước trực tuyến): Người dùng khởi tạo yêu cầu đặt sách. Nếu sách còn khả dụng, hệ thống cấp phát ngay (vào vị trí 0). Nếu sách hết, người dùng được xếp vào hàng đợi chờ (vị trí > 0).
* **UC-17 (Renew Book Online):** Actor: User (Student/Lecturer) | (Gia hạn trực tuyến): Người dùng tự động kéo dài thời gian mượn của một cuốn sách đang giữ, với điều kiện không có ai khác đang xếp hàng chờ cuốn sách đó.
* **UC-43 (Auto-cancel Expired Reservations):** Actor: System, SysAdmin | (Hủy đặt trước quá hạn): Hệ thống chạy định kỳ (hoặc SysAdmin kích hoạt thủ công) để quét các đơn đặt trước sẵn sàng nhận quá hạn, hủy bỏ chúng, đôn hàng chờ cho người tiếp theo hoặc trả sách về kho.
* **UC-49 (View Full Borrow/Return History):** Actor: Student, Lecturer | (Xem lịch sử mượn trả đầy đủ): Độc giả xem danh sách tất cả các bản ghi mượn sách trong lịch sử (đang mượn và đã trả) của bản thân.
* **UC-50 (Cancel Online Reservation):** Actor: Student, Lecturer | (Hủy đặt trước trực tuyến): Độc giả chủ động hủy yêu cầu đặt trước sách khi đang trong hàng đợi hoặc trạng thái sẵn sàng nhận sách.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-16 (Reserve Book Online):** Actor: User (Student/Lecturer) | (Đặt trước trực tuyến): Người dùng khởi tạo yêu cầu đặt sách. Nếu sách còn khả dụng, hệ thống cấp phát ngay (vào vị trí 0). Nếu sách hết, người dùng được xếp vào hàng đợi chờ (vị trí > 0).
* **UC-17 (Renew Book Online):** Actor: User (Student/Lecturer) | (Gia hạn trực tuyến): Người dùng tự động kéo dài thời gian mượn của một cuốn sách đang giữ, với điều kiện không có ai khác đang xếp hàng chờ cuốn sách đó.
* **UC-43 (Auto-cancel Expired Reservations):** Actor: System, SysAdmin | (Hủy đặt trước quá hạn): Hệ thống chạy định kỳ (hoặc SysAdmin kích hoạt thủ công) để quét các đơn đặt trước sẵn sàng nhận quá hạn, hủy bỏ chúng, đôn hàng chờ cho người tiếp theo hoặc trả sách về kho.
* **UC-49 (View Full Borrow/Return History):** Actor: Student, Lecturer | (Xem lịch sử mượn trả đầy đủ): Độc giả xem danh sách tất cả các bản ghi mượn sách trong lịch sử (đang mượn và đã trả) của bản thân.
* **UC-50 (Cancel Online Reservation):** Actor: Student, Lecturer | (Hủy đặt trước trực tuyến): Độc giả chủ động hủy yêu cầu đặt trước sách khi đang trong hàng đợi hoặc trạng thái sẵn sàng nhận sách.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-19 (Reservation Eligibility):** Độc giả BẮT BUỘC chỉ được phép thực hiện Đặt trước hoặc Gia hạn trực tuyến nếu tài khoản đang ở trạng thái hoạt động (status = 'active') VÀ không bị khóa vì bất kỳ lý do nợ phạt nào.
* **BR-20 (Queue Positioning Strategy):** Vị trí hàng đợi queuePosition = 0 DÀNH RIÊNG cho việc giữ sách đã sẵn sàng lấy (status = 'readypickup'). Mọi yêu cầu chờ sách (khi availableQuantity = 0) BẮT BUỘC phải có queuePosition > 0 và trạng thái 'pending'.
* **BR-21 (Renewal Constraints):** Giao dịch mượn (BorrowRecord) chỉ được phép gia hạn nếu thỏa mãn ĐỒNG THỜI 3 điều kiện: (1) Thời gian mượn đã qua % quy định, (2) extensionCount chưa vượt mức tối đa trong SystemConfigurations, (3) KHÔNG có bất kỳ Reservation nào có queuePosition > 0 đang chờ cho cùng tựa sách đó.
* **BR-36 (Reservation Pickup Limit):** Đơn đặt trước ở trạng thái 'readypickup' chỉ được giữ tại quầy trong một khoảng thời gian giới hạn được xác định bởi cấu hình RESERVATION_HOLD_DAYS trong bảng SystemConfigurations (mặc định là 3 ngày). Nếu quá thời hạn này (endDate < NOW()), đơn hàng sẽ tự động bị hủy và giải phóng bản sao sách.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-29 (Xác thực điều kiện Giao dịch Trực tuyến đầy đủ):** WHEN ReservationServlet hoặc RenewalServlet nhận request từ user, THE system SHALL kiểm tra điều kiện giao dịch: (1) Verify session userId hợp lệ, (2) UserDAO.findById(userId), kiểm tra User.status='active' (không locked), (3) UserLockReasonDAO.hasLockReason(userId, 'unpaid'), WHERE tồn tại: chặn với thông báo "Tài khoản có nợ phạt chưa thanh toán, không thể thực hiện giao dịch", (4) BorrowRecordDAO.countActiveBorrowsByUser(userId), so sánh với SystemConfig: STUDENT_MAX_BORROW_BOOKS hoặc LECTURER_MAX_BORROW_BOOKS theo role, WHERE vượt hạn mức: chặn với thông báo "Đã đạt giới hạn số sách mượn", (5) WHERE tất cả điều kiện OK: tiếp tục xử lý reserve/renew.
  * *Mapping:* UC-16, UC-17 / BR-19
* **FR-30 (Đặt trước sách có sẵn với Transaction):** WHEN OnlineCirculationService.reserveBook(userId, bookId, role) được gọi VÀ Book.availableQuantity > 0, THE system SHALL mở DB Transaction (conn.setAutoCommit(false)): (1) **SELECT ... FOR UPDATE** Book WHERE bookId=? (lock row chống race condition), (2) Re-check availableQuantity > 0, (3) INSERT Reservation(userId, bookId, bookCopyId=NULL, queuePosition=0, status='readypickup', createdAt=NOW(), endDate=NOW()+RESERVATION_HOLD_DAYS từ SystemConfig), (4) UPDATE Book SET availableQuantity = availableQuantity - 1, (5) INSERT AuditLog(RESERVE_BOOK_ONLINE, userId), (6) conn.commit(), (7) EmailService.enqueue(RESERVATION_READY, userId) [async, ngoài transaction]. WHERE SQLException: rollback.
  * *Mapping:* UC-16 / BR-20
* **FR-31 (Xếp hàng chờ sách hết bản sao với Race Condition Protection):** WHEN OnlineCirculationService.reserveBook(userId, bookId, role) được gọi VÀ Book.availableQuantity == 0, THE system SHALL mở DB Transaction: (1) **SELECT ... FOR UPDATE** Book WHERE bookId=? (lock row), (2) Re-check availableQuantity == 0, (3) ReservationDAO.getMaxQueuePosition(bookId) → maxQueue, (4) INSERT Reservation(userId, bookId, bookCopyId=NULL, queuePosition=maxQueue+1, status='pending', createdAt=NOW(), endDate=NULL), (5) INSERT AuditLog(RESERVE_BOOK_QUEUE, userId), (6) conn.commit(), (7) Trả về flash message "Đã xếp hàng chờ tại vị trí {maxQueue+1}". WHERE SQLException: rollback. (KHÔNG trừ availableQuantity vì sách đã hết).
  * *Mapping:* UC-16 / BR-20
* **FR-32 (Kiểm tra điều kiện Gia hạn với 3 điều kiện bắt buộc):** WHEN OnlineCirculationService.renewBook(userId, borrowRecordId) được gọi, THE system SHALL kiểm tra 3 điều kiện theo BR-21: (1) **Điều kiện 1 - Thời gian tối thiểu**: Tính số ngày đã mượn = (NOW() - BorrowRecord.startDate), lấy RENEWAL_MIN_DAYS_BEFORE_DUE từ SystemConfig (default 0), WHERE số ngày < minDays: chặn với thông báo "Chưa đủ thời gian để gia hạn", (2) **Điều kiện 2 - Số lần tối đa**: Lấy MAX_EXTENSION_COUNT từ SystemConfig, WHERE BorrowRecord.extensionCount >= maxCount: chặn với thông báo "Đã hết lượt gia hạn", (3) **Điều kiện 3 - Không có người chờ**: ReservationDAO.hasPendingQueue(bookId) WHERE tồn tại Reservation có queuePosition > 0 AND status='pending': chặn với thông báo "Có người đang chờ sách này, không thể gia hạn". WHERE tất cả điều kiện OK: tiếp tục FR-33.
  * *Mapping:* UC-17 / BR-21
* **FR-33 (Thực thi Gia hạn với cập nhật endDate):** WHERE yêu cầu gia hạn hợp lệ (qua FR-32), THE system SHALL mở DB Transaction: (1) Lấy STUDENT_MAX_BORROW_DAYS hoặc LECTURER_MAX_BORROW_DAYS từ SystemConfig theo role, (2) UPDATE BorrowRecord SET endDate = endDate + {loanDays} ngày, extensionCount = extensionCount + 1 WHERE borrowRecordId=?, (3) INSERT AuditLog(RENEW_BOOK_ONLINE, userId), (4) conn.commit(), (5) EmailService.enqueue(RENEWAL_CONFIRMATION, userId) [async], (6) Trả về flash "Gia hạn thành công, hạn mới: {newEndDate}".
  * *Mapping:* UC-17 / BR-21
* **FR-67 (Quét đơn đặt trước sẵn sàng quá hạn theo BR-36):** WHEN ReservationExpirationProcessor chạy định kỳ (mỗi 1 giờ) hoặc TriggerReservationExpirationServlet được admin kích hoạt thủ công, THE system SHALL: (1) Lấy RESERVATION_HOLD_DAYS từ SystemConfig (default 3 ngày), (2) Truy vấn ReservationDAO.findExpiredReadyPickup(NOW()) để lấy tất cả Reservation WHERE status='readypickup' AND endDate < NOW(), (3) Ghi log số lượng đơn hết hạn tìm được, (4) Với mỗi expired reservation: gọi FR-68 để xử lý cancel + đôn hàng chờ, (5) Trả về JSON {processedCount, cancelledCount, reassignedCount, emailsSent}.
  * *Mapping:* UC-43 / BR-36
* **FR-68 (Hủy đặt trước và đôn hàng chờ tự động):** For each expired Reservation found trong FR-67, THE system SHALL mở DB Transaction: (1) UPDATE Reservation SET status='cancelled', cancelledAt=NOW(), cancelReason='Expired - không nhận sách trong thời hạn' WHERE reservationId=?, (2) **Kiểm tra hàng chờ**: ReservationDAO.findNextInQueue(bookId) WHERE queuePosition=1 AND status='pending', (3) **PHÂN NHÁNH A - Có người chờ tiếp theo**: UPDATE Reservation SET queuePosition=0, status='readypickup', bookCopyId=expired.bookCopyId (kế thừa bản sao), endDate=NOW()+RESERVATION_HOLD_DAYS, UPDATE BookCopy SET status='reserved' (giữ nguyên), EmailService.enqueue(RESERVATION_READY, nextUserId) [async], **PHÂN NHÁNH B - Không có người chờ**: UPDATE BookCopy SET status='available', UPDATE Book SET availableQuantity = availableQuantity + 1, (4) INSERT AuditLog(CANCEL_EXPIRED_RESERVATION), (5) conn.commit(), (6) EmailService.enqueue(RESERVATION_EXPIRED_NOTICE, originalUserId) [async].
  * *Mapping:* UC-43 / BR-36
* **FR-78 (Hủy đặt trước trực tuyến):** WHEN CancelReservationServlet.doPost() nhận request hủy đặt trước từ Student hoặc Lecturer, THE system SHALL: (1) Lấy reservationId từ param, (2) Gọi OnlineCirculationService.cancelReservation(userId, reservationId) để mở DB Transaction: (a) Đổi status Reservation thành 'cancelled', (b) UPDATE queuePosition của các đơn hàng chờ phía sau trong hàng đợi cho đầu sách đó (trừ đi 1), (c) Ghi log AuditLog(CANCEL_RESERVATION), (3) Redirect về trang my-borrowings kèm success flash message.
  * *Mapping:* UC-50 / BR-19
* **FR-79 (Xem lịch sử mượn trả đầy đủ):** WHEN BorrowHistoryServlet.doGet() được gọi, THE system SHALL: (1) Lấy userId từ session, (2) Gọi BorrowRecordDAO.findAllBorrowRecordsByUserId() để JOIN Book và BookCopy lấy toàn bộ lịch sử mượn trả (bao gồm các bản ghi đã trả 'returned', quá hạn 'overdue', đang mượn 'borrowed'), (3) Set attribute và forward sang borrow-history.jsp tương ứng với role.
  * *Mapping:* UC-49

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Ràng buộc: Độc giả bị khóa do nợ phạt hoặc vi phạm bảo mật không thể thực hiện đặt trước hay gia hạn.
* Hiệu năng: Thời gian cập nhật hàng đợi dưới 200ms.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng Reservation
* `reservationId` (INT, PK)
* `userId` (INT, FK)
* `bookId` (INT, FK)
* `bookCopyId` (INT, FK, NULL)
* `status` (VARCHAR(50))
* `queuePosition` (INT)
* `startDate` (TIMESTAMP)
* `endDate` (TIMESTAMP)

### Bảng BorrowRecord
* `borrowRecordId` (INT, PK)
* `userId` (INT, FK)
* `bookCopyId` (INT, FK)
* `status` (VARCHAR(50))
* `extensionCount` (INT)
* `endDate` (TIMESTAMP)



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE độc giả bị khóa do nợ phạt, THE system SHALL chặn yêu cầu và hiển thị thông báo 'Tài khoản bị khóa do chưa hoàn thành tiền phạt'.
* WHERE sách đã hết lượt gia hạn tối đa, THE system SHALL hiển thị thông báo 'Bạn đã vượt quá số lần gia hạn tối đa cho phép'.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Đặt trước sách còn sẵn: Đặt trước thành công -> Trạng thái 'readypickup', queuePosition = 0, gán sẵn bản sao vật lý.
- [ ] Gia hạn sách có người đang chờ: Sách đang có hàng đợi (queuePosition > 0) -> Hệ thống từ chối gia hạn và hiển thị thông báo.
- [ ] Hủy đặt trước: Độc giả hủy đơn đang ở vị trí số 2 -> Đơn vị trí số 3 tự động chuyển lên vị trí số 2.

## 9. Out of Scope (Phạm vi không thực hiện)
* Độc giả tự thay đổi vị trí của mình trong hàng đợi đặt trước.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.