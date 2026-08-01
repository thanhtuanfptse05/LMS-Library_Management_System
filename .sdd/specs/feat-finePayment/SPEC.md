# Feature Specification: Quản lý tiền phạt & Thanh toán (Fine & Payment Management)
# Version: 1.3 | Chủ sở hữu: Tuan | Ngày cập nhật: 2026-07-26 (Chuẩn hóa UC-BR-FR registry)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp chức năng quản lý danh sách khoản phạt (`Fine`), thu tiền phạt mượn quá hạn hoặc hỏng/mất sách thông qua hai hình thức: Tiền mặt tại quầy (Thủ thư xử lý) hoặc Thanh toán chuyển khoản trực tuyến (Tích hợp Cổng thanh toán SePay / QR Code). Đồng thời tự động khôi phục quyền mượn sách cho độc giả sau khi hoàn tất thanh toán.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Sinh viên (Student) & Giảng viên (Lecturer):** Xem danh sách phiếu phạt của bản thân, thực hiện thanh toán trực tuyến qua mã QR (SePay).
* **Thủ thư (Librarian):** Tra cứu khoản phạt của độc giả, thu tiền phạt bằng tiền mặt tại quầy, chốt phiếu thanh toán.

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-31 (View My Borrowings & Reservations):** Actor: User (Student/Lecturer) | (Xem Hàng mượn & Chờ sách): Độc giả xem danh sách các sách đang mượn, lịch sử mượn và các đơn đặt trước (đang chờ hoặc đã sẵn sàng nhận) tại trang "Hàng mượn & chờ sách".
* **UC-38 (View Fine History):** Actor: User | (Xem lịch sử phạt): Người dùng xem danh sách các khoản phạt đã thanh toán và chưa thanh toán.
* **UC-39 (Pay Fine Online):** Actor: User | (Thanh toán phạt trực tuyến): Người dùng quét mã QR để thanh toán tiền phạt qua cổng thanh toán điện tử.
* **UC-42 (Run Overdue Processor):** Actor: System, SysAdmin | (Quét quá hạn tự động): Hệ thống tự động chạy định kỳ (hoặc SysAdmin kích hoạt thủ công) để quét các bản ghi mượn trễ hạn, tính tiền phạt, khóa tài khoản độc giả và gửi email thông báo.
* **UC-53 (Configure Payment Gateway Integration):** Actor: Admin | (Cấu hình cổng SePay QR): Quản trị viên cấu hình thông tin tích hợp SePay để sinh mã QR chuyển khoản thanh toán tiền phạt trực tuyến.

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F9 Fine & Payment Management. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-22 (Strict Fine Enforcement):** Hệ thống BẮT BUỘC chặn giao dịch mượn sách nếu tồn tại bất kỳ bản ghi nào có reason = 'unpaid' trong bảng UserLockReason của người dùng. KHÔNG trực tiếp kiểm tra bảng Fine để quyết định chặn giao dịch nhằm giữ tính độc lập dữ liệu.
* **BR-25 (Conditional Auto-Unlock):** Sau khi thanh toán tiền phạt (xóa reason 'unpaid'), hệ thống BẮT BUỘC đếm số lượng lý do khóa còn lại trong UserLockReason. CHỈ KHỞI ĐỘNG quy trình mở khóa (Update User.status = 'active') NẾU COUNT == 0. Tuyệt đối không mở khóa nếu tài khoản đang bị 'adminban' hoặc 'securitybreach'.
* **BR-31 (System Config Authorization):** Admin chỉ được phép xem và cập nhật các config thuộc nhóm 'library' hoặc cấu hình tích hợp SePay. Admin có toàn quyền với mọi nhóm config.
* **BR-35 (Overdue Policy):** Giao dịch mượn (BorrowRecord) ở trạng thái 'borrowed' có endDate nhỏ hơn thời điểm quét phải được coi là quá hạn. Hệ thống SHALL phạt 5,000 VND (hoặc theo cấu hình FINE_RATE_PER_DAY) cho mỗi ngày trễ hạn và khóa tài khoản độc giả cho tới khi thanh toán xong.
* **BR-53 (Payment Config Group Access):** Admin chỉ có quyền xem và sửa các cấu hình có prefix `SEPAY_`. Việc phân quyền sửa cấu hình SePay được kiểm soát nghiêm ngặt ở tầng Service.
* **BR-75 (Fine Visibility):** The system SHALL display the complete history of both paid and unpaid fines to the user.
* **BR-80 (Payment Configuration Access):** The system SHALL strictly isolate payment gateway settings from general system configurations.


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-53 (Hiển thị Hàng mượn & chờ sách với trạng thái):** WHEN MyBorrowingsServlet.doGet() được gọi, THE system SHALL: (1) BorrowRecordDAO.findActiveBorrowsByUser(userId) → JOIN Book, BookCopy để lấy {borrowRecordId, bookTitle, barcode, startDate, endDate, extensionCount, daysUntilDue, isOverdue}, (2) ReservationDAO.findActiveReservationsByUser(userId) → JOIN Book, BookCopy (nếu có) để lấy {reservationId, bookTitle, queuePosition, status, createdAt, endDate (nếu readypickup), barcode (nếu có)}, (3) Tính toán các flag: isOverdue = (endDate < NOW()), canRenew = (extensionCount < MAX_EXTENSION_COUNT AND không có người chờ), canCancel = (status='pending' OR status='readypickup'), (4) Forward sang JSP với {activeBorrows, activeReservations} để hiển thị.
  * *Mapping:* UC-31
