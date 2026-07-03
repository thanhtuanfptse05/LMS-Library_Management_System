# Feature Specification: Quản lý sách và danh mục (Book Management)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp các công cụ cho Thủ thư (Librarian) để quản lý kho sách của thư viện, bao gồm quản lý đầu sách, bản sao vật lý (Barcode), danh mục, tag phân loại và import sách hàng loạt từ file Excel.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Thủ thư (Librarian):** Có quyền quản lý đầu sách, bản sao, danh mục, tag và thực hiện import sách.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-16 (Uniqueness of Identifiers):** Định danh sách gồm ISBN (Bảng Book) và Barcode (Bảng BookCopy) BẮT BUỘC phải là duy nhất trên toàn hệ thống.\n* **BR-17 (Inventory Synchronization):** Số lượng totalQuantity và availableQuantity của bảng Book BẮT BUỘC đồng bộ với BookCopy. Khi thêm bản sao: cộng 1 vào cả hai. Khi cập nhật Condition sang hỏng/mất: trừ availableQuantity.\n* **BR-18 (Immutable Core Identifiers):** KHÔNG ĐƯỢC PHÉP thay đổi thông tin định danh hệ thống (ISBN, Barcode) sau khi bản ghi sách hoặc bản sao đã được lưu thành công.\n* **BR-27 (Book Import Transaction):** Tính năng Import khối lượng lớn Sách BẮT BUỘC tuân thủ chiến lược All-or-Nothing. Tệp dữ liệu chỉ được lưu vào DB khi toàn bộ thông tin Sách và Bản sao đều hợp lệ.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-22 (Thêm đầu sách mới):** WHEN thủ thư tạo đầu sách mới với thông tin hợp lệ, THE system SHALL chèn bản ghi mới vào bảng Book và ghi Audit Log.\n* **FR-23 (Cập nhật thông tin đầu sách):** WHEN thủ thư cập nhật siêu dữ liệu đầu sách (ngoại trừ ISBN), THE system SHALL cập nhật bảng Book và ghi Audit Log.\n* **FR-24 (Ẩn đầu sách - Soft delete):** WHEN thủ thư yêu cầu ẩn sách, THE system SHALL cập nhật trạng thái Book thành 'unavailable' và ẩn sách khỏi trang tra cứu công khai.\n* **FR-25 (Quản lý bản sao vật lý):** WHEN thủ thư thêm bản sao, SHALL quét/nhập mã barcode duy nhất. Hệ thống SHALL cập nhật totalQuantity và availableQuantity của Book tương ứng.\n* **FR-26 (Cập nhật tình trạng bản sao):** WHEN thủ thư cập nhật tình trạng bản sao ('good', 'damaged', 'lost'), THE system SHALL đồng bộ số lượng availableQuantity thích hợp.\n* **FR-27 (Liên kết danh mục & tag):** WHEN thiết lập đầu sách, THE system SHALL cho phép gán danh mục và nhiều tag phân loại thông qua bảng trung gian BookCategory và BookTag.\n* **FR-28 (CRUD Danh mục & Tag):** SYSTEM SHALL hỗ trợ các chức năng quản lý danh mục và thẻ phân loại sách.\n* **FR-46 (Kiểm định tệp Excel Sách 2 Phase):** WHEN import file Excel, Phase 1 SHALL kiểm tra tính hợp lệ của tất cả các dòng dữ liệu (ISBN, Barcode, các trường bắt buộc). WHERE có lỗi, báo lỗi lập tức và dừng.\n* **FR-47 (Lưu trữ hàng loạt Sách đồng bộ):** WHEN import được confirm, THE system SHALL mở DB Transaction để thêm sách và các bản sao, tự động tạo barcode nếu trống, ghi BookImportBatch và Audit Log.\n* **FR-81 (Xem lịch sử nhập sách):** WHEN thủ thư truy cập lịch sử import, THE system SHALL hiển thị các đợt import và cho phép xem chi tiết lỗi của từng dòng bị lỗi.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Bảo mật: Ngăn chặn thay đổi ISBN và Barcode sau khi tạo.\n* Ràng buộc: Barcode và ISBN là unique toàn hệ thống.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng Book\n* `bookId` (INT, PK)\n* `isbn` (VARCHAR(20), UNIQUE)\n* `title` (VARCHAR(500))\n* `author` (VARCHAR(500))\n* `publisher` (VARCHAR(255))\n* `publicationYear` (INT)\n* `price` (DECIMAL)\n* `totalQuantity` (INT)\n* `availableQuantity` (INT)\n* `status` (VARCHAR(50))\n\n### Bảng BookCopy\n* `bookCopyId` (INT, PK)\n* `bookId` (INT, FK)\n* `location` (VARCHAR(255))\n* `condition` (VARCHAR(100))\n* `status` (VARCHAR(50))\n* `barcode` (VARCHAR(50), UNIQUE)\n\n### Bảng Category\n* `categoryId` (INT, PK)\n* `name` (VARCHAR(255))\n* `status` (VARCHAR(50))\n\n### Bảng Tag\n* `tagId` (INT, PK)\n* `name` (VARCHAR(100))\n* `status` (VARCHAR(50))\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE ISBN hoặc Barcode bị trùng lặp, THE system SHALL thông báo lỗi trùng lặp và từ chối lưu bản ghi.\n* WHERE Phase 1 import Excel có dòng lỗi, THE system SHALL xuất lỗi chi tiết dòng đó và rollback toàn bộ.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Thêm đầu sách thành công: Điền đầy đủ thông tin hợp lệ -> Sách hiển thị trong danh sách.\n- [ ] Thêm bản sao: Thêm 1 bản sao mới -> totalQuantity và availableQuantity đầu sách tăng thêm 1.\n- [ ] Import sách lỗi: File Excel chứa barcode đã tồn tại -> Báo lỗi dòng chứa barcode trùng, không có sách nào được import.

## 9. Out of Scope (Phạm vi không thực hiện)
* Xóa vật lý (HARD DELETE) các đầu sách hoặc bản sao đã phát sinh giao dịch mượn trả.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
