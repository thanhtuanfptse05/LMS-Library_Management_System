# System Test Plan — LMS Project (Flat Structure & E2E Suites)
> Định nghĩa Kịch bản Kiểm thử Hệ thống (System Test) Katalon Studio cho Dự án LMS

---

## 1. Quy tắc đặt tên đồng bộ (Mapping Rule)

* **Test Case:** Tiền tố `TC` + Tên chức năng (VD: `TCCreateUser`, `TCCheckoutBook`, `TCSearchBook`)
* **Data File:** Tiền tố `Data` + Tên chức năng tương ứng (VD: `DataCreateUser.xlsx`, `DataSearchBook.xlsx`)
* **Test Suite:** Tiền tố `TS` + Tên nhóm chức năng (VD: `TSAuthentication`, `TSBookDiscovery`)

---

## 2. Danh sách các Test Case (Mapping 1-1 với Data Files)

### 🟢 Đã hoàn thành 100% (TS1 - TS4: 54 Test Cases)

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

### 🟡 Các Test Suite Mới Đã Chốt Kiến Trúc (TS5 - TS7)

| Test Case Name | Mapping Data File | Luồng thực thi (Test Flow) | Kết quả kỳ vọng (Expected Result) |
|---|---|---|---|
| **TCSearchBook** | `DataSearchBook.xlsx` | Nhập từ khóa (Tên sách, Tác giả, ISBN) ➔ Bấm Tìm kiếm | Danh sách sách hiển thị chính xác các kết quả khớp từ khóa. |
| **TCFilterByCategory** | `DataFilterByCategory.xlsx` | Chọn 1 hoặc nhiều Danh mục sách ➔ Lọc | Chỉ hiển thị các đầu sách thuộc danh mục đã chọn. |
| **TCFilterByTag** | `DataFilterByTag.xlsx` | Chọn Thẻ Tag (Java, AI, Giáo trình) ➔ Lọc | Chỉ hiển thị các đầu sách có gắn thẻ Tag tương ứng. |
| **TCFilterByAvailability** | `DataFilterByAvailability.xlsx` | Lọc theo trạng thái sách có sẵn trong kho | Loại bỏ các đầu sách đã hết bản sao mượn. |
| **TCViewBookDetail** | `DataViewBookDetail.xlsx` | Click vào một đầu sách bất kỳ trong danh sách | Hiển thị chi tiết sách, ảnh bìa, vị trí kệ & các bản sao. |
| **TCReserveBookOnline** | `DataReserveBookOnline.xlsx` | Độc giả bấm Đặt trước sách trực tuyến | Tạo đơn đặt trước thành công (trạng thái `readypickup` / `pending`). |
| **TCRenewBookOnline** | `DataRenewBookOnline.xlsx` | Độc giả gửi Yêu cầu gia hạn sách đang mượn | Hệ thống tự động gia hạn thêm ngày trả sách mới nếu đủ điều kiện. |
| **TCCancelReservation** | `DataCancelReservation.xlsx` | Độc giả bấm Hủy đơn đặt trước | Chuyển trạng thái đơn sang `cancelled`, giải phóng bản sao sách. |
| **TCCreateNotification** | `DataCreateNotification.xlsx` | Manager đăng thông báo hệ thống mới | Thông báo xuất hiện trên bảng tin toàn hệ thống. |
| **TCViewNotifications** | `DataViewNotifications.xlsx` | Student/Lecturer xem bảng tin & lọc loại thông báo | Hiển thị danh sách thông báo kèm số thông báo chưa đọc. |
| **TCMarkAsRead** | `DataMarkAsRead.xlsx` | Bấm "Đánh dấu tất cả đã đọc" | Cập nhật `readAt`, badge thông báo giảm về 0. |

---

## 3. Tổ chức các Test Suites

### 🟢 Test Suite 1: `TSAuthentication` (12 Test Cases) — PASSED
* **Mục tiêu:** Kiểm thử toàn bộ chức năng Xác thực, Phân quyền, Khôi phục mật khẩu & Khóa tài khoản tự động.

### 🟢 Test Suite 2: `TSUserManagement` (10 Test Cases) — PASSED
* **Mục tiêu:** Kiểm thử Quản lý tài khoản người dùng bởi Quản trị viên (Admin).

### 🟢 Test Suite 3: `TSBookManagement` (9 Test Cases) — PASSED
* **Mục tiêu:** Kiểm thử Quản lý Kho sách & Bản sao bởi Thủ thư.

### 🟢 Test Suite 4: `TSDeskCirculation` (23 Test Cases) — PASSED
* **Mục tiêu:** Kiểm thử nghiệp vụ Mượn sách, Trả sách và Thu tiền phạt tại quầy của Thủ thư.

### 🟡 Test Suite 5: `TSBookDiscovery` (Chốt kiến trúc - Chuẩn bị triển khai)
* **Mục tiêu:** Kiểm thử Tra cứu và Lọc tìm kiếm sách nâng cao (từ khóa, danh mục, tag, trạng thái kho).
* **Tập hợp TC:** `TCSearchBook` ➔ `TCFilterByCategory` ➔ `TCFilterByTag` ➔ `TCFilterByAvailability` ➔ `TCViewBookDetail`.

### 🟡 Test Suite 6: `TSSelfService` (Chốt kiến trúc - Chuẩn bị triển khai)
* **Mục tiêu:** Kiểm thử Dịch vụ Độc giả tự phục vụ trực tuyến (Đặt trước, Gia hạn, Hủy đặt trước).
* **Tập hợp TC:** `TCReserveBookOnline` ➔ `TCRenewBookOnline` ➔ `TCCancelReservation`.

### 🟡 Test Suite 7: `TSNotifications` (Chốt kiến trúc - Chuẩn bị triển khai)
* **Mục tiêu:** Kiểm thử Đăng thông báo, Bảng tin người dùng & Đánh dấu đã đọc.
* **Tập hợp TC:** `TCCreateNotification` ➔ `TCViewNotifications` ➔ `TCMarkAsRead`.

---

## 4. Báo cáo Xuất bản & Lưu trữ

* **File Báo cáo Tổng hợp (Template3 Standard):** [LMS_System_Test_Report.xlsx](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/System%20Test/LMS_System_Test_Report.xlsx)
* **Script tạo báo cáo tự động:** [generate_report.py](file:///d:/Data/NetBeansIDE17/LMS-Library_Management_System/System%20Test/generate_report.py)
