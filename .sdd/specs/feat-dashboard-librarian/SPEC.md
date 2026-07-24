# Feature Specification: Bảng điều khiển theo vai trò (Role-Based Dashboards)
# Version: 1.2 | Chủ sở hữu: @thai | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp màn hình Bảng điều khiển (Dashboard) tổng quan được tùy biến theo từng vai trò người dùng (Admin, Librarian, Manager, Student, Lecturer), hiển thị các chỉ số đo lường nhanh (KPI metrics), lối tắt thao tác nhanh (Quick Actions), danh sách cảnh báo (Quá hạn, Chờ duyệt, Nợ phạt) và thông báo mới nhất.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản trị viên (SysAdmin):** Xem Dashboard tổng quan hệ thống, chỉ số người dùng, trạng thái dịch vụ và Audit Logs mới nhất.
* **Thủ thư (Librarian):** Xem Dashboard quầy lưu thông (lượt mượn/trả trong ngày, sách chờ trả, đơn đặt trước chờ nhận).
* **Quản lý Thư viện (Library Manager):** Xem Dashboard quản lý (thống kê tổng quan sách, danh mục, đề xuất mua sách chờ duyệt).
* **Sinh viên & Giảng viên:** Xem Dashboard cá nhân (sách đang mượn, ngày đến hạn trả, lịch sử mượn, thông báo nợ phạt).

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-40 (View Role Dashboard):** Actor: All Roles | Truy cập trang chủ cá nhân hóa sau khi đăng nhập thành công.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-45 (Role-based Dashboard Isolation):** Mỗi vai trò BẮT BUỘC chỉ được chuyển hướng và xem đúng Dashboard được phân quyền theo cấu hình RBAC.
* **BR-46 (Real-time Metric Counters):** Các chỉ số đếm (Ví dụ: Số sách đang mượn, số đơn chờ xử lý) phải phản ánh đúng dữ liệu hiện tại trong DB.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-49 (Dashboard Thủ thư):** WHEN Thủ thư truy cập `LibrarianDashboardServlet`, THE system SHALL hiển thị: (1) Số lượt mượn/trả hôm nay, (2) Số đơn đặt trước chờ lấy sách, (3) Lối tắt đến trang Check-out, Check-in, Báo sự cố sách.
  * *Mapping:* UC-40 / BR-45
* **FR-50 (Dashboard Độc giả - Student/Lecturer):** WHEN Sinh viên/Giảng viên truy cập Dashboard, THE system SHALL hiển thị: (1) Danh sách các sách đang mượn kèm số ngày còn lại đến hạn, (2) Cảnh báo nếu có khoản phạt chưa trả, (3) Nút gia hạn nhanh cho các sách đủ điều kiện.
  * *Mapping:* UC-40 / BR-45
* **FR-51 (Dashboard Admin & Manager):** WHEN Admin hoặc Manager truy cập Dashboard tương ứng, THE system SHALL hiển thị biểu đồ tổng quan tài khoản, tổng số đầu sách, hoạt động gần đây và lối tắt quản trị.
  * *Mapping:* UC-40 / BR-45

## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Phân quyền nghiêm ngặt bởi `AuthFilter`.
* **Hiệu năng:** Tải trang Dashboard trong dưới 250ms.
* **Giao diện:** Đồ họa thẻ thông tin (Metric Cards) hiện đại, màu sắc trực quan, 100% tiếng Việt.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
* Truy vấn tổng hợp từ `BorrowRecord`, `Reservation`, `Fine`, `BookCopy`, `Notification`, `"User"`.

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** người dùng truy cập Dashboard không đúng vai trò, **THE system SHALL** chuyển hướng về Dashboard chính xác của vai trò đó.

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-DASH-01] Đăng nhập bằng tài khoản Thủ thư chuyển hướng đến Dashboard Thủ thư với đầy đủ lối tắt Check-out/Check-in.
- [ ] [TC-DASH-02] Đăng nhập Sinh viên hiển thị đúng danh sách các sách Sinh viên đó đang mượn và ngày hẹn trả.
- [ ] [TC-DASH-03] Các chỉ số Metric Cards trên Dashboard đếm chuẩn xác theo DB.

## 8. Out of Scope (Phạm vi không thực hiện)
* Tùy biến vị trí kéo thả các widget trên Dashboard (Drag & Drop UI customization).

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện toàn bộ các Servlet Dashboard cho 5 phân hệ vai trò.