* **FR-54 (Liên kết chuyển hướng Dashboard với stats cards):** WHEN StudentDashboardServlet hoặc LecturerDashboardServlet.doGet() được gọi, THE system SHALL tổng hợp dữ liệu: (1) activeLoansCount = BorrowRecordDAO.countActiveBorrowsByUser(userId), (2) dueSoonCount = BorrowRecordDAO.countDueSoonByUser(userId, 3) — số sách hạn trả trong 3 ngày, (3) reservedCount = ReservationDAO.countActiveReservationsByUser(userId), (4) totalFines = FineDAO.getTotalUnpaidFinesByUser(userId), (5) activeLoans = BorrowRecordDAO.findActiveBorrowsByUser(userId) JOIN Book (top 5), (6) recentLoans = BorrowRecordDAO.findRecentByUser(userId, limit=5), (7) recommendations = AiRecommendationService.getRecommendationsForUser(userId) [cache trong session]. THEN forward sang dashboard.jsp với các stats cards có link: "Sách đang mượn" → /{role}/my-borrowings, "Sách quá hạn" → /{role}/my-borrowings?filter=overdue, "Tiền phạt" → /{role}/fines.
  * *Mapping:* UC-31
* **FR-61 (Quét quá hạn tự động theo cơ chế Lazy Load):** WHEN các Controller/Service liên quan (LibrarianDashboardServlet, DeskDashboardServlet, CheckInServlet, CashPaymentServlet, StudentDashboardServlet, LecturerDashboardServlet, OnlineCirculationService.reserveBook, RenewalServlet) được truy cập hoặc thực thi, THE system SHALL tự động gọi OverdueProcessor.processOverdue() [Lazy Load]: (1) Truy vấn BorrowRecordDAO.findOverdueBorrows(NOW()) để lấy tất cả BorrowRecord WHERE status='borrowed' AND endDate < NOW(), (2) Ghi log số lượng overdue tìm được, (3) Với mỗi overdue BorrowRecord: gọi FR-62 để xử lý phạt + khóa tài khoản trong transaction riêng biệt.
  * *Mapping:* UC-42 / BR-35
