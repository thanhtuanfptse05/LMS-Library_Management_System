# Feature Specification: Quản lý Hàng chờ Đặt trước dành cho Thủ thư (Librarian Reservation Queue Management)
# Version: 1.4 (CLARIFIED-NO-BOOKCOPY) | Chủ sở hữu: @tech-lead | Ngày cập nhật: 2026-07-31

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Sinh viên và Giảng viên đã có các chức năng đặt trước sách trực tuyến, xem vị trí hàng chờ cá nhân và tự hủy lượt đặt trước. 
Tính năng này tập trung xây dựng phân hệ **Quản lý Hàng chờ Đặt trước dành riêng cho Thủ thư (Librarian)** tại quầy lưu thông. Giúp Thủ thư dễ dàng tra cứu toàn bộ các lượt đặt trước trên hệ thống, theo dõi thứ tự hàng chờ từng tựa sách, chủ động hủy/can thiệp lượt đặt trước khi có sự cố hoặc theo yêu cầu trực tiếp từ độc giả.

*Ranh giới phạm vi tuyệt đối (Strict Scope Boundary):*
Tính năng này **HOÀN TOÀN KHÔNG XỬ LÝ BẤT KỲ THÔNG TIN HAY THAO TÁC NÀO LIÊN QUAN ĐẾN BẢN SAO SÁCH (`BookCopy`)**. Khi độc giả gắn với bản sao sách nghĩa là đã thuộc về thủ tục mượn sách (Check-out). Phân hệ này thuần túy quản lý các bản ghi đặt trước (`Reservation`) và thứ tự vị trí trong hàng đợi (`queuePosition`).

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Librarian (Thủ thư - Actor chính):**
  * Tra cứu, xem danh sách toàn bộ hàng chờ đặt trước của tất cả tựa sách.
  * Lọc danh sách theo tựa sách, mã độc giả (`studentCode`/`lecturerCode`), hoặc trạng thái (`pending`, `readypickup`, `fulfilled`, `cancelled`).
  * Hủy lượt đặt trước của bất kỳ độc giả nào (kèm lý do hủy thủ công của Thủ thư).
  * Tự động đôn vị trí hàng chờ và gửi email thông báo cho người tiếp theo khi một lượt bị hủy.
* **System (Hệ thống tự động):**
  * Đọc thời hạn giữ sách từ cấu hình hệ thống `SystemConfigurations` (khóa `RESERVATION_HOLD_DAYS`).
  * Tự động điều chỉnh `queuePosition` của các lượt chờ phía sau khi Thủ thư hủy lượt đặt trước.
  * Ghi nhật ký thao tác `AuditLogs` cho mọi hành động can thiệp của Thủ thư.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **[BR-LIB-RES-01] Quyền hạn Thủ thư:** Chỉ tài khoản thuộc vai trò `Librarian` (hoặc `Admin`/`LibraryManager`) mới được truy cập và thao tác trên giao diện Quản lý Hàng chờ Thủ thư (`/librarian/reservation-queue*`).
* **[BR-LIB-RES-02] Trạng thái & Vị trí Hàng chờ (Queue Model):**
  * `queuePosition = 0`: Người được suất sẵn sàng nhận sách (`status = 'readypickup'`).
  * `queuePosition = 1..N`: Các độc giả đang xếp hàng chờ (`status = 'pending'`).
  * Tuyệt đối không chứa thông tin bản sao sách (`BookCopy`) trong màn hình này.
* **[BR-LIB-RES-03] Đôn hàng chờ tự động khi Hủy lượt:**
  * Khi Thủ thư hủy lượt đặt trước ở suất `queuePosition = 0`, hệ thống tự động tìm người kế tiếp (`queuePosition = 1`), đôn lên `queuePosition = 0`, chuyển `status = 'readypickup'`, đặt hạn `endDate = NOW() + RESERVATION_HOLD_DAYS` và dịch chuyển hàng đợi phía sau (`decrementQueuePositions`).
  * Khi Thủ thư hủy lượt đặt trước ở vị trí `queuePosition > 0`, hệ thống thực hiện dịch hàng đợi phía sau (`shiftQueuePositions`).
