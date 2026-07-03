# .sdd/shared_context.md
# File này là NGUỒN SỰ THẬT CHUNG (Source of Truth) cho toàn bộ AI Agents & Developers
# Version: 1.3.0 (Cập nhật theo thực tế code PostgreSQL/Supabase)
# Cập nhật bởi: Lead Architect AI Agent | Ngày: 2026-07-03


---

## 1. ACTOR TO USE CASE MAPPING (Ánh xạ Tác nhân và Ca sử dụng)

| Actor (Tác nhân) | Use Cases được phép thực thi |
| :--- | :--- |
| **Guest (Khách)** | UC01, UC05, UC06 |
| **Student (Sinh viên)** | UC01, UC02, UC03, UC04, UC05, UC06, UC07, UC08, UC09, UC10, UC11, UC12 |
| **Lecturer (Giảng viên)** | UC01, UC02, UC03, UC04, UC05, UC06, UC07, UC08, UC09, UC10, UC11, UC12 |
| **Librarian (Thủ thư)** | UC01, UC02, UC13, UC14, UC15, UC16, UC17, UC18 |
| **Library Manager (Quản lý)** | UC01, UC02, UC19, UC20 |
| **SysAdmin (Quản trị viên)** | UC01, UC02, UC21, UC22, UC23 |

---

## 2. USE CASES REGISTRY (Danh sách 23 Use Cases chính thức)

| Mã UC | Tác nhân (Actor) | Tên Use Case | Mô tả Luồng Nghiệp Vụ (Business Flow) |
| :--- | :--- | :--- | :--- |
| **UC01** | Guest, All Users | Đăng nhập hệ thống | Người dùng nhập thông tin xác thực để truy cập vào các tính năng dành riêng cho thành viên. |
| **UC02** | All Users | Đăng xuất tài khoản | Người dùng chủ động kết thúc phiên làm việc để bảo vệ thông tin cá nhân. |
| **UC03** | Student, Lecturer | Xem hồ sơ cá nhân | Người dùng truy cập để xem các thông tin cá nhân và vai trò hiện tại của mình trong thư viện. |
| **UC04** | Student, Lecturer | Cập nhật hồ sơ | Người dùng thay đổi các thông tin liên lạc được phép (ví dụ: số điện thoại). |
| **UC05** | Student, Lecturer | Tìm kiếm Đầu sách | Người dùng nhập từ khóa để tìm các tựa sách, tác giả hoặc chủ đề mình quan tâm. |
| **UC06** | Student, Lecturer | Xem trạng thái Kho sách | Người dùng xem chi tiết một tựa sách để biết hiện thư viện còn bao nhiêu cuốn vật lý có thể mượn. |
| **UC07** | Student, Lecturer | Nhận gợi ý sách (AI) | Người dùng tương tác với hệ thống AI để nhận các đề xuất sách dựa trên lịch sử đọc của mình. |
| **UC08** | Student, Lecturer | Yêu cầu Gia hạn | Người dùng chủ động xin kéo dài thời gian mượn đối với cuốn sách đang giữ. |
| **UC09** | Student, Lecturer | Ghi danh Đặt trước | Người dùng đăng ký xếp hàng chờ mượn một tựa sách hiện đang hết bản sao vật lý. |
| **UC10** | Student, Lecturer | Hủy Đặt trước chủ động | Người dùng tự rút tên khỏi danh sách hàng chờ nếu không còn nhu cầu mượn tựa sách đó nữa. |
| **UC11** | Student, Lecturer | Tra cứu nợ phạt | Người dùng xem danh sách các khoản phạt quá hạn hoặc đền bù tài sản chưa thanh toán. |
| **UC12** | Student, Lecturer | Thanh toán VNPAY | Người dùng thực hiện trả tiền phạt thông qua cổng thanh toán trực tuyến. |
| **UC13** | Librarian | Quét mã Mượn sách | Thủ thư ghi nhận việc giao một cuốn sách vật lý cho người dùng mang ra khỏi thư viện. |
| **UC14** | Librarian | Quét mã Trả sách | Thủ thư ghi nhận việc thu hồi lại một cuốn sách vật lý từ tay người dùng. |
| **UC15** | Librarian | Quản lý thông tin Đầu sách | Thủ thư khởi tạo hoặc chỉnh sửa thông tin trừu tượng của một tựa sách (Tên, Tác giả, Nhà xuất bản). |
| **UC16** | Librarian | Quản lý Phân loại sách | Thủ thư thêm hoặc sửa các danh mục (Category) và thẻ (Tag) để tổ chức hệ thống tra cứu. |
| **UC17** | Librarian | Khai báo Bản sao vật lý | Thủ thư thêm mới từng cuốn sách thực tế vào kho và sinh mã vạch (Barcode) tương ứng. |
| **UC18** | Librarian | Cập nhật Hao mòn tài sản | Thủ thư ghi nhận tình trạng vật lý (rách, hỏng, mất) của một cuốn sách cụ thể sau khi kiểm tra. |
| **UC19** | Library Manager | Đăng Thông báo chung | Quản lý thư viện phát đi các thông báo về lịch hoạt động hoặc chính sách mới trên bảng tin hệ thống. |
| **UC20** | Library Manager | Cấu hình Quy tắc Thư viện | Quản lý thư viện thay đổi các con số luật lệ (số ngày mượn, giá tiền phạt) áp dụng cho hệ thống. |
| **UC21** | SysAdmin | Quản trị Danh sách User | Quản trị viên hệ thống tra cứu và xem chi tiết thông tin toàn bộ tài khoản đang hoạt động. |
| **UC22** | SysAdmin | Xử lý Vi phạm thủ công | Quản trị viên trực tiếp thực hiện lệnh khóa hoặc mở khóa một tài khoản cụ thể. |
| **UC23** | SysAdmin | Tra cứu Nhật ký (Audit) | Quản trị viên xem lại lịch sử các thao tác thay đổi dữ liệu quan trọng để truy vết sự cố. |

