# Feature Specification: Bảo trì sách và Kiểm kê (Book Maintenance)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp các chức năng báo cáo và xử lý sự cố rách, hỏng, mất sách vật lý của các bản sao và quy trình kiểm kê kho sách định kỳ để đối chiếu dữ liệu thực tế trên kệ so với hệ thống.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Báo cáo sự cố bản sao sách, thực hiện quy trình kiểm kê kho.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-28 (Incident Resolution Sync):** Khi ghi nhận báo cáo sự cố (Report Incident), hệ thống BẮT BUỘC phải tức thời vô hiệu hóa bản sao (status='unavailable') và trừ đi 1 availableQuantity của Đầu sách tương ứng. Khi bác bỏ (Reject Incident), phải cộng lại availableQuantity.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-48 (Ghi nhận sự cố bản sao):** WHEN thủ thư báo cáo sự cố (damaged/lost), THE system SHALL cập nhật trạng thái bản sao thành 'unavailable', trừ 1 availableQuantity của đầu sách, tạo bản ghi BookCopyIncident status='pending'.\n* **FR-49 (Giải quyết sự cố):** WHEN thủ thư xử lý sự cố, THE system SHALL cập nhật status incident thành 'resolved'. WHERE bác bỏ hoặc sửa chữa xong bản sao, SHALL đưa trạng thái bản sao về 'available' và cộng lại availableQuantity.\n* **FR-50 (Quy trình kiểm kê kho sách):** WHEN thủ thư kiểm kê, THE system SHALL hỗ trợ các hành động: tạo phiên kiểm kê, quét barcode bản sao trên kệ đối chiếu vị trí, tự động tính toán bản sao bị mất tích (missing) hoặc sai vị trí (misplaced), giải quyết chênh lệch và hoàn thành phiên.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Độ chính xác: Đảm bảo số lượng availableQuantity luôn đồng bộ với trạng thái thực của các bản sao.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng BookCopyIncident\n* `incidentId` (INT, PK)\n* `bookCopyId` (INT, FK)\n* `incidentType` (VARCHAR(20))\n* `description` (VARCHAR(1000))\n* `status` (VARCHAR(20))\n* `reportedBy` (INT)\n* `reportedAt` (TIMESTAMP)\n* `resolvedBy` (INT)\n* `resolvedAt` (TIMESTAMP)\n\n### Bảng InventorySession\n* `inventorySessionId` (INT, PK)\n* `location` (VARCHAR(255))\n* `status` (VARCHAR(20))\n* `startedBy` (INT)\n* `startedAt` (TIMESTAMP)\n* `completedAt` (TIMESTAMP)\n\n### Bảng InventoryItem\n* `inventoryItemId` (INT, PK)\n* `inventorySessionId` (INT, FK)\n* `bookCopyId` (INT, FK)\n* `expectedLocation` (VARCHAR(255))\n* `scannedLocation` (VARCHAR(255))\n* `result` (VARCHAR(20))\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE bản sao đang được mượn, THE system SHALL cảnh báo thủ thư khi cố gắng báo cáo sự cố mất/hỏng.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Báo cáo sách hỏng: Ghi nhận sự cố ->availableQuantity của Book giảm đi 1.\n- [ ] Quét kiểm kê sai vị trí: Quét barcode cuốn sách ở Kệ A trong khi hệ thống lưu Kệ B -> Trạng thái chênh lệch hiển thị 'misplaced'.

## 9. Out of Scope (Phạm vi không thực hiện)
* Tính toán khấu hao giá trị sách theo thời gian.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
