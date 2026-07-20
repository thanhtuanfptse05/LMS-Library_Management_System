# Feature Specification: Bảo trì sách và Kiểm kê (Book Maintenance)
# Version: 1.1 | Chủ sở hữu: Chuong | Ngày cập nhật: 2026-07-09

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp quy trình cho Thủ thư ghi nhận, xác minh và xử lý bản sao hỏng/mất; đồng thời thực hiện kiểm kê theo vị trí để phát hiện sách khớp, thiếu hoặc sai vị trí. Mọi thay đổi trạng thái bản sao và số lượng tồn kho phải nguyên tử, có Audit Log và không hard-delete.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Tác nhân duy nhất được xem và thực hiện nghiệp vụ F13.
* **Vai trò khác:** `ADMIN`, `MANAGER`, `STUDENT`, `LECTURER` và vai trò khác nhận HTTP 403 tại `/librarian/book-management/incidents` và `/librarian/book-management/inventory`.
* **Người chưa đăng nhập:** Được chuyển tới trang đăng nhập.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-28 (Report Book Incident):** Actor: Librarian | Tìm kiếm, báo hỏng/mất theo Barcode, chuyển xác minh, kết luận, bác bỏ và khôi phục bản sao hỏng sau sửa chữa.
* **UC-29 (Inventory Reconciliation):** Actor: Librarian | Tạo phiên theo vị trí, quét Barcode, kết thúc kiểm đếm, xử lý sách sai vị trí/thiếu và hoàn tất hoặc hủy phiên.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-28 (Incident Resolution Sync):** Khi báo sự cố hợp lệ, hệ thống BẮT BUỘC chuyển BookCopy sang `unavailable` và giảm `Book.availableQuantity` đúng 1 trong cùng transaction. Khi bác bỏ báo cáo hoặc khôi phục bản sao hỏng sau sửa chữa, hệ thống BẮT BUỘC chuyển BookCopy về `good/available` và tăng `availableQuantity` đúng 1. Kết luận `damaged/lost` không giảm lần thứ hai.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-48 (Ghi nhận sự cố Bản sao với vô hiệu hóa tức thì):** WHEN `BookCopyIncidentServlet.doPost(action=report)` nhận `barcode`, `incidentType` và `description`, THE system SHALL: (1) chỉ chấp nhận type `damaged/lost`, mô tả không rỗng và tối đa 1000 ký tự, (2) khóa và tìm BookCopy theo Barcode, (3) chỉ chấp nhận BookCopy `condition='good'`, `status='available'`, chưa có incident `pending/investigating`, (4) mở transaction, INSERT `BookCopyIncident(status='pending')`, (5) UPDATE BookCopy `status='unavailable'` nhưng chưa đổi condition, (6) giảm `Book.availableQuantity` đúng 1, (7) ghi Audit Log cho incident và BookCopy, (8) commit; WHERE lỗi thì rollback.
  * *Mapping:* UC-28 / BR-28
* **FR-49 (Xử lý vòng đời sự cố và phục hồi số lượng):** WHEN xử lý incident, THE system SHALL tuân theo state machine: (1) `investigate`: chỉ `pending -> investigating`; (2) `resolve`: từ `pending/investigating -> resolved`, cập nhật BookCopy.condition thành `damaged` hoặc `lost`, giữ `status='unavailable'`, không đổi số lượng lần nữa; (3) `reject`: từ `pending/investigating -> rejected`, đưa BookCopy về `available` và tăng `availableQuantity` 1; (4) `restore`: chỉ incident `resolved` loại `damaged` có BookCopy `damaged/unavailable`, đưa BookCopy về `good/available`, tăng `availableQuantity` 1 và nối ghi chú sửa chữa vào resolution. Mọi nhánh phải khóa bản ghi, ghi Audit Log và commit/rollback nguyên tử.
  * *Mapping:* UC-28 / BR-28
* **FR-50 (Tạo và xử lý phiên Kiểm kê Kho với 8 action):** WHEN `InventoryReconciliationServlet` nhận action, THE system SHALL: (1) `create`: validate location/note, INSERT `InventorySession(status='draft')`, snapshot BookCopy condition `good` tại location thành `InventoryItem(result='pending')`; (2) `start`: `draft -> counting`; (3) `scan`: chỉ trong `counting`, khóa BookCopy theo Barcode, ghi `matched` nếu location trùng vị trí phiên, ngược lại `misplaced`; (4) `finish-counting`: đổi item `pending -> missing`, phiên `counting -> reviewing`; (5) `resolve-misplaced`: chỉ trong `reviewing`, cập nhật BookCopy.location về vị trí quét và đánh dấu item đã xử lý bằng `resolvedAt`; (6) `resolve-missing`: chỉ BookCopy `good/available`, tạo incident `lost/pending`, chuyển copy `unavailable`, giảm `availableQuantity` và đánh dấu item đã xử lý; (7) `complete`: chỉ `reviewing -> completed` khi không còn item `missing/misplaced` chưa xử lý; (8) `cancel`: phiên chưa kết thúc có thể chuyển `cancelled`. Mỗi action thay đổi dữ liệu phải dùng transaction và Audit Log.
  * *Mapping:* UC-29 / BR-28
* **FR-51 (DEPRECATED - Logic merged into FR-50):** Logic kết luận phiên kiểm kê đã được tích hợp vào action `complete` của FR-50; không triển khai luồng độc lập.
  * *Mapping:* UC-29

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
- [ ] Resolve chỉ đổi condition thành damaged/lost; không trừ tồn kho lần thứ hai.
- [ ] Reject phục hồi BookCopy available và tăng tồn kho đúng 1.
- [ ] Chỉ incident damaged đã resolved được restore sau sửa chữa; incident lost không được restore.
- [ ] Phiên kiểm kê đi đúng `draft -> counting -> reviewing -> completed`, hoặc chuyển `cancelled` khi chưa kết thúc.
- [ ] Scan đúng vị trí tạo matched; scan khác vị trí tạo misplaced; bản sao kỳ vọng chưa scan trở thành missing.
- [ ] Không thể complete khi còn missing/misplaced chưa xử lý.
- [ ] Resolve missing tạo incident lost pending, ngừng lưu thông BookCopy và giảm tồn kho đúng 1.
- [ ] Vai trò ngoài LIBRARIAN nhận HTTP 403; UI không có nhãn/thông báo tiếng Anh.

## 9. Out of Scope (Phạm vi không thực hiện)
* Tạo/cập nhật metadata Book, nhập BookCopy và import Excel (F4 `feat-bookManagement`).
* Nhận trả sách và tính phạt do hỏng/mất (F6/F9).
* Tính khấu hao, thanh lý hoặc hard-delete BookCopy.
* Tự động hoàn tất incident hoặc tự sửa chênh lệch kiểm kê không có xác nhận Thủ thư.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* F13 giữ nguyên mã UC-28, UC-29, BR-28, FR-48..51 trong `diagram/spec-UC-BR-FR.txt`.
* `missing` là kết quả kiểm kê; khi xử lý sẽ tạo incidentType `lost`, vì schema không cho phép incidentType `missing`.
