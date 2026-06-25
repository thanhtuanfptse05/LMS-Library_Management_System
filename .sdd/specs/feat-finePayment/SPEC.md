# SPEC.md — Fine & Payment Management (Quản lý Phạt & Thanh toán)
# Version: 1.1.0 | Owner: @antigravity | Status: DRAFT | Ngày cập nhật: 2026-06-24
# Mapping: UC-20, UC-31, UC-38, UC-39, UC-42 | BR-22, BR-24, BR-25, BR-35 | FR-40, FR-41, FR-53, FR-54, FR-61, FR-62, FR-63, FR-64, FR-65, FR-66

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
- Phân hệ **Fine & Payment Management (F9)** chịu trách nhiệm quản lý vòng đời các khoản tiền phạt (phát sinh từ trả sách trễ hạn, làm hỏng hoặc mất sách), cung cấp cơ chế thanh toán tiền mặt tại quầy và thanh toán trực tuyến qua cổng SePay bằng mã QR động.
- Đồng thời tích hợp tiến trình ngầm **Overdue Processor** tự động quét và tính phạt trễ hạn hàng đêm, giúp bảo vệ kho tài nguyên của thư viện và đảm bảo độc giả tuân thủ thời hạn mượn trả.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
- **Độc giả (Student/Lecturer):** Xem danh sách phạt của bản thân, thực hiện thanh toán online qua mã QR động (SePay).
- **Thủ thư (Librarian):** Tra cứu tình trạng nợ phạt của độc giả, duyệt thanh toán tiền mặt tại quầy.
- **Hệ thống (System):** Chạy tiến trình quét quá hạn tự động lúc 00:00 AM hằng đêm và tiếp nhận Webhook SePay để đối soát giao dịch tự động.

## 3. Business Rules (Quy tắc nghiệp vụ)
- **BR-35 (Quy tắc quét và phạt quá hạn):**
  - Giao dịch mượn (BorrowRecord) được coi là quá hạn khi trạng thái là `'borrowed'` VÀ ngày trả dự kiến (`endDate`) nhỏ hơn thời điểm hiện tại khi quét.
  - Số tiền phạt trễ hạn được tính bằng công thức: `Số ngày trễ hạn * FINE_RATE_PER_DAY`. Giá trị `FINE_RATE_PER_DAY` được lấy từ bảng `SystemConfigurations` (mặc định là 5,000 VND nếu không cấu hình).
  - Khi phát hiện trễ hạn, hệ thống đổi trạng thái BorrowRecord sang `'overdue'`, tạo bản ghi `Fine` trễ hạn trạng thái `'unpaid'`, thêm lý do khóa `'unpaid'` vào bảng `UserLockReason` và khóa tài khoản người dùng (`User.status = 'locked'`).
- **BR-22 (Chặn giao dịch khi nợ phạt):** Hệ thống chặn giao dịch mượn sách mới nếu tài khoản độc giả đang bị khóa do nợ phạt (`reason = 'unpaid'`).
- **BR-25 (Mở khóa có điều kiện):** Sau khi độc giả thanh toán hết nợ phạt (xóa lý do khóa `'unpaid'`), hệ thống chỉ mở khóa tài khoản (chuyển `User.status = 'active'`) khi số lượng lý do khóa còn lại trong bảng `UserLockReason` của độc giả đó bằng 0.
- **BR-F9-01 (Xác thực Webhook SePay):** Webhook của SePay gửi đến hệ thống bắt buộc phải kèm theo Header Authorization chứa API Key trùng khớp với cấu hình `SEPAY_API_KEY` trong bảng `SystemConfigurations` (nếu có cấu hình).
- **BR-F9-02 (Quy chuẩn Nội dung Chuyển khoản):** Nội dung chuyển khoản thanh toán trực tuyến bắt buộc phải có cú pháp `LMSPF<paymentId>` (không phân biệt hoa thường) để hệ thống trích xuất chính xác mã hóa đơn cần đối soát.

## 4. Functional Requirements (EARS)

