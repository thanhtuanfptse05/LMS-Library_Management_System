# BÁO CÁO KẾT QUẢ KIỂM THỬ TẦNG NGHIỆP VỤ (SERVICE LAYER)

- **Thời gian xuất báo cáo:** 24/07/2026 21:44:13
- **Tổng số test cases:** 144 cases
- **Số case thành công:** 144
- **Số case thất bại:** 0
- **Thời gian thực thi:** 20147 ms
- **Trạng thái chung:** PASSED (100%)

## 1. Tóm tắt theo Test Suite

| Tên Test Suite | Số Test Cases | Thành công | Thất bại | Trạng thái |
| --- | --- | --- | --- | --- |
| `service.AiChatbotServiceTest` | 6 | 6 | 0 | ✅ PASS |
| `service.AiRecommendationServiceTest` | 3 | 3 | 0 | ✅ PASS |
| `service.AuthServiceTest` | 9 | 9 | 0 | ✅ PASS |
| `service.BookCopyIncidentServiceTest` | 16 | 16 | 0 | ✅ PASS |
| `service.BookCopyServiceTest` | 11 | 11 | 0 | ✅ PASS |
| `service.BookImportServiceTest` | 3 | 3 | 0 | ✅ PASS |
| `service.BookImportValidatorTest` | 4 | 4 | 0 | ✅ PASS |
| `service.BookServiceTest` | 13 | 13 | 0 | ✅ PASS |
| `service.BookSuggestionServiceTest` | 7 | 7 | 0 | ✅ PASS |
| `service.CategoryServiceTest` | 8 | 8 | 0 | ✅ PASS |
| `service.DeskCirculationServiceTest` | 7 | 7 | 0 | ✅ PASS |
| `service.EmailServiceTest` | 5 | 5 | 0 | ✅ PASS |
| `service.EmailWorkerTest` | 1 | 1 | 0 | ✅ PASS |
| `service.ExcelExportServiceTest` | 1 | 1 | 0 | ✅ PASS |
| `service.InventoryReconciliationServiceTest` | 7 | 7 | 0 | ✅ PASS |
| `service.OnlineCirculationServiceTest` | 6 | 6 | 0 | ✅ PASS |
| `service.ProcessorTest` | 2 | 2 | 0 | ✅ PASS |
| `service.ProfileServiceTest` | 6 | 6 | 0 | ✅ PASS |
| `service.ReportServiceTest` | 2 | 2 | 0 | ✅ PASS |
| `service.ReservationExpirationProcessorTest` | 2 | 2 | 0 | ✅ PASS |
| `service.SystemConfigServiceTest` | 14 | 14 | 0 | ✅ PASS |
| `service.TagServiceTest` | 8 | 8 | 0 | ✅ PASS |
| `service.UserServiceTest` | 3 | 3 | 0 | ✅ PASS |

## 2. Nhật ký chi tiết từng Test Case

