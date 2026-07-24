# Feature Specification: Cấu hình chính sách hệ thống (System Configuration)
# Version: 1.2 | Chủ sở hữu: @quyet | Ngày cập nhật: 2026-07-24 (Đồng bộ CodeGraph)

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cho phép Quản lý Thư viện (Library Manager) và Admin linh hoạt thay đổi các thông số cấu hình chính sách của thư viện (mức phạt trễ hạn, hạn mức mượn sách, số ngày mượn mặc định cho từng đối tượng, số lần gia hạn tối đa, thời gian giữ chỗ đặt trước) mà không cần can thiệp mã nguồn hay khởi động lại hệ thống.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản lý Thư viện (Library Manager) / Admin:** Xem và điều chỉnh các tham số cấu hình chính sách hệ thống.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-37 (Manage System Configurations):** Actor: Library Manager/Admin | Truy vấn và cập nhật giá trị các tham số cấu hình quy tắc thư viện.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-41 (Dynamic Configuration Reload):** Mọi sự thay đổi tham số cấu hình BẮT BUỘC có hiệu lực ngay lập tức (Real-time Dynamic Reload) cho các giao dịch mới phát sinh mà không cần restart server.
* **BR-42 (Configuration Range Validation):** Giá trị cấu hình phải tuân thủ khoảng giá trị hợp lệ (Ví dụ: Mức phạt >= 0, Hạn mức mượn từ 1 đến 20 quyển).

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-46 (Hiển thị & Cập nhật tham số cấu hình):** WHEN Manager truy cập trang Cấu hình hệ thống, THE system SHALL tải danh sách các cấu hình từ bảng `SystemConfigurations` theo từng nhóm (`configGroup`). WHEN gửi yêu cầu lưu, hệ thống validate khoảng giá trị và UPDATE `configValue`, `updatedBy`, `updatedAt`. Ghi `AuditLogs`.
  * *Mapping:* UC-37 / BR-41, BR-42

## 4.5 Non-functional Requirements (Yêu cầu phi chức năng)
* **Bảo mật:** Phân quyền nghiêm ngặt chỉ MANAGER và ADMIN mới có quyền sửa đổi cấu hình.
* **Giao diện:** 100% Tiếng Việt, phân nhóm rõ ràng: Chính sách mượn sách, Chính sách tiền phạt, Quy định đặt giữ chỗ.

## 5. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng `SystemConfigurations`
* `configKey` (VARCHAR(100), PK), `configValue` (VARCHAR(255), NOT NULL), `description` (TEXT), `configGroup` (VARCHAR(50)), `updatedBy` (FK REFERENCES `"User"`), `updatedAt` (TIMESTAMP)

## 6. Error Handling (Xử lý lỗi ngoại lệ)
* **WHERE** nhập giá trị cấu hình âm hoặc không phải là số, **THE system SHALL** từ chối lưu và báo lỗi "Giá trị cấu hình phải là số dương hợp lệ".

## 7. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] [TC-CONF-01] Manager cập nhật giá trị mức phạt theo ngày thành công và áp dụng ngay cho phiếu mượn trả sau đó.
- [ ] [TC-CONF-02] Nhập giá trị không hợp lệ (như chữ hoặc số âm) bị ngăn chặn và hiển thị lỗi.
- [ ] [TC-CONF-03] Thay đổi cấu hình được ghi lại đầy đủ thông tin người sửa và thời gian trong AuditLogs.

## 8. Out of Scope (Phạm vi không thực hiện)
* Tự động điều chỉnh cấu hình theo lịch trình hẹn giờ tự động.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Đã hoàn thiện module SystemConfigurationsDAO phục vụ toàn bộ nghiệp vụ mượn trả.