# PLAN.md — Kế hoạch Thực thi Bảo trì sách và Kiểm kê
# Trạng thái: APPROVED | Cập nhật: 2026-07-09

## 1. ARCHITECTURAL APPROACH
Áp dụng Servlet MVC + Service + JDBC DAO. Service sở hữu transaction, khóa hàng, xác thực state transition, đồng bộ BookCopy/Book và ghi Audit Log. Controller chỉ parse action, gọi Service, đặt flash message và forward/redirect JSP.

## 2. COMPONENTS
| Component | Trách nhiệm | Interface/Class |
| --- | --- | --- |
| IncidentController | Danh sách/filter/detail và action report/investigate/resolve/reject/restore/removeFromInventory. | `BookCopyIncidentServlet.java` |
| InventoryController | Danh sách/chi tiết phiên và 8 action kiểm kê. | `InventoryReconciliationServlet.java` |
| IncidentService | State machine incident, BookCopy, tồn kho và Audit Log. | `BookCopyIncidentService.java` |
| InventoryService | State machine session/item, scan và xử lý mismatch. | `InventoryReconciliationService.java` |
| IncidentDAO | Query, row lock, insert và transition incident. | `BookCopyIncidentDAO.java` |
| InventoryDAO | Snapshot, scan, mark missing, resolve item và transition session. | `InventoryDAO.java` |
| Shared DAO | Khóa/cập nhật BookCopy, số lượng Book và AuditLogs. | `BookCopyDAO.java`, `BookDAO.java`, `AuditLogDAO.java` |
| Views | UI tiếng Việt cho sự cố và kiểm kê. | `book-damaged-lost.jsp`, `book-inventory-reconciliation.jsp`, fragments |

## 3. DATA FLOW
- **Report Incident:** Barcode -> lock BookCopy -> validate good/available/no open incident -> insert pending -> copy unavailable -> availableQuantity -1 -> Audit -> commit.
- **Resolve/Reject:** Lock incident + copy -> validate pending/investigating -> resolve condition hoặc reject và phục hồi số lượng -> nếu resolve `lost` thì mark removed + totalQuantity -1 -> Audit -> commit.
- **F6 Check-in Incident:** F6 tạo sẵn incident `resolved` khi nhận trả bản sao `damaged/lost`; F13 không resolve/reject lại, chỉ hiển thị và cho phép restore hoặc remove khỏi kho nếu incidentType=`damaged`.
- **Restore Repair:** Lock resolved damaged incident + damaged/unavailable copy -> copy good/available -> ưu tiên pending reservation, chỉ +1 availableQuantity khi hàng chờ trống -> append note + Audit -> commit -> notify sau commit.
- **Remove Damaged From Inventory:** Lock resolved damaged incident + damaged/unavailable copy -> validate `removedFromInventory=false` -> set removed flag/At/By -> totalQuantity -1 -> append note + Audit -> commit.
- **Inventory:** Create draft -> start tạo snapshot và khóa quyền chạy phiên khác trên toàn hệ thống -> scan matched/misplaced, chặn duplicate -> finish chuyển item ngoài phạm vi thành excluded và item hợp lệ chưa quét thành missing -> review/resolve -> complete khi không còn unresolved.
- **Resolve Misplaced:** `return_to_expected` chỉ xác nhận đã đưa sách về vị trí gốc; `relocate_to_scanned` mới cập nhật `BookCopy.location`. Cả hai phải khóa item/copy, kiểm tra copy good/available/chưa thanh lý và location chưa lệch snapshot.
- **Resolve Missing:** Lock item/session/Book/copy -> validate available/good/chưa thanh lý/location snapshot/no open incident -> create lost pending incident -> copy unavailable -> giảm suất tự do hoặc demote ready hold theo BR-28 -> resolve item + Audit -> commit -> notify sau commit.

## 4. STATE MACHINES
- Incident F13: `pending -> investigating -> resolved|rejected`; `pending -> resolved|rejected` cũng hợp lệ. Incident do F6 tạo đi thẳng vào `resolved` vì đã được kết luận tại quầy.
- Restore/remove khỏi kho không đổi incident status; chỉ append resolution note cho incident `resolved/damaged`.
- InventorySession: `draft -> counting -> reviewing -> completed`; `draft|counting|reviewing -> cancelled`. Các trường `created*`, `started*`, `completed*`, `cancelled*` ghi đúng thời điểm tương ứng; chỉ một phiên `counting/reviewing` trên toàn hệ thống.
- InventoryItem.result gồm `pending/matched/missing/misplaced/excluded`, không có `resolved`; trạng thái đã xử lý được xác định bằng `resolvedAt IS NOT NULL`.

## 5. ACCESS CONTROL
- `AuthFilter` bảo vệ `/librarian/book-management/incidents` và `/librarian/book-management/inventory` qua prefix `/librarian/book-management/*`.
- Anonymous redirect `/login`; mọi role khác `LIBRARIAN` nhận HTTP 403.
- Controller kiểm tra lại session/role cho POST.

## 6. DATABASE CHANGES
- Dùng đúng schema PostgreSQL cho `BookCopyIncident`, `BookCopy.removedFromInventory*`, `InventorySession`, `InventoryItem`.
- Giữ partial unique index cho incident chưa kết thúc và unique `(inventorySessionId, bookCopyId)`.
- Giữ CHECK constraint đúng từng miền: Incident không dùng type `missing` hoặc status `open/disposed`; Session không dùng `created/in_progress/counting_complete`; Item không dùng result `scanned/resolved`.
- Không thêm `disposed` vì `BookCopy.status` không hỗ trợ và trái soft-delete hiện hành; dùng `removedFromInventory` để loại khỏi tổng kho mà vẫn giữ record.

## 7. RISKS & MITIGATIONS
- **Risk:** Hai request cùng báo sự cố hoặc resolve hai lần.
  **Mitigation:** Row lock + unique partial index + kiểm tra trạng thái nguồn.
- **Risk:** Tồn kho cộng/trừ lặp.
  **Mitigation:** Dùng `removedFromInventory=false` trong điều kiện update khi loại khỏi kho; mọi nhánh số lượng chạy trong cùng transaction.
- **Risk:** Complete khi còn mismatch.
  **Mitigation:** `countUnresolved` trong cùng transaction trước transition.
- **Risk:** Scan đồng thời làm trùng item.
  **Mitigation:** Unique session-copy và upsert/update có khóa phù hợp.
- **Risk:** Resolve dùng snapshot cũ và ghi đè location/trạng thái vừa thay đổi bởi nghiệp vụ khác.
  **Mitigation:** Khóa item/copy, kiểm tra available/good/chưa thanh lý và location còn khớp snapshot; nếu lệch thì từ chối với thông báo rõ ràng.
- **Risk:** F4/F6 cập nhật condition trực tiếp làm lệch state.
  **Mitigation:** F4 không cập nhật condition; F6 chỉ cập nhật trong transaction check-in và tạo incident `resolved`; F13 xử lý manual/inventory incident theo BR-28.

## 8. QUESTIONS FOR HUMAN
- N/A
