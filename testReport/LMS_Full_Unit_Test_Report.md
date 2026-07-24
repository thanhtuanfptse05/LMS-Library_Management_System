# BÁO CÁO KẾT QUẢ KIỂM THỬ TOÀN BỘ HỆ THỐNG LMS

- **Thời gian xuất báo cáo:** 24/07/2026 21:44:13
- **Tổng số test cases:** 212 cases
- **Số case thành công:** 212
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
| `filter.AuthFilterTest` | 6 | 6 | 0 | ✅ PASS |
| `util.BookCoverFetcherTest` | 3 | 3 | 0 | ✅ PASS |
| `util.BookImageStorageTest` | 8 | 8 | 0 | ✅ PASS |
| `util.BookImportWorkbookReaderTest` | 5 | 5 | 0 | ✅ PASS |
| `util.CsvExportUtilTest` | 9 | 9 | 0 | ✅ PASS |
| `util.GoogleSSOUtilTest` | 4 | 4 | 0 | ✅ PASS |
| `util.IsbnValidatorTest` | 12 | 12 | 0 | ✅ PASS |
| `util.SupabaseStorageClientTest` | 7 | 7 | 0 | ✅ PASS |
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
| 15 | `AuthFilterTest` | `testBypassRoutesMatch` | 0 ms | ✅ PASS | OK |
| 16 | `AuthFilterTest` | `testRoleRouteMatchingLogicAllRoles` | 0 ms | ✅ PASS | OK |
| 17 | `AuthFilterTest` | `testAuthFilterInstantiation` | 1 ms | ✅ PASS | OK |
| 18 | `AuthFilterTest` | `testFilterLifecycleMethods` | 0 ms | ✅ PASS | OK |
| 19 | `AuthFilterTest` | `testStaticResourceExtensionCheckAllExtensions` | 2 ms | ✅ PASS | OK |
| 20 | `AuthFilterTest` | `testBookManagementLegacyRouteMatching` | 0 ms | ✅ PASS | OK |
| 21 | `BookCoverFetcherTest` | `testBookCoverFetcherInstantiation` | 228 ms | ✅ PASS | OK |
| 22 | `BookCoverFetcherTest` | `testNullIsbnHandling` | 4 ms | ✅ PASS | OK |
| 23 | `BookCoverFetcherTest` | `testIsbnFormattingForFetcher` | 2 ms | ✅ PASS | OK |
| 24 | `BookImageStorageTest` | `testMaxFileSizeConstant` | 2 ms | ✅ PASS | OK |
| 25 | `BookImageStorageTest` | `testResolveValidJpgFilename` | 1 ms | ✅ PASS | OK |
| 26 | `BookImageStorageTest` | `testResolveArbitraryStringThrowsException` | 2 ms | ✅ PASS | OK |
| 27 | `BookImageStorageTest` | `testResolveNullFilenameThrowsException` | 2 ms | ✅ PASS | OK |
| 28 | `BookImageStorageTest` | `testResolveInvalidExtensionThrowsException` | 1 ms | ✅ PASS | OK |
| 29 | `BookImageStorageTest` | `testResolveUppercaseHexUuid` | 1 ms | ✅ PASS | OK |
| 30 | `BookImageStorageTest` | `testResolveValidPngFilename` | 1 ms | ✅ PASS | OK |
| 31 | `BookImageStorageTest` | `testResolvePathTraversalAttemptThrowsException` | 1 ms | ✅ PASS | OK |
| 32 | `BookImportWorkbookReaderTest` | `testReadValidWorkbook` | 859 ms | ✅ PASS | OK |
| 33 | `BookImportWorkbookReaderTest` | `testReadWorkbookInvalidHeaders` | 29 ms | ✅ PASS | OK |
| 34 | `BookImportWorkbookReaderTest` | `testReadWorkbookMissingCopiesSheet` | 26 ms | ✅ PASS | OK |
| 35 | `BookImportWorkbookReaderTest` | `testReadWorkbookWithOnlyHeaderRows` | 23 ms | ✅ PASS | OK |
| 36 | `BookImportWorkbookReaderTest` | `testReadWorkbookMissingBooksSheet` | 25 ms | ✅ PASS | OK |
| 37 | `CsvExportUtilTest` | `testFormatTimestampValid` | 1 ms | ✅ PASS | OK |
| 38 | `CsvExportUtilTest` | `testFormulaInjectionNeutralization` | 0 ms | ✅ PASS | OK |
| 39 | `CsvExportUtilTest` | `testFormatTimestampNull` | 0 ms | ✅ PASS | OK |
| 40 | `CsvExportUtilTest` | `testEscapeNull` | 0 ms | ✅ PASS | OK |
| 41 | `CsvExportUtilTest` | `testEscapeEmptyString` | 0 ms | ✅ PASS | OK |
| 42 | `CsvExportUtilTest` | `testUtf8BomWriter` | 0 ms | ✅ PASS | OK |
| 43 | `CsvExportUtilTest` | `testEscapeNormalText` | 0 ms | ✅ PASS | OK |
| 44 | `CsvExportUtilTest` | `testEscapeSpecialCharactersCommaAndQuotes` | 0 ms | ✅ PASS | OK |
| 45 | `CsvExportUtilTest` | `testEscapeFormulaWithLeadingSpaces` | 0 ms | ✅ PASS | OK |
| 46 | `GoogleSSOUtilTest` | `testConstantsNotNull` | 0 ms | ✅ PASS | OK |
| 47 | `GoogleSSOUtilTest` | `testGetUserEmailInvalidAccessTokenThrowsException` | 327 ms | ✅ PASS | OK |
| 48 | `GoogleSSOUtilTest` | `testGetTokenInvalidCodeThrowsException` | 161 ms | ✅ PASS | OK |
| 49 | `GoogleSSOUtilTest` | `testGetLoginUrlContainsOAuthParams` | 0 ms | ✅ PASS | OK |
| 50 | `IsbnValidatorTest` | `testValidIsbn13Standard` | 0 ms | ✅ PASS | OK |
| 51 | `IsbnValidatorTest` | `testBoundaryLength13Digits` | 0 ms | ✅ PASS | OK |
| 52 | `IsbnValidatorTest` | `testInvalidNullOrEmptyIsbn` | 0 ms | ✅ PASS | OK |
| 53 | `IsbnValidatorTest` | `testValidIsbn10Standard` | 0 ms | ✅ PASS | OK |
| 54 | `IsbnValidatorTest` | `testNormalizeValidString` | 0 ms | ✅ PASS | OK |
| 55 | `IsbnValidatorTest` | `testInvalidChecksum` | 0 ms | ✅ PASS | OK |
| 56 | `IsbnValidatorTest` | `testBoundaryLength10Digits` | 0 ms | ✅ PASS | OK |
| 57 | `IsbnValidatorTest` | `testValidIsbnWithHyphensAndSpaces` | 0 ms | ✅ PASS | OK |
| 58 | `IsbnValidatorTest` | `testInvalidCharacters` | 0 ms | ✅ PASS | OK |
| 59 | `IsbnValidatorTest` | `testNormalizeNullAndEmpty` | 0 ms | ✅ PASS | OK |
| 60 | `IsbnValidatorTest` | `testInvalidLengthTooShortOrLong` | 0 ms | ✅ PASS | OK |
| 61 | `IsbnValidatorTest` | `testValidIsbn10WithChecksumX` | 0 ms | ✅ PASS | OK |
| 62 | `SupabaseStorageClientTest` | `testIsConfiguredFalse` | 3 ms | ✅ PASS | OK |
| 63 | `SupabaseStorageClientTest` | `testPublicObjectUrlGeneration` | 2 ms | ✅ PASS | OK |
| 64 | `SupabaseStorageClientTest` | `testUploadPublicObjectUnconfiguredThrowsException` | 2 ms | ✅ PASS | OK |
| 65 | `SupabaseStorageClientTest` | `testUrlNormalizationWithTrailingSlashes` | 3 ms | ✅ PASS | OK |
| 66 | `SupabaseStorageClientTest` | `testGetConfigurationStatus` | 2 ms | ✅ PASS | OK |
| 67 | `SupabaseStorageClientTest` | `testPublicObjectUrlUnconfiguredThrowsException` | 1 ms | ✅ PASS | OK |
| 68 | `SupabaseStorageClientTest` | `testIsConfiguredTrue` | 2 ms | ✅ PASS | OK |
| 69 | `AiChatbotServiceTest` | `testClassifyIntentBooks` | 1 ms | ✅ PASS | OK |
| 70 | `AiChatbotServiceTest` | `testClassifyIntentRules` | 0 ms | ✅ PASS | OK |
| 71 | `AiChatbotServiceTest` | `testClassifyIntentWithWhitespaceAndCaseSensitivity` | 1 ms | ✅ PASS | OK |
| 72 | `AiChatbotServiceTest` | `testClassifyIntentNullReturnsIrrelevant` | 0 ms | ✅ PASS | OK |
| 73 | `AiChatbotServiceTest` | `testClassifyIntentGreetingIrrelevant` | 0 ms | ✅ PASS | OK |
| 74 | `AiChatbotServiceTest` | `testClassifyIntentEmptyReturnsIrrelevant` | 0 ms | ✅ PASS | OK |
| 75 | `AiRecommendationServiceTest` | `testGetRecommendationsNullCandidatePoolReturnsNull` | 4 ms | ✅ PASS | OK |
| 76 | `AiRecommendationServiceTest` | `testGetRecommendationsEmptyCandidatePoolReturnsNull` | 0 ms | ✅ PASS | OK |
| 77 | `AiRecommendationServiceTest` | `testServiceInstantiation` | 0 ms | ✅ PASS | OK |
| 78 | `AuthServiceTest` | `testVerifyPasswordWrongPassword` | 123 ms | ✅ PASS | OK |
| 79 | `AuthServiceTest` | `testIsAccountLockedExpiredTimestamp` | 1 ms | ✅ PASS | OK |
| 80 | `AuthServiceTest` | `testIsAccountNotLockedForActiveUser` | 0 ms | ✅ PASS | OK |
| 81 | `AuthServiceTest` | `testVerifyPasswordInvalidHashPrefix` | 0 ms | ✅ PASS | OK |
| 82 | `AuthServiceTest` | `testVerifyPasswordSuccess` | 121 ms | ✅ PASS | OK |
| 83 | `AuthServiceTest` | `testVerifyPasswordNullPlainOrHash` | 120 ms | ✅ PASS | OK |
| 84 | `AuthServiceTest` | `testIsAccountLockedPermanentlyByAdmin` | 0 ms | ✅ PASS | OK |
| 85 | `AuthServiceTest` | `testIsAccountLockedNullUser` | 0 ms | ✅ PASS | OK |
| 86 | `AuthServiceTest` | `testIsAccountLockedFutureTimestamp` | 0 ms | ✅ PASS | OK |
| 87 | `BookCopyIncidentServiceTest` | `testValidateReportDescriptionBoundary1000` | 3 ms | ✅ PASS | OK |
| 88 | `BookCopyIncidentServiceTest` | `testValidateReportNullBarcode` | 0 ms | ✅ PASS | OK |
| 89 | `BookCopyIncidentServiceTest` | `testValidateReportValidLost` | 0 ms | ✅ PASS | OK |
| 90 | `BookCopyIncidentServiceTest` | `testValidateRemovalNoteBlank` | 0 ms | ✅ PASS | OK |
| 91 | `BookCopyIncidentServiceTest` | `testValidateRemovalNoteValid` | 0 ms | ✅ PASS | OK |
| 92 | `BookCopyIncidentServiceTest` | `testValidateRepairNoteBlank` | 0 ms | ✅ PASS | OK |
| 93 | `BookCopyIncidentServiceTest` | `testValidateRepairNoteValid` | 0 ms | ✅ PASS | OK |
| 94 | `BookCopyIncidentServiceTest` | `testValidateReportValidDamaged` | 1 ms | ✅ PASS | OK |
| 95 | `BookCopyIncidentServiceTest` | `testValidateReportInvalidType` | 0 ms | ✅ PASS | OK |
| 96 | `BookCopyIncidentServiceTest` | `testValidateResolutionBoundary1000` | 0 ms | ✅ PASS | OK |
| 97 | `BookCopyIncidentServiceTest` | `testValidateResolutionBlank` | 0 ms | ✅ PASS | OK |
| 98 | `BookCopyIncidentServiceTest` | `testValidateResolutionValid` | 0 ms | ✅ PASS | OK |
| 99 | `BookCopyIncidentServiceTest` | `testValidateRemovalNoteBoundary1000` | 0 ms | ✅ PASS | OK |
| 100 | `BookCopyIncidentServiceTest` | `testValidateReportBlankDescription` | 0 ms | ✅ PASS | OK |
| 101 | `BookCopyIncidentServiceTest` | `testValidateRemovalNoteExceeds1000` | 0 ms | ✅ PASS | OK |
| 102 | `BookCopyIncidentServiceTest` | `testValidateReportDescriptionExceeds1000` | 0 ms | ✅ PASS | OK |
| 103 | `BookCopyServiceTest` | `testValidateCreateNullBarcode` | 1 ms | ✅ PASS | OK |
| 104 | `BookCopyServiceTest` | `testValidateCreateLocationExceeds255` | 0 ms | ✅ PASS | OK |
| 105 | `BookCopyServiceTest` | `testValidateCreateBarcodeSpecialChars` | 0 ms | ✅ PASS | OK |
| 106 | `BookCopyServiceTest` | `testValidateCreateBlankLocation` | 0 ms | ✅ PASS | OK |
| 107 | `BookCopyServiceTest` | `testValidateUpdateValidCopy` | 0 ms | ✅ PASS | OK |
| 108 | `BookCopyServiceTest` | `testValidateCreateBarcodeLength50` | 0 ms | ✅ PASS | OK |
| 109 | `BookCopyServiceTest` | `testValidateCreateInvalidBookId` | 0 ms | ✅ PASS | OK |
| 110 | `BookCopyServiceTest` | `testValidateCreateLocationLength255` | 0 ms | ✅ PASS | OK |
| 111 | `BookCopyServiceTest` | `testValidateCreateBarcodeExceeds50` | 0 ms | ✅ PASS | OK |
| 112 | `BookCopyServiceTest` | `testValidateCreateValidCopy` | 0 ms | ✅ PASS | OK |
| 113 | `BookCopyServiceTest` | `testValidateUpdateInvalidCopyId` | 0 ms | ✅ PASS | OK |
| 114 | `BookImportServiceTest` | `testValidateEmptyPreview` | 888 ms | ✅ PASS | OK |
| 115 | `BookImportServiceTest` | `testBookImportServiceInstantiation` | 0 ms | ✅ PASS | OK |
| 116 | `BookImportServiceTest` | `testValidatePreviewWithErrors` | 1627 ms | ✅ PASS | OK |
| 117 | `BookImportValidatorTest` | `testInvalidCategoryExceeds255Chars` | 0 ms | ✅ PASS | OK |
| 118 | `BookImportValidatorTest` | `testValidCategoryAndTagLengths` | 0 ms | ✅ PASS | OK |
| 119 | `BookImportValidatorTest` | `testInvalidTagExceeds100Chars` | 0 ms | ✅ PASS | OK |
| 120 | `BookImportValidatorTest` | `testValidatorInstantiation` | 0 ms | ✅ PASS | OK |
| 121 | `BookServiceTest` | `testValidateInvalidPublicationYearInFuture` | 1 ms | ✅ PASS | OK |
| 122 | `BookServiceTest` | `testValidateValidBookUpdate` | 0 ms | ✅ PASS | OK |
| 123 | `BookServiceTest` | `testValidateInvalidStatus` | 0 ms | ✅ PASS | OK |
| 124 | `BookServiceTest` | `testValidateInvalidIsbnFormatOnCreation` | 0 ms | ✅ PASS | OK |
| 125 | `BookServiceTest` | `testValidateNegativePrice` | 0 ms | ✅ PASS | OK |
| 126 | `BookServiceTest` | `testValidateBoundaryTitleLength500` | 0 ms | ✅ PASS | OK |
| 127 | `BookServiceTest` | `testValidateBlankTitle` | 0 ms | ✅ PASS | OK |
| 128 | `BookServiceTest` | `testValidateBoundaryPublicationYear` | 1 ms | ✅ PASS | OK |
| 129 | `BookServiceTest` | `testValidateBoundaryZeroPrice` | 0 ms | ✅ PASS | OK |
| 130 | `BookServiceTest` | `testValidateValidBookCreation` | 0 ms | ✅ PASS | OK |
| 131 | `BookServiceTest` | `testValidateInvalidPublicationYearTooOld` | 0 ms | ✅ PASS | OK |
| 132 | `BookServiceTest` | `testValidateTitleExceeds500Chars` | 0 ms | ✅ PASS | OK |
| 133 | `BookServiceTest` | `testValidateNullIsbnOnCreation` | 0 ms | ✅ PASS | OK |
| 134 | `BookSuggestionServiceTest` | `testValidateReasonExceeds1000` | 2 ms | ✅ PASS | OK |
| 135 | `BookSuggestionServiceTest` | `testValidateBoundaryTitleLength255` | 0 ms | ✅ PASS | OK |
| 136 | `BookSuggestionServiceTest` | `testValidateBoundaryReasonLength1000` | 0 ms | ✅ PASS | OK |
| 137 | `BookSuggestionServiceTest` | `testValidateIsbnTooShort` | 0 ms | ✅ PASS | OK |
| 138 | `BookSuggestionServiceTest` | `testValidateBlankAuthor` | 0 ms | ✅ PASS | OK |
| 139 | `BookSuggestionServiceTest` | `testValidateValidSuggestion` | 0 ms | ✅ PASS | OK |
| 140 | `BookSuggestionServiceTest` | `testValidateNullTitle` | 0 ms | ✅ PASS | OK |
| 141 | `CategoryServiceTest` | `testValidateBoundaryNameLength1` | 0 ms | ✅ PASS | OK |
| 142 | `CategoryServiceTest` | `testValidateInvalidStatus` | 2 ms | ✅ PASS | OK |
| 143 | `CategoryServiceTest` | `testValidateNameExceeds255Chars` | 0 ms | ✅ PASS | OK |
| 144 | `CategoryServiceTest` | `testValidateBoundaryNameLength255` | 0 ms | ✅ PASS | OK |
| 145 | `CategoryServiceTest` | `testValidateValidActiveCategory` | 0 ms | ✅ PASS | OK |
| 146 | `CategoryServiceTest` | `testValidateNullName` | 0 ms | ✅ PASS | OK |
| 147 | `CategoryServiceTest` | `testValidateValidHiddenCategory` | 0 ms | ✅ PASS | OK |
| 148 | `CategoryServiceTest` | `testValidateBlankName` | 0 ms | ✅ PASS | OK |
| 149 | `DeskCirculationServiceTest` | `testCheckInNullBarcode` | 915 ms | ✅ PASS | OK |
| 150 | `DeskCirculationServiceTest` | `testCheckOutBlankBarcode` | 855 ms | ✅ PASS | OK |
| 151 | `DeskCirculationServiceTest` | `testCheckInInvalidCondition` | 0 ms | ✅ PASS | OK |
| 152 | `DeskCirculationServiceTest` | `testCheckInBlankBarcode` | 975 ms | ✅ PASS | OK |
| 153 | `DeskCirculationServiceTest` | `testServiceInstantiation` | 0 ms | ✅ PASS | OK |
| 154 | `DeskCirculationServiceTest` | `testCheckOutBoundaryInvalidLibrarianIdZero` | 993 ms | ✅ PASS | OK |
| 155 | `DeskCirculationServiceTest` | `testCheckOutNullBarcode` | 876 ms | ✅ PASS | OK |
| 156 | `EmailServiceTest` | `testEnqueueNullJob` | 7 ms | ✅ PASS | OK |
| 157 | `EmailServiceTest` | `testEnqueueUppercaseGmail` | 1 ms | ✅ PASS | OK |
| 158 | `EmailServiceTest` | `testEnqueueValidGmail` | 0 ms | ✅ PASS | OK |
| 159 | `EmailServiceTest` | `testEnqueueNonGmailIgnored` | 1 ms | ✅ PASS | OK |
| 160 | `EmailServiceTest` | `testEnqueueNullRecipientEmailIgnored` | 2 ms | ✅ PASS | OK |
| 161 | `EmailWorkerTest` | `testEmailWorkerShutdownFlag` | 4 ms | ✅ PASS | OK |
| 162 | `ExcelExportServiceTest` | `testExportSystemReportEmptyData` | 36 ms | ✅ PASS | OK |
| 163 | `InventoryReconciliationServiceTest` | `testValidateLocationBlank` | 5 ms | ✅ PASS | OK |
| 164 | `InventoryReconciliationServiceTest` | `testValidateLocationValid` | 0 ms | ✅ PASS | OK |
| 165 | `InventoryReconciliationServiceTest` | `testValidateLocationBoundary255` | 0 ms | ✅ PASS | OK |
| 166 | `InventoryReconciliationServiceTest` | `testScanBlankBarcode` | 0 ms | ✅ PASS | OK |
| 167 | `InventoryReconciliationServiceTest` | `testValidateLocationExceeds255` | 1 ms | ✅ PASS | OK |
| 168 | `InventoryReconciliationServiceTest` | `testValidateLocationNull` | 0 ms | ✅ PASS | OK |
| 169 | `InventoryReconciliationServiceTest` | `testScanNullBarcode` | 0 ms | ✅ PASS | OK |
| 170 | `OnlineCirculationServiceTest` | `testReserveBookBoundaryUserIdZero` | 1589 ms | ✅ PASS | OK |
| 171 | `OnlineCirculationServiceTest` | `testReserveBookBoundaryBookIdZero` | 2004 ms | ✅ PASS | OK |
| 172 | `OnlineCirculationServiceTest` | `testRenewBookInvalidRecordId` | 1526 ms | ✅ PASS | OK |
| 173 | `OnlineCirculationServiceTest` | `testReserveBookNegativeBookId` | 1953 ms | ✅ PASS | OK |
| 174 | `OnlineCirculationServiceTest` | `testReserveBookNegativeUserId` | 1556 ms | ✅ PASS | OK |
| 175 | `OnlineCirculationServiceTest` | `testServiceInstantiation` | 0 ms | ✅ PASS | OK |
| 176 | `ProcessorTest` | `testProcessOverdueOffline` | 922 ms | ✅ PASS | OK |
| 177 | `ProcessorTest` | `testProcessorInstantiation` | 1 ms | ✅ PASS | OK |
| 178 | `ProfileServiceTest` | `testChangePasswordWeakPasswordPolicyThrowsException` | 0 ms | ✅ PASS | OK |
| 179 | `ProfileServiceTest` | `testUpdateUserInfoInvalidDateFormatThrowsException` | 0 ms | ✅ PASS | OK |
| 180 | `ProfileServiceTest` | `testUpdateUserInfoBlankNameThrowsException` | 0 ms | ✅ PASS | OK |
| 181 | `ProfileServiceTest` | `testUpdateUserInfoNullNameThrowsException` | 0 ms | ✅ PASS | OK |
| 182 | `ProfileServiceTest` | `testChangePasswordMismatchConfirmPasswordThrowsException` | 1 ms | ✅ PASS | OK |
| 183 | `ProfileServiceTest` | `testServiceInstantiation` | 0 ms | ✅ PASS | OK |
| 184 | `ReportServiceTest` | `testExportSystemReportToExcelSuccess` | 141 ms | ✅ PASS | OK |
| 185 | `ReportServiceTest` | `testExportSystemReportWithEmptyDataMap` | 15 ms | ✅ PASS | OK |
| 186 | `ReservationExpirationProcessorTest` | `testProcessExpirationExecution` | 925 ms | ✅ PASS | OK |
| 187 | `ReservationExpirationProcessorTest` | `testProcessorInstantiation` | 0 ms | ✅ PASS | OK |
| 188 | `SystemConfigServiceTest` | `testValidateValuePositiveIntSuccess` | 0 ms | ✅ PASS | OK |
| 189 | `SystemConfigServiceTest` | `testValidateValueNonNegativeDecimalSuccess` | 1 ms | ✅ PASS | OK |
| 190 | `SystemConfigServiceTest` | `testValidateValuePositiveIntNegativeThrowsException` | 0 ms | ✅ PASS | OK |
| 191 | `SystemConfigServiceTest` | `testValidateValueNonNegativeIntSuccess` | 0 ms | ✅ PASS | OK |
| 192 | `SystemConfigServiceTest` | `testValidateValueNonNegativeDecimalBoundaryZero` | 0 ms | ✅ PASS | OK |
| 193 | `SystemConfigServiceTest` | `testValidateValuePositiveIntZeroThrowsException` | 0 ms | ✅ PASS | OK |
| 194 | `SystemConfigServiceTest` | `testValidateValueNonNegativeDecimalNegativeThrowsException` | 0 ms | ✅ PASS | OK |
| 195 | `SystemConfigServiceTest` | `testValidateValueBlankThrowsException` | 0 ms | ✅ PASS | OK |
| 196 | `SystemConfigServiceTest` | `testValidateValuePositiveIntBoundaryOne` | 0 ms | ✅ PASS | OK |
| 197 | `SystemConfigServiceTest` | `testValidateValueInvalidNumberFormatThrowsException` | 0 ms | ✅ PASS | OK |
| 198 | `SystemConfigServiceTest` | `testValidateValueNonNegativeIntNegativeThrowsException` | 0 ms | ✅ PASS | OK |
| 199 | `SystemConfigServiceTest` | `testValidateValueNonNegativeIntBoundaryZero` | 0 ms | ✅ PASS | OK |
| 200 | `SystemConfigServiceTest` | `testValidateValueNullThrowsException` | 0 ms | ✅ PASS | OK |
| 201 | `SystemConfigServiceTest` | `testValidateValueStringSuccess` | 0 ms | ✅ PASS | OK |
| 202 | `TagServiceTest` | `testValidateValidHiddenTag` | 1 ms | ✅ PASS | OK |
| 203 | `TagServiceTest` | `testValidateBoundaryNameLength1` | 0 ms | ✅ PASS | OK |
| 204 | `TagServiceTest` | `testValidateInvalidStatus` | 0 ms | ✅ PASS | OK |
| 205 | `TagServiceTest` | `testValidateBoundaryNameLength100` | 0 ms | ✅ PASS | OK |
| 206 | `TagServiceTest` | `testValidateNullName` | 0 ms | ✅ PASS | OK |
| 207 | `TagServiceTest` | `testValidateNameExceeds100Chars` | 0 ms | ✅ PASS | OK |
| 208 | `TagServiceTest` | `testValidateValidActiveTag` | 0 ms | ✅ PASS | OK |
| 209 | `TagServiceTest` | `testValidateBlankName` | 0 ms | ✅ PASS | OK |
| 210 | `UserServiceTest` | `testImportUsersEmptyList` | 0 ms | ✅ PASS | OK |
| 211 | `UserServiceTest` | `testUserServiceInstantiation` | 0 ms | ✅ PASS | OK |
| 212 | `UserServiceTest` | `testImportUsersNullList` | 0 ms | ✅ PASS | OK |

