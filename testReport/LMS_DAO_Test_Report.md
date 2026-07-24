# BÁO CÁO KẾT QUẢ KIỂM THỬ TẦNG TRUY XUẤT DỮ LIỆU (DAO LAYER)

- **Thời gian xuất báo cáo:** 24/07/2026 21:44:13
- **Tổng số test cases:** 14 cases
- **Số case thành công:** 14
- **Số case thất bại:** 0
- **Thời gian thực thi:** 20147 ms
- **Trạng thái chung:** PASSED (100%)

## 1. Tóm tắt theo Test Suite

| Tên Test Suite | Số Test Cases | Thành công | Thất bại | Trạng thái |
| --- | --- | --- | --- | --- |
| `dao.BookCopyIncidentDAOTest` | 1 | 1 | 0 | ✅ PASS |
| `dao.BookDAOTest` | 2 | 2 | 0 | ✅ PASS |
| `dao.BorrowRecordDAOTest` | 2 | 2 | 0 | ✅ PASS |
| `dao.FineDAOTest` | 2 | 2 | 0 | ✅ PASS |
| `dao.NotificationDAOTest` | 1 | 1 | 0 | ✅ PASS |
| `dao.PaymentDAOTest` | 2 | 2 | 0 | ✅ PASS |
| `dao.SystemConfigurationsDAOTest` | 2 | 2 | 0 | ✅ PASS |
| `dao.UserDAOTest` | 2 | 2 | 0 | ✅ PASS |

## 2. Nhật ký chi tiết từng Test Case

| STT | Test Suite | Tên Test Case | Thời gian | Trạng thái | Ghi chú / Lỗi |
| --- | --- | --- | --- | --- | --- |
| 1 | `BookCopyIncidentDAOTest` | `testInsertResolvedFromCheckInReturnsGeneratedId` | 43 ms | ✅ PASS | OK |
| 2 | `BookDAOTest` | `testFindByIsbnWithMockConn` | 18 ms | ✅ PASS | OK |
| 3 | `BookDAOTest` | `testInsertBookWithMockConn` | 0 ms | ✅ PASS | OK |
| 4 | `BorrowRecordDAOTest` | `testUpdateStatusToReturnedWithMockConn` | 0 ms | ✅ PASS | OK |
| 5 | `BorrowRecordDAOTest` | `testFindByIdWithMockConn` | 1 ms | ✅ PASS | OK |
| 6 | `FineDAOTest` | `testUpdateStatusToPaidWithMockConn` | 0 ms | ✅ PASS | OK |
| 7 | `FineDAOTest` | `testInsertCompensationFineWithMockConn` | 1 ms | ✅ PASS | OK |
| 8 | `NotificationDAOTest` | `testNotificationDAOMockConn` | 0 ms | ✅ PASS | OK |
| 9 | `PaymentDAOTest` | `testUpdateStatusToCompletedWithMockConn` | 1 ms | ✅ PASS | OK |
| 10 | `PaymentDAOTest` | `testFindFineIdByPaymentIdWithMockConn` | 0 ms | ✅ PASS | OK |
| 11 | `SystemConfigurationsDAOTest` | `testGetConfigValueWithMockConnection` | 0 ms | ✅ PASS | OK |
| 12 | `SystemConfigurationsDAOTest` | `testGetLibraryConfigurationsWithMockConnection` | 0 ms | ✅ PASS | OK |
| 13 | `UserDAOTest` | `testUpdatePasswordWithMockConn` | 1 ms | ✅ PASS | OK |
| 14 | `UserDAOTest` | `testFindByEmailWithMockConn` | 0 ms | ✅ PASS | OK |

