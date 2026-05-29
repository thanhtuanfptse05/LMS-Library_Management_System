# Business Rules Registry — Library Management System (LMS)
# Version: 2.1.0 | Updated: 29/5/2026
# Source of Truth cho tất cả Business Rules được tham chiếu trong project.
# Trích xuất từ: Tài liệu FR/UC/BR chính thức (32 FR, 23 UC, 31 BR)

---

## Cách sử dụng

Khi viết Spec hoặc code, tham chiếu BR bằng mã đầy đủ `BR-LMS-XXX`.
Mã viết tắt (BR01, BR02...) là alias từ tài liệu nghiệp vụ gốc — xem bảng mapping bên dưới.

---

## Mapping Viết Tắt → Mã Đầy Đủ

| Mã viết tắt | Mã đầy đủ | Nhóm | Mô tả tóm tắt (EN) |
|---|---|---|---|
| BR01 | BR-LMS-001 | Authentication | Auto-lock account after N failed login attempts |
| BR02 | BR-LMS-002 | Authorization | No permanent delete — lock only |
| BR03 | BR-LMS-003 | Authorization | RBAC enforcement + unauthorized access logging |
| BR04 | BR-LMS-004 | Transaction | Must pay all fines before borrow/extend/reserve |
| BR05 | BR-LMS-005 | Transaction | Block reserve when borrowed + reserved >= max limit |
| BR06 | BR-LMS-006 | Transaction | Loan duration determined by role + config |
| BR07 | BR-LMS-007 | Loan Extension | Extension blocked if reservation queue exists |
| BR08 | BR-LMS-008 | Loan Extension | Max extension count per transaction |
| BR09 | BR-LMS-009 | Reservation Queue | Block new reservations for fully-overdue titles |
| BR10 | BR-LMS-010 | Reservation Queue | Ready-for-pickup status + validity period hold |
| BR11 | BR-LMS-011 | Reservation Queue | Auto-cancel expired pickup + circulate to next |
| BR12 | BR-LMS-012 | Reservation Queue | Penalty for exceeding no-show threshold |
| BR13 | BR-LMS-013 | Physical Inventory | Mandatory condition check on return scan |
| BR14 | BR-LMS-014 | Finance | Overdue fine = days × fine_per_day (cumulative) |
| BR15 | BR-LMS-015 | Finance | Fine cap at max threshold (e.g. 150% book price) |
| BR16 | BR-LMS-016 | Finance | Compensation fine for lost/severely damaged books |
| BR17 | BR-LMS-017 | Finance | Auto-cancel unpaid VNPAY transactions after 15 min |
| BR18 | BR-LMS-018 | AI Integration | AI results are advisory only |
| BR19 | BR-LMS-019 | Monitoring | Immutable Audit Log for all core operations |
| BR20 | BR-LMS-020 | Configuration | Centralized config — changes apply immediately |
| BR21 | BR-LMS-021 | Transaction | Ready-for-pickup still held if user has fines, but lending locked until paid |
| BR22 | BR-LMS-022 | Authentication & Security | Password policy (8+ chars, complexity, OTP 6 digits/15 min) |
| BR23 | BR-LMS-023 | Data Validation | Unique email, phone, student/faculty code |
| BR24 | BR-LMS-024 | Data Validation | Book record requires unique ISBN + valid metadata |
| BR25 | BR-LMS-025 | Document Management | Standardized templates for receipts, confirmations, fines |
| BR26 | BR-LMS-026 | Data Classification | Books classified by DDC or LCC standards |
| BR27 | BR-LMS-027 | Notification | Auto-notification triggers for key actions |
| BR28 | BR-LMS-028 | Security | Encrypt sensitive data in-transit and at-rest |
| BR29 | BR-LMS-029 | Transaction Integrity | All transactions linked to valid member/book/transaction IDs |
| BR30 | BR-LMS-030 | Authentication & Security | Force password change on first login |
| BR31 | BR-LMS-031 | Authentication & Security | Safeguards for fine-based lock/unlock logic |

---

## Danh Sách Business Rules Đầy Đủ

### Authentication & Security