---

## 3. FUNCTIONAL REQUIREMENTS REGISTRY (Danh sách 33 Yêu cầu Chức năng)

| Mã FR | Tên Chức Năng | Mô tả chi tiết hành vi hệ thống (System Behavior) |
| :--- | :--- | :--- |
| **FR01** | Đăng nhập hệ thống | Hệ thống cho phép người dùng xác thực bằng Email và Mật khẩu. |
| **FR02** | Xử lý đăng nhập sai | *(Hệ thống tự động)*: Nếu phát hiện đăng nhập sai quá số lần quy định, hệ thống tự động khóa tài khoản tạm thời. |
| **FR03** | Đăng xuất | Hệ thống xóa phiên làm việc hiện tại, đưa người dùng về trạng thái chưa xác thực. |
| **FR04** | Xem hồ sơ cá nhân | Hệ thống hiển thị thông tin người dùng. Giao diện tự động thay đổi các trường dữ liệu tùy thuộc người dùng là Sinh viên hay Giảng viên. |
| **FR05** | Cập nhật hồ sơ | Hệ thống cho phép người dùng chỉnh sửa các thông tin cá nhân được phép thay đổi (ví dụ: số điện thoại). |
| **FR06** | Tìm kiếm Đầu sách | Hệ thống trả về danh sách các tựa sách dựa trên từ khóa tìm kiếm (tiêu đề, tác giả, danh mục, thẻ). |
| **FR07** | Xem trạng thái Kho | Hệ thống hiển thị số lượng bản sao sách vật lý hiện đang có sẵn để mượn đối với một tựa sách cụ thể. |
| **FR08** | Gợi ý Sách (AI) | Hệ thống sử dụng AI phân tích lịch sử để đưa ra danh sách các tựa sách đề xuất cá nhân hóa. |
| **FR09** | Ghi nhận Mượn Sách | Hệ thống ghi nhận việc mượn một cuốn sách vật lý thông qua mã vạch, đánh dấu cuốn sách đó đang được mượn. |
| **FR10** | Tính hạn trả sách | *(Hệ thống tự động)*: Khi giao dịch mượn thành công, hệ thống tự động tính toán và lưu ngày phải trả dựa trên vai trò của người mượn. |
| **FR11** | Yêu cầu Gia hạn | Hệ thống tiếp nhận yêu cầu kéo dài thời gian mượn sách từ người dùng và tính toán ngày trả mới. |
| **FR12** | Chặn Gia hạn | *(Hệ thống tự động)*: Hệ thống từ chối gia hạn nếu cuốn sách đang có người xếp hàng đặt trước hoặc người dùng đã hết lượt gia hạn. |
| **FR13** | Ghi danh Đặt trước | Hệ thống ghi nhận người dùng vào hàng chờ của một tựa sách đã hết và cấp số thứ tự chờ. Hệ thống sẽ tự động chặn và từ chối yêu cầu nếu tổng số lượng sách đang mượn và đang đặt trước của người dùng đã đạt hạn mức tối đa. |
| **FR14** | Hủy Đặt trước chủ động | Hệ thống cho phép người dùng tự xóa tên mình khỏi hàng chờ nếu không còn nhu cầu. |
| **FR15** | Hiển thị Cảnh báo | *(Giao diện động)*: Hệ thống tính toán realtime và hiển thị cảnh báo trực quan trên màn hình khi người dùng có sách sắp đến hạn, quá hạn hoặc có nợ phạt (Không lưu database). |
| **FR16** | Khởi tạo Thanh toán | Hệ thống đóng gói thông tin khoản phạt và điều hướng người dùng sang cổng thanh toán VNPAY. |
| **FR17** | Xử lý Kết quả VNPAY | *(Hệ thống tự động)*: Hệ thống nhận phản hồi từ VNPAY để ghi nhận trạng thái giao dịch và xóa nợ cho người dùng nếu thành công. |
| **FR18** | Quản lý Đầu sách | Thủ thư thực hiện thêm, sửa, xóa thông tin trừu tượng của các tựa sách (Tên, Tác giả, Nhà XB). |
| **FR19** | Quản lý Phân loại | Thủ thư thực hiện thêm, sửa, xóa các Danh mục (Category) và Thẻ (Tag). |
| **FR20** | Quản lý Mã vạch | Thủ thư thêm mới và sinh mã vạch cho từng cuốn sách vật lý nhập kho. |
| **FR21** | Cập nhật Hao mòn | Thủ thư ghi nhận lại tình trạng vật lý thực tế của sách (còn tốt, rách, mất). |
| **FR22** | Quét mã Trả sách | Hệ thống ghi nhận trả sách và bắt buộc thủ thư xác nhận tình trạng vật lý của cuốn sách. Sách chỉ được chuyển về trạng thái sẵn sàng hoặc phân bổ cho hàng chờ nếu tình trạng là bình thường. |
| **FR23** | Phân bổ Hàng chờ | *(Hệ thống tự động)*: Ngay khi sách được trả, hệ thống kiểm tra và tự động giữ cuốn sách đó cho người đứng đầu tiên trong hàng chờ (nếu có). |
| **FR24** | Quản lý Thông báo | Quản lý thư viện đăng tải các thông báo chung (Lễ, Tết), hiển thị trên bảng tin của toàn bộ người dùng. |
| **FR25** | Cấu hình Chính sách | Quản lý thư viện thay đổi các quy tắc hệ thống (số ngày mượn, tiền phạt). |
| **FR26** | Quản lý Danh sách User | Quản trị viên xem danh sách và thông tin chi tiết của người dùng. |
| **FR27** | Xử lý Vi phạm thủ công | Quản trị viên thực hiện khóa hoặc mở khóa tài khoản người dùng bằng tay khi có sự cố. |
| **FR28** | Xem Nhật ký Audit | Quản trị viên xem lịch sử vết của các thao tác thay đổi dữ liệu trong hệ thống. |
| **FR29** | Tính Phạt Trễ hạn | *(Hệ thống chạy ngầm)*: Mỗi đêm, rà soát các giao dịch quá hạn để tự động sinh ra khoản tiền phạt. |
| **FR30** | Dọn dẹp Hàng chờ | *(Hệ thống chạy ngầm)*: Hủy bỏ các phiếu đặt trước đã có sách sẵn sàng nhưng người dùng quá hạn không đến lấy. |
| **FR31** | Gửi Email | *(Hệ thống chạy ngầm)*: Gửi Email thông báo (sắp đến hạn, có sách chờ, bị phạt) đến hộp thư người dùng. |
| **FR32** | Hủy Giao dịch treo | *(Hệ thống chạy ngầm)*: Mỗi 15 phút, hệ thống tự động quét và chuyển trạng thái các yêu cầu thanh toán trực tuyến chưa nhận được phản hồi thành trạng thái hủy bỏ. |
| **FR33** | Chatbot hỗ trợ (AI) | Hệ thống cung cấp giao diện hội thoại (Chatbot), tiếp nhận câu hỏi tự nhiên từ người dùng về quy định thư viện, tìm kiếm sách hoặc hỗ trợ sử dụng. Hệ thống gửi yêu cầu đến AI Service (kèm theo ngữ cảnh nếu cần) và trả về phản hồi văn bản cho người dùng. |

