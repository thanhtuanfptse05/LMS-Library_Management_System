# Feature Specification: Quản lý Phạt và Thanh toán (Fine & Payment Management)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Quản lý việc tính toán tiền phạt trễ hạn tự động, hỗ trợ thanh toán tiền mặt tại quầy và tích hợp mã VietQR tự động qua cổng SePay để độc giả thanh toán trực tuyến.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Độc giả (User):** Xem lịch sử phạt, quét mã QR thanh toán trực tuyến.
* **Thủ thư (Librarian):** Xác nhận thanh toán tiền mặt tại quầy.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-31 (View My Borrowings & Reservations):** Actor: User (Student/Lecturer) | (Xem Hàng mượn & Chờ sách): Độc giả xem danh sách các sách đang mượn, lịch sử mượn và các đơn đặt trước (đang chờ hoặc đã sẵn sàng nhận) tại trang "Hàng mượn & chờ sách".
* **UC-38 (View Fine History):** Actor: User | (Xem lịch sử phạt): Người dùng xem danh sách các khoản phạt đã thanh toán và chưa thanh toán.
* **UC-39 (Pay Fine Online):** Actor: User | (Thanh toán phạt trực tuyến): Người dùng quét mã QR để thanh toán tiền phạt qua cổng thanh toán điện tử.
* **UC-42 (Run Overdue Processor):** Actor: System, SysAdmin | (Quét quá hạn tự động): Hệ thống tự động chạy định kỳ (hoặc SysAdmin kích hoạt thủ công) để quét các bản ghi mượn trễ hạn, tính tiền phạt, khóa tài khoản độc giả và gửi email thông báo.
* **UC-53 (Configure Payment Gateway Integration):** Actor: Library Manager | (Cấu hình cổng SePay QR): Quản lý thư viện cấu hình thông tin tích hợp SePay để sinh mã QR chuyển khoản thanh toán tiền phạt trực tuyến.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-31 (View My Borrowings & Reservations):** Actor: User (Student/Lecturer) | (Xem Hàng mượn & Chờ sách): Độc giả xem danh sách các sách đang mượn, lịch sử mượn và các đơn đặt trước (đang chờ hoặc đã sẵn sàng nhận) tại trang "Hàng mượn & chờ sách".
* **UC-38 (View Fine History):** Actor: User | (Xem lịch sử phạt): Người dùng xem danh sách các khoản phạt đã thanh toán và chưa thanh toán.
* **UC-39 (Pay Fine Online):** Actor: User | (Thanh toán phạt trực tuyến): Người dùng quét mã QR để thanh toán tiền phạt qua cổng thanh toán điện tử.
* **UC-42 (Run Overdue Processor):** Actor: System, SysAdmin | (Quét quá hạn tự động): Hệ thống tự động chạy định kỳ (hoặc SysAdmin kích hoạt thủ công) để quét các bản ghi mượn trễ hạn, tính tiền phạt, khóa tài khoản độc giả và gửi email thông báo.
* **UC-53 (Configure Payment Gateway Integration):** Actor: Library Manager | (Cấu hình cổng SePay QR): Quản lý thư viện cấu hình thông tin tích hợp SePay để sinh mã QR chuyển khoản thanh toán tiền phạt trực tuyến.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-31 (View My Borrowings & Reservations):** Actor: User (Student/Lecturer) | (Xem Hàng mượn & Chờ sách): Độc giả xem danh sách các sách đang mượn, lịch sử mượn và các đơn đặt trước (đang chờ hoặc đã sẵn sàng nhận) tại trang "Hàng mượn & chờ sách".
* **UC-38 (View Fine History):** Actor: User | (Xem lịch sử phạt): Người dùng xem danh sách các khoản phạt đã thanh toán và chưa thanh toán.
* **UC-39 (Pay Fine Online):** Actor: User | (Thanh toán phạt trực tuyến): Người dùng quét mã QR để thanh toán tiền phạt qua cổng thanh toán điện tử.
* **UC-42 (Run Overdue Processor):** Actor: System, SysAdmin | (Quét quá hạn tự động): Hệ thống tự động chạy định kỳ (hoặc SysAdmin kích hoạt thủ công) để quét các bản ghi mượn trễ hạn, tính tiền phạt, khóa tài khoản độc giả và gửi email thông báo.
* **UC-53 (Configure Payment Gateway Integration):** Actor: Library Manager | (Cấu hình cổng SePay QR): Quản lý thư viện cấu hình thông tin tích hợp SePay để sinh mã QR chuyển khoản thanh toán tiền phạt trực tuyến.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-35 (Overdue Policy):** Giao dịch mượn (BorrowRecord) ở trạng thái 'borrowed' có endDate nhỏ hơn thời điểm quét phải được coi là quá hạn. Hệ thống SHALL phạt 5,000 VND (hoặc theo cấu hình FINE_RATE_PER_DAY) cho mỗi ngày trễ hạn và khóa tài khoản độc giả cho tới khi thanh toán xong.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-53 (Hiển thị Hàng mượn & chờ sách với trạng thái):** WHEN MyBorrowingsServlet.doGet() được gọi, THE system SHALL: (1) BorrowRecordDAO.findActiveBorrowsByUser(userId) → JOIN Book, BookCopy để lấy {borrowRecordId, bookTitle, barcode, startDate, endDate, extensionCount, daysUntilDue, isOverdue}, (2) ReservationDAO.findActiveReservationsByUser(userId) → JOIN Book, BookCopy (nếu có) để lấy {reservationId, bookTitle, queuePosition, status, createdAt, endDate (nếu readypickup), barcode (nếu có)}, (3) Tính toán các flag: isOverdue = (endDate < NOW()), canRenew = (extensionCount < MAX_EXTENSION_COUNT AND không có người chờ), canCancel = (status='pending' OR status='readypickup'), (4) Forward sang JSP với {activeBorrows, activeReservations} để hiển thị.
  * *Mapping:* UC-31
