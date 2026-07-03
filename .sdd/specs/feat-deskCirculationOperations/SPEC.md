# Feature Specification: Mượn và Trả sách tại quầy (Desk Circulation Operations)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Hỗ trợ Thủ thư (Librarian) xử lý trực tiếp các nghiệp vụ giao sách (Check-out) và nhận sách trả (Check-in) tại quầy thông qua thao tác quét mã vạch (Barcode) bản sao sách và mã độc giả.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Quét mã vạch mượn/trả sách, đánh giá tình trạng sách khi trả, thu phí phạt tiền mặt.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-22 (Strict Fine Enforcement):** Hệ thống BẮT BUỘC chặn giao dịch mượn sách nếu tồn tại bất kỳ bản ghi nào có reason = 'unpaid' trong bảng UserLockReason của người dùng.\n* **BR-23 (Direct Borrow Queue Policy):** Độc giả mượn sách trực tiếp tại quầy KHÔNG ĐƯỢC PHÉP mượn đầu sách đang có người xếp hàng chờ. Mọi giao dịch mượn trực tiếp đều BẮT BUỘC phải tự động sinh ra một Reservation ảo với queuePosition = 0 tại chỗ trước khi insert BorrowRecord.\n* **BR-24 (Damaged/Lost Inventory Deduction):** Khi nhận sách trả với tình trạng 'damaged' hoặc 'lost', hệ thống BẮT BUỘC trừ 1 đơn vị vào Book.totalQuantity. ĐỒNG THỜI, BẮT BUỘC phải insert tức thời bản ghi 'unpaid' vào UserLockReason và đổi status User thành 'locked'.\n* **BR-25 (Conditional Auto-Unlock):** Sau khi thanh toán tiền phạt (xóa reason 'unpaid'), hệ thống BẮT BUỘC đếm số lượng lý do khóa còn lại trong UserLockReason. CHỈ KHỞI ĐỘNG quy trình mở khóa (Update User.status = 'active') NẾU COUNT == 0.\n* **BR-29 (Walk-in vs Pre-reservation Checkout Policy):** Khi thực hiện Giao sách (Check-out) tại quầy, hệ thống BẮT BUỘC phân biệt trạng thái bản sao sách: Walk-in checkout chỉ chấp nhận BookCopy ở trạng thái 'available' và phải trừ availableQuantity của đầu sách đi 1; Pre-reservation checkout chỉ chấp nhận BookCopy ở trạng thái 'reserved' và KHÔNG được trừ availableQuantity.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-34 (Xử lý giao sách - Check-out):** WHEN thủ thư quét mã độc giả và barcode bản sao sách, THE system SHALL kiểm tra điều kiện chặn nợ phạt và hạn mức mượn. WHERE hợp lệ, chuyển BookCopy thành 'borrowed', chèn BorrowRecord mới và cập nhật sẵn số lượng.\n* **FR-35 (Xử lý nhận sách trả - Check-in):** WHEN thủ thư quét barcode sách trả, THE system SHALL tính toán xem sách có bị trễ hạn hay không và ghi nhận returnedAt. WHERE trễ hạn, tự động tạo khoản phạt Fine.\n* **FR-36 (Đánh giá tình trạng sách khi trả):** WHEN thực hiện trả sách, THE system SHALL cho phép thủ thư chọn tình trạng sách ('good', 'damaged', 'lost'). WHERE hỏng/mất, áp dụng BR-24 để khóa tài khoản độc giả lập tức và trừ totalQuantity.\n* **FR-37 (Tự động luân chuyển sách khi trả):** WHEN sách được trả mà có hàng đợi đang chờ, THE system SHALL tự động chuyển sách sang trạng thái 'reserved' và gán cho đơn đặt trước của độc giả tiếp theo.\n* **FR-38 (Duyệt thanh toán tiền mặt):** WHEN thủ thư xác nhận độc giả nộp tiền mặt, THE system SHALL tạo Payment status='completed', đóng khoản phạt và mở khóa tài khoản nếu đủ điều kiện.\n* **FR-39 (Kiểm tra giới hạn mượn theo vai trò):** WHEN check-out, THE system SHALL truy vấn cấu hình hạn mức tối đa của Student/Lecturer để đảm bảo không vượt quá số lượng sách cho phép.\n* **FR-40 (Quét mã barcode):** SYSTEM SHALL hỗ trợ quét hoặc nhập barcode trực tiếp trên biểu mẫu để tải nhanh thông tin độc giả/sách.\n* **FR-41 (Đăng ký đặt trước tại quầy):** WHEN độc giả yêu cầu tại quầy, THE system SHALL cho phép thủ thư tạo Reservation ảo thay thế.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Ràng buộc: Giao dịch Check-out phải hoàn tất trong dưới 500ms để đảm bảo tốc độ tại quầy.\n* Bảo mật: Chặn đứng mọi trường hợp mượn sách khi độc giả đang nợ phạt.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng BorrowRecord\n* `borrowRecordId` (INT, PK)\n* `userId` (INT, FK)\n* `bookCopyId` (INT, FK)\n* `startDate` (TIMESTAMP)\n* `endDate` (TIMESTAMP)\n* `returnedAt` (TIMESTAMP, NULL)\n* `status` (VARCHAR(50))\n* `createdBy` (INT)\n\n### Bảng Fine\n* `fineId` (INT, PK)\n* `borrowRecordId` (INT, FK)\n* `amount` (DECIMAL)\n* `status` (VARCHAR(50))\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE độc giả đang bị khóa do nợ phạt, THE system SHALL ngăn chặn checkout và hiển thị cảnh báo đỏ trên màn hình thủ thư.\n* WHERE barcode bản sao sách không tồn tại hoặc đang ở trạng thái 'unavailable', THE system SHALL báo lỗi.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Check-out hợp lệ: Độc giả không nợ phạt, sách có sẵn -> Tạo BorrowRecord thành công.\n- [ ] Check-in trễ hạn: Trả sách trễ 3 ngày -> Tự động sinh khoản phạt 15,000đ, khóa tài khoản độc giả với lý do 'unpaid'.\n- [ ] Trả sách hỏng: Độc giả trả sách bị rách nát -> Ghi nhận tình trạng 'damaged', trừ 1 totalQuantity của sách, khóa tài khoản độc giả.

## 9. Out of Scope (Phạm vi không thực hiện)
* Thanh toán trả góp khoản phạt (phải thanh toán toàn bộ nợ mới được mở khóa mượn sách).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
