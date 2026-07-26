# BÁO CÁO K?T QU? KI?M TH? TI?N ÍCH & B?O M?T (UTIL & FILTER LAYER)

- **Th?i gian xu?t báo cáo:** 24/07/2026 22:08:33
- **T?ng s? test cases:** 54 cases
- **S? case thành công:** 54
- **S? case th?t b?i:** 0
- **Tr?ng thái chung:** PASSED (100%)

## 1. Tóm t?t theo Test Suite

| Tên Test Suite | S? Test Cases | Thành công | Th?t b?i | Tr?ng thái |
| --- | --- | --- | --- | --- |
| `filter.AuthFilterTest` | 6 | 6 | 0 | ? PASS |
| `util.BookCoverFetcherTest` | 3 | 3 | 0 | ? PASS |
| `util.BookImageStorageTest` | 8 | 8 | 0 | ? PASS |
| `util.BookImportWorkbookReaderTest` | 5 | 5 | 0 | ? PASS |
| `util.CsvExportUtilTest` | 9 | 9 | 0 | ? PASS |
| `util.GoogleSSOUtilTest` | 4 | 4 | 0 | ? PASS |
| `util.IsbnValidatorTest` | 12 | 12 | 0 | ? PASS |
| `util.SupabaseStorageClientTest` | 7 | 7 | 0 | ? PASS |

## 2. Nh?t k? chi ti?t t?ng Test Case

