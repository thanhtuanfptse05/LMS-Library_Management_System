# Feature Specification: Bảo trì sách và Kiểm kê (Book Maintenance)
# Version: 1.3 | Chủ sở hữu: Chuong | Ngày cập nhật: 2026-07-26 (Chuẩn hóa UC-BR-FR registry)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp quy trình cho Thủ thư ghi nhận, xác minh và xử lý bản sao hỏng/mất; đồng thời thực hiện kiểm kê theo vị trí để phát hiện sách khớp, thiếu hoặc sai vị trí. Mọi thay đổi trạng thái bản sao, số lượng tồn kho, dữ liệu kiểm kê và Audit Log phải chạy nguyên tử, không hard-delete BookCopy/Incident/InventorySession.

Spec này căn theo `diagram/business-rules-specification.md`, `diagram/detailed-UC-specifications.md`, schema PostgreSQL và implementation hiện có. Không dùng `diagram/spec-UC-BR-FR.txt` làm nguồn mapping chuẩn vì file đó đang có mã UC/BR/FR trùng hoặc lệch sang feature khác.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Tác nhân duy nhất được xem và thực hiện nghiệp vụ F13.
* **Vai trò khác:** `ADMIN`, `MANAGER`, `STUDENT`, `LECTURER` và vai trò khác nhận HTTP 403 tại `/librarian/book-management/incidents`, `/librarian/book-management/inventory` hoặc legacy `/book-management/*`.
* **Người chưa đăng nhập:** Được chuyển tới trang đăng nhập.

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-28 (Report Book Incident):** Actor: Librarian | (Báo cáo sự cố sách): Thủ thư tìm kiếm, báo hỏng/mất theo Barcode, chuyển xác minh, kết luận, bác bỏ, khôi phục bản sao hỏng sau sửa chữa hoặc loại khỏi tổng kho bằng soft flag.
* **UC-29 (Inventory Reconciliation):** Actor: Librarian | (Kiểm kê kho): Thủ thư tạo phiên theo vị trí, quét Barcode, kết thúc kiểm đếm, xử lý sách sai vị trí/thiếu, hoàn tất hoặc hủy phiên.

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F13 Book Maintenance. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-28 (Incident Resolution Sync):** Khi báo sự cố hợp lệ trong F13, hệ thống BẮT BUỘC chuyển BookCopy sang status='unavailable' và giảm Book.availableQuantity đúng 1 trong cùng transaction. Khi bác bỏ báo cáo hoặc khôi phục bản sao hỏng sau sửa chữa, hệ thống BẮT BUỘC chuyển BookCopy về good/available và tăng availableQuantity đúng 1. Khi kết luận lost hoặc khi bản sao damaged/resolved không còn khả năng sửa, hệ thống BẮT BUỘC đánh dấu removedFromInventory=true và giảm Book.totalQuantity đúng 1 trong transaction; không được xóa record BookCopy.
* **BR-44 (Inventory Reconciliation Data):** Dữ liệu kiểm kê gần nhất phải đủ để đối chiếu số lượng/vị trí bản sao trong báo cáo quản lý. Trong F13, quy tắc này được đáp ứng bằng InventorySession và InventoryItem; việc hiển thị báo cáo quản trị tổng hợp thuộc feature báo cáo nếu có.


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-48 (Ghi nhận sự cố bản sao với vô hiệu hóa tức thì):** WHEN BookCopyIncidentServlet.doPost(action=report) nhận barcode, incidentType và description, THE system SHALL chỉ chấp nhận type damaged/lost, mô tả không rỗng và tối đa 1000 ký tự, khóa và tìm BookCopy theo Barcode, chỉ chấp nhận BookCopy condition='good', status='available', chưa có incident pending/investigating, mở transaction, INSERT BookCopyIncident(status='pending'), UPDATE BookCopy status='unavailable' nhưng chưa đổi condition, giảm Book.availableQuantity đúng 1, ghi Audit Log cho incident và BookCopy, rồi commit; WHERE lỗi thì rollback.
  * *Mapping:* UC-28 / BR-28
