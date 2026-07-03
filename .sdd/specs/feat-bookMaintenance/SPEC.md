# Feature Specification: Bảo trì sách và Kiểm kê (Book Maintenance)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp các chức năng báo cáo và xử lý sự cố rách, hỏng, mất sách vật lý của các bản sao và quy trình kiểm kê kho sách định kỳ để đối chiếu dữ liệu thực tế trên kệ so với hệ thống.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Báo cáo sự cố bản sao sách, thực hiện quy trình kiểm kê kho.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-28 (Report Book Incident):** Actor: Librarian | (Báo cáo sự cố sách): Ghi nhận và xử lý các sự cố vật lý của bản sao sách (mất, rách, hỏng hóc).
* **UC-29 (Inventory Reconciliation):** Actor: Librarian | (Kiểm kê kho): Rà soát, đối chiếu số lượng sách thực tế trên kệ so với dữ liệu hệ thống.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-28 (Report Book Incident):** Actor: Librarian | (Báo cáo sự cố sách): Ghi nhận và xử lý các sự cố vật lý của bản sao sách (mất, rách, hỏng hóc).
* **UC-29 (Inventory Reconciliation):** Actor: Librarian | (Kiểm kê kho): Rà soát, đối chiếu số lượng sách thực tế trên kệ so với dữ liệu hệ thống.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-28 (Report Book Incident):** Actor: Librarian | (Báo cáo sự cố sách): Ghi nhận và xử lý các sự cố vật lý của bản sao sách (mất, rách, hỏng hóc).
* **UC-29 (Inventory Reconciliation):** Actor: Librarian | (Kiểm kê kho): Rà soát, đối chiếu số lượng sách thực tế trên kệ so với dữ liệu hệ thống.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-28 (Incident Resolution Sync):** Khi ghi nhận báo cáo sự cố (Report Incident), hệ thống BẮT BUỘC phải tức thời vô hiệu hóa bản sao (status='unavailable') và trừ đi 1 availableQuantity của Đầu sách tương ứng. Khi bác bỏ (Reject Incident), phải cộng lại availableQuantity.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-48 (Ghi nhận sự cố Bản sao với vô hiệu hóa tức thì):** WHEN BookCopyIncidentServlet.doPost(action=report) nhận báo cáo sự cố, THE system SHALL: (1) Validate bookCopyId tồn tại, (2) Mở DB Transaction, (3) INSERT BookCopyIncident(bookCopyId, incidentType IN ['damaged','lost','missing'], description, status='open', reportedBy=librarianId, reportedAt=NOW()), (4) **Vô hiệu hóa bản sao tức thì theo BR-28**: UPDATE BookCopy SET status='unavailable', condition=incidentType, (5) UPDATE Book SET availableQuantity = availableQuantity - 1 WHERE bookId=?, (6) INSERT AuditLog(REPORT_BOOK_INCIDENT), (7) conn.commit(), (8) WHERE SQLException: rollback.
  * *Mapping:* UC-28 / BR-28
* **FR-49 (Giải quyết sự cố Bản sao với phục hồi số lượng):** WHEN BookCopyIncidentServlet.doPost(action=resolve) xử lý sự cố, THE system SHALL: (1) Load BookCopyIncident by incidentId, (2) Mở DB Transaction, (3) UPDATE BookCopyIncident SET status='resolved', resolution=?, resolvedBy=librarianId, resolvedAt=NOW(), (4) **Phân nhánh theo resolution**: IF resolution='rejected' (sự cố không xảy ra): UPDATE BookCopy SET status='available', condition='good', UPDATE Book SET availableQuantity = availableQuantity + 1 (phục hồi số lượng theo BR-28), ELSE IF resolution='repaired': UPDATE BookCopy SET status='available', condition='good', UPDATE availableQuantity + 1, ELSE IF resolution='disposed': UPDATE BookCopy SET status='disposed', condition='lost', UPDATE Book.totalQuantity = totalQuantity - 1 (loại bỏ vĩnh viễn), (5) INSERT AuditLog(RESOLVE_INCIDENT), (6) conn.commit().
  * *Mapping:* UC-28 / BR-28
* **FR-50 (Tạo phiên Kiểm kê Kho với 8 action):** WHEN InventoryReconciliationServlet nhận các action khác nhau, THE system SHALL xử lý theo state machine: **action=create**: INSERT InventorySession(location, note, status='created', startedBy=librarianId, startedAt=NOW()), **action=start**: UPDATE status='in_progress', **action=scan**: INSERT InventoryItem(sessionId, bookCopyId FROM barcode, expectedLocation=BookCopy.location, scannedLocation=session.location, result='scanned'), **action=finish-counting**: Tính toán chênh lệch: SELECT BookCopy WHERE location=session.location AND NOT EXISTS InventoryItem → INSERT InventoryItem với result='missing', UPDATE session.status='counting_complete', **action=resolve-misplaced**: UPDATE BookCopy.location = scannedLocation WHERE itemId, UPDATE InventoryItem.result='resolved', **action=resolve-missing**: INSERT BookCopyIncident(type='missing') + UPDATE BookCopy.status='unavailable', **action=complete**: UPDATE session.status='completed', completedBy=librarianId, completedAt=NOW(), **action=cancel**: UPDATE session.status='cancelled'.
  * *Mapping:* UC-29
* **FR-51 (DEPRECATED - Logic merged into FR-50):** Logic kết luận kiểm kê đã được tích hợp vào FR-50 với action=complete. Không còn sử dụng FR riêng biệt.
  * *Mapping:* (merged into FR-50)

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Độ chính xác: Đảm bảo số lượng availableQuantity luôn đồng bộ với trạng thái thực của các bản sao.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng BookCopyIncident
* `incidentId` (INT, PK)
* `bookCopyId` (INT, FK)
* `incidentType` (VARCHAR(20))
* `description` (VARCHAR(1000))
* `status` (VARCHAR(20))
* `reportedBy` (INT)
* `reportedAt` (TIMESTAMP)
* `resolvedBy` (INT)
* `resolvedAt` (TIMESTAMP)

### Bảng InventorySession
* `inventorySessionId` (INT, PK)
* `location` (VARCHAR(255))
* `status` (VARCHAR(20))
* `startedBy` (INT)
* `startedAt` (TIMESTAMP)
* `completedAt` (TIMESTAMP)

### Bảng InventoryItem
* `inventoryItemId` (INT, PK)
* `inventorySessionId` (INT, FK)
* `bookCopyId` (INT, FK)
* `expectedLocation` (VARCHAR(255))
* `scannedLocation` (VARCHAR(255))
* `result` (VARCHAR(20))



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE bản sao đang được mượn, THE system SHALL cảnh báo thủ thư khi cố gắng báo cáo sự cố mất/hỏng.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Báo cáo sách hỏng: Ghi nhận sự cố ->availableQuantity của Book giảm đi 1.
- [ ] Quét kiểm kê sai vị trí: Quét barcode cuốn sách ở Kệ A trong khi hệ thống lưu Kệ B -> Trạng thái chênh lệch hiển thị 'misplaced'.

## 9. Out of Scope (Phạm vi không thực hiện)
* Tính toán khấu hao giá trị sách theo thời gian.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.