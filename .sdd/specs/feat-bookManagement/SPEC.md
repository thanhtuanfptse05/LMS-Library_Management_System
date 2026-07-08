# Feature Specification: Quản lý sách và danh mục (Book Management)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp các công cụ cho Thủ thư (Librarian) để quản lý kho sách của thư viện, bao gồm quản lý đầu sách, bản sao vật lý (Barcode), danh mục, tag phân loại và import sách hàng loạt từ file Excel.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Có quyền quản lý đầu sách, bản sao, danh mục, tag và thực hiện import sách.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-12 (View Book Catalog & Inventory):** Actor: Librarian | (Xem Danh mục & Kho): Truy xuất danh sách đầu sách, chi tiết các bản sao vật lý, kèm danh mục và thẻ.
* **UC-13 (Manage Book Catalog):** Actor: Librarian | (Quản lý Đầu sách): Khởi tạo Đầu sách mới trực tuyến, hoặc cập nhật thông tin siêu dữ liệu (metadata) của Đầu sách hiện có.
* **UC-14 (Manage Physical Copies):** Actor: Librarian | (Quản lý Bản sao vật lý): Nhập kho Bản sao sách mới bằng cách quét mã vạch (Barcode), hoặc cập nhật tình trạng vật lý (Condition/Location) của Bản sao hiện có.
* **UC-15 (Manage Tags & Categories):** Actor: Librarian | (Quản lý Danh mục & Thẻ): Thêm, sửa, hoặc thay đổi trạng thái của các Danh mục (Category) và Thẻ phân loại (Tag) áp dụng cho sách.
* **UC-27 (Import Bulk Books):** Actor: Librarian | (Nhập sách hàng loạt): Thủ thư tải lên tệp Excel để thêm mới số lượng lớn Đầu sách.
* **UC-52 (View Book Import History):** Actor: Librarian | (Xem lịch sử nhập sách hàng loạt): Thủ thư xem danh sách các đợt nhập sách số lượng lớn từ Excel, tìm kiếm và kiểm tra lỗi của từng dòng dữ liệu.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-12 (View Book Catalog & Inventory):** Actor: Librarian | (Xem Danh mục & Kho): Truy xuất danh sách đầu sách, chi tiết các bản sao vật lý, kèm danh mục và thẻ.
* **UC-13 (Manage Book Catalog):** Actor: Librarian | (Quản lý Đầu sách): Khởi tạo Đầu sách mới trực tuyến, hoặc cập nhật thông tin siêu dữ liệu (metadata) của Đầu sách hiện có.
* **UC-14 (Manage Physical Copies):** Actor: Librarian | (Quản lý Bản sao vật lý): Nhập kho Bản sao sách mới bằng cách quét mã vạch (Barcode), hoặc cập nhật tình trạng vật lý (Condition/Location) của Bản sao hiện có.
* **UC-15 (Manage Tags & Categories):** Actor: Librarian | (Quản lý Danh mục & Thẻ): Thêm, sửa, hoặc thay đổi trạng thái của các Danh mục (Category) và Thẻ phân loại (Tag) áp dụng cho sách.
* **UC-27 (Import Bulk Books):** Actor: Librarian | (Nhập sách hàng loạt): Thủ thư tải lên tệp Excel để thêm mới số lượng lớn Đầu sách.
* **UC-52 (View Book Import History):** Actor: Librarian | (Xem lịch sử nhập sách hàng loạt): Thủ thư xem danh sách các đợt nhập sách số lượng lớn từ Excel, tìm kiếm và kiểm tra lỗi của từng dòng dữ liệu.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-12 (View Book Catalog & Inventory):** Actor: Librarian | (Xem Danh mục & Kho): Truy xuất danh sách đầu sách, chi tiết các bản sao vật lý, kèm danh mục và thẻ.
* **UC-13 (Manage Book Catalog):** Actor: Librarian | (Quản lý Đầu sách): Khởi tạo Đầu sách mới trực tuyến, hoặc cập nhật thông tin siêu dữ liệu (metadata) của Đầu sách hiện có.
* **UC-14 (Manage Physical Copies):** Actor: Librarian | (Quản lý Bản sao vật lý): Nhập kho Bản sao sách mới bằng cách quét mã vạch (Barcode), hoặc cập nhật tình trạng vật lý (Condition/Location) của Bản sao hiện có.
* **UC-15 (Manage Tags & Categories):** Actor: Librarian | (Quản lý Danh mục & Thẻ): Thêm, sửa, hoặc thay đổi trạng thái của các Danh mục (Category) và Thẻ phân loại (Tag) áp dụng cho sách.
* **UC-27 (Import Bulk Books):** Actor: Librarian | (Nhập sách hàng loạt): Thủ thư tải lên tệp Excel để thêm mới số lượng lớn Đầu sách.
* **UC-52 (View Book Import History):** Actor: Librarian | (Xem lịch sử nhập sách hàng loạt): Thủ thư xem danh sách các đợt nhập sách số lượng lớn từ Excel, tìm kiếm và kiểm tra lỗi của từng dòng dữ liệu.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-16 (Uniqueness of Identifiers):** Định danh sách gồm ISBN (Bảng Book) và Barcode (Bảng BookCopy) BẮT BUỘC phải là duy nhất trên toàn hệ thống.
* **BR-17 (Inventory Synchronization):** Số lượng totalQuantity và availableQuantity của bảng Book BẮT BUỘC đồng bộ với BookCopy. Khi thêm bản sao: cộng 1 vào cả hai. Khi cập nhật Condition sang hỏng/mất: trừ availableQuantity.
* **BR-18 (Immutable Core Identifiers):** KHÔNG ĐƯỢC PHÉP thay đổi thông tin định danh hệ thống (ISBN, Barcode) sau khi bản ghi sách hoặc bản sao đã được lưu thành công.
* **BR-27 (Book Import Transaction):** Tính năng Import khối lượng lớn Sách BẮT BUỘC tuân thủ chiến lược All-or-Nothing. Tệp dữ liệu chỉ được lưu vào DB khi toàn bộ thông tin Sách và Bản sao đều hợp lệ.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-22 (Tạo Đầu sách với validation ISBN):** WHEN BookServlet.doPost(action=create) nhận biểu mẫu tạo sách mới, THE system SHALL: (1) Validate ISBN: chuẩn hóa bằng cách bỏ khoảng trắng/dấu gạch ngang, chấp nhận ISBN-10 hoặc ISBN-13 đúng checksum, (2) Gọi BookDAO.findByIsbn(isbn), WHERE tồn tại: trả lỗi "ISBN đã tồn tại trong hệ thống", (3) WHERE hợp lệ: BookService.createBook(book, categoryIds[], tagIds[], actorId) thực thi INSERT Book(isbn, title, author, publisher, publicationYear, price, imagePath, totalQuantity=0, availableQuantity=0, status, description, pageCount, language, createdAt=NOW()), (4) INSERT BookCategory cho mỗi categoryId, (5) INSERT BookTag cho mỗi tagId, (6) Lưu ảnh bìa (nếu có) vào thư mục uploads/books/ với tên file = {bookId}_{timestamp}.{ext}, (7) INSERT AuditLog(CREATE_BOOK), (8) Redirect với flash success.
  * *Mapping:* UC-13 / BR-16
