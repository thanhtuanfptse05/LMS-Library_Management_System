# Feature Specification: Quản lý Đề xuất sách (Book Suggestions - F20)

**Feature Branch**: `feat-bookSuggestion`

**Created**: 2026-07-05

**Status**: Draft

**Input**: User description: "Hỗ trợ thu thập và đánh giá nhu cầu tài liệu từ Giảng viên. Giảng viên có thể gửi đề xuất sách mới hoặc vote (+1) cho đề xuất đã có. Thủ thư có thể quản lý trạng thái đề xuất."

## Clarifications

### Session 2026-07-05 (Round 1)

- Q: Giảng viên có thể chỉnh sửa hoặc xóa đề xuất đã gửi không? → A: Cho phép sửa/xóa chỉ khi status = "pending" VÀ voteCount = 1 (chỉ có vote của chính mình).
- Q: Giảng viên có thể rút lại (hủy) vote đã bấm không? → A: Cho phép hủy vote chỉ khi đề xuất còn status = "pending".
- Q: Giảng viên có thể vote cho đề xuất đã bị chuyển sang trạng thái "acknowledged" hoặc "rejected" không? → A: Không. Chỉ cho phép vote khi status = "pending".

### Session 2026-07-05 (Round 2)

- Q: Thủ thư có thể đổi ngược trạng thái đề xuất (acknowledged/rejected → pending, hoặc acknowledged ↔ rejected) không? → A: Có. Thủ thư được phép chuyển đổi tự do giữa ba trạng thái pending/acknowledged/rejected. Chỉ trạng thái 'deleted' là không thể đảo ngược.
- Q: Có giới hạn số đề xuất một Giảng viên có thể tạo không? → A: Có. Giới hạn được cấu hình qua bảng SystemConfigurations (key: MAX_SUGGESTION_PER_LECTURER, giá trị mặc định là 10) — Đếm theo số đề xuất có status='pending' của Giảng viên đó tại thời điểm gửi.
- Q: Khi Giảng viên tự xóa đề xuất (status='pending', voteCount=1), có nên xóa mềm hay xóa cứng? → A: Xóa cứng (hard DELETE). Vì voteCount=1 có nghĩa chưa ai khác tương tác với đề xuất, không có lý do giữ lại bản ghi. Thực hiện DELETE cả BookSuggestion và SuggestionVote liên quan. Audit Log vẫn ghi nhận hành động DELETE_SUGGESTION.
- Q: Khi nhiều đề xuất có cùng số vote (tie), thứ tự hiển thị ưu tiên theo tiêu chí nào? → A: Tie-break theo createdAt ASC — đề xuất được gửi trước sẽ hiển thị trước ("first come, first served"). SQL ORDER BY: voteCount DESC, createdAt ASC.
- Q: Điều kiện cụ thể của mục tiêu hiệu năng SC-004 là gì? → A: Thời gian phản hồi (P95) phải < 200ms cho truy vấn phân trang cơ bản có Index. (Giới hạn "2 giây" trước đó là lỗi đánh máy).

### Session 2026-07-05 (Round 3)

- Q: Sau khi Thủ thư đổi trạng thái đề xuất thành "acknowledged" hoặc "rejected", hệ thống xử lý bước tiếp theo như thế nào? → A: Đề xuất chỉ lưu trạng thái để Giảng viên tự xem trên danh sách; việc nhập sách là quy trình độc lập không móc nối trực tiếp.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Giảng viên gửi đề xuất sách mới (Priority: P1)

Một Giảng viên (Lecturer) đang cần một tài liệu tham khảo cho môn học của mình nhưng thư viện chưa có sách này. Giảng viên truy cập trang "Đề xuất sách", điền thông tin sách (tiêu đề, tác giả, nhà xuất bản, lý do đề xuất), sau đó gửi form. Hệ thống ghi nhận đề xuất với trạng thái mặc định "pending" và lượt vote khởi tạo bằng 1.

**Why this priority**: Đây là luồng cốt lõi tạo ra dữ liệu đề xuất - nếu không có khả năng gửi đề xuất, toàn bộ tính năng không có giá trị.

**Independent Test**: Có thể kiểm thử bằng cách đăng nhập tài khoản Giảng viên, gửi form đề xuất, và xác nhận đề xuất xuất hiện trong danh sách với vote = 1.

**Acceptance Scenarios**:

1. **Given** Giảng viên đã đăng nhập và đang ở trang "Đề xuất sách", **When** điền đầy đủ thông tin sách hợp lệ và nhấn nút "Gửi đề xuất", **Then** hệ thống lưu đề xuất thành công, hiển thị thông báo "Đề xuất đã được gửi thành công", và đề xuất xuất hiện trong danh sách với voteCount = 1.
2. **Given** Giảng viên đang điền form đề xuất, **When** bỏ trống trường bắt buộc (tiêu đề), **Then** hệ thống hiển thị thông báo lỗi yêu cầu nhập đầy đủ thông tin.
3. **Given** Người dùng có role khác (Student), **When** cố truy cập trang đề xuất sách, **Then** hệ thống từ chối truy cập và chuyển hướng phù hợp.

---

### User Story 2 - Giảng viên vote cho đề xuất có sẵn (Priority: P1)

Một Giảng viên thấy một đề xuất sách đã có trong danh sách trùng với nhu cầu của mình. Giảng viên nhấn nút "Tôi cũng cần (+1)" để thể hiện sự ủng hộ. Hệ thống kiểm tra giảng viên chưa từng vote cho đề xuất này, ghi nhận vote và tăng voteCount lên 1.

**Why this priority**: Cơ chế vote là yếu tố then chốt giúp Thủ thư xác định mức độ ưu tiên mua sắm tài liệu dựa trên nhu cầu thực tế.

**Independent Test**: Đăng nhập tài khoản Giảng viên, xem danh sách đề xuất, bấm "+1" cho một đề xuất chưa vote, xác nhận voteCount tăng lên.

**Acceptance Scenarios**:

1. **Given** Giảng viên đang xem danh sách đề xuất và chưa vote cho đề xuất X, **When** nhấn nút "Tôi cũng cần (+1)" trên đề xuất X, **Then** hệ thống ghi nhận vote, tăng voteCount lên 1, và cập nhật giao diện phản ánh số vote mới.
2. **Given** Giảng viên đã vote cho đề xuất X trước đó, **When** nhấn nút "Tôi cũng cần (+1)" lần nữa, **Then** hệ thống từ chối và hiển thị thông báo "Bạn đã vote cho đề xuất này".
3. **Given** Giảng viên là người tạo đề xuất X (đã tự động vote khi tạo), **When** nhấn nút "+1" cho đề xuất X, **Then** hệ thống từ chối và hiển thị thông báo "Bạn đã vote cho đề xuất này".
4. **Given** Giảng viên đã vote cho đề xuất X có status = "pending", **When** nhấn nút "Hủy vote", **Then** hệ thống xóa bản ghi vote, giảm voteCount đi 1, và cập nhật giao diện.
5. **Given** Giảng viên đã vote cho đề xuất X có status = "acknowledged" hoặc "rejected", **When** xem đề xuất X, **Then** hệ thống ẩn nút "Hủy vote" và không cho phép hủy.
6. **Given** đề xuất X có status = "acknowledged" hoặc "rejected", **When** Giảng viên chưa vote và xem đề xuất X, **Then** hệ thống ẩn nút "Tôi cũng cần (+1)" và không cho phép vote mới.

---

### User Story 3 - Giảng viên xem danh sách đề xuất (Priority: P2)

Giảng viên muốn xem tất cả các đề xuất sách đang có trong hệ thống để biết nhu cầu chung và tránh đề xuất trùng lặp. Danh sách hiển thị thông tin tóm tắt mỗi đề xuất gồm: tiêu đề sách, tác giả, người đề xuất, số lượt vote, trạng thái xử lý, và cho phép tìm kiếm/lọc.

**Why this priority**: Giúp giảng viên tra cứu trước khi đề xuất, tránh tạo bản ghi trùng lặp và nắm được tình hình xử lý.

**Independent Test**: Đăng nhập tài khoản Giảng viên, truy cập trang danh sách đề xuất, xác nhận hiển thị đúng dữ liệu và chức năng tìm kiếm hoạt động.

**Acceptance Scenarios**:

1. **Given** có nhiều đề xuất trong hệ thống, **When** Giảng viên truy cập trang danh sách đề xuất, **Then** hệ thống hiển thị danh sách phân trang, sắp xếp mặc định theo số vote giảm dần.
2. **Given** Giảng viên đang xem danh sách, **When** nhập từ khóa tìm kiếm theo tiêu đề sách, **Then** danh sách lọc chỉ hiển thị các đề xuất có tiêu đề chứa từ khóa.
3. **Given** Giảng viên đang xem danh sách, **When** lọc theo trạng thái (pending / acknowledged / rejected), **Then** danh sách chỉ hiển thị các đề xuất có trạng thái tương ứng.