* **FR-62 (Xử lý phạt quá hạn và khóa tài khoản tức thì):** For each overdue BorrowRecord found trong FR-61, THE system SHALL mở DB Transaction: (1) Tính số ngày trễ = DATEDIFF(NOW(), BorrowRecord.endDate), (2) Lấy FINE_RATE_PER_DAY từ SystemConfig (default 5000 VNĐ), tính amount = daysLate × FINE_RATE_PER_DAY, (3) INSERT Fine(borrowRecordId, userId, amount, status='unpaid', reason='overdue', createdAt=NOW()), (4) UPDATE BorrowRecord SET status='overdue' WHERE borrowRecordId=?, (5) **Khóa tài khoản tức thì theo BR-22**: INSERT UserLockReason(userId, reason='unpaid', createdAt=NOW()), UPDATE User SET status='locked' WHERE userId=?, (6) INSERT AuditLog(CREATE_FINE_OVERDUE, actorId=NULL), (7) conn.commit(), (8) EmailService.enqueue(OVERDUE_NOTICE, userId, templateData={bookTitle, daysLate, fineAmount}) [async, ngoài transaction].
  * *Mapping:* UC-42 / BR-22, BR-35
* **FR-63 (Gửi email thông báo trễ hạn async):** WHEN FR-62 hoàn tất thành công xử lý DB cho một overdue BorrowRecord, THE system SHALL gọi EmailService.sendOverdueNotificationEmail(userId, fineId) [async]. EmailService sẽ: (1) Lấy DocumentTemp WHERE tempName='OVERDUE_NOTICE', (2) Render template với biến {userName, bookTitle, dueDate, daysLate, fineAmount, libraryContactInfo}, (3) Enqueue email vào background worker (ExecutorService) với subject="Thông báo sách quá hạn - {bookTitle}", (4) Background worker gửi email qua SMTP/SendGrid, (5) Ghi log email sent. WHERE email fail: retry 3 lần, sau đó ghi error log.
  * *Mapping:* UC-42
* **FR-64 (Hiển thị Lịch sử Phạt của Độc giả với Payment status):** WHEN MemberFinesServlet.doGet() được gọi (đã xử lý ở FR-65 - tự động tạo Payment), THE system SHALL: (1) FineDAO.findByUserId(userId) ORDER BY createdAt DESC → lấy tất cả Fine, (2) Với mỗi Fine: LEFT JOIN Payment để lấy {paymentId, paymentStatus, paidAt, method, transactionReference}, (3) Tính toán flags: isPaid = (Fine.status='paid'), hasPendingPayment = (paymentStatus='pending'), (4) Tính totalUnpaid = SUM(amount WHERE status='unpaid'), unpaidCount = COUNT(*), (5) Forward sang fines.jsp với {fines[], totalUnpaid, unpaidCount, sePayConfig}. JSP hiển thị: Fine unpaid → button "Thanh toán Online" (nếu có paymentId) hoặc "Thanh toán tại quầy", Fine paid → badge "Đã thanh toán" + paidAt + method.
  * *Mapping:* UC-38 / BR-75
* **FR-65 (Tạo mã QR thanh toán SePay tự động):** WHEN MemberFinesServlet.doGet() được gọi, THE system SHALL: (1) Lấy danh sách Fine của userId từ FineDAO, (2) Với mỗi Fine có status='unpaid' VÀ paymentId=NULL, TỰ ĐỘNG INSERT Payment(fineId, userId, amount=Fine.amount, method='BankTransfer', status='pending', createdAt=NOW()), (3) Tính totalUnpaid = SUM(Fine.amount WHERE status='unpaid'), (4) Lấy cấu hình SePay từ SystemConfigDAO: SEPAY_ACCOUNT_NUMBER, SEPAY_BANK_CODE, SEPAY_ACCOUNT_NAME, (5) Forward sang JSP với dữ liệu {fines, totalUnpaid, unpaidCount, SePay config}. JSP sẽ sinh mã VietQR cho từng khoản phạt với nội dung="LMSPF{paymentId}".
  * *Mapping:* UC-39 / BR-80
