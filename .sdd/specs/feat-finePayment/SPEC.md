# Feature Specification: Quản lý Phạt và Thanh toán (Fine & Payment Management)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Quản lý việc tính toán tiền phạt trễ hạn tự động, hỗ trợ thanh toán tiền mặt tại quầy và tích hợp mã VietQR tự động qua cổng SePay để độc giả thanh toán trực tuyến.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Độc giả (User):** Xem lịch sử phạt, quét mã QR thanh toán trực tuyến.\n* **Thủ thư (Librarian):** Xác nhận thanh toán tiền mặt tại quầy.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-35 (Overdue Policy):** Giao dịch mượn ở trạng thái 'borrowed' có endDate nhỏ hơn thời điểm quét phải được coi là quá hạn. Hệ thống SHALL phạt 5,000 VND cho mỗi ngày trễ hạn và khóa tài khoản độc giả cho tới khi thanh toán xong.\n* **BR-25 (Conditional Auto-Unlock):** Sau khi thanh toán tiền phạt (xóa lý do 'unpaid'), hệ thống BẮT BUỘC đếm số lượng lý do khóa còn lại trong UserLockReason. CHỈ mở khóa tài khoản khi số lý do bằng 0.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-64 (Hiển thị Lịch sử Phạt độc giả):** WHEN độc giả truy cập mục phạt, THE system SHALL hiển thị toàn bộ lịch sử phạt, phân biệt đã đóng và chưa đóng, tính tổng tiền nợ.\n* **FR-65 (Tạo mã QR thanh toán tự động):** WHEN độc giả xem chi tiết khoản phạt chưa thanh toán, THE system SHALL tự động insert Payment ở trạng thái 'pending' (nếu chưa có) và hiển thị mã VietQR chứa mã thanh toán định dạng 'LMSPF{paymentId}'.\n* **FR-66 (Xử lý Webhook thanh toán SePay):** WHEN nhận webhook từ SePay, THE system SHALL parse nội dung giao dịch. WHERE khớp mã thanh toán, SHALL cập nhật trạng thái Payment='completed', Fine='paid', xóa lý do khóa 'unpaid' và mở khóa tài khoản nếu đủ điều kiện, gửi email xác nhận async.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Bảo mật: Xác thực API Key trong header webhook SePay để ngăn chặn webhook giả mạo.\n* Độ chính xác: Giao dịch tài chính bắt buộc sử dụng DB Transaction để tránh mất mát dữ liệu.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng Fine\n* `fineId` (INT, PK)\n* `borrowRecordId` (INT, FK)\n* `userId` (INT, FK)\n* `amount` (DECIMAL)\n* `status` (VARCHAR(50))\n* `createdAt` (TIMESTAMP)\n\n### Bảng Payment\n* `paymentId` (INT, PK)\n* `fineId` (INT, FK)\n* `paidAmount` (DECIMAL)\n* `paymentMethod` (VARCHAR(100))\n* `transactionReference` (VARCHAR(255), UNIQUE)\n* `processedBy` (INT)\n* `status` (VARCHAR(50))\n* `paidAt` (TIMESTAMP)\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE Webhook SePay truyền sai thông tin hoặc trùng transactionReference, THE system SHALL từ chối xử lý và ghi log.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Thanh toán online thành công: Độc giả chuyển khoản đúng nội dung -> Webhook nhận được, tự động mở khóa tài khoản ngay lập tức.\n- [ ] Xem lịch sử phạt: Hiển thị đúng số tiền nợ phạt tương ứng với số ngày quá hạn.

## 9. Out of Scope (Phạm vi không thực hiện)
* Hoàn tiền (refund) trực tuyến qua cổng thanh toán.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