---

### User Story 4 - Thủ thư quản lý trạng thái đề xuất (Priority: P2)

Thủ thư (Librarian) truy cập Dashboard quản lý đề xuất để xem xét và phân loại các đề xuất sách từ Giảng viên. Thủ thư có thể thay đổi trạng thái đề xuất sang "Đang xem xét" (pending), "Đã ghi nhận" (acknowledged), hoặc "Bác bỏ" (rejected) kèm theo ghi chú lý do.

**Why this priority**: Hoàn thiện vòng đời quản lý đề xuất, đảm bảo Giảng viên nhận được phản hồi về đề xuất của mình.

**Independent Test**: Đăng nhập tài khoản Thủ thư, truy cập Dashboard đề xuất, chọn một đề xuất, đổi trạng thái, xác nhận trạng thái được cập nhật trong DB.

**Acceptance Scenarios**:

1. **Given** Thủ thư đang xem Dashboard đề xuất với danh sách đề xuất có trạng thái "pending", **When** chọn một đề xuất và đổi trạng thái sang "acknowledged", **Then** hệ thống cập nhật trạng thái thành công và hiển thị thông báo xác nhận.
2. **Given** Thủ thư muốn bác bỏ đề xuất, **When** đổi trạng thái sang "rejected" và nhập ghi chú lý do, **Then** hệ thống lưu trạng thái mới kèm ghi chú và hiển thị thông báo thành công.
3. **Given** Thủ thư đang xem Dashboard, **When** lọc theo trạng thái hoặc sắp xếp theo số vote, **Then** danh sách hiển thị đúng kết quả lọc/sắp xếp.

---

### Edge Cases