* **FR-54 (Liên kết chuyển hướng Dashboard với stats cards):** WHEN StudentDashboardServlet hoặc LecturerDashboardServlet.doGet() được gọi, THE system SHALL tổng hợp dữ liệu: (1) activeLoansCount = BorrowRecordDAO.countActiveBorrowsByUser(userId), (2) dueSoonCount = BorrowRecordDAO.countDueSoonByUser(userId, 3) — số sách hạn trả trong 3 ngày, (3) reservedCount = ReservationDAO.countActiveReservationsByUser(userId), (4) totalFines = FineDAO.getTotalUnpaidFinesByUser(userId), (5) activeLoans = BorrowRecordDAO.findActiveBorrowsByUser(userId) JOIN Book (top 5), (6) recentLoans = BorrowRecordDAO.findRecentByUser(userId, limit=5), (7) recommendations = AiRecommendationService.getRecommendationsForUser(userId) [cache trong session]. THEN forward sang dashboard.jsp với các stats cards có link: "Sách đang mượn" → /{role}/my-borrowings, "Sách quá hạn" → /{role}/my-borrowings?filter=overdue, "Tiền phạt" → /{role}/fines.
  * *Mapping:* UC-31
* **FR-61 (Quét quá hạn tự động với cron job):** WHEN OverdueProcessor chạy định kỳ (scheduled 00:00 AM hằng đêm) hoặc TriggerOverdueServlet được admin kích hoạt thủ công, THE system SHALL: (1) Truy vấn BorrowRecordDAO.findOverdueBorrows(NOW()) để lấy tất cả BorrowRecord WHERE status='borrowed' AND endDate < NOW(), (2) Ghi log số lượng overdue tìm được, (3) Với mỗi overdue BorrowRecord: gọi FR-62 để xử lý phạt + khóa tài khoản, (4) Đếm số lượng: processedRecords, lockedUsers, emailsSent, (5) INSERT AuditLog(RUN_OVERDUE_PROCESSOR, actorId=NULL, details={processedRecords, lockedUsers}), (6) Trả về JSON {success:true, processedRecords, lockedUsers, emailsSent} cho admin monitor.
  * *Mapping:* UC-42 / BR-35
