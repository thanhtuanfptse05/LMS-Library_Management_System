# .sdd/constraints/business.md
# Phiên bản: 1.2.0 | Trạng thái: LOCKED

Dưới đây là danh sách chính thức **35 Quy tắc Nghiệp vụ (Business Rules - BR01 đến BR35)** của hệ thống LMS Library Management System. AI Agent và Developer bắt buộc phải tuân thủ 100% khi triển khai code nghiệp vụ, không được tự ý thay đổi hoặc tự suy diễn thêm luật mới.

---

## I. XÁC THỰC & BẢO MẬT (AUTHENTICATION, AUTHORIZATION & SECURITY)

### BR01: Authentication (Xác thực)
* **Mô tả:** Hệ thống tự động khóa tài khoản tạm thời nếu người dùng nhập sai thông tin đăng nhập vượt quá số lần quy định.
* **English:** The system automatically locks a user account temporarily if the number of failed login attempts exceeds the configured limit.

### BR02: Authorization (Phân quyền)
* **Mô tả:** Quản trị viên KHÔNG ĐƯỢC PHÉP xóa vĩnh viễn bất kỳ tài khoản người dùng nào khỏi hệ thống, mà chỉ được phép thay đổi trạng thái thành "Khóa" (Locked) để bảo toàn lịch sử giao dịch.
* **English:** Administrators are NOT ALLOWED to permanently delete any user account from the system; they are only allowed to change the account status to "Locked" to preserve transaction history.

### BR03: Authorization (Phân quyền)
* **Mô tả:** Mọi người dùng chỉ được phép truy cập vào các tính năng và dữ liệu tương ứng với vai trò (Role) của mình. Các nỗ lực truy cập trái phép phải bị hệ thống chặn và ghi log.
* **English:** Users are only allowed to access features and data corresponding to their assigned roles. Unauthorized access attempts must be blocked and logged by the system.

### BR22: Authentication & Security
* **Mô tả:** Việc đặt lại/thay đổi mật khẩu phải đáp ứng: tối thiểu 8 ký tự gồm chữ hoa, chữ thường, số và ký tự đặc biệt; không được trùng mật khẩu gần nhất; yêu cầu xác thực mật khẩu hiện tại.
* **English:** Password reset/change must satisfy the following requirements: minimum 8 characters including uppercase letters, lowercase letters, numbers, and special characters; must not match the most recent password; requires current password verifications.

### BR27: Security
* **Mô tả:** Tất cả dữ liệu nhạy cảm của thành viên và giao dịch phải được mã hóa khi truyền và khi lưu trữ theo chính sách bảo mật của trường đại học.
* **English:** All sensitive member and transaction data must be encrypted both in transit and at rest according to university security policies.

### BR29: Authentication & Security 
* **Mô tả:** Mỗi người dùng được cấp tài khoản đã phân quyền trước với mật khẩu mặc định trùng với tên đăng nhập. Ngay sau khi đăng nhập thành công lần đầu tiên, hệ thống BẮT BUỘC điều hướng người dùng đến trang đổi mật khẩu và chặn mọi thao tác khác cho đến khi mật khẩu mới được thiết lập. 
* **English:** Each user is provisioned with a pre-authorized account where the default password matches the username. Upon the first successful login, the system MUST redirect the user to the password change screen and block all other activities until a new password is set.

### BR30: Authentication & Security
* **Mô tả:** Tiến trình tự động khóa tài khoản do nợ phạt không được phép ghi đè lên các lý do khóa nghiêm trọng hơn đang có hiệu lực (như admin ban hoặc security breach). Khi người dùng đóng hết tiền phạt, tài khoản chỉ được tự động mở khóa nếu lý do khóa hiện tại là unpaid và không còn bất kỳ điều kiện khóa nào khác. 
* **English:** Automatic account locking due to unpaid fines must not overwrite existing severe lock reasons (such as adminban or securitybreach). Upon paying all fines, the account can only be unlocked if the lock reason is unpaid and no other active lock conditions (failed login attempts, admin ban) exist. 

### BR31: Account Deactivation 
* **Mô tả:** Tài khoản không hoạt động trong một khoảng thời gian cấu hình có thể bị tạm khóa tự động. 
* **English:** Inactive accounts for a configurable period may be automatically suspended. 

---

## II. QUẢN LÝ GIAO DỊCH & MƯỢN TRẢ (TRANSACTION & LOAN EXTENSION)

### BR04: Transaction
* **Mô tả:** Người dùng không được phép tạo đặt mới hoặc mượn sách nếu còn nợ phí phạt.
* **English:** User is not allowed to create new reservations or borrow books while having unpaid fines. 

### BR05: Transaction
* **Mô tả:** Người dùng KHÔNG ĐƯỢC PHÉP thực hiện Đặt trước sách nếu tổng số lượng "Sách đang mượn" cộng với "Sách đang đặt trước" đã đạt đến hạn mức mượn tối đa của họ.
* **English:** Users are NOT ALLOWED to reserve books if the total number of "Borrowed Books" plus "Reserved Books" has already reached their maximum borrowing limit.

