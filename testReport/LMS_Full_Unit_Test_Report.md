# BÁO CÁO KẾT QUẢ KIỂM THỬ TOÀN BỘ HỆ THỐNG LMS (F01 - F20)

- **Thời gian xuất báo cáo:** 27/07/2026 22:42:21
- **Tổng số tính năng kiểm thử:** 20 Phân hệ (F01 - F20)
- **Tổng số test cases:** 72 cases
- **Số case thành công:** 72
- **Số case thất bại:** 0
- **Thời gian thực thi:** 1534 ms
- **Trạng thái chung:** PASSED (100%)

## 1. Tóm tắt theo Tính năng (F01 - F20)

| Mã Feature | Tên Tính Năng (Feature Name) | Số Test Cases | Thành công | Thất bại | Trạng thái |
| --- | --- | --- | --- | --- | --- |
| `f01_auth` | F01: Authentication & Security | 12 | 12 | 0 | ✅ PASS |
| `f02_profile` | F02: Profile Management | 7 | 7 | 0 | ✅ PASS |
| `f03_user_account` | F03: User Account Management | 5 | 5 | 0 | ✅ PASS |
| `f04_book_mgmt` | F04: Book Management & Copy Tracking | 5 | 5 | 0 | ✅ PASS |
| `f05_reservation` | F05: Online Reservation & Renewal | 5 | 5 | 0 | ✅ PASS |
| `f06_desk_circ` | F06: Desk Circulation Operations | 6 | 6 | 0 | ✅ PASS |
| `f07_notif` | F07: Notification Management | 3 | 3 | 0 | ✅ PASS |
| `f08_book_disc` | F08: Book Discovery | 2 | 2 | 0 | ✅ PASS |
| `f09_fine_payment` | F09: Fine & Payment Management | 4 | 4 | 0 | ✅ PASS |
| `f10_sys_config` | F10: System Configuration | 3 | 3 | 0 | ✅ PASS |
| `f11_sys_report` | F11: System Reports | 2 | 2 | 0 | ✅ PASS |
| `f12_audit_log` | F12: Audit Log | 2 | 2 | 0 | ✅ PASS |
| `f13_book_maint` | F13: Book Maintenance & Copy Incident | 4 | 4 | 0 | ✅ PASS |
| `f14_ai_chatbot` | F14: AI Chatbot & Recommendation | 2 | 2 | 0 | ✅ PASS |
| `f15_dash_librarian` | F15: Dashboard — Librarian | 1 | 1 | 0 | ✅ PASS |
| `f16_dash_manager` | F16: Dashboard — Manager | 1 | 1 | 0 | ✅ PASS |
| `f17_dash_admin` | F17: Dashboard — Admin | 1 | 1 | 0 | ✅ PASS |
| `f18_public_pages` | F18: Public Pages & News | 2 | 2 | 0 | ✅ PASS |
| `f19_async_email` | F19: Async Email Infrastructure | 1 | 1 | 0 | ✅ PASS |
| `f20_book_suggestion` | F20: Book Suggestion | 4 | 4 | 0 | ✅ PASS |

## 2. Nhật ký chi tiết từng Test Case

