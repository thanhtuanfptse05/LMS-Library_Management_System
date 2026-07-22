package util;

import org.junit.Test;
import static org.junit.Assert.*;

public class IsbnValidatorTest {

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidIsbn10Standard() {
        // ISBN-10 hợp lệ với các chữ số chuẩn (0306406152)
        assertTrue("ISBN-10 chuẩn hợp lệ", IsbnValidator.isValid("0306406152"));
    }

    @Test
    public void testValidIsbn10WithChecksumX() {
        // ISBN-10 hợp lệ có chữ số kiểm tra là 'X' hoặc 'x' (080442957X)
        assertTrue("ISBN-10 với checksum X viết hoa hợp lệ", IsbnValidator.isValid("080442957X"));
        assertTrue("ISBN-10 với checksum x viết thường hợp lệ", IsbnValidator.isValid("080442957x"));
    }

    @Test
    public void testValidIsbn13Standard() {
        // ISBN-13 chuẩn hợp lệ (9780306406157)
        assertTrue("ISBN-13 chuẩn hợp lệ", IsbnValidator.isValid("9780306406157"));
    }

    @Test
    public void testValidIsbnWithHyphensAndSpaces() {
        // ISBN có định dạng chứa dấu gạch ngang hoặc khoảng trắng
        assertTrue("ISBN-13 chứa dấu gạch ngang hợp lệ", IsbnValidator.isValid("978-0-306-40615-7"));
        assertTrue("ISBN-10 chứa khoảng trắng hợp lệ", IsbnValidator.isValid("0 306 40615 2"));
    }

    @Test
    public void testNormalizeValidString() {
        assertEquals("9780306406157", IsbnValidator.normalize(" 978-0-306-40615-7 "));
        assertEquals("080442957X", IsbnValidator.normalize("0-8044-2957-x"));
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testBoundaryLength10Digits() {
        // Chuỗi đúng 10 ký tự sau khi chuẩn hóa
        String normalized = IsbnValidator.normalize("0306406152");
        assertNotNull(normalized);
        assertEquals(10, normalized.length());
        assertTrue(IsbnValidator.isValid("0306406152"));
    }

    @Test
    public void testBoundaryLength13Digits() {
        // Chuỗi đúng 13 ký tự sau khi chuẩn hóa
        String normalized = IsbnValidator.normalize("9780306406157");
        assertNotNull(normalized);
        assertEquals(13, normalized.length());
        assertTrue(IsbnValidator.isValid("9780306406157"));
    }

    @Test
    public void testNormalizeNullAndEmpty() {
        assertNull("Normalize null phải trả về null", IsbnValidator.normalize(null));
        assertEquals("Normalize rỗng phải trả về chuỗi rỗng", "", IsbnValidator.normalize(""));
        assertEquals("Normalize chỉ có khoảng trắng trả về chuỗi rỗng", "", IsbnValidator.normalize("   "));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Errors
    // ==========================================

    @Test
    public void testInvalidNullOrEmptyIsbn() {
        assertFalse("ISBN null phải trả về false", IsbnValidator.isValid(null));
        assertFalse("ISBN rỗng phải trả về false", IsbnValidator.isValid(""));
        assertFalse("ISBN chỉ chứa khoảng trắng phải trả về false", IsbnValidator.isValid("   "));
    }

    @Test
    public void testInvalidLengthTooShortOrLong() {
        assertFalse("ISBN 9 ký tự phải trả về false", IsbnValidator.isValid("123456789"));
        assertFalse("ISBN 11 ký tự phải trả về false", IsbnValidator.isValid("12345678901"));
        assertFalse("ISBN 12 ký tự phải trả về false", IsbnValidator.isValid("123456789012"));
        assertFalse("ISBN 14 ký tự phải trả về false", IsbnValidator.isValid("97803064061571"));
    }

    @Test
    public void testInvalidChecksum() {
        // Sai số checksum
        assertFalse("ISBN-10 sai checksum phải trả về false", IsbnValidator.isValid("0306406153"));
        assertFalse("ISBN-13 sai checksum phải trả về false", IsbnValidator.isValid("9780306406158"));
    }

    @Test
    public void testInvalidCharacters() {
        assertFalse("ISBN chứa chữ cái không phải X ở cuối phải trả về false", IsbnValidator.isValid("030640615A"));
        assertFalse("ISBN-13 chứa chữ cái phải trả về false", IsbnValidator.isValid("978030640615X"));
        assertFalse("ISBN chứa ký tự đặc biệt phải trả về false", IsbnValidator.isValid("978030640615#"));
    }
}