### BR06: Transaction
* **Mô tả:** Thời gian mượn tối đa cho một cuốn sách được quy định linh hoạt dựa trên vai trò của người dùng theo cấu hình hệ thống.
* **English:** The maximum borrowing duration for a book is flexibly determined based on the user’s role according to system configuration.

### BR07: Loan Extension
* **Mô tả:** Người dùng chỉ được gia hạn thời gian mượn nếu tựa sách đó HIỆN KHÔNG CÓ bất kỳ ai khác đang xếp hàng chờ đặt trước.
* **English:** Users are only allowed to extend the loan period if the book title currently has NO other reservation requests in queue.

### BR08: Loan Extension
* **Mô tả:** Mỗi giao dịch mượn sách chỉ được phép gia hạn tối đa một số lần nhất định, không được phép gia hạn vô hạn.
* **English:** Each borrowing transaction can only be extended a limited number of times and cannot be renewed indefinitely.

### BR21: Transaction
* **Mô tả:** Khi đến lượt nhận sách đặt trước, nếu người dùng đang có nợ phạt, hệ thống VẪN giữ sách và báo "Sẵn sàng để lấy". Tuy nhiên, hệ thống sẽ KHÓA chức năng giao sách tại quầy; người dùng bắt buộc phải thanh toán xong nợ phạt thì Thủ thư mới có thể quét mã cho mượn cuốn sách đó.
* **English:** When a reserved book becomes available, if the user still has unpaid fines, the system STILL keeps the book in "Ready for Pickup" status. However, the book lending function at the counter is LOCKED until the user fully pays the fines before the Librarian can complete the borrowing process.

### BR28: Transaction Integrity
* **Mô tả:** Mọi giao dịch mượn và trả sách phải được liên kết với ID thành viên, ID sách và ID giao dịch hợp lệ.
* **English:** All borrowing and returning transactions must be linked to valid member IDs, book IDs, and transaction IDs.

### BR32: Book Availability Validation 
* **Mô tả:** Một bản sao sách chỉ được phép cho mượn khi trạng thái là Available. 
* **English:** A book copy can only be borrowed if its status is Available. 

### BR33: Duplicate Borrow Prevention 
* **Mô tả:** Người dùng không được mượn cùng một bản sao sách nhiều lần cùng lúc. 
* **English:** A user cannot borrow the same physical copy more than once simultaneously. 

---

## III. HÀNG CHỜ ĐẶT TRƯỚC (RESERVATION QUEUE)

### BR09: Reservation Queue
* **Mô tả:** Các tựa sách nếu đang ở trạng thái "quá hạn" (tất cả các bản sao đều chưa được trả dù đã lố ngày) thì việc đặt trước vẫn được chấp nhận, nhưng việc giao hàng sẽ bị trì hoãn cho đến khi có hàng.
* **English:** Book titles in "Overdue" status (all copies not returned past due date), Reservation requests remain allowed, but fulfillment is delayed until a copy becomes available. 

### BR10: Reservation Queue
* **Mô tả:** Khi sách đặt trước đã có sẵn, hệ thống chuyển trạng thái sang "Sẵn sàng để lấy" và chỉ giữ bản sao sách đó cho người dùng trong một khoảng thời gian hiệu lực quy định.
* **English:** When a reserved book becomes available, the system changes its status to "Ready for Pickup" and only holds the physical copy for the user within the configured validity period.

### BR11: Reservation Queue
* **Mô tả:** Nếu người dùng không đến nhận sách trong thời gian hiệu lực, hệ thống tự động hủy quyền của họ. Bản sao sách vật lý đó NẾU ở tình trạng bình thường, BẮT BUỘC phải được ưu tiên luân chuyển ngay cho thành viên hợp lệ tiếp theo.
* **English:** If the user does not pick up the reserved book within the validity period, the system automatically cancels their reservation. If the physical copy is in normal condition, it MUST immediately be circulated to the next eligible member in queue.

### BR12: Reservation Queue
* **Mô tả:** Nếu người dùng có số lần "đặt sách nhưng không đến lấy" vượt quá mức cho phép, tài khoản sẽ bị phạt theo cấu hình của Admin.
* **English:** If the number of "reserved but not collected" books by a user exceeds the allowed threshold, the account will be penalized according to Admin configuration.

### BR34: Reservation Queue Priority 
* **Mô tả:** Sách đặt trước phải được phân bổ theo nguyên tắc ai đặt trước được phục vụ trước. 
* **English:** Reserved books must be allocated according to a First-Come-First-Served queue. 

### BR35: Self Reservation Restriction 
* **Mô tả:** Người dùng không được đặt trước chính tựa sách mà mình đang mượn. 
* **English:** Users are not allowed to reserve a title that they are currently borrowing. 

---

## IV. TÀI SẢN & KHO SÁCH (PHYSICAL INVENTORY & DATA VALIDATION)

