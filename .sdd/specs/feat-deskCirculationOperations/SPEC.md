# Feature Specification: Mượn và Trả sách tại quầy (Desk Circulation Operations)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Hỗ trợ Thủ thư (Librarian) xử lý trực tiếp các nghiệp vụ giao sách (Check-out) và nhận sách trả (Check-in) tại quầy thông qua thao tác quét mã vạch (Barcode) bản sao sách và mã độc giả.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Quét mã vạch mượn/trả sách, đánh giá tình trạng sách khi trả, thu phí phạt tiền mặt.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-18 (Desk Check-out):** Actor: Librarian | (Giao sách tại quầy): Thủ thư quét mã vạch bản sao sách và mã độc giả để giao sách. Xử lý cả hai trường hợp: Độc giả đã đặt trước trực tuyến (có Reservation queuePosition = 0) hoặc Độc giả đến mượn trực tiếp tại chỗ.
* **UC-19 (Desk Check-in):** Actor: Librarian | (Nhận sách tại quầy): Thủ thư nhận lại bản sao sách, đánh giá tình trạng vật lý (Condition). Tự động luân chuyển sách cho người chờ tiếp theo trong hàng đợi (nếu có) hoặc tính phạt và khóa tài khoản tức thời (nếu sách hỏng/mất).
* **UC-20 (Process Cash Payment):** Actor: Librarian | (Duyệt thanh toán tiền mặt): Thủ thư xác nhận đã thu tiền phạt bằng tiền mặt từ độc giả, đóng khoản phạt, gỡ cờ nợ phạt và tự động mở khóa tài khoản nếu đủ điều kiện.
* **UC-51 (Register Desk Reservation):** Actor: Librarian | (Đăng ký đặt trước tại quầy): Thủ thư thực hiện đăng ký đặt trước sách thay cho độc giả ngay tại quầy khi được yêu cầu trực tiếp.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-18 (Desk Check-out):** Actor: Librarian | (Giao sách tại quầy): Thủ thư quét mã vạch bản sao sách và mã độc giả để giao sách. Xử lý cả hai trường hợp: Độc giả đã đặt trước trực tuyến (có Reservation queuePosition = 0) hoặc Độc giả đến mượn trực tiếp tại chỗ.
* **UC-19 (Desk Check-in):** Actor: Librarian | (Nhận sách tại quầy): Thủ thư nhận lại bản sao sách, đánh giá tình trạng vật lý (Condition). Tự động luân chuyển sách cho người chờ tiếp theo trong hàng đợi (nếu có) hoặc tính phạt và khóa tài khoản tức thời (nếu sách hỏng/mất).
* **UC-20 (Process Cash Payment):** Actor: Librarian | (Duyệt thanh toán tiền mặt): Thủ thư xác nhận đã thu tiền phạt bằng tiền mặt từ độc giả, đóng khoản phạt, gỡ cờ nợ phạt và tự động mở khóa tài khoản nếu đủ điều kiện.
* **UC-51 (Register Desk Reservation):** Actor: Librarian | (Đăng ký đặt trước tại quầy): Thủ thư thực hiện đăng ký đặt trước sách thay cho độc giả ngay tại quầy khi được yêu cầu trực tiếp.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-18 (Desk Check-out):** Actor: Librarian | (Giao sách tại quầy): Thủ thư quét mã vạch bản sao sách và mã độc giả để giao sách. Xử lý cả hai trường hợp: Độc giả đã đặt trước trực tuyến (có Reservation queuePosition = 0) hoặc Độc giả đến mượn trực tiếp tại chỗ.
* **UC-19 (Desk Check-in):** Actor: Librarian | (Nhận sách tại quầy): Thủ thư nhận lại bản sao sách, đánh giá tình trạng vật lý (Condition). Tự động luân chuyển sách cho người chờ tiếp theo trong hàng đợi (nếu có) hoặc tính phạt và khóa tài khoản tức thời (nếu sách hỏng/mất).
* **UC-20 (Process Cash Payment):** Actor: Librarian | (Duyệt thanh toán tiền mặt): Thủ thư xác nhận đã thu tiền phạt bằng tiền mặt từ độc giả, đóng khoản phạt, gỡ cờ nợ phạt và tự động mở khóa tài khoản nếu đủ điều kiện.
* **UC-51 (Register Desk Reservation):** Actor: Librarian | (Đăng ký đặt trước tại quầy): Thủ thư thực hiện đăng ký đặt trước sách thay cho độc giả ngay tại quầy khi được yêu cầu trực tiếp.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-22 (Strict Fine Enforcement):** Hệ thống BẮT BUỘC chặn giao dịch mượn sách nếu tồn tại bất kỳ bản ghi nào có reason = 'unpaid' trong bảng UserLockReason của người dùng. KHÔNG trực tiếp kiểm tra bảng Fine để quyết định chặn giao dịch nhằm giữ tính độc lập dữ liệu.
* **BR-23 (Direct Borrow Queue Policy):** Độc giả mượn sách trực tiếp tại quầy KHÔNG ĐƯỢC PHÉP mượn đầu sách đang có người xếp hàng chờ (tồn tại Reservation với status='pending' VÀ queuePosition > 0). Để chuẩn hóa dữ liệu, mọi giao dịch mượn trực tiếp đều BẮT BUỘC phải tự động sinh ra một Reservation ảo với queuePosition = 0 tại chỗ trước khi insert BorrowRecord.
* **BR-24 (Damaged/Lost Check-in Handoff):** Khi nhận sách trả với tình trạng `damaged` hoặc `lost`, hệ thống BẮT BUỘC ngừng lưu thông bản sao và tạo sự cố theo cùng bất biến F13/BR-28: BookCopy chuyển `unavailable`, **INSERT bản ghi `BookCopyIncident`** (incidentType = condition, status = 'pending', description tự sinh, reportedBy = librarianId) trong **cùng một DB Transaction** với các bước cập nhật BorrowRecord/BookCopy/Fine. Tồn kho khả dụng không được cộng lại. F6 chỉ xử lý phần trả sách, phạt/khóa theo chính sách lưu thông; vòng đời xác minh, kết luận, bác bỏ hoặc khôi phục bản sao thuộc F13. **Lưu ý: Code hiện tại (`DeskCirculationService.processCheckInDamagedOrLost()`) đang THIẾU bước INSERT `BookCopyIncident` — cần bổ sung.**
* **BR-25 (Conditional Auto-Unlock):** Sau khi thanh toán tiền phạt (xóa reason 'unpaid'), hệ thống BẮT BUỘC đếm số lượng lý do khóa còn lại trong UserLockReason. CHỈ KHỞI ĐỘNG quy trình mở khóa (Update User.status = 'active') NẾU COUNT == 0. Tuyệt đối không mở khóa nếu tài khoản đang bị 'adminban' hoặc 'securitybreach'.
* **BR-29 (Walk-in vs Pre-reservation Checkout Policy):** Khi thực hiện Giao sách (Check-out) tại quầy, hệ thống BẮT BUỘC phân biệt trạng thái bản sao sách: Walk-in checkout chỉ chấp nhận BookCopy ở trạng thái 'available' và phải trừ availableQuantity của đầu sách đi 1; Pre-reservation checkout chỉ chấp nhận BookCopy ở trạng thái 'reserved' và KHÔNG được trừ availableQuantity (vì đã trừ khi đặt trước online).
* **BR-41 (Desk Reservation Rules):** Khi Thủ thư đăng ký đặt trước tại quầy thay cho độc giả (UC-51), hệ thống BẮT BUỘC phải tuân thủ đầy đủ các giới hạn về chặn nợ phạt (BR-22) và hạn mức mượn sách (BR-19, BR-21).

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-34 (Kiểm tra điều kiện Giao sách đầy đủ):** WHEN CheckOutServlet.doPost(memberCode, barcode, targetBookId) được gọi, THE system SHALL: (1) Validate barcode và memberCode không rỗng, (2) UserLookupDAO.findUserIdByMemberCode() → userId, (3) Kiểm tra User tồn tại và không bị xóa, (4) Truy vấn UserLockReason: WHERE tồn tại reason='unpaid', CHẶN giao dịch với thông báo "Tài khoản có nợ phạt chưa thanh toán", (5) BookCopyDAO.findByBarcode(barcode), (6) Kiểm tra BookCopy.status: Walk-in yêu cầu 'available', Pre-reservation yêu cầu 'reserved', (7) Kiểm tra hạn mức: đếm số BorrowRecord active của user, so với STUDENT_MAX_BORROW_BOOKS hoặc LECTURER_MAX_BORROW_BOOKS từ SystemConfig.
  * *Mapping:* UC-18 / BR-22, BR-29
