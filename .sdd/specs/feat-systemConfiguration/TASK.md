# TASK.md — Danh sách Task Thực thi: feat-systemConfiguration
# Version: 0.1 | Trạng thái: PENDING | Ngày tạo: 2026-06-20

## Ghi chú thực thi
- Thực hiện tuần tự theo thứ tự dependency (từ trên xuống dưới).
- Mỗi task phải pass Acceptance Criteria tương ứng trước khi chuyển sang task tiếp theo.
- Ký hiệu: `[ ]` chưa làm | `[/]` đang làm | `[x]` hoàn thành | `[!]` bị block

---

## PHASE 0 — Chuẩn bị & Kiểm tra

- [ ] **TASK-SC-00:** Đọc `AppConfig.java` hiện có để xác định các method đã có (`getString`, `getInt`, v.v.) và cơ chế load hiện tại — tránh trùng lặp.
- [ ] **TASK-SC-01:** Đọc `AppContextListener.java` hiện có để xác định điểm hook `contextInitialized`.
- [ ] **TASK-SC-02:** Kiểm tra `AuthFilter.java` để xác nhận pattern `/manager/*` đã được bảo vệ.

---

## PHASE 1 — Data Layer

- [ ] **TASK-SC-10:** Tạo `src/java/model/SystemConfiguration.java`
  - Fields: `configKey`, `configValue`, `description`, `configGroup`, `updatedBy` (Integer nullable), `updaterName` (String, từ JOIN), `updatedAt` (Timestamp nullable)
  - Getter/Setter đầy đủ, constructor đầy đủ và constructor mặc định.

- [ ] **TASK-SC-11:** Tạo `src/java/dao/SystemConfigDAO.java`
  - `List<SystemConfiguration> findAll(Connection conn)` — SELECT JOIN MemberProfile để lấy `updaterName`, ORDER BY `configGroup`, `configKey`
  - `List<SystemConfiguration> findByGroup(Connection conn, String group)` — thêm WHERE `configGroup = ?`
  - `SystemConfiguration findByKey(Connection conn, String key)` — SELECT WHERE `configKey = ?`
  - `void update(Connection conn, String key, String value, int updatedBy)` — UPDATE PreparedStatement

- [ ] **TASK-SC-12:** Mở rộng `src/java/config/AppConfig.java`
  - Thêm method `reload(ServletContext ctx)` — mở connection, gọi `SystemConfigDAO.findAll()`, cập nhật internal Map, đóng connection
  - Đảm bảo các method `getString(key)`, `getInt(key)`, `getDouble(key)` an toàn với null (trả về default nếu key không có)

- [ ] **TASK-SC-13:** Mở rộng `src/java/config/AppContextListener.java`
  - Trong `contextInitialized()`: tạo Connection, gọi `AppConfig.reload(ctx)`, đóng Connection

- [ ] **TASK-SC-14:** Thêm Seed Data vào `database/supabase/LMS_Seed_Data_PostgreSQL.sql`
  - 10 config keys theo BR-SC-08 với `ON CONFLICT (configKey) DO NOTHING`

---

## PHASE 2 — Business Logic

- [ ] **TASK-SC-20:** Tạo `src/java/service/SystemConfigService.java`
  - `List<SystemConfiguration> getConfigs(String groupFilter)` — gọi DAO, trả về list
  - `void updateConfig(String key, String newValue, int managerId, ServletContext ctx)` — validate → DAO.findByKey (oldValue) → DAO.update → AuditLogDAO.insert → AppConfig.reload(ctx)
  - Private `validateValue(String key, String value)` — kiểm tra theo `KEY_TYPES` map (POSITIVE_INT, NON_NEGATIVE_INT, NON_NEGATIVE_DECIMAL)
  - Ném `ValidationException` nếu sai định dạng; ném `DatabaseException` nếu SQLException

---

## PHASE 3 — Controller

- [ ] **TASK-SC-30:** Tạo `src/java/controllers/SystemConfigServlet.java`
  - `@WebServlet("/manager/system-config")`
  - `doGet()`: lấy param `group` (optional) → `SystemConfigService.getConfigs()` → setAttribute → forward `system-config-list.jsp`
  - `doPost()`: kiểm tra role `MANAGER` (nếu không → HTTP 403) → đọc `configKey`, `configValue` → gọi `SystemConfigService.updateConfig()` → redirect với flash message
  - Xử lý `ValidationException` → redirect kèm thông báo lỗi
  - Xử lý `DatabaseException` → redirect kèm thông báo lỗi hệ thống

---

## PHASE 4 — View (JSP)

- [ ] **TASK-SC-40:** Tạo `web/manager/system-config-list.jsp`
  - Include header/sidebar (`<jsp:include>`)
  - Dropdown filter theo `configGroup` (library, fine, notification, system)
  - Bảng hiển thị: STT, Tên key, Giá trị, Mô tả, Nhóm, Người cập nhật, Thời gian cập nhật
  - Nút "Sửa" chỉ hiển thị nếu `role == MANAGER` (dùng JSTL `<c:if>`)
  - Flash message thành công/thất bại (dùng JSTL `<c:if test="${not empty param.success}">`)
  - Toàn bộ text bằng tiếng Việt

- [ ] **TASK-SC-41:** Tạo `web/manager/system-config-edit.jsp` (hoặc dùng modal inline trong list.jsp)
  - Form POST tới `/manager/system-config`
  - Hidden field `configKey`
  - Input text `configValue` (hiển thị giá trị hiện tại)
  - Hiển thị `description` và ràng buộc hợp lệ của key
  - Nút "Lưu" và "Hủy"
  - Toàn bộ text bằng tiếng Việt

---

## PHASE 5 — Testing

- [ ] **TASK-SC-50:** Viết Unit Test cho `SystemConfigService`
  - Test case: validate POSITIVE_INT với giá trị hợp lệ → pass
  - Test case: validate POSITIVE_INT với giá trị âm → ném ValidationException
  - Test case: validate POSITIVE_INT với chuỗi chữ → ném ValidationException
  - Test case: validate NON_NEGATIVE_DECIMAL với "0.0" → pass
  - Test case: key không trong whitelist → ném ValidationException

- [ ] **TASK-SC-51:** Viết Integration Test cho `SystemConfigDAO` (nếu môi trường cho phép kết nối DB test)
  - Test `findAll()` trả về list không rỗng sau khi seed
  - Test `update()` cập nhật đúng giá trị và `updatedBy`, `updatedAt`
  - Test `findByKey()` với key tồn tại và không tồn tại

- [ ] **TASK-SC-52:** Manual Acceptance Test theo TC-SC-01 đến TC-SC-11 trong SPEC.md

---

## PHASE 6 — Review & Commit

- [ ] **TASK-SC-60:** Kiểm tra tất cả Acceptance Criteria trong SPEC.md đã pass.
- [ ] **TASK-SC-61:** Xóa mọi `System.out.println` debug và comment `TODO` trong code.
- [ ] **TASK-SC-62:** Commit theo convention: `feat(system-config): implement system configuration management`
- [ ] **TASK-SC-63:** Cập nhật `CHANGELOG.md` cho tính năng này.