* **FR-23 (Validation trùng lặp ISBN):** WHEN BookServlet.doPost(action=create) hoặc action=update nhận ISBN từ biểu mẫu, THE system SHALL gọi BookDAO.findByIsbn(isbn) để kiểm tra tồn tại. WHERE ISBN đã tồn tại VÀ bookId khác với book đang sửa (action=update), THE system SHALL từ chối và trả về flash error message: "ISBN {isbn} đã tồn tại trong hệ thống, thuộc sách: {existingBook.title}". WHERE ISBN chưa tồn tại hoặc trùng với chính bản ghi đang sửa, CHO PHÉP tiếp tục.
  * *Mapping:* UC-13 / BR-16
* **FR-24 (Nhập Kho Bản sao với đồng bộ số lượng):** WHEN BookCopyServlet.doPost(action=create) nhận biểu mẫu thêm bản sao mới, THE system SHALL: (1) Validate barcode unique: BookCopyDAO.findByBarcode(barcode), WHERE tồn tại: trả lỗi "Mã vạch đã tồn tại, thuộc sách {bookTitle}", (2) WHERE hợp lệ: Mở DB Transaction, (3) INSERT BookCopy(bookId, barcode, location, condition='good', status='available', acquisitionDate=NOW()), (4) **Đồng bộ số lượng theo BR-17**: UPDATE Book SET totalQuantity = totalQuantity + 1, availableQuantity = availableQuantity + 1 WHERE bookId=?, (5) INSERT AuditLog(CREATE_BOOK_COPY, actorId), (6) conn.commit(), (7) WHERE SQLException: rollback + throw.
  * *Mapping:* UC-14 / BR-16, BR-17
* **FR-25 (DEPRECATED - Logic merged into FR-24):** Logic đồng bộ số lượng khi thêm bản sao đã được tích hợp vào FR-24. Không còn sử dụng FR riêng biệt.
  * *Mapping:* (merged into FR-24)
