# Feature Specification: Giao dịch mượn trả tại quầy (Desk Circulation Operations)
# Version: 1.4 | Chủ sở hữu: Thai | Ngày cập nhật: 2026-07-27 (Đồng bộ luồng Check-out bắt buộc Reservation & UC-51)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp công cụ cho Thủ thư (Librarian) thực hiện các thao tác Mượn sách (`Check-out`), Trả sách (`Check-in`), Đăng ký đặt trước tại quầy (`Desk Reservation`), và Duyệt thanh toán tiền mặt (`Cash Payment`) trực tiếp tại quầy lưu thông thông qua quét mã vạch Barcode, xử lý trả sách quá hạn, tự động tính tiền phạt và ghi nhận trạng thái sách hư hỏng/thất lạc.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Thực hiện mượn/trả sách cho độc giả tại quầy, kiểm tra tình trạng sách khi trả, đăng ký đặt trước thay độc giả, ghi nhận quá hạn và khởi tạo phiếu phạt.

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-18 (Desk Check-out):** Actor: Librarian | (Giao sách tại quầy): Thủ thư quét mã vạch bản sao sách và mã độc giả để giao sách. Yêu cầu độc giả bắt buộc phải có đơn đặt trước sách (Reservation ở trạng thái `readypickup`).
* **UC-19 (Desk Check-in):** Actor: Librarian | (Nhận sách tại quầy): Thủ thư nhận lại bản sao sách, đánh giá tình trạng vật lý (Condition). Tự động luân chuyển sách cho người chờ tiếp theo trong hàng đợi (nếu có) hoặc tính phạt và khóa tài khoản tức thời (nếu sách hỏng/mất).
* **UC-20 (Process Cash Payment):** Actor: Librarian | (Duyệt thanh toán tiền mặt): Thủ thư xác nhận đã thu tiền phạt bằng tiền mặt từ độc giả, đóng khoản phạt, gỡ cờ nợ phạt và tự động mở khóa tài khoản nếu đủ điều kiện.
* **UC-51 (Register Desk Reservation):** Actor: Librarian | (Đăng ký đặt trước tại quầy): Thủ thư thực hiện đăng ký đặt trước sách thay cho độc giả ngay tại quầy khi độc giả mượn trực tiếp tại chỗ hoặc theo yêu cầu.

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F6 Desk Circulation Operations. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-22 (Strict Fine Enforcement):** Hệ thống BẮT BUỘC chặn giao dịch mượn sách nếu tồn tại bất kỳ khoản phạt chưa thanh toán nào (`hasUnpaidFines`) hoặc có lý do khóa 'unpaid' trong `UserLockReason`.
* **BR-23 (Pre-reservation Enforced Policy):** Giao sách (Check-out) tại quầy BẮT BUỘC độc giả phải có đơn đặt trước sách (Reservation) ở trạng thái `readypickup` cho đầu sách đó. Nếu độc giả mượn trực tiếp tại quầy chưa có đơn đặt trước, Thủ thư BẮT BUỘC phải thực hiện Đăng ký Đặt trước sách tại quầy (UC-51 / `DeskReservationServlet`) trước khi tiến hành Giao sách. Hệ thống KHÔNG tự động tạo Reservation ảo ngầm bên trong luồng Check-out.
* **BR-24 (Damaged/Lost Inventory Deduction):** Khi nhận sách trả với tình trạng 'damaged' hoặc 'lost', hệ thống BẮT BUỘC trừ 1 đơn vị vào Book.totalQuantity (nếu lost) hoặc giữ totalQuantity (nếu damaged để F13 xử lý). ĐỒNG THỜI, BẮT BUỘC phải insert tức thời bản ghi 'unpaid' vào UserLockReason và đổi status User thành 'locked' mà không chờ Background Job chạy ngầm.
* **BR-25 (Conditional Auto-Unlock):** Sau khi thanh toán tiền phạt (xóa reason 'unpaid'), hệ thống BẮT BUỘC đếm số lượng lý do khóa còn lại trong UserLockReason. CHỈ KHỞI ĐỘNG quy trình mở khóa (Update User.status = 'active') NẾU COUNT == 0. Tuyệt đối không mở khóa nếu tài khoản đang bị 'adminban' hoặc 'securitybreach'.
* **BR-29 (Walk-in vs Pre-reservation Checkout Policy):** Khi thực hiện Giao sách (Check-out) tại quầy, nếu đơn đặt trước đã giữ sẵn bản sao (`bookCopyId != null`), hệ thống chuyển trạng thái BookCopy sang 'borrowed' mà không trừ lại `availableQuantity` (vì đã trừ khi chuyển ready). Nếu đơn đặt trước chưa gán bản sao, gán bản sao hiện tại và cập nhật trạng thái kho phù hợp.
* **BR-41 (Desk Reservation Rules):** Khi Thủ thư đăng ký đặt trước tại quầy thay cho độc giả (UC-51), hệ thống BẮT BUỘC phải tuân thủ đầy đủ các giới hạn về chặn nợ phạt (BR-22) và hạn mức mượn sách tối đa (BR-21).


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-34 (Kiểm tra điều kiện Giao sách đầy đủ):** WHEN CheckOutServlet.doPost(memberCode, barcode, targetBookId) được gọi, THE system SHALL: (1) Validate barcode và memberCode không rỗng, (2) UserLookupDAO.findUserIdByMemberCode() → userId, (3) Kiểm tra User tồn tại và không bị xóa, (4) Truy vấn FineDAO: WHERE tồn tại unpaid fine, CHẶN giao dịch với thông báo "Tài khoản đang nợ phạt, không thể mượn sách cho đến khi thanh toán xong", (5) BookCopyDAO.findByBarcode(barcode), (6) Kiểm tra BookCopy.status hợp lệ ('available' hoặc 'reserved'), (7) Kiểm tra hạn mức mượn tối đa của độc giả.
  * *Mapping:* UC-18 / BR-22, BR-29
