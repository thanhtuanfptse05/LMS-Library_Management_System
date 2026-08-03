# TASKS.md — Task Breakdown Bảo trì sách và Kiểm kê

| ID | Task | Files liên quan | Est | Deps | DoD / Spec Refs |
|---|---|---|---|---|---|
| **T-F13-01** | Đối chiếu schema và state constraints | `database/supabase/LMS_Schema_PostgreSQL.sql`, `database/supabase/migrations/20260804_inventory_unexpected_scans.sql` | 2h | None | Type/status/result/index khớp FR-48..50; có `expectedInSession`, `anomalyType`, `unexpected` và CHECK constraint tương ứng. |
| **T-F13-02** | Chuẩn hóa Model/DTO Incident và Inventory | `BookCopyIncident.java`, `InventorySession.java`, `InventoryItem.java`, `InventoryLocationSummaryDTO.java` | 2h | T-F13-01 | Đủ field thống kê phiên, loại bất thường, kiểu nullable và timestamp theo schema. |
| **T-F13-03** | Hoàn thiện IncidentDAO | `BookCopyIncidentDAO.java` | 3h | T-F13-02 | PreparedStatement, search/count/summary, row lock, pending/investigating transitions. Refs: FR-48, FR-49. |
| **T-F13-04** | Hoàn thiện InventoryDAO và truy vấn tổng hợp vị trí | `InventoryDAO.java`, `BookCopyDAO.java` | 4h | T-F13-02 | Snapshot chỉ lấy good/available/chưa thanh lý; scan ngoài snapshot; đếm expected/scanned-expected/unexpected riêng; duplicate guard, excluded/missing và transition đúng lifecycle. Refs: BR-44, BR-70, FR-50. |
| **T-F13-05** | Hoàn thiện IncidentService | `BookCopyIncidentService.java` | 5h | T-F13-03 | Report/investigate/resolve/reject/restore nguyên tử, số lượng và Audit đúng một lần. Refs: UC-28, BR-28, FR-48, FR-49. |
| **T-F13-06** | Hoàn thiện InventoryService | `InventoryReconciliationService.java` | 6h | T-F13-03, T-F13-04 | 9 action đúng state machine; phân loại 5 loại unexpected; resolve-unexpected không tự đổi BookCopy; misplaced có 2 mode; missing áp dụng capacity policy. Refs: UC-29, BR-44, BR-70, FR-50; nhánh missing áp dụng BR-28. |
| **T-F13-07** | Hoàn thiện controller sự cố | `BookCopyIncidentServlet.java` | 3h | T-F13-05 | Search/filter/page/detail và đủ action; lỗi/flash tiếng Việt. |
| **T-F13-08** | Hoàn thiện controller kiểm kê | `InventoryReconciliationServlet.java` | 3h | T-F13-06 | List/detail và 9 action gồm resolve-unexpected; load tổng hợp vị trí; giữ sessionId khi redirect. |
| **T-F13-09** | Hoàn thiện JSP/fragments | `web/librarian/book-damaged-lost.jsp`, `book-inventory-reconciliation.jsp`, `fragments/_book-incident-*.jsp` | 5h | T-F13-07, T-F13-08 | 100% tiếng Việt, JSTL/EL; tách tình trạng vị trí khỏi tiến độ phiên; hiển thị nhãn và action xác minh unexpected đúng trạng thái. |
| **T-F13-10** | Kiểm chứng RBAC | `AuthFilter.java`, servlet mappings | 2h | T-F13-07, T-F13-08 | Anonymous redirect; role khác LIBRARIAN nhận 403. |
| **T-F13-11** | Unit/DAO test incident | `test/service/BookCopyIncidentServiceTest.java`, `test/dao/BookCopyIncidentDAOTest.java` | 5h | T-F13-05 | Happy path, invalid state, duplicate open incident, reject/restore inventory. |
| **T-F13-12** | Unit/DAO test inventory | `test/service/InventoryReconciliationServiceTest.java`, `test/dao/InventoryDAOTest.java` | 5h | T-F13-06 | Lifecycle timestamps, single active, duplicate scan, excluded, 2 mode misplaced, 5 loại unexpected, resolution validation, expected-count isolation, stale snapshot, missing capacity và unresolved gate. |
| **T-F13-13** | Integration test transaction/Audit | `test/integration/*` | 5h | T-F13-10..12 | Rollback không lệch tồn kho; Audit đủ; concurrent action không cộng/trừ lặp. |
| **T-F13-14** | Quality gate | Toàn bộ file F13 | 2h | T-F13-13 | Build/test đạt; scan < 1 giây; không TODO/System.out; UI tiếng Việt. |
