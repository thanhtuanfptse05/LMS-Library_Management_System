# Feature Specification: Quản lý sách và danh mục (Book Management)
# Version: 1.3 | Chủ sở hữu: Chuong | Ngày cập nhật: 2026-07-26 (Chuẩn hóa UC-BR-FR registry)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp công cụ cho Thủ thư quản lý đầu sách, bản sao vật lý, thể loại, tag, import sách hàng loạt, lịch sử import, lịch sử lưu thông của bản sao và export danh sách quản lý sách. F4 bảo đảm ISBN/Barcode duy nhất, ISBN/Barcode bất biến sau khi tạo, số lượng tồn kho đồng bộ theo `BookCopy`, thao tác quan trọng có Audit Log và giao diện hoàn toàn bằng tiếng Việt.

Spec này căn theo `diagram/business-rules-specification.md`, `diagram/detailed-UC-specifications.md`, schema PostgreSQL và implementation hiện có. Không dùng `diagram/spec-UC-BR-FR.txt` làm nguồn mapping chuẩn vì file đó đang có mã UC/BR/FR trùng hoặc lệch sang feature khác.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Tác nhân duy nhất được truy cập và thay đổi dữ liệu trong F4.
* **Vai trò khác:** `ADMIN`, `ADMIN`, `STUDENT`, `LECTURER` và vai trò khác nhận HTTP 403 khi truy cập `/librarian/book-management/*` hoặc legacy `/book-management/*`.
* **Người chưa đăng nhập:** Được chuyển tới trang đăng nhập.

## 2.5 Use Cases (Danh sách Use Cases đúng theo registry)
* **UC-12 (View Book Catalog & Inventory):** Actor: Librarian | (Xem Danh mục & Kho): Truy xuất danh sách đầu sách, chi tiết các bản sao vật lý, kèm danh mục và thẻ.
* **UC-13 (Manage Book Catalog):** Actor: Librarian | (Quản lý Đầu sách): Khởi tạo Đầu sách mới trực tuyến, hoặc cập nhật thông tin siêu dữ liệu (metadata) của Đầu sách hiện có.
* **UC-14 (Manage Physical Copies):** Actor: Librarian | (Quản lý Bản sao vật lý): Khai báo bản sao bằng Barcode, cập nhật vị trí của bản sao đang khả dụng và xem thông tin/lịch sử liên quan tới bản sao. F4 không sửa condition trực tiếp; hỏng/mất chuyển sang F13 hoặc F6 tùy nghiệp vụ.
* **UC-15 (Manage Tags & Categories):** Actor: Librarian | (Quản lý Danh mục & Thẻ): Thêm, sửa, hoặc thay đổi trạng thái của các Danh mục (Category) và Thẻ phân loại (Tag) áp dụng cho sách.
* **UC-27 (Import Bulk Books):** Actor: Librarian | (Nhập sách hàng loạt): Thủ thư tải file .xlsx, xem preview và xác nhận import Book/BookCopy theo nguyên tắc all-or-nothing.
* **UC-52 (View Book Import History):** Actor: Librarian | (Xem lịch sử nhập sách hàng loạt): Thủ thư xem danh sách các đợt nhập sách số lượng lớn từ Excel, tìm kiếm và kiểm tra lỗi của từng dòng dữ liệu.

### Mapping Boundary
* Canonical source: diagram/spec-UC-BR-FR.md cho F4 Book Management. Các UC ngoài danh sách trên thuộc feature khác và không được map vào feature này.


## 3. Business Rules (Quy tắc nghiệp vụ đúng theo registry)
* **BR-16 (Uniqueness of Identifiers):** Định danh sách gồm ISBN (Bảng Book) và Barcode (Bảng BookCopy) BẮT BUỘC phải là duy nhất trên toàn hệ thống.
* **BR-17 (Inventory Synchronization):** Số lượng totalQuantity và availableQuantity của bảng Book BẮT BUỘC đồng bộ với BookCopy. Tạo BookCopy good/available cộng 1 vào cả hai; các thay đổi khả dụng khác do F13/F6 xử lý trong transaction tương ứng.
* **BR-18 (Immutable Core Identifiers):** KHÔNG ĐƯỢC PHÉP thay đổi thông tin định danh hệ thống (ISBN, Barcode) sau khi bản ghi sách hoặc bản sao đã được lưu thành công.
* **BR-27 (Book Import Transaction):** Tính năng Import khối lượng lớn Sách BẮT BUỘC tuân thủ chiến lược All-or-Nothing. Tệp dữ liệu chỉ được lưu vào DB khi toàn bộ thông tin Sách và Bản sao đều hợp lệ.


