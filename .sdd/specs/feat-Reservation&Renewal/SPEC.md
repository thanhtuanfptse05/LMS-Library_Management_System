# Feature Specification: Đặt trước và Gia hạn trực tuyến (Online Reservation & Renewal)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cho phép Độc giả (Sinh viên/Giảng viên) đặt trước sách trực tuyến khi sách đã hết hoặc gia hạn thời gian mượn đối với các cuốn sách đang mượn trực tiếp trên tài khoản cá nhân.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Độc giả (Student/Lecturer):** Đặt trước sách, hủy đặt trước, gia hạn mượn sách trực tuyến.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-19 (Reservation Eligibility):** Độc giả BẮT BUỘC chỉ được phép thực hiện Đặt trước hoặc Gia hạn trực tuyến nếu tài khoản đang ở trạng thái hoạt động (status = 'active') VÀ không bị khóa vì bất kỳ lý do nợ phạt nào.\n* **BR-20 (Queue Positioning Strategy):** Vị trí hàng đợi queuePosition = 0 DÀNH RIÊNG cho việc giữ sách đã sẵn sàng lấy (status = 'readypickup'). Mọi yêu cầu chờ sách (khi availableQuantity = 0) BẮT BUỘC phải có queuePosition > 0 và trạng thái 'pending'.\n* **BR-21 (Renewal Constraints):** Giao dịch mượn (BorrowRecord) chỉ được phép gia hạn nếu thỏa mãn ĐỒNG THỜI 3 điều kiện: (1) Thời gian mượn đã qua % quy định, (2) extensionCount chưa vượt mức tối đa trong SystemConfigurations, (3) KHÔNG có bất kỳ Reservation nào có queuePosition > 0 đang chờ cho cùng tựa sách đó.\n* **BR-36 (Reservation Pickup Limit):** Đơn đặt trước ở trạng thái 'readypickup' chỉ được giữ tại quầy trong một khoảng thời gian giới hạn được xác định bởi cấu hình RESERVATION_HOLD_DAYS trong bảng SystemConfigurations (mặc định là 3 ngày). Nếu quá thời hạn này, đơn hàng sẽ tự động bị hủy và giải phóng bản sao sách.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-29 (Yêu cầu đặt trước sách):** WHEN độc giả nhấn đặt trước sách, THE system SHALL kiểm tra trạng thái hoạt động và nợ phạt. WHERE hợp lệ và còn sách, đặt queuePosition=0 và status='readypickup'. WHERE hết sách, xếp vào hàng đợi với queuePosition > 0 và status='pending'.\n* **FR-30 (Hủy đặt trước trực tuyến):** WHEN độc giả chủ động hủy đặt trước, THE system SHALL cập nhật trạng thái Reservation thành 'cancelled' và đôn hàng chờ của các độc giả phía sau lên 1 vị trí.\n* **FR-31 (Gia hạn thời hạn mượn):** WHEN độc giả yêu cầu gia hạn, THE system SHALL kiểm tra số lần gia hạn hiện tại và hàng đợi. WHERE thỏa mãn, gia hạn ngày trả và tăng extensionCount.\n* **FR-32 (Hủy đặt trước hết hạn tự động):** WHEN Background Job chạy quét các đơn 'readypickup' quá hạn, THE system SHALL tự động hủy đơn và đôn hàng chờ cho người tiếp theo hoặc trả bản sao về trạng thái khả dụng.\n* **FR-33 (Thông báo sách sẵn sàng nhận):** WHEN có bản sao sách trống được gán cho người chờ đầu tiên (queuePosition chuyển từ 1 sang 0), THE system SHALL cập nhật trạng thái đơn thành 'readypickup' và enqueue email thông báo async.\n* **FR-53 (Hiển thị danh sách đang mượn & đặt trước):** WHEN độc giả truy cập trang cá nhân, THE system SHALL hiển thị chi tiết các sách đang mượn, trạng thái quá hạn và danh sách các sách đang xếp hàng chờ.\n* **FR-78 (Hủy đặt trước trực tuyến Servlet):** WHEN nhận request POST hủy, THE system SHALL gọi nghiệp vụ hủy đặt trước, cập nhật hàng chờ, ghi Audit Log và chuyển hướng.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Ràng buộc: Độc giả bị khóa do nợ phạt hoặc vi phạm bảo mật không thể thực hiện đặt trước hay gia hạn.\n* Hiệu năng: Thời gian cập nhật hàng đợi dưới 200ms.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng Reservation\n* `reservationId` (INT, PK)\n* `userId` (INT, FK)\n* `bookId` (INT, FK)\n* `bookCopyId` (INT, FK, NULL)\n* `status` (VARCHAR(50))\n* `queuePosition` (INT)\n* `startDate` (TIMESTAMP)\n* `endDate` (TIMESTAMP)\n\n### Bảng BorrowRecord\n* `borrowRecordId` (INT, PK)\n* `userId` (INT, FK)\n* `bookCopyId` (INT, FK)\n* `status` (VARCHAR(50))\n* `extensionCount` (INT)\n* `endDate` (TIMESTAMP)\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE độc giả bị khóa do nợ phạt, THE system SHALL chặn yêu cầu và hiển thị thông báo 'Tài khoản bị khóa do chưa hoàn thành tiền phạt'.\n* WHERE sách đã hết lượt gia hạn tối đa, THE system SHALL hiển thị thông báo 'Bạn đã vượt quá số lần gia hạn tối đa cho phép'.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Đặt trước sách còn sẵn: Đặt trước thành công -> Trạng thái 'readypickup', queuePosition = 0, gán sẵn bản sao vật lý.\n- [ ] Gia hạn sách có người đang chờ: Sách đang có hàng đợi (queuePosition > 0) -> Hệ thống từ chối gia hạn và hiển thị thông báo.\n- [ ] Hủy đặt trước: Độc giả hủy đơn đang ở vị trí số 2 -> Đơn vị trí số 3 tự động chuyển lên vị trí số 2.

## 9. Out of Scope (Phạm vi không thực hiện)
* Độc giả tự thay đổi vị trí của mình trong hàng đợi đặt trước.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
