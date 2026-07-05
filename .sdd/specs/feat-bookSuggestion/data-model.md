# Data Model: Book Suggestions (F20)

## Overview
Tính năng Quản lý Đề xuất sách sử dụng 2 bảng mới: `BookSuggestion` (lưu trữ thông tin sách được giảng viên đề xuất) và `SuggestionVote` (lưu trữ thông tin vote của các giảng viên cho từng đề xuất).

## Entities

### 1. BookSuggestion

Lưu trữ thông tin chi tiết về các đề xuất sách được gửi bởi Giảng viên.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| `suggestionId` | `SERIAL / INT` | `PRIMARY KEY` | Khóa chính tự tăng |
| `title` | `VARCHAR(255)` | `NOT NULL` | Tiêu đề sách đề xuất |
| `author` | `VARCHAR(255)` | `NOT NULL` | Tác giả sách |
| `publisher` | `VARCHAR(255)` | `NULL` | Nhà xuất bản |
| `isbn` | `VARCHAR(20)` | `NULL` | Mã số tiêu chuẩn quốc tế |
| `reason` | `TEXT` | `NOT NULL` | Lý do đề xuất sách |
| `status` | `VARCHAR(20)` | `NOT NULL, DEFAULT 'pending'` | Trạng thái: `pending`, `acknowledged`, `rejected` |
| `voteCount` | `INT` | `NOT NULL, DEFAULT 1, CHECK (voteCount >= 0)` | Tổng số lượt vote (tối thiểu 0) |
| `librarianNote` | `TEXT` | `NULL` | Ghi chú của thủ thư khi đổi trạng thái |
| `createdBy` | `INT` | `NOT NULL, FK -> "User".userId` | ID của giảng viên tạo đề xuất |
| `reviewedBy` | `INT` | `NULL, FK -> "User".userId` | ID của thủ thư xét duyệt đề xuất |
| `createdAt` | `TIMESTAMP` | `NOT NULL, DEFAULT NOW()` | Thời gian tạo đề xuất |
| `updatedAt` | `TIMESTAMP` | `NOT NULL, DEFAULT NOW()` | Thời gian cập nhật cuối cùng |

### 2. SuggestionVote

Lưu trữ lịch sử vote để đảm bảo mỗi giảng viên chỉ vote 1 lần cho 1 đề xuất.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|---|---|---|---|
| `voteId` | `SERIAL / INT` | `PRIMARY KEY` | Khóa chính tự tăng |
| `suggestionId` | `INT` | `NOT NULL, FK -> BookSuggestion.suggestionId ON DELETE CASCADE` | ID đề xuất sách |
| `userId` | `INT` | `NOT NULL, FK -> "User".userId` | ID giảng viên vote |
| `votedAt` | `TIMESTAMP` | `NOT NULL, DEFAULT NOW()` | Thời gian thực hiện vote |

**Ràng buộc bổ sung:**
- Cần có `UNIQUE(suggestionId, userId)` để ngăn chặn spam vote.
- `ON DELETE CASCADE` trên khóa ngoại `suggestionId` để tự động xóa vote khi Giảng viên thực hiện hard DELETE đề xuất (nếu voteCount=1).
- **Indexes bắt buộc**: Cần tạo Index cho các cột `(status, voteCount, createdAt)` và `(title)` bằng `pg_trgm` (hoặc B-Tree cơ bản) để đạt SLA < 200ms.

## State Transitions
Vòng đời của trường `status` trong `BookSuggestion`:
- `pending`: Trạng thái mặc định khi mới tạo.
- `acknowledged`: Thủ thư ghi nhận đề xuất sẽ được xử lý/mua.
- `rejected`: Thủ thư từ chối đề xuất (soft delete từ góc nhìn business).
*(Lưu ý: Thủ thư có quyền chuyển đổi tự do giữa cả 3 trạng thái trên. Chỉ trường hợp Giảng viên tự hủy đề xuất khi `voteCount=1` mới sử dụng thao tác xóa cứng - hard DELETE khỏi database).*

## System Configurations
Bảng `SystemConfigurations` sẽ cần chèn thêm 1 bản ghi cấu hình giới hạn số đề xuất:
- `configKey`: `MAX_SUGGESTION_PER_LECTURER`
- `configValue`: `10`
- `configGroup`: `library`
- `description`: `Giới hạn số đề xuất đang ở trạng thái pending tối đa cho mỗi giảng viên`
