# CONTEXT.md — User Account Management
# Version: 1.0.0 | Status: LOCKED

## 1. PROBLEM STATEMENT
Hệ thống LMS cần một phân hệ tập trung để Admin kiểm soát vòng đời tài khoản người dùng (Sinh viên, Giảng viên, Nhân viên thư viện). Đặc biệt, khi có khóa học/học kỳ mới, việc tạo hàng trăm tài khoản thủ công là điểm nghẽn (bottleneck). Cần giải pháp Import hàng loạt tự động hóa việc tạo tài khoản, sinh mật khẩu và phân bổ vào các bảng role tương ứng.

## 2. DOMAIN KNOWLEDGE
Cấu trúc tài khoản trong hệ thống được phân mảnh để chuẩn hóa dữ liệu:
* Bảng `[User]`: Quản lý định danh đăng nhập (email, passwordHash, status, role).
* Bảng `MemberProfile`: Quản lý thông tin cá nhân chung (tên, sđt, giới tính).
* Bảng Role-specific (`Student`, `Lecturer`, `Librarian`...): Quản lý mã định danh nội bộ (studentCode, lecturerCode) và thông tin chuyên ngành.

## 3. STAKEHOLDERS
* **Admin**: Tác nhân duy nhất có quyền truy cập module này.
* **Tất cả Users**: Đối tượng chịu tác động (bị khóa tài khoản, được cấp tài khoản mới).

## 4. CONSTRAINTS (RÀNG BUỘC KỸ THUẬT)
* **Architecture**: Java Servlet MVC, JDBC thuần.
* **Security**: Hash password bằng `jbcrypt-0.4.jar`. Không lưu plaintext.
* **Thư viện bên thứ 3**: Sử dụng Apache POI để parse file Excel (.xlsx).
* **Database**: Khóa ngoại (Foreign Key) yêu cầu Insert vào `[User]` để sinh `userId` trước khi Insert vào `MemberProfile` và bảng Role-specific.

## 5. ASSUMPTIONS (GIẢ ĐỊNH)
* File Excel được tải lên tuân thủ đúng template mẫu của hệ thống cung cấp.
* Dữ liệu trong file Excel thuộc về MỘT Role duy nhất (đã được Admin chọn từ UI).
