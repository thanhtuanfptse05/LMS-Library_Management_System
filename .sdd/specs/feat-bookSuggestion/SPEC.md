# Feature Specification: Đề xuất mua sách mới (Book Suggestion)
# Version: 1.3 | Chủ sở hữu: TBD | Ngày cập nhật: 2026-07-26 (Chuẩn hóa UC-BR-FR registry)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cho phép độc giả (Sinh viên, Giảng viên) gửi đề xuất cho Thư viện bổ sung các đầu sách mới chưa có trong kho. Quản lý Thư viện có thể duyệt, từ chối hoặc đánh dấu đã nhập sách, giúp thư viện xây dựng nguồn tài liệu bám sát nhu cầu học tập và nghiên cứu.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Sinh viên (Student) & Giảng viên (Lecturer):** Gửi đề xuất mua sách mới, xem trạng thái các yêu cầu đề xuất của bản thân.
* **Quản lý Thư viện (Library Manager):** Xem danh sách đề xuất từ độc giả, phê duyệt (Approve), từ chối (Reject) kèm lý do, hoặc chuyển trạng thái đã mua (Acquired).

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-55 (Submit & Vote Book Suggestion):** Actor: Lecturer | (Đề xuất & Vote sách mới): Giảng viên gửi đề xuất sách mới cần bổ sung cho thư viện hoặc vote (+1) cho đề xuất có sẵn của giảng viên khác. Giảng viên cũng có thể hủy vote và sửa/xóa đề xuất của mình khi còn ở trạng thái pending.
* **UC-56 (Manage Book Suggestion Status):** Actor: Librarian | (Quản lý trạng thái đề xuất sách): Thủ thư xem danh sách đề xuất sách từ giảng viên, xét duyệt và cập nhật trạng thái (pending / acknowledged / rejected) kèm ghi chú lý do. =============================================================================

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F20 Book Suggestion. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-56 (Book Suggestion Vote Uniqueness):** Mỗi Giảng viên SHALL chỉ được vote tối đa 1 lần cho mỗi đề xuất sách. Hệ thống BẮT BUỘC kiểm tra tính duy nhất trước khi ghi nhận vote.
* **BR-57 (Book Suggestion Vote Restriction):** Tính năng vote (+1) và hủy vote CHỈ ĐƯỢC PHÉP thực hiện khi đề xuất sách còn ở trạng thái 'pending'. Khi status = 'acknowledged' hoặc 'rejected', hệ thống MUST NOT cho phép vote mới hoặc hủy vote.
* **BR-58 (Book Suggestion Edit/Delete Restriction):** Giảng viên CHỈ ĐƯỢC PHÉP sửa hoặc xóa (soft-delete) đề xuất sách của chính mình KHI VÀ CHỈ KHI status = 'pending' VÀ voteCount = 1 (chỉ có vote của chính mình). Nếu có người khác đã vote hoặc trạng thái đã thay đổi, hệ thống MUST NOT cho phép sửa/xóa.
* **BR-82 (Suggestion Status Finality):** The system SHALL freeze book suggestions from further updates once marked as rejected. =============================================================================


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-119 (Gửi đề xuất sách mới):** WHEN BookSuggestionServlet.doPost(action=create) nhận form đề xuất từ Giảng viên, THE system SHALL: (1) Validate các trường bắt buộc (title, author, reason), (2) Kiểm tra tiêu đề tương tự đã tồn tại (LIKE query), WHERE trùng THE system SHALL hiển thị cảnh báo, (3) INSERT vào bảng BookSuggestion với status='pending', voteCount=1, (4) INSERT bản ghi SuggestionVote tương ứng, (5) INSERT AuditLog(CREATE_SUGGESTION), (6) Redirect kèm thông báo thành công.
  * *Mapping:* UC-55 / BR-56
* **FR-120 (Vote đề xuất sách):** WHEN BookSuggestionServlet.doPost(action=vote) nhận request vote từ Giảng viên, THE system SHALL mở DB Transaction: (1) Kiểm tra đề xuất tồn tại và status='pending', (2) Kiểm tra user chưa vote cho đề xuất này (BR-56), WHERE đã vote THE system SHALL trả lỗi "Bạn đã vote cho đề xuất này", (3) INSERT SuggestionVote(suggestionId, userId), (4) UPDATE BookSuggestion SET voteCount = voteCount + 1, (5) conn.commit(), (6) Redirect kèm thông báo.
  * *Mapping:* UC-55 / BR-56, BR-57
* **FR-121 (Hủy vote đề xuất sách):** WHEN BookSuggestionServlet.doPost(action=unvote) nhận request hủy vote từ Giảng viên, THE system SHALL mở DB Transaction: (1) Kiểm tra đề xuất tồn tại và status='pending' (BR-57), WHERE status ≠ 'pending' THE system SHALL từ chối, (2) Kiểm tra user đã vote, (3) DELETE bản ghi SuggestionVote, (4) UPDATE BookSuggestion SET voteCount = voteCount - 1, (5) conn.commit().
  * *Mapping:* UC-55 / BR-57
* **FR-122 (Sửa đề xuất sách):** WHEN BookSuggestionServlet.doPost(action=edit) nhận request sửa đề xuất, THE system SHALL: (1) Kiểm tra đề xuất thuộc về user hiện tại, (2) Kiểm tra status='pending' VÀ voteCount=1 (BR-58), WHERE không thỏa THE system SHALL từ chối, (3) UPDATE các trường được phép (title, author, publisher, isbn, reason), (4) INSERT AuditLog(UPDATE_SUGGESTION).
  * *Mapping:* UC-55 / BR-58
