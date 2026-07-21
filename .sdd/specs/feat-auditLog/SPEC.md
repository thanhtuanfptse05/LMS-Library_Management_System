# Feature Specification: Nhật ký hoạt động và Dashboard Admin (Audit Log)
# Version: 1.1 | Chủ sở hữu: @antigravity | Ngày cập nhật: 2026-07-21

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Ghi nhận toàn bộ hành động thay đổi dữ liệu cốt lõi (Create, Update, Delete) của người dùng trên hệ thống, cho phép Quản trị viên (Admin) giám sát, lọc tìm kiếm nhật ký hoạt động, xem so sánh chi tiết giá trị cũ/mới của các bản ghi dữ liệu, xuất nhật ký ra Excel, và theo dõi chỉ số sức khỏe của toàn thư viện thông qua Dashboard dành riêng cho Admin.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản trị viên (Admin):** Có toàn quyền truy cập trang Nhật ký Kiểm toán, xem danh sách, lọc theo nhiều tiêu chí, xem so sánh chi tiết các trường dữ liệu thay đổi, xuất Excel nhật ký và xem Admin Dashboard tổng quan.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-40 (View Audit Log):** Actor: SysAdmin | (Xem Nhật ký Kiểm toán): Quản trị viên truy cập trang Nhật ký Kiểm toán để xem danh sách toàn bộ hành động thay đổi dữ liệu của người dùng, lọc theo nhiều tiêu chí, và xem chi tiết so sánh giá trị cũ/mới.
* **UC-41 (Export Audit Log):** Actor: SysAdmin | (Xuất Nhật ký Kiểm toán): Quản trị viên xuất dữ liệu Nhật ký Kiểm toán ra file Excel để phục vụ báo cáo và lưu trữ ngoài hệ thống.
* **UC-46 (View Admin Dashboard):** Actor: Admin | (Xem bảng điều khiển quản trị): Quản trị viên hệ thống xem tổng quan toàn hệ thống bao gồm tổng số tài khoản, sách, tiền phạt chưa thu, giao dịch đang chờ, hoạt động gần đây và cấu hình hệ thống quan trọng.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-32 (Audit Log Read-Only):** Tính năng Nhật ký Kiểm toán (F12) KHÔNG ĐƯỢC PHÉP Insert, Update hoặc Delete dữ liệu trong bất kỳ bảng nào của hệ thống thông qua giao diện hiển thị. Chỉ được thực hiện SELECT dữ liệu nhật ký.
* **BR-33 (Audit Log JSON Format):** Tất cả `oldValues` và `newValues` trong bảng `AuditLogs` BẮT BUỘC được ghi ở dạng JSON hợp lệ (hoặc NULL). KHÔNG sử dụng plain text để đảm bảo giao diện hiển thị đối chiếu nhất quán.
* **BR-34 (Audit Log Pagination):** Danh sách Nhật ký Kiểm toán BẮT BUỘC phải phân trang (20 bản ghi/trang) để bảo vệ hiệu năng hệ thống. KHÔNG ĐƯỢC PHÉP tải toàn bộ dữ liệu trong một request.
* **BR-38 (Dashboard Data Isolation):** Mỗi Dashboard (Admin/Manager/Librarian/Student/Lecturer) BẮT BUỘC chỉ hiển thị dữ liệu và chỉ số phù hợp với role của người dùng. Dashboard KHÔNG ĐƯỢC PHÉP truy xuất hoặc hiển thị dữ liệu ngoài phạm vi quyền hạn của role.
* **BR-14 (Mandatory Audit):** Mọi thao tác làm thay đổi dữ liệu tài khoản (Thêm, Sửa, Khóa, Mở khóa, Import) từ Quản trị viên BẮT BUỘC phải được lưu vết tự động vào hệ thống Audit Log.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-55 (Truy vấn Danh sách Nhật ký Kiểm toán với phân trang):** WHEN AuditLogServlet.doGet(action=list) được gọi, THE system SHALL: (1) Parse filter params: actionType, entityName, email (search user), fromDate, toDate, keyword (search in oldValues/newValues JSON), page (default 1), pageSize (fixed 20), (2) AuditLogDAO.findWithFilters(filters, page, pageSize) thực thi SQL: SELECT a.*, u.email AS actorEmail FROM AuditLogs a LEFT JOIN "User" u ON a.userId = u.userId WHERE (filters) ORDER BY timestamp DESC LIMIT 20 OFFSET (page-1)*20, (3) WHERE userId IS NULL: hiển thị "Hệ thống" thay vì email, (4) Tính totalCount để phân trang, totalPages = CEIL(totalCount / 20), (5) Forward sang audit-log-list.jsp với {logs[], currentPage, totalPages, filters[]}.
  * *Mapping:* UC-40 / BR-32, BR-34
