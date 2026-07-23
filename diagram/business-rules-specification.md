# BẢNG QUY TẮC NGHIỆP VỤ HỆ THỐNG (58 BUSINESS RULES - LMS)

**Dự án:** Hệ thống Quản lý Thư viện Đại học (LMS) - SWP391 Milestone 2  
**Phiên bản:** 4.0.0 | **Ngày:** 2026-07-22  

---

<table border="1" width="100%">
  <thead>
    <tr>
      <th width="12%">Mã Quy Tắc<br>(Rule ID)</th>
      <th width="18%">Nhóm Quy Tắc<br>(Category)</th>
      <th width="35%">Mô Tả Tiếng Anh<br>(English Description)</th>
      <th width="35%">Mô Tả Tiếng Việt<br>(Vietnamese Description)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>BR-01</b></td>
      <td>Authentication</td>
      <td>The system SHALL temporarily suspend access if the user provides incorrect credentials 5 consecutive times.</td>
      <td>Hệ thống SHALL tạm đình chỉ quyền truy cập nếu người dùng cung cấp thông tin xác thực sai 5 lần liên tiếp.</td>
    </tr>
    <tr>
      <td><b>BR-02</b></td>
      <td>Authentication</td>
      <td>The default suspension duration for security violations SHALL be 30 minutes from the last attempt.</td>
      <td>Thời gian đình chỉ quyền truy cập mặc định cho các vi phạm bảo mật SHALL là 30 phút kể từ lần cuối.</td>
    </tr>
    <tr>
      <td><b>BR-03</b></td>
      <td>Security</td>
      <td>The system SHALL provide a generic error message for failed authentication to prevent information harvesting.</td>
      <td>Hệ thống SHALL cung cấp thông báo lỗi chung cho xác thực thất bại để ngăn chặn việc dò quét thông tin.</td>
    </tr>
    <tr>
      <td><b>BR-04</b></td>
      <td>Security</td>
      <td>For password recovery requests, the system SHALL return a generic hypothetical message regardless of whether the identity exists or not.</td>
      <td>Đối với yêu cầu khôi phục mật khẩu, hệ thống SHALL trả về thông báo giả định chung bất kể định danh tồn tại hay không.</td>
    </tr>
    <tr>
      <td><b>BR-05</b></td>
      <td>Authentication</td>
      <td>Automatic access restoration SHALL only apply to accounts suspended due to incorrect credential attempts.</td>
      <td>Việc tự động khôi phục quyền truy cập SHALL chỉ áp dụng cho tài khoản bị đình chỉ do sai sót thông tin xác thực.</td>
    </tr>
    <tr>
      <td><b>BR-06</b></td>
      <td>Authentication</td>
      <td>Accounts suspended due to administrative violations or unpaid fines SHALL NOT be automatically restored over time.</td>
      <td>Tài khoản bị đình chỉ do vi phạm hành chính hoặc nợ phạt SHALL KHÔNG được tự động khôi phục theo thời gian.</td>
    </tr>
    <tr>
      <td><b>BR-07</b></td>
      <td>Security</td>
      <td>Automatically generated temporary credentials (on forgot password) SHALL consist of exactly 8 random characters.</td>
      <td>Thông tin xác thực tạm thời được cấp tự động (khi quên mật khẩu) SHALL bao gồm đúng 8 ký tự ngẫu nhiên.</td>
    </tr>
    <tr>
      <td><b>BR-08</b></td>
      <td>Data Integrity</td>
      <td>Updating personal profiles MUST NOT modify system identifier fields (e.g., student/staff code, role, status).</td>
      <td>Cập nhật hồ sơ cá nhân KHÔNG ĐƯỢC PHÉP thay đổi các trường định danh hệ thống (mã số, vai trò, trạng thái).</td>
    </tr>
    <tr>
      <td><b>BR-09</b></td>
      <td>Security</td>
      <td>New passwords MUST meet security strength requirements.</td>
      <td>Mật khẩu mới BẮT BUỘC đáp ứng tiêu chuẩn bảo mật.</td>
    </tr>
    <tr>
      <td><b>BR-10</b></td>
      <td>Data Validation</td>
      <td>Identity data including Email and unique code (Student Code, Lecturer Code...) MUST be unique system-wide.</td>
      <td>Dữ liệu định danh gồm Email và Mã số (MSSV, MSGV...) BẮT BUỘC là duy nhất trên toàn hệ thống.</td>
    </tr>
    <tr>
      <td><b>BR-11</b></td>
      <td>Transaction</td>
      <td>Bulk account import process MUST strictly adhere to the "All-or-Nothing" transaction strategy.</td>
      <td>Quy trình nhập danh sách tài khoản khối lượng lớn BẮT BUỘC tuân thủ chiến lược "Thành công toàn bộ hoặc Hủy bỏ toàn bộ".</td>
    </tr>
    <tr>
      <td><b>BR-12</b></td>
      <td>Provisioning</td>
      <td>Newly provisioned user accounts MUST use their registered Email as the default initial password.</td>
      <td>Tài khoản khi khởi tạo BẮT BUỘC dùng Email làm mật khẩu mặc định.</td>
    </tr>
    <tr>
      <td><b>BR-13</b></td>
      <td>Role Assignment</td>
      <td>Bulk import Excel files MUST NOT contain role assignment definitions. Admins MUST configure the role globally via UI prior to import.</td>
      <td>File Excel dùng để Import khối lượng lớn KHÔNG ĐƯỢC chứa định nghĩa phân quyền. Quản trị viên BẮT BUỘC phải cấu hình Role chung từ giao diện trước khi thực thi tải tệp.</td>
    </tr>
    <tr>
      <td><b>BR-14</b></td>
      <td>Mandatory Audit</td>
      <td>All administrative actions modifying account data (Add, Edit, Lock, Unlock, Import) MUST be recorded in AuditLogs.</td>
      <td>Mọi thao tác làm thay đổi dữ liệu tài khoản (Thêm, Sửa, Khóa, Mở khóa, Import) từ Quản trị viên BẮT BUỘC phải được lưu vết vào hệ thống Audit Log.</td>
    </tr>
    <tr>
      <td><b>BR-15</b></td>
      <td>UPSERT Mechanism</td>
      <td>User profile updates MUST utilize an UPSERT mechanism to prevent data corruption for accounts missing initial profile records.</td>
      <td>Tiến trình cập nhật hồ sơ cá nhân của người dùng BẮT BUỘC sử dụng cơ chế UPSERT (Cập nhật hoặc Chèn mới) để đảm bảo không đứt gãy dữ liệu đối với các tài khoản chưa có profile gốc.</td>
    </tr>
    <tr>
      <td><b>BR-16</b></td>
      <td>Uniqueness of Identifiers</td>
      <td>Book identifiers including ISBN (Book table) and Barcode (BookCopy table) MUST be unique system-wide.</td>
      <td>Định danh sách gồm ISBN (Bảng Book) và Barcode (Bảng BookCopy) BẮT BUỘC phải là duy nhất trên toàn hệ thống.</td>
    </tr>
    <tr>
      <td><b>BR-17</b></td>
      <td>Inventory Synchronization</td>
      <td>The totalQuantity and availableQuantity fields in Book table MUST automatically synchronize with BookCopy inventory counts.</td>
      <td>Số lượng totalQuantity và availableQuantity của bảng Book BẮT BUỘC đồng bộ với BookCopy. Khi thêm bản sao: cộng 1 vào cả hai. Khi cập nhật Condition sang hỏng/mất: trừ availableQuantity.</td>
    </tr>
    <tr>
      <td><b>BR-18</b></td>
      <td>Immutable Core Identifiers</td>
      <td>Core system identifiers (ISBN, Barcode) MUST NOT be modified once assigned to physical inventory.</td>
      <td>KHÔNG ĐƯỢC PHÉP thay đổi thông tin định danh hệ thống (ISBN, Barcode) sau khi bản ghi sách hoặc bản sao đã được lưu thành công.</td>
    </tr>
    <tr>
      <td><b>BR-19</b></td>
      <td>Reservation Eligibility</td>
      <td>Readers MUST only be eligible to Reserve or Renew books if they have zero overdue loans and zero pending unpaid fines.</td>
      <td>Độc giả BẮT BUỘC chỉ được phép thực hiện Đặt trước hoặc Gia hạn trực tuyến nếu tài khoản đang ở trạng thái hoạt động (status = 'active') VÀ không bị khóa vì bất kỳ lý do nợ phạt nào.</td>
    </tr>
    <tr>
      <td><b>BR-20</b></td>
      <td>Queue Positioning Strategy</td>
      <td>The queuePosition = 0 in Reservation table is strictly reserved for physical copies undergoing desk pick-up hold.</td>
      <td>Vị trí hàng đợi queuePosition = 0 DÀNH RIÊNG cho việc giữ sách đã sẵn sàng lấy (status = 'readypickup'). Mọi yêu cầu chờ sách (khi availableQuantity = 0) BẮT BUỘC phải có queuePosition > 0 và trạng thái 'pending'.</td>
    </tr>
    <tr>
      <td><b>BR-21</b></td>
      <td>Renewal Constraints</td>
      <td>Loan renewals MUST only be allowed if renewal limit is not exceeded AND no pending reservations exist for the book title.</td>
      <td>Giao dịch mượn (BorrowRecord) chỉ được phép gia hạn nếu thỏa mãn ĐỒNG THỜI 3 điều kiện: (1) Thời gian mượn đã qua % quy định, (2) extensionCount chưa vượt mức tối đa trong SystemConfigurations, (3) KHÔNG có bất kỳ Reservation nào có queuePosition > 0 đang chờ cho cùng tựa sách đó.</td>
    </tr>
    <tr>
      <td><b>BR-22</b></td>
      <td>Strict Fine Enforcement</td>
      <td>The system MUST strictly block new book check-outs if the reader has any overdue loans or unpaid fines.</td>
      <td>Hệ thống BẮT BUỘC chặn giao dịch mượn sách nếu tồn tại bất kỳ bản ghi nào có reason = 'unpaid' trong bảng UserLockReason của người dùng. KHÔNG trực tiếp kiểm tra bảng Fine để quyết định chặn giao dịch nhằm giữ tính độc lập dữ liệu.</td>
    </tr>
    <tr>
      <td><b>BR-23</b></td>
      <td>Direct Borrow Queue Policy</td>
      <td>Walk-in readers at circulation desk MUST NOT check out a book title if all available copies are reserved by other readers.</td>
      <td>Độc giả mượn sách trực tiếp tại quầy KHÔNG ĐƯỢC PHÉP mượn đầu sách đang có người xếp hàng chờ (tồn tại Reservation với status='pending' VÀ queuePosition > 0). Để chuẩn hóa dữ liệu, mọi giao dịch mượn trực tiếp đều BẮT BUỘC phải tự động sinh ra một Reservation ảo với queuePosition = 0 tại chỗ trước khi insert BorrowRecord.</td>
    </tr>
    <tr>
      <td><b>BR-24</b></td>
      <td>Damaged/Lost Inventory Deduction</td>
      <td>When receiving returned books marked as damaged or lost, the system MUST deduct inventory and record a BookCopyIncident.</td>
      <td>Khi nhận sách trả với tình trạng 'damaged' hoặc 'lost', hệ thống BẮT BUỘC trừ 1 đơn vị vào Book.totalQuantity (vì sách không còn khả năng lưu thông). ĐỒNG THỜI, BẮT BUỘC phải insert tức thời bản ghi 'unpaid' vào UserLockReason và đổi status User thành 'locked' mà không chờ Background Job chạy ngầm, tránh lỗ hổng bảo mật.</td>
    </tr>
    <tr>
      <td><b>BR-25</b></td>
      <td>Conditional Auto-Unlock</td>
      <td>Upon full payment of fine balance, the system MUST automatically restore reader borrowing privileges.</td>
      <td>Sau khi thanh toán tiền phạt (xóa reason 'unpaid'), hệ thống BẮT BUỘC đếm số lượng lý do khóa còn lại trong UserLockReason. CHỈ KHỞI ĐỘNG quy trình mở khóa (Update User.status = 'active') NẾU COUNT == 0. Tuyệt đối không mở khóa nếu tài khoản đang bị 'adminban' hoặc 'securitybreach'.</td>
    </tr>
    <tr>
      <td><b>BR-26</b></td>
      <td>Google SSO Registration Policy</td>
      <td>Google SSO authentication MUST NOT automatically create new accounts for unauthorized email domains.</td>
      <td>Tính năng Google SSO KHÔNG ĐƯỢC PHÉP tự động tạo tài khoản mới. Hệ thống BẮT BUỘC trả về lỗi nếu email Google chưa được Admin cấp phát trước.</td>
    </tr>
    <tr>
      <td><b>BR-27</b></td>
      <td>Book Import Transaction</td>
      <td>Bulk book import process MUST execute within an atomic transaction with line-by-line validation logging.</td>
      <td>Tính năng Import khối lượng lớn Sách BẮT BUỘC tuân thủ chiến lược All-or-Nothing. Tệp dữ liệu chỉ được lưu vào DB khi toàn bộ thông tin Sách và Bản sao đều hợp lệ.</td>
    </tr>
    <tr>
      <td><b>BR-28</b></td>
      <td>Incident Resolution Sync</td>
      <td>Incident reports on physical copies MUST automatically synchronize BookCopy status to Damaged, Lost, or Maintenance.</td>
      <td>Khi ghi nhận báo cáo sự cố (Report Incident), hệ thống BẮT BUỘC phải tức thời vô hiệu hóa bản sao (status='unavailable') và trừ đi 1 availableQuantity của Đầu sách tương ứng. Khi bác bỏ (Reject Incident), phải cộng lại availableQuantity.</td>
    </tr>
    <tr>
      <td><b>BR-29</b></td>
      <td>Walk-in vs Pre-reservation Checkout Policy</td>
      <td>Desk check-out operations MUST verify reservation queue positions before issuing reserved physical copies.</td>
      <td>Khi thực hiện Giao sách (Check-out) tại quầy, hệ thống BẮT BUỘC phân biệt trạng thái bản sao sách: Walk-in checkout chỉ chấp nhận BookCopy ở trạng thái 'available' và phải trừ availableQuantity của đầu sách đi 1; Pre-reservation checkout chỉ chấp nhận BookCopy ở trạng thái 'reserved' và KHÔNG được trừ availableQuantity (vì đã trừ khi đặt trước online).</td>
    </tr>
    <tr>
      <td><b>BR-30</b></td>
      <td>System Config Immutability</td>
      <td>System configuration parameters (configKey) MUST NOT be hard-deleted via the management UI.</td>
      <td>Cấm tuyệt đối việc xóa cấu hình (delete configKey) thông qua UI hoặc hệ thống dưới mọi hình thức. Hệ thống chỉ cho phép cập nhật (UPDATE) giá trị configValue của các key đã tồn tại, hoặc thêm mới (INSERT) đối với các key thuộc whitelist (KEY_TYPES) chưa tồn tại trong CSDL.</td>
    </tr>
    <tr>
      <td><b>BR-31</b></td>
      <td>System Config Authorization</td>
      <td>Library Managers MUST only view and update system configurations belonging to their authorized configGroup.</td>
      <td>Library Manager chỉ được phép xem và cập nhật các config thuộc nhóm 'library' hoặc cấu hình tích hợp SePay. Admin có toàn quyền với mọi nhóm config.</td>
    </tr>
    <tr>
      <td><b>BR-32</b></td>
      <td>Audit Log Read-Only</td>
      <td>The Audit Log module MUST be strictly read-only; no manual Insert, Update, or Delete operations are permitted.</td>
      <td>Tính năng Nhật ký Kiểm toán (F12) KHÔNG ĐƯỢC PHÉP Insert, Update hoặc Delete dữ liệu trong bất kỳ bảng nào. Chỉ được thực hiện SELECT.</td>
    </tr>
    <tr>
      <td><b>BR-33</b></td>
      <td>Audit Log JSON Format</td>
      <td>All oldValues and newValues in AuditLogs MUST be formatted as valid JSON strings for auditability.</td>
      <td>Tất cả oldValues và newValues trong bảng AuditLogs BẮT BUỘC được ghi ở dạng JSON hợp lệ (hoặc NULL). KHÔNG sử dụng plain text để đảm bảo giao diện hiển thị nhất quán.</td>
    </tr>
    <tr>
      <td><b>BR-34</b></td>
      <td>Audit Log Pagination</td>
      <td>Audit Log data tables MUST be paginated with a maximum default limit of 20 records per page.</td>
      <td>Danh sách Nhật ký Kiểm toán BẮT BUỘC phải phân trang (20 bản ghi/trang) để bảo vệ hiệu năng hệ thống. KHÔNG ĐƯỢC PHÉP tải toàn bộ dữ liệu trong một request.</td>
    </tr>
    <tr>
      <td><b>BR-35</b></td>
      <td>Overdue Policy</td>
      <td>Active loans exceeding their endDate MUST automatically be flagged as Overdue and incur daily fine calculations.</td>
      <td>Giao dịch mượn (BorrowRecord) ở trạng thái 'borrowed' có endDate nhỏ hơn thời điểm quét phải được coi là quá hạn. Hệ thống SHALL phạt 5,000 VND (hoặc theo cấu hình FINE_RATE_PER_DAY) cho mỗi ngày trễ hạn và khóa tài khoản độc giả cho tới khi thanh toán xong.</td>
    </tr>
    <tr>
      <td><b>BR-36</b></td>
      <td>Reservation Pickup Limit</td>
      <td>Hold reservations ready for pickup MUST expire after a configurable timeframe (default 3 days) if not collected.</td>
      <td>Đơn đặt trước ở trạng thái 'readypickup' chỉ được giữ tại quầy trong một khoảng thời gian giới hạn được xác định bởi cấu hình RESERVATION_HOLD_DAYS trong bảng SystemConfigurations (mặc định là 3 ngày). Nếu quá thời hạn này (endDate < NOW()), đơn hàng sẽ tự động bị hủy và giải phóng bản sao sách.</td>
    </tr>
    <tr>
      <td><b>BR-37</b></td>
      <td>AI Chatbot Access Control</td>
      <td>The AI Chatbot interface SHALL be publicly accessible to both Guests and authenticated Users.</td>
      <td>Tính năng AI Chatbot SHALL được public cho cả Guest và User đã đăng nhập. Chatbot SHALL chỉ trả lời các câu hỏi liên quan đến nội quy thư viện, chính sách mượn trả, và tra cứu thông tin sách. Chatbot MUST NOT trả lời các yêu cầu thực hiện giao dịch (mượn, trả, thanh toán) thay người dùng.</td>
    </tr>
    <tr>
      <td><b>BR-38</b></td>
      <td>Dashboard Data Isolation</td>
      <td>Role dashboards MUST isolate data access scope according to the logged-in user role permissions.</td>
      <td>Mỗi Dashboard (Admin/Manager/Librarian/Student/Lecturer) BẮT BUỘC chỉ hiển thị dữ liệu và chỉ số phù hợp với role của người dùng. Dashboard KHÔNG ĐƯỢC PHÉP truy xuất hoặc hiển thị dữ liệu ngoài phạm vi quyền hạn của role.</td>
    </tr>
    <tr>
      <td><b>BR-39</b></td>
      <td>Session Management</td>
      <td>HTTP session management MUST continuously validate account status against the database on each request.</td>
      <td>Hệ thống BẮT BUỘC kiểm tra trạng thái tài khoản từ database cho mỗi request (ngoại trừ static resources). Nếu tài khoản bị xóa hoặc status thay đổi thành 'locked', session BẮT BUỘC phải bị invalidate ngay lập tức và redirect về trang login.</td>
    </tr>
    <tr>
      <td><b>BR-40</b></td>
      <td>SePay Whitelist Modification</td>
      <td>Payment gateway configurations MUST only permit modifications to whitelisted SEPAY_ and VNPAY_ config keys.</td>
      <td>Cập nhật cấu hình hệ thống chỉ được áp dụng với các key cấu hình nằm trong whitelist (KEY_TYPES) định nghĩa sẵn trong mã nguồn. Mọi thao tác cập nhật phải được kiểm tra kiểu dữ liệu (số nguyên dương, số nguyên không âm, số thực không âm) trước khi lưu DB.</td>
    </tr>
    <tr>
      <td><b>BR-41</b></td>
      <td>Desk Reservation Rules</td>
      <td>Desk reservation holds registered by Librarians MUST respect standard queue positioning and user quota rules.</td>
      <td>Khi Thủ thư đăng ký đặt trước tại quầy thay cho độc giả (UC-51), hệ thống BẮT BUỘC phải tuân thủ đầy đủ các giới hạn về chặn nợ phạt (BR-22) và hạn mức mượn sách (BR-19, BR-21).</td>
    </tr>
    <tr>
      <td><b>BR-42</b></td>
      <td>Graceful Shutdown Email Queue</td>
      <td>During application shutdown, background email workers MUST gracefully complete queued tasks before termination.</td>
      <td>Khi ứng dụng shutdown, hệ thống PHẢI dừng tiếp nhận email mới vào hàng đợi, chờ tối đa 5 giây để gửi nốt các email còn tồn đọng trong queue rồi mới ngắt luồng Consumer.</td>
    </tr>
    <tr>
      <td><b>BR-43</b></td>
      <td>System Report Integrity</td>
      <td>System financial reports MUST display both collected cash revenue and pending fine receivables concurrently.</td>
      <td>Dữ liệu thống kê tài chính BẮT BUỘC hiển thị song song cả 2 chiều: tiền phạt đã thu (paid) và tiền phạt chưa thu (unpaid) để phục vụ đối chiếu minh bạch.</td>
    </tr>
    <tr>
      <td><b>BR-44</b></td>
      <td>System Report Inventory Reconciliation</td>
      <td>Inventory management reports MUST reconcile physical copy counts against active loan and reservation logs.</td>
      <td>Dữ liệu kho sách hiển thị trong báo cáo quản lý bắt buộc phải đối chiếu dựa trên dữ liệu từ đợt kiểm kê gần nhất.</td>
    </tr>
    <tr>
      <td><b>BR-45</b></td>
      <td>System Report Granularity</td>
      <td>System analytics reports MUST support flexible grouping by daily, weekly, monthly, and yearly granularities.</td>
      <td>Hệ thống phải cung cấp dữ liệu báo cáo phân nhóm linh hoạt theo Ngày, Tháng, Năm để hỗ trợ phân tích chiều hướng phát triển (tăng/giảm) của thư viện.</td>
    </tr>
    <tr>
      <td><b>BR-46</b></td>
      <td>Email SMTP Configurations</td>
      <td>SMTP email configurations (Host, Port, Username, Password) MUST be securely stored in SystemConfigurations.</td>
      <td>Các tham số cấu hình SMTP (Host, Port, Username, Password) BẮT BUỘC phải được đọc trực tiếp từ bảng SystemConfigurations.</td>
    </tr>
    <tr>
      <td><b>BR-47</b></td>
      <td>Email Template Protection</td>
      <td>Core email document templates MUST be protected against accidental deletion by management staff.</td>
      <td>Các mẫu email hệ thống (RESET_PASSWORD, RESERVATION_READY, RENEWAL_CONFIRMATION, OVERDUE_NOTICE, INCIDENT_FINE_NOTICE, PAYMENT_CONFIRMATION) cấm tuyệt đối xóa khỏi hệ thống.</td>
    </tr>
    <tr>
      <td><b>BR-48</b></td>
      <td>Email Worker Error Recovery</td>
      <td>Background email dispatch workers MUST implement retry and error recovery mechanisms without crashing the consumer thread.</td>
      <td>Lỗi kết nối SMTP không được phép làm crash thread Consumer; hệ thống phải tự động retry tối đa số lần cấu hình (EMAIL_MAX_RETRIES) trước khi bỏ qua job.</td>
    </tr>
    <tr>
      <td><b>BR-49</b></td>
      <td>Email Job Queue Limits</td>
      <td>Async email job queues MUST enforce maximum capacity limits to prevent memory overflow during email spikes.</td>
      <td>Hàng đợi email bất đồng bộ BẮT BUỘC giới hạn dung lượng tối đa (EMAIL_QUEUE_CAPACITY). Khi hàng đợi đầy, hệ thống SHALL ghi log cảnh báo và bỏ qua (drop) email mới nhất để bảo vệ tính ổn định hệ thống.</td>
    </tr>
    <tr>
      <td><b>BR-50</b></td>
      <td>Email Temp Password Exclusion</td>
      <td>Email dispatch logs MUST NEVER record or display temporary plain-text passwords in application logs.</td>
      <td>Tiến trình ngầm gửi mail TUYỆT ĐỐI KHÔNG ĐƯỢC log mật khẩu tạm thời (tempPassword) dưới dạng thô nhằm đảm bảo an toàn bảo mật.</td>
    </tr>
    <tr>
      <td><b>BR-51</b></td>
      <td>Email Template Rendering</td>
      <td>Email templates support Markdown formatting and MUST be rendered into clean HTML before dispatch.</td>
      <td>Hệ thống hỗ trợ định dạng Markdown và render ra HTML trước khi gửi đi. Placeholders trong email template phải ở định dạng `{{key}}`.</td>
    </tr>
    <tr>
      <td><b>BR-52</b></td>
      <td>Librarian Performance Isolation</td>
      <td>Staff performance reports MUST strictly isolate and credit metrics to the staff member who processed the transaction.</td>
      <td>Báo cáo hiệu suất nhân viên chỉ thống kê các giao dịch được thực hiện bởi các tài khoản có vai trò là LIBRARIAN.</td>
    </tr>
    <tr>
      <td><b>BR-53</b></td>
      <td>Payment Config Group Access</td>
      <td>Payment gateway configuration access MUST be restricted to users possessing LibraryManager role permissions.</td>
      <td>Library Manager chỉ có quyền xem và sửa các cấu hình có prefix `SEPAY_`. Việc phân quyền sửa cấu hình SePay được kiểm soát nghiêm ngặt ở tầng Service.</td>
    </tr>
    <tr>
      <td><b>BR-54</b></td>
      <td>User List Pagination</td>
      <td>User account management tables MUST support pagination with configurable page sizes (default 10 or 20 records).</td>
      <td>Tính năng xem danh sách tài khoản BẮT BUỘC phải phân trang và hỗ trợ bộ lọc (Filter) theo Role/Status để chống tràn bộ nhớ.</td>
    </tr>
    <tr>
      <td><b>BR-55</b></td>
      <td>Self-Lock Prevention</td>
      <td>Admin accounts MUST NOT be permitted to perform self-locking or self-deletion actions via the UI.</td>
      <td>Quản trị viên (Admin) KHÔNG ĐƯỢC PHÉP thực hiện thao tác Khóa (Lock), Xóa (Delete), hoặc thay đổi Role trên chính tài khoản mà họ đang đăng nhập để tránh tình trạng hệ thống bị vô chủ (orphaned system).</td>
    </tr>
    <tr>
      <td><b>BR-56</b></td>
      <td>Book Suggestion Vote Uniqueness</td>
      <td>Each Student or Lecturer SHALL be restricted to casting a maximum of 1 upvote per book suggestion.</td>
      <td>Mỗi Giảng viên SHALL chỉ được vote tối đa 1 lần cho mỗi đề xuất sách. Hệ thống BẮT BUỘC kiểm tra tính duy nhất trước khi ghi nhận vote.</td>
    </tr>
    <tr>
      <td><b>BR-57</b></td>
      <td>Book Suggestion Vote Restriction</td>
      <td>Upvoting (+1) and downvoting book suggestions SHALL only be permitted when the suggestion status is Pending.</td>
      <td>Tính năng vote (+1) và hủy vote CHỈ ĐƯỢC PHÉP thực hiện khi đề xuất sách còn ở trạng thái 'pending'. Khi status = 'acknowledged' hoặc 'rejected', hệ thống MUST NOT cho phép vote mới hoặc hủy vote.</td>
    </tr>
    <tr>
      <td><b>BR-58</b></td>
      <td>Book Suggestion Edit/Delete Restriction</td>
      <td>Users SHALL only be allowed to edit or delete book suggestions if they are the author AND status is Pending AND voteCount = 1.</td>
      <td>Giảng viên CHỈ ĐƯỢC PHÉP sửa hoặc xóa (soft-delete) đề xuất sách của chính mình KHI VÀ CHỈ KHI status = 'pending' VÀ voteCount = 1 (chỉ có vote của chính mình). Nếu có người khác đã vote hoặc trạng thái đã thay đổi, hệ thống MUST NOT cho phép sửa/xóa.</td>
    </tr>
  </tbody>
</table>

---
