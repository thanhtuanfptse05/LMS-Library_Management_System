# Feature Specification: Đặt trước & Gia hạn sách (Reservation & Renewal)
# Version: 1.5 | Chủ sở hữu: Bao | Ngày cập nhật: 2026-08-01 (Đồng bộ FR-136 hủy đặt trước kèm lý do & gửi email RESERVATION_CANCELLED)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp chức năng cho phép Sinh viên và Giảng viên chủ động Đặt trước (Reservation) các đầu sách mong muốn khi hết bản sao sẵn có, và Yêu cầu Gia hạn (Renewal) thời gian mượn sách trực tuyến mà không cần đến quầy thư viện, tuân thủ các quy định chính sách của hệ thống.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Sinh viên (Student) & Giảng viên (Lecturer):** Thực hiện đặt giữ chỗ sách trực tuyến, thực hiện yêu cầu gia hạn thời gian mượn sách.
* **Thủ thư (Librarian):** Xác nhận giữ chỗ tại quầy khi độc giả đến nhận sách theo đơn đặt trước.

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-16 (Reserve Book Online):** Actor: User (Student/Lecturer) | (Đặt trước trực tuyến): Người dùng khởi tạo yêu cầu đặt sách. Nếu sách còn khả dụng, hệ thống cấp phát ngay (vào vị trí 0). Nếu sách hết, người dùng được xếp vào hàng đợi chờ (vị trí > 0).
* **UC-17 (Renew Book Online):** Actor: User (Student/Lecturer) | (Gia hạn trực tuyến): Người dùng tự động kéo dài thời gian mượn của một cuốn sách đang giữ, với điều kiện không có ai khác đang xếp hàng chờ cuốn sách đó.
* **UC-43 (Auto-cancel Expired Reservations):** Actor: System, SysAdmin | (Hủy đặt trước quá hạn): Hệ thống chạy định kỳ (hoặc SysAdmin kích hoạt thủ công) để quét các đơn đặt trước sẵn sàng nhận quá hạn, hủy bỏ chúng, đôn hàng chờ cho người tiếp theo hoặc trả sách về kho.
* **UC-49 (View Full Borrow/Return History):** Actor: Student, Lecturer | (Xem lịch sử mượn trả đầy đủ): Độc giả xem danh sách tất cả các bản ghi mượn sách trong lịch sử (đang mượn và đã trả) của bản thân.
* **UC-50 (Cancel Online Reservation):** Actor: Student, Lecturer | (Hủy đặt trước trực tuyến): Độc giả chủ động hủy yêu cầu đặt trước sách khi đang trong hàng đợi hoặc trạng thái sẵn sàng nhận sách.
* **UC-58 (Librarian Reservation Management):** Actor: Librarian | (Thủ thư quản lý đặt trước): Thủ thư quản lý danh sách đặt trước, bao gồm quyền hủy các đơn đặt trước không hợp lệ kèm theo lý do cụ thể.

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F5 Online Reservation & Renewal. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-19 (Reservation Eligibility):** Độc giả BẮT BUỘC chỉ được phép thực hiện Đặt trước hoặc Gia hạn trực tuyến nếu tài khoản đang ở trạng thái hoạt động (status = 'active') VÀ không bị khóa vì bất kỳ lý do nợ phạt nào.
* **BR-20 (Queue Positioning Strategy):** Vị trí hàng đợi queuePosition = 0 DÀNH RIÊNG cho việc giữ sách đã sẵn sàng lấy (status = 'readypickup'). Mọi yêu cầu chờ sách (khi availableQuantity = 0) BẮT BUỘC phải có queuePosition > 0 và trạng thái 'pending'.
* **BR-21 (Renewal Constraints):** Giao dịch mượn (BorrowRecord) chỉ được phép gia hạn nếu thỏa mãn ĐỒNG THỜI 3 điều kiện: (1) Thời gian mượn đã qua % quy định, (2) extensionCount chưa vượt mức tối đa trong SystemConfigurations, (3) KHÔNG có bất kỳ Reservation nào có queuePosition > 0 đang chờ cho cùng tựa sách đó.
* **BR-36 (Reservation Pickup Limit):** Đơn đặt trước ở trạng thái 'readypickup' chỉ được giữ tại quầy trong một khoảng thời gian giới hạn được xác định bởi cấu hình RESERVATION_HOLD_DAYS trong bảng SystemConfigurations (mặc định là 3 ngày). Nếu quá thời hạn này (endDate < NOW()), đơn hàng sẽ tự động bị hủy và giải phóng bản sao sách.
* **BR-63 (Borrow and Reservation Quota):** The system SHALL enforce a maximum combined limit for active borrows and pending reservations per user.
* **BR-64 (Duplicate Title Prevention):** The system SHALL prevent a user from borrowing or reserving multiple copies of the exact same book title simultaneously.
* **BR-72 (Borrowing History Privacy):** The system SHALL restrict users to viewing only their own personal borrowing and reservation records.
* **BR-78 (Historical Data Immutability):** The system SHALL NOT allow users to modify or delete their past borrow and return records.


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
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
* **FR-67 (Dọn dẹp đơn đặt trước quá hạn theo cơ chế Lazy Load):** WHEN các Controller/Service liên quan (LibrarianDashboardServlet, DeskDashboardServlet, CheckInServlet, CheckOutServlet, BookDetailServlet, OnlineCirculationService.reserveBook) được truy cập hoặc thực thi, THE system SHALL tự động gọi ReservationExpirationProcessor.processExpiration() [Lazy Load]: (1) Lấy RESERVATION_HOLD_DAYS từ SystemConfig (default 3 ngày), (2) Truy vấn ReservationDAO.findExpiredReadyPickup(NOW()) để lấy tất cả Reservation WHERE status='readypickup' AND endDate < NOW(), (3) Ghi log số lượng đơn hết hạn tìm được, (4) Với mỗi expired reservation: gọi FR-68 để xử lý cancel + đôn hàng chờ trong transaction riêng biệt.
  * *Mapping:* UC-43 / BR-36
