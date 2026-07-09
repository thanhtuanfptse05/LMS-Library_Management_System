# Feature Specification: Quản lý sách và danh mục (Book Management)
# Version: 1.1 | Chủ sở hữu: Chuong | Ngày cập nhật: 2026-07-09

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp công cụ cho Thủ thư quản lý đầu sách, bản sao vật lý, thể loại, tag và import sách hàng loạt; bảo đảm ISBN/Barcode duy nhất, số lượng tồn kho đồng bộ, thao tác có Audit Log và giao diện hoàn toàn bằng tiếng Việt.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Tác nhân duy nhất được truy cập và thay đổi dữ liệu F4.
* **Vai trò khác:** `ADMIN`, `MANAGER`, `STUDENT`, `LECTURER` và vai trò khác nhận HTTP 403 khi truy cập `/book-management/*`.
* **Người chưa đăng nhập:** Được chuyển tới trang đăng nhập.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-12 (View Book Catalog & Inventory):** Actor: Librarian | Xem tổng quan, tìm kiếm, lọc, sắp xếp và phân trang đầu sách/bản sao cùng số lượng tồn kho.
* **UC-13 (Manage Book Catalog):** Actor: Librarian | Tạo đầu sách và cập nhật metadata, ảnh bìa, thể loại, tag hoặc trạng thái; không sửa ISBN và số lượng trực tiếp.
* **UC-14 (Manage Physical Copies):** Actor: Librarian | Nhập bản sao bằng Barcode và cập nhật vị trí của bản sao đang khả dụng; thay đổi condition được chuyển sang F13.
* **UC-15 (Manage Tags & Categories):** Actor: Librarian | Tạo, cập nhật trạng thái thể loại/tag và gộp tag mà không hard-delete.
* **UC-27 (Import Bulk Books):** Actor: Librarian | Tải file `.xlsx`, xem preview và xác nhận import Book/BookCopy theo all-or-nothing.
* **UC-52 (View Book Import History):** Actor: Librarian | Tìm kiếm, lọc và xem lỗi chi tiết của từng phiên import.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-16 (Uniqueness of Identifiers):** ISBN của `Book` và Barcode của `BookCopy` BẮT BUỘC duy nhất toàn hệ thống. ISBN được chuẩn hóa trước khi so sánh/lưu.
* **BR-17 (Inventory Synchronization):** `totalQuantity` và `availableQuantity` BẮT BUỘC đồng bộ với BookCopy. Tạo BookCopy `good/available` cộng 1 vào cả hai; các thay đổi khả dụng khác do F13/F6 cập nhật trong transaction tương ứng.
* **BR-18 (Immutable Core Identifiers):** ISBN và Barcode KHÔNG ĐƯỢC thay đổi sau khi bản ghi được tạo thành công.
* **BR-27 (Book Import Transaction):** Import sách BẮT BUỘC all-or-nothing. Có bất kỳ lỗi validation hoặc lỗi ghi dữ liệu nào thì không Book/BookCopy nào của phiên được commit.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-22 (Tạo Đầu sách với validation ISBN):** WHEN `BookServlet.doPost(action=create)` nhận form, THE system SHALL: (1) chuẩn hóa và kiểm tra ISBN-10/ISBN-13 đúng checksum, (2) kiểm tra ISBN chưa tồn tại, (3) validate title, author, publisher, publicationYear, price và status theo schema, (4) mở transaction, INSERT `Book` với `totalQuantity=0`, `availableQuantity=0`, (5) thay thế liên kết `BookCategory` và `BookTag`, (6) INSERT `AuditLogs(CREATE_BOOK)`, (7) commit; WHERE lỗi thì rollback và dọn ảnh bìa mới đã lưu.
  * *Mapping:* UC-13 / BR-16, BR-17
* **FR-23 (Validation trùng lặp ISBN):** WHEN tạo Book, THE system SHALL từ chối ISBN đã tồn tại và hiển thị lỗi tiếng Việt. WHEN cập nhật Book, THE system SHALL lấy ISBN hiện tại từ Database và không chấp nhận ISBN từ request làm giá trị cập nhật.
  * *Mapping:* UC-13 / BR-16, BR-18
* **FR-24 (Nhập Kho Bản sao với đồng bộ số lượng):** WHEN `BookCopyServlet.doPost(action=create)` nhận `bookId`, `barcode`, `location`, THE system SHALL: (1) kiểm tra Book tồn tại, Barcode không trùng và location hợp lệ, (2) mở transaction, (3) INSERT BookCopy với `condition='good'`, `status='available'`, (4) tăng `Book.totalQuantity` và `Book.availableQuantity` mỗi giá trị 1, (5) INSERT `AuditLogs(CREATE_BOOK_COPY)`, (6) commit; WHERE lỗi thì rollback.
  * *Mapping:* UC-14 / BR-16, BR-17