* **FR-35 (Xác thực đơn Đặt trước khi Giao sách):** WHEN CheckOutServlet.doPost() được gọi cho mượn sách, THE system SHALL kiểm tra ReservationDAO.findReadyPickupByUserAndBook(conn, userId, bookId). WHERE `reservation == null`, THE system SHALL dừng giao dịch ngay lập tức, ném `IllegalStateException` với thông báo: "Độc giả chưa có đơn đặt mượn sách (Reservation) khả dụng cho đầu sách này. Bắt buộc độc giả hoặc thủ thư phải đăng ký Đặt trước sách trước khi thực hiện giao sách."
  * *Mapping:* UC-18 / BR-23
* **FR-36 (Thực thi Giao sách với DB Transaction):** WHERE tất cả điều kiện FR-34, FR-35 thỏa mãn, THE system SHALL mở DB Transaction (conn.setAutoCommit(false)) và thực thi tuần tự: (1) INSERT BorrowRecord(userId, bookCopyId, status='borrowed', startDate=NOW(), endDate=NOW()+LoanDays theo role, extensionCount=0), (2) UPDATE Reservation SET status='fulfilled', borrowRecordId=? WHERE reservationId=?, (3) UPDATE BookCopy SET status='borrowed', (4) INSERT AuditLog(CHECKOUT, actorId=librarianId), (5) conn.commit(). WHERE SQLException: conn.rollback() + throw. (6) EmailService.enqueue(CHECKOUT_CONFIRMATION, userId) [async, ngoài transaction].
  * *Mapping:* UC-18 / BR-29
* **FR-37 (Nhận sách Hỏng/Mất với khóa tức thì):** WHEN CheckInServlet.doPost(barcode, condition='damaged'|'lost', memberCode) được gọi, THE system SHALL mở DB Transaction: (1) BookCopyDAO.findByBarcode(), (2) BorrowRecordDAO.findActiveBorrowByBookCopyId(), (3) Tính số ngày trễ = (NOW() - BorrowRecord.endDate), WHERE > 0: amount = FINE_RATE_PER_DAY × số ngày, INSERT Fine(borrowRecordId, userId, amount, status='unpaid', reason='overdue'), (4) UPDATE BorrowRecord SET status='returned', returnedAt=NOW(), (5) UPDATE BookCopy SET status='unavailable', condition=condition, (6) IF condition='lost': UPDATE Book.totalQuantity = totalQuantity - 1 và set removedFromInventory=true; IF condition='damaged': giữ totalQuantity, (7) INSERT BookCopyIncident(bookCopyId, type=condition, description='Phát hiện khi trả sách', status='resolved'), (8) KHÓA TỨC THÌ: INSERT UserLockReason(userId, reason='unpaid') + UPDATE User.status='locked', (9) INSERT AuditLog(CHECKIN), (10) conn.commit().
  * *Mapping:* UC-19 / BR-24
* **FR-38 (Nhận sách Nguyên vẹn với tính phạt trễ hạn):** WHEN CheckInServlet.doPost(barcode, condition='good', memberCode) được gọi, THE system SHALL mở DB Transaction: (1) BookCopyDAO.findByBarcode(), (2) BorrowRecordDAO.findActiveBorrowByBookCopyId(), (3) Tính số ngày trễ = (NOW() - BorrowRecord.endDate), WHERE số ngày > 0: amount = FINE_RATE_PER_DAY × số ngày trễ, INSERT Fine(borrowRecordId, userId, amount, status='unpaid', reason='overdue'), INSERT UserLockReason(userId, reason='unpaid'), UPDATE User.status='locked', (4) UPDATE BorrowRecord SET status='returned', returnedAt=NOW(), (5) UPDATE BookCopy SET condition='good', status='available', (6) INSERT AuditLog(CHECKIN), (7) THEN gọi FR-39 để điều phối hàng chờ, (8) conn.commit(). (9) EmailService.enqueue(CHECKIN_CONFIRMATION) [async].
  * *Mapping:* UC-19
