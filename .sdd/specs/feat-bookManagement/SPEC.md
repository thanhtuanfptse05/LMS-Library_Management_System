# SPEC.md — Quản lý Sách và Kho vật lý
# Version: 1.0.0 | Owner: @tech-lead | Status: APPROVED

## 1. Context & Goal
Quản lý toàn bộ vòng đời của tài nguyên sách. Đảm bảo tính duy nhất của mã vạch và sự đồng bộ tuyệt đối về số lượng tồn kho (Inventory) mỗi khi có sự thay đổi về bản sao vật lý.

## 2. Actors & Roles
- **Librarian:** Toàn quyền truy cập CRUD (Tạo, Đọc, Sửa, Đổi trạng thái) Đầu sách, Bản sao vật lý, Danh mục và Thẻ.

## 3. Functional Requirements (EARS)
**Quản lý Đầu sách (Book Catalog)**
- **FR-F4-01:** WHEN Librarian gửi biểu mẫu tạo Đầu sách mới, THE system SHALL kiểm tra tính duy nhất của ISBN.
- **FR-F4-02:** WHERE ISBN hợp lệ, THE system SHALL thực thi lệnh INSERT vào bảng `Book` VÀ gán giá trị mặc định `totalQuantity` = 0, `availableQuantity` = 0.
- **FR-F4-03:** WHERE ISBN đã tồn tại, THE system SHALL từ chối lưu và trả về lỗi HTTP 400 kèm thông điệp "Trùng lặp ISBN".
- **FR-F4-04:** WHEN Librarian cập nhật thông tin Đầu sách, THE system SHALL chặn bất kỳ hành vi sửa đổi nào đối với cột `isbn` (BR-18).

**Quản lý Bản sao vật lý (Book Copy)**
- **FR-F4-05:** WHEN Librarian quét Barcode để thêm Bản sao vật lý, THE system SHALL kiểm tra tính duy nhất của mã vạch trong bảng `BookCopy`.
- **FR-F4-06:** WHERE Barcode bị trùng lặp, THE system SHALL từ chối thêm mới VÀ báo lỗi "Mã vạch đã tồn tại trên hệ thống thuộc tựa sách [Tên sách]".
- **FR-F4-07:** WHILE thực thi thành công việc nhập kho Bản sao mới (status='available', condition='good'), THE system SHALL tự động UPDATE tăng `totalQuantity` + 1 VÀ `availableQuantity` + 1 cho bảng `Book` tương ứng trong cùng 1 Database Transaction.
- **FR-F4-08:** WHEN Librarian cập nhật trường `condition` của `BookCopy`, WHERE trạng thái chuyển từ 'good' sang 'damaged' hoặc 'lost', THE system SHALL tự động UPDATE giảm `availableQuantity` của `Book` đi 1 đơn vị, VÀ chuyển `BookCopy.status` sang 'unavailable'.
- **FR-F4-09:** WHEN Librarian cập nhật thông tin Bản sao, THE system SHALL chặn mọi hành vi sửa đổi đối với `barcode` (BR-18).

## 4. Non-functional Requirements
- **Data Consistency:** Quá trình đồng bộ số lượng tồn kho (Insert `BookCopy` và Update `Book`) BẮT BUỘC nằm trong cùng một Database Transaction. Nếu một vế thất bại, hệ thống SHALL Rollback toàn bộ.
- **Performance:** Truy vấn danh mục sách (có filter) phải phản hồi dưới 500ms (P95).

## 5. Data Model
- **Book:** `bookId`, `isbn` (UNIQUE), `title`, `author`, `totalQuantity`, `availableQuantity`, `status`.
- **BookCopy:** `bookCopyId`, `bookId`, `barcode` (UNIQUE), `condition` (good, damaged, lost), `status` (available, unavailable, borrowed, reserved).

## 6. Error Handling
- WHERE dữ liệu vi phạm ràng buộc định danh (trùng ISBN/Barcode), THE system SHALL từ chối giao dịch và hiển thị flash message báo lỗi tương ứng.
- WHERE Database Transaction gặp SQLException trong lúc đồng bộ kho, THE system SHALL gọi `connection.rollback()`, ghi log lỗi và trả về HTTP 500 với thông báo "Lỗi hệ thống trong quá trình đồng bộ dữ liệu".

## 7. Acceptance Criteria
- [ ] Khởi tạo Đầu sách mới với ISBN chưa tồn tại: Thành công, số lượng khởi tạo bằng 0.
- [ ] Khởi tạo Đầu sách mới với ISBN đã tồn tại: Báo lỗi và chặn lưu.
- [ ] Nhập kho Bản sao mới: Thành công, cột `totalQuantity` và `availableQuantity` của sách tự động tăng thêm 1.
- [ ] Sửa `condition` của Bản sao từ 'good' sang 'lost': Cột `availableQuantity` tự động giảm đi 1, cột `status` thành 'unavailable'.
- [ ] Cố tình sửa đổi ISBN của Book hoặc Barcode của BookCopy sau khi đã lưu: Báo lỗi và chặn giao dịch.

## 8. Out of Scope
- Hệ thống KHÔNG cho phép Hard Delete (xóa cứng) dữ liệu `Book` và `BookCopy`.
- Hệ thống KHÔNG xử lý các nghiệp vụ Check-out, Check-in hay tính tiền phạt tại Feature này.
