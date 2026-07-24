# System Test Plan — LMS Project (Flat Structure & E2E Suites)
> Định nghĩa Kịch bản Kiểm thử Hệ thống (System Test) Katalon Studio cho Dự án LMS

---

## 1. Quy tắc đặt tên đồng bộ (Mapping Rule)

* **Test Case:** Tiền tố `TC` + Tên chức năng (VD: `TCCreateUser`, `TCCheckoutBook`)
* **Data File:** Tiền tố `Data` + Tên chức năng tương ứng (VD: `DataCreateUser.xlsx`, `DataCheckoutBook.xlsx`)
* **Test Suite:** Tiền tố `TS` + Tên nhóm chức năng (VD: `TSAuthentication`, `TSDeskCirculation`)

---

## 2. Danh sách các Test Case (Mapping 1-1 với Data Files)

| Test Case Name | Mapping Data File | Số lượng TCs | Luồng thực thi (Test Flow) | Kết quả kỳ vọng (Expected Result) |
|---|---|---|---|---|
| **TCLogin** | `DataLogin.xlsx` | 4 TCs | Mở trang Login ➔ Nhập Email & Password ➔ Submit & Verify Role Header | Đăng nhập thành công với đúng Role. Nếu sai pass/email báo lỗi. |
| **TCLogout** | *(Single Execution)* | 1 TC | Click Đăng xuất trên Header | Xóa Session, quay lại màn hình Login. |
| **TCForgotPassword** | `DataForgotPassword.xlsx` | 3 TCs | Nhập Email tại trang Quên mật khẩu ➔ Bấm Gửi OTP | Hệ thống xác minh email và gửi mã OTP khôi phục. |
| **TCAccountLockout** | `DataAccountLockout.xlsx` | 4 TCs | Nhập sai MK 5 lần liên tiếp | Tự động khóa tài khoản tạm thời, báo lỗi tài khoản bị khóa. |
| **TCCreateUser** | `DataCreateUser.xlsx` | 4 TCs | Vào Admin -> Thêm người dùng ➔ Điền Form ➔ Lưu | Tạo tài khoản thành công, xuất hiện trong danh sách. Báo lỗi nếu trùng. |
| **TCUpdateUser** | `DataUpdateUser.xlsx` | 4 TCs | Tìm user ➔ Bấm Sửa ➔ Cập nhật thông tin ➔ Lưu | Báo cập nhật thành công, dữ liệu mới thay đổi. |
| **TCLockUser** | `DataLockUser.xlsx` | 1 TC | Tìm user Active ➔ Bấm Khóa ➔ Chọn lý do ➔ Xác nhận | Trạng thái chuyển thành Locked. |
| **TCUnlockUser** | `DataUnlockUser.xlsx` | 1 TC | Tìm user Locked ➔ Bấm Mở khóa ➔ Confirm Alert | Trạng thái chuyển thành Active. |
| **TCAddBook** | `DataAddBook.xlsx` | 4 TCs | Vào Quản lý sách ➔ Thêm sách mới ➔ Điền form ➔ Lưu | Thêm sách mới thành công. |
| **TCAddBookCopy** | `DataAddBookCopy.xlsx` | 3 TCs | Chọn đầu sách ➔ Thêm bản sao ➔ Nhập vị trí ➔ Lưu | Sinh bản sao mới kèm Mã vạch (Barcode). |
| **TCUpdateBook** | `DataUpdateBook.xlsx` | 2 TCs | Chọn sách ➔ Bấm Sửa thông tin ➔ Lưu | Cập nhật thông tin thành công. |
| **TCCheckoutBook** | `DataCheckoutBook.xlsx` | 10 TCs | Tra cứu Mã SV (`memberCode`) ➔ Bấm 'Chọn giao sách' ➔ Nhập Barcode ➔ Bấm 'Xác nhận giao sách' | Giao sách thành công, BorrowRecord trạng thái borrowed. Từ chối nếu nợ phạt / quá hạn mức. |
| **TCCheckinBook** | `DataCheckinBook.xlsx` | 8 TCs | Tra cứu Mã SV (`memberCode`) ➔ Bấm 'Chọn trả sách' ➔ Nhập Barcode & Tình trạng (`good`/`damaged`/`lost`) ➔ Bấm 'Xác nhận nhận trả sách' | Nhận trả sách thành công, tự động tính phạt trễ/hỏng/mất. Báo lỗi nếu bản sao chưa mượn / không tồn tại. |
| **TCPayFine** | `DataPayFine.xlsx` | 5 TCs | Tra cứu Mã SV (`memberCode`) ➔ Bấm 'DUYỆT THU TIỀN MẶT' | Đóng khoản phạt, xóa cờ nợ phạt và tự động mở khóa tài khoản. |

---

## 3. Tổ chức các Test Suites

### 🟢 Test Suite 1: `TSAuthentication` (12 Test Cases)
* **Mục tiêu:** Kiểm thử toàn bộ chức năng Xác thực, Phân quyền, Khôi phục mật khẩu & Khóa tài khoản tự động.
* **Tập hợp TC:** `TCLogin` (4 TCs) ➔ `TCLogout` (1 TC) ➔ `TCForgotPassword` (3 TCs) ➔ `TCAccountLockout` (4 TCs).

### 🟢 Test Suite 2: `TSUserManagement` (10 Test Cases)
* **Mục tiêu:** Kiểm thử Quản lý tài khoản người dùng bởi Quản trị viên (Admin).
* **Tập hợp TC:** `TCCreateUser` (4 TCs) ➔ `TCUpdateUser` (4 TCs) ➔ `TCLockUser` (1 TC) ➔ `TCUnlockUser` (1 TC).

### 🟢 Test Suite 3: `TSBookManagement` (9 Test Cases)
* **Mục tiêu:** Kiểm thử Quản lý Kho sách & Bản sao bởi Thủ thư.
* **Tập hợp TC:** `TCAddBook` (4 TCs) ➔ `TCAddBookCopy` (3 TCs) ➔ `TCUpdateBook` (2 TCs).

### 🟢 Test Suite 4: `TSDeskCirculation` (23 Test Cases)
* **Mục tiêu:** Kiểm thử nghiệp vụ Mượn sách, Trả sách và Thu tiền phạt tại quầy của Thủ thư (Phủ 100% tất cả các nhánh điều hướng logic).
* **Tập hợp TC:** `TCCheckoutBook` (10 TCs) ➔ `TCCheckinBook` (8 TCs) ➔ `TCPayFine` (5 TCs).

---

## 4. Kết quả Kiểm thử & Báo cáo Xuất bản

* **Tổng số kịch bản kiểm thử toàn hệ thống:** **54 Test Cases**
* **Kết quả thực thi tự động (Automated Execution):** **54/54 Passed (100% Pass Rate)**
* **File Báo cáo Tổng hợp (Template3 Standard):** [LMS_System_Test_Report.xlsx](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/System%20Test/LMS_System_Test_Report.xlsx)