* **FR-56 (Lọc Nhật ký Kiểm toán với 7 filter params):** WHEN AuditLogServlet nhận filter params, THE system SHALL build SQL WHERE clause động: (1) actionType filter: WHERE actionType = ? (dropdown: CREATE, UPDATE, DELETE, CHECKOUT, etc.), (2) entityName filter: WHERE entityName = ? (dropdown: User, Book, BorrowRecord, SystemConfigurations, etc.), (3) email filter: WHERE u.email ILIKE '%?%', (4) fromDate filter: WHERE timestamp >= ?, (5) toDate filter: WHERE timestamp <= ? + 1 day, (6) keyword filter: WHERE (oldValues::text ILIKE '%?%' OR newValues::text ILIKE '%?%') — tìm kiếm trong chuỗi JSON, (7) WHILE chuyển trang (page param thay đổi): giữ nguyên toàn bộ filter params trong query string.
  * *Mapping:* UC-40 / BR-34
* **FR-57 (Chi tiết Nhật ký dạng Card so sánh 1-1):** WHEN SysAdmin click "Xem chi tiết" trên một AuditLog row, THE system SHALL mở modal popup hiển thị: (1) Parse oldValues và newValues từ JSON string → Map<String, Object>, (2) Lấy tất cả keys từ cả 2 maps, (3) Với mỗi key: tạo 1 comparison card pair với 2 cột: LEFT (Giá trị Cũ - nền hồng nhạt), RIGHT (Giá trị Mới - nền xanh nhạt), (4) Format: Key name (bold) ở header, old value ở card trái, new value ở card phải, xếp theo chiều dọc, (5) WHERE value là nested object/array: pretty-print JSON với indent, (6) Hiển thị metadata: {actionType, entityName, entityId, actorEmail, timestamp} ở modal header.
  * *Mapping:* UC-40 / BR-33
* **FR-58 (Xử lý hiển thị đặc biệt Modal theo actionType):** WHEN render modal chi tiết AuditLog, THE system SHALL xử lý các trường hợp đặc biệt: (1) **actionType = CREATE**: oldValues = NULL → hiển thị "—" hoặc badge "Không có" ở cột trái, chỉ hiển thị newValues ở cột phải, (2) **actionType = DELETE**: newValues = NULL → hiển thị "—" ở cột phải, chỉ hiển thị oldValues ở cột trái, (3) **actionType = CHANGE_PASSWORD**: oldValues và newValues đều NULL hoặc rỗng (vì bảo mật) → hiển thị text "Mật khẩu đã thay đổi (bảo mật)" thay vì cards rỗng, (4) **WHERE JSON invalid**: không parse được oldValues/newValues → hiển thị raw text trong 1 card đơn với border đỏ + icon warning, (5) **WHERE field name dài**: truncate với tooltip hover để xem full text.
  * *Mapping:* UC-40 / BR-33