| STT | Test Suite | Tên Test Case | Th?i gian | Tr?ng thái | Ghi chú / L?i |
| --- | --- | --- | --- | --- | --- |
| 1 | `AuthFilterTest` | `testStaticResourceExtensionCheckAllExtensions` | 0 ms | ? PASS | OK |
| 2 | `AuthFilterTest` | `testBookManagementLegacyRouteMatching` | 2 ms | ? PASS | OK |
| 3 | `AuthFilterTest` | `testRoleRouteMatchingLogicAllRoles` | 4 ms | ? PASS | OK |
| 4 | `AuthFilterTest` | `testFilterLifecycleMethods` | 4 ms | ? PASS | OK |
| 5 | `AuthFilterTest` | `testBypassRoutesMatch` | 2 ms | ? PASS | OK |
| 6 | `AuthFilterTest` | `testAuthFilterInstantiation` | 2 ms | ? PASS | OK |
| 7 | `BookCoverFetcherTest` | `testIsbnFormattingForFetcher` | 3 ms | ? PASS | OK |
| 8 | `BookCoverFetcherTest` | `testNullIsbnHandling` | 2 ms | ? PASS | OK |
| 9 | `BookCoverFetcherTest` | `testBookCoverFetcherInstantiation` | 0 ms | ? PASS | OK |
| 10 | `BookImageStorageTest` | `testResolvePathTraversalAttemptThrowsException` | 0 ms | ? PASS | OK |
| 11 | `BookImageStorageTest` | `testResolveArbitraryStringThrowsException` | 4 ms | ? PASS | OK |
| 12 | `BookImageStorageTest` | `testResolveNullFilenameThrowsException` | 1 ms | ? PASS | OK |
| 13 | `BookImageStorageTest` | `testResolveInvalidExtensionThrowsException` | 0 ms | ? PASS | OK |
| 14 | `BookImageStorageTest` | `testResolveValidPngFilename` | 3 ms | ? PASS | OK |
| 15 | `BookImageStorageTest` | `testMaxFileSizeConstant` | 4 ms | ? PASS | OK |
| 16 | `BookImageStorageTest` | `testResolveUppercaseHexUuid` | 3 ms | ? PASS | OK |
| 17 | `BookImageStorageTest` | `testResolveValidJpgFilename` | 4 ms | ? PASS | OK |
| 18 | `BookImportWorkbookReaderTest` | `testReadValidWorkbook` | 3 ms | ? PASS | OK |
| 19 | `BookImportWorkbookReaderTest` | `testReadWorkbookWithOnlyHeaderRows` | 2 ms | ? PASS | OK |
| 20 | `BookImportWorkbookReaderTest` | `testReadWorkbookInvalidHeaders` | 4 ms | ? PASS | OK |
| 21 | `BookImportWorkbookReaderTest` | `testReadWorkbookMissingBooksSheet` | 0 ms | ? PASS | OK |
| 22 | `BookImportWorkbookReaderTest` | `testReadWorkbookMissingCopiesSheet` | 1 ms | ? PASS | OK |
| 23 | `CsvExportUtilTest` | `testEscapeSpecialCharactersCommaAndQuotes` | 1 ms | ? PASS | OK |
| 24 | `CsvExportUtilTest` | `testEscapeNull` | 2 ms | ? PASS | OK |
| 25 | `CsvExportUtilTest` | `testUtf8BomWriter` | 2 ms | ? PASS | OK |
| 26 | `CsvExportUtilTest` | `testEscapeFormulaWithLeadingSpaces` | 0 ms | ? PASS | OK |
| 27 | `CsvExportUtilTest` | `testFormatTimestampNull` | 0 ms | ? PASS | OK |
| 28 | `CsvExportUtilTest` | `testFormatTimestampValid` | 3 ms | ? PASS | OK |
| 29 | `CsvExportUtilTest` | `testEscapeEmptyString` | 4 ms | ? PASS | OK |
| 30 | `CsvExportUtilTest` | `testEscapeNormalText` | 0 ms | ? PASS | OK |
| 31 | `CsvExportUtilTest` | `testFormulaInjectionNeutralization` | 0 ms | ? PASS | OK |
| 32 | `GoogleSSOUtilTest` | `testGetUserEmailInvalidAccessTokenThrowsException` | 4 ms | ? PASS | OK |
| 33 | `GoogleSSOUtilTest` | `testGetTokenInvalidCodeThrowsException` | 4 ms | ? PASS | OK |
| 34 | `GoogleSSOUtilTest` | `testGetLoginUrlContainsOAuthParams` | 4 ms | ? PASS | OK |
| 35 | `GoogleSSOUtilTest` | `testConstantsNotNull` | 2 ms | ? PASS | OK |
| 36 | `IsbnValidatorTest` | `testValidIsbn13Standard` | 0 ms | ? PASS | OK |
| 37 | `IsbnValidatorTest` | `testNormalizeValidString` | 2 ms | ? PASS | OK |
| 38 | `IsbnValidatorTest` | `testBoundaryLength13Digits` | 4 ms | ? PASS | OK |
| 39 | `IsbnValidatorTest` | `testInvalidCharacters` | 4 ms | ? PASS | OK |
| 40 | `IsbnValidatorTest` | `testValidIsbn10WithChecksumX` | 1 ms | ? PASS | OK |
| 41 | `IsbnValidatorTest` | `testInvalidChecksum` | 0 ms | ? PASS | OK |
| 42 | `IsbnValidatorTest` | `testBoundaryLength10Digits` | 2 ms | ? PASS | OK |
| 43 | `IsbnValidatorTest` | `testValidIsbnWithHyphensAndSpaces` | 3 ms | ? PASS | OK |
| 44 | `IsbnValidatorTest` | `testInvalidNullOrEmptyIsbn` | 1 ms | ? PASS | OK |
| 45 | `IsbnValidatorTest` | `testInvalidLengthTooShortOrLong` | 0 ms | ? PASS | OK |
| 46 | `IsbnValidatorTest` | `testValidIsbn10Standard` | 2 ms | ? PASS | OK |
| 47 | `IsbnValidatorTest` | `testNormalizeNullAndEmpty` | 3 ms | ? PASS | OK |
| 48 | `SupabaseStorageClientTest` | `testUrlNormalizationWithTrailingSlashes` | 2 ms | ? PASS | OK |
| 49 | `SupabaseStorageClientTest` | `testPublicObjectUrlUnconfiguredThrowsException` | 4 ms | ? PASS | OK |
| 50 | `SupabaseStorageClientTest` | `testUploadPublicObjectUnconfiguredThrowsException` | 2 ms | ? PASS | OK |
| 51 | `SupabaseStorageClientTest` | `testIsConfiguredTrue` | 0 ms | ? PASS | OK |
| 52 | `SupabaseStorageClientTest` | `testGetConfigurationStatus` | 4 ms | ? PASS | OK |
| 53 | `SupabaseStorageClientTest` | `testPublicObjectUrlGeneration` | 0 ms | ? PASS | OK |
| 54 | `SupabaseStorageClientTest` | `testIsConfiguredFalse` | 3 ms | ? PASS | OK |
