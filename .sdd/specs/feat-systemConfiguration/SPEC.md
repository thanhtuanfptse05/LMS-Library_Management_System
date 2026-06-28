# SPEC.md — Quản lý Cấu hình Hệ thống (System Configuration)
# Version: 0.1 (DRAFT) | Owner: @tech-lead | Status: DRAFT | Ngày khởi tạo: 2026-06-20
# Mapping: UC-32, UC-33 | BR-30, BR-31 | FR: (xem chi tiết: FR-SC-01..FR-SC-14)
# Cross-ref: BR-SC-01 và BR-SC-07 = BR-30 (toàn cục) | BR-SC-03 = BR-31 (toàn cục)

## 1. Context & Goal
Tính năng này cho phép **Library Manager** xem và cập nhật các thông số vận hành của hệ thống thư viện (chính sách mượn sách, tiền phạt, giới hạn mượn, số lần gia hạn, v.v.) thông qua giao diện quản trị mà không cần can thiệp vào mã nguồn hay CSDL thủ công.

Mọi giá trị cấu hình được lưu tập trung trong bảng `SystemConfigurations` với cấu trúc key-value và nhóm (`configGroup`). Hệ thống tải cấu hình một lần khi khởi động và cache để sử dụng xuyên suốt các tính năng nghiệp vụ như tính phạt (F3), mượn sách (F6), gia hạn (F5).

---

## 2. Actors & Roles
- **Library Manager (MANAGER):** Xem và CRUD cấu hình thuộc nhóm `library` (chính sách mượn/gia hạn/đặt trước). Truy cập qua route `/manager/system-config`. **Không được phép** đọc hoặc sửa các nhóm cấu hình khác (`fine`, `notification`, `system`).
- **Admin (ADMIN):** Toàn quyền CRUD tất cả cấu hình thuộc mọi nhóm (`library`, `fine`, `notification`, `system`). Truy cập qua route `/admin/system-config`.
- **Librarian / Student / Lecturer:** Không được phép truy cập bất kỳ trang cấu hình hệ thống nào; bị chặn bởi `AuthFilter` và trả về HTTP 403.
- **Các Servlet nghiệp vụ khác** (DeskCirculationService, FineService, ReservationService): Đọc cấu hình từ `SystemConfigCache` (lưu trong `ServletContext`); không được phép ghi trực tiếp bảng `SystemConfigurations`.

---

## 3. Business Rules (Quy tắc nghiệp vụ)

* **[BR-SC-01]:** Bảng `SystemConfigurations` dùng `configKey` làm Primary Key (VARCHAR). Không được phép tạo hoặc xóa key tuỳ tiện qua UI; chỉ được **cập nhật** `configValue` của các key đã tồn tại.
* **[BR-SC-02]:** Mỗi `configKey` thuộc một nhóm (`configGroup`) cụ thể: `library` (chính sách thư viện), `fine` (tiền phạt), `notification` (email/thông báo), `system` (tham số hệ thống).
* **[BR-SC-03]:** Phân quyền theo `configGroup`:
  - **Library Manager (MANAGER):** Chỉ được xem và CRUD các key thuộc `configGroup = 'library'`. Các nhóm khác bị ẩn hoàn toàn và bị từ chối tại tầng Service nếu cố gửi request.
  - **Admin (ADMIN):** Được xem và CRUD tất cả các key thuộc mọi `configGroup`.
