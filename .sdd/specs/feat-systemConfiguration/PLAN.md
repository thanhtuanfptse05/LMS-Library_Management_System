# PLAN.md — Kế hoạch Thực thi Quản lý Cấu hình Hệ thống
# Trạng thái: DRAFT | Ngày tạo: 2026-06-20

## 1. ARCHITECTURAL APPROACH
Áp dụng mô hình Servlet MVC + DAO/Service Pattern chuẩn của dự án.

- **Tầng Cache:** `AppConfig` (singleton lưu trong `ServletContext`) là single source of truth cho toàn bộ cấu hình runtime. `AppContextListener` nạp cache khi khởi động; `SystemConfigServlet` reload cache sau mỗi lần cập nhật thành công.
- **Tầng Service:** `SystemConfigService` chịu trách nhiệm validate giá trị, gọi `SystemConfigDAO`, ghi Audit Log và reload cache — tất cả trong cùng một phương thức, không tách transaction riêng vì chỉ cập nhật một bảng duy nhất.
- **Tầng DAO:** `SystemConfigDAO` dùng `PreparedStatement` tuyệt đối. Không concatenate chuỗi SQL.
- **Tầng View:** Hai JSP riêng biệt — danh sách cấu hình (`system-config-list.jsp`) và form sửa inline hoặc modal (`system-config-edit.jsp`). Tuyệt đối không dùng Scriptlet Java.

---

## 2. COMPONENTS

| Component | Trách nhiệm | File |
|---|---|---|
| **SystemConfigServlet** | Router GET/POST: hiển thị danh sách, xử lý cập nhật, kiểm tra RBAC (chỉ MANAGER được POST) | `SystemConfigServlet.java` |
| **SystemConfigService** | Validate giá trị theo key, gọi DAO update, ghi Audit Log, gọi AppConfig.reload() | `SystemConfigService.java` |
| **SystemConfigDAO** | SELECT tất cả / SELECT theo group / UPDATE một key bằng PreparedStatement | `SystemConfigDAO.java` |
| **SystemConfig model** | POJO: configKey, configValue, description, configGroup, updatedBy, updaterName, updatedAt | `SystemConfiguration.java` |
| **AppConfig** | Singleton HashMap cache; methods: `load(conn)`, `reload(ctx)`, `getString(key)`, `getInt(key)`, `getDouble(key)` | `AppConfig.java` (hiện có, cần mở rộng) |
| **AppContextListener** | Gọi `AppConfig.load()` khi server khởi động | `AppContextListener.java` (hiện có, cần mở rộng) |
| **AuditLogDAO** | Ghi Audit Log cho mọi thao tác UPDATE cấu hình | `AuditLogDAO.java` (hiện có) |
| **system-config-list.jsp** | Hiển thị danh sách cấu hình nhóm theo configGroup, filter dropdown, bảng có nút Sửa (chỉ MANAGER) | `/web/manager/system-config-list.jsp` |
| **system-config-edit.jsp** (optional) | Form sửa giá trị một key, hiển thị mô tả và ràng buộc | `/web/manager/system-config-edit.jsp` |

---

## 3. DATA FLOW

### Luồng Xem Cấu hình (GET)
```
Manager/Admin browser
  → GET /manager/system-config
  → AuthFilter (kiểm tra role MANAGER hoặc ADMIN)
  → SystemConfigServlet.doGet()
  → SystemConfigService.getAllConfigs(groupFilter)
  → SystemConfigDAO.findAll() hoặc findByGroup(group)
    [SELECT sc.*, mp.fullName FROM SystemConfigurations sc
     LEFT JOIN "User" u ON sc.updatedBy = u.userId
     LEFT JOIN MemberProfile mp ON u.userId = mp.userId
     ORDER BY sc.configGroup, sc.configKey]
  → List<SystemConfiguration> → setAttribute("configs")
  → forward → system-config-list.jsp
```

### Luồng Cập nhật Cấu hình (POST — chỉ MANAGER)
```
Manager browser → POST /manager/system-config (configKey, configValue)
  → AuthFilter (kiểm tra role MANAGER; ADMIN → HTTP 403)
  → SystemConfigServlet.doPost()
  → SystemConfigService.updateConfig(configKey, newValue, managerId)
      1. Validate: key phải tồn tại trong whitelist cấu hình đã seed
      2. Validate: newValue theo kiểu dữ liệu của key (int/decimal/string)
      3. SystemConfigDAO.findByKey(configKey) → lấy oldValue
      4. SystemConfigDAO.update(configKey, newValue, managerId)
         [UPDATE SystemConfigurations SET configValue=?, updatedBy=?, updatedAt=NOW() WHERE configKey=?]
      5. AuditLogDAO.insert(managerId, 'UPDATE', 'SystemConfigurations', null, oldValues, newValues)
      6. AppConfig.reload(servletContext)  ← reload cache toàn bộ
  → redirect → /manager/system-config?success=true
  → flash message "Cập nhật thành công"
```

### Luồng Đọc Cache tại Nghiệp vụ khác
```
DeskCirculationService / FineService / ReservationService
  → AppConfig.getInt("max_borrow_days_student")  ← đọc từ cache trong memory
  → Không truy vấn DB thêm
```

---

## 4. VALIDATION RULES PER KEY