---

## 4. SHARED DEPENDENCIES & ENVIRONMENT (Cơ sở môi trường và thư viện dùng chung)

### 4.1 Cấu hình Cơ sở dữ liệu (PostgreSQL & Supabase)
* **Hệ quản trị CSDL**: PostgreSQL (Supabase / Supavisor)
* **JDBC Driver**: `org.postgresql.Driver` (sử dụng thư viện `postgresql-42.7.3.jar`)
* **JNDI DataSource (Tomcat)**: `java:comp/env/jdbc/LMSDB`
* **Direct JDBC Connection (Fallback/Local)**:
  * URL: `jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:6543/postgres?sslmode=require&prepareThreshold=0&options=-c%20timezone=Asia/Ho_Chi_Minh`
  * Port: `6543` (Supabase Transaction Pooler hỗ trợ IPv4)
* **Ràng buộc SQL**: Tên bảng và tên cột phân biệt hoa/thường. Riêng bảng `"User"` bắt buộc phải bọc trong nháy kép `"User"` ở mọi câu truy vấn.

### 4.2 Tích hợp dịch vụ ngoại vi (External Integrations)
* **Dịch vụ gửi Email (Async Email Infrastructure - F19)**:
  * Gửi email bất đồng bộ sử dụng Java `ExecutorService`.
  * SMTP Host: `smtp.gmail.com` (Port: 587 - TLS).
  * Email gửi hệ thống: `caotuan2k50112@gmail.com` (đọc từ biến môi trường `SMTP_USERNAME`).
  * Tên người gửi hiển thị: `LMS University Library`.