* **FR-68 (Hủy đặt trước và đôn hàng chờ tự động):** For each expired Reservation found trong FR-67, THE system SHALL mở DB Transaction: (1) UPDATE Reservation SET status='cancelled', cancelledAt=NOW(), cancelReason='Expired - không nhận sách trong thời hạn' WHERE reservationId=?, (2) **Kiểm tra hàng chờ**: ReservationDAO.findNextInQueue(bookId) WHERE queuePosition=1 AND status='pending', (3) **PHÂN NHÁNH A - Có người chờ tiếp theo**: UPDATE Reservation SET queuePosition=0, status='readypickup', bookCopyId=expired.bookCopyId (kế thừa bản sao), endDate=NOW()+RESERVATION_HOLD_DAYS, UPDATE BookCopy SET status='reserved' (giữ nguyên), EmailService.enqueue(RESERVATION_READY, nextUserId) [async], **PHÂN NHÁNH B - Không có người chờ**: UPDATE BookCopy SET status='available', UPDATE Book SET availableQuantity = availableQuantity + 1, (4) INSERT AuditLog(CANCEL_EXPIRED_RESERVATION), (5) conn.commit(), (6) EmailService.enqueue(RESERVATION_EXPIRED_NOTICE, originalUserId) [async].
  * *Mapping:* UC-43 / BR-36
* **FR-78 (Hủy đặt trước trực tuyến):** WHEN CancelReservationServlet.doPost() nhận request hủy đặt trước từ Student hoặc Lecturer, THE system SHALL: (1) Lấy reservationId từ param, (2) Gọi OnlineCirculationService.cancelReservation(userId, reservationId) để mở DB Transaction: (a) Đổi status Reservation thành 'cancelled', (b) UPDATE queuePosition của các đơn hàng chờ phía sau trong hàng đợi cho đầu sách đó (trừ đi 1), (c) Ghi log AuditLog(CANCEL_RESERVATION), (3) Redirect về trang my-borrowings kèm success flash message.
  * *Mapping:* UC-50 / BR-19
* **FR-79 (Xem lịch sử mượn trả đầy đủ):** WHEN BorrowHistoryServlet.doGet() được gọi, THE system SHALL: (1) Lấy userId từ session, (2) Gọi BorrowRecordDAO.findAllBorrowRecordsByUserId() để JOIN Book và BookCopy lấy toàn bộ lịch sử mượn trả (bao gồm các bản ghi đã trả 'returned', quá hạn 'overdue', đang mượn 'borrowed'), (3) Set attribute và forward sang borrow-history.jsp tương ứng với role.
  * *Mapping:* UC-49
