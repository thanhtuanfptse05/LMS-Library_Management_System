# Feature Specification: Cấu hình hệ thống (System Configuration)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cho phép thay đổi các thông số vận hành của hệ thống như chính sách mượn sách, tiền phạt, giới hạn gia hạn và thông tin cổng thanh toán SePay trực tiếp thông qua giao diện quản trị.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản lý Thư viện (Library Manager):** Xem và cập nhật các cấu hình nghiệp vụ thư viện và SePay.\n* **Quản trị viên (Admin):** Có toàn quyền xem và cập nhật tất cả các cấu hình hệ thống.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-30 (System Config Immutability):** Cấm tuyệt đối việc xóa cấu hình (delete configKey) thông qua UI hoặc hệ thống dưới mọi hình thức.\n* **BR-31 (System Config Authorization):** Library Manager chỉ được phép xem và cập nhật các config thuộc nhóm 'library' hoặc cấu hình tích hợp SePay. Admin có toàn quyền với mọi nhóm config.\n* **BR-40 (SePay Whitelist Modification):** Cập nhật cấu hình hệ thống chỉ được áp dụng với các key cấu hình nằm trong whitelist định nghĩa sẵn trong mã nguồn. Mọi thao tác cập nhật phải được kiểm tra kiểu dữ liệu trước khi lưu DB.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-84 (Xem cấu hình nhóm library của Manager):** WHEN Manager truy cập, THE system SHALL chỉ tải các key thuộc nhóm 'library' hoặc SePay.\n* **FR-85 (Xem toàn bộ cấu hình của Admin):** WHEN Admin truy cập, THE system SHALL tải toàn bộ cấu hình hệ thống.\n* **FR-86 (Cập nhật cấu hình hệ thống):** WHEN thực hiện cập nhật key, THE system SHALL validate kiểu dữ liệu hợp lệ (số nguyên dương, số thực không âm) và cập nhật DB, ghi Audit Log và reload cache RAM.\n* **FR-87 (Thêm mới cấu hình whitelist):** WHEN thêm mới cấu hình, THE system SHALL đảm bảo key thuộc whitelist và chưa tồn tại.\n* **FR-88 (Bảo mật chặn xóa cấu hình):** WHEN nhận request xóa cấu hình, THE system SHALL ném ra lỗi từ chối hành động.\n* **FR-93 (Khởi động nạp Cache cấu hình):** WHEN ứng dụng khởi động, THE system SHALL nạp toàn bộ cấu hình vào RAM.\n* **FR-94 (Đồng bộ cache tức thời khi update):** WHEN cập nhật thành công, THE system SHALL reload cache trong RAM lập tức để các luồng mượn trả áp dụng ngay.

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Hiệu năng: Đọc cấu hình từ cache RAM nên thời gian đáp ứng gần như bằng 0ms.\n* Ràng buộc dữ liệu: Thực hiện kiểm tra kiểu dữ liệu nghiêm ngặt trước khi cập nhật DB.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng SystemConfigurations\n* `configKey` (VARCHAR(100), PK)\n* `configValue` (TEXT)\n* `description` (TEXT)\n* `configGroup` (VARCHAR(50))\n* `updatedBy` (INT)\n* `updatedAt` (TIMESTAMP)\n\n

## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE giá trị cấu hình nhập vào sai định dạng kiểu dữ liệu (ví dụ: chữ thay vì số), THE system SHALL hiển thị lỗi báo đỏ trên form.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Cập nhật phí phạt ngày: Thay đổi giá trị FINE_RATE_PER_DAY từ 5000 thành 10000 -> Lưu thành công, hệ thống tính phạt mới lập tức.\n- [ ] Manager sửa cấu hình hệ thống bảo mật: Manager cố tình sửa cấu hình ngoài nhóm cho phép -> Hệ thống báo lỗi từ chối phân quyền.

## 9. Out of Scope (Phạm vi không thực hiện)
* Xóa các tham số cấu hình hệ thống ra khỏi DB thông qua giao diện quản trị.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.
