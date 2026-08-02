# Feature Specification: Bảo trì sách và Kiểm kê (Book Maintenance)
# Version: 1.4 | Chủ sở hữu: Chuong | Ngày cập nhật: 2026-08-02 (Đồng bộ nghiệp vụ kiểm kê thực tế)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp quy trình cho Thủ thư ghi nhận, xác minh và xử lý bản sao hỏng/mất; đồng thời thực hiện kiểm kê theo vị trí để phát hiện sách khớp, thiếu hoặc sai vị trí. Mọi thay đổi trạng thái bản sao, số lượng tồn kho, dữ liệu kiểm kê và Audit Log phải chạy nguyên tử, không hard-delete BookCopy/Incident/InventorySession.

Spec này căn theo `diagram/business-rules-specification.md`, `diagram/detailed-UC-specifications.md`, schema PostgreSQL và implementation hiện có. Không dùng `diagram/spec-UC-BR-FR.txt` làm nguồn mapping chuẩn vì file đó đang có mã UC/BR/FR trùng hoặc lệch sang feature khác.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Tác nhân duy nhất được xem và thực hiện nghiệp vụ F13.
* **Vai trò khác:** `ADMIN`, `ADMIN`, `STUDENT`, `LECTURER` và vai trò khác nhận HTTP 403 tại `/librarian/book-management/incidents`, `/librarian/book-management/inventory` hoặc legacy `/book-management/*`.
* **Người chưa đăng nhập:** Được chuyển tới trang đăng nhập.

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-28 (Report Book Incident):** Actor: Librarian | (Báo cáo sự cố sách): Thủ thư tìm kiếm, báo hỏng/mất theo Barcode, chuyển xác minh, kết luận, bác bỏ, khôi phục bản sao hỏng sau sửa chữa hoặc loại khỏi tổng kho bằng soft flag.
* **UC-29 (Inventory Reconciliation):** Actor: Librarian | (Kiểm kê kho): Thủ thư tạo draft theo vị trí, bắt đầu để chụp snapshot, quét Barcode, kết thúc kiểm đếm, xử lý sách sai vị trí/thiếu với lựa chọn vật lý rõ ràng, rồi hoàn tất hoặc hủy phiên theo state machine.

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F13 Book Maintenance. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-28 (Incident Resolution Sync):** `Book.availableQuantity` là số suất chưa cấp, không phải phép đếm trực tiếp BookCopy `available`. Khi một BookCopy khả dụng gặp sự cố: nếu còn suất tự do thì giảm `availableQuantity` 1; nếu số lượng đã bằng 0 thì giữ 0 và đưa Reservation `readypickup` mới nhất về đầu hàng `pending`. Khi bản sao được phục hồi: ưu tiên cấp suất cho người đầu hàng chờ và giữ nguyên số lượng; chỉ tăng `availableQuantity` khi không có người chờ. Mọi thay đổi phải cùng transaction; không hard-delete BookCopy.
* **BR-44 (Inventory Reconciliation Data):** Dữ liệu kiểm kê gần nhất phải đủ để đối chiếu số lượng/vị trí bản sao trong báo cáo quản lý. Trong F13, quy tắc này được đáp ứng bằng InventorySession và InventoryItem; việc hiển thị báo cáo quản trị tổng hợp thuộc feature báo cáo nếu có.
* **BR-70 (Single Active Inventory Session):** Có thể tồn tại nhiều phiên `draft`, nhưng toàn hệ thống chỉ được có tối đa một InventorySession ở trạng thái `counting` hoặc `reviewing`; Database unique partial index là lớp bảo vệ cuối cho request đồng thời.


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-48 (Ghi nhận sự cố bản sao với vô hiệu hóa tức thì):** WHEN báo damaged/lost hợp lệ, THE system SHALL khóa Book trước rồi khóa BookCopy, tạo incident và chuyển BookCopy sang `unavailable`. WHERE `availableQuantity>0` thì giảm 1. WHERE `availableQuantity=0` thì không trừ âm, chuyển Reservation `readypickup` mới nhất về `pending/queuePosition=1`, dịch hàng chờ và gửi thông báo. Ghi Audit Log và commit nguyên tử.
  * *Mapping:* UC-28 / BR-28