* **FR-26 (Validation trùng lặp Barcode):** WHEN BookCopyServlet.doPost(action=create) hoặc action=update nhận barcode từ biểu mẫu, THE system SHALL gọi BookCopyDAO.findByBarcode(barcode) để kiểm tra tồn tại. WHERE barcode đã tồn tại VÀ bookCopyId khác với bản sao đang sửa (action=update), THE system SHALL từ chối và trả về flash error message có cấu trúc: "Mã vạch {barcode} đã tồn tại trong hệ thống, thuộc sách: {existingCopy.book.title} (ID: {existingCopy.bookCopyId})". WHERE barcode chưa tồn tại hoặc trùng với chính bản ghi đang sửa, CHO PHÉP tiếp tục. Error message giúp Librarian nhanh chóng xác định vị trí barcode trùng để điều tra nguyên nhân (lỗi dán nhãn, lỗi scan, hoặc cố tình trùng).
  * *Mapping:* UC-14 / BR-16
* **FR-27 (Chặn sửa đổi Định danh bất biến):** WHEN BookServlet.doPost(action=update) hoặc BookCopyServlet.doPost(action=update) nhận request cập nhật, THE system SHALL kiểm tra các trường định danh bất biến (immutable identifiers): (1) **Đầu sách (Book)**: Load Book hiện tại từ DB theo bookId, so sánh request.isbn với book.isbn, WHERE khác nhau: CHẶN giao dịch và trả lỗi "Không được phép thay đổi ISBN sau khi đầu sách đã được tạo", (2) **Bản sao (BookCopy)**: Load BookCopy hiện tại từ DB theo bookCopyId, so sánh request.barcode với bookCopy.barcode, WHERE khác nhau: CHẶN giao dịch và trả lỗi "Không được phép thay đổi Barcode sau khi bản sao đã được tạo". Chỉ cho phép cập nhật các trường metadata khác (title, author, publisher cho Book; location, condition, status cho BookCopy). WHERE cố tình sửa ISBN/Barcode: ghi AuditLog(ATTEMPTED_IDENTIFIER_CHANGE, actorId, oldValue, attemptedValue) để theo dõi hành vi bất thường.
  * *Mapping:* UC-13, UC-14 / BR-18
* **FR-28 (Đồng bộ Hư hỏng/Mất mát với Trigger):** WHEN BookCopyServlet.doPost(action=update) cập nhật BookCopy VÀ phát hiện condition thay đổi từ 'good' sang 'damaged' hoặc 'lost', THE system SHALL: (1) Mở DB Transaction, (2) UPDATE BookCopy SET condition=?, status='unavailable', (3) **Trigger đồng bộ theo BR-17**: UPDATE Book SET availableQuantity = availableQuantity - 1 WHERE bookId=?, (4) INSERT BookCopyIncident(bookCopyId, type=condition, description='Phát hiện khi cập nhật bản sao', status='open', reportedBy=actorId), (5) INSERT AuditLog(UPDATE_BOOK_COPY), (6) conn.commit(). WHERE condition thay đổi từ 'damaged'/'lost' về 'good' (sau khi sửa chữa): UPDATE availableQuantity = availableQuantity + 1.
  * *Mapping:* UC-14 / BR-17, BR-28
* **FR-46 (Kiểm định tệp Excel Sách với 2 Phase):** WHEN BookImportServlet.doPost(action=upload) nhận file upload (.xlsx ≤10MB, tên ≤255 ký tự), THE system SHALL thực hiện 2 Phase: **Phase 1 (Validation — RAM only)**: Gọi BookImportWorkbookReader.read() để dùng Apache POI đọc file Excel, với mỗi row (skip header): validate ISBN (chuẩn hóa bằng cách bỏ khoảng trắng/dấu gạch ngang, chấp nhận ISBN-10 hoặc ISBN-13 đúng checksum) qua BookImportValidator, validate Barcode unique (không trùng trong DB), validate các field bắt buộc (title, authorName, categoryId, quantity > 0). WHERE phát hiện lỗi bất kỳ: thêm vào List<String> errors với format "Row {rowIndex}: {field} - {lỗi chi tiết}" và DỪNG import. WHERE validation pass: lưu BookImportPreview vào HttpSession để user xem lại, THEN redirect về book-import.jsp. **Phase 2 (Transaction Insert)**: WHEN user click confirm, doPost(action=confirm) gọi BookImportService.commit(preview, actorId) mở DB Transaction để INSERT từng Book record, AUTO sinh barcode nếu không cung cấp, INSERT BookCopy tương ứng với totalQuantity = availableQuantity = số bản sao, INSERT BookImportBatch để lưu lịch sử import, INSERT AuditLog(BOOK_IMPORT, actorId), THEN conn.commit(). WHERE SQLException: rollback và forward error page.
  * *Mapping:* UC-27 / BR-27
