# Feature Specification: Tách Nghiệp Vụ Check-in Hỏng/Mất và Kết Luận Sự Cố (Checkin-Incident Decouple)

**Feature Branch**: `feat/checkin-incident-decouple`
**Created**: 2026-08-01
**Status**: Approved

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Tái thiết kế luồng check-in hỏng/mất tại quầy (F6 `DeskCirculationService`) để khi Thủ thư nhận sách hỏng hoặc mất, hệ thống **chỉ ghi nhận nghi vấn** bằng cách tạm ngưng bản sao (`BookCopy → unavailable`) và tạo sự cố ở trạng thái chờ (`BookCopyIncident → pending`).

Tất cả các hành động phạt đền bù, khóa tài khoản và gạch tên khỏi tổng kho được **chuyển sang phân hệ F13 (Book Maintenance)** — nơi Thủ thư chuyên trách xác minh và đưa ra kết luận chính thức. Điều này tránh rủi ro bấm nhầm nút tại quầy gây ra các thay đổi dữ liệu không thể đảo ngược.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Ghi nhận nghi vấn hỏng/mất khi check-in tại quầy (F6); Xác minh và kết luận/bác bỏ sự cố tại F13.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-19 (Desk Check-in):** Actor: Librarian | (Nhận sách tại quầy): Nhận lại sách, ghi nhận nghi vấn hỏng/mất nếu có, tạm ngưng lưu thông bản sao và gửi sự cố sang F13.
* **UC-28 (Report & Resolve Book Incident):** Actor: Librarian | (Xác minh & Kết luận sự cố): F13 xác minh sự cố pending, kết luận damaged/lost (tạo Fine, khóa tài khoản, loại khỏi kho) hoặc bác bỏ (khôi phục bản sao).

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-24 (Damaged/Lost Incident Decouple Policy):**
  1. Khi nhận trả sách `damaged`/`lost` tại quầy, hệ thống **chỉ** đổi `BorrowRecord.status = 'returned'`, `BookCopy.status = 'unavailable'` và tạo `BookCopyIncident(status='pending', borrowRecordId=BR_ID)`.
  2. KHÔNG tự động tạo Fine đền bù, KHÔNG tạo Payment, KHÔNG thêm UserLockReason, KHÔNG khóa tài khoản, KHÔNG giảm `totalQuantity` ngay tại F6.
  3. Khi F13 kết luận `resolve damaged`: Tạo Fine đền bù, Payment pending, thêm UserLockReason('unpaid'), khóa tài khoản. `totalQuantity` giữ nguyên.
  4. Khi F13 kết luận `resolve lost`: Như damaged, thêm: giảm `totalQuantity` 1, set `removedFromInventory = true`.
  5. Khi F13 `reject`: Khôi phục `BookCopy.status = 'available'`, `condition = 'good'`, tăng `availableQuantity` 1 (hoặc đôn hàng chờ). Không phạt, không khóa.

## 4. Functional Requirements (Yêu cầu chức năng)
* **FR-001**: Hệ thống PHẢI thay đổi luồng Check-in Hỏng/Mất (UC-19) để CHỈ ghi nhận nghi vấn — tạo `BookCopyIncident(status='pending')`, cập nhật `BookCopy(status='unavailable')`, kết thúc `BorrowRecord(status='returned')` — mà KHÔNG tạo Fine đền bù, KHÔNG tạo Payment, KHÔNG thêm UserLockReason, KHÔNG khóa tài khoản, KHÔNG giảm `totalQuantity`.
* **FR-002**: Hệ thống PHẢI giữ nguyên `Book.availableQuantity` khi check-in hỏng/mất (vì sách bị mượn đã bị trừ 1 từ trước, khi chuyển sang unavailable thì không cộng trả lại 1).
* **FR-003**: Hệ thống PHẢI vẫn tính và tạo Fine quá hạn (overdue fine) nếu sách trả trễ, kể cả khi condition là `damaged`/`lost` — phạt quá hạn độc lập với phạt đền bù.
* **FR-004**: Bảng `BookCopyIncident` PHẢI được bổ sung cột `borrowRecordId INT NULL` (FK → `BorrowRecord`). Khi F6 tạo incident từ check-in, hệ thống PHẢI gán `borrowRecordId` chính xác.
* **FR-005**: F13 (UC-28) PHẢI hỗ trợ kết luận sự cố `pending` do check-in tạo ra: resolve damaged (tạo Fine đền bù + khóa tài khoản), resolve lost (như damaged + giảm `totalQuantity` + `removedFromInventory=true`), hoặc reject (khôi phục BookCopy + tăng tồn kho).
* **FR-006**: Hệ thống PHẢI ghi Audit Log cho mọi thao tác: ghi nhận nghi vấn tại F6, kết luận/bác bỏ tại F13.
* **FR-007**: Hệ thống PHẢI gửi email thông báo phạt đền bù bất đồng bộ SAU KHI F13 kết luận (không phải sau check-in).

## 5. User Scenarios

### User Story 1 - Thủ thư nhận trả sách nghi hỏng/mất tại quầy (P1)
- **Given** sách đang được mượn, **When** Thủ thư quét barcode chọn `damaged` hoặc `lost`, **Then** `BorrowRecord.status = 'returned'`, `BookCopy.status = 'unavailable'`, `BookCopyIncident.status = 'pending'`, **KHÔNG** phạt đền bù, **KHÔNG** khóa tài khoản.

### User Story 2 - F13 xác minh sự cố và kết luận (P1)
- **Given** incident `pending` từ check-in, **When** F13 resolve `damaged`/`lost`, **Then** tạo Fine đền bù, Payment, UserLockReason, khóa tài khoản (và giảm `totalQuantity` nếu lost).
- **Given** incident `pending` từ check-in, **When** F13 `reject`, **Then** `BookCopy` khôi phục `available`, không phạt.

### User Story 3 - Truy vết liên kết giữa Sự cố và Lượt mượn (P2)
- Cột `borrowRecordId` liên kết incident với lượt mượn gốc, hiển thị trên F13.

## 6. Acceptance Criteria
- [ ] 100% lần check-in hỏng/mất tại quầy chỉ tạo incident `pending`, không tạo Fine đền bù, không khóa tài khoản.
- [ ] Phạt quá hạn (overdue) vẫn được tính đúng khi trả sách trễ hạn + hỏng/mất.
- [ ] 100% incident `pending` từ check-in có thể được F13 resolve hoặc reject thành công.
- [ ] Bác bỏ (reject) tại F13 trả sách về `available` an toàn trong dưới 2 phút.
