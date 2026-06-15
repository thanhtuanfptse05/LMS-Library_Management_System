package service;

import exception.ValidationException;
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
