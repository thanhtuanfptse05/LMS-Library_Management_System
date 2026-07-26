<!-- converted from LMS_Unit_Test_Report.xlsx -->

## Sheet: Cover
|  | UNIT TEST CASE |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| Project Name | LMS - Library Management System |  |  | Creator | SWP391 Dev Team |
| Project Code | SWP391_LMS |  |  | Reviewer/Approver | Instructor |
| Document Code | SWP391_LMS_UT_v1.0 |  |  | Issue Date | 12/07/2026 |
|  |  |  |  | Version | 1.0 |
| Record of change |  |  |  |  |  |
| Effective Date | Version | Change Item | *A,D,M | Change description | Reference |
| 12/07/2026 | 1.0 | Initial | A | Initial version | AGENTS.md |
## Sheet: FunctionList
|  |  |  |  | UNIT TEST CASE LIST |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Project Name |  |  |  | LMS - Library Management System |  |  |  |
| Project Code |  |  |  | SWP391_LMS |  |  |  |
| Normal number of Test cases/KLOC |  |  |  | 100 |  |  |  |
| Test Environment Setup Description |  |  |  | 1. Java JDK 17
2. PostgreSQL (Supabase)
3. JUnit 4.13.2 |  |  |  |
| No | Requirement
Name | Class Name | Function Name | Function Code | Sheet Name | Description | Pre-Condition |
| 1 | asyncEmailSender | EmailJob | EmailJobTest | EmailJobTest | EmailJobTest | Unit test EmailJob (50 TCs: 50N/0A/0B) | Java JDK 17, DB ready |
| 2 | asyncEmailSender | EmailService | EmailServiceTest | EmailServiceTest | EmailServiceTest | Unit test EmailService (50 TCs: 49N/1A/0B) | Java JDK 17, DB ready |
| 3 | asyncEmailSender | EmailTrigger | EmailTriggerIntegrationTest | EmailTriggerIntegrationTest | EmailTriggerIntegrationTest | Unit test EmailTrigger (50 TCs: 50N/0A/0B) | Java JDK 17, DB ready |
| 4 | asyncEmailSender | EmailWorker | EmailWorkerTest | EmailWorkerTest | EmailWorkerTest | Unit test EmailWorker (50 TCs: 50N/0A/0B) | Java JDK 17, DB ready |
| 5 | dao | BookCopyDAO | BookCopyDAOTest | BookCopyDAOTest | BookCopyDAOTest | Unit test BookCopyDAO (1 TCs: 1N/0A/0B) | Java JDK 17, DB ready |
| 6 | dao | BookCopyIncidentDAO | BookCopyIncidentDAOTest | BookCopyIncidentDAOTest | BookCopyIncidentDAOTest | Unit test BookCopyIncidentDAO (2 TCs: 2N/0A/0B) | Java JDK 17, DB ready |
| 7 | dao | BookDAO | BookDAOTest | BookDAOTest | BookDAOTest | Unit test BookDAO (1 TCs: 0N/0A/1B) | Java JDK 17, DB ready |
| 8 | dao | BookImportDAO | BookImportDAOTest | BookImportDAOTest | BookImportDAOTest | Unit test BookImportDAO (2 TCs: 1N/1A/0B) | Java JDK 17, DB ready |
| 9 | dao | BorrowRecordDAO | BorrowRecordDAOTest | BorrowRecordDAOTest | BorrowRecordDAOTest | Unit test BorrowRecordDAO (4 TCs: 3N/1A/0B) | Java JDK 17, DB ready |
| 10 | dao | CategoryTagDAO | CategoryTagDAOTest | CategoryTagDAOTest | CategoryTagDAOTest | Unit test CategoryTagDAO (2 TCs: 2N/0A/0B) | Java JDK 17, DB ready |
| 11 | dao | FineDAO | FineDAOTest | FineDAOTest | FineDAOTest | Unit test FineDAO (3 TCs: 3N/0A/0B) | Java JDK 17, DB ready |
| 12 | dao | InventoryDAO | InventoryDAOTest | InventoryDAOTest | InventoryDAOTest | Unit test InventoryDAO (1 TCs: 1N/0A/0B) | Java JDK 17, DB ready |
| 13 | dao | ReservationDAO | ReservationDAOTest | ReservationDAOTest | ReservationDAOTest | Unit test ReservationDAO (3 TCs: 2N/1A/0B) | Java JDK 17, DB ready |
| 14 | dao | UserDAO | UserDAOTest | UserDAOTest | UserDAOTest | Unit test UserDAO (4 TCs: 3N/1A/0B) | Java JDK 17, DB ready |
| 15 | f14 | AiChatbotService | AiChatbotServiceIntegrationTest | AiChatbotServiceIntegrationTest | AiChatbotServiceIntegrationTest | Unit test AiChatbotService (31 TCs: 31N/0A/0B) | Java JDK 17, DB ready |
| 16 | f14 | AiChatbotService | AiChatbotServiceUnitTest | AiChatbotServiceUnitTest | AiChatbotServiceUnitTest | Unit test AiChatbotService (51 TCs: 51N/0A/0B) | Java JDK 17, DB ready |
| 17 | f14 | AiChatbotServlet | AiChatbotServletTest | AiChatbotServletTest | AiChatbotServletTest | Unit test AiChatbotServlet (21 TCs: 20N/1A/0B) | Java JDK 17, DB ready |
| 18 | f20 | BookSuggestionService | BookSuggestionServiceTest | BookSuggestionServiceTest | BookSuggestionServiceTest | Unit test BookSuggestionService (201 TCs: 193N/8A/0B) | Java JDK 17, DB ready |
| 19 | f5 | F5SystemServlet | F5SystemServletTest | F5SystemServletTest | F5SystemServletTest | Unit test F5SystemServlet (26 TCs: 25N/1A/0B) | Java JDK 17, DB ready |
| 20 | f5 | OnlineCirculationService | OnlineCirculationServiceIntegrationTest | OnlineCirculationServiceIntegra | OnlineCirculationServiceIntegra | Unit test OnlineCirculationService (13 TCs: 13N/0A/0B) | Java JDK 17, DB ready |
| 21 | f5 | OnlineCirculationService | OnlineCirculationServiceUnitTest | OnlineCirculationServiceUnitTes | OnlineCirculationServiceUnitTes | Unit test OnlineCirculationService (109 TCs: 94N/9A/6B) | Java JDK 17, DB ready |
| 22 | f6 | DeskCirculationService | DeskCirculationServiceIntegrationTest | DeskCirculationServiceIntegrati | DeskCirculationServiceIntegrati | Unit test DeskCirculationService (31 TCs: 28N/3A/0B) | Java JDK 17, DB ready |
| 23 | f6 | DeskCirculationService | DeskCirculationServiceUnitTest | DeskCirculationServiceUnitTest | DeskCirculationServiceUnitTest | Unit test DeskCirculationService (51 TCs: 46N/5A/0B) | Java JDK 17, DB ready |
| 24 | f6 | F6SystemServlet | F6SystemServletTest | F6SystemServletTest | F6SystemServletTest | Unit test F6SystemServlet (21 TCs: 20N/1A/0B) | Java JDK 17, DB ready |
| 25 | f8 | AiConfig | AiConfigTest | AiConfigTest | AiConfigTest | Unit test AiConfig (20 TCs: 20N/0A/0B) | Java JDK 17, DB ready |
| 26 | f8 | AiRecommendationService | AiRecommendationServiceTest | AiRecommendationServiceTest | AiRecommendationServiceTest | Unit test AiRecommendationService (45 TCs: 42N/3A/0B) | Java JDK 17, DB ready |
| 27 | f8 | BookDAO | BookDAOTest | BookDAOTest_26 | BookDAOTest_26 | Unit test BookDAO (63 TCs: 63N/0A/0B) | Java JDK 17, DB ready |
| 28 | f8 | BookDiscoverySystem | BookDiscoverySystemTest | BookDiscoverySystemTest | BookDiscoverySystemTest | Unit test BookDiscoverySystem (21 TCs: 21N/0A/0B) | Java JDK 17, DB ready |
| 29 | f8 | BookServlets | BookServletsTest | BookServletsTest | BookServletsTest | Unit test BookServlets (22 TCs: 16N/6A/0B) | Java JDK 17, DB ready |
| 30 | f8 | RecommendationServlet | RecommendationServletTest | RecommendationServletTest | RecommendationServletTest | Unit test RecommendationServlet (45 TCs: 44N/1A/0B) | Java JDK 17, DB ready |
| 31 | service | AuthService | AuthServiceTest | AuthServiceTest | AuthServiceTest | Unit test AuthService (11 TCs: 3N/7A/1B) | Java JDK 17, DB ready |
| 32 | service | BookCopyIncidentService | BookCopyIncidentServiceTest | BookCopyIncidentServiceTest | BookCopyIncidentServiceTest | Unit test BookCopyIncidentService (5 TCs: 1N/4A/0B) | Java JDK 17, DB ready |
| 33 | service | BookCopyService | BookCopyServiceTest | BookCopyServiceTest | BookCopyServiceTest | Unit test BookCopyService (3 TCs: 2N/1A/0B) | Java JDK 17, DB ready |
| 34 | service | BookImportService | BookImportServiceTest | BookImportServiceTest | BookImportServiceTest | Unit test BookImportService (4 TCs: 2N/2A/0B) | Java JDK 17, DB ready |
| 35 | service | BookService | BookServiceTest | BookServiceTest | BookServiceTest | Unit test BookService (6 TCs: 2N/4A/0B) | Java JDK 17, DB ready |
| 36 | service | CategoryService | CategoryServiceTest | CategoryServiceTest | CategoryServiceTest | Unit test CategoryService (2 TCs: 1N/1A/0B) | Java JDK 17, DB ready |
| 37 | service | InventoryReconciliationService | InventoryReconciliationServiceTest | InventoryReconciliationServiceT | InventoryReconciliationServiceT | Unit test InventoryReconciliationService (2 TCs: 1N/1A/0B) | Java JDK 17, DB ready |
| 38 | service | OnlineCirculationService | OnlineCirculationServiceTest | OnlineCirculationServiceTest | OnlineCirculationServiceTest | Unit test OnlineCirculationService (27 TCs: 10N/13A/4B) | Java JDK 17, DB ready |
| 39 | service | OverdueProcessor | OverdueProcessorTest | OverdueProcessorTest | OverdueProcessorTest | Unit test OverdueProcessor (2 TCs: 1N/1A/0B) | Java JDK 17, DB ready |
| 40 | service | ProfileService | ProfileServiceTest | ProfileServiceTest | ProfileServiceTest | Unit test ProfileService (7 TCs: 2N/5A/0B) | Java JDK 17, DB ready |
| 41 | service | ReservationExpirationProcessor | ReservationExpirationProcessorTest | ReservationExpirationProcessorT | ReservationExpirationProcessorT | Unit test ReservationExpirationProcessor (3 TCs: 0N/3A/0B) | Java JDK 17, DB ready |
| 42 | service | TagService | TagServiceTest | TagServiceTest | TagServiceTest | Unit test TagService (2 TCs: 1N/1A/0B) | Java JDK 17, DB ready |
| 43 | service | UserService | UserServiceTest | UserServiceTest | UserServiceTest | Unit test UserService (15 TCs: 5N/10A/0B) | Java JDK 17, DB ready |
| 44 | systemConfig | SystemConfigService | SystemConfigServiceTest | SystemConfigServiceTest | SystemConfigServiceTest | Unit test SystemConfigService (9 TCs: 2N/6A/1B) | Java JDK 17, DB ready |
| 45 | util | BookImageStorage | BookImageStorageTest | BookImageStorageTest | BookImageStorageTest | Unit test BookImageStorage (3 TCs: 1N/2A/0B) | Java JDK 17, DB ready |
| 46 | util | BookImportWorkbookReader | BookImportWorkbookReaderTest | BookImportWorkbookReaderTest | BookImportWorkbookReaderTest | Unit test BookImportWorkbookReader (3 TCs: 0N/3A/0B) | Java JDK 17, DB ready |
| 47 | util | IsbnValidator | IsbnValidatorTest | IsbnValidatorTest | IsbnValidatorTest | Unit test IsbnValidator (6 TCs: 3N/3A/0B) | Java JDK 17, DB ready |
## Sheet: Test Report
| UNIT TEST REPORT |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Project Name | LMS - Library Management System |  | Creator | SWP391 Dev Team |  |  |  |  |
| Project Code | SWP391_LMS |  | Reviewer | Instructor |  |  |  |  |
| Document Code | SWP391_LMS_UT_v1.0 |  | Issue Date |  | 12/07/2026 |  |  |  |
| Notes | Release 1: Full LMS |  |  |  |  |  |  |  |
| No | Function code | Passed | Failed | Untested | N | A | B | Total Test Cases |
| 1 | EmailJobTest | 50 | 0 | 0 | 50 | 0 | 0 | 50 |
| 2 | EmailServiceTest | 50 | 0 | 0 | 49 | 1 | 0 | 50 |
| 3 | EmailTriggerIntegrationTest | 50 | 0 | 0 | 50 | 0 | 0 | 50 |
| 4 | EmailWorkerTest | 50 | 0 | 0 | 50 | 0 | 0 | 50 |
| 5 | BookCopyDAOTest | 1 | 0 | 0 | 1 | 0 | 0 | 1 |
| 6 | BookCopyIncidentDAOTest | 2 | 0 | 0 | 2 | 0 | 0 | 2 |
| 7 | BookDAOTest | 1 | 0 | 0 | 0 | 0 | 1 | 1 |
| 8 | BookImportDAOTest | 2 | 0 | 0 | 1 | 1 | 0 | 2 |
| 9 | BorrowRecordDAOTest | 4 | 0 | 0 | 3 | 1 | 0 | 4 |
| 10 | CategoryTagDAOTest | 2 | 0 | 0 | 2 | 0 | 0 | 2 |
| 11 | FineDAOTest | 3 | 0 | 0 | 3 | 0 | 0 | 3 |
| 12 | InventoryDAOTest | 1 | 0 | 0 | 1 | 0 | 0 | 1 |
| 13 | ReservationDAOTest | 3 | 0 | 0 | 2 | 1 | 0 | 3 |
| 14 | UserDAOTest | 4 | 0 | 0 | 3 | 1 | 0 | 4 |
| 15 | AiChatbotServiceIntegrationTest | 31 | 0 | 0 | 31 | 0 | 0 | 31 |
| 16 | AiChatbotServiceUnitTest | 51 | 0 | 0 | 51 | 0 | 0 | 51 |
| 17 | AiChatbotServletTest | 21 | 0 | 0 | 20 | 1 | 0 | 21 |
| 18 | BookSuggestionServiceTest | 201 | 0 | 0 | 193 | 8 | 0 | 201 |
| 19 | F5SystemServletTest | 26 | 0 | 0 | 25 | 1 | 0 | 26 |
| 20 | OnlineCirculationServiceIntegra | 13 | 0 | 0 | 13 | 0 | 0 | 13 |
| 21 | OnlineCirculationServiceUnitTes | 109 | 0 | 0 | 94 | 9 | 6 | 109 |
| 22 | DeskCirculationServiceIntegrati | 31 | 0 | 0 | 28 | 3 | 0 | 31 |
| 23 | DeskCirculationServiceUnitTest | 51 | 0 | 0 | 46 | 5 | 0 | 51 |
| 24 | F6SystemServletTest | 21 | 0 | 0 | 20 | 1 | 0 | 21 |
| 25 | AiConfigTest | 20 | 0 | 0 | 20 | 0 | 0 | 20 |
| 26 | AiRecommendationServiceTest | 45 | 0 | 0 | 42 | 3 | 0 | 45 |
| 27 | BookDAOTest_26 | 63 | 0 | 0 | 63 | 0 | 0 | 63 |
| 28 | BookDiscoverySystemTest | 21 | 0 | 0 | 21 | 0 | 0 | 21 |
| 29 | BookServletsTest | 22 | 0 | 0 | 16 | 6 | 0 | 22 |
| 30 | RecommendationServletTest | 45 | 0 | 0 | 44 | 1 | 0 | 45 |
| 31 | AuthServiceTest | 11 | 0 | 0 | 3 | 7 | 1 | 11 |
| 32 | BookCopyIncidentServiceTest | 5 | 0 | 0 | 1 | 4 | 0 | 5 |
| 33 | BookCopyServiceTest | 3 | 0 | 0 | 2 | 1 | 0 | 3 |
| 34 | BookImportServiceTest | 4 | 0 | 0 | 2 | 2 | 0 | 4 |
| 35 | BookServiceTest | 6 | 0 | 0 | 2 | 4 | 0 | 6 |
| 36 | CategoryServiceTest | 2 | 0 | 0 | 1 | 1 | 0 | 2 |
| 37 | InventoryReconciliationServiceT | 2 | 0 | 0 | 1 | 1 | 0 | 2 |
| 38 | OnlineCirculationServiceTest | 27 | 0 | 0 | 10 | 13 | 4 | 27 |
| 39 | OverdueProcessorTest | 2 | 0 | 0 | 1 | 1 | 0 | 2 |
| 40 | ProfileServiceTest | 7 | 0 | 0 | 2 | 5 | 0 | 7 |
| 41 | ReservationExpirationProcessorT | 3 | 0 | 0 | 0 | 3 | 0 | 3 |
| 42 | TagServiceTest | 2 | 0 | 0 | 1 | 1 | 0 | 2 |
| 43 | UserServiceTest | 15 | 0 | 0 | 5 | 10 | 0 | 15 |
| 44 | SystemConfigServiceTest | 9 | 0 | 0 | 2 | 6 | 1 | 9 |
| 45 | BookImageStorageTest | 3 | 0 | 0 | 1 | 2 | 0 | 3 |
| 46 | BookImportWorkbookReaderTest | 3 | 0 | 0 | 0 | 3 | 0 | 3 |
| 47 | IsbnValidatorTest | 6 | 0 | 0 | 3 | 3 | 0 | 6 |
|  | Sub total |  |  |  |  |  |  |  |
|  | Test coverage |  |  | % |  |  |  |  |
|  | Test successful coverage |  |  | % |  |  |  |  |
|  | Normal case |  |  | % |  |  |  |  |
|  | Abnormal case |  |  | % |  |  |  |  |
|  | Boundary case |  |  | % |  |  |  |  |
## Sheet: EmailJobTest
| Function Code |  | EmailJobTest |  |  | Function Name |  |  |  |  |  | EmailJob |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 100 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for EmailJob (asyncEmailSender) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 50 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 | TC027 | TC028 | TC029 | TC030 | TC031 | TC032 | TC033 | TC034 | TC035 | TC036 | TC037 | TC038 | TC039 | TC040 | TC041 | TC042 | TC043 | TC044 | TC045 | TC046 | TC047 | TC048 | TC049 | TC050 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | email |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | subject |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | body |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | index |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: EmailServiceTest
| Function Code |  | EmailServiceTest |  |  | Function Name |  |  |  |  |  | EmailService |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 205 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for EmailService (asyncEmailSender) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 50 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 | TC027 | TC028 | TC029 | TC030 | TC031 | TC032 | TC033 | TC034 | TC035 | TC036 | TC037 | TC038 | TC039 | TC040 | TC041 | TC042 | TC043 | TC044 | TC045 | TC046 | TC047 | TC048 | TC049 | TC050 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | email |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | tempName |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | index |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: EmailTriggerIntegrationTest
| Function Code |  | EmailTriggerIntegrationTest |  |  | Function Name |  |  |  |  |  | EmailTrigger |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 0 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for EmailTrigger (asyncEmailSender) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 50 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 | TC027 | TC028 | TC029 | TC030 | TC031 | TC032 | TC033 | TC034 | TC035 | TC036 | TC037 | TC038 | TC039 | TC040 | TC041 | TC042 | TC043 | TC044 | TC045 | TC046 | TC047 | TC048 | TC049 | TC050 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | tempName |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | email |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | index |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: EmailWorkerTest
| Function Code |  | EmailWorkerTest |  |  | Function Name |  |  |  |  |  | EmailWorker |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 189 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for EmailWorker (asyncEmailSender) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 50 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 | TC027 | TC028 | TC029 | TC030 | TC031 | TC032 | TC033 | TC034 | TC035 | TC036 | TC037 | TC038 | TC039 | TC040 | TC041 | TC042 | TC043 | TC044 | TC045 | TC046 | TC047 | TC048 | TC049 | TC050 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | tempName |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | userName |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | bookTitle |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | index |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BookCopyDAOTest
| Function Code |  | BookCopyDAOTest |  |  | Function Name |  |  |  |  |  | BookCopyDAO |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 451 |  |  | Lack of test cases |  |  |  |  |  | 44 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BookCopyDAO (dao) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |  |  |  |  |
|  |  |  |  |  | TC001 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | insertCreatesGoodAvailableCopy |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BookCopyIncidentDAOTest
| Function Code |  | BookCopyIncidentDAOTest |  |  | Function Name |  |  |  |  |  | BookCopyIncidentDAO |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 235 |  |  | Lack of test cases |  |  |  |  |  | 21 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BookCopyIncidentDAO (dao) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 2 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | reportThenResolveSynchronizesCopyAndAvai |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | insertPreventsTwoOpenIncidentsForSameCop |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | N |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BookDAOTest
| Function Code |  | BookDAOTest |  |  | Function Name |  |  |  |  |  | BookDAO |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 674 |  |  | Lack of test cases |  |  |  |  |  | 66 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BookDAO (dao) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |  |  |  |  |
|  |  |  |  |  | TC001 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | insertCreatesBookWithZeroInventory |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | B |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BookImportDAOTest
| Function Code |  | BookImportDAOTest |  |  | Function Name |  |  |  |  |  | BookImportDAO |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 172 |  |  | Lack of test cases |  |  |  |  |  | 15 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BookImportDAO (dao) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 2 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | importTransactionCreatesRelationsCopiesA |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | insertsFailedBatchAndErrorsInsideTransac |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | A |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BorrowRecordDAOTest
| Function Code |  | BorrowRecordDAOTest |  |  | Function Name |  |  |  |  |  | BorrowRecordDAO |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 844 |  |  | Lack of test cases |  |  |  |  |  | 80 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BorrowRecordDAO (dao) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 4 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testInsertBorrowRecord_Success |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testInsertBorrowRecord_FK_Failure |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testUpdateStatusToReturned_Success |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testFindActiveBorrowRecord_Found |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | A | N | N |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P | P |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: CategoryTagDAOTest
| Function Code |  | CategoryTagDAOTest |  |  | Function Name |  |  |  |  |  | CategoryTagDAO |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 0 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for CategoryTagDAO (dao) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 2 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | insertAndFindCategoryAndTag |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | loadCategoryAndTagSummaries |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | N |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: FineDAOTest
| Function Code |  | FineDAOTest |  |  | Function Name |  |  |  |  |  | FineDAO |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 422 |  |  | Lack of test cases |  |  |  |  |  | 39 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for FineDAO (dao) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 3 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testInsertOverdueFine_Success |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testUpdateStatusToPaid_Success |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testHasUnpaidFines |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | N | N |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: InventoryDAOTest
| Function Code |  | InventoryDAOTest |  |  | Function Name |  |  |  |  |  | InventoryDAO |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 248 |  |  | Lack of test cases |  |  |  |  |  | 23 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for InventoryDAO (dao) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 1 |  |  |  |  |  |
|  |  |  |  |  | TC001 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | createScanAndFinishCountingTracksResults |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: ReservationDAOTest
| Function Code |  | ReservationDAOTest |  |  | Function Name |  |  |  |  |  | ReservationDAO |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 1020 |  |  | Lack of test cases |  |  |  |  |  | 99 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for ReservationDAO (dao) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 3 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testInsertWalkIn_Success |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testUpdateToReadyPickup_Success |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testFindNextInQueue_FoundAndNotFound |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | N | A |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: UserDAOTest
| Function Code |  | UserDAOTest |  |  | Function Name |  |  |  |  |  | UserDAO |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 1005 |  |  | Lack of test cases |  |  |  |  |  | 96 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for UserDAO (dao) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 4 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCreateUserWithProfile_Success |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCreateUserWithProfile_DuplicateEmail |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testUpdateUserStatus_Success |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExistsByEmail |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | A | N | N |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P | P |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: AiChatbotServiceIntegrationTest
| Function Code |  | AiChatbotServiceIntegrationTest |  |  | Function Name |  |  |  |  |  | AiChatbotService |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 473 |  |  | Lack of test cases |  |  |  |  |  | 16 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for AiChatbotService (f14) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 31 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 | TC027 | TC028 | TC029 | TC030 | TC031 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | testId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | query |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | userId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | List<Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | dbData |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectedPersonalized |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: AiChatbotServiceUnitTest
| Function Code |  | AiChatbotServiceUnitTest |  |  | Function Name |  |  |  |  |  | AiChatbotService |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 473 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for AiChatbotService (f14) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 51 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 | TC027 | TC028 | TC029 | TC030 | TC031 | TC032 | TC033 | TC034 | TC035 | TC036 | TC037 | TC038 | TC039 | TC040 | TC041 | TC042 | TC043 | TC044 | TC045 | TC046 | TC047 | TC048 | TC049 | TC050 | TC051 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | testId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | methodToTest |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | inputMessage |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | rawContext |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | List<Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | dbData |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectedResult |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: AiChatbotServletTest
| Function Code |  | AiChatbotServletTest |  |  | Function Name |  |  |  |  |  | AiChatbotServlet |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 226 |  |  | Lack of test cases |  |  |  |  |  | 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for AiChatbotServlet (f14) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 21 |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | testId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | requestBodyJson |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | sessionAttributes |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | List<Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | dbData |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectSuccess |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BookSuggestionServiceTest
| Function Code |  | BookSuggestionServiceTest |  |  | Function Name |  |  |  |  |  | BookSuggestionService |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 236 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BookSuggestionService (f20) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 201 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 | TC027 | TC028 | TC029 | TC030 | TC031 | TC032 | TC033 | TC034 | TC035 | TC036 | TC037 | TC038 | TC039 | TC040 | TC041 | TC042 | TC043 | TC044 | TC045 | TC046 | TC047 | TC048 | TC049 | TC050 | TC051 | TC052 | TC053 | TC054 | TC055 | TC056 | TC057 | TC058 | TC059 | TC060 | TC061 | TC062 | TC063 | TC064 | TC065 | TC066 | TC067 | TC068 | TC069 | TC070 | TC071 | TC072 | TC073 | TC074 | TC075 | TC076 | TC077 | TC078 | TC079 | TC080 | TC081 | TC082 | TC083 | TC084 | TC085 | TC086 | TC087 | TC088 | TC089 | TC090 | TC091 | TC092 | TC093 | TC094 | TC095 | TC096 | TC097 | TC098 | TC099 | TC100 | TC101 | TC102 | TC103 | TC104 | TC105 | TC106 | TC107 | TC108 | TC109 | TC110 | TC111 | TC112 | TC113 | TC114 | TC115 | TC116 | TC117 | TC118 | TC119 | TC120 | TC121 | TC122 | TC123 | TC124 | TC125 | TC126 | TC127 | TC128 | TC129 | TC130 | TC131 | TC132 | TC133 | TC134 | TC135 | TC136 | TC137 | TC138 | TC139 | TC140 | TC141 | TC142 | TC143 | TC144 | TC145 | TC146 | TC147 | TC148 | TC149 | TC150 | TC151 | TC152 | TC153 | TC154 | TC155 | TC156 | TC157 | TC158 | TC159 | TC160 | TC161 | TC162 | TC163 | TC164 | TC165 | TC166 | TC167 | TC168 | TC169 | TC170 | TC171 | TC172 | TC173 | TC174 | TC175 | TC176 | TC177 | TC178 | TC179 | TC180 | TC181 | TC182 | TC183 | TC184 | TC185 | TC186 | TC187 | TC188 | TC189 | TC190 | TC191 | TC192 | TC193 | TC194 | TC195 | TC196 | TC197 | TC198 | TC199 | TC200 | TC201 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | testId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | action |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | suggestion |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | actorId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | confirmSimilar |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | statusToUpdate |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | librarianNote |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | List<Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | dbData |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectSuccess |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectedErrorMessage |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  | O | O | O | O | O | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | A | A | A | A | A | A | A | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: F5SystemServletTest
| Function Code |  | F5SystemServletTest |  |  | Function Name |  |  |  |  |  | F5SystemServlet |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 0 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for F5SystemServlet (f5) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 26 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | servletName |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | userRole |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | bookIdParam |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | reservationIdParam |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | borrowRecordIdParam |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectLoginRedirect |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: OnlineCirculationServiceIntegra
| Function Code |  | OnlineCirculationServiceIntegra |  |  | Function Name |  |  |  |  |  | OnlineCirculationService |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 573 |  |  | Lack of test cases |  |  |  |  |  | 44 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for OnlineCirculationService (f5) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 13 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O |  |  |
|  | flow |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O |  |  |
|  | role |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O |  |  |
|  | hasUnpaidFine |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O |  |  |
|  | initialAvailableQty |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O |  |  |
|  | hasActiveReservation |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O |  |  |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | N | N | N | N | N | N | N | N | N | N | N | N |  |  |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: OnlineCirculationServiceUnitTes
| Function Code |  | OnlineCirculationServiceUnitTes |  |  | Function Name |  |  |  |  |  | OnlineCirculationService |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 573 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for OnlineCirculationService (f5) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 109 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 | TC027 | TC028 | TC029 | TC030 | TC031 | TC032 | TC033 | TC034 | TC035 | TC036 | TC037 | TC038 | TC039 | TC040 | TC041 | TC042 | TC043 | TC044 | TC045 | TC046 | TC047 | TC048 | TC049 | TC050 | TC051 | TC052 | TC053 | TC054 | TC055 | TC056 | TC057 | TC058 | TC059 | TC060 | TC061 | TC062 | TC063 | TC064 | TC065 | TC066 | TC067 | TC068 | TC069 | TC070 | TC071 | TC072 | TC073 | TC074 | TC075 | TC076 | TC077 | TC078 | TC079 | TC080 | TC081 | TC082 | TC083 | TC084 | TC085 | TC086 | TC087 | TC088 | TC089 | TC090 | TC091 | TC092 | TC093 | TC094 | TC095 | TC096 | TC097 | TC098 | TC099 | TC100 | TC101 | TC102 | TC103 | TC104 | TC105 | TC106 | TC107 | TC108 | TC109 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_UserNotFound |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_UserLocked |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_UserHasUnpaidFines |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_AlreadyBorrowingThisBook |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_AlreadyReservedThisBook |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_LimitExceeded_Student |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_LimitExceeded_Lecturer |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_BookNotFound |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_BookUnavailableStatus |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_Success_ReadyPickup |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_Success_IntoPendingQueue |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_NotFound |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_NotOwned |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_InvalidStatus |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_Success_PendingQue |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_Success_ReadyPicku |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testRenewBook_Success |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testRenewBook_ThresholdNotMet |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testRenewBook_MaxExtensionReached |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testRenewBook_HasPendingReservations |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_InvalidRole_Admin |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_NegativeLimit |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_DBErrorOnUserCheck |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_CascadeToNextInQue |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_ByLibrarian_Succes |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_ByLibrarian_NotFou |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_ByLibrarian_Invali |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testRenewBook_AlreadyReturned |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testRenewBook_ZeroThreshold |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase01 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase02 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase03 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase04 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase05 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase06 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase07 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase08 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase09 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase10 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase11 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase12 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase13 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase14 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase15 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase16 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase17 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase18 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase19 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase20 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase21 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase22 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase23 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase24 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase25 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase26 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase27 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase28 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase29 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase30 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase31 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase32 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase33 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase34 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase35 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase36 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase37 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase38 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase39 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase40 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase41 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase42 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase43 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase44 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase45 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase46 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase47 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase48 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase49 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase50 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase51 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase52 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase53 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase54 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase55 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase56 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase57 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase58 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase59 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase60 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase61 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase62 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase63 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase64 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase65 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase66 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase67 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase68 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase69 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase70 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase71 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase72 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |
|  |  |  | testExtraCase73 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |
|  |  |  | testExtraCase74 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |
|  |  |  | testExtraCase75 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |
|  |  |  | testExtraCase76 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |
|  |  |  | testExtraCase77 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |
|  |  |  | testExtraCase78 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |
|  |  |  | testExtraCase79 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |
|  |  |  | testExtraCase80 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  | O | O |  |  |  |  |  | O |  |  |  | O |  | O |  |  |  |  |  |  | O |  | O |  |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | A | N | N | N | B | B | A | N | N | N | A | N | A | N | N | N | B | B | N | A | B | A | N | N | A | A | N | B | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: DeskCirculationServiceIntegrati
| Function Code |  | DeskCirculationServiceIntegrati |  |  | Function Name |  |  |  |  |  | DeskCirculationService |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 1100 |  |  | Lack of test cases |  |  |  |  |  | 79 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for DeskCirculationService (f6) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 31 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 | TC027 | TC028 | TC029 | TC030 | TC031 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | testId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | action |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | memberCode |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | barcode |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | condition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | paymentId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | userId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | List<Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | dbData |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectSuccess |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | A | A | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: DeskCirculationServiceUnitTest
| Function Code |  | DeskCirculationServiceUnitTest |  |  | Function Name |  |  |  |  |  | DeskCirculationService |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 1100 |  |  | Lack of test cases |  |  |  |  |  | 59 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for DeskCirculationService (f6) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 51 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 | TC027 | TC028 | TC029 | TC030 | TC031 | TC032 | TC033 | TC034 | TC035 | TC036 | TC037 | TC038 | TC039 | TC040 | TC041 | TC042 | TC043 | TC044 | TC045 | TC046 | TC047 | TC048 | TC049 | TC050 | TC051 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | testId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | action |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | memberCode |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | barcode |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | condition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | paymentId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | userId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | List<Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | dbData |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectSuccess |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectedErrorMessage |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  | O | O | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | A | A | A | A | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: F6SystemServletTest
| Function Code |  | F6SystemServletTest |  |  | Function Name |  |  |  |  |  | F6SystemServlet |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 0 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for F6SystemServlet (f6) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 21 |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | testId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | servletType |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | requestParams |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | sessionAttributes |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | List<Map<String |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | dbData |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectSuccess |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: AiConfigTest
| Function Code |  | AiConfigTest |  |  | Function Name |  |  |  |  |  | AiConfig |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 157 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for AiConfig (f8) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 20 |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | testId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | scenario |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | sysRecommenProp |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | sysGeminiProp |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | sysChatbotProp |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | dbValue |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectKey |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: AiRecommendationServiceTest
| Function Code |  | AiRecommendationServiceTest |  |  | Function Name |  |  |  |  |  | AiRecommendationService |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 273 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for AiRecommendationService (f8) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 45 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 | TC027 | TC028 | TC029 | TC030 | TC031 | TC032 | TC033 | TC034 | TC035 | TC036 | TC037 | TC038 | TC039 | TC040 | TC041 | TC042 | TC043 | TC044 | TC045 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | testId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | scenario |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | candidatePoolIds |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | apiResponse |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | apiException |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectedIds |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | A | A | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BookDAOTest_26
| Function Code |  | BookDAOTest_26 |  |  | Function Name |  |  |  |  |  | BookDAO |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 674 |  |  | Lack of test cases |  |  |  |  |  | 4 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BookDAO (f8) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 63 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 | TC027 | TC028 | TC029 | TC030 | TC031 | TC032 | TC033 | TC034 | TC035 | TC036 | TC037 | TC038 | TC039 | TC040 | TC041 | TC042 | TC043 | TC044 | TC045 | TC046 | TC047 | TC048 | TC049 | TC050 | TC051 | TC052 | TC053 | TC054 | TC055 | TC056 | TC057 | TC058 | TC059 | TC060 | TC061 | TC062 | TC063 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | testId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | keyword |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | categoryId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | tagIds |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | status |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | sort |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | limit |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectedCount |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BookDiscoverySystemTest
| Function Code |  | BookDiscoverySystemTest |  |  | Function Name |  |  |  |  |  | BookDiscoverySystem |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 0 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BookDiscoverySystem (f8) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 21 |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | testId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | scenarioName |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | loginRole |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | studentBorrowCount |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | aiSvcFails |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | searchKeyword |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | detailBookId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BookServletsTest
| Function Code |  | BookServletsTest |  |  | Function Name |  |  |  |  |  | BookServlets |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 0 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BookServlets (f8) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 22 |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | testId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | servletType |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | keyword |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | categoryIdParam |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | tagParams |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | pageParam |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | detailIdParam |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | userRole |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectedRedirect |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectedForward |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  | O | O | O | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | A | A | A | A | A | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: RecommendationServletTest
| Function Code |  | RecommendationServletTest |  |  | Function Name |  |  |  |  |  | RecommendationServlet |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 141 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for RecommendationServlet (f8) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 45 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 | TC027 | TC028 | TC029 | TC030 | TC031 | TC032 | TC033 | TC034 | TC035 | TC036 | TC037 | TC038 | TC039 | TC040 | TC041 | TC042 | TC043 | TC044 | TC045 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | testId |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | scenario |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | userRole |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | borrowCount |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | aiReturnsNull |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | aiReturnsEmpty |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | cacheHit |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | expectedIsAi |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | value per TC |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: AuthServiceTest
| Function Code |  | AuthServiceTest |  |  | Function Name |  |  |  |  |  | AuthService |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 163 |  |  | Lack of test cases |  |  |  |  |  | 5 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for AuthService (service) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 11 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | AuthServiceTest — Unit Tests cho AuthSer |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Test verifyPassword khi nhập sai mật khẩ |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Test isAccountLocked khi tài khoản không |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Test isAccountLocked khi tài khoản bị kh |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Test isAccountLocked khi tài khoản bị kh |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Test isAccountLocked khi tài khoản bị kh |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |
|  |  |  | Test handleFailedLogin bình thường (chưa |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |
|  |  |  | Test handleFailedLogin khi đạt ngưỡng 5  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |
|  |  |  | Test generateRandomPassword có độ dài ch |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |
|  |  |  | Test resetPassword cho email tồn tại. |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |
|  |  |  | Test resetPassword cho email không tồn t |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O |  |  |  |  |
|  | Exception |  |  |  |  | O | O | O | O | O | O |  |  |  | O |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | A | A | A | A | A | A | B | N | N | A |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BookCopyIncidentServiceTest
| Function Code |  | BookCopyIncidentServiceTest |  |  | Function Name |  |  |  |  |  | BookCopyIncidentService |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 271 |  |  | Lack of test cases |  |  |  |  |  | 22 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BookCopyIncidentService (service) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 5 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateReportAcceptsCompleteReport |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateReportRejectsInvalidType |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateReportRejectsMissingDescription |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateResolutionRejectsBlankConclusion |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateRepairNoteRejectsBlankNote |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  | O | O | O | O |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | A | A | A | A |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P | P | P |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BookCopyServiceTest
| Function Code |  | BookCopyServiceTest |  |  | Function Name |  |  |  |  |  | BookCopyService |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 141 |  |  | Lack of test cases |  |  |  |  |  | 11 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BookCopyService (service) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 3 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateCreateAcceptsValidCopy |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateCreateRejectsMissingBarcode |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateUpdateOnlyRequiresValidLocation |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | A | N |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BookImportServiceTest
| Function Code |  | BookImportServiceTest |  |  | Function Name |  |  |  |  |  | BookImportService |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 226 |  |  | Lack of test cases |  |  |  |  |  | 18 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BookImportService (service) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 4 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testValidate_Success |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testValidate_Fail_InvalidISBN |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testConfirm_Success |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testConfirm_Fail_ValidationChanged |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  | O |  | O |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | A | N | A |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P | P |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BookServiceTest
| Function Code |  | BookServiceTest |  |  | Function Name |  |  |  |  |  | BookService |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 134 |  |  | Lack of test cases |  |  |  |  |  | 7 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BookService (service) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 6 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateAcceptsValidNewBook |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateRejectsMissingIsbnWhenCreating |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateNormalizesDashedIsbnWhenCreating |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateRejectsInvalidIsbnChecksumWhenCr |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateRejectsNegativePrice |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateRejectsInvalidStatus |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  | O |  | O | O | O |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | A | N | A | A | A |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: CategoryServiceTest
| Function Code |  | CategoryServiceTest |  |  | Function Name |  |  |  |  |  | CategoryService |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 104 |  |  | Lack of test cases |  |  |  |  |  | 8 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for CategoryService (service) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 2 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateAcceptsValidCategory |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateRejectsMissingName |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | A |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: InventoryReconciliationServiceT
| Function Code |  | InventoryReconciliationServiceT |  |  | Function Name |  |  |  |  |  | InventoryReconciliationService |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 200 |  |  | Lack of test cases |  |  |  |  |  | 18 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for InventoryReconciliationService (service) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 2 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateLocationAcceptsValidLocation |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateLocationRejectsBlankLocation |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | A |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: OnlineCirculationServiceTest
| Function Code |  | OnlineCirculationServiceTest |  |  | Function Name |  |  |  |  |  | OnlineCirculationService |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Lines  of code |  | 573 |  |  | Lack of test cases |  |  |  |  |  | 30 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for OnlineCirculationService (service) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 27 |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 | TC016 | TC017 | TC018 | TC019 | TC020 | TC021 | TC022 | TC023 | TC024 | TC025 | TC026 | TC027 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_UserNotFound |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_UserNotActive |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_AlreadyBorrowed |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_AlreadyReserved |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_LimitExceeded_Student |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_LimitExceeded_Lecturer |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_BookNotFound |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_BookNotAvailable |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_Success_ReadyPickup |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testReserveBook_Success_PendingQueue |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_UserNotFound |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_UserNotActive |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_ResNotFound |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_NotOwner |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_NotActiveStatus |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_Success_PendingQue |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_Success_ReadyPicku |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testCancelReservation_Success_ReadyPicku |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |
|  |  |  | testRenewBook_UserNotFound |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |
|  |  |  | testRenewBook_UserNotActive |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |
|  |  |  | testRenewBook_RecordNotFound |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |
|  |  |  | testRenewBook_NotOwner |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |
|  |  |  | testRenewBook_NotBorrowed |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |
|  |  |  | testRenewBook_ThresholdNotMet |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |
|  |  |  | testRenewBook_MaxExtensionExceeded |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |
|  |  |  | testRenewBook_HasQueuedReservation |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |
|  |  |  | testRenewBook_Success |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  | O | O |  |  |  |  | O |  |  |  | O | O | O | O | O |  |  |  | O | O | O | O | O |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | A | N | N | B | B | A | N | N | N | A | A | A | A | A | N | N | N | A | A | A | A | A | B | B | N | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: OverdueProcessorTest
| Function Code |  | OverdueProcessorTest |  |  | Function Name |  |  |  |  |  | OverdueProcessor |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 226 |  |  | Lack of test cases |  |  |  |  |  | 20 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for OverdueProcessor (service) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 2 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testProcessNoOverdueRecords |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testProcessOneOverdueRecord |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | N |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: ProfileServiceTest
| Function Code |  | ProfileServiceTest |  |  | Function Name |  |  |  |  |  | ProfileService |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 103 |  |  | Lack of test cases |  |  |  |  |  | 3 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for ProfileService (service) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 7 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testUpdateUserInfo_Success |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testUpdateUserInfo_Fail_EmptyFullName |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testUpdateUserInfo_Fail_InvalidDate |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testChangePassword_Success |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testChangePassword_Fail_MismatchConfirm |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testChangePassword_Fail_WeakPolicy |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |
|  |  |  | testChangePassword_Fail_WrongOldPassword |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  | O | O |  | O | O | O |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | A | A | N | A | A | A |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: ReservationExpirationProcessorT
| Function Code |  | ReservationExpirationProcessorT |  |  | Function Name |  |  |  |  |  | ReservationExpirationProcessor |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 233 |  |  | Lack of test cases |  |  |  |  |  | 20 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for ReservationExpirationProcessor (service) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 3 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testProcessNoExpiredReservations |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testProcessExpiredWithPromotedNextUser |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testProcessExpiredQueueEmpty |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | A | A |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: TagServiceTest
| Function Code |  | TagServiceTest |  |  | Function Name |  |  |  |  |  | TagService |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 138 |  |  | Lack of test cases |  |  |  |  |  | 11 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for TagService (service) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 2 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateAcceptsValidTag |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | validateRejectsInvalidStatus |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | A |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: UserServiceTest
| Function Code |  | UserServiceTest |  |  | Function Name |  |  |  |  |  | UserService |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 353 |  |  | Lack of test cases |  |  |  |  |  | 20 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for UserService (service) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 15 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 | TC010 | TC011 | TC012 | TC013 | TC014 | TC015 |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | UserServiceTest — Unit Tests cho UserSer |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Test tạo tài khoản thất bại khi thiếu em |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Test tạo tài khoản thất bại khi trùng Em |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Test tạo tài khoản thất bại khi trùng mã |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Test tạo tài khoản thất bại khi thiếu số |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Test tạo tài khoản thất bại khi số điện  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |
|  |  |  | Test khóa tài khoản người dùng thành côn |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |
|  |  |  | Test mở khóa tài khoản người dùng thành  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |
|  |  |  | Test cập nhật tài khoản Admin bởi một Ad |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |
|  |  |  | Test cập nhật tài khoản Admin bởi chính  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |
|  |  |  | Test khóa tài khoản Admin bởi Admin khác |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |  |
|  |  |  | Test khóa tài khoản Admin bởi chính mình |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |  |
|  |  |  | Test Import hàng loạt thành công. |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |  |
|  |  |  | Test Import hàng loạt thất bại ở Phase 1 |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |  |
|  |  |  | Test lấy danh sách người dùng để xuất Ex |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | O |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O | O | O | O | O | O | O |
|  | Exception |  |  |  |  | O | O | O | O | O | O | O | O |  | O |  |  | O |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | A | A | A | A | A | A | A | A | N | A | N | N | A | N |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P | P | P | P | P | P | P |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: SystemConfigServiceTest
| Function Code |  | SystemConfigServiceTest |  |  | Function Name |  |  |  |  |  | SystemConfigService |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 217 |  |  | Lack of test cases |  |  |  |  |  | 12 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for SystemConfigService (systemConfig) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 9 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 | TC007 | TC008 | TC009 |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O | O | O | O |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testValidatePositiveIntSuccess |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testValidatePositiveIntFailureZero |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testValidatePositiveIntFailureString |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testValidateNonNegativeIntSuccess |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testValidateNonNegativeIntFailure |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |
|  |  |  | testValidateNonNegativeDecimalSuccess |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |
|  |  |  | testValidateNonNegativeDecimalFailure |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |
|  |  |  | testValidateStringSuccess |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |  |
|  |  |  | testValidateEmptyValue |  |  |  |  |  |  |  |  |  | O |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O | O | O | O |  |  |  |  |  |  |
|  | Exception |  |  |  |  |  | O | O | O | O | O |  | O |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | B | A | A | A | A | A | N | A |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P | P | P | P |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BookImageStorageTest
| Function Code |  | BookImageStorageTest |  |  | Function Name |  |  |  |  |  | BookImageStorage |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 117 |  |  | Lack of test cases |  |  |  |  |  | 8 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BookImageStorage (util) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 3 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | saveStoresValidPngImage |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | saveRejectsNonImageFile |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | resolveRejectsUnsafeFileName |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | A | A |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: BookImportWorkbookReaderTest
| Function Code |  | BookImportWorkbookReaderTest |  |  | Function Name |  |  |  |  |  | BookImportWorkbookReader |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 210 |  |  | Lack of test cases |  |  |  |  |  | 18 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for BookImportWorkbookReader (util) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 3 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 |  |  |  |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | readsValidWorkbookAndSkipsBlankRows |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | rejectsDuplicateBarcodeInsideWorkbook |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | rejectsMissingRequiredSheet |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  | O | O | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | A | A | A |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
## Sheet: IsbnValidatorTest
| Function Code |  | IsbnValidatorTest |  |  | Function Name |  |  |  |  |  | IsbnValidator |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Created By |  | SWP391 Dev Team |  |  | Executed By |  |  |  |  |  | SWP391 Dev Team |  |  |  |  |  |  |  |  |
| Lines  of code |  | 59 |  |  | Lack of test cases |  |  |  |  |  | 0 |  |  |  |  |  |  |  |  |
| Test requirement |  | Unit test for IsbnValidator (util) |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Passed |  | Failed |  |  | Untested |  |  |  |  |  | N/A/B |  |  | Total Test Cases |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |  |  |  | 6 |  |  |  |  |  |
|  |  |  |  |  | TC001 | TC002 | TC003 | TC004 | TC005 | TC006 |  |  |  |  |  |  |  |  |  |
| Condition | Precondition |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | N/A |  | O | O | O | O | O | O |  |  |  |  |  |  |  |  |  |
|  | Test Method |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | acceptsValidIsbn13 |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | acceptsValidIsbn10WithXChecksum |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | normalizesHyphenAndWhitespace |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | rejectsInvalidIsbn13Checksum |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | rejectsInvalidCharacters |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |  |
|  |  |  | rejectsUnsupportedLength |  |  |  |  |  |  | O |  |  |  |  |  |  |  |  |  |
| Confirm | Return |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
|  |  |  | Assertion verified |  | O | O | O | O | O | O |  |  |  |  |  |  |  |  |  |
|  | Exception |  |  |  |  |  |  | O | O | O |  |  |  |  |  |  |  |  |  |
|  | Log message |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| Result | Type(N : Normal, A : Abnormal, B : Boundary) |  |  |  | N | N | N | A | A | A |  |  |  |  |  |  |  |  |  |
|  | Passed/Failed |  |  |  | P | P | P | P | P | P |  |  |  |  |  |  |  |  |  |
|  | Executed Date |  |  |  | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 | 2026-07-12 00:00:00 |  |  |  |  |  |  |  |  |  |
|  | Defect ID |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |