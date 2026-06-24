# SPEC.md — Nhật ký Kiểm toán (Audit Log)
# Version: 1.0.0 | Owner: @tech-lead | Status: APPROVED

## 1. Context & Goal
Cung cấp giao diện cho SysAdmin xem, lọc, tìm kiếm và xuất dữ liệu Nhật ký Kiểm toán (Audit Log). Dữ liệu audit đã được ghi sẵn bởi các tính năng F1–F14 thông qua tiến trình ngầm trong Service/Controller. F12 chỉ tạo giao diện ĐỌC, không ghi thêm dữ liệu.

## 2. Actors & Roles
- **SysAdmin:** Là người duy nhất có quyền truy cập trang Nhật ký Kiểm toán. Xem danh sách, lọc, xem chi tiết so sánh Old ↔ New, và xuất CSV.
- **Access Control:** Role = `ADMIN` có toàn quyền đọc audit log. Các vai trò khác (Librarian, Manager, Student, Lecturer) PHẢI bị từ chối với HTTP 403.

## 3. Functional Requirements (EARS)

**Truy vấn & Hiển thị Danh sách**
- **FR-F12-01:** WHEN SysAdmin truy cập trang Nhật ký Kiểm toán, THE system SHALL truy vấn bảng AuditLogs kết hợp LEFT JOIN bảng "User" để lấy email người thực hiện, sắp xếp theo timestamp giảm dần, phân trang 20 bản ghi mỗi trang.
- **FR-F12-02:** WHEN hiển thị danh sách, THE system SHALL hiển thị badge màu cho cột actionType theo nhóm: Tạo mới (xanh lá), Cập nhật (vàng), Xóa/Hủy (đỏ), Giao dịch (xanh dương), Bảo mật (tím), Thanh toán (cam).
- **FR-F12-03:** WHERE userId trong bản ghi AuditLogs là NULL, THE system SHALL hiển thị "Hệ thống" thay vì email ở cột Người thực hiện.

**Lọc & Tìm kiếm**
- **FR-F12-04:** WHEN SysAdmin áp dụng bộ lọc, THE system SHALL hỗ trợ lọc theo: loại hành động (actionType), đối tượng (entityName), email người thực hiện (ILIKE), khoảng thời gian (fromDate–toDate), và từ khóa trong oldValues/newValues. Các điều kiện lọc kết hợp bằng AND.
- **FR-F12-05:** WHEN populate dropdown bộ lọc, THE system SHALL truy vấn DISTINCT actionType và DISTINCT entityName có trong bảng AuditLogs.
- **FR-F12-06:** WHILE chuyển trang phân trang, THE system SHALL giữ nguyên toàn bộ tham số filter hiện tại.

**Xem chi tiết (Modal Card-based)**
- **FR-F12-07:** WHEN SysAdmin click nút Chi tiết trên một dòng, THE system SHALL mở modal hiển thị thông tin chung (thời gian, email, actionType, entityName, entityId) và bảng so sánh card-by-card giữa oldValues và newValues.
- **FR-F12-08:** WHEN render modal, THE system SHALL parse JSON oldValues/newValues và hiển thị mỗi key thay đổi trong 1 card riêng biệt: card giá trị cũ nền hồng nhạt (error-container), card giá trị mới nền xanh nhạt (tertiary-fixed), xếp dọc đối xứng 1-1.
- **FR-F12-09:** WHERE actionType là CREATE (oldValues=NULL), THE system SHALL hiển thị "—" ở cột Giá trị Cũ và liệt kê cards cho newValues. WHERE actionType là DELETE (newValues=NULL), THE system SHALL hiển thị ngược lại.
- **FR-F12-10:** WHERE actionType là CHANGE_PASSWORD (oldValues={}, newValues={}), THE system SHALL hiển thị dòng text "Mật khẩu đã được thay đổi (không hiển thị giá trị vì lý do bảo mật)" thay vì cards rỗng.
- **FR-F12-11:** WHERE oldValues hoặc newValues không phải JSON hợp lệ, THE system SHALL hiển thị raw text trong 1 card đơn thay vì bảng so sánh.

**Xuất CSV**
- **FR-F12-12:** WHEN SysAdmin click Xuất CSV, THE system SHALL truy vấn toàn bộ bản ghi theo filter hiện tại (giới hạn tối đa 10,000 bản ghi), tạo file CSV mã hóa UTF-8 có BOM, và trả về response với Content-Disposition attachment.

## 4. Business Rules
- **BR-32 (Audit Log Read-Only):** Tính năng F12 KHÔNG ĐƯỢC PHÉP Insert, Update hoặc Delete bất kỳ dữ liệu nào trong bất kỳ bảng nào. Chỉ được thực hiện SELECT.
- **BR-33 (Audit Log JSON Format):** Tất cả oldValues và newValues trong hệ thống BẮT BUỘC được ghi ở dạng JSON (hoặc NULL). Không sử dụng plain text. Các tính năng đang dùng plain text (F6: CHECK_OUT/CHECK_IN/CASH_PAYMENT, F1: CHANGE_PASSWORD qua reset) BẮT BUỘC phải chuẩn hóa.
- **BR-34 (Audit Log Pagination):** Danh sách Nhật ký Kiểm toán BẮT BUỘC phải phân trang (20 bản ghi/trang) để bảo vệ hiệu năng. KHÔNG ĐƯỢC PHÉP load toàn bộ dữ liệu trong 1 request.

## 5. Non-Functional Requirements
- **NFR-F12-01 (Performance):** Trang danh sách audit log với filter phải phản hồi trong P95 < 500ms.
- **NFR-F12-02 (Export Limit):** Xuất CSV giới hạn tối đa 10,000 bản ghi để tránh timeout và quá tải bộ nhớ.
