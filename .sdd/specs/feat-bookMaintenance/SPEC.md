# Feature Specification: Bảo trì & Kiểm kê sách (Book Maintenance & Inventory)
# Version: 1.2 | Chủ sở hữu: @chuong | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp công cụ cho Thủ thư (Librarian) ghi nhận các sự cố hỏng/mất sách (`BookCopyIncident`), theo dõi tiến trình sửa chữa, thanh lý sách hư hỏng nặng, và khởi tạo các đợt kiểm kê kho sách (`InventorySession`) để đối soát vị trí thực tế của sách trên kệ so với CSDL.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Khai báo sự cố hư hỏng/mất sách, cập nhật tiến độ xử lý sự cố, mở đợt kiểm kê kho, quét barcode kiểm kê, xử lý chênh lệch kiểm kê.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-24 (Report Incident):** Actor: Librarian | Ghi nhận sự cố hư hỏng, rách, mất trang hoặc thất lạc của một bản sao sách (`BookCopy`).
* **UC-25 (Resolve Incident):** Actor: Librarian | Cập nhật tình trạng xử lý sự cố (sửa xong, phục hồi, hoặc thanh lý/báo mất sách).
* **UC-26 (Inventory Reconciliation):** Actor: Librarian | Khởi tạo phiên kiểm kê, quét barcode kiểm định vị trí sách và chốt đối soát chênh lệch.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-24 (Incident Status Flow):** Trạng thái sự cố chuyển biến từ `pending` (Chờ xử lý) -> `under_repair` (Đang sửa chữa) -> `resolved` (Đã xử lý) hoặc `write_off` (Thanh lý/Báo mất).
* **BR-25 (Copy Availability on Incident):** Khi bản sao bị báo sự cố `pending` hoặc `under_repair`, trạng thái bản sao `BookCopy.status` BẮT BUỘC đổi thành `'maintenance'`. Khi báo `write_off`, trạng thái đổi thành `'lost'` và tự động giảm `availableQuantity` của `Book`.
* **BR-27 (Inventory Locking):** Trong thời gian đợt kiểm kê đang ở trạng thái `in_progress`, các sách nằm trong khu vực kiểm kê cần được đưa vào cảnh báo đối soát.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-22 (Ghi nhận sự cố sách):** WHEN Thủ thư gửi khai báo tại `BookCopyIncidentServlet`, THE system SHALL tạo bản ghi trong `BookCopyIncident` với `status='pending'`, đồng thời UPDATE `BookCopy.status='maintenance'`. Ghi `AuditLogs` với action `REPORT_INCIDENT`.
  * *Mapping:* UC-24 / BR-25
* **FR-23 (Xử lý và Chốt sự cố):** WHEN Thủ thư cập nhật kết quả xử lý sự cố, THE system SHALL: WHERE kết quả là `resolved`, UPDATE `BookCopy.status='available'` và cập nhật `condition` mới. WHERE kết quả là `write_off`, UPDATE `BookCopy.status='lost'` và giảm `availableQuantity` của `Book`. Ghi `AuditLogs`.
  * *Mapping:* UC-25 / BR-24, BR-25
* **FR-24 (Khởi tạo & Quét kiểm kê):** WHEN Thủ thư tạo đợt kiểm kê tại `InventoryReconciliationServlet`, THE system SHALL khởi tạo `InventorySession`. Khi quét barcode bản sao, hệ thống ghi nhận `InventoryItem`, so sánh `scannedLocation` với `expectedLocation` để phát hiện sách bị xếp sai kệ hoặc thất lạc.
  * *Mapping:* UC-26 / BR-27
* **FR-25 (Đối soát & Hoàn tất kiểm kê):** WHEN Thủ thư hoàn tất kiểm kê, THE system SHALL chốt danh sách sách thiếu (`missing`), sách sai vị trí (`mislocated`), tính tổng số lượng quét và đổi trạng thái `InventorySession.status='completed'`.
  * *Mapping:* UC-26

## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Chỉ LIBRARIAN và MANAGER có quyền ghi nhận sự cố và thực hiện kiểm kê.
* **Hiệu năng:** Luồng quét barcode kiểm kê phản hồi dưới 200ms để đảm bảo tốc độ làm việc tại kho sách.
* **Giao diện:** Đồ họa trực quan thể hiện màu sắc theo tình trạng sự cố (Đỏ: Mất, Vàng: Đang sửa, Xanh: Đã xong).

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `BookCopyIncident`
* `incidentId` (INT, PK), `bookCopyId` (FK), `incidentType`, `description`, `status` (pending/under_repair/resolved/write_off), `reportedBy` (FK), `reportedAt`, `resolvedBy` (FK), `resolvedAt`

### Bảng `InventorySession` & `InventoryItem`
* `inventorySessionId` (INT, PK), `location`, `status` (in_progress/completed), `startedBy`, `completedBy`
* `inventoryItemId` (INT, PK), `inventorySessionId` (FK), `bookCopyId` (FK), `expectedLocation`, `scannedLocation`, `result` (matched/mislocated/missing)

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** mã Barcode quét kiểm kê không tồn tại trong DB, **THE system SHALL** báo lỗi "Không tìm thấy mã vạch sách này trong CSDL".
* **WHERE** bản sao đang trong trạng thái mượn mà bị báo mất, **THE system SHALL** yêu cầu chốt quy trình xử lý phạt trước khi báo `write_off`.

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-MAINT-01] Báo sự cố hỏng sách thành công, chuyển BookCopy sang status 'maintenance'.
- [ ] [TC-MAINT-02] Chốt sự cố 'write_off' tự động chuyển BookCopy sang 'lost' và giảm availableQuantity của sách.
- [ ] [TC-MAINT-03] Tạo đợt kiểm kê và quét barcode ghi nhận đúng vị trí thực tế so với vị trí dự kiến.
- [ ] [TC-MAINT-04] Hoàn tất kiểm kê xuất báo cáo thống kê chính xác số sách trùng khớp, sai kệ và thất lạc.

## 8. Out of Scope (Phạm vi không thực hiện)
* Tự động quét kiểm kê bằng thiết bị RFID tần số cao (chỉ hỗ trợ Barcode).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện module sự cố và kiểm kê đối soát vị trí.
