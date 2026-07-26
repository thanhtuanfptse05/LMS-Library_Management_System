# BÁO CÁO K?T QU? KI?M TH? T?NG TRUY XU?T D? LI?U (DAO LAYER)

- **Th?i gian xu?t báo cáo:** 24/07/2026 22:08:33
- **T?ng s? test cases:** 39 cases
- **S? case thành công:** 39
- **S? case th?t b?i:** 0
- **Tr?ng thái chung:** PASSED (100%)

## 1. Tóm t?t theo Test Suite

| Tên Test Suite | S? Test Cases | Thành công | Th?t b?i | Tr?ng thái |
| --- | --- | --- | --- | --- |
| `dao.BookCopyIncidentDAOTest` | 1 | 1 | 0 | ? PASS |
| `dao.BookDAOTest` | 2 | 2 | 0 | ? PASS |
| `dao.BorrowRecordDAOTest` | 2 | 2 | 0 | ? PASS |
| `dao.FineDAOTest` | 2 | 2 | 0 | ? PASS |
| `dao.NotificationDAOTest` | 1 | 1 | 0 | ? PASS |
| `dao.PaymentDAOTest` | 2 | 2 | 0 | ? PASS |
| `dao.SystemConfigurationsDAOTest` | 2 | 2 | 0 | ? PASS |
| `dao.UserDAOTest` | 2 | 2 | 0 | ? PASS |
| `dao.CategoryDAOTest` | 5 | 5 | 0 | ? PASS |
| `dao.TagDAOTest` | 5 | 5 | 0 | ? PASS |
| `dao.BookCopyDAOTest` | 5 | 5 | 0 | ? PASS |
| `dao.ReservationDAOTest` | 5 | 5 | 0 | ? PASS |
| `dao.InventoryDAOTest` | 5 | 5 | 0 | ? PASS |

## 2. Nh?t k? chi ti?t t?ng Test Case

| STT | Test Suite | Tên Test Case | Th?i gian | Tr?ng thái | Ghi chú / L?i |
| --- | --- | --- | --- | --- | --- |
| 1 | `BookCopyIncidentDAOTest` | `testInsertResolvedFromCheckInReturnsGeneratedId` | 2 ms | ? PASS | OK |
| 2 | `BookDAOTest` | `testFindByIsbnWithMockConn` | 0 ms | ? PASS | OK |
| 3 | `BookDAOTest` | `testInsertBookWithMockConn` | 1 ms | ? PASS | OK |
| 4 | `BorrowRecordDAOTest` | `testUpdateStatusToReturnedWithMockConn` | 3 ms | ? PASS | OK |
| 5 | `BorrowRecordDAOTest` | `testFindByIdWithMockConn` | 4 ms | ? PASS | OK |
| 6 | `FineDAOTest` | `testInsertCompensationFineWithMockConn` | 1 ms | ? PASS | OK |
| 7 | `FineDAOTest` | `testUpdateStatusToPaidWithMockConn` | 3 ms | ? PASS | OK |
| 8 | `NotificationDAOTest` | `testNotificationDAOMockConn` | 0 ms | ? PASS | OK |
| 9 | `PaymentDAOTest` | `testFindFineIdByPaymentIdWithMockConn` | 4 ms | ? PASS | OK |
| 10 | `PaymentDAOTest` | `testUpdateStatusToCompletedWithMockConn` | 3 ms | ? PASS | OK |
| 11 | `SystemConfigurationsDAOTest` | `testGetLibraryConfigurationsWithMockConnection` | 1 ms | ? PASS | OK |
| 12 | `SystemConfigurationsDAOTest` | `testGetConfigValueWithMockConnection` | 0 ms | ? PASS | OK |
| 13 | `UserDAOTest` | `testUpdatePasswordWithMockConn` | 4 ms | ? PASS | OK |
| 14 | `UserDAOTest` | `testFindByEmailWithMockConn` | 3 ms | ? PASS | OK |
| 15 | `CategoryDAOTest` | `testSearchCategoryWithMockConn` | 4 ms | ? PASS | OK |
| 16 | `CategoryDAOTest` | `testCountCategoryWithMockConn` | 2 ms | ? PASS | OK |
| 17 | `CategoryDAOTest` | `testNullSearchFilterHandling` | 2 ms | ? PASS | OK |
| 18 | `CategoryDAOTest` | `testCategoryDAOInstantiation` | 4 ms | ? PASS | OK |
| 19 | `CategoryDAOTest` | `testFindAllWithMockConn` | 2 ms | ? PASS | OK |
| 20 | `TagDAOTest` | `testInsertTagWithMockConn` | 2 ms | ? PASS | OK |
| 21 | `TagDAOTest` | `testTagDAOInstantiation` | 2 ms | ? PASS | OK |
| 22 | `TagDAOTest` | `testUpdateTagStatusWithMockConn` | 0 ms | ? PASS | OK |
| 23 | `TagDAOTest` | `testSearchTagEmptyKeyword` | 1 ms | ? PASS | OK |
| 24 | `TagDAOTest` | `testFindAllWithMockConn` | 1 ms | ? PASS | OK |
| 25 | `BookCopyDAOTest` | `testDeleteBookCopySoftWithMockConn` | 4 ms | ? PASS | OK |
| 26 | `BookCopyDAOTest` | `testBookCopyDAOInstantiation` | 2 ms | ? PASS | OK |
| 27 | `BookCopyDAOTest` | `testUpdateConditionWithMockConn` | 2 ms | ? PASS | OK |
| 28 | `BookCopyDAOTest` | `testFindByBarcodeWithMockConn` | 2 ms | ? PASS | OK |
| 29 | `BookCopyDAOTest` | `testInsertBookCopyWithMockConn` | 1 ms | ? PASS | OK |
| 30 | `ReservationDAOTest` | `testFindActiveReservationWithMockConn` | 0 ms | ? PASS | OK |
| 31 | `ReservationDAOTest` | `testUpdateQueuePositionWithMockConn` | 2 ms | ? PASS | OK |
| 32 | `ReservationDAOTest` | `testReservationDAOInstantiation` | 0 ms | ? PASS | OK |
| 33 | `ReservationDAOTest` | `testCancelReservationWithMockConn` | 2 ms | ? PASS | OK |
| 34 | `ReservationDAOTest` | `testCreateReservationWithMockConn` | 0 ms | ? PASS | OK |
| 35 | `InventoryDAOTest` | `testInsertInventoryItemWithMockConn` | 4 ms | ? PASS | OK |
| 36 | `InventoryDAOTest` | `testInventoryDAOInstantiation` | 2 ms | ? PASS | OK |
| 37 | `InventoryDAOTest` | `testResolveDiscrepancyWithMockConn` | 2 ms | ? PASS | OK |
| 38 | `InventoryDAOTest` | `testCompleteSessionWithMockConn` | 0 ms | ? PASS | OK |
| 39 | `InventoryDAOTest` | `testCreateSessionWithMockConn` | 0 ms | ? PASS | OK |