* **FR-35 (Xử lý Mượn trực tiếp với Reservation ảo):** WHERE người dùng chưa có đơn đặt trước (Mượn trực tiếp Walk-in) VÀ không vi phạm nợ phạt, THE system SHALL kiểm tra hàng đợi: ReservationDAO.hasQueueForBook(bookId) WHERE tồn tại Reservation có queuePosition > 0 AND status='pending', THE system SHALL từ chối với thông báo "Sách đang có người chờ, không thể mượn trực tiếp". WHERE hàng đợi trống, THE system SHALL tự động CREATE Reservation tại chỗ với (userId, bookId, bookCopyId, queuePosition=0, status='readypickup', createdAt=NOW(), endDate=NOW()+LoanDays) theo BR-23 để chuẩn hóa dữ liệu trước khi insert BorrowRecord.
  * *Mapping:* UC-18 / BR-23
* **FR-36 (Thực thi Giao sách với DB Transaction):** WHERE tất cả điều kiện FR-34, FR-35 thỏa mãn, THE system SHALL mở DB Transaction (conn.setAutoCommit(false)) và thực thi tuần tự: (1) INSERT BorrowRecord(userId, bookCopyId, status='borrowed', startDate=NOW(), endDate=NOW()+LoanDays theo role, extensionCount=0), (2) UPDATE Reservation SET status='fulfilled', borrowRecordId=? WHERE reservationId=?, (3) UPDATE BookCopy SET status='borrowed', (4) **PHÂN NHÁNH**: IF BookCopy trước đó status='available' (Walk-in): UPDATE Book.availableQuantity = availableQuantity - 1, ELSE IF BookCopy status='reserved' (Pre-reservation): SKIP (đã trừ khi đặt trước), (5) INSERT AuditLog(CHECKOUT, actorId=librarianId), (6) conn.commit(). WHERE SQLException: conn.rollback() + throw. (7) EmailService.enqueue(CHECKOUT_CONFIRMATION, userId) [async, ngoài transaction].
  * *Mapping:* UC-18 / BR-29