* **FR-62 (Xử lý phạt quá hạn và khóa tài khoản tức thì):** For each overdue BorrowRecord found trong FR-61, THE system SHALL mở DB Transaction: (1) Tính số ngày trễ = DATEDIFF(NOW(), BorrowRecord.endDate), (2) Lấy FINE_RATE_PER_DAY từ SystemConfig (default 5000 VNĐ), tính amount = daysLate × FINE_RATE_PER_DAY, (3) INSERT Fine(borrowRecordId, userId, amount, status='unpaid', reason='overdue', createdAt=NOW()), (4) UPDATE BorrowRecord SET status='overdue' WHERE borrowRecordId=?, (5) **Khóa tài khoản tức thì theo BR-24**: INSERT UserLockReason(userId, reason='unpaid', createdAt=NOW()), UPDATE User SET status='locked' WHERE userId=?, (6) INSERT AuditLog(CREATE_FINE_OVERDUE, actorId=NULL), (7) conn.commit(), (8) EmailService.enqueue(OVERDUE_NOTICE, userId, templateData={bookTitle, daysLate, fineAmount}) [async, ngoài transaction].
  * *Mapping:* UC-42 / BR-22, BR-24, BR-35
* **FR-63 (Gửi email thông báo trễ hạn async):** WHEN FR-62 hoàn tất thành công xử lý DB cho một overdue BorrowRecord, THE system SHALL gọi EmailService.sendOverdueNotificationEmail(userId, fineId) [async]. EmailService sẽ: (1) Lấy DocumentTemp WHERE tempName='OVERDUE_NOTICE', (2) Render template với biến {userName, bookTitle, dueDate, daysLate, fineAmount, libraryContactInfo}, (3) Enqueue email vào background worker (ExecutorService) với subject="Thông báo sách quá hạn - {bookTitle}", (4) Background worker gửi email qua SMTP/SendGrid, (5) Ghi log email sent. WHERE email fail: retry 3 lần, sau đó ghi error log.
  * *Mapping:* UC-42
* **FR-64 (Hiển thị Lịch sử Phạt của Độc giả với Payment status):** WHEN MemberFinesServlet.doGet() được gọi (đã xử lý ở FR-65 - tự động tạo Payment), THE system SHALL: (1) FineDAO.findByUserId(userId) ORDER BY createdAt DESC → lấy tất cả Fine, (2) Với mỗi Fine: LEFT JOIN Payment để lấy {paymentId, paymentStatus, paidAt, method, transactionReference}, (3) Tính toán flags: isPaid = (Fine.status='paid'), hasPendingPayment = (paymentStatus='pending'), (4) Tính totalUnpaid = SUM(amount WHERE status='unpaid'), unpaidCount = COUNT(*), (5) Forward sang fines.jsp với {fines[], totalUnpaid, unpaidCount, sePayConfig}. JSP hiển thị: Fine unpaid → button "Thanh toán Online" (nếu có paymentId) hoặc "Thanh toán tại quầy", Fine paid → badge "Đã thanh toán" + paidAt + method.
  * *Mapping:* UC-38
* **FR-65 (Tạo mã QR thanh toán SePay tự động):** WHEN MemberFinesServlet.doGet() được gọi, THE system SHALL: (1) Lấy danh sách Fine của userId từ FineDAO, (2) Với mỗi Fine có status='unpaid' VÀ paymentId=NULL, TỰ ĐỘNG INSERT Payment(fineId, userId, amount=Fine.amount, method='BankTransfer', status='pending', createdAt=NOW()), (3) Tính totalUnpaid = SUM(Fine.amount WHERE status='unpaid'), (4) Lấy cấu hình SePay từ SystemConfigDAO: SEPAY_ACCOUNT_NUMBER, SEPAY_BANK_CODE, SEPAY_ACCOUNT_NAME, (5) Forward sang JSP với dữ liệu {fines, totalUnpaid, unpaidCount, SePay config}. JSP sẽ sinh mã VietQR cho từng khoản phạt với nội dung="LMSPF{paymentId}".
  * *Mapping:* UC-39