* **FR-49 (Xử lý vòng đời sự cố và phục hồi số lượng):** WHEN reject hoặc restore làm BookCopy trở lại `available`, THE system SHALL kiểm tra hàng chờ: có người chờ thì đôn người đầu tiên thành `readypickup/bookCopyId=NULL` và không tăng số lượng; không có người chờ mới tăng `availableQuantity` 1. Nếu đầu sách đang `unavailable`, bản sao không được khôi phục lưu thông. Các nhánh resolve/remove giữ quy tắc soft-delete và cập nhật totalQuantity nguyên tử.
  * *Mapping:* UC-28 / BR-28
* **FR-50 (Tạo và xử lý phiên kiểm kê kho với 8 action):** WHEN InventoryReconciliationServlet nhận action, THE system SHALL hỗ trợ create, start, scan, finish-counting, resolve-misplaced, resolve-missing, complete và cancel theo state machine F13. Create chỉ tạo draft; start mới chụp snapshot và chặn phiên active khác. Scan chỉ nhận BookCopy `available/good/chưa thanh lý`, chuẩn hóa location và từ chối Barcode trùng trong phiên. Finish-counting từ chối nếu có bản sao kỳ vọng nhưng chưa quét bản nào, chuyển bản sao đã đổi trạng thái/ra ngoài phạm vi thành `excluded`, phần chưa quét còn hợp lệ thành `missing`. Resolve-misplaced nhận `return_to_expected|relocate_to_scanned`: nhánh đầu chỉ xác nhận đã đưa sách về vị trí gốc, nhánh sau mới đổi location; cả hai khóa item/copy và kiểm tra snapshot. Resolve-missing cũng kiểm tra `available/good/chưa thanh lý`, location snapshot và incident mở trước khi tạo incident lost/pending; việc giảm suất hoặc lùi Reservation `readypickup` tuân BR-28. Complete chỉ cho phép reviewing khi không còn chênh lệch chưa xử lý; mọi thay đổi dùng transaction và Audit Log.
  * *Mapping:* UC-29 / BR-44, BR-70; BR-28 cho nhánh resolve-missing
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
* `status` (`available`, `unavailable`, `borrowed`)
* `removedFromInventory` (BOOLEAN, DEFAULT FALSE)
* `removedFromInventoryAt` (TIMESTAMP, nullable)
* `removedFromInventoryBy` (INT, FK -> User, nullable)
* Constraint: chỉ cho phép `removedFromInventory=true` khi BookCopy `status='unavailable'`, `condition IN ('damaged','lost')` và đã có thời điểm loại khỏi kho.

### Bảng InventorySession
* `inventorySessionId` (INT, PK), `location` (VARCHAR(255)), `note` (VARCHAR(1000))
* `status` (`draft`, `counting`, `reviewing`, `completed`, `cancelled`)
* `createdBy`, `createdAt`, `startedBy`, `startedAt`, `completedBy`, `completedAt`, `cancelledBy`, `cancelledAt`

