# Feature Specification: Quản lý danh sách mượn sách & Gửi yêu cầu Thu hồi sách cho Thủ thư (Librarian Borrowings Management & Recall Request)

**Feature Directory**: `.sdd/specs/feat-borrowingsManagement`
**Created**: 2026-07-31
**Status**: Clarified
**Input User Description**: "Sử dụng email template RECALL_NOTICE trong seed 04_email_templates.sql để gửi mail yêu cầu thu hồi sách tới độc giả."

---

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)

Cung cấp cho Thủ thư (Librarian) công cụ xem, tra cứu, tìm kiếm phân trang danh sách tất cả lượt mượn sách đang hoạt động trong thư viện (giao diện `borrowings-management.jsp` và controller `DeskBorrowingManagerServlet`). Đồng thời tích hợp chức năng **Gửi Yêu cầu Thu hồi sách (Send Recall Request)**: Thủ thư bấm nút "Gửi Gmail Thu hồi" để gửi email thông báo theo mẫu `RECALL_NOTICE` trong CSDL yêu cầu độc giả mang sách tới quầy trả (lượt mượn giữ nguyên trạng thái `borrowed`/`overdue`, ghi Audit Log `SEND_RECALL_EMAIL`). *Không có nút hay bước xác nhận thu hồi tại quầy*.

## Clarifications

### Session 2026-07-31
- Q: Mẫu Email thu hồi được định nghĩa ở đâu? → A: Sử dụng Email Template `RECALL_NOTICE` đã được seed vào CSDL (`04_email_templates.sql`) với các nhãn biến thế thế: `{{userName}}`, `{{bookTitle}}`, `{{barcode}}`, `{{recallReason}}`.

---

## 2. User Scenarios & Acceptance Testing *(mandatory)*

### User Story 1 - Xem & Tìm kiếm danh sách mượn sách (Priority: P1)

Là một Thủ thư, tôi muốn tra cứu và tìm kiếm danh sách lượt mượn sách theo mã độc giả, mã vạch sách, trạng thái và ngày mượn để quản lý lưu thông kho sách hiệu quả.

* **Why this priority**: Đây là chức năng tra cứu cốt lõi giúp Thủ thư theo dõi danh sách sách đang mượn và quá hạn tại quầy.
* **Independent Test**: Có thể kiểm thử độc lập bằng cách đăng nhập tài khoản Thủ thư, truy cập `/librarian/borrowings`, nhập từ khóa tìm kiếm và kiểm tra kết quả danh sách phân trang.
* **Acceptance Scenarios**:
  1. **Given** Thủ thư đang ở trang `/librarian/borrowings`, **When** nhập mã sinh viên/giảng viên hoặc mã vạch sách vào ô tìm kiếm và bấm "Tìm kiếm", **Then** hệ thống hiển thị danh sách các lượt mượn khớp với từ khóa tìm kiếm.
  2. **Given** Thủ thư đang chọn bộ lọc trạng thái "Đang mượn" hoặc "Quá hạn", **When** bấm tìm kiếm, **Then** hệ thống chỉ trả về các bản ghi lượt mượn thỏa mãn đúng trạng thái được chọn.

---

### User Story 2 - Gửi Yêu cầu Thu hồi sách cho Độc giả (Priority: P2)

Là một Thủ thư, tôi muốn gửi Gmail yêu cầu thu hồi sách cho độc giả theo mẫu chuẩn `RECALL_NOTICE` kèm lý do cụ thể để yêu cầu độc giả đưa sách về quầy trả.

* **Why this priority**: Đảm bảo quy trình gửi thông báo thu hồi chuyên nghiệp qua email mẫu đã đăng ký trong hệ thống mà không làm thay đổi trạng thái mượn.
* **Independent Test**: 
  1. Thao tác nút "Gửi Gmail Thu hồi", nhập lý do và bấm gửi. Kiểm tra `EmailJob` gắn mã template `RECALL_NOTICE` với biến `recallReason` được đẩy vào hàng đợi bất đồng bộ, lượt mượn giữ nguyên trạng thái `borrowed`/`overdue` và ghi AuditLog `SEND_RECALL_EMAIL`.
* **Acceptance Scenarios**:
  1. **Given** lượt mượn đang mượn (`borrowed`/`overdue`), **When** Thủ thư bấm nút "Gửi Gmail Thu hồi" và nhập lý do, **Then** hệ thống gửi email mẫu `RECALL_NOTICE` tới độc giả, ghi AuditLog `SEND_RECALL_EMAIL` và giữ nguyên trạng thái mượn hiện tại.
  2. **Given** ô lý do bị bỏ trống trong modal gửi yêu cầu thu hồi, **When** bấm xác nhận gửi, **Then** hệ thống hiển thị báo lỗi yêu cầu nhập lý do.

---

## 3. Business Rules (Quy tắc nghiệp vụ)

* **BR-82 (Strict View & Send Recall Request Scope):** Thủ thư CHỈ CÓ QUYỀN Xem / Tìm kiếm và Gửi Gmail yêu cầu thu hồi sách. Tuyệt đối không có tính năng Chỉnh sửa lượt mượn (không sửa ngày hẹn trả, không đổi bản sao sách) và KHÔNG CÓ nút bấm xác nhận thu hồi.
* **BR-83 (Template RECALL_NOTICE & Async Queue):** Khi Thủ thư bấm gửi yêu cầu thu hồi, hệ thống BẮT BUỘC khởi tạo `EmailJob` với `tempName = 'RECALL_NOTICE'` chứa các tham số `{{userName}}`, `{{bookTitle}}`, `{{barcode}}`, `{{recallReason}}` và đẩy vào hàng đợi gửi mail ngầm bất đồng bộ (`EmailService.enqueue(...)`), đồng thời ghi vết nhật ký thao tác vào `AuditLogs` (`actionType = 'SEND_RECALL_EMAIL'`). Trạng thái bản ghi `BorrowRecord.status` KHÔNG THAY ĐỔI (`borrowed`/`overdue`).

