# Feature Specification: Quản lý tiền phạt & Thanh toán (Fine & Payment Management)
# Version: 1.2 | Chủ sở hữu: @quyet | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp chức năng quản lý danh sách khoản phạt (`Fine`), thu tiền phạt mượn quá hạn hoặc hỏng/mất sách thông qua hai hình thức: Tiền mặt tại quầy (Thủ thư xử lý) hoặc Thanh toán chuyển khoản trực tuyến (Tích hợp Cổng thanh toán SePay / QR Code). Đồng thời tự động khôi phục quyền mượn sách cho độc giả sau khi hoàn tất thanh toán.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Sinh viên (Student) & Giảng viên (Lecturer):** Xem danh sách phiếu phạt của bản thân, thực hiện thanh toán trực tuyến qua mã QR (SePay).
* **Thủ thư (Librarian):** Tra cứu khoản phạt của độc giả, thu tiền phạt bằng tiền mặt tại quầy, chốt phiếu thanh toán.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-29 (View Fines):** Actor: Student/Lecturer/Librarian | Xem danh sách các khoản phạt mượn quá hạn hoặc sự cố sách.
* **UC-30 (Pay Fine Cash):** Actor: Librarian | Thu tiền phạt bằng tiền mặt tại quầy và ghi nhận vào hệ thống.
* **UC-31 (Pay Fine Online):** Actor: Student/Lecturer | Thanh toán tiền phạt trực tuyến thông qua quét mã QR SePay.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-32 (Payment Transaction Atomicity):** Thao tác thanh toán BẮT BUỘC thực hiện trong DB Transaction: (1) Tạo bản ghi `Payment` với trạng thái `completed`, (2) Cập nhật `Fine.status = 'paid'`, (3) Kiểm tra nếu độc giả không còn khoản nợ nào khác, tự động xóa `reason = 'unpaid'` trong `UserLockReason`.
* **BR-33 (DB Mapping Constraint):** Người xử lý thanh toán được lưu trữ trong cột `processedBy INT NULL` của bảng `Payment` (với tiền mặt lưu `userId` Thủ thư, trực tuyến lưu `NULL`).
* **BR-34 (Auto Account Unlocking on Clear Fines):** Khi nợ phạt được giải quyết 100%, hệ thống tự động gỡ bỏ cảnh báo nợ phạt và cho phép độc giả tiếp tục mượn sách.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-37 (Thu tiền phạt Tiền mặt):** WHEN Thủ thư chốt thu tiền mặt tại `CashPaymentServlet`, THE system SHALL mở DB Transaction: (1) Chèn bản ghi `Payment(fineId, paidAmount, paymentMethod='cash', processedBy=librarianId, status='completed')`, (2) UPDATE `Fine.status='paid'`, (3) Gọi `checkAndUnlockUnpaidAccount(userId)`. Ghi `AuditLogs` với action `PAYMENT_CASH`.
  * *Mapping:* UC-30 / BR-32, BR-33, BR-34
* **FR-38 (Thanh toán phạt Trực tuyến SePay):** WHEN độc giả quét mã QR SePay để thanh toán, Cổng thanh toán SePay gửi Webhook callback, THE system SHALL đối chiếu `transactionReference` và số tiền. WHERE hợp lệ, hệ thống tạo `Payment(paymentMethod='sepay', processedBy=NULL, status='completed')`, UPDATE `Fine.status='paid'` và tự động mở khóa tài khoản nếu hết nợ.
  * *Mapping:* UC-31 / BR-32, BR-33, BR-34
* **FR-39 (Truy vấn & Tra cứu tiền phạt):** WHEN độc giả hoặc Thủ thư truy cập trang phạt, THE system SHALL hiển thị chi tiết số tiền, lý do phạt, ngày tạo và trạng thái (`unpaid` / `paid` / `waived`).
  * *Mapping:* UC-29

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