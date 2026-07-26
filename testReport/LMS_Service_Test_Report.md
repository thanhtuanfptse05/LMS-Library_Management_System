# BÁO CÁO K?T QU? KI?M TH? T?NG NGHI?P V? (SERVICE LAYER)

- **Th?i gian xu?t báo cáo:** 24/07/2026 22:08:33
- **T?ng s? test cases:** 144 cases
- **S? case thành công:** 144
- **S? case th?t b?i:** 0
- **Tr?ng thái chung:** PASSED (100%)

## 1. Tóm t?t theo Test Suite

| Tên Test Suite | S? Test Cases | Thành công | Th?t b?i | Tr?ng thái |
| --- | --- | --- | --- | --- |
| `service.AiChatbotServiceTest` | 6 | 6 | 0 | ? PASS |
| `service.AiRecommendationServiceTest` | 3 | 3 | 0 | ? PASS |
| `service.AuthServiceTest` | 9 | 9 | 0 | ? PASS |
| `service.BookCopyIncidentServiceTest` | 16 | 16 | 0 | ? PASS |
| `service.BookCopyServiceTest` | 11 | 11 | 0 | ? PASS |
| `service.BookImportServiceTest` | 3 | 3 | 0 | ? PASS |
| `service.BookImportValidatorTest` | 4 | 4 | 0 | ? PASS |
| `service.BookServiceTest` | 13 | 13 | 0 | ? PASS |
| `service.BookSuggestionServiceTest` | 7 | 7 | 0 | ? PASS |
| `service.CategoryServiceTest` | 8 | 8 | 0 | ? PASS |
| `service.DeskCirculationServiceTest` | 7 | 7 | 0 | ? PASS |
| `service.EmailServiceTest` | 5 | 5 | 0 | ? PASS |
| `service.EmailWorkerTest` | 1 | 1 | 0 | ? PASS |
| `service.ExcelExportServiceTest` | 1 | 1 | 0 | ? PASS |
| `service.InventoryReconciliationServiceTest` | 7 | 7 | 0 | ? PASS |
| `service.OnlineCirculationServiceTest` | 6 | 6 | 0 | ? PASS |
| `service.ProcessorTest` | 2 | 2 | 0 | ? PASS |
| `service.ProfileServiceTest` | 6 | 6 | 0 | ? PASS |
| `service.ReportServiceTest` | 2 | 2 | 0 | ? PASS |
| `service.ReservationExpirationProcessorTest` | 2 | 2 | 0 | ? PASS |
| `service.SystemConfigServiceTest` | 14 | 14 | 0 | ? PASS |
| `service.TagServiceTest` | 8 | 8 | 0 | ? PASS |
| `service.UserServiceTest` | 3 | 3 | 0 | ? PASS |

## 2. Nh?t k? chi ti?t t?ng Test Case