* **FR-80 (Sắp xếp cá nhân & Đếm ngược thời gian giữ sách) (FR-134, BR-84):** WHEN MyBorrowingsServlet.doGet() được gọi từ Sinh viên hoặc Giảng viên (`/student/my-borrowings`, `/lecturer/my-borrowings`), THE system SHALL: (1) Nhận các tham số sắp xếp `borrowSortBy`, `borrowSortOrder`, `resSortBy`, `resSortOrder`, (2) Thực hiện sắp xếp danh sách mượn (`borrows`) và danh sách đặt trước (`reservations`), (3) Trên giao diện JSP hiển thị bộ đếm ngược thời gian thực (Countdown Timer) cho các đơn đặt trước sẵn sàng nhận (`queuePosition == 0`), tự động reload trang sau 1.5s khi hết hạn để kích hoạt Lazy Sweep cập nhật trạng thái mới.
  * *Mapping:* UC-16, UC-50, UC-59 / BR-20, BR-36, BR-84
* **FR-136 (Thủ thư Hủy lượt đặt trước kèm Lý do & Gửi Mail Thông báo):** WHEN Thủ thư gửi POST request tới `/librarian/reservation-queue` với `action=cancel` kèm `reservationId` và `reason`, THE system SHALL gọi `OnlineCirculationService.cancelReservationByLibrarian(librarianId, reservationId, reason)`: (1) UPDATE Reservation SET status='cancelled', (2) Đôn người ở queuePosition=1 lên queuePosition=0 (readypickup) nếu có, (3) INSERT AuditLog(CANCEL_RESERVATION_BY_LIBRARIAN, librarianId, reason), (4) EmailService.enqueue(RESERVATION_CANCELLED, userId, {cancelReason: reason}) [async] gửi email thông báo chứa `{{userName}}`, `{{bookTitle}}`, `{{cancelReason}}` tới độc giả bị hủy. (5) Redirect về reservation-queue kèm flash success.
  * *Mapping:* UC-50, UC-58 / BR-83


## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Phân quyền kiểm tra phiên làm việc người dùng. Ngăn chặn thao tác gia hạn/đặt trước cho tài khoản khác (ID spoofing).
* **Hiệu năng:** Xử lý yêu cầu đặt trước và gia hạn dưới 250ms.
* **Giao diện:** Thân thiện 100% tiếng Việt, hiển thị rõ số ngày còn lại và số lần gia hạn còn lại.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `Reservation`
* `reservationId` (INT, PK), `userId` (FK), `bookId` (FK), `bookCopyId` (FK), `status` (pending/fulfilled/cancelled/expired), `queuePosition` (INT), `startDate`, `endDate`

### Bảng `BorrowRecord`
* `borrowRecordId` (INT, PK), `userId` (FK), `bookCopyId` (FK), `startDate`, `endDate`, `returnedAt`, `status`, `extensionCount`

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** phiếu mượn đã quá hạn, **THE system SHALL** từ chối gia hạn và báo lỗi "Sách đã quá hạn, vui lòng mang sách đến quầy để làm thủ tục trả và nộp phạt".
* **WHERE** sách đã hết lượt gia hạn (ví dụ: đã gia hạn 2/2 lần), **THE system SHALL** báo lỗi "Bạn đã đạt số lần gia hạn tối đa cho phép".

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-RES-01] Đặt trước sách thành công và cập nhật hàng chờ queuePosition đúng thứ tự.
- [ ] [TC-RES-02] Đơn đặt trước quá 48h tự động hết hạn và chuyển quyền cho người tiếp theo.
- [ ] [TC-RES-03] Gia hạn sách thành công kéo dài ngày hẹn trả đúng theo cấu hình hệ thống.
- [ ] [TC-RES-04] Bị nợ phạt hoặc sách quá hạn hệ thống chặn gia hạn và thông báo lỗi rõ ràng.

## 8. Out of Scope (Phạm vi không thực hiện)
* Gia hạn sách thông qua tin nhắn SMS tự động.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện toàn bộ luồng nghiệp vụ Đặt trước và Gia hạn.