## 4. Functional Requirements (Yêu cầu chức năng chi tiết đúng theo registry)
* **FR-22 (Tạo đầu sách với validation ISBN):** WHEN BookServlet.doPost(action=create) nhận form, THE system SHALL chuẩn hóa và kiểm tra ISBN-10/ISBN-13 đúng checksum, kiểm tra ISBN chưa tồn tại, validate metadata/status theo schema, mở transaction, INSERT Book với totalQuantity=0 và availableQuantity=0, thay thế liên kết BookCategory/BookTag, ghi AuditLog(CREATE_BOOK), rồi commit; WHERE lỗi thì rollback và dọn ảnh bìa mới đã lưu.
  * *Mapping:* UC-13 / BR-16, BR-17
* **FR-23 (Cập nhật đầu sách và chặn đổi ISBN):** WHEN cập nhật Book, THE system SHALL lấy Book hiện tại từ Database, giữ nguyên ISBN và số lượng, chỉ cập nhật metadata/trạng thái/ảnh/phân loại được phép, ghi AuditLog(UPDATE_BOOK) trong cùng transaction. WHERE Book không tồn tại hoặc dữ liệu không hợp lệ, THE system SHALL từ chối lưu và hiển thị lỗi tiếng Việt.
  * *Mapping:* UC-13 / BR-18
* **FR-24 (Nhập kho bản sao với đồng bộ số lượng):** WHEN BookCopyServlet.doPost(action=create) nhận bookId, barcode và location, THE system SHALL kiểm tra Book tồn tại, barcode bắt buộc/đúng định dạng/không trùng, location hợp lệ, mở transaction, INSERT BookCopy với condition='good' và status='available', tăng Book.totalQuantity và Book.availableQuantity mỗi giá trị 1, ghi AuditLog(CREATE_BOOK_COPY), rồi commit; WHERE lỗi thì rollback.
  * *Mapping:* UC-14 / BR-16, BR-17
* **FR-25 (Cập nhật vị trí bản sao):** WHEN BookCopyServlet.doPost(action=update) nhận bookCopyId và location, THE system SHALL chỉ cho cập nhật location nếu BookCopy hiện tại đang status='available' và condition='good'; Barcode, bookId, condition và status phải giữ theo Database. WHERE bản sao đang borrowed/reserved/unavailable/damaged/lost, THE system SHALL từ chối cập nhật và hướng người dùng sang quy trình phù hợp.
  * *Mapping:* UC-14 / BR-18
* **FR-26 (Validation trùng lặp Barcode):** WHEN tạo BookCopy, THE system SHALL từ chối Barcode đã tồn tại và thông báo đầu sách sở hữu Barcode đó. WHERE unique constraint DB phát sinh do request đồng thời, THE system SHALL rollback và hiển thị lỗi tiếng Việt thân thiện thay vì lỗi hệ thống chung.
  * *Mapping:* UC-14 / BR-16
* **FR-27 (Quản lý thể loại và tag):** WHEN CategoryServlet hoặc TagServlet nhận create/update, THE system SHALL validate tên bắt buộc, kiểm tra trùng tên theo DAO, chỉ dùng trạng thái active hoặc hidden cho UI F4, ghi Audit Log tương ứng và không hard-delete Category/Tag.
  * *Mapping:* UC-15
* **FR-28 (Điều phối thay đổi condition sang F13/F6):** WHEN Thủ thư cần ghi nhận BookCopy hỏng/mất từ màn quản lý bản sao, F4 SHALL không cập nhật condition trực tiếp tại BookCopyServlet; hệ thống SHALL điều hướng sang F13 feat-bookMaintenance. WHERE hỏng/mất được phát hiện khi nhận trả sách tại quầy, F6 xử lý trong transaction check-in.
  * *Mapping:* UC-14 / BR-17
* **FR-46 (Kiểm định file Excel sách với 2 phase):** WHEN BookImportServlet.doPost(action=upload) nhận file, THE system SHALL chỉ nhận .xlsx tối đa 10 MB, yêu cầu sheet Books và BookCopies đúng header, bỏ dòng trống, giới hạn 5.000 BookCopy, kiểm tra trường bắt buộc, kiểu dữ liệu, ISBN, tham chiếu ISBN, độ dài, Barcode cùng rule validate với nhập tay, duplicate nội bộ và duplicate Barcode trong DB; WHERE có lỗi thì lưu BookImportBatch(status='failed') và BookImportError theo sheet/dòng/cột, không tạo dữ liệu sách.
  * *Mapping:* UC-27 / BR-16, BR-27