* **FR-123 (Xóa mềm đề xuất sách):** WHEN BookSuggestionServlet.doPost(action=delete) nhận request xóa đề xuất, THE system SHALL: (1) Kiểm tra đề xuất thuộc về user, (2) Kiểm tra status='pending' VÀ voteCount=1 (BR-58), (3) UPDATE BookSuggestion SET status='deleted', (4) DELETE bản ghi SuggestionVote liên quan, (5) INSERT AuditLog(DELETE_SUGGESTION). Soft-delete tuân thủ DATA-01.
  * *Mapping:* UC-55 / BR-58
* **FR-124 (Xem danh sách đề xuất sách - Giảng viên):** WHEN BookSuggestionServlet.doGet() được gọi bởi Lecturer, THE system SHALL: (1) Đọc params tìm kiếm (keyword), lọc (status), phân trang (page, pageSize=10), (2) Truy vấn BookSuggestionDAO với JOIN User để lấy tên người đề xuất, (3) Sắp xếp mặc định theo voteCount DESC, (4) Kiểm tra user hiện tại đã vote cho từng đề xuất chưa, (5) Forward sang lecturer/book-suggestions.jsp với danh sách và trạng thái vote.
  * *Mapping:* UC-55
* **FR-125 (Xem danh sách đề xuất sách - Thủ thư):** WHEN BookSuggestionServlet.doGet() được gọi bởi Librarian, THE system SHALL: (1) Đọc params tìm kiếm và lọc tương tự FR-124, (2) Truy vấn danh sách đề xuất với JOIN User, (3) Sắp xếp mặc định theo voteCount DESC, (4) Forward sang librarian/book-suggestions.jsp với giao diện quản lý trạng thái.
  * *Mapping:* UC-56
* **FR-126 (Cập nhật trạng thái đề xuất sách):** WHEN BookSuggestionServlet.doPost(action=updateStatus) nhận request từ Thủ thư, THE system SHALL: (1) Validate status mới phải thuộc {'pending', 'acknowledged', 'rejected'}, (2) UPDATE BookSuggestion SET status=newStatus, librarianNote=note, reviewedBy=librarianUserId, updatedAt=NOW(), (3) INSERT AuditLog(UPDATE_SUGGESTION_STATUS) ghi oldStatus → newStatus, (4) Redirect kèm thông báo thành công.
  * *Mapping:* UC-56
* **FR-127 (Phân quyền truy cập đề xuất sách):** WHERE người dùng không có vai trò LECTURER hoặc LIBRARIAN cố truy cập URL /lecturer/book-suggestions hoặc /librarian/book-suggestions, THE system SHALL chặn tại AuthFilter và trả về lỗi SC_FORBIDDEN (403).
  * *Mapping:* UC-55, UC-56
* **FR-128 (Cảnh báo đề xuất trùng lặp):** WHEN Giảng viên nhập tiêu đề sách để đề xuất, THE system SHALL truy vấn BookSuggestionDAO.findByTitleLike(title) để kiểm tra đề xuất tương tự đã tồn tại. WHERE tìm thấy, THE system SHALL hiển thị danh sách đề xuất tương tự kèm gợi ý "Đề xuất tương tự đã tồn tại, bạn có muốn vote thay vì tạo mới?". Giảng viên vẫn được phép tạo nếu xác nhận.
  * *Mapping:* UC-55
* **FR-129 (Transaction an toàn cho Vote):** THE system SHALL thực hiện mọi thao tác vote/unvote trong một DB Transaction duy nhất: INSERT/DELETE SuggestionVote VÀ UPDATE voteCount trong BookSuggestion. WHERE xảy ra lỗi giữa chừng, THE system SHALL rollback toàn bộ transaction.
  * *Mapping:* UC-55 / BR-56, BR-57
* **FR-130 (Ẩn nút tương tác theo trạng thái):** WHEN hiển thị đề xuất sách trên JSP, THE system SHALL ẩn/hiện các nút tương tác dựa trên trạng thái: (1) Nút "Tôi cũng cần (+1)" chỉ hiện khi status='pending' VÀ user chưa vote, (2) Nút "Hủy vote" chỉ hiện khi status='pending' VÀ user đã vote, (3) Nút "Sửa"/"Xóa" chỉ hiện khi user là người tạo VÀ status='pending' VÀ voteCount=1.
  * *Mapping:* UC-55 / BR-57, BR-58
* **FR-131 (Ghi Audit Log đề xuất sách):** THE system SHALL ghi nhận vào bảng AuditLogs cho mọi thao tác CUD trên đề xuất sách: CREATE_SUGGESTION, UPDATE_SUGGESTION, DELETE_SUGGESTION, UPDATE_SUGGESTION_STATUS với đầy đủ oldValues/newValues.
  * *Mapping:* UC-55, UC-56
* **FR-132 (Bảo vệ voteCount không âm):** WHERE thao tác hủy vote khiến voteCount giảm dưới 0, THE system SHALL đặt voteCount = 0 (tối thiểu là 0). Đề xuất với voteCount = 0 vẫn tồn tại trong hệ thống để Thủ thư xem xét.
  * *Mapping:* UC-55 / BR-57


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
