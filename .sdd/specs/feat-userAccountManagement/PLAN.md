# PLAN.md — Execution Plan
# Version: 1.1.0 | Status: LOCKED
# Changelog: v1.1.0 — Refactor Import Flow thành 2-Phase (Pre-Validation + DB Transaction)

## 1. ARCHITECTURAL APPROACH
Sử dụng kiến trúc MVC thuần. Controller (`Servlet`) nhận request, điều phối sang Service (`UserService`) để xử lý logic (validate, parse Excel) và gọi DAO (`UserDAO`, `ProfileDAO`) thực thi truy vấn.

## 2. COMPONENTS ĐƯỢC TẠO/SỬA
| Component | Trách nhiệm | Interface/Class |
|-----------|-------------|-----------------|
| `UserListServlet` | GET danh sách người dùng. | `controller.admin.UserListServlet` |
| `UserDetailServlet` | GET chi tiết và POST Cập nhật/Khóa tài khoản. | `controller.admin.UserDetailServlet` |
| `UserCreateServlet` | POST Tạo mới tài khoản đơn lẻ. | `controller.admin.UserCreateServlet` |
| `UserImportServlet` | POST Parse Multipart file Excel và gọi Batch Insert. | `controller.admin.UserImportServlet` |
| `UserService` | Chứa logic quét trùng lặp, hash pass, bóc tách Excel. | `service.UserService` |
| `ExcelParserUtil` | Utility class wrap Apache POI để đọc file .xlsx. | `utils.ExcelParserUtil` |
| `UserDAO` | Các hàm `insert`, `update`, `batchInsertUser`. | `dao.UserDAO` |
| `ImportErrorDTO` | POJO Response-only, trả danh sách lỗi JSON cho Admin. | `dto.ImportErrorDTO` |

## 3. DATA FLOW (Luồng Import Bulk - 2-Phase Strategy)

### Phase 1 — Pre-Validation (RAM only, không chạm DB Transaction)
1. Request: POST `/admin/users/import` (Multipart data: file, role).
2. `UserImportServlet` gọi `ExcelParserUtil.parse(InputStream)`. Trả về `List<UserImportDTO>`.
3. `UserService.validateImportList(List, Role)` quét toàn bộ list:
   - **Local scan**: Dùng `HashSet` phát hiện email/code trùng lặp *trong file*.
   - **DB scan**: 1 lần query `SELECT email FROM [User] WHERE email IN (...)` và tương tự cho code để phát hiện trùng với DB.
   - **Format scan**: Kiểm tra regex email, số điện thoại, giá trị bắt buộc.
   - Trả về `List<ImportErrorDTO>`. Nếu list **không rỗng** → `UserImportServlet` trả HTTP 400 + JSON, dừng hẳn.

### Phase 2 — DB Transaction (chỉ chạy khi Phase 1 trả empty list)
4. `UserService.importUsers(List, Role)` gọi `UserDAO.batchInsertTransaction(List)`:
   - `connection.setAutoCommit(false);`
   - Vòng lặp 1: Batch Insert `[User]` → Lấy `GeneratedKeys` (userId).
   - Vòng lặp 2: Batch Insert `MemberProfile`.
   - Vòng lặp 3: Batch Insert `Student/Lecturer...`
   - `connection.commit();`
   - *SQLException tại bất kỳ bước nào* → `connection.rollback()` + HTTP 500.

## 4. DEPENDENCIES & RISKS
* **Dependencies**: Yêu cầu AuthFilter chặn quyền, chỉ cho ADMIN đi qua. Library Apache POI, jBcrypt.
* **Risk (Data Integrity)**: Batch Insert thất bại giữa chừng.
* **Mitigation**: Bắt buộc sử dụng Connection Transaction. Lỗi ở bất kỳ step nào phải gọi `connection.rollback()`.