* **FR-47 (Lưu hàng loạt sách với đồng bộ số lượng):** WHEN BookImportServlet.doPost(action=confirm) nhận preview hợp lệ, THE system SHALL validate lại preview, mở một transaction, dùng Book hiện hữu theo ISBN hoặc tạo Book mới mà không ghi đè metadata hiện hữu, tự tạo Category/Tag chưa tồn tại và liên kết với Book mới, INSERT mọi BookCopy với Barcode bắt buộc từ file, condition='good', status='available', tăng số lượng Book theo số BookCopy được tạo, INSERT batch success và Audit Log tổng hợp, rồi commit; WHERE bất kỳ bước nào lỗi thì rollback toàn bộ dữ liệu nghiệp vụ và lưu batch failed bằng transaction riêng.
  * *Mapping:* UC-27 / BR-16, BR-17, BR-27
* **FR-81 (Xem lịch sử nhập sách hàng loạt):** WHEN BookImportHistoryServlet.doGet() được gọi, THE system SHALL tìm theo từ khóa, lọc success/failed, phân trang 20 bản ghi; WHERE có batchId, hệ thống SHALL hiển thị lỗi chi tiết từ BookImportError và forward tới book-import-history.jsp.
  * *Mapping:* UC-52 / BR-27
* **FR-133 (Xem lịch sử lưu thông bản sao):** WHEN BookCirculationHistoryServlet.doGet(bookCopyId) được gọi, THE system SHALL validate bookCopyId, kiểm tra BookCopy tồn tại, truy vấn lịch sử BorrowRecord liên quan theo thứ tự mới nhất, phân trang 15 bản ghi và hiển thị read-only thông tin người mượn, ngày mượn/trả và trạng thái lưu thông; WHERE bookCopyId sai hoặc không tồn tại, THE system SHALL redirect về danh sách bản sao với lỗi tiếng Việt.
  * *Mapping:* UC-14 / BR-18
* **FR-134 (Xuất CSV danh sách đầu sách/bản sao):** WHEN BookExportServlet hoặc BookCopyExportServlet được gọi, THE system SHALL xuất tối đa 10.000 dòng theo bộ lọc hiện tại, dùng UTF-8 BOM, escape đúng CSV và trung hòa CSV formula injection cho giá trị bắt đầu bằng =, +, -, @, tab hoặc xuống dòng; WHERE lỗi DB, THE system SHALL log server và hiển thị lỗi thân thiện.
  * *Mapping:* UC-12, UC-14 / BR-16


## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** `AuthFilter` bảo vệ toàn bộ `/librarian/book-management/*`; chỉ `LIBRARIAN` được truy cập, mọi SQL đầu vào dùng `PreparedStatement`. Route canonical của F4 là `/librarian/book-management/*`; route legacy `/book-management/*` chỉ dùng cho tương thích/redirect.
* **Toàn vẹn:** Mọi C/U quan trọng và Audit Log dùng cùng transaction/Connection; lỗi phải rollback.
* **Hiệu năng:** Danh sách có phân trang/filter/sort; export giới hạn 10.000 dòng; import giới hạn 5.000 BookCopy và 10 MB để phù hợp Milestone 2.
* **Giao diện:** JSP dùng JSTL/EL, không scriptlet Java; toàn bộ nhãn và thông báo bằng tiếng Việt.
* **Lưu trữ:** Lịch sử import/lỗi có `expiresAt` sau 1 năm theo schema.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
Nguồn chuẩn: `database/supabase/LMS_Schema_PostgreSQL.sql`.

### Bảng Book
* `bookId` (INT, PK), `isbn` (VARCHAR(20), UNIQUE), `title` (VARCHAR(500))
* `author` (VARCHAR(500)), `publisher` (VARCHAR(255)), `publicationYear` (INT)
* `price` (DECIMAL(18,2)), `imagePath` (VARCHAR(255))
* `totalQuantity`, `availableQuantity` (INT, không âm; available <= total)
* `status` (`available`, `unavailable`), `createdAt`, `updatedAt`

### Bảng BookCopy
* `bookCopyId` (INT, PK), `bookId` (INT, FK), `barcode` (VARCHAR(50), UNIQUE)
* `location` (VARCHAR(255)), `condition` (`good`, `damaged`, `lost`)
* `status` (`available`, `unavailable`, `borrowed`, `reserved`), `createdAt`, `updatedAt`
* `removedFromInventory` (BOOLEAN), `removedFromInventoryAt`, `removedFromInventoryBy` dùng bởi F13/F6 để loại bản sao khỏi tổng kho nhưng vẫn giữ lịch sử.