* **FR-59 (Xuất Excel Nhật ký Kiểm toán):** WHEN AuditLogServlet.doGet(action=export) được gọi, THE system SHALL: (1) Lấy cùng filter params từ list view, (2) AuditLogDAO.findWithFilters(filters, page=1, pageSize=10000) — giới hạn tối đa 10.000 bản ghi để bảo vệ hiệu năng, (3) Build Excel file (.xlsx) bằng Apache POI: tạo header row = ["Thời gian", "Hành động", "Đối tượng", "ID", "Người thực hiện", "Giá trị cũ", "Giá trị mới"], data rows với oldValues/newValues được flatten thành string, (4) Set response headers và write workbook to response OutputStream, (5) Ghi AuditLog(EXPORT_AUDIT_LOG, actorId).
  * *Mapping:* UC-41 / BR-32
* **FR-60 (Badge màu hành động theo nhóm):** WHEN hiển thị danh sách Nhật ký Kiểm toán trong audit-log-list.jsp, THE system SHALL render badge màu cho cột actionType theo nhóm: (1) **Nhóm Tạo mới** (màu xanh lá - green): CREATE, CREATE_USER, CREATE_BOOK, BULK_USER_IMPORT, BOOK_IMPORT, (2) **Nhóm Cập nhật** (màu vàng - yellow): UPDATE, UPDATE_USER, UPDATE_BOOK, (3) **Nhóm Xóa/Hủy** (màu đỏ - red): DELETE, DELETE_USER, CANCEL_RESERVATION, (4) **Nhóm Giao dịch** (màu xanh dương - blue): CHECKOUT, CHECKIN, RESERVE_BOOK_ONLINE, RENEW_BOOK_ONLINE, (5) **Nhóm Bảo mật** (màu tím - purple): LOGIN, LOGOUT, CHANGE_PASSWORD, LOCK_ACCOUNT, UNLOCK_ACCOUNT, (6) **Nhóm Thanh toán** (màu cam - orange): CASH_PAYMENT, SEPAY_WEBHOOK_PAYMENT, (7) **Mặc định** (màu xám - gray): các action khác.
  * *Mapping:* UC-40
* **FR-73 (Hiển thị Dashboard Admin với tổng quan hệ thống):** WHEN AdminDashboardServlet.doGet() được gọi, THE system SHALL tổng hợp dữ liệu toàn hệ thống: (1) **totalBooks** = BookCopyDAO.count(null, null, null) — tổng số bản sao vật lý, (2) **totalMembers** = UserDAO.countAllUsers("", "ALL", "ALL") — tổng số tài khoản, (3) **unpaidFines** = FineDAO.getTotalUnpaidFines() — tổng tiền phạt chưa thu (VNĐ), (4) **pendingPayments** = PaymentDAO.countPendingPayments() — số giao dịch đang chờ, (5) **recentUsers** = UserService.getUserList("", "ALL", "ALL", page=1, pageSize=5) — 5 user mới nhất, (6) **recentAuditLogs** = AuditLogDAO.findWithFilters(null, page=1, pageSize=5) — 5 log gần nhất, (7) Forward sang admin/dashboard.jsp. Dashboard có quick links: "Quản lý người dùng", "Xem Audit Log", "Cấu hình hệ thống".
  * *Mapping:* UC-46 / BR-38
