# Implementation Plan: Audit Log (Nhật ký hoạt động và Dashboard Admin)

**Branch**: `main` | **Date**: 2026-07-21 | **Spec**: [SPEC.md](file:///d:/LMS-Library_Management_System/.sdd/specs/feat-auditLog/SPEC.md)

## Summary (Tóm tắt)
Triển khai giao diện quản lý Nhật ký Kiểm toán (Audit Log) và Bảng điều khiển dành riêng cho Quản trị viên (Admin Dashboard). Hệ thống hỗ trợ truy vấn danh sách log thay đổi dữ liệu có phân trang, lọc nâng cao theo 7 tiêu chí, xem so sánh trực quan giá trị cũ/mới dạng card 1-1 trên giao diện Modal (phía client), và kết xuất tệp Excel (.xlsx) báo cáo nhật ký bằng thư viện Apache POI. Dashboard Admin tổng hợp nhanh sức khỏe hệ thống và hiển thị các thông số cấu hình quan trọng từ Cache RAM.

## Technical Context (Bối cảnh kỹ thuật)
* **Backend:** Java 17, Java Servlet (Servlet 4.0/5.0)
* **Database:** PostgreSQL (JDBC + DAO Pattern)
* **Libraries:** Apache POI 5.2.5 (Excel Export)
* **Auth & Authorization:** Session-based authentication và `@WebFilter` bảo vệ nghiêm ngặt đường dẫn `/admin/*` (chỉ role `ADMIN` được phép truy cập)

## Project Structure (Cấu trúc dự án thực tế)
### Source Code
```text
src/java/
├── controllers/
│   ├── AuditLogServlet.java        # Controller quản lý danh sách lọc, xem chi tiết, và xuất Excel nhật ký (UC-40, UC-41)
│   └── AdminDashboardServlet.java   # Controller cho Dashboard của Admin (UC-46, FR-73, FR-74)
├── dao/
│   ├── AuditLogDAO.java            # Thực thi SELECT đọc nhật ký kiểm toán với bộ lọc động
│   ├── UserDAO.java                # JOIN lấy thông tin email của tài khoản thực hiện
│   └── BookCopyDAO.java            # Đếm tổng số lượng bản sao vật lý cho Dashboard Admin
├── model/
│   └── AuditLog.java               # Model đại diện cho bảng AuditLogs
├── dto/
│   └── AuditLogDTO.java            # DTO kết hợp dữ liệu AuditLog cùng email người thực hiện
web/admin/                          # Giao diện dành riêng cho Admin
├── dashboard.jsp                   # Trang Dashboard tổng hợp KPI toàn thư viện
├── audit-log-list.jsp              # Trang xem danh sách lọc, phân trang và chứa modal so sánh JSON
└── fragments/                      # Các fragment JSP dùng chung (head, sidebar, header)
```

## Technical Decisions & Implementation Details (Chi tiết kỹ thuật & Quyết định thiết kế)

### 1. Chỉ đọc và Bảo mật dữ liệu (BR-32)
* Tính năng Audit Log là **Read-Only** thông qua giao diện. `AuditLogDAO` chỉ thực thi các truy vấn `SELECT` dữ liệu, tuyệt đối không chứa bất kỳ logic `INSERT`, `UPDATE` hay `DELETE` nào để ngăn chặn hành vi xóa dấu vết pháhoại.

### 2. So sánh Trực quan 1-1 phía Client (FR-57, FR-58)
* Để giảm tải xử lý cho server, các trường `oldValues` và `newValues` dạng JSON string được nạp vào HTML data attributes trên thẻ `<tr>` của bảng hiển thị.
* Khi Admin click "Xem chi tiết", mã JavaScript phía client sẽ thực hiện `JSON.parse()`, lặp qua các cặp key-value thay đổi và render động lên Modal thành dạng so sánh 2 cột đối xứng: Cột trái (Cũ - nền đỏ/hồng nhạt), Cột phải (Mới - nền xanh lá nhạt).
* Đối với hành động đổi mật khẩu (`actionType = CHANGE_PASSWORD`), hệ thống ẩn toàn bộ giá trị thô và hiển thị nhãn: "Mật khẩu đã thay đổi (bảo mật)".

### 3. Phân trang và Giới hạn hiệu năng (BR-34, FR-59)
* Để bảo vệ bộ nhớ RAM và hiệu năng cơ sở dữ liệu khi bảng `AuditLogs` phình to trong production, hệ thống bắt buộc phân trang ở tầng database sử dụng `LIMIT 20 OFFSET (page-1)*20` trên PostgreSQL.
* Khi kết xuất Excel, hệ thống giới hạn cứng tối đa 10.000 dòng ghi gần nhất tương ứng với bộ lọc để tránh tràn bộ nhớ máy chủ (Out Of Memory).

### 4. Badge Màu sắc nhóm Hành động (FR-60)
* Cột loại hành động (`actionType`) được phủ màu badge CSS tương ứng để Admin dễ dàng phân biệt bằng mắt thường (Ví dụ: nhóm Tạo mới = Green, nhóm Cập nhật = Yellow, nhóm Xóa/Hủy = Red, nhóm Giao dịch mượn trả = Blue, nhóm Bảo mật = Purple).