### BR13: Physical Inventory
* **Mô tả:** Ngay tại thời điểm quét mã nhận trả sách, Thủ thư bắt buộc phải ghi nhận tình trạng vật lý của sách. Nếu sách bị "Hư hỏng nặng" hoặc "Mất", hệ thống KHÔNG ĐƯỢC đưa sách vào luân chuyển hàng chờ mà phải loại khỏi kho và kích hoạt luồng phạt đền bù.
* **English:** At the time of scanning a returned book, the Librarian is required to record the physical condition of the book. If the book is marked as "Severely Damaged" or "Lost", the system MUST NOT circulate it in the reservation queue but instead remove it from inventory and trigger the compensation fine process.

### BR23: Data Validation
* **Mô tả:** Email, số điện thoại và MSSV/MSGV phải là duy nhất. Hệ thống phải phát hiện hồ sơ trùng lặp và ngăn tạo tài khoản trùng.
* **English:** Email, phone number, and student/faculty ID must be unique. The system must detect duplicate profiles and prevent duplicate account creation.

### BR24: Data Validation
* **Mô tả:** Mỗi bản ghi sách phải có ISBN hoặc mã thư viện duy nhất cùng các thông tin hợp lệ như tiêu đề, tác giả, nhà xuất bản, năm xuất bản, thể loại, mã phân loại, số lượng và giá sách.
* **English:** Each book record must have a unique ISBN or library ID along with valid information such as title, author, publisher, publication year, category, classification code, quantity, and book price.

---

## V. TÀI CHÍNH & PHẠT (FINANCE)

### BR14: Finance
* **Mô tả:** Tiền phạt trễ hạn được tính cộng dồn: Số ngày trễ nhân với đơn giá phạt/ngày (Đơn giá do Admin cấu hình).
* **English:** Overdue fines are accumulated based on the formula: number of overdue days multiplied by the configured fine rate per day.

### BR15: Finance
* **Mô tả:** Tổng số tiền phạt trễ hạn cho một giao dịch mượn không được phép vượt quá mức trần tối đa đã được cấu hình(ví dụ: 150% giá trị sách).
* **English:** The total overdue fine for a borrowing transaction must not exceed the configured maximum threshold (e.g., 150% of the book value).

### BR16: Finance
* **Mô tả:** Nếu người dùng làm Mất hoặc Hư hỏng nặng sách, hệ thống áp dụng mức phạt đền bù độc lập với phạt trễ hạn.
* **English:** If a user loses or severely damages a book, the system applies a compensation fine independently from overdue fines.

### BR17: Finance
* **Mô tả:** Giao dịch thanh toán trực tuyến (VNPAY) nếu không có xác nhận thành công từ cổng thanh toán trong vòng 15 phút sẽ tự động bị hệ thống hủy bỏ.
* **English:** Online payment transactions (VNPAY) that do not receive successful confirmation from the payment gateway within 15 minutes are automatically canceled by the system.

---

## VI. TÍCH HỢP AI, GIÁM SÁT & CẤU HÌNH (INTEGRATION, AUDIT & CONFIG)

### BR18: AI Integration
* **Mô tả:** Các kết quả do AI cung cấp (gợi ý sách, phân tích thói quen) chỉ mang tính chất hỗ trợ và tham khảo. Quyết định cuối cùng (như duyệt mượn, phạt, khóa tài khoản) phải do hệ thống luật định sẵn hoặc Thủ thư thực hiện.
* **English:** AI-generated results (book recommendations, habit analysis) are for support and reference purposes only. Final decisions (such as borrowing approval, penalties, or account locking) must be enforced by predefined system rules or Librarians.

### BR19: Monitoring
* **Mô tả:** Hệ thống phải duy trì một nhật ký hoạt động (Audit Log) cho mọi thao tác cốt lõi. Dữ liệu nhật ký này không thể bị sửa chữa hay xóa bỏ bởi bất kỳ ai.
* **English:** The system must maintain an Audit Log for all core operations. Audit log data must not be modified or deleted by anyone.

### BR20: Configuration
* **Mô tả:** Toàn bộ các tham số vận hành (giới hạn mượn, giá phạt, thời gian khóa, hiệu lực đặt trước) phải được lưu tập trung. Mọi thay đổi cấu hình phải được hệ thống áp dụng ngay lập tức cho các giao dịch mới.
* **English:** All operational parameters (borrowing limits, fine rates, lock duration, reservation validity) must be centrally managed. Any configuration changes must immediately apply to new transactions.

### BR25: Document Management
* **Mô tả:** Phiếu mượn, xác nhận trả và thông báo phạt phải tuân theo mẫu chuẩn gồm thông tin thư viện, thành viên, chi tiết giao dịch, thời gian và mã tham chiếu. File PDF xuất ra phải đảm bảo toàn vẹn dữ liệu và chống chỉnh sửa trái phép.
* **English:** Borrowing receipts, return confirmations, and fine notices must follow a standardized template including library information, member details, transaction details, timestamp, and reference number. Exported PDF files must ensure data integrity and prevent unauthorized modifications.

### BR26: Notification
* **Mô tả:** Các hành động quan trọng gồm mượn, trả, cập nhật đặt trước, thanh toán phạt và gia hạn phải kích hoạt thông báo tự động qua email hoặc tin nhắn hệ thống.
* **English:** Important actions including borrowing, returning, reservation updates, fine payments, and loan extensions must trigger automatic notifications via email or system messages.