| STT | Feature Package | Tên Test Case | Thời gian | Trạng thái | Ghi chú / Lỗi |
| --- | --- | --- | --- | --- | --- |
| 1 | `f01_auth` | `testPasswordValidationRules_TooShort` | 2 ms | ✅ PASS | OK |
| 2 | `f01_auth` | `testPasswordValidationRules_NoNumbers` | 2 ms | ✅ PASS | OK |
| 3 | `f01_auth` | `testUserGettersAndSetters` | 4 ms | ✅ PASS | OK |
| 4 | `f01_auth` | `testEmailFormatValidation_Valid` | 0 ms | ✅ PASS | OK |
| 5 | `f01_auth` | `testPasswordValidationRules_Valid` | 1 ms | ✅ PASS | OK |
| 6 | `f01_auth` | `testUserRolesBoundary` | 4 ms | ✅ PASS | OK |
| 7 | `f01_auth` | `testFailedLoginAttemptsIncrement` | 3 ms | ✅ PASS | OK |
| 8 | `f01_auth` | `testAccountStatusTransition` | 0 ms | ✅ PASS | OK |
| 9 | `f01_auth` | `testUserAccountLockingLogic` | 0 ms | ✅ PASS | OK |
| 10 | `f01_auth` | `testEmailFormatValidation_Invalid` | 2 ms | ✅ PASS | OK |
| 11 | `f01_auth` | `testUserLockReasonConstant` | 0 ms | ✅ PASS | OK |
| 12 | `f01_auth` | `testUserDTOMapping` | 1 ms | ✅ PASS | OK |
| 13 | `f02_profile` | `testPhoneNumberValidation_Valid` | 3 ms | ✅ PASS | OK |
| 14 | `f02_profile` | `testMemberProfileFields` | 1 ms | ✅ PASS | OK |
| 15 | `f02_profile` | `testStudentProfileFields` | 1 ms | ✅ PASS | OK |
| 16 | `f02_profile` | `testLibrarianAndAdminProfileFields` | 4 ms | ✅ PASS | OK |
| 17 | `f02_profile` | `testStudentCodeBoundary` | 2 ms | ✅ PASS | OK |
| 18 | `f02_profile` | `testLecturerProfileFields` | 2 ms | ✅ PASS | OK |
| 19 | `f02_profile` | `testPhoneNumberValidation_Invalid` | 0 ms | ✅ PASS | OK |
| 20 | `f03_user_account` | `testCreateUserAccountData` | 2 ms | ✅ PASS | OK |
| 21 | `f03_user_account` | `testUserStatusChange` | 3 ms | ✅ PASS | OK |
| 22 | `f03_user_account` | `testMemberProfileAssociation` | 4 ms | ✅ PASS | OK |
| 23 | `f03_user_account` | `testUserRolePermissions` | 1 ms | ✅ PASS | OK |
| 24 | `f03_user_account` | `testAccountImportRowValidation` | 4 ms | ✅ PASS | OK |
| 25 | `f04_book_mgmt` | `testBookGettersAndSetters` | 4 ms | ✅ PASS | OK |
| 26 | `f04_book_mgmt` | `testCategoryAndTagFields` | 0 ms | ✅ PASS | OK |
| 27 | `f04_book_mgmt` | `testQuantityConsistency` | 0 ms | ✅ PASS | OK |
| 28 | `f04_book_mgmt` | `testBookImportDTOs` | 1 ms | ✅ PASS | OK |
| 29 | `f04_book_mgmt` | `testBookCopyFields` | 3 ms | ✅ PASS | OK |
| 30 | `f05_reservation` | `testBorrowRecordPercentPassedCalculations` | 4 ms | ✅ PASS | OK |
| 31 | `f05_reservation` | `testReservationStatusTransitions` | 3 ms | ✅ PASS | OK |
| 32 | `f05_reservation` | `testRenewalExtensionCountBoundary` | 1 ms | ✅ PASS | OK |
| 33 | `f05_reservation` | `testRenewalNotAllowedWhenOverdue` | 0 ms | ✅ PASS | OK |
| 34 | `f05_reservation` | `testReservationFields` | 2 ms | ✅ PASS | OK |
| 35 | `f06_desk_circ` | `testBookCopyStatusTransitionOnCheckInDamagedCondition` | 3 ms | ✅ PASS | OK |
| 36 | `f06_desk_circ` | `testBookCopyStatusTransitionOnCheckOut` | 1 ms | ✅ PASS | OK |
| 37 | `f06_desk_circ` | `testBookCopyStatusTransitionOnCheckInGoodCondition` | 3 ms | ✅ PASS | OK |
| 38 | `f06_desk_circ` | `testCheckInRecordCompletion` | 1 ms | ✅ PASS | OK |
| 39 | `f06_desk_circ` | `testCheckOutRecordCreation` | 0 ms | ✅ PASS | OK |
| 40 | `f06_desk_circ` | `testOverdueDaysCalculation` | 2 ms | ✅ PASS | OK |
| 41 | `f07_notif` | `testNotificationFields` | 4 ms | ✅ PASS | OK |
| 42 | `f07_notif` | `testNotificationPinToggle` | 3 ms | ✅ PASS | OK |
| 43 | `f07_notif` | `testNotificationTypeBoundary` | 3 ms | ✅ PASS | OK |
| 44 | `f08_book_disc` | `testBookCatalogSummaryFields` | 0 ms | ✅ PASS | OK |
| 45 | `f08_book_disc` | `testBookSearchKeywordMatching` | 3 ms | ✅ PASS | OK |
| 46 | `f09_fine_payment` | `testFineCalculationOverdueDays` | 3 ms | ✅ PASS | OK |
| 47 | `f09_fine_payment` | `testFineStatusTransitions` | 4 ms | ✅ PASS | OK |
| 48 | `f09_fine_payment` | `testFineFields` | 3 ms | ✅ PASS | OK |
| 49 | `f09_fine_payment` | `testPaymentFields` | 2 ms | ✅ PASS | OK |
| 50 | `f10_sys_config` | `testConfigParsingInteger` | 3 ms | ✅ PASS | OK |
| 51 | `f10_sys_config` | `testConfigParsingFineRate` | 2 ms | ✅ PASS | OK |
| 52 | `f10_sys_config` | `testConfigFallbackDefaults` | 3 ms | ✅ PASS | OK |
| 53 | `f11_sys_report` | `testUserActiveRatioCalculation` | 0 ms | ✅ PASS | OK |
| 54 | `f11_sys_report` | `testManagementSummaryDTOGetters` | 2 ms | ✅ PASS | OK |
| 55 | `f12_audit_log` | `testAuditLogEntryFields` | 3 ms | ✅ PASS | OK |
| 56 | `f12_audit_log` | `testActionTypesSupported` | 3 ms | ✅ PASS | OK |
| 57 | `f13_book_maint` | `testIncidentResolutionReject` | 0 ms | ✅ PASS | OK |
| 58 | `f13_book_maint` | `testIncidentResolutionRemove` | 4 ms | ✅ PASS | OK |
| 59 | `f13_book_maint` | `testIncidentResolutionRestore` | 4 ms | ✅ PASS | OK |
| 60 | `f13_book_maint` | `testIncidentFields` | 0 ms | ✅ PASS | OK |
| 61 | `f14_ai_chatbot` | `testAiRecommendationFallbackLogic` | 3 ms | ✅ PASS | OK |
| 62 | `f14_ai_chatbot` | `testAiConfigFields` | 2 ms | ✅ PASS | OK |
| 63 | `f15_dash_librarian` | `testLibrarianDashboardMetrics` | 1 ms | ✅ PASS | OK |
| 64 | `f16_dash_manager` | `testManagerDashboardMetrics` | 0 ms | ✅ PASS | OK |
| 65 | `f17_dash_admin` | `testAdminDashboardSystemMetrics` | 2 ms | ✅ PASS | OK |
| 66 | `f18_public_pages` | `testDocumentTempFields` | 1 ms | ✅ PASS | OK |
| 67 | `f18_public_pages` | `testTemplatePlaceholderReplacement` | 2 ms | ✅ PASS | OK |
| 68 | `f19_async_email` | `testEmailJobCreationAndEnqueuing` | 4 ms | ✅ PASS | OK |
| 69 | `f20_book_suggestion` | `testSuggestionVoteIncrement` | 3 ms | ✅ PASS | OK |
| 70 | `f20_book_suggestion` | `testBookSuggestionFields` | 0 ms | ✅ PASS | OK |
| 71 | `f20_book_suggestion` | `testSuggestionStatusTransitions` | 0 ms | ✅ PASS | OK |
| 72 | `f20_book_suggestion` | `testTitleAndAuthorValidation` | 3 ms | ✅ PASS | OK |