### Bảng InventoryItem
* `inventoryItemId` (INT, PK), `inventorySessionId` (INT, FK), `bookCopyId` (INT, FK)
* `expectedLocation`, `scannedLocation`
* `result` (`pending`, `matched`, `missing`, `misplaced`, `excluded`)
* `scannedBy`, `scannedAt`, `resolution`, `resolvedBy`, `resolvedAt`
* Mỗi cặp `(inventorySessionId, bookCopyId)` là duy nhất.

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE Barcode không tồn tại, BookCopy đang mượn/unavailable hoặc đã có incident mở, THE system SHALL từ chối báo sự cố.
* WHERE action không phù hợp trạng thái nguồn, incident/session/item không tồn tại hoặc chênh lệch đã xử lý, THE system SHALL từ chối mà không thay đổi dữ liệu.
* WHERE scan Barcode không tồn tại/trùng trong phiên, finish-counting chưa quét bản sao dự kiến nào, resolve dùng snapshot vị trí đã cũ hoặc complete còn chênh lệch chưa xử lý, THE system SHALL giữ nguyên trạng thái phiên và hiển thị lỗi tiếng Việt.
* WHERE lỗi Database bất ngờ, THE system SHALL rollback, log chi tiết ở server và không lộ stack trace ra UI.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Báo sự cố hợp lệ tạo incident `pending`, chuyển BookCopy `unavailable`; giảm một suất tự do hoặc lùi ready hold nếu sức chứa đã cấp hết, không làm số lượng âm và có Audit Log.
- [ ] Không thể báo sự cố cho copy borrowed/unavailable hoặc copy đã có incident mở.
- [ ] Resolve chỉ đổi condition thành damaged/lost; không trừ `availableQuantity` lần thứ hai.
- [ ] Resolve lost set `removedFromInventory=true`, giảm `totalQuantity` đúng 1 và không xóa BookCopy.
- [ ] Reject/restore phục hồi BookCopy available, ưu tiên người đầu hàng pending; chỉ tăng `availableQuantity` 1 khi hàng chờ trống.
- [ ] Chỉ incident damaged đã resolved được restore sau sửa chữa; incident lost không được restore.
- [ ] Incident damaged đã resolved và không thể sửa được có thể loại khỏi kho; hệ thống set `removedFromInventory=true`, giảm `totalQuantity` đúng 1, không xóa BookCopy và không cho loại khỏi kho lần 2.
- [ ] Incident `resolved` do F6 tạo khi check-in hỏng/mất được hiển thị trên F13 nhưng không được resolve/reject lại; incident `damaged` vẫn restore được sau sửa chữa nếu chưa bị loại khỏi kho.
- [ ] Phiên kiểm kê đi đúng `draft -> counting -> reviewing -> completed`, hoặc chuyển `cancelled` khi chưa kết thúc.
- [ ] Snapshot chỉ xuất hiện khi start; có thể xem nhiều draft nhưng chỉ một phiên counting/reviewing trên toàn hệ thống.
- [ ] Scan đúng vị trí tạo matched; scan khác vị trí tạo misplaced; quét lặp bị từ chối; bản sao đổi trạng thái/vị trí trong lúc kiểm đếm trở thành excluded thay vì bị kết luận cưỡng ép.
- [ ] Resolve misplaced theo `return_to_expected` không đổi location; chỉ `relocate_to_scanned` mới đổi location sau khi kiểm tra copy còn available/good/chưa thanh lý và snapshot chưa cũ.
- [ ] Không thể complete khi còn missing/misplaced chưa xử lý.
- [ ] Resolve missing tạo incident lost pending và ngừng lưu thông BookCopy; nếu còn suất tự do thì giảm 1, nếu sức chứa đã cấp hết thì lùi Reservation readypickup mới nhất về đầu hàng pending, không trừ âm.
- [ ] Vai trò ngoài LIBRARIAN nhận HTTP 403; UI không có nhãn/thông báo tiếng Anh.

## 9. Out of Scope (Phạm vi không thực hiện)
* Tạo/cập nhật metadata Book, nhập BookCopy và import Excel (F4 `feat-bookManagement`).
* Nhận trả sách và tính phạt do hỏng/mất (F6/F9); F13 chỉ tiếp nhận incident F6 đã `resolved` để tra cứu hoặc restore bản sao `damaged` sau sửa chữa.
* Tính khấu hao, thanh lý tài sản kế toán hoặc hard-delete BookCopy; F13 chỉ hỗ trợ loại khỏi tổng kho phục vụ bằng soft flag `removedFromInventory`.
* Tự động hoàn tất incident F13 hoặc tự sửa chênh lệch kiểm kê không có xác nhận Thủ thư; ngoại lệ là incident do F6 tạo đã được Thủ thư kết luận trực tiếp khi nhận trả sách.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* `missing` là kết quả kiểm kê; khi xử lý sẽ tạo `incidentType='lost'`, vì schema không cho phép incidentType `missing`.
* F13 dùng `BR-28`, `BR-44` và quy tắc hiện hữu `BR-70` cho giới hạn phiên active; FR registry vẫn là `FR-48..51` cho `UC-28/UC-29`.