* **[BR-SC-04]:** Giá trị `configValue` phải được validate theo kiểu dữ liệu mong đợi của từng key trước khi lưu (số nguyên dương, số nguyên không âm, số thực không âm).
* **[BR-SC-05]:** Mọi cập nhật cấu hình phải ghi Audit Log vào bảng `AuditLogs` với `actionType = 'UPDATE_SYSTEM_CONFIG'`, `oldValues` và `newValues` dạng JSON.
* **[BR-SC-06]:** Sau khi cập nhật thành công, hệ thống phải reload `SystemConfigCache` ngay lập tức (không cần restart server) để các nghiệp vụ khác áp dụng giá trị mới tức thì.
* **[BR-SC-07]:** Không được phép Soft-delete hay Hard-delete bất kỳ `configKey` nào qua UI. Cấu hình chỉ được INSERT khi seeding dữ liệu ban đầu.
* **[BR-SC-08]:** Trường `updatedBy` phải lưu `userId` của người đang đăng nhập; `updatedAt` tự động set bằng `NOW()` tại câu UPDATE.
* **[BR-SC-09]:** Các key cấu hình cốt lõi phải được seed sẵn trong CSDL (14 keys, 4 nhóm):

  | configKey                      | configGroup  | Kiểu       | Mô tả                                                | Giá trị mặc định |
  |-------------------------------|--------------|------------|------------------------------------------------------|------------------|
  | `STUDENT_MAX_BORROW_DAYS`     | `library`    | INT > 0    | Số ngày mượn tối đa cho sinh viên                    | 14               |
  | `LECTURER_MAX_BORROW_DAYS`    | `library`    | INT > 0    | Số ngày mượn tối đa cho giảng viên                   | 30               |
  | `STUDENT_MAX_BORROW_LIMIT`    | `library`    | INT > 0    | Số đầu sách mượn đồng thời tối đa (sinh viên)        | 5                |
  | `LECTURER_MAX_BORROW_LIMIT`   | `library`    | INT > 0    | Số đầu sách mượn đồng thời tối đa (giảng viên)       | 15               |
  | `MAX_EXTENSION_COUNT`         | `library`    | INT ≥ 0    | Số lần gia hạn tối đa mỗi lần mượn                  | 3                |
  | `RENEW_DURATION_DAYS`         | `library`    | INT > 0    | Số ngày gia hạn mỗi lần                              | 14               |
  | `RESERVATION_HOLD_DAYS`       | `library`    | INT > 0    | Số ngày giữ sách đặt trước trước khi huỷ tự động    | 3                |
  | `FINE_RATE_PER_DAY`           | `library`    | DEC ≥ 0    | Tiền phạt mỗi ngày quá hạn (VNĐ)                    | 5000             |
  | `LOST_FINE_MULTIPLIER`        | `library`    | DEC ≥ 0    | Hệ số nhân giá sách khi mất sách                    | 2.0              |
  | `DAMAGED_FINE_MULTIPLIER`     | `library`    | DEC ≥ 0    | Hệ số nhân giá sách khi sách bị hỏng                 | 2.0              |
  | `DEFAULT_BOOK_PRICE`          | `library`    | DEC ≥ 0    | Giá mặc định của sách khi không có giá gốc (VND)     | 500000           |
  | `EMAIL_OTP_EXPIRE_MINUTES`    | `system`     | INT > 0    | Thời gian hết hạn OTP qua email (phút)               | 10               |
  | `EMAIL_OVERDUE_NOTICE_DAYS`   | `system`     | INT > 0    | Số ngày trước khi quá hạn để gửi email nhắc          | 1                |
  | `MAX_IMPORT_ROWS`             | `system`     | INT > 0    | Số BookCopy tối đa trong một file import             | 5000             |
  | `IMPORT_EXPIRE_DAYS`          | `system`     | INT > 0    | Số ngày lưu lịch sử import                           | 365              |

---

## 4. Functional Requirements (Yêu cầu chức năng — EARS Notation)

### 4.1 Xem Cấu hình Hệ thống
- **[FR-SC-01]:** WHEN Library Manager truy cập `/manager/system-config`, THE system SHALL chỉ hiển thị danh sách các key thuộc `configGroup = 'library'`, bao gồm `configKey`, `configValue`, `description`, người cập nhật cuối, thời điểm cập nhật cuối.
- **[FR-SC-02]:** WHEN Admin truy cập `/admin/system-config`, THE system SHALL hiển thị toàn bộ danh sách cấu hình của mọi nhóm, có dropdown lọc theo `configGroup`.
- **[FR-SC-03]:** WHILE hiển thị danh sách, THE system SHALL hiển thị badge màu theo nhóm: `library`=xanh lá, `fine`=vàng, `notification`=xanh lam, `system`=xám.

