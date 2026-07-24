# Feature Specification: Báo cáo & Thống kê hệ thống (System Reports & Analytics)
# Version: 1.2 | Chủ sở hữu: @quyet | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cung cấp công cụ báo cáo thống kê trực quan cho Quản lý Thư viện (Library Manager) và Admin để theo dõi hiệu suất hoạt động của thư viện: tần suất mượn/trả sách, thống kê sách quá hạn, doanh thu phạt, top độc giả tích cực, top danh mục sách được mượn nhiều nhất và xuất báo cáo ra file Excel.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản lý Thư viện (Library Manager) & Admin:** Truy xuất báo cáo, xem biểu đồ thống kê, xuất file Excel/CSV.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-38 (View System Reports):** Actor: Manager/Admin | Xem các báo cáo thống kê số liệu hoạt động thư viện theo khoảng thời gian.
* **UC-39 (Export Report Data):** Actor: Manager/Admin | Xuất dữ liệu báo cáo ra file Excel (`.xlsx`) hoặc CSV.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-43 (Report Time-range Filtering):** Báo cáo BẮT BUỘC cho phép lọc theo các khoảng thời gian linh hoạt (Hôm nay, Tuần này, Tháng này, Quý này, hoặc Khoảng ngày tùy chọn).
* **BR-44 (Data Accuracy & Consistency):** Số liệu thống kê mượn/trả, tiền phạt, tồn kho sách BẮT BUỘC được tính toán trực tiếp từ CSDL theo thời gian thực (Real-time DB query).

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-47 (Thống kê hoạt động & Biểu đồ):** WHEN Manager/Admin truy cập trang Báo cáo, THE system SHALL tính toán và hiển thị: (1) Tổng số lượt mượn/trả trong kỳ, (2) Tổng tiền phạt đã thu và chưa thu, (3) Top 5 sách được mượn nhiều nhất, (4) Thống kê theo danh mục thể loại.
  * *Mapping:* UC-38 / BR-43, BR-44
* **FR-48 (Xuất báo cáo ra Excel):** WHEN người dùng chọn xuất báo cáo tại `ExportReportServlet`, THE system SHALL dùng Apache POI kết xuất các bảng số liệu thống kê ra file Excel (`.xlsx`) hỗ trợ tiếng Việt có định dạng header, tổng cộng và font chữ chuẩn.
  * *Mapping:* UC-39

## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Phân quyền nghiêm ngặt chỉ MANAGER và ADMIN mới có quyền xem báo cáo.
* **Hiệu năng:** Xử lý câu truy vấn thống kê dữ liệu lớn trong dưới 500ms bằng index CSDL thích hợp.
* **Giao diện:** Đồ họa biểu đồ đẹp mắt, hỗ trợ xem trên máy tính và tablet, 100% tiếng Việt.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `BorrowRecord`, `Fine`, `Payment`, `Book`, `Category`
* Thực hiện các câu lệnh `GROUP BY`, `COUNT()`, `SUM()`, `JOIN` tính toán số liệu.

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** khoảng ngày chọn không hợp lệ (ngày bắt đầu lớn hơn ngày kết thúc), **THE system SHALL** báo lỗi "Khoảng thời gian báo cáo không hợp lệ".

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-REP-01] Xem báo cáo thống kê hiển thị đúng tổng số lượt mượn, tiền phạt thu được.
- [ ] [TC-REP-02] Lọc báo cáo theo tháng/quý tính toán số liệu chính xác với dữ liệu thực tế trong DB.
- [ ] [TC-REP-03] Xuất file Excel chứa đầy đủ các bảng báo cáo tiếng Việt không bị lỗi font.

## 8. Out of Scope (Phạm vi không thực hiện)
* Tự động gửi file báo cáo hàng tuần qua email cho Ban giám hiệu.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện truy vấn báo cáo thống kê và xuất dữ liệu ra Excel.