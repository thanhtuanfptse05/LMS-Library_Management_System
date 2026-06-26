# SPEC.md — Quản lý Sách và Kho vật lý
# Version: 1.0.0 | Owner: @tech-lead | Status: APPROVED
# Mapping: UC-12, UC-13, UC-14, UC-15, UC-27 | BR-16, BR-17, BR-18, BR-27 | FR-22..FR-28, FR-46, FR-47 (chi tiết: FR-F4-01..FR-F4-24)

## 1. Context & Goal
Quản lý toàn bộ vòng đời của tài nguyên sách. Đảm bảo tính duy nhất của mã vạch và sự đồng bộ tuyệt đối về số lượng tồn kho (Inventory) mỗi khi có sự thay đổi về bản sao vật lý.

## Clarifications
### Session 2026-06-08
- Q: F4 được phép cập nhật tình trạng của những BookCopy nào? → A: F4 chỉ được đổi `condition` khi BookCopy có `status='available'`; BookCopy đang `borrowed` hoặc `reserved` phải được xử lý qua F6.
- Q: Import hàng loạt sẽ nhập dữ liệu ở mức nào? → A: File import gồm danh sách `Book` và `BookCopy`; mỗi BookCopy phải có barcode cụ thể.
- Q: Khi file import có một hoặc nhiều dòng lỗi, hệ thống xử lý thế nào? → A: Không lưu dòng nào; hiển thị toàn bộ lỗi để Librarian sửa file rồi import lại.
- Q: Khi file import chứa ISBN đã tồn tại trong Database, hệ thống xử lý thế nào? → A: Giữ nguyên metadata của Book hiện hữu và chỉ thêm các BookCopy mới vào Book đó.
- Q: Ai được phép sử dụng F4 và chức năng import hàng loạt? → A: Chỉ người dùng có Role = `LIBRARIAN` được xem, tạo, cập nhật và import sách.
- Q: Admin hoặc Library Manager được làm gì trong F4? → A: Không được truy cập phân hệ BookManagement; mọi yêu cầu trực tiếp tới route F4 phải bị từ chối với HTTP 403.
- Q: File import hàng loạt sử dụng định dạng nào? → A: File Excel `.xlsx` gồm hai sheet `Books` và `BookCopies`.
- Q: Hệ thống xác định cảnh báo lệch kho như thế nào? → A: Cảnh báo khi `Book.totalQuantity` khác tổng số BookCopy hoặc `Book.availableQuantity` khác số BookCopy có `status='available'`.
- Q: Khi nào hệ thống kiểm tra và hiển thị cảnh báo lệch kho? → A: Kiểm tra trực tiếp mỗi khi Librarian mở hoặc làm mới báo cáo lệch kho.
- Q: Lịch sử import cần lưu mức độ chi tiết nào? → A: Lưu thông tin phiên import và danh sách lỗi theo sheet, dòng và cột.
- Q: Giới hạn tối đa cho một file import là bao nhiêu? → A: Tối đa 5.000 BookCopy mỗi file.
- Q: Librarian có được sửa trực tiếp số lượng tồn kho của Book không? → A: Không được sửa trực tiếp; `totalQuantity` và `availableQuantity` chỉ thay đổi thông qua nghiệp vụ BookCopy.
- Q: Khi Librarian phát hiện cảnh báo lệch kho, hệ thống hỗ trợ xử lý thế nào? → A: Chỉ hiển thị cảnh báo; Librarian điều tra và xử lý BookCopy liên quan, hệ thống không tự sửa số lượng.
- Q: Khi import, hệ thống xử lý Category và Tag chưa tồn tại thế nào? → A: Tự động tạo Category/Tag chưa tồn tại trong cùng transaction import.
- Q: BookCopy được import sẽ có trạng thái khởi tạo như thế nào? → A: Tất cả BookCopy import mặc định `condition='good'` và `status='available'`.
- Q: Sheet `Books` cần các cột nào? → A: `isbn`, `title`, `author`, `publisher`, `publicationYear`, `price`, `categories`, `tags`.
- Q: Sheet `BookCopies` cần các cột nào? → A: `isbn`, `barcode`, `location`.
- Q: Trong sheet `Books`, nhiều Category/Tag trong một ô được phân tách bằng gì? → A: Dùng dấu chấm phẩy `;`.
- Q: Audit Log cho import hàng loạt nên ghi thế nào? → A: Ghi Audit Log tổng hợp cho phiên import và ghi log cho từng Book, BookCopy, Category, Tag được tạo.
- Q: Lịch sử import và lỗi import được lưu bao lâu? → A: Lưu 1 năm.
- Q: Dòng trống trong file Excel import được xử lý thế nào? → A: Bỏ qua dòng trống hoàn toàn trong cả hai sheet.
- Q: Nếu trong file import có ISBN hoặc Barcode bị trùng lặp nội bộ, hệ thống xử lý thế nào? → A: Xem là lỗi validation, báo rõ các dòng trùng và không lưu file.