* **FR-66 (Xử lý Webhook thanh toán SePay với Parse JSON thủ công):** WHEN SePayWebhookServlet.doPost() nhận webhook, THE system SHALL: (1) **Xác thực tùy chọn**: IF SystemConfig có SEPAY_API_KEY, đọc header Authorization, WHERE không khớp: trả 401 Unauthorized, (2) **Parse JSON thủ công** (không dùng thư viện): Đọc request body, dùng regex tìm "content":"([^"]*)", "code":"([^"]*)", "transferAmount":([0-9.]+), "referenceCode":"([^"]*)", (3) Dùng regex LMSPF(\\d+) tìm paymentId trong content+code, WHERE không tìm thấy: trả JSON {success:false, message:"Không tìm thấy mã thanh toán"}, (4) **Mở DB Transaction** (conn.setAutoCommit(false)): PaymentDAO.updatePaymentOnlineSuccess(paymentId, transactionReference, transferAmount), FineDAO.updateStatusToPaid(fineId), SELECT userId FROM Fine WHERE fineId=?, UserLockReasonDAO.deleteLockReason(userId, 'unpaid'), countLockReasonsByUserId(userId) → IF = 0: UserDAO.updateStatusToActive(userId), AuditLogDAO.insert(SEPAY_WEBHOOK_PAYMENT, userId=NULL, entityName='Payment', entityId=paymentId), conn.commit(), (5) **Gửi email xác nhận** (ngoài transaction): EmailService.sendPaymentConfirmationEmail(paymentId, userId, "BankTransfer") [async], (6) Trả JSON {success:true, message:"Thanh toán thành công"}.
  * *Mapping:* UC-39 / BR-25, BR-80
* **FR-82 (Cấu hình cổng SePay QR):** WHEN PaymentConfigServlet.doGet() được gọi, THE system SHALL truy vấn từ SystemConfigDAO tất cả các cấu hình có prefix `SEPAY_` để hiển thị lên giao diện quản lý. WHEN doPost() nhận key và value mới, hệ thống SHALL gọi SystemConfigService.update() để cập nhật giá trị vào DB, ghi Audit Log và reload cache config.
  * *Mapping:* UC-53 / BR-31, BR-53, BR-80


## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Giao dịch thanh toán tài chính phải được bảo vệ tính toàn vẹn, chống trùng lặp mã giao dịch (`transactionReference` UNIQUE).
* **Hiệu năng:** Xử lý callback thanh toán trực tuyến SePay trong dưới 1 giây.
* **Giao diện:** Đồ họa tiếng Việt 100%, hiển thị mã QR VietQR động chứa đúng số tiền phạt và nội dung chuyển khoản.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `Fine`
* `fineId` (INT, PK), `borrowRecordId` (FK), `userId` (FK), `amount` (DECIMAL), `reason`, `status` (unpaid/paid/waived), `createdAt`

### Bảng `Payment`
* `paymentId` (INT, PK), `fineId` (FK), `paidAmount` (DECIMAL), `paymentMethod` (cash/sepay/vnpay), `transactionReference` (VARCHAR, UNIQUE), `processedBy` (INT, NULL, FK REFERENCES `"User"`), `status` (completed/failed), `paidAt`

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** số tiền thanh toán không đủ so với khoản phạt, **THE system SHALL** từ chối chốt phiếu và báo lỗi "Số tiền thanh toán chưa đủ".
* **WHERE** mã giao dịch SePay bị lặp lại, **THE system SHALL** bỏ qua giao dịch trùng lặp và ghi log cảnh báo.

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-FINE-01] Thu tiền phạt tiền mặt tại quầy cập nhật trạng thái phiếu phạt thành 'paid' và lưu processedBy thủ thư.
- [ ] [TC-FINE-02] Quét mã QR SePay thanh toán trực tuyến cập nhật tiền phạt thành công qua Webhook.
- [ ] [TC-FINE-03] Thanh toán hết nợ phạt tự động giải phóng tài khoản khỏi danh sách bị giới hạn mượn sách.
- [ ] [TC-FINE-04] Mọi thao tác thu tiền phạt tạo bản ghi lưu vết trong AuditLogs.

## 8. Out of Scope (Phạm vi không thực hiện)
* Hoàn tiền phạt cho độc giả trực tiếp qua cổng ngân hàng trực tuyến.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện thu tiền phạt tiền mặt và tích hợp webhook SePay QR Code.