* **FR-37 (Nhận sách Hỏng/Mất và tự động tạo Incident):** WHEN `CheckInServlet.doPost(barcode, condition='damaged'|'lost', memberCode)` được gọi, THE system SHALL mở DB Transaction và thực thi tuần tự:
  1. `BookCopyDAO.findByBarcode()` → xác định `bookCopyId`, `bookId`
  2. `BorrowRecordDAO.findActiveBorrowByBookCopyId()` → xác định `borrowRecordId`, `userId`
  3. UPDATE `BorrowRecord.status` = condition (`damaged`/`lost`), `returnedAt` = NOW()
  4. UPDATE `BookCopy.status='unavailable'`, `BookCopy.condition` = condition
  5. UPDATE `Book.totalQuantity - 1` (loại bản sao khỏi tổng tài sản)
  6. **[BẮT BUỘC — ĐANG THIẾU TRONG CODE]** INSERT `BookCopyIncident` với các trường:
     - `bookCopyId` = bookCopyId của bản sao đang xử lý
     - `incidentType` = condition (`'damaged'` hoặc `'lost'`)
     - `description` = Chuỗi tự sinh theo mẫu: `"Phát hiện khi trả sách — Mã mượn: BR-{borrowRecordId}"`
     - `status` = `'pending'` (giá trị mặc định theo schema)
     - `reportedBy` = `librarianId` (Thủ thư đang thực hiện check-in)
     - `reportedAt` = NOW() (giá trị mặc định theo schema)
     - Gọi qua: `BookCopyIncidentDAO.insert(conn, incident)` — hàm này đã tồn tại sẵn
  7. Tính tiền phạt đền bù: `calculateCompensationAmount(conn, bookId, condition)` → INSERT `Fine` + INSERT `Payment(status='pending')`
  8. INSERT `UserLockReason(reason='unpaid')` nếu chưa có + UPDATE `User.status='locked'`
  9. INSERT `AuditLog` cho CHECK_IN_DAMAGED/CHECK_IN_LOST
  10. `conn.commit()`; WHERE `SQLException` → `conn.rollback()`
  11. Async: `triggerIncidentFineEmailAsync()` — gửi email thông báo phạt (ngoài transaction)
  * WHERE có người chờ: SKIP FR-39 vì bản sao không được luân chuyển.
  * Việc resolve/reject/restore incident sau đó tuân theo F13 FR-48..50.
  * **⚠️ GAP hiện tại:** Hàm `processCheckInDamagedOrLost()` tại `DeskCirculationService.java:553-593` đã thực hiện bước 1-5 và 7-9, nhưng **bỏ qua hoàn toàn bước 6** (INSERT `BookCopyIncident`). Cần bổ sung ngay.
  * *Mapping:* UC-19 / BR-24