## 2. Actors & Roles
- **Librarian:** Toàn quyền truy cập CRUD (Tạo, Đọc, Sửa, Đổi trạng thái) Đầu sách, Bản sao vật lý, Danh mục và Thẻ, bao gồm import sách hàng loạt.
- **Admin:** Không được truy cập phân hệ BookManagement; quản trị hệ thống thực hiện qua các màn hình `/admin/*` riêng.
- **Library Manager:** Không được truy cập phân hệ BookManagement; các báo cáo quản trị được xử lý ở phân hệ Manager riêng khi có yêu cầu.
- **Access Control:** Chỉ Role = `LIBRARIAN` có quyền truy cập route F4 `/book-management/*`. Role = `ADMIN`, `MANAGER` và các vai trò khác phải bị từ chối với HTTP 403.

## 3. Functional Requirements (EARS)
**Quản lý Đầu sách (Book Catalog)**
- **FR-F4-01:** WHEN Librarian gửi biểu mẫu tạo Đầu sách mới, THE system SHALL kiểm tra tính duy nhất của ISBN.
- **FR-F4-02:** WHERE ISBN hợp lệ, THE system SHALL thực thi lệnh INSERT vào bảng `Book` VÀ gán giá trị mặc định `totalQuantity` = 0, `availableQuantity` = 0.
- **FR-F4-03:** WHERE ISBN đã tồn tại, THE system SHALL từ chối lưu và trả về lỗi HTTP 400 kèm thông điệp "Trùng lặp ISBN".
- **FR-F4-04:** WHEN Librarian cập nhật thông tin Đầu sách, THE system SHALL chặn bất kỳ hành vi sửa đổi nào đối với cột `isbn` (BR-18).
- **FR-F4-04A:** WHEN Librarian cập nhật thông tin Đầu sách, THE system SHALL chặn mọi hành vi sửa trực tiếp `totalQuantity` hoặc `availableQuantity`; hai trường này chỉ được hệ thống cập nhật thông qua nghiệp vụ BookCopy.

**Quản lý Bản sao vật lý (Book Copy)**
- **FR-F4-05:** WHEN Librarian quét Barcode để thêm Bản sao vật lý, THE system SHALL kiểm tra tính duy nhất của mã vạch trong bảng `BookCopy`.
- **FR-F4-06:** WHERE Barcode bị trùng lặp, THE system SHALL từ chối thêm mới VÀ báo lỗi "Mã vạch đã tồn tại trên hệ thống thuộc tựa sách [Tên sách]".
- **FR-F4-07:** WHILE thực thi thành công việc nhập kho Bản sao mới (status='available', condition='good'), THE system SHALL tự động UPDATE tăng `totalQuantity` + 1 VÀ `availableQuantity` + 1 cho bảng `Book` tương ứng trong cùng 1 Database Transaction.
- **FR-F4-08:** WHEN Librarian cập nhật trường `condition` của `BookCopy`, WHERE `BookCopy.status` = 'available' VÀ `condition` chuyển từ 'good' sang 'damaged' hoặc 'lost', THE system SHALL tự động UPDATE giảm `availableQuantity` của `Book` đi 1 đơn vị VÀ chuyển `BookCopy.status` sang 'unavailable' trong cùng Database Transaction. WHERE `BookCopy.status` = 'borrowed' hoặc 'reserved', THE system SHALL từ chối cập nhật tại F4 và yêu cầu xử lý qua F6.
- **FR-F4-09:** WHEN Librarian cập nhật thông tin Bản sao, THE system SHALL chặn mọi hành vi sửa đổi đối với `barcode` (BR-18).