* **FR-74 (Hiển thị Cấu hình Quan trọng trên Admin Dashboard):** WHEN AdminDashboardServlet.doGet() render dashboard, THE system SHALL đọc SystemConfigCache để lấy các cấu hình quan trọng: (1) STUDENT_MAX_BORROW_DAYS (số ngày mượn SV), (2) LECTURER_MAX_BORROW_DAYS (số ngày mượn GV), (3) FINE_RATE_PER_DAY (tiền phạt/ngày VNĐ), (4) RESERVATION_HOLD_DAYS (số ngày giữ sách đặt trước), (5) MAX_EXTENSION_COUNT (số lần gia hạn tối đa), (6) STUDENT_MAX_BORROW_BOOKS (hạn mức sách SV), (7) LECTURER_MAX_BORROW_BOOKS (hạn mức sách GV). Hiển thị trong panel "Cấu hình Hệ thống Quan trọng" với button "Chỉnh sửa" → redirect sang /admin/system-config. WHERE cache miss: load từ DB và populate cache.
  * *Mapping:* UC-46

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật bất biến:** Nhật ký kiểm toán là read-only qua giao diện ứng dụng. Tuyệt đối không cho phép bất kỳ hành động CUD (Create/Update/Delete) nào trên UI.
* **Định dạng chuẩn:** Trường `oldValues` và `newValues` bắt buộc lưu dưới dạng JSON hợp lệ để hệ thống parse hiển thị dạng cột so sánh.
* **Ngôn ngữ hiển thị:** Giao diện Dashboard, danh sách nhật ký, modal so sánh, file Excel xuất ra và badge nhóm đều phải bằng tiếng Việt.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng AuditLogs
* `auditLogId` (INT, PK, Identity) - Khóa chính tự tăng
* `userId` (INT, FK REFERENCES "User", NULL) - ID người thực hiện hành động (Hệ thống = NULL)
* `actionType` (VARCHAR(100)) - Loại hành động (CREATE_BOOK, UPDATE_USER, LOGIN...)
* `entityName` (VARCHAR(255)) - Tên bảng bị tác động (Book, User, SystemConfigurations...)
* `entityId` (INT, NULL) - ID của thực thể bị tác động
* `oldValues` (TEXT, NULL) - Giá trị cũ định dạng JSON
* `newValues` (TEXT, NULL) - Giá trị mới định dạng JSON
* `timestamp` (TIMESTAMP) - Thời gian ghi nhận hành động

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE dữ liệu `oldValues` hoặc `newValues` trong CSDL không phải là định dạng JSON hợp lệ, THE system SHALL hiển thị dữ liệu dạng text thô trong một thẻ card đơn có border đỏ kèm cảnh báo "Dữ liệu không đúng định dạng JSON" để tránh làm crash giao diện.
* WHERE lỗi kết nối CSDL hoặc Apache POI xảy ra khi xuất Excel, hệ thống SHALL log lỗi, không crash hệ thống và hiển thị cảnh báo bằng tiếng Việt: "Đã xảy ra lỗi khi tạo tệp Excel nhật ký. Vui lòng thử lại sau".

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] **Ghi nhận hành động:** Thực hiện cập nhật một thông số cấu hình hệ thống -> Bảng `AuditLogs` tự động lưu bản ghi chứa thông tin cũ và mới của key đó dạng JSON.
- [ ] **Xem danh sách & Lọc:** Admin có thể lọc danh sách nhật ký theo Action Type, Entity Name, Email, khoảng thời gian và keyword trong JSON. Danh sách phân trang chuẩn 20 bản ghi/trang.
- [ ] **Xem chi tiết so sánh:** Khi nhấn "Xem chi tiết", modal hiển thị so sánh trực quan dạng 2 cột: Cột trái (Giá trị cũ - hồng), Cột phải (Giá trị mới - xanh). Thao tác đổi mật khẩu ẩn giá trị thô, chỉ hiển thị "Mật khẩu đã thay đổi (bảo mật)".
- [ ] **Dashboard Admin:** Dashboard Admin hiển thị đúng các số liệu tổng hợp (tài khoản, sách, tiền phạt chưa thu, 5 user mới, 5 log gần nhất) và panel cấu hình quan trọng.
- [ ] **Xuất Excel:** File Excel xuất ra khớp chính xác dữ liệu theo bộ lọc đang chọn trên giao diện và giới hạn tối đa 10.000 dòng.

## 9. Out of Scope (Phạm vi không thực hiện)
* Chỉnh sửa hoặc xóa các bản ghi Audit Log từ giao diện quản lý.
* Theo dõi lịch sử truy cập trang web (Page Views) của Guest/User thông qua Audit Log (chỉ theo dõi thay đổi dữ liệu cốt lõi và đăng nhập/đăng xuất).

## 10. Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Toàn bộ hệ thống ghi nhật ký kiểm toán đã chạy ổn định và đồng bộ với cơ chế ghi log thủ công ở tầng Service/Servlet.