* **Lưu trữ ảnh bìa sách (Book Covers Storage - F4)**:
  * Local Storage (Fallback): `~/.lms/book-images/` (đọc từ biến môi trường `LMS_BOOK_IMAGE_DIR`).
  * Cloud Storage: Supabase Storage Bucket `book-covers` (sử dụng `SupabaseStorageClient` qua HTTP POST API với key `SUPABASE_SERVICE_ROLE_KEY`).
* **Trợ lý AI & Gợi ý sách (AI Chatbot & Recommendation - F8, F14)**:
  * Google Gemini API (sử dụng API Key cấu hình trong bảng `SystemConfigurations` hoặc fallback qua biến môi trường).
  * Hỗ trợ cache cấu hình hệ thống `SystemConfigCache` để giảm tải DB query.
* **Đăng nhập Google SSO (Google Login - F1)**:
  * Tích hợp qua Google OAuth2 (`GoogleSSOUtil.java`).

### 4.3 Quản lý Nhật ký & Bảo mật (PII Masking & Audit)
* **Ghi vết tự động (Audit Log - F12)**: Mọi thao tác CUD quan trọng đều tự động lưu vào bảng `AuditLogs`.
* **Che giấu thông tin nhạy cảm (PII masking pattern)**:
  * Email log format: `use***@domain.com`
  * Phone log format: `091***456`