**Import Sách hàng loạt**
- **FR-F4-10:** WHEN Librarian tải lên file Excel `.xlsx` import hàng loạt, THE system SHALL đọc danh sách `Book` từ sheet `Books` và danh sách `BookCopy` từ sheet `BookCopies`, trong đó mỗi `BookCopy` phải có một `barcode` cụ thể và tham chiếu được tới `Book` tương ứng bằng ISBN.
- **FR-F4-11:** WHEN hệ thống kiểm tra file import, THE system SHALL kiểm tra dữ liệu bắt buộc, tính duy nhất của ISBN và Barcode trong file VÀ trong Database, cùng tính hợp lệ của liên kết giữa `BookCopy` và `Book`.
- **FR-F4-12:** WHERE file import có ít nhất một dòng không hợp lệ, THE system SHALL từ chối toàn bộ phiên import, không lưu bất kỳ `Book` hoặc `BookCopy` nào VÀ hiển thị toàn bộ lỗi kèm số dòng để Librarian sửa file.
- **FR-F4-13:** WHERE toàn bộ file import hợp lệ, THE system SHALL tạo các `Book`, `BookCopy` và cập nhật số lượng tồn kho trong cùng một Database Transaction. Nếu bất kỳ thao tác lưu nào thất bại, hệ thống SHALL rollback toàn bộ phiên import.
- **FR-F4-14:** WHERE file import tham chiếu ISBN đã tồn tại trong Database, THE system SHALL giữ nguyên toàn bộ metadata của `Book` hiện hữu VÀ chỉ thêm các `BookCopy` mới có Barcode hợp lệ vào `Book` đó.
- **FR-F4-14A:** WHERE file import tham chiếu Category hoặc Tag chưa tồn tại, THE system SHALL tự động tạo Category hoặc Tag đó và liên kết với Book trong cùng Database Transaction của phiên import.
- **FR-F4-14B:** WHEN hệ thống tạo BookCopy từ file import, THE system SHALL bỏ qua mọi giá trị `condition` hoặc `status` từ file nếu có và luôn khởi tạo `condition='good'`, `status='available'`.

**Đối chiếu Kho dành cho Librarian**
- **FR-F4-15:** WHEN Librarian truy cập phân hệ đối chiếu tồn kho, THE system SHALL cho phép xem danh mục sách, số lượng tồn kho, lịch sử các phiên import, báo cáo BookCopy hỏng/mất và cảnh báo lệch kho.
- **FR-F4-16:** WHEN Admin, Library Manager hoặc vai trò khác gửi bất kỳ yêu cầu truy cập route F4, THE system SHALL từ chối yêu cầu với HTTP 403 và không thay đổi dữ liệu.
- **FR-F4-17:** WHEN hệ thống kiểm tra lệch kho, THE system SHALL cảnh báo một `Book` nếu `Book.totalQuantity` khác tổng số bản ghi `BookCopy` thuộc Book đó HOẶC `Book.availableQuantity` khác số `BookCopy` có `status='available'`.
- **FR-F4-18:** WHEN Librarian mở hoặc làm mới báo cáo lệch kho, THE system SHALL tính lại dữ liệu đối chiếu trực tiếp từ Database và hiển thị kết quả hiện tại mà không tự động sửa số lượng tồn kho.
- **FR-F4-18A:** WHERE báo cáo phát hiện lệch kho, THE system SHALL chỉ hiển thị cảnh báo và dữ liệu đối chiếu để Librarian điều tra BookCopy liên quan; hệ thống SHALL NOT tự động sửa `totalQuantity` hoặc `availableQuantity`.