### 4.1. Độc giả Tra cứu & Thanh toán Online
- **FR-53 (Hiển thị Hàng mượn & chờ sách):** WHEN người dùng truy cập trang "Hàng mượn & chờ sách", THE system SHALL truy vấn danh sách sách đang mượn, lịch sử mượn và các đơn đặt trước để hiển thị.
- **FR-54 (Liên kết Dashboard):** WHEN người dùng click vào các Stats Cards nợ phạt/sách mượn trên Dashboard, THE system SHALL điều hướng thẳng đến trang chi tiết tương ứng.
- **FR-64 (Hiển thị Lịch sử Phạt):** WHEN độc giả truy cập trang Quản lý phạt, THE system SHALL hiển thị danh sách các khoản phạt (`Fine`) kèm lý do phạt, số tiền, trạng thái (`unpaid` / `paid`), tổng nợ phạt hiện tại, nút bấm "Thanh toán Online" cho các khoản chưa đóng và hiển thị thông tin giao dịch VietQR đang chờ xử lý (`pending`) nếu có.
- **FR-65 (Tạo mã QR thanh toán SePay):** WHEN độc giả click "Thanh toán Online" cho một khoản phạt chưa đóng:
  - WHERE chưa có bản ghi `Payment` ở trạng thái `pending` liên kết với `fineId` này, THE system SHALL tạo mới bản ghi `Payment` với `status = 'pending'`, `paidAmount = Fine.amount`, và `paymentMethod = 'VietQR (SePay)'`.
  - THE system SHALL hiển thị mã VietQR động theo chuẩn Napas chứa: Số tài khoản, Mã ngân hàng, Tên chủ tài khoản lấy từ cấu hình hệ thống, số tiền cần đóng, và nội dung chuyển khoản bắt buộc dạng `LMSPF<paymentId>`.

### 4.2. Xử lý Giao dịch Tự động & Webhook SePay
- **FR-66 (Xử lý Webhook SePay):** WHEN nhận webhook POST từ SePay tại `/api/sepay-webhook`, THE system SHALL:
  1. Xác thực `Authorization` header với `SEPAY_API_KEY` trong DB.
  2. Parse JSON body lấy `content` (nội dung chuyển khoản), `transferAmount` (số tiền chuyển) và `referenceCode` (mã tham chiếu ngân hàng).
  3. Sử dụng Regex trích xuất mã hóa đơn `LMSPF<paymentId>` từ `content`.
  4. WHERE trích xuất thành công và tìm thấy bản ghi `Payment` khớp `paymentId` ở trạng thái `'pending'`:
     - So sánh `transferAmount` có lớn hơn hoặc bằng `Payment.paidAmount` không. WHERE hợp lệ, thực thi Database Transaction:
       * Cập nhật `Payment` (`status = 'completed'`, `transactionReference = referenceCode`, `paidAt = NOW()`).
       * Cập nhật `Fine` (`status = 'paid'`).
       * Thực hiện `DELETE` bản ghi có `reason = 'unpaid'` trong bảng `UserLockReason` tương ứng của độc giả.
       * Đếm số lượng lý do khóa còn lại của độc giả. WHERE bằng 0, cập nhật `User.status = 'active'`.
       * Ghi Audit Log hành động (`actionType = 'SEPAY_WEBHOOK_PAYMENT'`, `userId = NULL` đại diện cho Hệ thống).
       * Trả về JSON phản hồi HTTP 200 OK thành công cho SePay.

### 4.3. Thủ thư Duyệt Thanh toán Tiền mặt tại Quầy
- **FR-40 (Xác nhận Thanh toán Tiền mặt):** WHEN Thủ thư xác nhận độc giả đã đóng tiền mặt tại quầy cho khoản phạt và nhấn duyệt thanh toán, THE system SHALL thực thi một DB Transaction:
  1. Tạo bản ghi `Payment` (`status = 'completed'`, `paidAmount = Fine.amount`, `paymentMethod = 'Tiền mặt'`, `processedBy = librarianId`).
  2. Cập nhật `Fine.status = 'paid'`.
  3. `DELETE` bản ghi có `reason = 'unpaid'` trong bảng `UserLockReason` của độc giả.
- **FR-41 (Kiểm định Mở khóa Tự động):** WHILE hoàn tất duyệt thanh toán tiền mặt ở FR-40, THE system SHALL đếm số lượng lý do khóa còn lại của độc giả đó. WHERE số lý do bằng 0, hệ thống SHALL cập nhật `User.status = 'active'`. WHERE vẫn lớn hơn 0, hệ thống SHALL giữ trạng thái khóa tài khoản và hiển thị cảnh báo lý do còn lại.

