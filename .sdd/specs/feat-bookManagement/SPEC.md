# Feature Specification: Quản lý sách & bản sao (Book & Copy Management)
# Version: 1.2 | Chủ sở hữu: @chuong | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Tính năng cho phép Thủ thư (Librarian) và Quản lý (Manager) thêm mới, chỉnh sửa thông tin sách, phân loại danh mục/thẻ tag, quản lý danh sách bản sao (BookCopy) kèm mã vạch (barcode), cập nhật tình trạng sách, tải lên ảnh bìa và nhập dữ liệu sách hàng loạt từ file Excel.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian) / Quản lý (Library Manager):** Khai báo sách mới, sửa thông tin sách, thêm/sửa bản sao sách, gán mã vạch, cập nhật tình trạng sách, quản lý danh mục và tag.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-12 (Manage Books):** Actor: Librarian/Manager | Thêm mới, cập nhật thông tin sách (Tiêu đề, Tác giả, NXB, Năm XB, Giá tiền, ISBN, Ảnh bìa).
* **UC-13 (Manage Book Copies):** Actor: Librarian | Khai báo bản sao sách (`BookCopy`), quản lý Mã vạch (Barcode), Vị trí kệ (Location), và Tình trạng (Condition).
* **UC-14 (Manage Categories & Tags):** Actor: Librarian/Manager | Quản lý danh mục thể loại (`Category`) và thẻ phân loại (`Tag`).
* **UC-15 (Batch Import Books):** Actor: Librarian/Manager | Nhập danh mục sách và bản sao hàng loạt từ file Excel (`.xlsx`).

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-13 (ISBN & Barcode Uniqueness):** Mã ISBN của sách và Mã vạch (Barcode) của từng bản sao BẮT BUỘC là duy nhất trong CSDL.
* **BR-14 (Quantity Consistency):** Tổng số lượng bản sao (`totalQuantity`) và số lượng sẵn có (`availableQuantity`) của một đầu sách phải tự động cập nhật đồng bộ khi thêm/xóa/sửa trạng thái của các bản sao `BookCopy`.
* **BR-16 (Soft Delete Books):** Không thực hiện xóa cứng (`DELETE`) sách hoặc bản sao đã phát sinh giao dịch mượn/trả. Chuyển trạng thái `status` thành `'inactive'` hoặc `'lost'`.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-18 (Thêm/Sửa đầu sách):** WHEN Thủ thư gửi thông tin sách tại `BookServlet`, THE system SHALL validate dữ liệu (ISBN duy nhất, năm XB hợp lệ). WHERE thông tin hợp lệ, hệ thống lưu sách vào bảng `Book`, xử lý upload ảnh bìa qua `BookImageServlet` và lưu đường dẫn `imagePath`. Ghi `AuditLogs` với action `CREATE_BOOK` hoặc `UPDATE_BOOK`.
  * *Mapping:* UC-12 / BR-13
* **FR-19 (Quản lý bản sao & Mã vạch):** WHEN Thủ thư thêm bản sao tại `BookCopyServlet`, THE system SHALL sinh mã vạch (Barcode) duy nhất nếu chưa nhập, gán vị trí kệ (`location`), tình trạng ban đầu (`condition`) và thiết lập `status='available'`. THEN hệ thống tự động tăng `totalQuantity` và `availableQuantity` của `Book` tương ứng thêm 1.
  * *Mapping:* UC-13 / BR-13, BR-14
* **FR-20 (Quản lý Danh mục & Tag):** WHEN Manager thêm/sửa Danh mục hoặc Tag tại `CategoryServlet` / `TagServlet`, THE system SHALL lưu vào CSDL và cập nhật bảng liên kết `BookCategory` / `BookTag`.
  * *Mapping:* UC-14
* **FR-21 (Import sách từ Excel):** WHEN Thủ thư tải file Excel sách tại `BookImportServlet`, THE system SHALL đọc dữ liệu qua `BookImportWorkbookReader`, kiểm tra trùng lặp ISBN/Barcode, chèn các đầu sách và bản sao hợp lệ, lưu lịch sử import vào `BookImportBatch` và `BookImportError`.
  * *Mapping:* UC-15 / BR-13, BR-14

## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Chỉ role LIBRARIAN và MANAGER mới có quyền thực thi C/U/D sách. Kiểm tra định dạng ảnh (JPEG/PNG, dung lượng < 5MB).
* **Hiệu năng:** Tải trang danh sách sách < 300ms với hỗ trợ phân trang và tìm kiếm Ajax.
* **Giao diện:** Đồ họa trực quan, hiển thị mã vạch và trạng thái sẵn có của từng bản sao.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `Book`
* `bookId` (INT, PK), `isbn` (VARCHAR, UNIQUE), `title`, `author`, `publisher`, `publicationYear`, `price`, `imagePath`, `totalQuantity`, `availableQuantity`, `status`

### Bảng `BookCopy`
* `bookCopyId` (INT, PK), `bookId` (FK), `location`, `condition`, `status` (available / reserved / borrowed / maintenance / lost), `barcode` (VARCHAR, UNIQUE)

### Bảng `Category`, `Tag`, `BookCategory`, `BookTag`

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** ISBN bị trùng lặp, **THE system SHALL** trả về lỗi "Mã ISBN này đã tồn tại trên hệ thống".
* **WHERE** file ảnh upload không đúng định dạng, **THE system SHALL** thông báo lỗi "Chỉ chấp nhận file ảnh định dạng JPG/PNG".

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-BOOK-01] Tạo mới đầu sách thành công kèm ảnh bìa và hiển thị trên danh sách.
- [ ] [TC-BOOK-02] Thêm 5 bản sao BookCopy tự động tăng availableQuantity của sách lên 5.
- [ ] [TC-BOOK-03] Trùng mã vạch Barcode báo lỗi lập tức và không cho lưu.
- [ ] [TC-BOOK-04] Import thành công file Excel chứa sách và bản sao mới.
- [ ] [TC-BOOK-05] Mọi thao tác thêm/sửa sách được ghi vết trong AuditLogs.

## 8. Out of Scope (Phạm vi không thực hiện)
* Tự động in nhãn Barcode ra máy in nhiệt trực tiếp từ trình duyệt.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện lưu trữ ảnh bìa tại thư mục app storage và tích hợp POI import.