* **FR-25 (DEPRECATED - Logic merged into FR-24):** Logic đồng bộ số lượng khi thêm bản sao đã được tích hợp vào FR-24; không triển khai luồng độc lập.
  * *Mapping:* UC-14 / BR-17
* **FR-26 (Validation trùng lặp Barcode):** WHEN tạo BookCopy, THE system SHALL từ chối Barcode đã tồn tại và thông báo đầu sách sở hữu Barcode đó. WHEN cập nhật BookCopy, Barcode hiện tại phải được lấy từ Database và không được nhận từ request.
  * *Mapping:* UC-14 / BR-16, BR-18
* **FR-27 (Chặn sửa đổi Định danh bất biến):** WHEN cập nhật Book hoặc BookCopy, THE system SHALL chỉ cập nhật trường cho phép: metadata/trạng thái/ảnh/phân loại của Book và location của BookCopy đang `available`; ISBN, Barcode, bookId, condition, status và số lượng của BookCopy phải giữ theo bản ghi hiện tại. WHERE BookCopy đang `borrowed`, `reserved` hoặc `unavailable`, THE system SHALL từ chối cập nhật location.
  * *Mapping:* UC-13, UC-14 / BR-18
* **FR-28 (Điều phối thay đổi condition):** WHEN Thủ thư cần ghi nhận BookCopy hỏng/mất, F4 SHALL không cập nhật condition trực tiếp tại `BookCopyServlet`; hệ thống SHALL điều hướng sang quy trình sự cố của F13 `feat-bookMaintenance`, nơi việc ngừng lưu thông, đồng bộ `availableQuantity` và Audit Log được xử lý nguyên tử.
  * *Mapping:* UC-14 / BR-17
* **FR-46 (Kiểm định tệp Excel Sách với 2 Phase):** WHEN `BookImportServlet.doPost(action=upload)` nhận file, THE system SHALL: (1) chỉ nhận `.xlsx`, tối đa 10 MB, tên tối đa 255 ký tự, (2) yêu cầu sheet `Books` có cột `isbn,title,author,publisher,publicationYear,price,categories,tags` và sheet `BookCopies` có `isbn,barcode,location`, (3) bỏ dòng trống, giới hạn 5.000 BookCopy, (4) kiểm tra trường bắt buộc, kiểu dữ liệu, ISBN, tham chiếu ISBN, độ dài, duplicate nội bộ và duplicate Barcode trong DB, (5) lưu preview trong session nếu toàn bộ hợp lệ; WHERE có lỗi thì lưu `BookImportBatch(status='failed')` và `BookImportError` theo sheet/dòng/cột, không tạo dữ liệu sách.
  * *Mapping:* UC-27 / BR-16, BR-27
* **FR-47 (Lưu trữ hàng loạt Sách với đồng bộ số lượng):** WHEN `BookImportServlet.doPost(action=confirm)` nhận preview hợp lệ, THE system SHALL: (1) validate lại preview, (2) mở một transaction, (3) dùng Book hiện hữu theo ISBN hoặc tạo Book mới mà không ghi đè metadata hiện hữu, (4) tự tạo Category/Tag chưa tồn tại và liên kết với Book mới, (5) INSERT mọi BookCopy với Barcode bắt buộc từ file, `good/available`, (6) tăng số lượng Book theo số BookCopy được tạo, (7) INSERT batch `success` và Audit Log tổng hợp, (8) commit; WHERE bất kỳ bước nào lỗi thì rollback toàn bộ dữ liệu nghiệp vụ và lưu batch `failed` bằng transaction riêng.
  * *Mapping:* UC-27 / BR-16, BR-17, BR-27
* **FR-81 (Xem lịch sử nhập sách hàng loạt):** WHEN `BookImportHistoryServlet.doGet()` được gọi, THE system SHALL tìm theo từ khóa, lọc `success/failed`, phân trang 20 bản ghi; WHERE có `batchId`, hệ thống SHALL hiển thị lỗi chi tiết từ `BookImportError` và forward tới `book-import-history.jsp`.
  * *Mapping:* UC-52 / BR-27

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** `AuthFilter` bảo vệ toàn bộ `/book-management/*`; chỉ `LIBRARIAN` được truy cập, mọi SQL đầu vào dùng `PreparedStatement`.
* **Toàn vẹn:** Mọi C/U quan trọng và Audit Log dùng cùng transaction/Connection; lỗi phải rollback.
* **Hiệu năng:** Danh sách có filter đạt P95 dưới 500 ms; validate file gần 5.000 BookCopy trong tối đa 30 giây ở môi trường Milestone 2.
* **Giao diện:** JSP dùng JSTL/EL, không scriptlet; toàn bộ nhãn và thông báo bằng tiếng Việt.
* **Lưu trữ:** Lịch sử import/lỗi có `expiresAt` sau 1 năm theo schema.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
Nguồn chuẩn: `database/supabase/LMS_Schema_PostgreSQL.sql`.

