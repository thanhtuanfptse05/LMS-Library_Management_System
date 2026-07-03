# Feature Specification: Cấu hình hệ thống (System Configuration)
# Version: 1.0 | Chủ sở hữu: @antigravity | Ngày khởi tạo: 2026-07-03

## 1. Context & Goal (Ngữ cảnh & Mục tiêu)
Cho phép thay đổi các thông số vận hành của hệ thống như chính sách mượn sách, tiền phạt, giới hạn gia hạn và thông tin cổng thanh toán SePay trực tiếp thông qua giao diện quản trị.

## 2. Actors & Roles (Tác nhân & Quyền hạn)
* **Quản lý Thư viện (Library Manager):** Xem và cập nhật các cấu hình nghiệp vụ thư viện và SePay.
* **Quản trị viên (Admin):** Có toàn quyền xem và cập nhật tất cả các cấu hình hệ thống.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-32 (View System Configuration):** Actor: Library Manager, Admin | (Xem cấu hình hệ thống): Quản lý thư viện hoặc quản trị viên xem các thông số vận hành của hệ thống như chính sách mượn sách, tiền phạt, giới hạn.
* **UC-33 (Update System Configuration):** Actor: Library Manager, Admin | (Cập nhật cấu hình hệ thống): Thay đổi các thông số vận hành thông qua giao diện quản trị mà không cần can thiệp mã nguồn.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-32 (View System Configuration):** Actor: Library Manager, Admin | (Xem cấu hình hệ thống): Quản lý thư viện hoặc quản trị viên xem các thông số vận hành của hệ thống như chính sách mượn sách, tiền phạt, giới hạn.
* **UC-33 (Update System Configuration):** Actor: Library Manager, Admin | (Cập nhật cấu hình hệ thống): Thay đổi các thông số vận hành thông qua giao diện quản trị mà không cần can thiệp mã nguồn.

## 2.5 Use Cases (Danh sách Use Cases)
* **UC-32 (View System Configuration):** Actor: Library Manager, Admin | (Xem cấu hình hệ thống): Quản lý thư viện hoặc quản trị viên xem các thông số vận hành của hệ thống như chính sách mượn sách, tiền phạt, giới hạn.
* **UC-33 (Update System Configuration):** Actor: Library Manager, Admin | (Cập nhật cấu hình hệ thống): Thay đổi các thông số vận hành thông qua giao diện quản trị mà không cần can thiệp mã nguồn.

## 3. Business Rules (Quy tắc nghiệp vụ)
* **BR-30 (System Config Immutability):** Cấm tuyệt đối việc xóa cấu hình (delete configKey) thông qua UI hoặc hệ thống dưới mọi hình thức. Hệ thống chỉ cho phép cập nhật (UPDATE) giá trị configValue của các key đã tồn tại, hoặc thêm mới (INSERT) đối với các key thuộc whitelist (KEY_TYPES) chưa tồn tại trong CSDL.
* **BR-31 (System Config Authorization):** Library Manager chỉ được phép xem và cập nhật các config thuộc nhóm 'library' hoặc cấu hình tích hợp SePay. Admin có toàn quyền với mọi nhóm config.

## 4. Functional Requirements (Yêu cầu chức năng chi tiết)
* **FR-84 (Xem cấu hình nhóm library của Manager):** WHEN SystemConfigServlet.doGet() được gọi bởi MANAGER, THE system SHALL truy vấn SystemConfigDAO.findByGroup(conn, "library") để lấy danh sách các cấu hình chính sách mượn/trả và đặt trước, sau đó forward sang manager/system-config-list.jsp.
  * *Mapping:* UC-32 / BR-31
* **FR-85 (Xem toàn bộ cấu hình của Admin):** WHEN AdminSystemConfigServlet.doGet() được gọi bởi ADMIN, THE system SHALL lấy toàn bộ cấu hình hệ thống từ DB, hỗ trợ lọc theo nhóm thông qua query parameter 'group', sau đó forward sang admin/system-config-list.jsp.
  * *Mapping:* UC-32 / BR-31
* **FR-86 (Cập nhật cấu hình hệ thống):** WHEN SystemConfigServlet hoặc AdminSystemConfigServlet nhận POST cập nhật, THE system SHALL gọi SystemConfigService.update(key, value, actorId, role) để: (1) Kiểm tra key có trong whitelist (KEY_TYPES), (2) Xác thực giá trị hợp lệ theo kiểu dữ liệu quy định, (3) Chặn Manager nếu cố ý sửa các key nhóm khác (ngoại trừ sepay), (4) Thực thi UPDATE câu lệnh SQL, ghi Audit Log và reload cache config.
  * *Mapping:* UC-33 / BR-30, BR-31, BR-40
* **FR-87 (Thêm mới cấu hình whitelist):** WHEN Servlet nhận POST thêm mới (action=create), THE system SHALL gọi SystemConfigService.create() để kiểm tra key có trong whitelist và chưa tồn tại trong CSDL. THEN thực hiện INSERT vào bảng SystemConfigurations, ghi Audit Log, và reload cache.
  * *Mapping:* UC-33 / BR-30, BR-40