* **FR-66 (Xử lý Webhook thanh toán SePay với Parse JSON thủ công):** WHEN SePayWebhookServlet.doPost() nhận webhook, THE system SHALL: (1) **Xác thực tùy chọn**: IF SystemConfig có SEPAY_API_KEY, đọc header Authorization, WHERE không khớp: trả 401 Unauthorized, (2) **Parse JSON thủ công** (không dùng thư viện): Đọc request body, dùng regex tìm "content":"([^"]*)", "code":"([^"]*)", "transferAmount":([0-9.]+), "referenceCode":"([^"]*)", (3) Dùng regex LMSPF(\\d+) tìm paymentId trong content+code, WHERE không tìm thấy: trả JSON {success:false, message:"Không tìm thấy mã thanh toán"}, (4) **Mở DB Transaction** (conn.setAutoCommit(false)): PaymentDAO.updatePaymentOnlineSuccess(paymentId, transactionReference, transferAmount), FineDAO.updateStatusToPaid(fineId), SELECT userId FROM Fine WHERE fineId=?, UserLockReasonDAO.deleteLockReason(userId, 'unpaid'), countLockReasonsByUserId(userId) → IF = 0: UserDAO.updateStatusToActive(userId), AuditLogDAO.insert(SEPAY_WEBHOOK_PAYMENT, userId=NULL, entityName='Payment', entityId=paymentId), conn.commit(), (5) **Gửi email xác nhận** (ngoài transaction): EmailService.sendPaymentConfirmationEmail(paymentId, userId, "BankTransfer") [async], (6) Trả JSON {success:true, message:"Thanh toán thành công"}.
  * *Mapping:* UC-39 / BR-25
* **FR-82 (Cấu hình cổng SePay QR):** WHEN ManagerPaymentConfigServlet.doGet() được gọi, THE system SHALL truy vấn từ SystemConfigDAO tất cả các cấu hình có prefix `SEPAY_` để hiển thị lên giao diện quản lý. WHEN doPost() nhận key và value mới, hệ thống SHALL gọi SystemConfigService.update() để cập nhật giá trị vào DB, ghi Audit Log và reload cache config.
  * *Mapping:* UC-53 / BR-31, BR-53

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Bảo mật: Xác thực API Key trong header webhook SePay để ngăn chặn webhook giả mạo.
* Độ chính xác: Giao dịch tài chính bắt buộc sử dụng DB Transaction để tránh mất mát dữ liệu.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng Fine
* `fineId` (INT, PK)
* `borrowRecordId` (INT, FK)
* `userId` (INT, FK)
* `amount` (DECIMAL)
* `status` (VARCHAR(50))
* `createdAt` (TIMESTAMP)

### Bảng Payment
* `paymentId` (INT, PK)
* `fineId` (INT, FK)
* `paidAmount` (DECIMAL)
* `paymentMethod` (VARCHAR(100))
* `transactionReference` (VARCHAR(255), UNIQUE)
* `processedBy` (INT)
* `status` (VARCHAR(50))
* `paidAt` (TIMESTAMP)



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE Webhook SePay truyền sai thông tin hoặc trùng transactionReference, THE system SHALL từ chối xử lý và ghi log.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Thanh toán online thành công: Độc giả chuyển khoản đúng nội dung -> Webhook nhận được, tự động mở khóa tài khoản ngay lập tức.
- [ ] Xem lịch sử phạt: Hiển thị đúng số tiền nợ phạt tương ứng với số ngày quá hạn.

## 9. Out of Scope (Phạm vi không thực hiện)
* Hoàn tiền (refund) trực tuyến qua cổng thanh toán.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.