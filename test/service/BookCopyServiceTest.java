package service;

import exception.ValidationException;
import java.sql.SQLException;
import model.BookCopy;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

public class BookCopyServiceTest {

    private BookCopyService bookCopyService;

    @Before
    public void setUp() {
        bookCopyService = new BookCopyService(null, null, null);
    }

    @Test
    public void validateCreateAcceptsValidCopy() throws Exception {
        bookCopyService.validateCreate(validCreateCopy());
        assertTrue(true);
    }

    @Test
    public void validateCreateRejectsMissingBarcode() throws Exception {
        BookCopy copy = validCreateCopy();
        copy.setBarcode(null);
        assertCreateValidation(copy, "Mã vạch không được để trống.");
    }

    @Test
    public void validateCreateAcceptsBarcodeWithCommonPrintableSeparators() throws Exception {
        BookCopy copy = validCreateCopy();
        copy.setBarcode("BC9780134093413-02_A/1.3");

        bookCopyService.validateCreate(copy);
        assertTrue(true);
    }

    @Test
    public void validateCreateRejectsBarcodeWithUnsafeCharacters() throws Exception {
        BookCopy copy = validCreateCopy();
        copy.setBarcode("BC 978@013#409");

        assertCreateValidation(copy, "Mã vạch chỉ được chứa chữ, số");
    }

    @Test
    public void isUniqueConstraintViolationDetectsPostgresqlSqlState() {
        SQLException e = new SQLException("duplicate key", "23505");

        assertTrue(bookCopyService.isUniqueConstraintViolation(e));
    }

    @Test
    public void isUniqueConstraintViolationChecksNestedSqlException() {
        SQLException root = new SQLException("outer", "08006");
        root.setNextException(new SQLException("duplicate key", "23505"));

        assertTrue(bookCopyService.isUniqueConstraintViolation(root));
    }

    @Test
    public void validateUpdateOnlyRequiresValidLocation() throws Exception {
        BookCopy copy = new BookCopy();
        copy.setBookCopyId(1);
        copy.setLocation("Kho A · Kệ A12");
        copy.setCondition("worn");
        bookCopyService.validateUpdate(copy);
        assertTrue(true);
    }

    private void assertCreateValidation(BookCopy copy, String expected) throws Exception {
        try {
            bookCopyService.validateCreate(copy);
            fail("Expected ValidationException");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains(expected));
        }
    }

    private BookCopy validCreateCopy() {
        BookCopy copy = new BookCopy();
        copy.setBookId(1);
        copy.setBarcode("BC-TEST-001");
        copy.setLocation("Kho A · Kệ A12");
        return copy;
    }
}
