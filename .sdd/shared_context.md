# .sdd/shared_context.md
# File này là NGUỒN SỰ THẬT CHUNG (Source of Truth) cho toàn bộ AI Agents & Developers
# Version: 2.0.0 (Đồng bộ với spec-UC-BR-FR.txt v4.0.0)
# Cập nhật bởi: Lead Architect AI Agent | Ngày: 2026-07-05


---

## 1. ACTOR TO USE CASE MAPPING (Ánh xạ Tác nhân và Ca sử dụng)

| Actor (Tác nhân) | Use Cases được phép thực thi |
| :--- | :--- |
| **Guest (Khách)** | UC-01, UC-03, UC-36, UC-47, UC-48 |
| **Student (Sinh viên)** | UC-01→06, UC-16, UC-17, UC-22, UC-23, UC-25, UC-31, UC-38, UC-39, UC-49, UC-50 |
| **Lecturer (Giảng viên)** | UC-01→06, UC-16, UC-17, UC-22, UC-23, UC-25, UC-31, UC-38, UC-39, UC-49, UC-50, UC-55 |
| **Librarian (Thủ thư)** | UC-01, UC-02, UC-04, UC-05, UC-12→15, UC-18, UC-19, UC-20, UC-27, UC-28, UC-29, UC-44, UC-51, UC-52, UC-56 |
| **Library Manager (Quản lý)** | UC-01, UC-02, UC-04, UC-05, UC-24, UC-26, UC-32, UC-33, UC-34, UC-35, UC-45, UC-53, UC-54 |
| **SysAdmin (Quản trị viên)** | UC-01, UC-02, UC-04, UC-05, UC-07→11, UC-30, UC-32, UC-33, UC-34, UC-35, UC-40, UC-41, UC-46 |
| **System (Tự động)** | UC-42, UC-43 |

---

## 2. USE CASES REGISTRY (Danh sách 56 Use Cases — spec-UC-BR-FR.txt v4.0.0)

> Nguồn sự thật chính: `diagram/spec-UC-BR-FR.txt`. Dưới đây là tóm tắt.

| Mã UC | Actor | Tên Use Case |
| :--- | :--- | :--- |
| **UC-01** | Guest, User | Đăng nhập hệ thống |
| **UC-02** | User | Đăng xuất tài khoản |
| **UC-03** | Guest | Quên mật khẩu (Reset Password) |
| **UC-04** | User | Xem hồ sơ cá nhân |
| **UC-05** | User | Cập nhật hồ sơ |
| **UC-06** | User | Thay đổi mật khẩu |
| **UC-07** | Admin | Xem danh sách người dùng |
| **UC-08** | Admin | Xem chi tiết tài khoản |
| **UC-09** | Admin | Cấp tài khoản đơn lẻ |
| **UC-10** | Admin | Nhập tài khoản hàng loạt (Excel) |
| **UC-11** | Admin | Quản trị tài khoản (Sửa/Khóa/Mở khóa) |
| **UC-12** | Librarian | Xem Danh mục & Kho sách |
| **UC-13** | Librarian | Quản lý Đầu sách |
| **UC-14** | Librarian | Quản lý Bản sao vật lý |
| **UC-15** | Librarian | Quản lý Danh mục & Thẻ |
| **UC-16** | Student, Lecturer | Đặt trước sách trực tuyến |
| **UC-17** | Student, Lecturer | Gia hạn sách trực tuyến |
| **UC-18** | Librarian | Giao sách tại quầy (Check-out) |
| **UC-19** | Librarian | Nhận sách tại quầy (Check-in) |
| **UC-20** | Librarian | Duyệt thanh toán tiền mặt |
| **UC-21** | Guest | Đăng nhập bằng Google SSO |
| **UC-22** | User | Tra cứu sách |
| **UC-23** | User | Nhận gợi ý sách từ AI |
| **UC-24** | Manager | Quản lý thông báo |
| **UC-25** | User | Xem thông báo |
| **UC-26** | Manager | Quản lý mẫu văn bản email |
| **UC-27** | Librarian | Nhập sách hàng loạt (Excel) |
| **UC-28** | Librarian | Báo cáo sự cố sách |
| **UC-29** | Librarian | Kiểm kê kho |
| **UC-30** | Admin | Xuất danh sách người dùng (Excel) |
| **UC-31** | Student, Lecturer | Xem Hàng mượn & Chờ sách |
| **UC-32** | Manager, Admin | Xem cấu hình hệ thống |
| **UC-33** | Manager, Admin | Cập nhật cấu hình hệ thống |
| **UC-34** | Manager, Admin | Xem báo cáo hệ thống |
| **UC-35** | Manager, Admin | Xuất báo cáo (Excel) |
| **UC-36** | Guest, User | Hỏi chatbot AI |
| **UC-37** | User | Xem lịch sử chat |
| **UC-38** | User | Xem lịch sử phạt |
| **UC-39** | User | Thanh toán phạt trực tuyến (SePay) |
| **UC-40** | SysAdmin | Xem Nhật ký Kiểm toán |
| **UC-41** | SysAdmin | Xuất Nhật ký Kiểm toán (Excel) |
| **UC-42** | System, SysAdmin | Quét quá hạn tự động |
| **UC-43** | System, SysAdmin | Hủy đặt trước quá hạn tự động |
| **UC-44** | Librarian | Xem Dashboard Thủ thư |
| **UC-45** | Manager | Xem Dashboard Quản lý |
| **UC-46** | Admin | Xem Dashboard Quản trị |
| **UC-47** | Guest | Xem trang chủ công khai |
| **UC-48** | Guest, User | Xem nội quy thư viện |
| **UC-49** | Student, Lecturer | Xem lịch sử mượn trả đầy đủ |
| **UC-50** | Student, Lecturer | Hủy đặt trước trực tuyến |
| **UC-51** | Librarian | Đăng ký đặt trước tại quầy |
| **UC-52** | Librarian | Xem lịch sử nhập sách hàng loạt |
| **UC-53** | Manager | Cấu hình cổng SePay QR |
| **UC-54** | Manager | Xem báo cáo hiệu suất nhân viên |
| **UC-55** | Lecturer | Đề xuất & Vote sách mới |
| **UC-56** | Librarian | Quản lý trạng thái đề xuất sách |

