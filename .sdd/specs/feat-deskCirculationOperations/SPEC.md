# Feature Specification: Giao dịch mượn trả tại quầy (Desk Circulation Operations)
# Version: 1.2 | Chủ sở hữu: @thai | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp công cụ cho Thủ thư (Librarian) thực hiện các thao tác Mượn sách (`Check-out`) và Trả sách (`Check-in`) trực tiếp tại quầy lưu thông thông qua quét mã vạch Barcode, xử lý trả sách quá hạn, tự động tính tiền phạt và ghi nhận trạng thái sách hư hỏng/thất lạc.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Thực hiện mượn/trả sách cho độc giả tại quầy, kiểm tra tình trạng sách khi trả, ghi nhận quá hạn và khởi tạo phiếu phạt.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-22 (Desk Check-out):** Actor: Librarian | Quét mã độc giả và mã vạch sách để lập phiếu mượn mới tại quầy.
* **UC-23 (Desk Check-in):** Actor: Librarian | Quét mã vạch sách để nhận lại sách, kiểm tra tình trạng và chốt phiếu mượn.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-23 (Borrow Limits & Policy):** Độc giả chỉ được mượn tối đa số sách quy định (`maxBorrowLimit`, ví dụ: Sinh viên 5 quyển, Giảng viên 10 quyển). Thời hạn mượn mặc định (ví dụ: Sinh viên 14 ngày, Giảng viên 30 ngày) được cấu hình trong `SystemConfigurations`.
* **BR-30 (Block Borrowing on Fine):** Không cho phép mượn sách mới nếu độc giả đang có tiền phạt chưa thanh toán (`unpaid`) hoặc có sách quá hạn chưa trả.
* **BR-31 (Fine Calculation Rate):** Tiền phạt mượn quá hạn được tự động tính theo công thức: `Số ngày quá hạn x Mức phạt theo ngày` (ví dụ: 5,000 VNĐ / ngày quá hạn), lấy từ cấu hình `FINE_RATE_PER_DAY`.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-34 (Quy trình Mượn sách - Check-out):** WHEN Thủ thư nhập mã độc giả và quét mã vạch sách tại `CheckOutServlet`, THE system SHALL gọi `DeskCirculationService.checkoutBook()`. Hệ thống kiểm tra: (1) Độc giả active, không nợ phạt, chưa vượt quá hạn mức mượn, (2) Bản sao `BookCopy` có `status='available'` (hoặc `reserved` cho chính độc giả này). WHERE hợp lệ, tạo `BorrowRecord` mới, đổi `BookCopy.status='borrowed'`, giảm `availableQuantity` của `Book` bớt 1, và ghi `AuditLogs`.
  * *Mapping:* UC-22 / BR-23, BR-30
* **FR-35 (Quy trình Trả sách - Check-in):** WHEN Thủ thư quét mã vạch sách trả tại `CheckInServlet`, THE system SHALL gọi `DeskCirculationService.checkinBook()`. Hệ thống cập nhật `BorrowRecord.returnedAt = NOW()`, đổi `status='returned'`, đổi `BookCopy.status='available'`, và tăng `availableQuantity` của `Book` thêm 1.
  * *Mapping:* UC-23
* **FR-36 (Tự động tính phạt quá hạn & hư hỏng):** WHERE ngày trả `returnedAt` vượt quá ngày hẹn trả `endDate`, THE system SHALL tự động tính số tiền phạt và chèn bản ghi mới vào bảng `Fine` với `status='unpaid'`, lý do "Mượn quá hạn X ngày". WHERE sách bị trả trong tình trạng hư hỏng/mất, tạo phiếu phạt tương ứng giá trị sách. Ghi `AuditLogs`.
  * *Mapping:* UC-23 / BR-31

## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Hiệu năng:** Xử lý thao tác quét barcode và chốt phiếu mượn/trả trong dưới 200ms để tránh ùn tắc tại quầy.
* **Bảo mật:** Phân quyền bắt buộc role LIBRARIAN. Mọi thao tác mượn trả bắt buộc ghi Audit Log người thực hiện (`createdBy`).
* **Giao diện:** Tích hợp âm thanh/thông báo trực quan khi quét barcode thành công hoặc thất bại.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `BorrowRecord`
* `borrowRecordId` (INT, PK), `userId` (FK), `bookCopyId` (FK), `bookId` (FK), `startDate`, `endDate`, `returnedAt`, `status` (borrowing/returned/overdue), `extensionCount`, `createdBy` (FK)

### Bảng `Fine`
* `fineId` (INT, PK), `borrowRecordId` (FK), `userId` (FK), `amount` (DECIMAL), `reason`, `status` (unpaid/paid/waived), `createdAt`

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** độc giả đang vượt quá hạn mức mượn, **THE system SHALL** từ chối tạo phiếu mượn và thông báo "Độc giả đã mượn tối đa số sách cho phép".
* **WHERE** mã vạch sách không ở trạng thái 'available', **THE system SHALL** báo lỗi "Sách hiện không có sẵn để mượn (Đã mượn/Đang bảo trì)".

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-CIRC-01] Quét mượn sách thành công tạo đúng bản ghi BorrowRecord và giảm số lượng sách sẵn có.
- [ ] [TC-CIRC-02] Quét trả sách đúng hạn cập nhật returnedAt và trả lại trạng thái available cho bản sao.
- [ ] [TC-CIRC-03] Quét trả sách quá hạn tự động tạo bản ghi Fine với số tiền tính chính xác theo số ngày trễ.
- [ ] [TC-CIRC-04] Độc giả đang nợ tiền phạt bị hệ thống ngăn chặn không cho mượn tiếp.

## 8. Out of Scope (Phạm vi không thực hiện)
* Tự động mượn trả bằng trạm Robot tự phục vụ (Self Check-in Kiosk hardware).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện toàn bộ luồng giao dịch mượn trả tại quầy với hỗ trợ quét mã vạch Barcode.