| STT | Test Suite | Tên Test Case | Thời gian | Trạng thái | Ghi chú / Lỗi |
| --- | --- | --- | --- | --- | --- |
| 1 | `AiChatbotServiceTest` | `testClassifyIntentBooks` | 1 ms | ✅ PASS | OK |
| 2 | `AiChatbotServiceTest` | `testClassifyIntentRules` | 0 ms | ✅ PASS | OK |
| 3 | `AiChatbotServiceTest` | `testClassifyIntentWithWhitespaceAndCaseSensitivity` | 1 ms | ✅ PASS | OK |
| 4 | `AiChatbotServiceTest` | `testClassifyIntentNullReturnsIrrelevant` | 0 ms | ✅ PASS | OK |
| 5 | `AiChatbotServiceTest` | `testClassifyIntentGreetingIrrelevant` | 0 ms | ✅ PASS | OK |
| 6 | `AiChatbotServiceTest` | `testClassifyIntentEmptyReturnsIrrelevant` | 0 ms | ✅ PASS | OK |
| 7 | `AiRecommendationServiceTest` | `testGetRecommendationsNullCandidatePoolReturnsNull` | 4 ms | ✅ PASS | OK |
| 8 | `AiRecommendationServiceTest` | `testGetRecommendationsEmptyCandidatePoolReturnsNull` | 0 ms | ✅ PASS | OK |
| 9 | `AiRecommendationServiceTest` | `testServiceInstantiation` | 0 ms | ✅ PASS | OK |
| 10 | `AuthServiceTest` | `testVerifyPasswordWrongPassword` | 123 ms | ✅ PASS | OK |
| 11 | `AuthServiceTest` | `testIsAccountLockedExpiredTimestamp` | 1 ms | ✅ PASS | OK |
| 12 | `AuthServiceTest` | `testIsAccountNotLockedForActiveUser` | 0 ms | ✅ PASS | OK |
| 13 | `AuthServiceTest` | `testVerifyPasswordInvalidHashPrefix` | 0 ms | ✅ PASS | OK |
| 14 | `AuthServiceTest` | `testVerifyPasswordSuccess` | 121 ms | ✅ PASS | OK |
| 15 | `AuthServiceTest` | `testVerifyPasswordNullPlainOrHash` | 120 ms | ✅ PASS | OK |
| 16 | `AuthServiceTest` | `testIsAccountLockedPermanentlyByAdmin` | 0 ms | ✅ PASS | OK |
| 17 | `AuthServiceTest` | `testIsAccountLockedNullUser` | 0 ms | ✅ PASS | OK |
| 18 | `AuthServiceTest` | `testIsAccountLockedFutureTimestamp` | 0 ms | ✅ PASS | OK |
| 19 | `BookCopyIncidentServiceTest` | `testValidateReportDescriptionBoundary1000` | 3 ms | ✅ PASS | OK |
| 20 | `BookCopyIncidentServiceTest` | `testValidateReportNullBarcode` | 0 ms | ✅ PASS | OK |
| 21 | `BookCopyIncidentServiceTest` | `testValidateReportValidLost` | 0 ms | ✅ PASS | OK |
| 22 | `BookCopyIncidentServiceTest` | `testValidateRemovalNoteBlank` | 0 ms | ✅ PASS | OK |
| 23 | `BookCopyIncidentServiceTest` | `testValidateRemovalNoteValid` | 0 ms | ✅ PASS | OK |
| 24 | `BookCopyIncidentServiceTest` | `testValidateRepairNoteBlank` | 0 ms | ✅ PASS | OK |
| 25 | `BookCopyIncidentServiceTest` | `testValidateRepairNoteValid` | 0 ms | ✅ PASS | OK |
| 26 | `BookCopyIncidentServiceTest` | `testValidateReportValidDamaged` | 1 ms | ✅ PASS | OK |
| 27 | `BookCopyIncidentServiceTest` | `testValidateReportInvalidType` | 0 ms | ✅ PASS | OK |
| 28 | `BookCopyIncidentServiceTest` | `testValidateResolutionBoundary1000` | 0 ms | ✅ PASS | OK |
| 29 | `BookCopyIncidentServiceTest` | `testValidateResolutionBlank` | 0 ms | ✅ PASS | OK |
| 30 | `BookCopyIncidentServiceTest` | `testValidateResolutionValid` | 0 ms | ✅ PASS | OK |
| 31 | `BookCopyIncidentServiceTest` | `testValidateRemovalNoteBoundary1000` | 0 ms | ✅ PASS | OK |
| 32 | `BookCopyIncidentServiceTest` | `testValidateReportBlankDescription` | 0 ms | ✅ PASS | OK |
| 33 | `BookCopyIncidentServiceTest` | `testValidateRemovalNoteExceeds1000` | 0 ms | ✅ PASS | OK |
| 34 | `BookCopyIncidentServiceTest` | `testValidateReportDescriptionExceeds1000` | 0 ms | ✅ PASS | OK |
| 35 | `BookCopyServiceTest` | `testValidateCreateNullBarcode` | 1 ms | ✅ PASS | OK |
| 36 | `BookCopyServiceTest` | `testValidateCreateLocationExceeds255` | 0 ms | ✅ PASS | OK |
| 37 | `BookCopyServiceTest` | `testValidateCreateBarcodeSpecialChars` | 0 ms | ✅ PASS | OK |
| 38 | `BookCopyServiceTest` | `testValidateCreateBlankLocation` | 0 ms | ✅ PASS | OK |
| 39 | `BookCopyServiceTest` | `testValidateUpdateValidCopy` | 0 ms | ✅ PASS | OK |
| 40 | `BookCopyServiceTest` | `testValidateCreateBarcodeLength50` | 0 ms | ✅ PASS | OK |
| 41 | `BookCopyServiceTest` | `testValidateCreateInvalidBookId` | 0 ms | ✅ PASS | OK |
| 42 | `BookCopyServiceTest` | `testValidateCreateLocationLength255` | 0 ms | ✅ PASS | OK |
| 43 | `BookCopyServiceTest` | `testValidateCreateBarcodeExceeds50` | 0 ms | ✅ PASS | OK |
| 44 | `BookCopyServiceTest` | `testValidateCreateValidCopy` | 0 ms | ✅ PASS | OK |
| 45 | `BookCopyServiceTest` | `testValidateUpdateInvalidCopyId` | 0 ms | ✅ PASS | OK |
| 46 | `BookImportServiceTest` | `testValidateEmptyPreview` | 888 ms | ✅ PASS | OK |
| 47 | `BookImportServiceTest` | `testBookImportServiceInstantiation` | 0 ms | ✅ PASS | OK |
| 48 | `BookImportServiceTest` | `testValidatePreviewWithErrors` | 1627 ms | ✅ PASS | OK |
| 49 | `BookImportValidatorTest` | `testInvalidCategoryExceeds255Chars` | 0 ms | ✅ PASS | OK |
| 50 | `BookImportValidatorTest` | `testValidCategoryAndTagLengths` | 0 ms | ✅ PASS | OK |
| 51 | `BookImportValidatorTest` | `testInvalidTagExceeds100Chars` | 0 ms | ✅ PASS | OK |
| 52 | `BookImportValidatorTest` | `testValidatorInstantiation` | 0 ms | ✅ PASS | OK |
| 53 | `BookServiceTest` | `testValidateInvalidPublicationYearInFuture` | 1 ms | ✅ PASS | OK |
| 54 | `BookServiceTest` | `testValidateValidBookUpdate` | 0 ms | ✅ PASS | OK |
| 55 | `BookServiceTest` | `testValidateInvalidStatus` | 0 ms | ✅ PASS | OK |
| 56 | `BookServiceTest` | `testValidateInvalidIsbnFormatOnCreation` | 0 ms | ✅ PASS | OK |
| 57 | `BookServiceTest` | `testValidateNegativePrice` | 0 ms | ✅ PASS | OK |
| 58 | `BookServiceTest` | `testValidateBoundaryTitleLength500` | 0 ms | ✅ PASS | OK |
| 59 | `BookServiceTest` | `testValidateBlankTitle` | 0 ms | ✅ PASS | OK |
| 60 | `BookServiceTest` | `testValidateBoundaryPublicationYear` | 1 ms | ✅ PASS | OK |
| 61 | `BookServiceTest` | `testValidateBoundaryZeroPrice` | 0 ms | ✅ PASS | OK |
| 62 | `BookServiceTest` | `testValidateValidBookCreation` | 0 ms | ✅ PASS | OK |
| 63 | `BookServiceTest` | `testValidateInvalidPublicationYearTooOld` | 0 ms | ✅ PASS | OK |
| 64 | `BookServiceTest` | `testValidateTitleExceeds500Chars` | 0 ms | ✅ PASS | OK |
| 65 | `BookServiceTest` | `testValidateNullIsbnOnCreation` | 0 ms | ✅ PASS | OK |
| 66 | `BookSuggestionServiceTest` | `testValidateReasonExceeds1000` | 2 ms | ✅ PASS | OK |
| 67 | `BookSuggestionServiceTest` | `testValidateBoundaryTitleLength255` | 0 ms | ✅ PASS | OK |
| 68 | `BookSuggestionServiceTest` | `testValidateBoundaryReasonLength1000` | 0 ms | ✅ PASS | OK |
| 69 | `BookSuggestionServiceTest` | `testValidateIsbnTooShort` | 0 ms | ✅ PASS | OK |
| 70 | `BookSuggestionServiceTest` | `testValidateBlankAuthor` | 0 ms | ✅ PASS | OK |
| 71 | `BookSuggestionServiceTest` | `testValidateValidSuggestion` | 0 ms | ✅ PASS | OK |
| 72 | `BookSuggestionServiceTest` | `testValidateNullTitle` | 0 ms | ✅ PASS | OK |
| 73 | `CategoryServiceTest` | `testValidateBoundaryNameLength1` | 0 ms | ✅ PASS | OK |
| 74 | `CategoryServiceTest` | `testValidateInvalidStatus` | 2 ms | ✅ PASS | OK |
| 75 | `CategoryServiceTest` | `testValidateNameExceeds255Chars` | 0 ms | ✅ PASS | OK |
| 76 | `CategoryServiceTest` | `testValidateBoundaryNameLength255` | 0 ms | ✅ PASS | OK |
| 77 | `CategoryServiceTest` | `testValidateValidActiveCategory` | 0 ms | ✅ PASS | OK |
| 78 | `CategoryServiceTest` | `testValidateNullName` | 0 ms | ✅ PASS | OK |
| 79 | `CategoryServiceTest` | `testValidateValidHiddenCategory` | 0 ms | ✅ PASS | OK |
| 80 | `CategoryServiceTest` | `testValidateBlankName` | 0 ms | ✅ PASS | OK |
| 81 | `DeskCirculationServiceTest` | `testCheckInNullBarcode` | 915 ms | ✅ PASS | OK |
| 82 | `DeskCirculationServiceTest` | `testCheckOutBlankBarcode` | 855 ms | ✅ PASS | OK |
| 83 | `DeskCirculationServiceTest` | `testCheckInInvalidCondition` | 0 ms | ✅ PASS | OK |
| 84 | `DeskCirculationServiceTest` | `testCheckInBlankBarcode` | 975 ms | ✅ PASS | OK |
| 85 | `DeskCirculationServiceTest` | `testServiceInstantiation` | 0 ms | ✅ PASS | OK |
| 86 | `DeskCirculationServiceTest` | `testCheckOutBoundaryInvalidLibrarianIdZero` | 993 ms | ✅ PASS | OK |
| 87 | `DeskCirculationServiceTest` | `testCheckOutNullBarcode` | 876 ms | ✅ PASS | OK |
| 88 | `EmailServiceTest` | `testEnqueueNullJob` | 7 ms | ✅ PASS | OK |
| 89 | `EmailServiceTest` | `testEnqueueUppercaseGmail` | 1 ms | ✅ PASS | OK |
| 90 | `EmailServiceTest` | `testEnqueueValidGmail` | 0 ms | ✅ PASS | OK |
| 91 | `EmailServiceTest` | `testEnqueueNonGmailIgnored` | 1 ms | ✅ PASS | OK |
| 92 | `EmailServiceTest` | `testEnqueueNullRecipientEmailIgnored` | 2 ms | ✅ PASS | OK |
| 93 | `EmailWorkerTest` | `testEmailWorkerShutdownFlag` | 4 ms | ✅ PASS | OK |
| 94 | `ExcelExportServiceTest` | `testExportSystemReportEmptyData` | 36 ms | ✅ PASS | OK |
| 95 | `InventoryReconciliationServiceTest` | `testValidateLocationBlank` | 5 ms | ✅ PASS | OK |
| 96 | `InventoryReconciliationServiceTest` | `testValidateLocationValid` | 0 ms | ✅ PASS | OK |
| 97 | `InventoryReconciliationServiceTest` | `testValidateLocationBoundary255` | 0 ms | ✅ PASS | OK |
| 98 | `InventoryReconciliationServiceTest` | `testScanBlankBarcode` | 0 ms | ✅ PASS | OK |
| 99 | `InventoryReconciliationServiceTest` | `testValidateLocationExceeds255` | 1 ms | ✅ PASS | OK |
| 100 | `InventoryReconciliationServiceTest` | `testValidateLocationNull` | 0 ms | ✅ PASS | OK |
| 101 | `InventoryReconciliationServiceTest` | `testScanNullBarcode` | 0 ms | ✅ PASS | OK |
| 102 | `OnlineCirculationServiceTest` | `testReserveBookBoundaryUserIdZero` | 1589 ms | ✅ PASS | OK |
| 103 | `OnlineCirculationServiceTest` | `testReserveBookBoundaryBookIdZero` | 2004 ms | ✅ PASS | OK |
| 104 | `OnlineCirculationServiceTest` | `testRenewBookInvalidRecordId` | 1526 ms | ✅ PASS | OK |
| 105 | `OnlineCirculationServiceTest` | `testReserveBookNegativeBookId` | 1953 ms | ✅ PASS | OK |
| 106 | `OnlineCirculationServiceTest` | `testReserveBookNegativeUserId` | 1556 ms | ✅ PASS | OK |
| 107 | `OnlineCirculationServiceTest` | `testServiceInstantiation` | 0 ms | ✅ PASS | OK |
| 108 | `ProcessorTest` | `testProcessOverdueOffline` | 922 ms | ✅ PASS | OK |
| 109 | `ProcessorTest` | `testProcessorInstantiation` | 1 ms | ✅ PASS | OK |
| 110 | `ProfileServiceTest` | `testChangePasswordWeakPasswordPolicyThrowsException` | 0 ms | ✅ PASS | OK |
| 111 | `ProfileServiceTest` | `testUpdateUserInfoInvalidDateFormatThrowsException` | 0 ms | ✅ PASS | OK |
| 112 | `ProfileServiceTest` | `testUpdateUserInfoBlankNameThrowsException` | 0 ms | ✅ PASS | OK |
| 113 | `ProfileServiceTest` | `testUpdateUserInfoNullNameThrowsException` | 0 ms | ✅ PASS | OK |
| 114 | `ProfileServiceTest` | `testChangePasswordMismatchConfirmPasswordThrowsException` | 1 ms | ✅ PASS | OK |
| 115 | `ProfileServiceTest` | `testServiceInstantiation` | 0 ms | ✅ PASS | OK |
| 116 | `ReportServiceTest` | `testExportSystemReportToExcelSuccess` | 141 ms | ✅ PASS | OK |
| 117 | `ReportServiceTest` | `testExportSystemReportWithEmptyDataMap` | 15 ms | ✅ PASS | OK |
| 118 | `ReservationExpirationProcessorTest` | `testProcessExpirationExecution` | 925 ms | ✅ PASS | OK |
| 119 | `ReservationExpirationProcessorTest` | `testProcessorInstantiation` | 0 ms | ✅ PASS | OK |
| 120 | `SystemConfigServiceTest` | `testValidateValuePositiveIntSuccess` | 0 ms | ✅ PASS | OK |
| 121 | `SystemConfigServiceTest` | `testValidateValueNonNegativeDecimalSuccess` | 1 ms | ✅ PASS | OK |
| 122 | `SystemConfigServiceTest` | `testValidateValuePositiveIntNegativeThrowsException` | 0 ms | ✅ PASS | OK |
| 123 | `SystemConfigServiceTest` | `testValidateValueNonNegativeIntSuccess` | 0 ms | ✅ PASS | OK |
| 124 | `SystemConfigServiceTest` | `testValidateValueNonNegativeDecimalBoundaryZero` | 0 ms | ✅ PASS | OK |
| 125 | `SystemConfigServiceTest` | `testValidateValuePositiveIntZeroThrowsException` | 0 ms | ✅ PASS | OK |
| 126 | `SystemConfigServiceTest` | `testValidateValueNonNegativeDecimalNegativeThrowsException` | 0 ms | ✅ PASS | OK |
| 127 | `SystemConfigServiceTest` | `testValidateValueBlankThrowsException` | 0 ms | ✅ PASS | OK |
| 128 | `SystemConfigServiceTest` | `testValidateValuePositiveIntBoundaryOne` | 0 ms | ✅ PASS | OK |
| 129 | `SystemConfigServiceTest` | `testValidateValueInvalidNumberFormatThrowsException` | 0 ms | ✅ PASS | OK |
| 130 | `SystemConfigServiceTest` | `testValidateValueNonNegativeIntNegativeThrowsException` | 0 ms | ✅ PASS | OK |
| 131 | `SystemConfigServiceTest` | `testValidateValueNonNegativeIntBoundaryZero` | 0 ms | ✅ PASS | OK |
| 132 | `SystemConfigServiceTest` | `testValidateValueNullThrowsException` | 0 ms | ✅ PASS | OK |
| 133 | `SystemConfigServiceTest` | `testValidateValueStringSuccess` | 0 ms | ✅ PASS | OK |
| 134 | `TagServiceTest` | `testValidateValidHiddenTag` | 1 ms | ✅ PASS | OK |
| 135 | `TagServiceTest` | `testValidateBoundaryNameLength1` | 0 ms | ✅ PASS | OK |
| 136 | `TagServiceTest` | `testValidateInvalidStatus` | 0 ms | ✅ PASS | OK |
| 137 | `TagServiceTest` | `testValidateBoundaryNameLength100` | 0 ms | ✅ PASS | OK |
| 138 | `TagServiceTest` | `testValidateNullName` | 0 ms | ✅ PASS | OK |
| 139 | `TagServiceTest` | `testValidateNameExceeds100Chars` | 0 ms | ✅ PASS | OK |
| 140 | `TagServiceTest` | `testValidateValidActiveTag` | 0 ms | ✅ PASS | OK |
| 141 | `TagServiceTest` | `testValidateBlankName` | 0 ms | ✅ PASS | OK |
| 142 | `UserServiceTest` | `testImportUsersEmptyList` | 0 ms | ✅ PASS | OK |
| 143 | `UserServiceTest` | `testUserServiceInstantiation` | 0 ms | ✅ PASS | OK |
| 144 | `UserServiceTest` | `testImportUsersNullList` | 0 ms | ✅ PASS | OK |