- Điều gì xảy ra khi Giảng viên đề xuất sách có tiêu đề trùng với đề xuất đã tồn tại? Hệ thống sẽ hiển thị cảnh báo "Đề xuất tương tự đã tồn tại" và gợi ý vote thay vì tạo mới, nhưng vẫn cho phép tạo nếu Giảng viên xác nhận.
- Điều gì xảy ra khi Giảng viên đã tạo số lượng đề xuất pending đạt mức giới hạn MAX_SUGGESTION_PER_LECTURER? Hệ thống từ chối tạo mới và hiển thị thông báo "Đã đạt giới hạn đề xuất. Vui lòng đợi đề xuất hiện tại được xử lý hoặc hủy bắt kỳ đề xuất pending nào trước khi gửi tiếp."
- Điều gì xảy ra khi hai Giảng viên bấm "+1" cùng lúc cho cùng đề xuất? Hệ thống xử lý từng request tuần tự qua DB Transaction, đảm bảo voteCount tăng chính xác.
- Điều gì xảy ra khi Giảng viên đề xuất nhưng tài khoản bị khóa (status ≠ 'active')? Hệ thống từ chối thao tác tại tầng xác thực (AuthFilter).
- Điều gì xảy ra khi Thủ thư đổi trạng thái đề xuất đã bị xóa cứng? Không được — bản ghi không còn tồn tại, mọi request đến suggestionId đó sẽ trả về lỗi "Đề xuất không tồn tại".
- Điều gì xảy ra khi Thủ thư muốn đổi ngược trạng thái từ acknowledged/rejected về pending? Hệ thống cho phép — không có ràng buộc chiều chuyển trạng thái. Các lượt vote hiện tại của đề xuất vẫn được giữ nguyên (không bị reset). Audit Log ghi lại oldStatus → newStatus để truy vết.
- Điều gì xảy ra khi Giảng viên muốn sửa đề xuất đã có người khác vote (voteCount > 1) hoặc trạng thái đã chuyển sang acknowledged/rejected? Hệ thống ẩn nút Sửa/Xóa và không cho phép thao tác.
- Điều gì xảy ra khi Giảng viên hủy vote khiến voteCount giảm về 0? voteCount tối thiểu là 0 (không âm); đề xuất vẫn tồn tại trong danh sách với 0 vote để Thủ thư xem xét.
- Điều gì xảy ra khi Giảng viên cố vote cho đề xuất có status ≠ "pending"? Hệ thống ẩn nút vote trên giao diện; nếu request được gửi trực tiếp (bypass UI), hệ thống từ chối và trả về lỗi.
- Điều gì xảy ra nếu danh sách đề xuất rỗng (zero-state)? Giao diện hiển thị thông báo "Chưa có đề xuất sách nào".
- Điều gì xảy ra khi người dùng double-click nút Gửi/Vote? UI bắt buộc disable nút bấm ngay sau lần click đầu tiên để chống double-submit. Khi bấm vote/unvote, ưu tiên cập nhật qua AJAX để bảo toàn các điều kiện Lọc/Tìm kiếm hiện tại.
- Về bảo mật phân quyền, nếu role không hợp lệ cố truy cập URL, Filter sẽ redirect về trang báo lỗi 403 hoặc `/login`.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Hệ thống PHẢI cho phép Giảng viên (role = 'Lecturer') tạo đề xuất sách mới với các trường: tiêu đề sách (bắt buộc, tối đa 255 ký tự), tác giả (bắt buộc, tối đa 255 ký tự), nhà xuất bản (tùy chọn, tối đa 255 ký tự), ISBN (tùy chọn, 10-13 ký tự), lý do đề xuất (bắt buộc, tối đa 1000 ký tự). Error messages phải được hiển thị tương ứng nếu vi phạm.
- **FR-002**: Hệ thống PHẢI khởi tạo voteCount = 1 khi tạo đề xuất mới và tự động ghi nhận vote của người tạo vào bảng SuggestionVote.
- **FR-003**: Hệ thống PHẢI cho phép Giảng viên vote "+1" cho đề xuất đã có trong danh sách CHỈ KHI đề xuất còn status = "pending". Khi status = "acknowledged" hoặc "rejected", hệ thống ẩn nút vote.
- **FR-004**: Hệ thống PHẢI kiểm tra tính duy nhất của vote: mỗi Giảng viên chỉ được vote 1 lần cho mỗi đề xuất. Nếu đã vote, trả về thông báo "Bạn đã vote cho đề xuất này".
- **FR-005**: Hệ thống PHẢI thực hiện vote trong một DB Transaction duy nhất: INSERT SuggestionVote VÀ UPDATE tăng voteCount trong BookSuggestion. Nếu có lỗi, rollback toàn bộ. Đảm bảo ràng buộc `CHECK (voteCount >= 0)` dưới Database.
- **FR-006**: Hệ thống PHẢI cho phép Thủ thư (role = 'Librarian') thay đổi trạng thái đề xuất tự do giữa ba giá trị: "pending", "acknowledged", "rejected". Không có ràng buộc thứ tự chuyển trạng thái (Librarian có thể đổi acknowledged → pending, rejected → acknowledged, v.v.). Hệ thống chỉ từ chối nếu đề xuất đã bị hard DELETE (không tồn tại trong DB).
- **FR-007**: Hệ thống PHẢI cho phép Thủ thư nhập ghi chú (librarianNote) khi thay đổi trạng thái đề xuất.
- **FR-008**: Hệ thống PHẢI hiển thị danh sách đề xuất với phân trang, hỗ trợ tìm kiếm theo tiêu đề và lọc theo trạng thái. Định dạng ngày giờ hiển thị là `dd/MM/yyyy HH:mm`.
- **FR-009**: Hệ thống PHẢI sắp xếp danh sách đề xuất mặc định theo thứ tự: `ORDER BY voteCount DESC, createdAt ASC` — ưu tiên số vote cao nhất; khi bằng vote, đề xuất được gửi sớm hơn hiển thị trước.
- **FR-010**: Hệ thống PHẢI ghi Audit Log khi Thủ thư thay đổi trạng thái đề xuất (INSERT vào bảng AuditLogs). Cấu trúc `oldValues` = `{"status": "<trạng thái cũ>"}`, `newValues` = `{"status": "<trạng thái mới>", "librarianNote": "<ghi chú>"}`.
- **FR-011**: Hệ thống PHẢI chặn người dùng không có role 'Lecturer' hoặc 'Librarian' truy cập tính năng đề xuất sách.
- **FR-012**: Hệ thống PHẢI hiển thị cảnh báo khi Giảng viên tạo đề xuất có tiêu đề tương tự với đề xuất đã tồn tại (sử dụng toán tử `ILIKE` trong PostgreSQL để so sánh không phân biệt hoa thường).
- **FR-013**: Hệ thống PHẢI cho phép Giảng viên chỉnh sửa đề xuất của chính mình CHỈ KHI status = "pending" VÀ voteCount = 1. Khi điều kiện không thỏa mãn, hệ thống ẩn nút Sửa.
- **FR-013b**: Hệ thống PHẢI cho phép Giảng viên xóa đề xuất của chính mình bằng **hard DELETE** (xóa cứng) CHỈ KHI status = "pending" VÀ voteCount = 1. Thực hiện trong DB Transaction: DELETE SuggestionVote liên quan → DELETE BookSuggestion. Hệ thống PHẢI ghi INSERT AuditLog(DELETE_SUGGESTION) trước khi xóa. Khi điều kiện không thỏa mãn, hệ thống ẩn nút Xóa.
- **FR-014**: Hệ thống PHẢI cho phép Giảng viên hủy vote của chính mình CHỈ KHI đề xuất còn status = "pending". Thao tác hủy vote phải thực hiện trong DB Transaction (rollback nếu lỗi): DELETE bản ghi SuggestionVote VÀ UPDATE giảm voteCount trong BookSuggestion. Khi status ≠ "pending", hệ thống ẩn nút "Hủy vote".
- **FR-015**: Hệ thống PHẢI kiểm tra giới hạn đề xuất trước khi tạo mới: đếm số đề xuất có status='pending' hiện tại của Giảng viên đó, nếu ≥ giá trị cấu hình MAX_SUGGESTION_PER_LECTURER đọc từ SystemConfigurations (nếu không tìm thấy key, fallback sử dụng giá trị 10), hệ thống PHẢI từ chối và hiển thị thông báo "Đã đạt giới hạn đề xuất (đang chờ duyệt)".