* **FR-49 (Xử lý vòng đời sự cố và phục hồi số lượng):** WHEN xử lý incident được báo trực tiếp trong F13, THE system SHALL tuân theo state machine: investigate chỉ pending -> investigating; resolve từ pending/investigating -> resolved, cập nhật BookCopy.condition thành damaged hoặc lost, giữ status='unavailable', nếu lost thì set removedFromInventory=true và giảm totalQuantity 1; reject từ pending/investigating -> rejected, đưa BookCopy về available và tăng availableQuantity 1; restore chỉ incident resolved loại damaged có BookCopy damaged/unavailable và chưa removedFromInventory, đưa BookCopy về good/available, tăng availableQuantity 1; removeFromInventory chỉ incident resolved loại damaged chưa removedFromInventory, set removedFromInventory=true và giảm totalQuantity 1. Incident resolved tạo bởi F6 không được resolve/reject lại. Mọi nhánh phải khóa bản ghi, ghi Audit Log và commit/rollback nguyên tử.
  * *Mapping:* UC-28 / BR-28
* **FR-50 (Tạo và xử lý phiên kiểm kê kho với 8 action):** WHEN InventoryReconciliationServlet nhận action, THE system SHALL hỗ trợ create, start, scan, finish-counting, resolve-misplaced, resolve-missing, complete và cancel theo state machine F13. Resolve-missing chỉ áp dụng BookCopy good/available, tạo incident lost/pending, chuyển copy unavailable, giảm availableQuantity và đánh dấu item đã xử lý. Complete chỉ cho phép reviewing -> completed khi không còn missing/misplaced chưa xử lý. Mỗi action thay đổi dữ liệu phải dùng transaction và Audit Log.
  * *Mapping:* UC-29 / BR-44, BR-28 cho nhánh resolve-missing
* **FR-51 (DEPRECATED - Logic merged into FR-50):** Logic kết luận kiểm kê đã được tích hợp vào FR-50 với action=complete. Không còn sử dụng FR riêng biệt.
  * *Mapping:* (merged into FR-50)


## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* **Toàn vẹn:** Mọi thay đổi Incident/BookCopy/Book/InventoryItem/InventorySession và Audit Log dùng cùng một Connection; lỗi phải rollback.
* **Đồng thời:** Bản ghi Incident, BookCopy và InventorySession/Item phải được khóa khi kiểm tra và chuyển trạng thái.
* **Bảo mật:** Chỉ `LIBRARIAN`; mọi SQL nhận đầu vào dùng `PreparedStatement`.
* **Hiệu năng:** Danh sách sự cố phân trang 20 bản ghi; thao tác quét Barcode phản hồi dưới 1 giây ở môi trường Milestone 2.
* **Giao diện:** JSP dùng JSTL/EL, không scriptlet Java; nhãn, lỗi và thông báo thành công 100% tiếng Việt.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
Nguồn chuẩn: `database/supabase/LMS_Schema_PostgreSQL.sql`.

### Bảng BookCopyIncident
* `incidentId` (INT, PK), `bookCopyId` (INT, FK)
* `incidentType` (`damaged`, `lost`)
* `description`, `resolution` (tối đa 1000 ký tự)
* `status` (`pending`, `investigating`, `resolved`, `rejected`)
* `reportedBy`, `reportedAt`, `resolvedBy`, `resolvedAt`
* Unique partial index bảo đảm mỗi BookCopy chỉ có tối đa một incident chưa kết thúc.

### Bảng BookCopy (các cột liên quan F13)
* `condition` (`good`, `damaged`, `lost`)
* `status` (`available`, `unavailable`, `borrowed`, `reserved`)
* `removedFromInventory` (BOOLEAN, DEFAULT FALSE)
* `removedFromInventoryAt` (TIMESTAMP, nullable)
* `removedFromInventoryBy` (INT, FK -> User, nullable)
* Constraint: chỉ cho phép `removedFromInventory=true` khi BookCopy `status='unavailable'`, `condition IN ('damaged','lost')` và đã có thời điểm loại khỏi kho.

### Bảng InventorySession
* `inventorySessionId` (INT, PK), `location` (VARCHAR(255)), `note` (VARCHAR(1000))
* `status` (`draft`, `counting`, `reviewing`, `completed`, `cancelled`)
* `startedBy`, `startedAt`, `completedBy`, `completedAt`

