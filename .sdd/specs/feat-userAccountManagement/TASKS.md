# TASKS.md — Phân rã công việc
# Target Sprint: Sprint 2 | Risk: HIGH (Do Batch Insert) | Version: 1.1.0

| ID | Task Name | Files liên quan | Est | Deps | Definition of Done (DoD) |
|----|-----------|-----------------|-----|------|--------------------------|
| **T-UAM-01** | Tạo DTO & ExcelParserUtil | `dto/UserImportDTO.java`<br>`dto/ImportErrorDTO.java`<br>`utils/ExcelParserUtil.java` | 2h | None | Đọc thành công file `.xlsx` thành `List<UserImportDTO>`. Ném exception nếu sai format cột. `ImportErrorDTO` chứa đủ 4 trường: `row`, `field`, `errorCode`, `message`. |
| **T-UAM-02** | Implement DAO (CRUD) | `dao/UserDAO.java`<br>`dao/MemberProfileDAO.java` | 3h | None | Hoàn thành hàm `insert`, `update`, `findAll`, `findById`. 100% PreparedStatement. |
| **T-UAM-03** | Implement DAO (Batch Insert) | `dao/UserDAO.java` | 4h | T-02 | Hàm `batchInsertTransaction` lưu dữ liệu vào 3 bảng. Bắt buộc dùng `addBatch()`, `executeBatch()` và `conn.commit()`. |
| **T-UAM-04** | Implement UserService | `service/UserService.java` | 4h | T-01, T-03 | **(Phase 1)** Hàm `validateImportList()`: local HashSet scan + 1 lần DB batch-query, trả `List<ImportErrorDTO>` (empty = pass). **(Phase 2)** Hàm `importUsers()` chỉ gọi Transaction khi Phase 1 empty. Băm mật khẩu BCrypt cho toàn bộ list trước khi truyền sang DAO. |
| **T-UAM-05** | View/List/Update Servlets | `UserListServlet.java`<br>`UserDetailServlet.java` | 2h | T-04 | GET render danh sách. POST update thông tin và đổi `status` thành `locked` nếu có yêu cầu. |
| **T-UAM-06** | Create/Import Servlets | `UserCreateServlet.java`<br>`UserImportServlet.java` | 2h | T-04 | Xử lý Request, gọi Service. **Import**: Nếu `validateImportList()` trả list không rỗng → trả HTTP 400 với JSON `{ status, totalRows, errorCount, errors[] }`. **Create**: Catch exception trùng lặp → trả HTTP 400 JSON. Lỗi server → HTTP 500 (không lộ stack trace). |
| **T-UAM-07** | Xây dựng Views (JSP) | `users-list.jsp`<br>`user-form.jsp`<br>`user-import.jsp` | 3h | T-05, T-06 | Render UI có form tạo mới, form import (có dropdown chọn Role). Hiển thị Flash messages báo lỗi/thành công. |

*Lưu ý: Tasks được thiết kế bám sát ActivityDiagramF3. Không có Audit Log ở T-UAM-02 và T-UAM-03.*
*v1.1.0 — Import Flow cập nhật sang chiến lược 2-Phase: T-UAM-04 (+1h, est mới = 4h). T-UAM-01 bổ sung `ImportErrorDTO`. T-UAM-06 cập nhật DoD trả JSON array lỗi chi tiết. (Giải quyết GAP-01 & GAP-02)*
