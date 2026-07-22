package service;

import exception.ValidationException;
import model.BookCopy;
import org.junit.Before;
import org.junit.Test;

public class BookCopyServiceTest {

    private BookCopyService bookCopyService;

    @Before
    public void setUp() {
        bookCopyService = new BookCopyService();
    }

    private BookCopy createValidCopy() {
        BookCopy copy = new BookCopy();
        copy.setBookCopyId(1);
        copy.setBookId(10);
        copy.setBarcode("BC-2026-1001");
        copy.setLocation("Kệ A1-02");
        copy.setCondition("good");
        copy.setStatus("available");
        return copy;
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateCreateValidCopy() throws ValidationException {
        BookCopy copy = createValidCopy();
        bookCopyService.validateCreate(copy);
    }

    @Test
    public void testValidateUpdateValidCopy() throws ValidationException {
        BookCopy copy = createValidCopy();
        bookCopyService.validateUpdate(copy);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateCreateBarcodeLength50() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setBarcode("B".repeat(50));
        bookCopyService.validateCreate(copy);
    }

    @Test
    public void testValidateCreateLocationLength255() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setLocation("L".repeat(255));
        bookCopyService.validateCreate(copy);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateCreateInvalidBookId() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setBookId(0);
        bookCopyService.validateCreate(copy);
    }

    @Test(expected = ValidationException.class)
    public void testValidateCreateNullBarcode() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setBarcode(null);
        bookCopyService.validateCreate(copy);
    }

    @Test(expected = ValidationException.class)
    public void testValidateCreateBarcodeExceeds50() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setBarcode("B".repeat(51));
        bookCopyService.validateCreate(copy);
    }

    @Test(expected = ValidationException.class)
    public void testValidateCreateBarcodeSpecialChars() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setBarcode("BC@123#456");
        bookCopyService.validateCreate(copy);
    }

    @Test(expected = ValidationException.class)
    public void testValidateCreateBlankLocation() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setLocation("   ");
        bookCopyService.validateCreate(copy);
    }

    @Test(expected = ValidationException.class)
    public void testValidateCreateLocationExceeds255() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setLocation("L".repeat(256));
        bookCopyService.validateCreate(copy);
    }

    @Test(expected = ValidationException.class)
    public void testValidateUpdateInvalidCopyId() throws ValidationException {
        BookCopy copy = createValidCopy();
        copy.setBookCopyId(-1);
        bookCopyService.validateUpdate(copy);
    }
}