---

## 3. FEATURE REGISTRY (Danh sách 20 Feature — F1→F20)

| Feature | Tên | UC liên quan | Spec Folder |
| :--- | :--- | :--- | :--- |
| **F1** | Authentication | UC-01→03, UC-21 | `feat-authentication` |
| **F2** | Profile Management | UC-04→06 | `feat-profileManagement` |
| **F3** | User Account Management | UC-07→11, UC-30 | `feat-userAccountManagement` |
| **F4** | Book Management | UC-12→15, UC-27, UC-52 | `feat-bookManagement` |
| **F5** | Online Reservation & Renewal | UC-16, UC-17, UC-43, UC-49, UC-50 | `feat-Reservation&Renewal` |
| **F6** | Desk Circulation Operations | UC-18→20, UC-51 | `feat-deskCirculationOperations` |
| **F7** | Notification Management | UC-24→26 | `feat-notification-management` |
| **F8** | Book Discovery | UC-22, UC-23 | `feat-bookDiscovery` |
| **F9** | Fine & Payment Management | UC-31, UC-38, UC-39, UC-42, UC-53 | `feat-finePayment` |
| **F10** | System Configuration | UC-32, UC-33 | `feat-systemConfiguration` |
| **F11** | System Reports | UC-34, UC-35, UC-54 | `feat-systemReport` |
| **F12** | Audit Log | UC-40, UC-41 | `feat-auditLog` |
| **F13** | Book Maintenance | UC-28, UC-29 | `feat-bookMaintenance` |
| **F14** | AI Chatbot | UC-36, UC-37 | `feat-ai-chatbot` |
| **F15** | Dashboard — Librarian | UC-44 | `feat-dashboard-librarian` |
| **F16** | Dashboard — Manager | UC-45 | `feat-systemReport` |
| **F17** | Dashboard — Admin | UC-46 | `feat-auditLog` |
| **F18** | Public Pages | UC-47, UC-48 | `feat-publicPages` |
| **F19** | Async Email Infrastructure | (none) | `feat-asyncEmailSender` |
| **F20** | Book Suggestion | UC-55, UC-56 | `feat-bookSuggestion` |

> Chi tiết đầy đủ BR và FR của từng Feature → xem `diagram/spec-UC-BR-FR.txt`

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
