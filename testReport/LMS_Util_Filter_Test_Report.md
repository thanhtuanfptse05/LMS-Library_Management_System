# BÁO CÁO KẾT QUẢ KIỂM THỬ TẦNG TIỆN ÍCH VÀ BẢO MẬT (UTIL & FILTER LAYER)

- **Thời gian xuất báo cáo:** 24/07/2026 21:44:13
- **Tổng số test cases:** 54 cases
- **Số case thành công:** 54
- **Số case thất bại:** 0
- **Thời gian thực thi:** 20147 ms
- **Trạng thái chung:** PASSED (100%)

## 1. Tóm tắt theo Test Suite

| Tên Test Suite | Số Test Cases | Thành công | Thất bại | Trạng thái |
| --- | --- | --- | --- | --- |
| `filter.AuthFilterTest` | 6 | 6 | 0 | ✅ PASS |
| `util.BookCoverFetcherTest` | 3 | 3 | 0 | ✅ PASS |
| `util.BookImageStorageTest` | 8 | 8 | 0 | ✅ PASS |
| `util.BookImportWorkbookReaderTest` | 5 | 5 | 0 | ✅ PASS |
| `util.CsvExportUtilTest` | 9 | 9 | 0 | ✅ PASS |
| `util.GoogleSSOUtilTest` | 4 | 4 | 0 | ✅ PASS |
| `util.IsbnValidatorTest` | 12 | 12 | 0 | ✅ PASS |
| `util.SupabaseStorageClientTest` | 7 | 7 | 0 | ✅ PASS |

## 2. Nhật ký chi tiết từng Test Case

