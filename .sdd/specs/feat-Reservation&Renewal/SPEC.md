# Feature Specification: Đặt trước & Gia hạn sách (Reservation & Renewal)
# Version: 1.2 | Chủ sở hữu: @bao | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp chức năng cho phép Sinh viên và Giảng viên chủ động Đặt trước (Reservation) các đầu sách mong muốn khi hết bản sao sẵn có, và Yêu cầu Gia hạn (Renewal) thời gian mượn sách trực tuyến mà không cần đến quầy thư viện, tuân thủ các quy định chính sách của hệ thống.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Sinh viên (Student) & Giảng viên (Lecturer):** Thực hiện đặt giữ chỗ sách trực tuyến, thực hiện yêu cầu gia hạn thời gian mượn sách.
* **Thủ thư (Librarian):** Xác nhận giữ chỗ tại quầy khi độc giả đến nhận sách theo đơn đặt trước.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-19 (Reserve Book):** Actor: Student/Lecturer | Đặt giữ chỗ trước cho một đầu sách.
* **UC-20 (Renew Borrowing):** Actor: Student/Lecturer | Gia hạn thêm thời hạn trả cho phiếu mượn đang trong hạn.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-20 (Reservation Hold Period):** Đơn đặt trước có hiệu lực giữ sách tối đa 48 giờ kể từ khi có bản sao sẵn có. Sau 48 giờ không đến nhận, hệ thống tự động đổi trạng thái `expired` và giữ chỗ cho người tiếp theo trong hàng chờ (queuePosition).
* **BR-21 (Renewal Limits):** Số lần gia hạn tối đa (`maxExtensionCount`, mặc định 2 lần) và số ngày gia hạn thêm được cấu hình trong `SystemConfigurations` phân biệt theo vai trò (Student vs Lecturer).
* **BR-22 (Renewal Blockers):** KHÔNG CHO PHÉP gia hạn nếu: (1) Sách đã quá hạn trả, (2) Độc giả đang nợ tiền phạt chưa thanh toán, (3) Đầu sách đang có độc giả khác đặt trước trong hàng chờ.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-31 (Đặt trước sách & Hàng chờ):** WHEN độc giả gửi yêu cầu đặt trước tại `ReservationServlet`, THE system SHALL kiểm tra trạng thái tài khoản. WHERE tài khoản không bị nợ phạt hoặc bị khóa, hệ thống tạo bản ghi `Reservation` với `queuePosition` tiếp theo. WHERE có bản sao sẵn có, hệ thống cập nhật `BookCopy.status='reserved'` và đặt thời hạn nhận sách `endDate = NOW() + 48 hours`.
  * *Mapping:* UC-19 / BR-20
* **FR-32 (Tự động hết hạn đơn đặt trước):** WHEN hệ thống chạy tiến trình quét hạn đặt trước, WHERE `NOW() > Reservation.endDate` và `status='pending'`, THE system SHALL đổi `status='expired'`, giải phóng `BookCopy.status='available'` hoặc chuyển quyền giữ chỗ cho `queuePosition` tiếp theo.
  * *Mapping:* UC-19 / BR-20
* **FR-33 (Gia hạn thời gian mượn):** WHEN độc giả gửi yêu cầu gia hạn tại `RenewalServlet`, THE system SHALL gọi `DeskCirculationService.renewBook()`. Hệ thống kiểm tra: `extensionCount < maxExtensions` VÀ `returnedAt IS NULL` VÀ `NOW() <= endDate` VÀ không có ai khác đặt trước. WHERE tất cả hợp lệ, hệ thống tăng `extensionCount` thêm 1, cộng thêm số ngày gia hạn vào `endDate`, và ghi `AuditLogs`.
  * *Mapping:* UC-20 / BR-21, BR-22

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