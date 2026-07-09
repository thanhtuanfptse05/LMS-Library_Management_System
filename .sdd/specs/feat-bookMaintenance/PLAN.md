# PLAN.md — Kế hoạch Thực thi Bảo trì sách và Kiểm kê
# Trạng thái: APPROVED | Cập nhật: 2026-07-09

## 1. ARCHITECTURAL APPROACH
Áp dụng Servlet MVC + Service + JDBC DAO. Service sở hữu transaction, khóa hàng, xác thực state transition, đồng bộ BookCopy/Book và ghi Audit Log. Controller chỉ parse action, gọi Service, đặt flash message và forward/redirect JSP.

## 2. COMPONENTS
| Component | Trách nhiệm | Interface/Class |
| --- | --- | --- |
| IncidentController | Danh sách/filter/detail và action report/investigate/resolve/reject/restore. | `BookCopyIncidentServlet.java` |
| InventoryController | Danh sách/chi tiết phiên và 8 action kiểm kê. | `InventoryReconciliationServlet.java` |
| IncidentService | State machine incident, BookCopy, tồn kho và Audit Log. | `BookCopyIncidentService.java` |
| InventoryService | State machine session/item, scan và xử lý mismatch. | `InventoryReconciliationService.java` |
| IncidentDAO | Query, row lock, insert và transition incident. | `BookCopyIncidentDAO.java` |
| InventoryDAO | Snapshot, scan, mark missing, resolve item và transition session. | `InventoryDAO.java` |
| Shared DAO | Khóa/cập nhật BookCopy, số lượng Book và AuditLogs. | `BookCopyDAO.java`, `BookDAO.java`, `AuditLogDAO.java` |
| Views | UI tiếng Việt cho sự cố và kiểm kê. | `book-damaged-lost.jsp`, `book-inventory-reconciliation.jsp`, fragments |

## 3. DATA FLOW
- **Report Incident:** Barcode -> lock BookCopy -> validate good/available/no open incident -> insert pending -> copy unavailable -> availableQuantity -1 -> Audit -> commit.
- **Resolve/Reject:** Lock incident + copy -> validate pending/investigating -> resolve condition hoặc reject và phục hồi số lượng -> Audit -> commit.
- **Restore Repair:** Lock resolved damaged incident + damaged/unavailable copy -> copy good/available -> availableQuantity +1 -> append note + Audit -> commit.
- **Inventory:** Create snapshot -> start counting -> scan matched/misplaced -> finish marks pending as missing -> review/resolve -> complete when no unresolved.
- **Resolve Missing:** Lock item/session/copy -> create lost pending incident -> copy unavailable -> availableQuantity -1 -> resolve item + Audit -> commit.

## 4. STATE MACHINES
- Incident: `pending -> investigating -> resolved|rejected`; `pending -> resolved|rejected` cũng hợp lệ.
- Restore không đổi incident status; chỉ append resolution note cho incident `resolved/damaged`.
- InventorySession: `draft -> counting -> reviewing -> completed`; `draft|counting|reviewing -> cancelled`.
- InventoryItem.result không có `resolved`; trạng thái đã xử lý được xác định bằng `resolvedAt IS NOT NULL`.

## 5. ACCESS CONTROL
- `AuthFilter` bảo vệ `/book-management/incidents` và `/book-management/inventory` qua prefix `/book-management/*`.
- Anonymous redirect `/login`; mọi role khác `LIBRARIAN` nhận HTTP 403.
- Controller kiểm tra lại session/role cho POST.

## 6. DATABASE CHANGES
- Dùng đúng schema PostgreSQL cho `BookCopyIncident`, `InventorySession`, `InventoryItem`.
- Giữ partial unique index cho incident chưa kết thúc và unique `(inventorySessionId, bookCopyId)`.
- Giữ CHECK constraint đúng từng miền: Incident không dùng type `missing` hoặc status `open/disposed`; Session không dùng `created/in_progress/counting_complete`; Item không dùng result `scanned/resolved`.
- Không thêm `disposed` vì `BookCopy.status` không hỗ trợ và trái soft-delete hiện hành.

## 7. RISKS & MITIGATIONS
- **Risk:** Hai request cùng báo sự cố hoặc resolve hai lần.
  **Mitigation:** Row lock + unique partial index + kiểm tra trạng thái nguồn.
- **Risk:** Tồn kho cộng/trừ lặp.
  **Mitigation:** Chỉ report/reject/restore thay số lượng; resolve không trừ lần hai.
- **Risk:** Complete khi còn mismatch.
  **Mitigation:** `countUnresolved` trong cùng transaction trước transition.
- **Risk:** Scan đồng thời làm trùng item.
  **Mitigation:** Unique session-copy và upsert/update có khóa phù hợp.
- **Risk:** F4/F6 cập nhật condition trực tiếp làm lệch state.
  **Mitigation:** Mọi thay đổi hỏng/mất phải tái sử dụng quy tắc BR-28.

## 8. QUESTIONS FOR HUMAN
- N/A
