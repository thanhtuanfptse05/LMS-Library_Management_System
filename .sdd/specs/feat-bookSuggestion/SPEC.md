# Feature Specification: Đề xuất mua sách mới (Book Suggestion)
# Version: 1.2 | Chủ sở hữu: @bao | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cho phép độc giả (Sinh viên, Giảng viên) gửi đề xuất cho Thư viện bổ sung các đầu sách mới chưa có trong kho. Quản lý Thư viện có thể duyệt, từ chối hoặc đánh dấu đã nhập sách, giúp thư viện xây dựng nguồn tài liệu bám sát nhu cầu học tập và nghiên cứu.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Sinh viên (Student) & Giảng viên (Lecturer):** Gửi đề xuất mua sách mới, xem trạng thái các yêu cầu đề xuất của bản thân.
* **Quản lý Thư viện (Library Manager):** Xem danh sách đề xuất từ độc giả, phê duyệt (Approve), từ chối (Reject) kèm lý do, hoặc chuyển trạng thái đã mua (Acquired).

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-27 (Submit Book Suggestion):** Actor: Student/Lecturer | Gửi biểu mẫu đề xuất mua sách mới (Tên sách, Tác giả, Nhà xuất bản, Lý do đề xuất).
* **UC-28 (Review Book Suggestion):** Actor: Library Manager | Duyệt hoặc từ chối các yêu cầu đề xuất mua sách của độc giả.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-28 (Suggestion Limit):** Mỗi độc giả không được gửi quá 3 đề xuất ở trạng thái `pending` trong cùng một tháng.
* **BR-29 (Duplicate Check):** Đề xuất sách mới không được trùng với tên sách đã có sẵn trong CSDL thư viện ở trạng thái `active`.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-29 (Gửi đề xuất sách mới):** WHEN độc giả gửi yêu cầu tại `BookSuggestionServlet`, THE system SHALL kiểm tra hạn mức đề xuất trong tháng và đối chiếu tên sách với CSDL. WHERE hợp lệ, hệ thống tạo bản ghi trong `BookSuggestion` với `status='pending'`.
  * *Mapping:* UC-27 / BR-28, BR-29
* **FR-30 (Phê duyệt/Từ chối đề xuất):** WHEN Quản lý Thư viện xử lý đề xuất, THE system SHALL: WHERE chấp nhận, UPDATE `status='approved'`. WHERE từ chối, UPDATE `status='rejected'` và lưu `rejectionReason`. THEN hệ thống tạo thông báo gửi tới độc giả qua `NotificationDAO`. Ghi `AuditLogs`.
  * *Mapping:* UC-28

## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Phân quyền bắt buộc đối với Manager cho các thao tác phê duyệt. Đảm bảo dữ liệu người đề xuất được bảo mật.
* **Giao diện:** Đồ họa thân thiện 100% tiếng Việt, hiển thị rõ ràng tiến trình xử lý đề xuất.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `BookSuggestion`
* `suggestionId` (INT, PK), `userId` (FK REFERENCES `"User"`), `title`, `author`, `publisher`, `reason`, `status` (pending/approved/rejected/acquired), `rejectionReason`, `createdAt`, `updatedAt`

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** độc giả vượt quá 3 đề xuất/tháng, **THE system SHALL** báo lỗi "Bạn đã đạt giới hạn 3 đề xuất trong tháng này".
* **WHERE** sách đã có trong thư viện, **THE system SHALL** gợi ý độc giả chuyển sang trang tìm kiếm sách hiện có.

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-SUGG-01] Gửi đề xuất sách mới thành công và hiển thị trong danh sách chờ duyệt của cá nhân.
- [ ] [TC-SUGG-02] Quản lý phê duyệt đề xuất thành công và gửi thông báo tới độc giả.
- [ ] [TC-SUGG-03] Từ chối đề xuất yêu cầu nhập lý do từ chối và cập nhật đúng trạng thái.

## 8. Out of Scope (Phạm vi không thực hiện)
* Khai báo dự toán kinh phí mua sách trực tiếp trên hệ thống LMS.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện luồng đề xuất mua sách từ độc giả đến quản lý.