---

## 4. Functional Requirements (Yêu cầu chức năng)

### Tra cứu, Sắp xếp & Phân trang

* **FR-103 (Truy vấn danh sách lượt mượn phân trang & Sắp xếp linh hoạt) (FR-135, BR-84):** WHEN `DeskBorrowingManagerServlet.doGet()` được gọi với các tham số `userKeyword`, `barcodeKeyword`, `status`, `fromDate`, `toDate`, `sortBy`, `sortOrder`, `page`, THE system SHALL: (1) Truy vấn JOIN dữ liệu giữa `BorrowRecord`, `MemberProfile`, `"User"`, `Book`, `BookCopy`, `Student`, `Lecturer`, (2) Lọc dữ liệu theo các tiêu chí từ khóa, trạng thái và ngày mượn, (3) Sắp xếp dữ liệu theo `sortBy` (`startDate`, `endDate`, `bookTitle`, `userFullName`, `barcode`, `borrowRecordId`) và chiều `sortOrder` (`DESC`, `ASC`), (4) Phân trang với `PAGE_SIZE = 10`, (5) Forward danh sách `BorrowingManagementDTO` cho `borrowings-management.jsp` hiển thị.

* **FR-105 (Đồng bộ Giao diện & Navigation Sidebar) (FR-137):** Giao diện `borrowings-management.jsp` sử dụng cấu trúc `raised-card`, bảng `table-lms`, nhãn `badge-pill` và nút bấm Terracotta Orange (#d97706) đồng bộ 100% với hệ thống design system (`DESIGN.md`). Tên menu sidebar tại các vai trò được đồng bộ thành "Quản lý sách đang mượn" (Librarian) và "Quản lý sách đang mượn & đặt trước" (Student/Lecturer).

### Gửi Yêu cầu Thu hồi Sách qua Email Template RECALL_NOTICE

* **FR-104 (Gửi Email Yêu cầu Thu hồi sách theo Template):** WHEN `DeskBorrowingManagerServlet.doPost(action='sendRecallEmail', borrowRecordId, recallReason)` được gọi bởi Thủ thư, THE system SHALL:
  1. Validate `recallReason` không được rỗng hoặc chỉ chứa khoảng trắng.
  2. Truy vấn `BorrowRecordDAO.findById(conn, borrowRecordId)` kiểm tra trạng thái thuộc IN ('borrowed', 'overdue').
  3. Chuẩn bị Map placeholders: `userName` (Tên độc giả), `bookTitle` (Tên sách), `barcode` (Mã vạch bản sao), `recallReason` (Lý do thu hồi).
  4. Tạo `EmailJob job = new EmailJob("RECALL_NOTICE", borrowerEmail, userName, placeholders)` và đẩy vào `EmailService.enqueue(job)` bất đồng bộ.
  5. Ghi AuditLog `SEND_RECALL_EMAIL`.
  6. Giữ nguyên trạng thái `BorrowRecord.status` (`borrowed`/`overdue`).

---

## 5. Key Entities & Database Schema

* **`EmailTemplate`**: Bảng mẫu email hệ thống (`tempName` = 'RECALL_NOTICE', `subject`, `bodyContent`).
* **`BorrowRecord`**: Bảng ghi nhận lượt mượn (`borrowRecordId`, `userId`, `bookCopyId`, `bookId`, `startDate`, `endDate`, `returnedAt`, `status`).
* **`BookCopy`**: Bảng bản sao sách vật lý (`bookCopyId`, `bookId`, `barcode`, `status`).
* **`AuditLogs`**: Bảng nhật ký thao tác hệ thống (`auditLogId`, `userId`, `actionType` = 'SEND_RECALL_EMAIL').

---

## 6. Success Criteria *(mandatory)*

### Measurable Outcomes

* **SC-001**: Thời gian phản hồi của câu truy vấn tìm kiếm và phân trang danh sách mượn sách đạt dưới 200ms.
* **SC-002**: 100% email yêu cầu thu hồi sách được gửi qua mẫu `RECALL_NOTICE` và đẩy vào hàng đợi bất đồng bộ thành công kèm nhật ký `AuditLog` `SEND_RECALL_EMAIL`.
* **SC-003**: 100% các lượt mượn gửi yêu cầu thu hồi thành công vẫn duy trì trạng thái mượn hiện tại cho tới khi độc giả trả sách tại quầy qua luồng Check-in.

---

## 7. Assumptions & Out of Scope

### Assumptions
* Thủ thư đã được xác thực session hợp lệ với role `'librarian'`, `'manager'` hoặc `'admin'`.
* Mẫu email `RECALL_NOTICE` đã được seed thành công vào bảng `EmailTemplate` trong CSDL.

### Out of Scope
* Chức năng chỉnh sửa ngày hẹn trả hoặc đổi bản sao sách trong lượt mượn.
* Thao tác nút bấm "Xác nhận Thu hồi" hay thay đổi trạng thái `BorrowRecord.status` thành `recalled`.