### Bảng Category, Tag và bảng liên kết
* `Category(categoryId, name, description, status, updatedAt, updatedBy)` với status schema `active`, `inactive`, `hidden`; UI F4 hiện dùng `active` và `hidden`.
* `Tag(tagId, name UNIQUE, status, updatedAt, updatedBy)` với status schema `active`, `inactive`, `hidden`; UI F4 hiện dùng `active` và `hidden`.
* `BookCategory(bookId, categoryId)`, `BookTag(bookId, tagId)`

### Bảng BookImportBatch và BookImportError
* `BookImportBatch(importBatchId, importedBy, fileName, totalRows, successRows, failedRows, status, createdAt, expiresAt)`
* `BookImportError(importErrorId, importBatchId, sheetName, rowNumber, columnName, errorMessage, createdAt)`
* Batch status chỉ gồm `success`, `failed`; sheet lỗi chỉ gồm `Books`, `BookCopies`.

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE ISBN/Barcode trùng, entity không tồn tại, action/ID sai hoặc BookCopy không ở trạng thái cho phép, THE system SHALL từ chối lưu và hiển thị lỗi tiếng Việt.
* WHERE Barcode từ form nhập tay hoặc file import chứa ký tự ngoài chữ, số hoặc `- _ . /`, THE system SHALL từ chối lưu và hiển thị lỗi tiếng Việt.
* WHERE import có lỗi, THE system SHALL hiển thị lỗi theo sheet/dòng/cột và không commit Book/BookCopy.
* WHERE lỗi Database/File bất ngờ, THE system SHALL rollback, log chi tiết ở server và chỉ hiển thị thông báo thân thiện; không lộ stack trace.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Tạo đầu sách với ISBN hợp lệ lưu đúng Book, Category/Tag và Audit Log; ISBN trùng bị từ chối.
- [ ] Cập nhật đầu sách không thay đổi ISBN, `totalQuantity` hoặc `availableQuantity`.
- [ ] Thêm một BookCopy hợp lệ làm cả hai số lượng tăng đúng 1; Barcode trùng không làm thay đổi dữ liệu.
- [ ] Barcode nhập tay và Barcode import có ký tự không được phép bị từ chối; lỗi trùng Barcode do unique constraint đồng thời hiển thị thông báo thân thiện.
- [ ] Chỉ BookCopy `available/good` được cập nhật location; condition hỏng/mất không được sửa trực tiếp trong F4, mà đi qua F13 hoặc F6 tùy điểm phát hiện nghiệp vụ.
- [ ] Category/Tag được tạo/cập nhật bằng soft state; không hard-delete.
- [ ] File import lỗi tạo 0 Book/BookCopy và lưu được lỗi theo sheet/dòng/cột.
- [ ] File import hợp lệ tạo đủ dữ liệu hoặc rollback toàn bộ nếu một bước ghi thất bại.
- [ ] Lịch sử import tìm kiếm/lọc/phân trang và xem được chi tiết batch.
- [ ] Lịch sử lưu thông của một bản sao hiển thị read-only và phân trang đúng.
- [ ] Export CSV đầu sách/bản sao theo bộ lọc hiện tại, có UTF-8 BOM và chống CSV formula injection.
- [ ] Vai trò ngoài `LIBRARIAN` nhận HTTP 403; UI F4 không có nhãn/thông báo tiếng Anh.

## 9. Out of Scope (Phạm vi không thực hiện)
* Báo cáo/xử lý sự cố hỏng mất và kiểm kê kho thuộc F13 `feat-bookMaintenance`.
* Mượn, trả, đặt trước, phạt và thanh toán thuộc F5/F6/F9.
* Tìm kiếm sách công khai và đề xuất mua sách thuộc feature khác, không map vào F4.
* Hard-delete Book/BookCopy hoặc tự động sửa tồn kho không có transaction nghiệp vụ; loại khỏi tổng kho chỉ được thực hiện bởi F13/F6 qua `removedFromInventory`.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Màn tổng quan F4 có thể hiển thị cảnh báo từ dữ liệu F13 để điều hướng thủ thư, nhưng nghiệp vụ xử lý incident/inventory vẫn thuộc F13.
* `FR-133` và `FR-134` là capability hỗ trợ trong F4 hiện có, không được map sang `UC-53` hoặc `UC-54` vì hai UC đó thuộc feature khác trong tài liệu tổng thể.
