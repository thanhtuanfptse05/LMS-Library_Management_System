package service;

import dao.AuditLogDAO;
import dao.BookCopyDAO;
import dao.BookDAO;
import dao.BookImportDAO;
import dao.CategoryDAO;
import dao.TagDAO;
import dto.BookImportPreviewDTO;
import dto.BookImportRowDTO;
import exception.DatabaseException;
import exception.ValidationException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Book;
import model.BookCopy;
import model.BookImportBatch;
import model.BookImportError;
import model.Category;
import model.Tag;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class BookImportServiceTest {

    private BookImportService importService;
    private BookImportValidator validator;
    
    private MockBookDAO mockBookDAO;
    private MockBookCopyDAO mockCopyDAO;
    private MockBookImportDAO mockImportDAO;
    private MockCategoryDAO mockCategoryDAO;
    private MockTagDAO mockTagDAO;
    private MockAuditLogDAO mockAuditDAO;
    private MockBookService mockBookService;

    @Before
    public void setUp() {
        mockBookDAO = new MockBookDAO();
        mockCopyDAO = new MockBookCopyDAO();
        mockBookService = new MockBookService();
        validator = new BookImportValidator(mockBookDAO, mockCopyDAO, mockBookService);
        
        mockImportDAO = new MockBookImportDAO();
        mockCategoryDAO = new MockCategoryDAO();
        mockTagDAO = new MockTagDAO();
        mockAuditDAO = new MockAuditLogDAO();
        
        importService = new BookImportService(validator, mockImportDAO, mockBookDAO, mockCopyDAO, mockCategoryDAO, mockTagDAO, mockAuditDAO);
    }

    @Test
    public void testValidate_Success() throws Exception {
        BookImportPreviewDTO preview = new BookImportPreviewDTO();
        preview.setFileName("test.xlsx");
        
        BookImportRowDTO row = new BookImportRowDTO();
        row.setRowNumber(1);
        row.setIsbn("1234567890");
        row.setTitle("Valid Book");
        row.setBarcode("BC123");
        preview.getBooks().add(row);
        preview.getBookCopies().add(row);
        
        importService.validate(preview, 99);
        
        assertTrue("Không có lỗi validation", preview.isValid());
        assertEquals(0, preview.getErrors().size());
        assertFalse("Không insert batch lỗi", mockImportDAO.insertBatchCalled);
    }

    @Test
    public void testValidate_Fail_InvalidISBN() throws Exception {
        BookImportPreviewDTO preview = new BookImportPreviewDTO();
        preview.setFileName("test.xlsx");
        
        BookImportRowDTO row = new BookImportRowDTO();
        row.setRowNumber(1);
        row.setIsbn("invalid"); // Lỗi ISBN
        row.setTitle("Book");
        row.setBarcode("BC123");
        preview.getBooks().add(row);
        preview.getBookCopies().add(row);
        
        importService.validate(preview, 99);
        
        assertFalse("Phải validation fail", preview.isValid());
        assertTrue(preview.getErrors().size() > 0);
        assertTrue("Phải lưu lịch sử import lỗi", mockImportDAO.insertBatchCalled);
        assertTrue("Status batch phải là failed", mockImportDAO.batchInserted.getStatus().equals("failed"));
    }

    @Test
    public void testConfirm_Success() throws Exception {
        BookImportPreviewDTO preview = new BookImportPreviewDTO();
        preview.setFileName("test.xlsx");
        
        BookImportRowDTO row = new BookImportRowDTO();
        row.setRowNumber(1);
        row.setIsbn("1234567890123");
        row.setTitle("Valid Book");
        row.setBarcode("BC123");
        row.getCategories().add("IT");
        row.getTags().add("Java");
        preview.getBooks().add(row);
        preview.getBookCopies().add(row);
        
        int batchId = importService.confirm(preview, 99);
        
        assertTrue(batchId > 0);
        assertTrue("Phải insert book", mockBookDAO.insertCalled);
        assertTrue("Phải insert copy", mockCopyDAO.insertCalled);
        assertTrue("Phải insert batch", mockImportDAO.insertBatchCalled);
        assertEquals("success", mockImportDAO.batchInserted.getStatus());
        assertTrue("Phải có audit", mockAuditDAO.insertCalled);
    }

    @Test
    public void testConfirm_Fail_ValidationChanged() throws Exception {
        BookImportPreviewDTO preview = new BookImportPreviewDTO();
        preview.setFileName("test.xlsx");
        
        BookImportRowDTO row = new BookImportRowDTO();
        row.setRowNumber(1);
        row.setIsbn("1234567890123");
        row.setTitle("Valid Book");
        row.setBarcode("BC123");
        preview.getBooks().add(row);
        preview.getBookCopies().add(row);
        
        // Cố tình làm validation fail ở lần confirm (mock duplicate barcode)
        mockCopyDAO.existingBarcode = "BC123";
        
        try {
            importService.confirm(preview, 99);
            fail("Phải throw ValidationException");
        } catch (ValidationException e) {
            assertFalse("Không insert success", mockBookDAO.insertCalled);
            assertEquals("failed", mockImportDAO.batchInserted.getStatus());
        }
    }

    // ==========================================
    // MOCK CLASSES
    // ==========================================

    private static class MockBookDAO extends BookDAO {
        boolean insertCalled = false;
        @Override
        public Book findByIsbn(Connection conn, String isbn) throws SQLException {
            return null; // Giả lập sách mới
        }
        @Override
        public int insert(Connection conn, Book book) throws SQLException {
            insertCalled = true;
            return 100;
        }
        @Override
        public void replaceCategories(Connection conn, int bookId, int[] categoryIds) throws SQLException {}
        @Override
        public void replaceTags(Connection conn, int bookId, int[] tagIds) throws SQLException {}
        @Override
        public void updateQuantities(Connection conn, int bookId, int addedTotal, int addedAvailable) throws SQLException {}
    }

    private static class MockBookCopyDAO extends BookCopyDAO {
        boolean insertCalled = false;
        String existingBarcode = null;
        @Override
        public BookCopy findByBarcode(Connection conn, String barcode) throws SQLException {
            if (barcode.equals(existingBarcode)) return new BookCopy();
            return null;
        }
        @Override
        public int insert(Connection conn, BookCopy copy) throws SQLException {
            insertCalled = true;
            return 200;
        }
    }

    private static class MockBookImportDAO extends BookImportDAO {
        boolean insertBatchCalled = false;
        BookImportBatch batchInserted = null;
        @Override
        public int insertBatch(Connection conn, BookImportBatch batch) throws SQLException {
            insertBatchCalled = true;
            batchInserted = batch;
            return 300;
        }
        @Override
        public void insertErrors(Connection conn, int batchId, List<BookImportError> errors) throws SQLException {}
    }

    private static class MockCategoryDAO extends CategoryDAO {
        @Override
        public Category findByName(Connection conn, String name) throws SQLException {
            return null;
        }
        @Override
        public int insert(Connection conn, Category category, int actorId) throws SQLException {
            return 1;
        }
    }

    private static class MockTagDAO extends TagDAO {
        @Override
        public Tag findByName(Connection conn, String name) throws SQLException {
            return null;
        }
        @Override
        public int insert(Connection conn, Tag tag, int actorId) throws SQLException {
            return 1;
        }
    }

    private static class MockAuditLogDAO extends AuditLogDAO {
        boolean insertCalled = false;
        @Override
        public void insert(Connection conn, Integer userId, String actionType, String entityName, Integer entityId, String oldValues, String newValues) throws SQLException {
            insertCalled = true;
        }
    }

    private static class MockBookService extends BookService {
        @Override
        public void validate(Book book, boolean isCreate) throws ValidationException {
            // Happy path
        }
    }
}