* **FR-88 (Bảo mật chặn xóa cấu hình):** WHEN SystemConfigServlet nhận POST xóa cấu hình (action=delete), THE system SHALL ném ra lỗi ValidationException "Cấm tuyệt đối việc xóa cấu hình khỏi hệ thống" và chặn đứng mọi hoạt động xóa dữ liệu.
  * *Mapping:* UC-33 / BR-30
* **FR-89 (Hiển thị màu badge nhóm cấu hình):** WHEN kết xuất danh sách cấu hình trên JSP, THE system SHALL render class CSS tương ứng để tạo badge màu: library=green, fine=yellow, notification=blue, system=gray.
  * *Mapping:* UC-32
* **FR-90 (Phân quyền AuthFilter cấu hình Manager):** WHERE người dùng không có vai trò MANAGER cố tình truy cập `/manager/system-config`, THE system SHALL chặn lại tại AuthFilter và trả về lỗi SC_FORBIDDEN (403).
  * *Mapping:* UC-32 / BR-31
* **FR-91 (Phân quyền AuthFilter cấu hình Admin):** WHERE người dùng không có vai trò ADMIN cố tình truy cập `/admin/system-config`, THE system SHALL chặn lại tại AuthFilter và trả về lỗi SC_FORBIDDEN (403).
  * *Mapping:* UC-32 / BR-31
* **FR-92 (Chặn sửa đổi chéo nhóm config):** WHERE Manager cố ý chỉnh sửa key cấu hình thuộc nhóm system/fine/notification thông qua giả lập request, THE system SHALL phát hiện tại Service layer và trả về lỗi "Bạn không có quyền chỉnh sửa nhóm cấu hình này."
  * *Mapping:* UC-33 / BR-31
* **FR-93 (Khởi động nạp Cache cấu hình):** WHEN ứng dụng khởi động (AppContextListener.contextInitialized), THE system SHALL gọi SystemConfigCache.reload() để nạp toàn bộ cặp key-value từ bảng SystemConfigurations vào bộ nhớ ServletContext.
  * *Mapping:* UC-32
* **FR-94 (Đồng bộ cache tức thời khi update):** WHEN cập nhật hoặc thêm mới cấu hình thành công, THE system SHALL gọi ngay SystemConfigCache.reload(ctx) để làm mới giá trị lưu trữ trong bộ nhớ RAM, phục vụ các nghiệp vụ mượn trả tức thì.
  * *Mapping:* UC-33 / BR-30
* **FR-95 (Validation kiểu dữ liệu số nguyên dương):** WHERE configKey yêu cầu kiểu POSITIVE_INT, THE system SHALL validate value phải parse được thành số nguyên lớn hơn 0; ngược lại ném lỗi ValidationException.
  * *Mapping:* UC-33 / BR-40
* **FR-96 (Validation kiểu dữ liệu số nguyên không âm):** WHERE configKey yêu cầu kiểu NON_NEGATIVE_INT, THE system SHALL validate value phải parse được thành số nguyên lớn hơn hoặc bằng 0; ngược lại ném lỗi.
  * *Mapping:* UC-33 / BR-40
* **FR-97 (Validation kiểu dữ liệu số thực không âm):** WHERE configKey yêu cầu kiểu NON_NEGATIVE_DECIMAL, THE system SHALL validate value phải parse được thành số thực lớn hơn hoặc bằng 0; ngược lại ném lỗi.
  * *Mapping:* UC-33 / BR-40

## 5. Non-functional Requirements (Yêu cầu phi chức năng)
* Hiệu năng: Đọc cấu hình từ cache RAM nên thời gian đáp ứng gần như bằng 0ms.
* Ràng buộc dữ liệu: Thực hiện kiểm tra kiểu dữ liệu nghiêm ngặt trước khi cập nhật DB.

## 6. Database Schema & Data Models (Lược đồ dữ liệu)
### Bảng SystemConfigurations
* `configKey` (VARCHAR(100), PK)
* `configValue` (TEXT)
* `description` (TEXT)
* `configGroup` (VARCHAR(50))
* `updatedBy` (INT)
* `updatedAt` (TIMESTAMP)



## 7. Error Handling (Xử lý lỗi ngoại lệ)
* WHERE giá trị cấu hình nhập vào sai định dạng kiểu dữ liệu (ví dụ: chữ thay vì số), THE system SHALL hiển thị lỗi báo đỏ trên form.

## 8. Acceptance Criteria (Tiêu chí nghiệm thu)
- [ ] Cập nhật phí phạt ngày: Thay đổi giá trị FINE_RATE_PER_DAY từ 5000 thành 10000 -> Lưu thành công, hệ thống tính phạt mới lập tức.
- [ ] Manager sửa cấu hình hệ thống bảo mật: Manager cố tình sửa cấu hình ngoài nhóm cho phép -> Hệ thống báo lỗi từ chối phân quyền.

## 9. Out of Scope (Phạm vi không thực hiện)
* Xóa các tham số cấu hình hệ thống ra khỏi DB thông qua giao diện quản trị.

## Notes & Open Questions (Ghi chú & Câu hỏi mở)
* Hiện tại toàn bộ chức năng đã được cài đặt khớp với thiết kế mã nguồn thực tế.