### 4.2 Cập nhật Cấu hình
- **[FR-SC-04]:** WHEN Library Manager gửi yêu cầu cập nhật key, THE system SHALL kiểm tra `configGroup` của key tại Service layer: nếu group ≠ `library` → từ chối `ValidationException` dù request có vẻ hợp lệ.
- **[FR-SC-05]:** WHEN Admin gửi yêu cầu cập nhật bất kỳ key nào, THE system SHALL cho phép với điều kiện giá trị hợp lệ theo kiểu dữ liệu.
- **[FR-SC-06]:** WHERE `configValue` hợp lệ và quyền được xác nhận, THE system SHALL thực thi `UPDATE SystemConfigurations SET configValue = ?, updatedBy = ?, updatedAt = NOW() WHERE configKey = ?` bằng `PreparedStatement`.
- **[FR-SC-07]:** WHERE `configValue` không hợp lệ (sai định dạng, giá trị âm, v.v.), THE system SHALL từ chối lưu và hiển thị thông báo lỗi cụ thể.
- **[FR-SC-08]:** WHEN cập nhật thành công, THE system SHALL ghi Audit Log vào `AuditLogs` với `actionType = 'UPDATE_SYSTEM_CONFIG'`, `entityName = 'SystemConfigurations'`, `entityId = NULL`, `oldValues` và `newValues` dạng JSON.
- **[FR-SC-09]:** WHEN cập nhật thành công, THE system SHALL gọi `SystemConfigCache.reload(servletContext)` để giá trị mới có hiệu lực ngay mà không cần restart server.

### 4.3 Phân quyền và Bảo mật
- **[FR-SC-10]:** WHERE người dùng không có role `MANAGER` cố truy cập `/manager/system-config`, THE system SHALL chặn bởi `AuthFilter` và trả về HTTP 403.
- **[FR-SC-11]:** WHERE người dùng không có role `ADMIN` cố truy cập `/admin/system-config`, THE system SHALL chặn bởi `AuthFilter` và trả về HTTP 403.
- **[FR-SC-12]:** WHERE Library Manager cố gửi POST cập nhật key thuộc nhóm `fine`/`notification`/`system` (bypass UI), THE system SHALL từ chối tại Service layer với thông báo "Bạn không có quyền chỉnh sửa nhóm cấu hình này."

### 4.4 Tích hợp Cache & Reload
- **[FR-SC-13]:** WHEN ứng dụng khởi động (`AppContextListener.contextInitialized()`), THE system SHALL nạp toàn bộ cấu hình từ `SystemConfigurations` vào `SystemConfigCache` (lưu trong `ServletContext` attribute).
- **[FR-SC-14]:** WHEN cập nhật thành công tại Servlet, THE system SHALL gọi `SystemConfigCache.reload(servletContext)` để đồng bộ cache toàn bộ cấu hình.

---

## 5. Non-functional Requirements

- **Bảo mật (SEC-01/SEC-03):** Tuyệt đối dùng `PreparedStatement` cho mọi câu SQL liên quan `SystemConfigurations`. Không concatenate chuỗi SQL.
- **Phân quyền (SEC-02):** `AuthFilter` phải bảo vệ đường dẫn `/manager/system-config*`. Role khác ngoài `MANAGER` bị chặn hoàn toàn; `ADMIN` chỉ xem, không sửa.
- **Audit Log (ARCH-02):** Mọi thao tác cập nhật `configValue` phải ghi `AuditLogs` với `oldValues` / `newValues`.
- **Hiệu năng:** Trang liệt kê cấu hình (< 20 rows) phải phản hồi dưới 300ms (P95).
- **Cache Invalidation:** Sau mỗi lần cập nhật thành công, cache phải được reload trong cùng request để nghiệp vụ tiếp theo đọc giá trị mới nhất.
- **Ngôn ngữ UI (UI-01):** Toàn bộ giao diện, nhãn, thông báo lỗi/thành công phải bằng **tiếng Việt**.
- **Responsive:** Giao diện tương thích tốt trên Chrome, Edge, Firefox.

---

## 6. Database Schema & Data Models

### Bảng `SystemConfigurations`
| Cột           | Kiểu dữ liệu      | Ràng buộc                           | Mô tả                              |
|---------------|-------------------|-------------------------------------|------------------------------------|
| `configKey`   | VARCHAR(255)      | PRIMARY KEY                         | Tên khóa cấu hình (duy nhất)       |
| `configValue` | TEXT              | NULL cho phép                       | Giá trị cấu hình (text)            |
| `description` | TEXT              | NULL cho phép                       | Mô tả ý nghĩa của cấu hình         |
| `configGroup` | VARCHAR(50)       | NOT NULL, DEFAULT 'library'         | Nhóm cấu hình                      |
| `updatedBy`   | INT               | FK → `"User"(userId)`, NULL cho phép| ID người cập nhật cuối              |
| `updatedAt`   | TIMESTAMP         | DEFAULT NOW()                       | Thời điểm cập nhật cuối            |

### Model Java tương ứng: `SystemConfiguration.java`
```java
// src/java/model/SystemConfiguration.java
private String configKey;
private String configValue;
private String description;
private String configGroup;
private Integer updatedBy;    // nullable
private String updaterName;   // JOIN từ MemberProfile.fullName (dùng trong view)
private Timestamp updatedAt;  // nullable
```