```java
// SystemConfigService hoặc SystemConfigValidator
Map<String, String> KEY_TYPES = Map.of(
    "max_borrow_days_student",   "POSITIVE_INT",
    "max_borrow_days_lecturer",  "POSITIVE_INT",
    "max_borrow_books_student",  "POSITIVE_INT",
    "max_borrow_books_lecturer", "POSITIVE_INT",
    "max_extension_count",       "NON_NEGATIVE_INT",
    "extension_days",            "POSITIVE_INT",
    "reservation_hold_days",     "POSITIVE_INT",
    "fine_per_day_overdue",      "NON_NEGATIVE_DECIMAL",
    "fine_lost_book_multiplier", "NON_NEGATIVE_DECIMAL",
    "fine_damaged_book_flat",    "NON_NEGATIVE_DECIMAL"
);
```
- `POSITIVE_INT`: số nguyên > 0
- `NON_NEGATIVE_INT`: số nguyên ≥ 0
- `NON_NEGATIVE_DECIMAL`: số thực ≥ 0.0

---

## 5. ACCESS CONTROL (RBAC)

| Role | GET (Xem) | POST (Sửa) |
|------|-----------|------------|
| MANAGER | ✅ Có | ✅ Có |
| ADMIN | ✅ Có (read-only UI) | ❌ HTTP 403 |
| LIBRARIAN | ❌ HTTP 403 | ❌ HTTP 403 |
| STUDENT / LECTURER | ❌ HTTP 403 | ❌ HTTP 403 |

- `AuthFilter` bảo vệ pattern `/manager/*` → tự động chặn STUDENT/LECTURER/LIBRARIAN.
- `SystemConfigServlet.doPost()` kiểm tra thêm `role.equals("MANAGER")` trước khi xử lý.

---

## 6. DATABASE CHANGES

- **Không thay đổi schema.** Bảng `SystemConfigurations` đã tồn tại đầy đủ theo schema.
- **Thêm Seed Data** vào file `LMS_Seed_Data_PostgreSQL.sql`:
  ```sql
  INSERT INTO SystemConfigurations (configKey, configValue, description, configGroup)
  VALUES
    ('max_borrow_days_student',    '14',    'Số ngày mượn tối đa cho sinh viên',              'library'),
    ('max_borrow_days_lecturer',   '30',    'Số ngày mượn tối đa cho giảng viên',             'library'),
    ('max_borrow_books_student',   '3',     'Số đầu sách mượn đồng thời tối đa cho sinh viên','library'),
    ('max_borrow_books_lecturer',  '5',     'Số đầu sách mượn đồng thời tối đa cho giảng viên','library'),
    ('max_extension_count',        '2',     'Số lần gia hạn tối đa mỗi lần mượn',            'library'),
    ('extension_days',             '7',     'Số ngày gia hạn mỗi lần',                        'library'),
    ('reservation_hold_days',      '3',     'Số ngày giữ sách đặt trước trước khi huỷ',       'library'),
    ('fine_per_day_overdue',       '2000',  'Tiền phạt mỗi ngày quá hạn (VNĐ)',              'fine'),
    ('fine_lost_book_multiplier',  '2.0',   'Hệ số nhân giá sách khi mất sách',              'fine'),
    ('fine_damaged_book_flat',     '50000', 'Tiền phạt cố định khi sách bị hỏng (VNĐ)',      'fine')
  ON CONFLICT (configKey) DO NOTHING;
  ```

---

## 7. FILE STRUCTURE (Các file cần tạo/sửa)

### [NEW] Tạo mới
- `src/java/model/SystemConfiguration.java` — POJO model
- `src/java/dao/SystemConfigDAO.java` — DAO layer
- `src/java/service/SystemConfigService.java` — Business logic + validation
- `src/java/controllers/SystemConfigServlet.java` — Servlet controller (`@WebServlet("/manager/system-config")`)
- `web/manager/system-config-list.jsp` — View danh sách cấu hình
- `web/manager/system-config-edit.jsp` — View form sửa (nếu không dùng inline edit)

### [MODIFY] Sửa đổi
- `src/java/config/AppConfig.java` — Thêm method `reload(ServletContext)`, `getInt(key)`, `getDouble(key)`, `getString(key)` nếu chưa có
- `src/java/config/AppContextListener.java` — Gọi `AppConfig.load(conn)` khi contextInitialized
- `database/supabase/LMS_Seed_Data_PostgreSQL.sql` — Thêm INSERT seed 10 config keys

---

## 8. RISKS & MITIGATIONS

| Rủi ro | Giảm thiểu |
|--------|-----------|
| Cache không được reload sau khi cập nhật → nghiệp vụ vẫn dùng giá trị cũ | Gọi `AppConfig.reload()` bắt buộc trong `SystemConfigService.updateConfig()` sau khi DAO commit thành công |
| Manager nhập sai giá trị (chuỗi thay vì số) gây lỗi tại nghiệp vụ khác | Validate chặt chẽ tại `SystemConfigService` trước khi lưu; từ chối và báo lỗi rõ ràng |
| Admin hoặc role khác cố POST cập nhật cấu hình | Double-check role tại cả `AuthFilter` (URL pattern) và `SystemConfigServlet.doPost()` (role check) |
| configKey bị giả mạo (key không trong whitelist) | So sánh configKey với `KEY_TYPES` whitelist; nếu không có → HTTP 400 |
| Thiếu Audit Log cho thao tác quan trọng | `SystemConfigService.updateConfig()` ghi AuditLog sau DAO.update() trước khi reload cache; nếu ghi log fail → log error nhưng không rollback cập nhật cấu hình |

---

## 9. QUESTIONS FOR HUMAN

1. **Admin có được sửa cấu hình không?** → Hiện tại đề xuất: Admin chỉ xem, MANAGER mới được sửa.
2. **Có cần trang lịch sử thay đổi cấu hình riêng không?** → Nếu cần, có thể đọc từ `AuditLogs` filter theo `entityName='SystemConfigurations'`.
3. **AppConfig hiện tại đã tồn tại và đọc cấu hình từ đâu?** → Cần kiểm tra `AppConfig.java` hiện có để tránh trùng lặp logic.
