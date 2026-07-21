# TỔNG HỢP CODE KIỂM THỬ - LIBRARY MANAGEMENT SYSTEM (LMS)

**Ngày tạo:** 2026-07-12  
**Phiên bản:** 1.0  
**Dự án:** LMS - Library Management System  
**Môn học:** SWP391 - Software Development Project

---

## MỤC LỤC

1. [Tổng Quan](#1-tổng-quan)
2. [AsyncEmailSender Tests](#2-asyncemailsender-tests)
3. [DAO Tests](#3-dao-tests)
4. [Feature Tests (F14, F20, F5, F6, F8)](#4-feature-tests)
5. [Service Tests](#5-service-tests)
6. [SystemConfig Tests](#6-systemconfig-tests)
7. [Util Tests](#7-util-tests)
8. [Thống Kê Tổng Quan](#8-thống-kê-tổng-quan)
9. [Kết Luận](#9-kết-luận)

---

## 1. TỔNG QUAN

### 1.1. Mục Đích
Tài liệu này tổng hợp toàn bộ code kiểm thử của hệ thống LMS, bao gồm:
- Unit Tests (Kiểm thử đơn vị)
- Integration Tests (Kiểm thử tích hợp)
- Parameterized Tests (Kiểm thử tham số hóa)
- Mock/Stub Tests (Kiểm thử giả lập)

### 1.2. Cấu Trúc Thư Mục Test
```
test/
├── asyncEmailSender/        # Kiểm thử hệ thống email bất đồng bộ
├── dao/                     # Kiểm thử Data Access Objects
├── f14/                     # Kiểm thử tính năng AI Chatbot
├── f20/                     # Kiểm thử tính năng Gợi ý sách
├── f5/                      # Kiểm thử tính năng Lưu thông trực tuyến
├── f6/                      # Kiểm thử tính năng Lưu thông tại quầy
├── f8/                      # Kiểm thử tính năng Khám phá sách AI
├── service/                 # Kiểm thử Business Logic Services
├── systemConfig/            # Kiểm thử cấu hình hệ thống
└── util/                    # Kiểm thử các tiện ích
```

### 1.3. Framework & Công Cụ
- **JUnit 4** - Framework kiểm thử chính
- **JUnit Parameterized** - Kiểm thử tham số hóa
- **BCrypt** - Mã hóa mật khẩu trong test
- **Mock JDBC** - Giả lập kết nối database
- **Subclass Stubbing** - Kỹ thuật giả lập DAO

---

## 2. ASYNCEMAILSENDER TESTS

### 2.1. EmailJobTest.java
**Mục đích:** Kiểm thử model EmailJob với 50 test cases tham số hóa


**Số lượng test cases:** 100 (50 test direct email + 50 test template email)

**Các kịch bản kiểm thử:**
```java
// Test 1: Email job với subject và body trực tiếp
@Test
public void testEmailJobProperties() {
    EmailJob job = new EmailJob(email, subject, body);
    assertEquals(email, job.getRecipientEmail());
    assertEquals(subject, job.getDirectSubject());
    assertEquals(body, job.getDirectBody());
    assertNull(job.getTempName());
    assertEquals(0, job.getAttemptCount());
    
    job.incrementAttempt();
    assertEquals(1, job.getAttemptCount());
}

// Test 2: Email job với template
@Test
public void testEmailJobTemplateConstructor() {
    String tempName = "TEMP_" + index;
    String recipientName = "User " + index;
    EmailJob job = new EmailJob(tempName, email, recipientName, new HashMap<>());
    
    assertEquals(tempName, job.getTempName());
    assertEquals(email, job.getRecipientEmail());
    assertEquals(recipientName, job.getRecipientName());
    assertNotNull(job.getPlaceholders());
    assertNull(job.getDirectSubject());
    assertNull(job.getDirectBody());
}
```

**Dữ liệu test:**
- 50 email địa chỉ khác nhau (recipient0@example.com đến recipient49@example.com)
- Subject và body có index riêng
- Template names được sinh động

---

### 2.2. EmailServiceTest.java
**Mục đích:** Kiểm thử EmailService với cơ chế enqueue và filter email ảo

**Số lượng test cases:** 50 test cases tham số hóa


**Các kịch bản kiểm thử:**
```java
@Test
public void testEnqueueAndQueueState() throws InterruptedException {
    int initialSize = EmailService.getQueueSize();
    EmailJob job = new EmailJob(tempName, email, "User " + index, new HashMap<>());
    EmailService.enqueue(job);
    
    if (email.endsWith("@lms.com")) {
        // Virtual email không được enqueue
        assertEquals("Virtual email should not increase queue size", initialSize, EmailService.getQueueSize());
    } else {
        // Email thật được enqueue
        assertEquals("Valid email should increase queue size by 1", initialSize + 1, EmailService.getQueueSize());
        EmailJob taken = EmailService.take();
        assertNotNull(taken);
        assertEquals(email, taken.getRecipientEmail());
    }
}
```

**Logic kiểm thử:**
- **Email ảo (@lms.com):** Không được đưa vào queue (bị filter)
- **Email thật:** Được enqueue và có thể take() ra
- **Queue size:** Kiểm tra trước và sau khi enqueue

**Dữ liệu test:**
- Mỗi 5 test có 1 email ảo (i % 5 == 0 → user{i}@lms.com)
- Email hợp lệ: user{i}@gmail.com

---

### 2.3. EmailTriggerIntegrationTest.java
**Mục đích:** Kiểm thử tích hợp trigger email với các template khác nhau

**Số lượng test cases:** 50 test cases tham số hóa

**Các template được kiểm thử:**
1. CHECKOUT_CONFIRMATION
2. PAYMENT_CONFIRMATION
3. RESERVATION_READY
4. OVERDUE_NOTICE
5. RENEWAL_CONFIRMATION


**Kịch bản kiểm thử:**
```java
@Test
public void testEmailTriggerPushToQueue() throws InterruptedException {
    int initialSize = EmailService.getQueueSize();
    
    Map<String, String> placeholders = new HashMap<>();
    placeholders.put("triggerIndex", String.valueOf(index));
    
    EmailJob job = new EmailJob(tempName, email, "Trigger User " + index, placeholders);
    EmailService.enqueue(job);
    
    assertEquals(initialSize + 1, EmailService.getQueueSize());
    
    EmailJob taken = EmailService.take();
    assertNotNull(taken);
    assertEquals(tempName, taken.getTempName());
    assertEquals(email, taken.getRecipientEmail());
    assertEquals(String.valueOf(index), taken.getPlaceholders().get("triggerIndex"));
}
```

**Kiểm tra:**
- Template name được lưu đúng
- Email recipient chính xác
- Placeholders được truyền qua queue
- Queue size tăng đúng

---

### 2.4. EmailWorkerTest.java
**Mục đích:** Kiểm thử worker xử lý email với placeholder resolution và audit logging

**Số lượng test cases:** 50 test cases tham số hóa

**Kịch bản kiểm thử:**
```java
@Test
public void testWorkerPlaceholderAssemblyAndAuditLog() throws SQLException {
    String originalSubject = "Xin chào {{userName}}";
    String originalBody = "Sách của bạn là {{bookTitle}}";
    
    Map<String, String> placeholders = new HashMap<>();
    placeholders.put("bookTitle", bookTitle);
    
    EmailJob job = new EmailJob(tempName, "test@gmail.com", userName, placeholders);
    
    // Simulated worker placeholder resolution
    String subject = originalSubject.replace("{{userName}}", job.getRecipientName());
    String body = originalBody.replace("{{bookTitle}}", job.getPlaceholders().get("bookTitle"));
    
    assertTrue(subject.contains(userName));
    assertTrue(body.contains(bookTitle));
    
    // Test Audit Log
    MockAuditLogDAO auditLogDAO = new MockAuditLogDAO();
    String details = String.format("Status: %s | TempName: %s | Recipient: %s | Attempts: %d",
            "SUCCESS", tempName, "test@gmail.com", 1);
    auditLogDAO.insert(null, null, "SYSTEM_EMAIL", "EmailJob", null, null, details);
    
    assertEquals(1, auditLogDAO.logCount);
    assertTrue(auditLogDAO.lastNewValues.contains(tempName));
}
```


**Kiểm tra:**
- Placeholder {{userName}} và {{bookTitle}} được thay thế đúng
- Audit log ghi nhận chi tiết email gửi
- Mock AuditLogDAO hoạt động chính xác

**Dữ liệu test:**
- 50 template names khác nhau
- 50 user names tiếng Việt
- 50 book titles tiếng Việt

---

## 3. DAO TESTS

### 3.1. BookCopyDAOTest.java
**Mục đích:** Kiểm thử insert bản sao sách và cập nhật inventory

**Kịch bản kiểm thử:**
```java
@Test
public void insertCreatesGoodAvailableCopy() throws Exception {
    BookCopyDAO bookCopyDAO = new BookCopyDAO();
    BookDAO bookDAO = new BookDAO();
    BookCopy copy = new BookCopy();
    copy.setBookId(findBookId());
    copy.setBarcode("BC-TEST-" + System.nanoTime());
    copy.setLocation("Kho kiểm thử · Kệ 01");
    
    try (Connection conn = DatabaseConnection.getConnection()) {
        conn.setAutoCommit(false);
        try {
            int[] before = findQuantities(conn, copy.getBookId());
            int copyId = bookCopyDAO.insert(conn, copy);
            bookDAO.updateQuantities(conn, copy.getBookId(), 1, 1);
            
            assertTrue(copyId > 0);
            BookCopy saved = bookCopyDAO.findById(conn, copyId);
            assertNotNull(saved);
            assertEquals("good", saved.getCondition());
            assertEquals("available", saved.getStatus());
            
            int[] after = findQuantities(conn, copy.getBookId());
            assertEquals(before[0] + 1, after[0]); // totalQuantity
            assertEquals(before[1] + 1, after[1]); // availableQuantity
        } finally {
            conn.rollback();
            conn.setAutoCommit(true);
        }
    }
}
```

**Kiểm tra:**
- Copy được tạo với condition = "good"
- Copy được tạo với status = "available"
- totalQuantity và availableQuantity tăng đúng
- Transaction rollback để không ảnh hưởng DB


---

### 3.2. BookCopyIncidentDAOTest.java
**Mục đích:** Kiểm thử luồng báo cáo và giải quyết sự cố sách

**Số lượng test cases:** 2

**Test 1: Luồng hoàn chỉnh Report → Resolve → Restore**
```java
@Test
public void reportThenResolveSynchronizesCopyAndAvailableQuantity() throws Exception {
    // 1. Tạo copy
    BookCopy copy = createCopy(conn, copyDAO);
    int availableBefore = findAvailableQuantity(conn, copy.getBookId());
    
    // 2. Báo cáo sự cố
    int incidentId = incidentDAO.insert(conn, incident(copy.getBookCopyId()));
    copyDAO.markUnavailable(conn, copy.getBookCopyId());
    bookDAO.updateQuantities(conn, copy.getBookId(), 0, -1);
    
    // Kiểm tra: copy unavailable, availableQuantity giữ nguyên
    BookCopy pendingCopy = copyDAO.findById(conn, copy.getBookCopyId());
    assertEquals("good", pendingCopy.getCondition());
    assertEquals("unavailable", pendingCopy.getStatus());
    assertEquals(availableBefore, findAvailableQuantity(conn, copy.getBookId()));
    
    // 3. Giải quyết sự cố (xác nhận damaged)
    copyDAO.resolveCondition(conn, copy.getBookCopyId(), "damaged");
    incidentDAO.finish(conn, incidentId, "resolved", "Xác nhận hỏng sau kiểm tra.", findUserId());
    
    BookCopy resolvedCopy = copyDAO.findById(conn, copy.getBookCopyId());
    assertEquals("damaged", resolvedCopy.getCondition());
    assertEquals("unavailable", resolvedCopy.getStatus());
    assertEquals("resolved", incidentDAO.findById(conn, incidentId).getStatus());
    
    // 4. Khôi phục sau khi sửa chữa
    copyDAO.restoreAfterRepair(conn, copy.getBookCopyId());
    bookDAO.updateQuantities(conn, copy.getBookId(), 0, 1);
    incidentDAO.appendResolutionNote(conn, incidentId, "Khôi phục lưu thông: Đã sửa gáy sách.");
    
    BookCopy restoredCopy = copyDAO.findById(conn, copy.getBookCopyId());
    assertEquals("good", restoredCopy.getCondition());
    assertEquals("available", restoredCopy.getStatus());
    assertEquals(availableBefore + 1, findAvailableQuantity(conn, copy.getBookId()));
}
```

**Test 2: Unique constraint - Không cho phép 2 sự cố mở cùng lúc**
```java
@Test
public void insertPreventsTwoOpenIncidentsForSameCopy() throws Exception {
    BookCopy copy = createCopy(conn, copyDAO);
    BookCopyIncident first = incident(copy.getBookCopyId());
    int incidentId = incidentDAO.insert(conn, first);
    
    BookCopyIncident saved = incidentDAO.findById(conn, incidentId);
    assertNotNull(saved);
    assertEquals("pending", saved.getStatus());
    
    try {
        incidentDAO.insert(conn, incident(copy.getBookCopyId()));
        fail("Expected unique open incident constraint");
    } catch (SQLException expected) {
        assertTrue(expected.getMessage() != null);
    }
}
```


**Kiểm tra:**
- Sự cố được báo cáo với status = "pending"
- Copy chuyển sang unavailable khi có sự cố
- Giải quyết sự cố cập nhật condition đúng
- Khôi phục sau sửa chữa trả copy về available
- Constraint ngăn 2 sự cố mở cùng lúc

---

### 3.3. BookDAOTest.java
**Mục đích:** Kiểm thử insert đầu sách mới

**Kịch bản kiểm thử:**
```java
@Test
public void insertCreatesBookWithZeroInventory() throws Exception {
    BookDAO bookDAO = new BookDAO();
    Book book = new Book();
    String suffix = String.valueOf(System.nanoTime());
    book.setIsbn("978-TEST-" + suffix.substring(suffix.length() - 8));
    book.setTitle("Đầu sách kiểm thử DAO");
    book.setAuthor("Nhóm kiểm thử");
    book.setPublisher("LMS");
    book.setPublicationYear(2026);
    book.setPrice(new BigDecimal("100000"));
    book.setImagePath("00000000-0000-0000-0000-000000000001.png");
    
    try (Connection conn = DatabaseConnection.getConnection()) {
        conn.setAutoCommit(false);
        try {
            int bookId = bookDAO.insert(conn, book);
            assertTrue(bookId > 0);
            
            // Verify inventory = 0
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT imagePath, totalQuantity, availableQuantity FROM Book WHERE bookId = ?")) {
                ps.setInt(1, bookId);
                try (ResultSet rs = ps.executeQuery()) {
                    assertTrue(rs.next());
                    assertEquals(book.getImagePath(), rs.getString("imagePath"));
                    assertEquals(0, rs.getInt("totalQuantity"));
                    assertEquals(0, rs.getInt("availableQuantity"));
                }
            }
        } finally {
            conn.rollback();
            conn.setAutoCommit(true);
        }
    }
}
```

**Kiểm tra:**
- Book được insert với ID > 0
- totalQuantity = 0 (chưa có bản sao)
- availableQuantity = 0
- imagePath được lưu đúng


---

### 3.4. BookImportDAOTest.java
**Mục đích:** Kiểm thử import sách với transaction phức tạp

**Số lượng test cases:** 2

**Test 1: Import transaction tạo Book + Categories + Tags + Copies + Inventory**
```java
@Test
public void importTransactionCreatesRelationsCopiesAndInventoryTogether() throws Exception {
    // 1. Tạo category
    Category category = new Category();
    category.setName("Thể loại import " + suffix);
    category.setStatus("active");
    int categoryId = categoryDAO.insert(conn, category, actorId);
    
    // 2. Tạo tag
    Tag tag = new Tag();
    tag.setName(("Tag " + suffix).substring(0, Math.min(100, ("Tag " + suffix).length())));
    tag.setStatus("active");
    int tagId = tagDAO.insert(conn, tag, actorId);
    
    // 3. Tạo book
    Book book = new Book();
    book.setIsbn(("IMP" + suffix).substring(0, Math.min(20, ("IMP" + suffix).length())));
    book.setTitle("Đầu sách kiểm thử import");
    book.setStatus("available");
    int bookId = bookDAO.insert(conn, book);
    
    // 4. Liên kết categories và tags
    bookDAO.replaceCategories(conn, bookId, new int[]{categoryId});
    bookDAO.replaceTags(conn, bookId, new int[]{tagId});
    
    // 5. Tạo copy và cập nhật inventory
    BookCopy copy = new BookCopy();
    copy.setBookId(bookId);
    copy.setBarcode(("BC-" + suffix).substring(0, Math.min(50, ("BC-" + suffix).length())));
    copy.setLocation("Kho kiểm thử import");
    copyDAO.insert(conn, copy);
    bookDAO.updateQuantities(conn, bookId, 1, 1);
    
    // 6. Verify
    Book saved = bookDAO.findById(conn, bookId);
    assertEquals(1, saved.getTotalQuantity());
    assertEquals(1, saved.getAvailableQuantity());
    assertEquals(1, saved.getCategories().size());
    assertEquals(1, saved.getTags().size());
}
```

**Test 2: Import thất bại - Ghi lỗi vào BookImportError**
```java
@Test
public void insertsFailedBatchAndErrorsInsideTransaction() throws Exception {
    BookImportBatch batch = new BookImportBatch();
    batch.setImportedBy(findUserId(conn));
    batch.setFileName("kiem-thu.xlsx");
    batch.setTotalRows(1);
    batch.setSuccessRows(0);
    batch.setFailedRows(1);
    batch.setStatus("failed");
    
    int batchId = dao.insertBatch(conn, batch);
    dao.insertErrors(conn, batchId,
            List.of(new BookImportError("Books", 2, "isbn", "ISBN không hợp lệ.")));
    
    assertTrue(batchId > 0);
    assertEquals(1, countErrors(conn, batchId));
}
```


**Kiểm tra:**
- Transaction tạo đầy đủ book, relations, copies, inventory
- Import batch failed được ghi nhận
- Errors được lưu vào BookImportError table
- Transaction rollback đảm bảo không làm bẩn DB

---

### 3.5. BorrowRecordDAOTest.java
**Mục đích:** Kiểm thử CRUD phiếu mượn sách

**Số lượng test cases:** 4

**Test 1: Insert borrow record thành công**
```java
@Test
public void testInsertBorrowRecord_Success() throws Exception {
    int[] ids = setupDependencies(conn); // [userId, bookId, bookCopyId]
    Timestamp endDate = new Timestamp(System.currentTimeMillis() + 7 * 24 * 3600 * 1000L);
    
    int recordId = brDAO.insert(conn, ids[0], ids[2], ids[1], ids[0], endDate);
    assertTrue("ID phiếu mượn phải lớn hơn 0", recordId > 0);
    
    BorrowRecord record = brDAO.findBorrowRecordById(conn, recordId);
    assertNotNull("Phải tìm thấy phiếu mượn", record);
    assertEquals("Trạng thái mặc định phải là borrowed", "borrowed", record.getStatus());
    assertEquals("Người mượn phải khớp", ids[0], record.getUserId());
    assertEquals("Bản sao sách phải khớp", ids[2], record.getBookCopyId());
}
```

**Test 2: Insert thất bại do vi phạm FK**
```java
@Test
public void testInsertBorrowRecord_FK_Failure() throws Exception {
    Timestamp endDate = new Timestamp(System.currentTimeMillis() + 7 * 24 * 3600 * 1000L);
    
    try {
        brDAO.insert(conn, -1, 1, 1, 1, endDate); // userId = -1 không tồn tại
        fail("Phải văng exception khi vi phạm khóa ngoại");
    } catch (SQLException e) {
        assertNotNull(e);
    }
}
```

**Test 3: Update status thành 'returned'**
```java
@Test
public void testUpdateStatusToReturned_Success() throws Exception {
    int recordId = brDAO.insert(conn, ids[0], ids[2], ids[1], ids[0], endDate);
    brDAO.updateStatusToReturned(conn, recordId);
    
    BorrowRecord record = brDAO.findBorrowRecordById(conn, recordId);
    assertEquals("Trạng thái phải là returned", "returned", record.getStatus());
    assertNotNull("returnedAt không được null", record.getReturnedAt());
}
```

**Test 4: Tìm active borrow record**
```java
@Test
public void testFindActiveBorrowRecord_Found() throws Exception {
    brDAO.insert(conn, ids[0], ids[2], ids[1], ids[0], endDate);
    
    BorrowRecord record = brDAO.findActiveBorrowRecord(conn, ids[2]);
    assertNotNull("Phải tìm thấy active record", record);
    assertEquals(ids[0], record.getUserId());
    assertEquals("borrowed", record.getStatus());
}
```


---

### 3.6. CategoryTagDAOTest.java
**Mục đích:** Kiểm thử insert và summary của Category/Tag

**Số lượng test cases:** 2

**Test 1: Insert và find Category/Tag**
```java
@Test
public void insertAndFindCategoryAndTag() throws Exception {
    Category category = new Category();
    category.setName("Thể loại kiểm thử " + suffix);
    category.setDescription("Dữ liệu kiểm thử");
    category.setStatus("active");
    
    Tag tag = new Tag();
    tag.setName("Tag " + suffix.substring(Math.max(0, suffix.length() - 12)));
    tag.setStatus("active");
    
    Category savedCategory = categoryDAO.findById(conn, categoryDAO.insert(conn, category, 16));
    Tag savedTag = tagDAO.findById(conn, tagDAO.insert(conn, tag, 16));
    
    assertNotNull(savedCategory);
    assertNotNull(savedTag);
    assertEquals("active", savedCategory.getStatus());
    assertEquals("active", savedTag.getStatus());
}
```

**Test 2: Load summary statistics**
```java
@Test
public void loadCategoryAndTagSummaries() throws Exception {
    ManagementSummaryDTO categorySummary = new CategoryDAO().getSummary();
    ManagementSummaryDTO tagSummary = new TagDAO().getSummary();
    
    assertNotNull(categorySummary);
    assertNotNull(tagSummary);
    assertTrue(categorySummary.getTotalCount() >= categorySummary.getActiveCount());
    assertTrue(categorySummary.getTotalCount() >= categorySummary.getHiddenCount());
    assertTrue(categorySummary.getTotalCount() >= categorySummary.getUnusedCount());
}
```

**Kiểm tra:**
- Category và Tag được insert và find chính xác
- Summary DTO có tổng số lớn hơn hoặc bằng các sub-counts
- Status được lưu đúng

---

### 3.7. FineDAOTest.java
**Mục đích:** Kiểm thử CRUD tiền phạt

**Số lượng test cases:** 3

**Test 1: Insert overdue fine**
```java
@Test
public void testInsertOverdueFine_Success() throws Exception {
    int[] ids = setupDependencies(conn);
    BigDecimal amount = new BigDecimal("50000");
    int fineId = fDAO.insertOverdueFine(conn, ids[3], ids[0], amount, "Quá hạn 1 ngày");
    
    assertTrue("ID tiền phạt phải lớn hơn 0", fineId > 0);
    BigDecimal total = fDAO.getTotalUnpaidFinesByUser(conn, ids[0]);
    assertEquals(0, amount.compareTo(total));
}
```


**Test 2: Update status thành paid**
```java
@Test
public void testUpdateStatusToPaid_Success() throws Exception {
    BigDecimal amount = new BigDecimal("50000");
    int fineId = fDAO.insertCompensationFine(conn, ids[3], ids[0], amount, "Làm hỏng sách");
    fDAO.updateStatusToPaid(conn, fineId);
    
    BigDecimal total = fDAO.getTotalUnpaidFinesByUser(conn, ids[0]);
    assertEquals(0, BigDecimal.ZERO.compareTo(total));
    assertFalse(fDAO.hasUnpaidFines(conn, ids[0]));
}
```

**Test 3: Check hasUnpaidFines**
```java
@Test
public void testHasUnpaidFines() throws Exception {
    // Chưa có phạt
    assertFalse("Chưa có phạt thì phải trả về false", fDAO.hasUnpaidFines(conn, ids[0]));
    
    // Thêm 1 khoản phạt
    fDAO.insertOverdueFine(conn, ids[3], ids[0], new BigDecimal("10000"), "Late");
    
    // Bây giờ phải là true
    assertTrue("Có khoản phạt chưa nộp phải trả về true", fDAO.hasUnpaidFines(conn, ids[0]));
}
```

**Kiểm tra:**
- Insert fine overdue và compensation
- Tổng tiền phạt chưa trả tính đúng
- Update paid làm tổng tiền = 0
- hasUnpaidFines trả về đúng logic

---

### 3.8. InventoryDAOTest.java
**Mục đích:** Kiểm thử luồng kiểm kê kho

**Kịch bản kiểm thử:**
```java
@Test
public void createScanAndFinishCountingTracksResults() throws Exception {
    String location = "Kho kiểm kê " + System.nanoTime();
    BookCopy first = createCopy(conn, copyDAO, location);
    createCopy(conn, copyDAO, location);
    
    // 1. Tạo session
    int sessionId = inventoryDAO.insertSession(conn, location, "Kiểm thử", actorId);
    
    // 2. Tạo expected items (2 copies)
    assertEquals(2, inventoryDAO.createExpectedItems(conn, sessionId, location));
    
    // 3. Chuyển status sang 'counting'
    inventoryDAO.updateSessionStatus(conn, sessionId, "draft", "counting", actorId);
    
    // 4. Quét 1 copy (matched)
    inventoryDAO.recordScan(conn, sessionId, first.getBookCopyId(), location,
            "matched", actorId, location);
    
    // 5. Đánh dấu missing cho copy chưa quét
    assertEquals(1, inventoryDAO.markMissing(conn, sessionId));
    
    // 6. Chuyển sang 'reviewing'
    inventoryDAO.updateSessionStatus(conn, sessionId, "counting", "reviewing", actorId);
    
    // 7. Verify kết quả
    InventorySession saved = inventoryDAO.findSession(conn, sessionId, false);
    assertNotNull(saved);
    assertEquals("reviewing", saved.getStatus());
    assertEquals(2, saved.getExpectedCount());
    assertEquals(1, saved.getMatchedCount());
    assertEquals(1, saved.getDiscrepancyCount());
}
```


**Kiểm tra:**
- Session được tạo với location
- Expected items khớp với số copy trong location
- Scan được ghi nhận (matched)
- Missing được đánh dấu đúng
- Counts (expected, matched, discrepancy) chính xác

---

### 3.9. ReservationDAOTest.java
**Mục đích:** Kiểm thử CRUD reservation (đặt trước sách)

**Số lượng test cases:** 3

**Test 1: Insert walk-in reservation**
```java
@Test
public void testInsertWalkIn_Success() throws Exception {
    int reservationId = rDAO.insertWalkIn(conn, userId, bookId, bookCopyId);
    assertTrue("ID reservation phải lớn hơn 0", reservationId > 0);
    
    Reservation r = rDAO.findReservationById(conn, reservationId);
    assertNotNull(r);
    assertEquals("pending", r.getStatus());
    assertEquals(Integer.valueOf(0), r.getQueuePosition());
    assertEquals(bookCopyId, (int) r.getBookCopyId());
}
```

**Test 2: Update thành ready for pickup**
```java
@Test
public void testUpdateToReadyPickup_Success() throws Exception {
    int reservationId = rDAO.insertOnlineReservation(conn, ids[0], ids[1], 1);
    rDAO.updateToReadyPickup(conn, reservationId, ids[2]);
    
    Reservation r = rDAO.findReservationById(conn, reservationId);
    assertEquals("readypickup", r.getStatus());
    assertEquals(Integer.valueOf(0), r.getQueuePosition());
    assertEquals(ids[2], (int) r.getBookCopyId());
    assertNotNull(r.getEndDate());
}
```

**Test 3: Find next in queue**
```java
@Test
public void testFindNextInQueue_FoundAndNotFound() throws Exception {
    // Trống rỗng thì find phải trả về null
    Reservation r1 = rDAO.findNextInQueue(conn, ids[1]);
    assertNull("Chưa có ai chờ, phải trả về null", r1);
    
    // Thêm 1 người chờ
    rDAO.insertOnlineReservation(conn, ids[0], ids[1], 1);
    
    Reservation r2 = rDAO.findNextInQueue(conn, ids[1]);
    assertNotNull("Phải tìm thấy người chờ đầu tiên", r2);
    assertEquals(ids[0], r2.getUserId());
    assertEquals(Integer.valueOf(1), r2.getQueuePosition());
}
```

**Kiểm tra:**
- Walk-in reservation có queuePosition = 0
- Online reservation có queuePosition > 0
- Update sang readypickup reset queuePosition = 0
- findNextInQueue tìm đúng người chờ đầu tiên