| STT | Test Suite | Tên Test Case | Thời gian | Trạng thái | Ghi chú / Lỗi |
| --- | --- | --- | --- | --- | --- |
| 1 | `AuthFilterTest` | `testBypassRoutesMatch` | 0 ms | ✅ PASS | OK |
| 2 | `AuthFilterTest` | `testRoleRouteMatchingLogicAllRoles` | 0 ms | ✅ PASS | OK |
| 3 | `AuthFilterTest` | `testAuthFilterInstantiation` | 1 ms | ✅ PASS | OK |
| 4 | `AuthFilterTest` | `testFilterLifecycleMethods` | 0 ms | ✅ PASS | OK |
| 5 | `AuthFilterTest` | `testStaticResourceExtensionCheckAllExtensions` | 2 ms | ✅ PASS | OK |
| 6 | `AuthFilterTest` | `testBookManagementLegacyRouteMatching` | 0 ms | ✅ PASS | OK |
| 7 | `BookCoverFetcherTest` | `testBookCoverFetcherInstantiation` | 228 ms | ✅ PASS | OK |
| 8 | `BookCoverFetcherTest` | `testNullIsbnHandling` | 4 ms | ✅ PASS | OK |
| 9 | `BookCoverFetcherTest` | `testIsbnFormattingForFetcher` | 2 ms | ✅ PASS | OK |
| 10 | `BookImageStorageTest` | `testMaxFileSizeConstant` | 2 ms | ✅ PASS | OK |
| 11 | `BookImageStorageTest` | `testResolveValidJpgFilename` | 1 ms | ✅ PASS | OK |
| 12 | `BookImageStorageTest` | `testResolveArbitraryStringThrowsException` | 2 ms | ✅ PASS | OK |
| 13 | `BookImageStorageTest` | `testResolveNullFilenameThrowsException` | 2 ms | ✅ PASS | OK |
| 14 | `BookImageStorageTest` | `testResolveInvalidExtensionThrowsException` | 1 ms | ✅ PASS | OK |
| 15 | `BookImageStorageTest` | `testResolveUppercaseHexUuid` | 1 ms | ✅ PASS | OK |
| 16 | `BookImageStorageTest` | `testResolveValidPngFilename` | 1 ms | ✅ PASS | OK |
| 17 | `BookImageStorageTest` | `testResolvePathTraversalAttemptThrowsException` | 1 ms | ✅ PASS | OK |
| 18 | `BookImportWorkbookReaderTest` | `testReadValidWorkbook` | 859 ms | ✅ PASS | OK |
| 19 | `BookImportWorkbookReaderTest` | `testReadWorkbookInvalidHeaders` | 29 ms | ✅ PASS | OK |
| 20 | `BookImportWorkbookReaderTest` | `testReadWorkbookMissingCopiesSheet` | 26 ms | ✅ PASS | OK |
| 21 | `BookImportWorkbookReaderTest` | `testReadWorkbookWithOnlyHeaderRows` | 23 ms | ✅ PASS | OK |
| 22 | `BookImportWorkbookReaderTest` | `testReadWorkbookMissingBooksSheet` | 25 ms | ✅ PASS | OK |
| 23 | `CsvExportUtilTest` | `testFormatTimestampValid` | 1 ms | ✅ PASS | OK |
| 24 | `CsvExportUtilTest` | `testFormulaInjectionNeutralization` | 0 ms | ✅ PASS | OK |
| 25 | `CsvExportUtilTest` | `testFormatTimestampNull` | 0 ms | ✅ PASS | OK |
| 26 | `CsvExportUtilTest` | `testEscapeNull` | 0 ms | ✅ PASS | OK |
| 27 | `CsvExportUtilTest` | `testEscapeEmptyString` | 0 ms | ✅ PASS | OK |
| 28 | `CsvExportUtilTest` | `testUtf8BomWriter` | 0 ms | ✅ PASS | OK |
| 29 | `CsvExportUtilTest` | `testEscapeNormalText` | 0 ms | ✅ PASS | OK |
| 30 | `CsvExportUtilTest` | `testEscapeSpecialCharactersCommaAndQuotes` | 0 ms | ✅ PASS | OK |
| 31 | `CsvExportUtilTest` | `testEscapeFormulaWithLeadingSpaces` | 0 ms | ✅ PASS | OK |
| 32 | `GoogleSSOUtilTest` | `testConstantsNotNull` | 0 ms | ✅ PASS | OK |
| 33 | `GoogleSSOUtilTest` | `testGetUserEmailInvalidAccessTokenThrowsException` | 327 ms | ✅ PASS | OK |
| 34 | `GoogleSSOUtilTest` | `testGetTokenInvalidCodeThrowsException` | 161 ms | ✅ PASS | OK |
| 35 | `GoogleSSOUtilTest` | `testGetLoginUrlContainsOAuthParams` | 0 ms | ✅ PASS | OK |
| 36 | `IsbnValidatorTest` | `testValidIsbn13Standard` | 0 ms | ✅ PASS | OK |
| 37 | `IsbnValidatorTest` | `testBoundaryLength13Digits` | 0 ms | ✅ PASS | OK |
| 38 | `IsbnValidatorTest` | `testInvalidNullOrEmptyIsbn` | 0 ms | ✅ PASS | OK |
| 39 | `IsbnValidatorTest` | `testValidIsbn10Standard` | 0 ms | ✅ PASS | OK |
| 40 | `IsbnValidatorTest` | `testNormalizeValidString` | 0 ms | ✅ PASS | OK |
| 41 | `IsbnValidatorTest` | `testInvalidChecksum` | 0 ms | ✅ PASS | OK |
| 42 | `IsbnValidatorTest` | `testBoundaryLength10Digits` | 0 ms | ✅ PASS | OK |
| 43 | `IsbnValidatorTest` | `testValidIsbnWithHyphensAndSpaces` | 0 ms | ✅ PASS | OK |
| 44 | `IsbnValidatorTest` | `testInvalidCharacters` | 0 ms | ✅ PASS | OK |
| 45 | `IsbnValidatorTest` | `testNormalizeNullAndEmpty` | 0 ms | ✅ PASS | OK |
| 46 | `IsbnValidatorTest` | `testInvalidLengthTooShortOrLong` | 0 ms | ✅ PASS | OK |
| 47 | `IsbnValidatorTest` | `testValidIsbn10WithChecksumX` | 0 ms | ✅ PASS | OK |
| 48 | `SupabaseStorageClientTest` | `testIsConfiguredFalse` | 3 ms | ✅ PASS | OK |
| 49 | `SupabaseStorageClientTest` | `testPublicObjectUrlGeneration` | 2 ms | ✅ PASS | OK |
| 50 | `SupabaseStorageClientTest` | `testUploadPublicObjectUnconfiguredThrowsException` | 2 ms | ✅ PASS | OK |
| 51 | `SupabaseStorageClientTest` | `testUrlNormalizationWithTrailingSlashes` | 3 ms | ✅ PASS | OK |
| 52 | `SupabaseStorageClientTest` | `testGetConfigurationStatus` | 2 ms | ✅ PASS | OK |
| 53 | `SupabaseStorageClientTest` | `testPublicObjectUrlUnconfiguredThrowsException` | 1 ms | ✅ PASS | OK |
| 54 | `SupabaseStorageClientTest` | `testIsConfiguredTrue` | 2 ms | ✅ PASS | OK |