* **FR-38 (Nhận sách Nguyên vẹn với tính phạt trễ hạn):** WHEN CheckInServlet.doPost(barcode, condition='good', memberCode) được gọi, THE system SHALL mở DB Transaction: (1) BookCopyDAO.findByBarcode(), (2) BorrowRecordDAO.findActiveBorrowByBookCopyId(), (3) Tính số ngày trễ = (NOW() - BorrowRecord.endDate), WHERE số ngày > 0: amount = FINE_RATE_PER_DAY × số ngày trễ, INSERT Fine(borrowRecordId, userId, amount, status='unpaid', reason='overdue'), INSERT UserLockReason(userId, reason='unpaid'), UPDATE User.status='locked', (4) UPDATE BorrowRecord SET status='returned', returnedAt=NOW(), (5) UPDATE BookCopy SET condition='good', status='available' (tạm thời, sẽ đổi nếu có người chờ ở FR-39), (6) INSERT AuditLog(CHECKIN), (7) THEN gọi FR-39 để điều phối hàng chờ, (8) conn.commit(). (9) EmailService.enqueue(CHECKIN_CONFIRMATION) [async].
  * *Mapping:* UC-19
* **FR-39 (Điều phối Hàng chờ Check-in với tính HOLD_DAYS):** WHILE hệ thống nhận trả sách condition='good' VÀ hoàn tất cập nhật BorrowRecord, THE system SHALL truy vấn ReservationDAO.findNextInQueue(bookId) WHERE queuePosition = 1 AND status='pending'. WHERE tồn tại người chờ tiếp theo: (1) UPDATE Reservation SET queuePosition=0, status='readypickup', bookCopyId=?, endDate=NOW()+RESERVATION_HOLD_DAYS (từ SystemConfig), (2) UPDATE BookCopy SET status='reserved', (3) EmailService.enqueue(RESERVATION_READY, userId) [async]. WHERE KHÔNG có người chờ: (1) UPDATE Book.availableQuantity = availableQuantity + 1, (2) UPDATE BookCopy.status='available'. (Tất cả trong cùng 1 transaction của FR-38).
  * *Mapping:* UC-19
* **FR-40 (Xác nhận Thanh toán Tiền mặt với BR-25):** WHEN CashPaymentServlet.doPost(paymentId, memberCode) được gọi, THE system SHALL: (1) UserLookupDAO.findUserIdByMemberCode() → userId, (2) Mở DB Transaction: PaymentDAO.updatePaymentCompleted(paymentId, librarianId), FineDAO.updateStatusToPaid(fineId), UserLockReasonDAO.deleteLockReason(userId, 'unpaid'), (3) **Kiểm định mở khóa tự động theo BR-25**: COUNT(*) FROM UserLockReason WHERE userId=?, WHERE count = 0: UserDAO.updateStatusToActive(userId) [auto-unlock], WHERE count > 0: GIỮ NGUYÊN status='locked' (vì còn lý do khóa khác như 'adminban' hoặc 'securitybreach'), (4) INSERT AuditLog(CASH_PAYMENT), (5) conn.commit(), (6) EmailService.enqueue(PAYMENT_CONFIRMATION) [async].
  * *Mapping:* UC-20 / BR-25
* **FR-41 (DEPRECATED - Merged into FR-40):** Logic kiểm định mở khóa tự động đã được tích hợp vào FR-40 theo BR-25. Không còn sử dụng FR riêng biệt.
  * *Mapping:* (merged into FR-40)
