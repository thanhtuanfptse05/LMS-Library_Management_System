package util;

import org.junit.Test;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import static org.junit.Assert.*;

public class CsvExportUtilTest {

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testEscapeNormalText() {
        assertEquals("Hello World", CsvExportUtil.escape("Hello World"));
        assertEquals("LMS Library 2026", CsvExportUtil.escape("LMS Library 2026"));
    }

    @Test
    public void testEscapeSpecialCharactersCommaAndQuotes() {
        assertEquals("\"Java, Servlet\"", CsvExportUtil.escape("Java, Servlet"));
        assertEquals("\"Book \"\"Clean Code\"\"\"", CsvExportUtil.escape("Book \"Clean Code\""));
        assertEquals("\"Line1\nLine2\"", CsvExportUtil.escape("Line1\nLine2"));
    }

    @Test
    public void testFormatTimestampValid() {
        Timestamp ts = Timestamp.valueOf("2026-06-06 14:30:00");
        assertEquals("06/06/2026 14:30", CsvExportUtil.formatTimestamp(ts));
    }

    @Test
    public void testUtf8BomWriter() throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try (PrintWriter writer = CsvExportUtil.utf8BomWriter(baos)) {
            writer.print("Header1,Header2");
        }
        byte[] bytes = baos.toByteArray();
        assertTrue("Output phải có ít nhất 3 byte BOM UTF-8", bytes.length >= 3);
        // Kiểm tra 3 byte BOM EF BB BF
        assertEquals((byte) 0xEF, bytes[0]);
        assertEquals((byte) 0xBB, bytes[1]);
        assertEquals((byte) 0xBF, bytes[2]);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testEscapeEmptyString() {
        assertEquals("", CsvExportUtil.escape(""));
    }

    @Test
    public void testEscapeFormulaWithLeadingSpaces() {
        // Chuỗi có khoảng trắng đứng trước công thức Excel
        assertEquals("'   =1+1", CsvExportUtil.escape("   =1+1"));
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Security
    // ==========================================

    @Test
    public void testEscapeNull() {
        assertEquals("Null phải trả về chuỗi rỗng", "", CsvExportUtil.escape(null));
    }

    @Test
    public void testFormatTimestampNull() {
        assertEquals("Timestamp null phải trả về chuỗi rỗng", "", CsvExportUtil.formatTimestamp(null));
    }

    @Test
    public void testFormulaInjectionNeutralization() {
        // Chống lỗi CSV / Excel Formula Injection (=, +, -, @)
        assertEquals("'=SUM(A1:A10)", CsvExportUtil.escape("=SUM(A1:A10)"));
        assertEquals("'+123456", CsvExportUtil.escape("+123456"));
        assertEquals("'-5000", CsvExportUtil.escape("-5000"));
        assertEquals("'@CMD", CsvExportUtil.escape("@CMD"));
    }
}