**Lịch sử Import**
- **FR-F4-19:** WHEN hệ thống xử lý một file import, THE system SHALL lưu thông tin phiên import gồm người thực hiện, tên file, thời gian, trạng thái và tổng số dòng.
- **FR-F4-20:** WHERE phiên import có lỗi validation hoặc lỗi lưu dữ liệu, THE system SHALL lưu danh sách lỗi theo sheet, dòng và cột để Librarian tra cứu.
- **FR-F4-21:** WHERE sheet `BookCopies` chứa nhiều hơn 5.000 dòng dữ liệu, THE system SHALL từ chối file trước khi mở Database Transaction và hiển thị thông báo vượt giới hạn import.
- **FR-F4-21A:** THE system SHALL lưu lịch sử phiên import và lỗi import trong 1 năm kể từ thời điểm xử lý file.

**Audit Log**
- **FR-F4-22:** WHEN hệ thống import hàng loạt thành công, THE system SHALL ghi một Audit Log tổng hợp cho phiên import và ghi Audit Log chi tiết cho từng `Book`, `BookCopy`, `Category`, `Tag` được tạo.
- **FR-F4-23:** WHEN Librarian tạo hoặc cập nhật dữ liệu F4 ngoài import, THE system SHALL ghi Audit Log cho từng thao tác Create/Update quan trọng.

**Import Template**
- **FR-F4-24:** WHEN hệ thống đọc sheet `Books`, THE system SHALL yêu cầu đúng các cột `isbn`, `title`, `author`, `publisher`, `publicationYear`, `price`, `categories`, `tags`.
- **FR-F4-25:** WHEN hệ thống đọc sheet `BookCopies`, THE system SHALL yêu cầu đúng các cột `isbn`, `barcode`, `location`.
- **FR-F4-26:** WHEN hệ thống đọc cột `categories` hoặc `tags` trong sheet `Books`, THE system SHALL tách nhiều giá trị bằng dấu chấm phẩy `;`, trim khoảng trắng và bỏ qua phần tử rỗng.
- **FR-F4-27:** WHEN hệ thống đọc file import, THE system SHALL bỏ qua các dòng trống hoàn toàn trong cả sheet `Books` và `BookCopies`.
- **FR-F4-28:** WHERE file import có ISBN hoặc Barcode trùng lặp nội bộ, THE system SHALL xem đây là lỗi validation, báo rõ các dòng trùng và từ chối lưu toàn bộ file.