### Key Entities

- **BookSuggestion**: Đề xuất sách do Giảng viên gửi. Chứa thông tin sách đề xuất (tiêu đề, tác giả, nhà xuất bản, ISBN, lý do), trạng thái xử lý (pending/acknowledged/rejected), tổng số lượt vote (voteCount), ghi chú từ Thủ thư (librarianNote), người tạo, ngày tạo/cập nhật. Vòng đời trạng thái: pending ↔ acknowledged ↔ rejected (Thủ thư đổi tự do). Xóa vĩnh viễn (hard DELETE) xảy ra khi Giảng viên tự xóa (voteCount=1) hoặc Thủ thư thực hiện xóa quản trị.
- **SuggestionVote**: Bản ghi vote của từng Giảng viên cho từng đề xuất. Đảm bảo tính duy nhất (mỗi user chỉ vote 1 lần cho mỗi đề xuất), ghi nhận thời điểm vote. Vote có thể bị hủy (DELETE bản ghi) khi đề xuất còn status = "pending".

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Giảng viên có thể gửi đề xuất sách mới trong vòng 1 phút kể từ khi truy cập form.
- **SC-002**: 100% lượt vote trùng lặp bị từ chối chính xác mà không gây lỗi hệ thống.
- **SC-003**: Thủ thư có thể thay đổi trạng thái đề xuất trong vòng 3 thao tác (click).
- **SC-004**: Danh sách đề xuất hỗ trợ phân trang và tìm kiếm, trả kết quả (P95) **< 200ms** (với điều kiện bảng có Index cho các trường phân loại/tìm kiếm như title, status).
- **SC-005**: Mọi thay đổi trạng thái đề xuất đều được ghi nhận trong Audit Log để truy vết.

## Assumptions

- Chỉ Giảng viên (Lecturer) mới có quyền tạo đề xuất và vote. Sinh viên (Student) không tham gia tính năng này.
- Thủ thư (Librarian) là người duy nhất có quyền quản lý trạng thái đề xuất. Library Manager không tham gia trực tiếp vào luồng này.
- Hệ thống xác thực và phân quyền hiện tại (AuthFilter + HttpSession) đã sẵn sàng và sẽ được tái sử dụng.
- Cần tạo 2 bảng CSDL mới: `BookSuggestion` và `SuggestionVote` (chưa có trong schema hiện tại).
- Cần thêm 1 key cấu hình mới vào bảng `SystemConfigurations`: `MAX_SUGGESTION_PER_LECTURER` (kiểu NON_NEGATIVE_INT, giá trị mặc định = 10, configGroup = 'library').
- Tính năng này không dùng soft-delete cho Giảng viên tự xóa (hard DELETE khi voteCount=1). Soft-delete (status='rejected') chỉ xảy ra từ phía Thủ thư.
- Không tích hợp thông báo tự động (notification) cho Giảng viên khi trạng thái đề xuất thay đổi ở phiên bản đầu tiên. Luồng hậu duyệt (Post-approval) là độc lập: việc chuyển trạng thái thành "acknowledged" không tự động kích hoạt tạo lệnh "Nhập sách" ở phân hệ khác.
- Giả định giới hạn hiệu năng ban đầu (2 giây) là lỗi đánh máy, do đó SC-004 được chuẩn hóa lại thành < 200ms với yêu cầu có Database Index để tránh nghẽn thắt cổ chai.