| Mã | Tên | Mô tả | FR/UC tham chiếu |
|---|---|---|---|
| BR-LMS-001 | Login Lockout | Hệ thống tự động khóa tài khoản tạm thời nếu người dùng nhập sai thông tin đăng nhập vượt quá số lần quy định (`failed_login_attempts >= N` → `User.status = 'locked'`, set `locked_until`). | FR01, FR02, UC01 |
| BR-LMS-022 | Password Policy & OTP | Password ≥8 ký tự gồm chữ hoa, thường, số, ký tự đặc biệt. Không trùng mật khẩu gần nhất. Yêu cầu xác thực mật khẩu hiện tại khi đổi. OTP 6 số, hết hạn 15 phút. | FR01, UC01 |
| BR-LMS-028 | Data Encryption | Tất cả dữ liệu nhạy cảm phải được mã hóa in-transit (TLS 1.2+) và at-rest theo chính sách bảo mật trường đại học. | Constitution SEC-04 |
| BR-LMS-030 | First Login Password Change | Mỗi người dùng được cấp tài khoản đã phân quyền trước với mật khẩu mặc định trùng với tên đăng nhập. Ngay sau khi đăng nhập thành công lần đầu tiên, hệ thống BẮT BUỘC điều hướng người dùng đến trang đổi mật khẩu và chặn mọi thao tác khác cho đến khi mật khẩu mới được thiết lập. | FR01, UC01 |
| BR-LMS-031 | Fine Lock/Unlock Safeguards | Tiến trình tự động khóa tài khoản do nợ phạt không được phép ghi đè lên các lý do khóa nghiêm trọng hơn đang có hiệu lực (như adminban hoặc securitybreach). Khi người dùng đóng hết tiền phạt, tài khoản chỉ được tự động mở khóa nếu lý do khóa hiện tại là unpaid và không còn bất kỳ điều kiện khóa nào khác. | FR27, FR29, UC12, UC22 |

### Authorization

| Mã | Tên | Mô tả | FR/UC tham chiếu |
|---|---|---|---|
| BR-LMS-002 | No Permanent Delete | Admin KHÔNG ĐƯỢC xóa vĩnh viễn bất kỳ tài khoản nào. Chỉ thay đổi `User.status = 'locked'` để bảo toàn lịch sử giao dịch. | FR27, UC22 |
| BR-LMS-003 | RBAC Enforcement | Mọi người dùng chỉ truy cập tính năng/dữ liệu tương ứng role. Unauthorized access bị chặn VÀ ghi log vào AuditLogs. | FR01, UC01-UC23 |

### Transaction & Borrowing

| Mã | Tên | Mô tả | FR/UC tham chiếu |
|---|---|---|---|
| BR-LMS-004 | Fine-First Policy | Người dùng BẮT BUỘC thanh toán toàn bộ nợ phạt trước khi được nhận sách gia hạn hoặc đặt trước thêm sách mới. | FR09, FR11, UC08, UC09 |
| BR-LMS-005 | Borrow+Reserve Limit | KHÔNG ĐƯỢC đặt trước nếu tổng "Sách đang mượn" + "Sách đang đặt trước" ≥ `max_borrow_limit` (configurable). | FR13, UC09 |
| BR-LMS-006 | Role-based Loan Duration | Thời gian mượn tối đa linh hoạt theo vai trò người dùng, lấy từ `SystemConfigurations`. | FR10, UC13 |
| BR-LMS-021 | Ready-Pickup Fine Lock | Khi đến lượt nhận sách đặt trước nhưng user có nợ phạt: hệ thống VẪN giữ sách "Ready for Pickup" nhưng KHÓA chức năng giao sách tại quầy. User phải thanh toán xong nợ phạt trước. | FR09, FR13, UC09 |
| BR-LMS-029 | Transaction Integrity | Mọi giao dịch mượn/trả phải liên kết với `userId`, `bookId`, `bookCopyId`, và `borrowRecordId` hợp lệ. | FR09, FR22, UC13, UC14 |

### Loan Extension

| Mã | Tên | Mô tả | FR/UC tham chiếu |
|---|---|---|---|
| BR-LMS-007 | Extension Queue Check | Chỉ được gia hạn nếu tựa sách đó HIỆN KHÔNG CÓ ai khác đang xếp hàng chờ đặt trước (`Reservation.status IN ('pending', 'readypickup')` cho cùng `bookId`). | FR11, FR12, UC08 |
| BR-LMS-008 | Max Extension Count | Mỗi giao dịch mượn chỉ gia hạn tối đa `max_extensions` lần (configurable). Không gia hạn vô hạn. | FR11, FR12, UC08 |

### Reservation Queue

| Mã | Tên | Mô tả | FR/UC tham chiếu |
|---|---|---|---|
| BR-LMS-009 | Overdue Title Block | Tựa sách mà TẤT CẢ bản sao đều quá hạn chưa trả → tạm chặn reservation mới cho tựa sách đó. | FR13, UC09 |
| BR-LMS-010 | Ready-for-Pickup Hold | Khi sách đặt trước có sẵn → chuyển `Reservation.status = 'readypickup'`, gán `bookCopyId`, set `end_date = GETDATE() + reservation_validity_days`. Chỉ giữ trong thời gian hiệu lực. | FR23, UC09 |
| BR-LMS-011 | Auto-Cancel & Circulate | Nếu user không lấy sách trong thời gian hiệu lực → auto hủy reservation. Bản sao sách NẾU ở tình trạng bình thường (condition = 'good') → BẮT BUỘC luân chuyển ngay cho người tiếp theo trong hàng chờ. | FR30, UC09 |
| BR-LMS-012 | No-Show Penalty | Nếu số lần "đặt sách nhưng không đến lấy" vượt mức cho phép (configurable) → tài khoản bị phạt theo cấu hình Admin. | FR30, UC09 |

### Physical Inventory