## 4. Non-functional Requirements
- **Data Consistency:** Quá trình đồng bộ số lượng tồn kho (Insert `BookCopy` và Update `Book`) BẮT BUỘC nằm trong cùng một Database Transaction. Nếu một vế thất bại, hệ thống SHALL Rollback toàn bộ.
- **Import Transaction Scope:** Phiên import hàng loạt BẮT BUỘC rollback cả Book, BookCopy, Category, Tag và các bảng liên kết nếu bất kỳ bước nào thất bại.
- **Auditability:** Mọi thao tác tạo/cập nhật dữ liệu F4 và mọi phiên import thành công BẮT BUỘC ghi Audit Log.
- **Import Atomicity:** Mỗi phiên import hàng loạt BẮT BUỘC tuân theo nguyên tắc all-or-nothing; không cho phép lưu một phần file.
- **Import Format:** Hệ thống chỉ tiếp nhận file Excel `.xlsx` có đúng hai sheet bắt buộc tên `Books` và `BookCopies`.
- **Books Sheet Columns:** Sheet `Books` phải có các cột `isbn`, `title`, `author`, `publisher`, `publicationYear`, `price`, `categories`, `tags`.
- **BookCopies Sheet Columns:** Sheet `BookCopies` phải có các cột `isbn`, `barcode`, `location`.
- **Multi-value Separator:** Các cột `categories` và `tags` dùng dấu chấm phẩy `;` để phân tách nhiều giá trị.
- **Import Capacity:** Mỗi file import hỗ trợ tối đa 5.000 BookCopy.
- **Authorization:** Mọi Servlet và JSP thuộc F4 BẮT BUỘC được bảo vệ bởi `AuthFilter`. Chỉ Role = `LIBRARIAN` được phép truy cập, đọc và thay đổi dữ liệu; Role = `ADMIN`, `MANAGER` và các vai trò khác phải bị từ chối với HTTP 403.
- **Performance:** Truy vấn danh mục sách (có filter) phải phản hồi dưới 500ms (P95).

## 5. Data Model
- **Book:** `bookId`, `isbn` (UNIQUE), `title`, `author`, `totalQuantity`, `availableQuantity`, `status`.
- **BookCopy:** `bookCopyId`, `bookId`, `barcode` (UNIQUE), `condition` (good, damaged, lost), `status` (available, unavailable, borrowed, reserved).
- **BookImportBatch:** Thông tin phiên import gồm người thực hiện, tên file, thời gian, trạng thái và tổng số dòng.
- **BookImportError:** Chi tiết lỗi của phiên import gồm sheet, dòng, cột và thông báo lỗi.
- **Import Retention:** Dữ liệu `BookImportBatch` và `BookImportError` được lưu trong 1 năm.

## 6. Error Handling
- WHERE dữ liệu vi phạm ràng buộc định danh (trùng ISBN/Barcode), THE system SHALL từ chối giao dịch và hiển thị flash message báo lỗi tương ứng.
- WHERE Database Transaction gặp SQLException trong lúc đồng bộ kho, THE system SHALL gọi `connection.rollback()`, ghi log lỗi và trả về HTTP 500 với thông báo "Lỗi hệ thống trong quá trình đồng bộ dữ liệu".