### Bảng InventoryItem
* `inventoryItemId` (INT, PK), `inventorySessionId` (INT, FK), `bookCopyId` (INT, FK)
* `expectedLocation`, `scannedLocation`
* `result` (`pending`, `matched`, `missing`, `misplaced`)
* `scannedBy`, `scannedAt`, `resolution`, `resolvedBy`, `resolvedAt`
* Mỗi cặp `(inventorySessionId, bookCopyId)` là duy nhất.

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE Barcode không tồn tại, BookCopy đang mượn/đặt trước/unavailable hoặc đã có incident mở, THE system SHALL từ chối báo sự cố.
* WHERE action không phù hợp trạng thái nguồn, incident/session/item không tồn tại hoặc chênh lệch đã xử lý, THE system SHALL từ chối mà không thay đổi dữ liệu.
* WHERE scan Barcode không tồn tại hoặc complete còn chênh lệch chưa xử lý, THE system SHALL giữ nguyên trạng thái phiên và hiển thị lỗi tiếng Việt.
* WHERE lỗi Database bất ngờ, THE system SHALL rollback, log chi tiết ở server và không lộ stack trace ra UI.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Báo sự cố hợp lệ tạo incident `pending`, chuyển BookCopy `unavailable`, giảm `availableQuantity` 1 và có Audit Log.
- [ ] Không thể báo sự cố cho copy borrowed/reserved/unavailable hoặc copy đã có incident mở.
- [ ] Resolve chỉ đổi condition thành damaged/lost; không trừ `availableQuantity` lần thứ hai.
- [ ] Resolve lost set `removedFromInventory=true`, giảm `totalQuantity` đúng 1 và không xóa BookCopy.
- [ ] Reject phục hồi BookCopy available và tăng tồn kho đúng 1.
- [ ] Chỉ incident damaged đã resolved được restore sau sửa chữa; incident lost không được restore.
- [ ] Incident damaged đã resolved và không thể sửa được có thể loại khỏi kho; hệ thống set `removedFromInventory=true`, giảm `totalQuantity` đúng 1, không xóa BookCopy và không cho loại khỏi kho lần 2.
- [ ] Incident `resolved` do F6 tạo khi check-in hỏng/mất được hiển thị trên F13 nhưng không được resolve/reject lại; incident `damaged` vẫn restore được sau sửa chữa nếu chưa bị loại khỏi kho.
- [ ] Phiên kiểm kê đi đúng `draft -> counting -> reviewing -> completed`, hoặc chuyển `cancelled` khi chưa kết thúc.
- [ ] Scan đúng vị trí tạo matched; scan khác vị trí tạo misplaced; bản sao kỳ vọng chưa scan trở thành missing.
- [ ] Không thể complete khi còn missing/misplaced chưa xử lý.
- [ ] Resolve missing tạo incident lost pending, ngừng lưu thông BookCopy và giảm tồn kho đúng 1.
- [ ] Vai trò ngoài LIBRARIAN nhận HTTP 403; UI không có nhãn/thông báo tiếng Anh.

## 9. Out of Scope (Phạm vi không thực hiện)
* Tạo/cập nhật metadata Book, nhập BookCopy và import Excel (F4 `feat-bookManagement`).
* Nhận trả sách và tính phạt do hỏng/mất (F6/F9); F13 chỉ tiếp nhận incident F6 đã `resolved` để tra cứu hoặc restore bản sao `damaged` sau sửa chữa.
* Tính khấu hao, thanh lý tài sản kế toán hoặc hard-delete BookCopy; F13 chỉ hỗ trợ loại khỏi tổng kho phục vụ bằng soft flag `removedFromInventory`.
* Tự động hoàn tất incident F13 hoặc tự sửa chênh lệch kiểm kê không có xác nhận Thủ thư; ngoại lệ là incident do F6 tạo đã được Thủ thư kết luận trực tiếp khi nhận trả sách.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* `missing` là kết quả kiểm kê; khi xử lý sẽ tạo `incidentType='lost'`, vì schema không cho phép incidentType `missing`.
* Mã F13 không tạo UC/BR mới. Nếu cần đăng ký FR trong registry sau này, chỉ đăng ký `FR-48..51` cho `UC-28/UC-29`; không tái sử dụng `UC-24/25/26` hoặc `BR-24/25`.