* **[BR-LIB-RES-04] Thời hạn giữ sách theo Cấu hình:** Thời gian giữ sách `endDate` luôn lấy động từ `SystemConfigurations` (khóa `RESERVATION_HOLD_DAYS`), không fix cứng.
* **[BR-LIB-RES-05] Nhật ký Audit Log:** Mọi thao tác Hủy (`CANCEL_RESERVATION_BY_LIBRARIAN`) của Thủ thư phải lưu rõ `userId` người thực hiện, `reservationId` và lý do xử lý thủ công.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **[FR-LIB-RES-01] Màn hình Danh sách Hàng chờ Đặt trước:**
  * WHEN Thủ thư truy cập `/librarian/reservation-queue`, THE system SHALL hiển thị bảng danh sách tất cả các lượt đặt trước phân trang, bao gồm: Mã đặt trước, Tên tựa sách, Mã độc giả, Họ tên, Thứ tự hàng chờ (`queuePosition`), Trạng thái (`status`), Ngày đặt (`startDate`), Hạn nhận sách (`endDate`).
* **[FR-LIB-RES-02] Bộ lọc & Tra cứu linh hoạt:**
  * WHEN Thủ thư tìm kiếm theo từ khóa (tên sách, ISBN, mã sinh viên, tên độc giả) hoặc lọc theo trạng thái (`pending`, `readypickup`), THE system SHALL trả về kết quả truy vấn tương ứng tức thì.
* **[FR-LIB-RES-03] Thủ thư Hủy lượt đặt trước tại quầy:**
  * WHEN Thủ thư chọn "Hủy lượt đặt trước" và nhập lý do hủy, THE system SHALL gọi `OnlineCirculationService.cancelReservationByLibrarian`, cập nhật `status = 'cancelled'`, thực hiện đôn hàng chờ và gửi email cho người tiếp theo (nếu có).

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Phân quyền qua `@WebFilter` chặn người dùng vai role `Student`/`Lecturer` truy cập `/librarian/reservation-queue`.
* **Hiệu năng:** Tốc độ tải danh sách hàng chờ và lọc dữ liệu dưới 500ms. Thao tác hủy sách chạy trong 1 Database Transaction nguyên tử.
* **Giao diện:** 100% tiếng Việt, tối ưu hiển thị trên màn hình quầy thủ thư (Desktop / Tablet).

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
* `Reservation`: `reservationId`, `userId`, `bookId`, `status` (`'pending'`, `'readypickup'`, `'fulfilled'`, `'cancelled'`), `queuePosition`, `startDate`, `endDate`.
* `SystemConfigurations`: Đọc cấu hình `RESERVATION_HOLD_DAYS`.
* `AuditLogs`: Ghi vết `actionType = 'CANCEL_RESERVATION_BY_LIBRARIAN'`.

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** Thủ thư hủy lượt nhưng không nhập lý do hủy, **THE system SHALL** hiển thị thông báo lỗi "Vui lòng nhập lý do hủy lượt đặt trước."
* **WHERE** Lỗi kết nối CSDL khi đang đôn vị trí hàng chờ, **THE system SHALL** rollback toàn bộ và thông báo "Không thể xử lý hàng chờ, vui lòng thử lại."

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] **[TC-01]** Thủ thư xem được toàn bộ danh sách hàng chờ đặt trước và lọc theo mã độc giả / tên sách / trạng thái.
- [ ] **[TC-02]** Thủ thư hủy lượt đặt trước của độc giả thành công (kèm lý do), hệ thống đôn đúng vị trí `queuePosition` người phía sau và gửi email nếu người kế tiếp lên `queuePosition = 0`.
- [ ] **[TC-03]** Sinh viên/Giảng viên cố truy cập `/librarian/reservation-queue` bị Filter chặn và chuyển hướng về trang thông báo lỗi phân quyền.

## 9. Out of Scope (Phạm vi không thực hiện)
* **Không liên quan đến Bản sao sách (`BookCopy`):** Việc quét barcode, quản lý tình trạng hay gán bản sao sách cụ thể thuộc về quy trình **Check-out (Mượn sách)**.
* Không can thiệp đổi vai trò mượn sách trực tiếp ngoài quy định thư viện.

## 10. Clarifications (Các điểm đã làm rõ)
### Session 2026-07-31
- Q: Tính năng có xử lý thông tin hay bản sao sách (`BookCopy`) không? → A: Không. Tính năng quản lý hàng đợi cho thủ thư hoàn toàn không xử lý thông tin bản sao sách. Khi gắn với bản sao sách thì đã thuộc về quy trình mượn sách (Check-out).