| Mã | Tên | Mô tả | FR/UC tham chiếu |
|---|---|---|---|
| BR-LMS-013 | Return Condition Check | Khi quét trả sách, Thủ thư BẮT BUỘC ghi nhận condition. Nếu "Hư hỏng nặng" hoặc "Mất" → KHÔNG đưa vào luân chuyển hàng chờ, loại khỏi kho (`BookCopy.status = 'unavailable'`), kích hoạt luồng phạt đền bù (BR-LMS-016). | FR21, FR22, UC14, UC18 |

### Finance

| Mã | Tên | Mô tả | FR/UC tham chiếu |
|---|---|---|---|
| BR-LMS-014 | Overdue Fine Formula | Tiền phạt trễ hạn = `fine_per_day × days_overdue` (cộng dồn hằng ngày qua cách cập nhật UPDATE số tiền trên bản ghi Fine unpaid cũ thay vì chèn INSERT dòng mới mỗi ngày). Đơn giá `fine_per_day` do Admin cấu hình. | FR29, UC11 |
| BR-LMS-015 | Fine Cap | Tổng phạt trễ hạn cho 1 giao dịch KHÔNG vượt quá mức trần: `min(fine_calculated, book_price × max_fine_multiplier)` (Sử dụng `default_book_price` và `max_fine_multiplier` từ cấu hình nếu giá sách bị NULL). | FR29, UC11 |
| BR-LMS-016 | Compensation Fine | Nếu sách Mất hoặc Hư hỏng nặng → áp dụng mức phạt đền bù ĐỘC LẬP với phạt trễ hạn. | FR22, UC14, UC18 |
| BR-LMS-017 | VNPAY Timeout Cancel | Giao dịch thanh toán VNPAY không có xác nhận thành công trong 15 phút → hệ thống tự động hủy (`Payment.status = 'canceled'`). | FR17, FR32, UC12 |

### AI Integration

| Mã | Tên | Mô tả | FR/UC tham chiếu |
|---|---|---|---|
| BR-LMS-018 | AI Advisory Only | Kết quả AI gợi ý sách chỉ mang tính tham khảo. Quyết định cuối cùng (duyệt mượn, phạt, khóa tài khoản) do hệ thống luật định sẵn hoặc Thủ thư thực hiện. | FR08, UC07 |

### Monitoring & Audit

| Mã | Tên | Mô tả | FR/UC tham chiếu |
|---|---|---|---|
| BR-LMS-019 | Immutable Audit Log | Hệ thống PHẢI duy trì Audit Log cho mọi thao tác cốt lõi. Dữ liệu log KHÔNG THỂ bị sửa đổi hay xóa bỏ bởi bất kỳ ai. | FR28, UC23 |

### Configuration

| Mã | Tên | Mô tả | FR/UC tham chiếu |
|---|---|---|---|
| BR-LMS-020 | Centralized Config | Toàn bộ tham số vận hành (`max_borrow_limit`, `fine_per_day`, `account_lock_duration_minutes`, `reservation_validity_days`, `max_extensions`, `extension_duration_days`, `max_loan_days`, `default_book_price`, `max_fine_multiplier`, `max_no_show_limit`, `no_show_lock_duration_days`) lưu tập trung trong `SystemConfigurations`. Mọi thay đổi áp dụng ngay cho giao dịch mới. | FR25, UC20 |

### Data Validation

| Mã | Tên | Mô tả | FR/UC tham chiếu |
|---|---|---|---|
| BR-LMS-023 | Unique Identity Fields | Email, phone_number, student_code/lecturer_code PHẢI là duy nhất. Hệ thống phát hiện trùng lặp → chặn tạo tài khoản/hồ sơ. | FR05, UC04 |
| BR-LMS-024 | Book Record Validation | Mỗi bản ghi sách phải có ISBN unique + tiêu đề, tác giả, NXB, năm XB, thể loại, mã phân loại, số lượng, giá sách hợp lệ. | FR18, UC15 |

### Document Management

| Mã | Tên | Mô tả | FR/UC tham chiếu |
|---|---|---|---|
| BR-LMS-025 | Standardized Templates | Phiếu mượn, xác nhận trả, thông báo phạt tuân theo mẫu chuẩn: thông tin thư viện, thành viên, chi tiết giao dịch, timestamp, mã tham chiếu. PDF xuất ra đảm bảo toàn vẹn dữ liệu. | FR09, FR22, UC13, UC14 |

### Data Classification

| Mã | Tên | Mô tả | FR/UC tham chiếu |
|---|---|---|---|
| BR-LMS-026 | Standard Classification | Sách phân loại theo DDC (Dewey Decimal Classification) hoặc LCC (Library of Congress Classification). | FR18, UC15, UC16 |

### Notification

| Mã | Tên | Mô tả | FR/UC tham chiếu |
|---|---|---|---|
| BR-LMS-027 | Auto-Notification Triggers | Các hành động: mượn, trả, cập nhật đặt trước, thanh toán phạt, gia hạn → kích hoạt thông báo tự động qua email hoặc system message. | FR15, FR31, UC08-UC12 |