| STT | Test Suite | Tên Test Case | Th?i gian | Tr?ng thái | Ghi chú / L?i |
| --- | --- | --- | --- | --- | --- |
| 1 | `AiChatbotServiceTest` | `testClassifyIntentWithWhitespaceAndCaseSensitivity` | 1 ms | ? PASS | OK |
| 2 | `AiChatbotServiceTest` | `testClassifyIntentGreetingIrrelevant` | 0 ms | ? PASS | OK |
| 3 | `AiChatbotServiceTest` | `testClassifyIntentNullReturnsIrrelevant` | 4 ms | ? PASS | OK |
| 4 | `AiChatbotServiceTest` | `testClassifyIntentEmptyReturnsIrrelevant` | 1 ms | ? PASS | OK |
| 5 | `AiChatbotServiceTest` | `testClassifyIntentBooks` | 3 ms | ? PASS | OK |
| 6 | `AiChatbotServiceTest` | `testClassifyIntentRules` | 1 ms | ? PASS | OK |
| 7 | `AiRecommendationServiceTest` | `testGetRecommendationsEmptyCandidatePoolReturnsNull` | 0 ms | ? PASS | OK |
| 8 | `AiRecommendationServiceTest` | `testGetRecommendationsNullCandidatePoolReturnsNull` | 2 ms | ? PASS | OK |
| 9 | `AiRecommendationServiceTest` | `testServiceInstantiation` | 0 ms | ? PASS | OK |
| 10 | `AuthServiceTest` | `testIsAccountNotLockedForActiveUser` | 1 ms | ? PASS | OK |
| 11 | `AuthServiceTest` | `testVerifyPasswordInvalidHashPrefix` | 0 ms | ? PASS | OK |
| 12 | `AuthServiceTest` | `testIsAccountLockedExpiredTimestamp` | 0 ms | ? PASS | OK |
| 13 | `AuthServiceTest` | `testIsAccountLockedPermanentlyByAdmin` | 1 ms | ? PASS | OK |
| 14 | `AuthServiceTest` | `testIsAccountLockedFutureTimestamp` | 0 ms | ? PASS | OK |
| 15 | `AuthServiceTest` | `testIsAccountLockedNullUser` | 2 ms | ? PASS | OK |
| 16 | `AuthServiceTest` | `testVerifyPasswordWrongPassword` | 4 ms | ? PASS | OK |
| 17 | `AuthServiceTest` | `testVerifyPasswordNullPlainOrHash` | 4 ms | ? PASS | OK |
| 18 | `AuthServiceTest` | `testVerifyPasswordSuccess` | 3 ms | ? PASS | OK |
| 19 | `BookCopyIncidentServiceTest` | `testValidateReportDescriptionBoundary1000` | 0 ms | ? PASS | OK |
| 20 | `BookCopyIncidentServiceTest` | `testValidateRemovalNoteBoundary1000` | 1 ms | ? PASS | OK |
| 21 | `BookCopyIncidentServiceTest` | `testValidateReportDescriptionExceeds1000` | 4 ms | ? PASS | OK |
| 22 | `BookCopyIncidentServiceTest` | `testValidateRepairNoteBlank` | 2 ms | ? PASS | OK |
| 23 | `BookCopyIncidentServiceTest` | `testValidateReportBlankDescription` | 2 ms | ? PASS | OK |
| 24 | `BookCopyIncidentServiceTest` | `testValidateRemovalNoteExceeds1000` | 1 ms | ? PASS | OK |
| 25 | `BookCopyIncidentServiceTest` | `testValidateResolutionValid` | 0 ms | ? PASS | OK |
| 26 | `BookCopyIncidentServiceTest` | `testValidateResolutionBoundary1000` | 3 ms | ? PASS | OK |
| 27 | `BookCopyIncidentServiceTest` | `testValidateRemovalNoteValid` | 3 ms | ? PASS | OK |
| 28 | `BookCopyIncidentServiceTest` | `testValidateRemovalNoteBlank` | 2 ms | ? PASS | OK |
| 29 | `BookCopyIncidentServiceTest` | `testValidateReportValidDamaged` | 0 ms | ? PASS | OK |
| 30 | `BookCopyIncidentServiceTest` | `testValidateReportValidLost` | 4 ms | ? PASS | OK |
| 31 | `BookCopyIncidentServiceTest` | `testValidateRepairNoteValid` | 1 ms | ? PASS | OK |
| 32 | `BookCopyIncidentServiceTest` | `testValidateReportNullBarcode` | 0 ms | ? PASS | OK |
| 33 | `BookCopyIncidentServiceTest` | `testValidateResolutionBlank` | 2 ms | ? PASS | OK |
| 34 | `BookCopyIncidentServiceTest` | `testValidateReportInvalidType` | 1 ms | ? PASS | OK |
| 35 | `BookCopyServiceTest` | `testValidateCreateInvalidBookId` | 2 ms | ? PASS | OK |
| 36 | `BookCopyServiceTest` | `testValidateUpdateValidCopy` | 4 ms | ? PASS | OK |
| 37 | `BookCopyServiceTest` | `testValidateUpdateInvalidCopyId` | 1 ms | ? PASS | OK |
| 38 | `BookCopyServiceTest` | `testValidateCreateValidCopy` | 4 ms | ? PASS | OK |
| 39 | `BookCopyServiceTest` | `testValidateCreateNullBarcode` | 3 ms | ? PASS | OK |
| 40 | `BookCopyServiceTest` | `testValidateCreateBarcodeExceeds50` | 2 ms | ? PASS | OK |
| 41 | `BookCopyServiceTest` | `testValidateCreateBlankLocation` | 0 ms | ? PASS | OK |
| 42 | `BookCopyServiceTest` | `testValidateCreateBarcodeLength50` | 1 ms | ? PASS | OK |
| 43 | `BookCopyServiceTest` | `testValidateCreateLocationLength255` | 0 ms | ? PASS | OK |
| 44 | `BookCopyServiceTest` | `testValidateCreateLocationExceeds255` | 1 ms | ? PASS | OK |
| 45 | `BookCopyServiceTest` | `testValidateCreateBarcodeSpecialChars` | 2 ms | ? PASS | OK |
| 46 | `BookImportServiceTest` | `testValidatePreviewWithErrors` | 4 ms | ? PASS | OK |
| 47 | `BookImportServiceTest` | `testValidateEmptyPreview` | 0 ms | ? PASS | OK |
| 48 | `BookImportServiceTest` | `testBookImportServiceInstantiation` | 4 ms | ? PASS | OK |
| 49 | `BookImportValidatorTest` | `testValidatorInstantiation` | 3 ms | ? PASS | OK |
| 50 | `BookImportValidatorTest` | `testInvalidTagExceeds100Chars` | 0 ms | ? PASS | OK |
| 51 | `BookImportValidatorTest` | `testInvalidCategoryExceeds255Chars` | 0 ms | ? PASS | OK |
| 52 | `BookImportValidatorTest` | `testValidCategoryAndTagLengths` | 1 ms | ? PASS | OK |
| 53 | `BookServiceTest` | `testValidateInvalidIsbnFormatOnCreation` | 2 ms | ? PASS | OK |
| 54 | `BookServiceTest` | `testValidateInvalidPublicationYearTooOld` | 4 ms | ? PASS | OK |
| 55 | `BookServiceTest` | `testValidateInvalidPublicationYearInFuture` | 1 ms | ? PASS | OK |
| 56 | `BookServiceTest` | `testValidateBoundaryPublicationYear` | 3 ms | ? PASS | OK |
| 57 | `BookServiceTest` | `testValidateNullIsbnOnCreation` | 0 ms | ? PASS | OK |
| 58 | `BookServiceTest` | `testValidateTitleExceeds500Chars` | 0 ms | ? PASS | OK |
| 59 | `BookServiceTest` | `testValidateBoundaryTitleLength500` | 0 ms | ? PASS | OK |
| 60 | `BookServiceTest` | `testValidateValidBookUpdate` | 1 ms | ? PASS | OK |
| 61 | `BookServiceTest` | `testValidateBlankTitle` | 4 ms | ? PASS | OK |
| 62 | `BookServiceTest` | `testValidateBoundaryZeroPrice` | 0 ms | ? PASS | OK |
| 63 | `BookServiceTest` | `testValidateInvalidStatus` | 1 ms | ? PASS | OK |
| 64 | `BookServiceTest` | `testValidateNegativePrice` | 4 ms | ? PASS | OK |
| 65 | `BookServiceTest` | `testValidateValidBookCreation` | 0 ms | ? PASS | OK |
| 66 | `BookSuggestionServiceTest` | `testValidateBoundaryReasonLength1000` | 0 ms | ? PASS | OK |
| 67 | `BookSuggestionServiceTest` | `testValidateReasonExceeds1000` | 3 ms | ? PASS | OK |
| 68 | `BookSuggestionServiceTest` | `testValidateBlankAuthor` | 1 ms | ? PASS | OK |
| 69 | `BookSuggestionServiceTest` | `testValidateNullTitle` | 4 ms | ? PASS | OK |
| 70 | `BookSuggestionServiceTest` | `testValidateBoundaryTitleLength255` | 0 ms | ? PASS | OK |
| 71 | `BookSuggestionServiceTest` | `testValidateValidSuggestion` | 0 ms | ? PASS | OK |
| 72 | `BookSuggestionServiceTest` | `testValidateIsbnTooShort` | 3 ms | ? PASS | OK |
| 73 | `CategoryServiceTest` | `testValidateBoundaryNameLength255` | 4 ms | ? PASS | OK |
| 74 | `CategoryServiceTest` | `testValidateNullName` | 0 ms | ? PASS | OK |
| 75 | `CategoryServiceTest` | `testValidateNameExceeds255Chars` | 3 ms | ? PASS | OK |
| 76 | `CategoryServiceTest` | `testValidateBoundaryNameLength1` | 2 ms | ? PASS | OK |
| 77 | `CategoryServiceTest` | `testValidateValidActiveCategory` | 3 ms | ? PASS | OK |
| 78 | `CategoryServiceTest` | `testValidateBlankName` | 4 ms | ? PASS | OK |
| 79 | `CategoryServiceTest` | `testValidateInvalidStatus` | 1 ms | ? PASS | OK |
| 80 | `CategoryServiceTest` | `testValidateValidHiddenCategory` | 2 ms | ? PASS | OK |
| 81 | `DeskCirculationServiceTest` | `testServiceInstantiation` | 3 ms | ? PASS | OK |
| 82 | `DeskCirculationServiceTest` | `testCheckOutBoundaryInvalidLibrarianIdZero` | 4 ms | ? PASS | OK |
| 83 | `DeskCirculationServiceTest` | `testCheckOutNullBarcode` | 0 ms | ? PASS | OK |
| 84 | `DeskCirculationServiceTest` | `testCheckInBlankBarcode` | 4 ms | ? PASS | OK |
| 85 | `DeskCirculationServiceTest` | `testCheckInNullBarcode` | 0 ms | ? PASS | OK |
| 86 | `DeskCirculationServiceTest` | `testCheckOutBlankBarcode` | 1 ms | ? PASS | OK |
| 87 | `DeskCirculationServiceTest` | `testCheckInInvalidCondition` | 3 ms | ? PASS | OK |
| 88 | `EmailServiceTest` | `testEnqueueNullRecipientEmailIgnored` | 2 ms | ? PASS | OK |
| 89 | `EmailServiceTest` | `testEnqueueNullJob` | 3 ms | ? PASS | OK |
| 90 | `EmailServiceTest` | `testEnqueueNonGmailIgnored` | 4 ms | ? PASS | OK |
| 91 | `EmailServiceTest` | `testEnqueueUppercaseGmail` | 1 ms | ? PASS | OK |
| 92 | `EmailServiceTest` | `testEnqueueValidGmail` | 0 ms | ? PASS | OK |
| 93 | `EmailWorkerTest` | `testEmailWorkerShutdownFlag` | 4 ms | ? PASS | OK |
| 94 | `ExcelExportServiceTest` | `testExportSystemReportEmptyData` | 4 ms | ? PASS | OK |
| 95 | `InventoryReconciliationServiceTest` | `testScanNullBarcode` | 1 ms | ? PASS | OK |
| 96 | `InventoryReconciliationServiceTest` | `testScanBlankBarcode` | 3 ms | ? PASS | OK |
| 97 | `InventoryReconciliationServiceTest` | `testValidateLocationValid` | 0 ms | ? PASS | OK |
| 98 | `InventoryReconciliationServiceTest` | `testValidateLocationBoundary255` | 0 ms | ? PASS | OK |
| 99 | `InventoryReconciliationServiceTest` | `testValidateLocationNull` | 2 ms | ? PASS | OK |
| 100 | `InventoryReconciliationServiceTest` | `testValidateLocationBlank` | 3 ms | ? PASS | OK |
| 101 | `InventoryReconciliationServiceTest` | `testValidateLocationExceeds255` | 0 ms | ? PASS | OK |
| 102 | `OnlineCirculationServiceTest` | `testServiceInstantiation` | 3 ms | ? PASS | OK |
| 103 | `OnlineCirculationServiceTest` | `testReserveBookBoundaryUserIdZero` | 4 ms | ? PASS | OK |
| 104 | `OnlineCirculationServiceTest` | `testRenewBookInvalidRecordId` | 2 ms | ? PASS | OK |
| 105 | `OnlineCirculationServiceTest` | `testReserveBookBoundaryBookIdZero` | 2 ms | ? PASS | OK |
| 106 | `OnlineCirculationServiceTest` | `testReserveBookNegativeUserId` | 4 ms | ? PASS | OK |
| 107 | `OnlineCirculationServiceTest` | `testReserveBookNegativeBookId` | 3 ms | ? PASS | OK |
| 108 | `ProcessorTest` | `testProcessOverdueOffline` | 0 ms | ? PASS | OK |
| 109 | `ProcessorTest` | `testProcessorInstantiation` | 1 ms | ? PASS | OK |
| 110 | `ProfileServiceTest` | `testChangePasswordMismatchConfirmPasswordThrowsException` | 1 ms | ? PASS | OK |
| 111 | `ProfileServiceTest` | `testChangePasswordWeakPasswordPolicyThrowsException` | 3 ms | ? PASS | OK |
| 112 | `ProfileServiceTest` | `testServiceInstantiation` | 0 ms | ? PASS | OK |
| 113 | `ProfileServiceTest` | `testUpdateUserInfoInvalidDateFormatThrowsException` | 1 ms | ? PASS | OK |
| 114 | `ProfileServiceTest` | `testUpdateUserInfoBlankNameThrowsException` | 4 ms | ? PASS | OK |
| 115 | `ProfileServiceTest` | `testUpdateUserInfoNullNameThrowsException` | 4 ms | ? PASS | OK |
| 116 | `ReportServiceTest` | `testExportSystemReportWithEmptyDataMap` | 0 ms | ? PASS | OK |
| 117 | `ReportServiceTest` | `testExportSystemReportToExcelSuccess` | 4 ms | ? PASS | OK |
| 118 | `ReservationExpirationProcessorTest` | `testProcessExpirationExecution` | 0 ms | ? PASS | OK |
| 119 | `ReservationExpirationProcessorTest` | `testProcessorInstantiation` | 1 ms | ? PASS | OK |
| 120 | `SystemConfigServiceTest` | `testValidateValueNonNegativeDecimalNegativeThrowsException` | 3 ms | ? PASS | OK |
| 121 | `SystemConfigServiceTest` | `testValidateValueInvalidNumberFormatThrowsException` | 4 ms | ? PASS | OK |
| 122 | `SystemConfigServiceTest` | `testValidateValueNonNegativeIntNegativeThrowsException` | 1 ms | ? PASS | OK |
| 123 | `SystemConfigServiceTest` | `testValidateValuePositiveIntNegativeThrowsException` | 0 ms | ? PASS | OK |
| 124 | `SystemConfigServiceTest` | `testValidateValuePositiveIntBoundaryOne` | 2 ms | ? PASS | OK |
| 125 | `SystemConfigServiceTest` | `testValidateValuePositiveIntZeroThrowsException` | 1 ms | ? PASS | OK |
| 126 | `SystemConfigServiceTest` | `testValidateValueNonNegativeDecimalBoundaryZero` | 0 ms | ? PASS | OK |
| 127 | `SystemConfigServiceTest` | `testValidateValueBlankThrowsException` | 2 ms | ? PASS | OK |
| 128 | `SystemConfigServiceTest` | `testValidateValuePositiveIntSuccess` | 3 ms | ? PASS | OK |
| 129 | `SystemConfigServiceTest` | `testValidateValueNonNegativeIntSuccess` | 0 ms | ? PASS | OK |
| 130 | `SystemConfigServiceTest` | `testValidateValueNonNegativeDecimalSuccess` | 0 ms | ? PASS | OK |
| 131 | `SystemConfigServiceTest` | `testValidateValueNonNegativeIntBoundaryZero` | 3 ms | ? PASS | OK |
| 132 | `SystemConfigServiceTest` | `testValidateValueNullThrowsException` | 2 ms | ? PASS | OK |
| 133 | `SystemConfigServiceTest` | `testValidateValueStringSuccess` | 3 ms | ? PASS | OK |
| 134 | `TagServiceTest` | `testValidateNullName` | 3 ms | ? PASS | OK |
| 135 | `TagServiceTest` | `testValidateBoundaryNameLength1` | 3 ms | ? PASS | OK |
| 136 | `TagServiceTest` | `testValidateBlankName` | 0 ms | ? PASS | OK |
| 137 | `TagServiceTest` | `testValidateInvalidStatus` | 3 ms | ? PASS | OK |
| 138 | `TagServiceTest` | `testValidateValidHiddenTag` | 1 ms | ? PASS | OK |
| 139 | `TagServiceTest` | `testValidateBoundaryNameLength100` | 4 ms | ? PASS | OK |
| 140 | `TagServiceTest` | `testValidateNameExceeds100Chars` | 4 ms | ? PASS | OK |
| 141 | `TagServiceTest` | `testValidateValidActiveTag` | 1 ms | ? PASS | OK |
| 142 | `UserServiceTest` | `testUserServiceInstantiation` | 2 ms | ? PASS | OK |
| 143 | `UserServiceTest` | `testImportUsersNullList` | 1 ms | ? PASS | OK |
| 144 | `UserServiceTest` | `testImportUsersEmptyList` | 3 ms | ? PASS | OK |
