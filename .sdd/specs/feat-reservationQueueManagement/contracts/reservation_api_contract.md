# API & Servlet Interface Contract: Librarian Reservation Queue Management

## Endpoints dành riêng cho Thủ thư (`/librarian/*`)

### 1. `GET /librarian/reservation-queue`
* **Mục đích**: Tra cứu & hiển thị danh sách hàng chờ đặt trước toàn hệ thống cho Thủ thư.
* **Request Parameters**:
  - `keyword`: String (Từ khóa tìm kiếm theo tên sách, ISBN, tên độc giả, mã sinh viên/giảng viên)
  - `bookId`: INT (Lọc theo một tựa sách cụ thể)
  - `status`: `'all'` | `'pending'` | `'ready_for_pickup'` | `'fulfilled'` | `'cancelled'` (Mặc định: `'all'`)
  - `page`: INT (Số trang, mặc định: 1)
* **Response View**: Forward sang `web/librarian/reservation-queue.jsp` với các request attributes:
  - `queueList`: `List<ReservationQueueItemDTO>`
  - `currentPage`: INT
  - `totalPages`: INT
  - `totalItems`: INT

---

### 2. `POST /librarian/reservation-queue`
* **Mục đích**: Thực hiện hủy lượt đặt trước tại quầy của Thủ thư.
* **Request Parameters**:
  - `action`: `'cancel_by_librarian'`
  - `reservationId`: INT (Bắt buộc)
  - `reason`: String (Bắt buộc nhập lý do hủy)
* **Response (Redirect / Flash Notification)**:
  - Redirect về `/librarian/reservation-queue` kèm `messageSuccess` hoặc `messageError` trong Session.
