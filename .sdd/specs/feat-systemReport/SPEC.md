# Feature Specification: Báo cáo hệ thống và Dashboard Manager (System Reports)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Hỗ trợ Quản lý Thư viện (Manager) theo dõi hoạt động tổng thể của thư viện qua các biểu đồ xu hướng mượn trả, báo cáo tài chính đối chiếu tiền phạt đã thu/chưa thu, thống kê kho sách và hiệu suất của thủ thư.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản lý Thư viện (Library Manager):** Xem các báo cáo thống kê, xu hướng hoạt động, xuất báo cáo ra Excel.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-43 (System Report Integrity):** Dữ liệu thống kê tài chính BẮT BUỘC hiển thị song song cả 2 chiều: tiền phạt đã thu (paid) và tiền phạt chưa thu (unpaid) để phục vụ đối chiếu minh bạch.\n* **BR-44 (System Report Inventory Reconciliation):** Dữ liệu kho sách hiển thị trong báo cáo quản lý bắt buộc phải đối chiếu dựa trên dữ liệu từ đợt kiểm kê gần nhất.\n* **BR-45 (System Report Granularity):** Hệ thống phải cung cấp dữ liệu báo cáo phân nhóm linh hoạt theo Ngày, Tháng, Năm để hỗ trợ phân tích chiều hướng phát triển.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-72 (Hiển thị Dashboard Quản lý với KPI):** WHEN Manager truy cập dashboard, THE system SHALL hiển thị các chỉ số hiệu suất chính và tích hợp thư viện vẽ biểu đồ đường xu hướng mượn/trả và cột tài chính.\n* **FR-98 (Hiển thị biểu đồ xu hướng mượn trả):** WHEN tải dữ liệu báo cáo, THE system SHALL truy vấn số lượng mượn/trả phân nhóm theo thời gian và trả về định dạng JSON vẽ biểu đồ đường.\n* **FR-99 (Hiển thị biểu đồ đối chiếu tài chính):** WHEN tải báo cáo tài chính, THE system SHALL truy xuất dữ liệu tiền phạt đã thu và chưa thu song song để vẽ biểu đồ đối chiếu.\n* **FR-100 (Truy xuất báo cáo kho sách):** THE system SHALL hiển thị số lượng sách khớp, mất, sai vị trí từ dữ liệu đợt kiểm kê gần nhất.\n* **FR-102 (Xuất báo cáo hệ thống ra Excel):** WHEN Manager click xuất báo cáo, THE system SHALL tập hợp dữ liệu và viết vào file Excel (.xlsx) thông qua Apache POI, ghi Audit Log.\n* **FR-83 (Xem báo cáo hiệu suất nhân viên):** WHEN Manager truy cập báo cáo hiệu suất nhân viên, THE system SHALL thống kê số lượt mượn/trả và số tiền phạt thu được của từng thủ thư.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Tính trực quan: Biểu đồ tải mượt mà, sử dụng các thư viện biểu đồ phía Client (Chart.js).\n* Thời gian xử lý: Báo cáo tổng hợp phải hoàn thành truy vấn dưới 1.5 giây.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng BorrowRecord\n* `borrowRecordId` (INT, PK)\n* `status` (VARCHAR(50))\n\n### Bảng Fine\n* `fineId` (INT, PK)\n* `amount` (DECIMAL)\n* `status` (VARCHAR(50))\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE không có dữ liệu trong khoảng thời gian chọn, THE system SHALL hiển thị màn hình trống kèm thông báo thân thiện.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Xem Dashboard: Hiển thị đúng biểu đồ xu hướng mượn trả và các thống kê KPI chính.\n- [ ] Xuất Excel: File Excel chứa đúng các bảng biểu báo cáo tài chính và kho sách khớp với DB.

## 9. Out of Scope (Phạm vi không thực hiện)
* Tự động gửi báo cáo định kỳ hàng tuần/tháng qua email cho Manager.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