## 7. Acceptance Criteria
- [ ] Khởi tạo Đầu sách mới với ISBN chưa tồn tại: Thành công, số lượng khởi tạo bằng 0.
- [ ] Khởi tạo Đầu sách mới với ISBN đã tồn tại: Báo lỗi và chặn lưu.
- [ ] Nhập kho Bản sao mới: Thành công, cột `totalQuantity` và `availableQuantity` của sách tự động tăng thêm 1.
- [ ] Sửa `condition` của Bản sao từ 'good' sang 'lost': Cột `availableQuantity` tự động giảm đi 1, cột `status` thành 'unavailable'.
- [ ] Cố tình sửa `condition` tại F4 cho Bản sao đang `borrowed` hoặc `reserved`: Báo lỗi và không thay đổi dữ liệu tồn kho.
- [ ] Cố tình sửa đổi ISBN của Book hoặc Barcode của BookCopy sau khi đã lưu: Báo lỗi và chặn giao dịch.
- [ ] Cố tình gửi yêu cầu sửa trực tiếp `totalQuantity` hoặc `availableQuantity`: Hệ thống báo lỗi, chặn giao dịch và không thay đổi dữ liệu.
- [ ] Tải file import chứa Book và BookCopy hợp lệ: Mỗi BookCopy được tạo với đúng Barcode và liên kết tới Book tương ứng.
- [ ] Tải file không phải `.xlsx` hoặc thiếu sheet `Books`/`BookCopies`: Hệ thống từ chối file và hiển thị lỗi cấu trúc.
- [ ] Tải file import chứa Barcode trùng trong file hoặc Database: Hệ thống phát hiện và báo rõ dòng dữ liệu vi phạm.
- [ ] Tải file import chứa ISBN đã tồn tại và Barcode mới hợp lệ: Giữ nguyên metadata Book hiện hữu và chỉ tạo thêm BookCopy.
- [ ] Tải file import chứa Category/Tag chưa tồn tại: Hệ thống tự tạo Category/Tag và liên kết với Book trong cùng transaction.
- [ ] Tải file import có BookCopy hợp lệ: Mọi BookCopy được tạo với `condition='good'` và `status='available'`.
- [ ] Tải file import có ít nhất một dòng lỗi: Không có Book, BookCopy hoặc số lượng tồn kho nào bị thay đổi; hệ thống hiển thị toàn bộ lỗi theo dòng.
- [ ] Xảy ra SQLException trong lúc lưu file import hợp lệ: Toàn bộ thay đổi của phiên import được rollback.
- [ ] Người dùng có Role = `ADMIN` truy cập trực tiếp route F4 hoặc import hàng loạt: Hệ thống trả về HTTP 403 và không thay đổi dữ liệu.
- [ ] Library Manager truy cập trực tiếp route F4: Hệ thống trả về HTTP 403 và không thay đổi dữ liệu.
- [ ] Số lượng tổng hợp trong Book khác dữ liệu BookCopy: Hệ thống đánh dấu đúng Book bị lệch và hiển thị số lượng tổng hợp cùng số lượng tính lại.
- [ ] Librarian làm mới báo cáo lệch kho: Hệ thống tính lại cảnh báo từ dữ liệu Database hiện tại và không thay đổi dữ liệu Book hoặc BookCopy.
- [ ] Báo cáo phát hiện lệch kho: Hệ thống chỉ hiển thị cảnh báo và không cung cấp thao tác tự động sửa số lượng.
- [ ] Phiên import có lỗi: Lịch sử import lưu được thông tin phiên và toàn bộ lỗi theo sheet, dòng và cột.
- [ ] Phiên import thành công: Hệ thống ghi Audit Log tổng hợp cho phiên import và Audit Log chi tiết cho từng entity được tạo.
- [ ] Tạo hoặc cập nhật Book/BookCopy/Category/Tag ngoài import: Hệ thống ghi Audit Log tương ứng.
- [ ] File import chứa hơn 5.000 BookCopy: Hệ thống từ chối trước khi thay đổi Database và thông báo rõ giới hạn.
- [ ] Sheet `Books` thiếu hoặc sai tên cột bắt buộc: Hệ thống từ chối file và báo lỗi cấu trúc.
- [ ] Sheet `BookCopies` thiếu hoặc sai tên cột bắt buộc: Hệ thống từ chối file và báo lỗi cấu trúc.
- [ ] Cột `categories` hoặc `tags` chứa nhiều giá trị phân tách bằng `;`: Hệ thống trim và liên kết đúng từng Category/Tag.
- [ ] File import chứa dòng trống hoàn toàn: Hệ thống bỏ qua dòng trống và không báo lỗi cho dòng đó.
- [ ] File import chứa ISBN hoặc Barcode trùng lặp nội bộ: Hệ thống báo rõ các dòng trùng, không lưu bất kỳ dữ liệu nào.
- [ ] Admin, Library Manager hoặc vai trò khác cố tình gửi yêu cầu tạo, cập nhật, đổi trạng thái hoặc import F4: Hệ thống trả về HTTP 403 và không thay đổi dữ liệu.
- [ ] Người dùng không có Role = `LIBRARIAN` truy cập chức năng F4: Hệ thống trả về HTTP 403 và không thay đổi dữ liệu.

## 8. Out of Scope
- Hệ thống KHÔNG cho phép Hard Delete (xóa cứng) dữ liệu `Book` và `BookCopy`.
- Hệ thống KHÔNG xử lý các nghiệp vụ Check-out, Check-in hay tính tiền phạt tại Feature này.