* **FR-47 (Lưu trữ hàng loạt Sách với đồng bộ số lượng):** WHEN BookImportServlet.doPost(action=confirm) thực thi Phase 2 sau khi user xác nhận preview hợp lệ, THE system SHALL: (1) Lấy BookImportPreview từ HttpSession, (2) Mở DB Transaction (conn.setAutoCommit(false)), (3) INSERT BookImportBatch(importedBy=librarianId, fileName, totalRows, successRows=0, failedRows=0, status='processing', importedAt=NOW()) → lấy importBatchId, (4) Với mỗi BookImportDTO trong preview: (a) INSERT Book(isbn, title, authorName, publisherName, publicationYear, price, categoryId, totalQuantity=dto.quantity, availableQuantity=dto.quantity, status='available', createdAt=NOW()), (b) Lấy bookId vừa insert, (c) Loop từ 1 đến dto.quantity: AUTO-GENERATE barcode (nếu không cung cấp) theo format "LMS{bookId}{sequenceNumber}" hoặc dùng barcode từ Excel nếu có, INSERT BookCopy(bookId, barcode, location=dto.defaultLocation hoặc 'Kệ chính', condition='good', status='available', acquisitionDate=NOW()), (d) WHERE SQLException xảy ra cho bất kỳ row nào: INSERT BookImportError(importBatchId, sheetName, rowNumber, columnName='N/A', errorMessage=exception.getMessage()), failedRows++, CONTINUE (skip row lỗi), (e) WHERE thành công: successRows++, (5) UPDATE BookImportBatch SET successRows=?, failedRows=?, status='completed' WHERE importBatchId=?, (6) INSERT AuditLog(BOOK_IMPORT, librarianId, entityName='BookImportBatch', entityId=importBatchId, newValues=JSON.stringify({fileName, totalRows, successRows, failedRows})), (7) conn.commit(), (8) WHERE SQLException ở cấp transaction: conn.rollback() + forward error page, (9) Redirect sang /book-management/import-history?batchId={importBatchId} với flash success "Đã nhập thành công {successRows}/{totalRows} sách".
  * *Mapping:* UC-27 / BR-17, BR-27
* **FR-81 (Xem lịch sử nhập sách hàng loạt):** WHEN BookImportHistoryServlet.doGet() được gọi, THE system SHALL: (1) Đọc từ khóa tìm kiếm (q), trạng thái lọc (status), trang hiện tại (page, pageSize=20), (2) Gọi BookImportDAO.search() để lấy danh sách BookImportBatch kèm phân trang, (3) WHERE có param batchId, THE system SHALL truy vấn chi tiết lỗi từng dòng trong BookImportError để hiển thị cho Librarian, (4) Forward sang book-import-history.jsp.
  * *Mapping:* UC-52

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Bảo mật: Ngăn chặn thay đổi ISBN và Barcode sau khi tạo.
* Ràng buộc: Barcode và ISBN là unique toàn hệ thống.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng Book
* `bookId` (INT, PK)
* `isbn` (VARCHAR(20), UNIQUE)
* `title` (VARCHAR(500))
* `author` (VARCHAR(500))
* `publisher` (VARCHAR(255))
* `publicationYear` (INT)
* `price` (DECIMAL)
* `totalQuantity` (INT)
* `availableQuantity` (INT)
* `status` (VARCHAR(50))

### Bảng BookCopy
* `bookCopyId` (INT, PK)
* `bookId` (INT, FK)
* `location` (VARCHAR(255))
* `condition` (VARCHAR(100))
* `status` (VARCHAR(50))
* `barcode` (VARCHAR(50), UNIQUE)

### Bảng Category
* `categoryId` (INT, PK)
* `name` (VARCHAR(255))
* `status` (VARCHAR(50))

### Bảng Tag
* `tagId` (INT, PK)
* `name` (VARCHAR(100))
* `status` (VARCHAR(50))



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE ISBN hoặc Barcode bị trùng lặp, THE system SHALL thông báo lỗi trùng lặp và từ chối lưu bản ghi.
* WHERE Phase 1 import Excel có dòng lỗi, THE system SHALL xuất lỗi chi tiết dòng đó và rollback toàn bộ.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Thêm đầu sách thành công: Điền đầy đủ thông tin hợp lệ -> Sách hiển thị trong danh sách.
- [ ] Thêm bản sao: Thêm 1 bản sao mới -> totalQuantity và availableQuantity đầu sách tăng thêm 1.
- [ ] Import sách lỗi: File Excel chứa barcode đã tồn tại -> Báo lỗi dòng chứa barcode trùng, không có sách nào được import.

## 9. Out of Scope (Phạm vi không thực hiện)
* Xóa vật lý (HARD DELETE) các đầu sách hoặc bản sao đã phát sinh giao dịch mượn trả.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
