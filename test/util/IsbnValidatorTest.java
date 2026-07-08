package util;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Test;

public class IsbnValidatorTest {

    @Test
    public void acceptsValidIsbn13() {
        assertTrue(IsbnValidator.isValid("9780134685991"));
    }

    @Test
    public void acceptsValidIsbn10WithXChecksum() {
        assertTrue(IsbnValidator.isValid("080442957X"));
    }

    @Test
    public void normalizesHyphenAndWhitespace() {
        assertEquals("9780134685991", IsbnValidator.normalize("978-0-13-468599-1 "));
    }

    @Test
    public void rejectsInvalidIsbn13Checksum() {
        assertFalse(IsbnValidator.isValid("9780134685992"));
    }

    @Test
    public void rejectsInvalidCharacters() {
        assertFalse(IsbnValidator.isValid("97801346859A1"));
    }

    @Test
    public void rejectsUnsupportedLength() {
        assertFalse(IsbnValidator.isValid("123456789"));
    }
}