### 4.4. Tiến trình quét quá hạn tự động (Overdue Processor)
- **FR-61 (Overdue Detection):** WHEN tiến trình ngầm Overdue Processor chạy (hằng đêm lúc 00:00 AM hoặc do SysAdmin click kích hoạt thủ công), THE system SHALL truy vấn tất cả các bản ghi mượn sách đang hoạt động (`BorrowRecord.status = 'borrowed'`) có hạn trả (`endDate`) nhỏ hơn ngày hiện tại.
- **FR-62 (Overdue Processing & Lock):** For each overdue record found, THE system SHALL thực thi Database Transaction riêng biệt:
  1. Cập nhật `BorrowRecord.status = 'overdue'`.
  2. Tính số ngày trễ hạn: `overdueDays = Current Date - endDate` (chỉ lấy phần ngày nguyên).
  3. Lấy `FINE_RATE_PER_DAY` từ cấu hình hệ thống (mặc định = 5,000) và tính `amount = overdueDays * FINE_RATE_PER_DAY`.
  4. `INSERT` bản ghi vào bảng `Fine` (status = 'unpaid', reason = "Trễ hạn X ngày").
  5. WHERE độc giả chưa có bản ghi lý do khóa `'unpaid'` trong `UserLockReason`, thực hiện `INSERT` vào `UserLockReason` với `reason = 'unpaid'` và `UPDATE` bảng `"User"` thiết lập `status = 'locked'`.
  6. Ghi Audit Log (`actionType = 'LOCK_USER'`, `userId = NULL` đại diện cho Hệ thống).
- **FR-63 (Gửi email thông báo trễ hạn):** WHEN xử lý xong DB cho mỗi độc giả quá hạn, THE system SHALL gọi `EmailService` để gửi bất đồng bộ email thông báo trễ hạn và nợ phạt cho độc giả đó.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
- **Độ tin cậy (Reliability):** Tiến trình ngầm phải xử lý tốt ngoại lệ (`SQLException`), không được làm rò rỉ kết nối JDBC.
- **Tính nguyên tử (Atomicity):** Giao dịch webhook SePay và thanh toán tiền mặt phải thực thi trong Database Transaction; nếu một bước lỗi bắt buộc phải rollback toàn bộ.
- **Bảo mật:** Webhook SePay phải được bảo vệ bằng API Key. Tuyệt đối không log thông tin nhạy cảm.

## 6. Database Schema & Data Models
Xem chi tiết cấu trúc các bảng: `BorrowRecord`, `Fine`, `Payment`, `UserLockReason`, `"User"`, `SystemConfigurations`, `AuditLogs` trong file `LMS_Schema_PostgreSQL.sql`.

## 7. Error Handling (Xử lý lỗi ngoại lệ)
- **WHERE** xảy ra lỗi `SQLException` trong tiến trình quét quá hạn, hệ thống SHALL rollback giao dịch của độc giả bị lỗi đó, ghi nhận log lỗi và tiếp tục xử lý các độc giả khác.
- **WHERE** webhook SePay gửi nội dung chuyển khoản sai định dạng hoặc không tìm thấy `paymentId`, hệ thống SHALL trả về HTTP 400 Bad Request kèm mô tả lỗi chi tiết cho SePay để kiểm tra và lưu vết giao dịch không thành công.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-F9-01] Xem danh sách phạt: Hiển thị đúng các khoản phạt kèm số tiền và lý do.
- [ ] [TC-F9-02] Kích hoạt thanh toán online: Sinh mã QR chứa đúng tài khoản và nội dung `LMSPF<paymentId>`.
- [ ] [TC-F9-03] SePay Webhook: Chuyển khoản đúng cú pháp -> tự động cập nhật Fine thành `paid`, xóa lock nợ phạt và tự mở khóa User nếu đủ điều kiện.
- [ ] [TC-F9-04] Thanh toán tiền mặt: Thủ thư nhấn duyệt -> cập nhật Fine thành `paid`, xóa lock và mở khóa User.
- [ ] [TC-F9-05] Quét quá hạn: Chạy tiến trình ngầm quét trễ hạn -> chuyển trạng thái record thành `overdue`, tính phạt, khóa User và gửi email.

## 9. Out of Scope (Phạm vi không thực hiện)
- Hệ thống **SHALL NOT** thực hiện trích nợ tự động tài khoản ngân hàng của người dùng.
- Hệ thống **SHALL NOT** hỗ trợ hoàn tiền (refund) trực tuyến thông qua cổng SePay.