* **FR-80 (Đăng ký đặt trước tại quầy):** WHEN DeskReservationServlet.doPost() nhận mã độc giả (memberCode) và mã sách/ISBN (bookIdOrIsbn), THE system SHALL: (1) Ánh xạ memberCode sang userId, (2) Xác định bookId từ ISBN/barcode/bookId, (3) Gọi OnlineCirculationService.reserveBook(userId, bookId, role) trong DB Transaction: thực hiện validate các quy tắc chặn nợ phạt (BR-22), giới hạn số lượng sách (BR-19), sau đó tạo bản ghi Reservation với queuePosition thích hợp, (4) Redirect về desk-dashboard kèm thông báo thành công.
  * *Mapping:* UC-51 / BR-41

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Ràng buộc: Giao dịch Check-out phải hoàn tất trong dưới 500ms để đảm bảo tốc độ tại quầy.
* Bảo mật: Chặn đứng mọi trường hợp mượn sách khi độc giả đang nợ phạt.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng BorrowRecord
* `borrowRecordId` (INT, PK)
* `userId` (INT, FK)
* `bookCopyId` (INT, FK)
* `startDate` (TIMESTAMP)
* `endDate` (TIMESTAMP)
* `returnedAt` (TIMESTAMP, NULL)
* `status` (VARCHAR(50))
* `createdBy` (INT)

### Bảng Fine
* `fineId` (INT, PK)
* `borrowRecordId` (INT, FK)
* `amount` (DECIMAL)
* `status` (VARCHAR(50))

### Bảng BookCopyIncident (Liên quan FR-37 — Tự động tạo khi check-in hỏng/mất)
* `incidentId` (INT, PK, AUTO_INCREMENT)
* `bookCopyId` (INT, FK → BookCopy) — **NOT NULL**
* `incidentType` (VARCHAR(20)) — CHECK IN ('damaged', 'lost') — **NOT NULL**
* `description` (VARCHAR(1000)) — **NOT NULL**, ví dụ: "Phát hiện khi trả sách — Mã mượn: BR-123"
* `status` (VARCHAR(20), DEFAULT 'pending') — CHECK IN ('pending', 'investigating', 'resolved', 'rejected')
* `resolution` (VARCHAR(1000), NULL) — Ghi chú kết luận sau khi F13 xử lý
* `reportedBy` (INT, FK → User) — **NOT NULL**, = librarianId khi check-in
* `reportedAt` (TIMESTAMP, DEFAULT NOW())
* `resolvedBy` (INT, FK → User, NULL)
* `resolvedAt` (TIMESTAMP, NULL)
* **Unique Index:** `UX_BookCopyIncident_Open` ON (bookCopyId) WHERE status IN ('pending', 'investigating') — Mỗi bản sao chỉ có tối đa 1 incident đang mở



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE độc giả đang bị khóa do nợ phạt, THE system SHALL ngăn chặn checkout và hiển thị cảnh báo đỏ trên màn hình thủ thư.
* WHERE barcode bản sao sách không tồn tại hoặc đang ở trạng thái 'unavailable', THE system SHALL báo lỗi.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Check-out hợp lệ: Độc giả không nợ phạt, sách có sẵn -> Tạo BorrowRecord thành công.
- [ ] Check-in trễ hạn: Trả sách trễ 3 ngày -> Tự động sinh khoản phạt 15,000đ, khóa tài khoản độc giả với lý do 'unpaid'.
- [ ] Trả sách hỏng/mất: bản sao ngừng lưu thông, không luân chuyển cho hàng chờ.
- [ ] **[MỚI] Tự động tạo BookCopyIncident:** Khi check-in với condition='damaged' hoặc 'lost', hệ thống phải tự động INSERT 1 bản ghi vào bảng `BookCopyIncident` với: `incidentType` = condition, `status` = 'pending', `reportedBy` = librarianId, `description` chứa mã mượn. Kiểm chứng bằng truy vấn DB sau check-in: `SELECT * FROM BookCopyIncident WHERE bookCopyId = ? AND status = 'pending'` phải trả về đúng 1 dòng.
- [ ] **[MỚI] Hiển thị incident trên trang Hỏng và mất:** Sau check-in hỏng/mất, bản ghi incident mới phải xuất hiện ngay trên trang `/librarian/book-management/incidents` với trạng thái 'Chờ xử lý'.

## 9. Out of Scope (Phạm vi không thực hiện)
* Thanh toán trả góp khoản phạt (phải thanh toán toàn bộ nợ mới được mở khóa mượn sách).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Spec mô tả hành vi chuẩn cần đồng bộ với F13 `feat-bookMaintenance`; nếu code còn khác state machine này thì phải tạo task sửa code thay vì hợp thức hóa mâu thuẫn trong SRS.