### Bảng Book
* `bookId` (INT, PK), `isbn` (VARCHAR(20), UNIQUE), `title` (VARCHAR(500))
* `author` (VARCHAR(500)), `publisher` (VARCHAR(255)), `publicationYear` (INT)
* `price` (DECIMAL(18,2)), `imagePath` (VARCHAR(255))
* `totalQuantity`, `availableQuantity` (INT, không âm; available ≤ total)
* `status` (`available`, `unavailable`), `createdAt`, `updatedAt`

### Bảng BookCopy
* `bookCopyId` (INT, PK), `bookId` (INT, FK), `barcode` (VARCHAR(50), UNIQUE)
* `location` (VARCHAR(255)), `condition` (`good`, `damaged`, `lost`)
* `status` (`available`, `unavailable`, `borrowed`, `reserved`), `createdAt`, `updatedAt`

### Bảng Category, Tag và bảng liên kết
* `Category(categoryId, name, description, status, updatedAt, updatedBy)`
* `Tag(tagId, name UNIQUE, status, updatedAt, updatedBy)`
* `BookCategory(bookId, categoryId)`, `BookTag(bookId, tagId)`

### Bảng BookImportBatch và BookImportError
* `BookImportBatch(importBatchId, importedBy, fileName, totalRows, successRows, failedRows, status, createdAt, expiresAt)`
* `BookImportError(importErrorId, importBatchId, sheetName, rowNumber, columnName, errorMessage, createdAt)`
* Batch status chỉ gồm `success`, `failed`; sheet lỗi chỉ gồm `Books`, `BookCopies`.

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE ISBN/Barcode trùng, entity không tồn tại, action/ID sai hoặc BookCopy không ở trạng thái cho phép, THE system SHALL từ chối lưu và hiển thị lỗi tiếng Việt.
* WHERE import có lỗi, THE system SHALL hiển thị lỗi theo sheet/dòng/cột và không commit Book/BookCopy.
* WHERE lỗi Database/File bất ngờ, THE system SHALL rollback, log chi tiết ở server và chỉ hiển thị thông báo thân thiện; không lộ stack trace.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Tạo đầu sách với ISBN hợp lệ lưu đúng Book, Category/Tag và Audit Log; ISBN trùng bị từ chối.
- [ ] Cập nhật đầu sách không thay đổi ISBN, `totalQuantity` hoặc `availableQuantity`.
- [ ] Thêm một BookCopy hợp lệ làm cả hai số lượng tăng đúng 1; Barcode trùng không làm thay đổi dữ liệu.
- [ ] Chỉ BookCopy `available` được cập nhật location; condition hỏng/mất đi qua F13.
- [ ] Category/Tag được tạo/cập nhật bằng soft state; gộp tag không hard-delete tag nguồn.
- [ ] File import lỗi tạo 0 Book/BookCopy và lưu được lỗi theo sheet/dòng/cột.
- [ ] File import hợp lệ tạo đủ dữ liệu hoặc rollback toàn bộ nếu một bước ghi thất bại.
- [ ] Lịch sử import tìm kiếm/lọc/phân trang và xem được chi tiết batch.
- [ ] Vai trò ngoài `LIBRARIAN` nhận HTTP 403; UI F4 không có nhãn/thông báo tiếng Anh.

## 9. Out of Scope (Phạm vi không thực hiện)
* Báo cáo/xử lý sự cố hỏng mất và kiểm kê kho (F13 `feat-bookMaintenance`).
* Mượn, trả, đặt trước, phạt và thanh toán (F5/F6/F9).
* Tìm kiếm sách công khai (F8) và đề xuất mua sách (F20).
* Hard-delete Book/BookCopy hoặc tự động sửa tồn kho không có transaction nghiệp vụ.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* F4 giữ nguyên mã UC/BR/FR trong `diagram/spec-UC-BR-FR.txt`; không tạo hệ mã song song.
* Spec mô tả hành vi chuẩn. Sai lệch giữa code/schema và spec phải được xử lý qua TASK, không hợp thức hóa bằng mô tả mâu thuẫn.