---

## 7. Error Handling

- **WHERE** `configValue` không hợp lệ (ví dụ: nhập chữ cho trường số), **THE system SHALL** hiển thị flash message báo lỗi bằng tiếng Việt và giữ nguyên form với giá trị người dùng vừa nhập.
- **WHERE** `DatabaseException` xảy ra khi UPDATE, **THE system SHALL** ghi log lỗi, KHÔNG in stack trace ra giao diện, và hiển thị thông báo "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau."
- **WHERE** `configKey` không tồn tại trong CSDL (giả mạo request), **THE system SHALL** trả về HTTP 400 với thông báo "Khóa cấu hình không hợp lệ."
- **WHERE** người dùng không được phân quyền sửa cấu hình, **THE system SHALL** trả về HTTP 403 mà không thực hiện bất kỳ thay đổi nào.

---

## 8. Acceptance Criteria

- [ ] [TC-SC-01] Library Manager mở `/manager/system-config`: chỉ thấy 7 key thuộc nhóm `library`, không thấy key nhóm `fine`/`notification`/`system`.
- [ ] [TC-SC-02] Library Manager cập nhật `max_borrow_days_student` từ 14 → 21 (hợp lệ): lưu thành công, flash "Cập nhật cấu hình thành công!".
- [ ] [TC-SC-03] Audit Log ghi `actionType='UPDATE_SYSTEM_CONFIG'`, `oldValues={"max_borrow_days_student":"14"}`, `newValues={"max_borrow_days_student":"21"}`.
- [ ] [TC-SC-04] Library Manager cập nhật `max_borrow_days_student` → `-1`: từ chối, flash lỗi "Giá trị phải là số nguyên dương".
- [ ] [TC-SC-05] Library Manager cập nhật `max_borrow_days_student` → `abc`: từ chối, flash lỗi định dạng.
- [ ] [TC-SC-06] Library Manager gửi POST với `configKey=fine_per_day_overdue` (bypass UI): Service từ chối với thông báo "Bạn không có quyền chỉnh sửa nhóm cấu hình này."
- [ ] [TC-SC-07] Admin mở `/admin/system-config`: thấy tất cả 14 key thuộc 4 nhóm, có dropdown lọc theo nhóm, badge màu theo nhóm.
- [ ] [TC-SC-08] Admin cập nhật `fine_per_day_overdue` → 3000: lưu thành công, AuditLog ghi đúng.
- [ ] [TC-SC-09] Admin cập nhật `max_import_rows` → `abc`: từ chối, flash lỗi định dạng.
- [ ] [TC-SC-10] Sau cập nhật: `SystemConfigCache.reload()` được gọi → nghiệp vụ đọc giá trị mới không cần restart Tomcat.
- [ ] [TC-SC-11] LIBRARIAN/STUDENT/LECTURER truy cập `/manager/system-config`: AuthFilter trả HTTP 403.
- [ ] [TC-SC-12] MANAGER truy cập `/admin/system-config`: AuthFilter trả HTTP 403.
- [ ] [TC-SC-13] Toàn bộ text giao diện (nhãn, nút, thông báo) hiển thị bằng tiếng Việt.

---

## 9. Out of Scope

- Không thực hiện thêm mới (`INSERT`) hay xóa (`DELETE`) `configKey` qua giao diện UI — chỉ thực hiện qua seed script.
- Không xây dựng giao diện lịch sử thay đổi cấu hình trong sprint này (Audit Log xem qua phân hệ Admin riêng).
- Không tích hợp cơ chế phân môi trường (dev/staging/production config).
- Không validate cross-key (ví dụ: `max_borrow_days_lecturer` ≥ `max_borrow_days_student`) — để sprint sau.
- Library Manager KHÔNG được thay đổi `configGroup` của bất kỳ key nào.

---

## Notes & Open Questions

1. **Cache granularity:** Reload toàn bộ (< 20 rows, overhead thấp) — không cần reload từng key riêng.
2. **Admin sidebar:** Cần xác nhận vị trí thêm mục "Cấu hình Hệ thống" vào sidebar admin hiện tại.
3. **Validation rules:** Hard-code `Map<String, String> KEY_TYPES` trong `SystemConfigService` — 14 entries dùng `Map.ofEntries()` thay `Map.of()` (giới hạn 10 entries).
