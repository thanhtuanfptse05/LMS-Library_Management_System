# Endpoint Contracts: Desk Borrowing Management

**Feature**: `.sdd/specs/feat-borrowingsManagement`
**Base URL**: `/librarian/borrowings`

---

## 1. GET `/librarian/borrowings` (Xem & Tìm kiếm lượt mượn)

### Query Parameters
* `userKeyword` (optional): Từ khóa tìm kiếm theo tên hoặc mã độc giả (SV/GV).
* `barcodeKeyword` (optional): Từ khóa tìm kiếm theo mã vạch sách.
* `status` (optional): Bộ lọc trạng thái (`all`, `borrowed`, `overdue`).
* `fromDate` (optional): Ngày bắt đầu mượn (`yyyy-MM-dd`).
* `toDate` (optional): Ngày kết thúc mượn (`yyyy-MM-dd`).
* `page` (optional, default `1`): Trang hiện tại.

### Response
* **Success (200 OK):** Forward sang `WEB-INF/views/librarian/borrowings-management.jsp` kèm attributes:
  * `borrowings`: `List<BorrowingManagementDTO>`
  * `currentPage`: `int`
  * `totalPages`: `int`
  * `totalRecords`: `int`

---

## 2. POST `/librarian/borrowings` (Gửi Email Yêu cầu Thu hồi Sách)

### Form Parameters (`application/x-www-form-urlencoded`)
* `action`: `'sendRecallEmail'`
* `borrowRecordId`: `int` (ID lượt mượn)
* `recallReason`: `String` (Lý do thu hồi - Bắt buộc)

### Response
* **Success (302 Redirect to `/librarian/borrowings?success=email_sent`):**
  * Đẩy `EmailJob` vào `EmailService.enqueue(...)`.
  * Ghi `AuditLogs` (`actionType = 'SEND_RECALL_EMAIL'`).
* **Error Validation (302 Redirect to `/librarian/borrowings?error=missing_reason`):**
  * Nếu `recallReason` rỗng hoặc chỉ chứa khoảng trắng.