* **FR-39 (Điều phối Hàng chờ Check-in với tính HOLD_DAYS):** WHILE hệ thống nhận trả sách condition='good' VÀ hoàn tất cập nhật BorrowRecord, THE system SHALL truy vấn ReservationDAO.findNextInQueue(bookId) WHERE queuePosition = 1 AND status='pending'. WHERE tồn tại người chờ tiếp theo: (1) UPDATE Reservation SET queuePosition=0, status='readypickup', bookCopyId=?, endDate=NOW()+RESERVATION_HOLD_DAYS (từ SystemConfig), (2) UPDATE BookCopy SET status='reserved', (3) EmailService.enqueue(RESERVATION_READY, userId) [async]. WHERE KHÔNG có người chờ: (1) UPDATE Book.availableQuantity = availableQuantity + 1, (2) UPDATE BookCopy.status='available'.
  * *Mapping:* UC-19
* **FR-40 (Xác nhận Thanh toán Tiền mặt với BR-25):** WHEN CashPaymentServlet.doPost(paymentId, memberCode) được gọi, THE system SHALL: (1) UserLookupDAO.findUserIdByMemberCode() → userId, (2) Mở DB Transaction: PaymentDAO.updatePaymentCompleted(paymentId, librarianId), FineDAO.updateStatusToPaid(fineId), UserLockReasonDAO.deleteLockReason(userId, 'unpaid'), (3) Kiểm định mở khóa tự động theo BR-25: COUNT(*) FROM UserLockReason WHERE userId=?, WHERE count = 0: UserDAO.updateStatusToActive(userId), WHERE count > 0: GIỮ NGUYÊN status='locked', (4) INSERT AuditLog(CASH_PAYMENT), (5) conn.commit(), (6) EmailService.enqueue(PAYMENT_CONFIRMATION) [async].
  * *Mapping:* UC-20 / BR-25
* **FR-80 (Đăng ký đặt trước tại quầy):** WHEN DeskReservationServlet.doPost() nhận mã độc giả (memberCode) và mã sách/ISBN/barcode (bookIdOrIsbn), THE system SHALL: (1) Ánh xạ memberCode sang userId, (2) Xác định bookId từ ISBN/barcode/bookId, (3) Mở DB Transaction gọi OnlineCirculationService.reserveBook(userId, bookId, role): validate nợ phạt (BR-22) và hạn mức mượn/đặt (BR-21), tạo bản ghi Reservation với queuePosition thích hợp, (4) Redirect về desk-dashboard kèm thông báo thành công.
  * *Mapping:* UC-51 / BR-41


## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Hiệu năng:** Xử lý thao tác quét barcode và chốt phiếu mượn/trả trong dưới 200ms để tránh ùn tắc tại quầy.
* **Bảo mật:** Phân quyền bắt buộc role LIBRARIAN. Mọi thao tác mượn trả bắt buộc ghi Audit Log người thực hiện (`createdBy`).
* **Giao diện:** Tích hợp máy quét mã vạch Barcode scanner và nút quét linh hoạt trên các form tại quầy.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `BorrowRecord`
* `borrowRecordId` (INT, PK), `userId` (FK), `bookCopyId` (FK), `bookId` (FK), `startDate`, `endDate`, `returnedAt`, `status` (borrowing/returned/overdue), `extensionCount`, `createdBy` (FK)

### Bảng `Fine`
* `fineId` (INT, PK), `borrowRecordId` (FK), `userId` (FK), `amount` (DECIMAL), `reason`, `status` (unpaid/paid/waived), `createdAt`

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** độc giả chưa có đơn đặt mượn sách (Reservation), **THE system SHALL** từ chối tạo phiếu mượn và thông báo "Độc giả chưa có đơn đặt mượn sách (Reservation) khả dụng cho đầu sách này. Bắt buộc độc giả hoặc thủ thư phải đăng ký Đặt trước sách trước khi thực hiện giao sách."
* **WHERE** độc giả đang nợ tiền phạt, **THE system SHALL** từ chối và thông báo "Tài khoản đang nợ phạt, không thể mượn sách cho đến khi thanh toán xong."

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-CIRC-01] Quét mượn sách thành công tạo đúng bản ghi BorrowRecord khi đã có Reservation.
- [ ] [TC-CIRC-02] Quét trả sách đúng hạn cập nhật returnedAt và trả lại trạng thái available cho bản sao.
- [ ] [TC-CIRC-03] Quét trả sách quá hạn tự động tạo bản ghi Fine với số tiền tính chính xác theo số ngày trễ.
- [ ] [TC-CIRC-04] Độc giả chưa có Reservation bị hệ thống chặn không cho giao sách trực tiếp.
- [ ] [TC-CIRC-05] Thủ thư có thể đăng ký đặt trước tại quầy (UC-51) thay độc giả khi mượn trực tiếp.

## 8. Out of Scope (Phạm vi không thực hiện)
* Tự động mượn trả bằng trạm Robot tự phục vụ (Self Check-in Kiosk hardware).
