package service;

import exception.ValidationException;
import model.BookSuggestion;
import org.junit.Before;
import org.junit.Test;

public class BookSuggestionServiceTest {

    private BookSuggestionService suggestionService;

    @Before
    public void setUp() {
        suggestionService = new BookSuggestionService();
    }

    private BookSuggestion createValidSuggestion() {
        BookSuggestion s = new BookSuggestion();
        s.setTitle("Thiết Kế Kiến Trúc Phần Mềm");
        s.setAuthor("Martin Fowler");
        s.setPublisher("NXB Trẻ");
        s.setIsbn("9780306406157");
        s.setReason("Phục vụ môn học SWP391 và kiến trúc phần mềm đại học.");
        s.setStatus("pending");
        return s;
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateValidSuggestion() throws ValidationException {
        BookSuggestion s = createValidSuggestion();
        suggestionService.validate(s);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateBoundaryTitleLength255() throws ValidationException {
        BookSuggestion s = createValidSuggestion();
        s.setTitle("T".repeat(255));
        suggestionService.validate(s);
    }

    @Test
    public void testValidateBoundaryReasonLength1000() throws ValidationException {
        BookSuggestion s = createValidSuggestion();
        s.setReason("R".repeat(1000));
        suggestionService.validate(s);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateNullTitle() throws ValidationException {
        BookSuggestion s = createValidSuggestion();
        s.setTitle(null);
        suggestionService.validate(s);
    }

    @Test(expected = ValidationException.class)
    public void testValidateBlankAuthor() throws ValidationException {
        BookSuggestion s = createValidSuggestion();
        s.setAuthor("   ");
        suggestionService.validate(s);
    }

    @Test(expected = ValidationException.class)
    public void testValidateIsbnTooShort() throws ValidationException {
        BookSuggestion s = createValidSuggestion();
        s.setIsbn("12345");
        suggestionService.validate(s);
    }

    @Test(expected = ValidationException.class)
    public void testValidateReasonExceeds1000() throws ValidationException {
        BookSuggestion s = createValidSuggestion();
        s.setReason("R".repeat(1001));
        suggestionService.validate(s);
    }
}
