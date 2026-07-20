package util;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class CsvExportUtilTest {

    @Test
    public void escapesRegularCsvValues() {
        assertEquals("Campbell Biology", CsvExportUtil.escape("Campbell Biology"));
        assertEquals("\"Biology, advanced\"", CsvExportUtil.escape("Biology, advanced"));
        assertEquals("\"He said \"\"OK\"\"\"", CsvExportUtil.escape("He said \"OK\""));
    }

    @Test
    public void neutralizesFormulaLikeValues() {
        assertEquals("\"'=IMPORTXML(\"\"http://example.com\"\")\"",
                CsvExportUtil.escape("=IMPORTXML(\"http://example.com\")"));
        assertEquals("\"'+SUM(1,2)\"", CsvExportUtil.escape("+SUM(1,2)"));
        assertEquals("'-10", CsvExportUtil.escape("-10"));
        assertEquals("'@cmd", CsvExportUtil.escape("@cmd"));
    }

    @Test
    public void neutralizesFormulaLikeValuesAfterLeadingSpaces() {
        assertEquals("\"'  =SUM(1,2)\"", CsvExportUtil.escape("  =SUM(1,2)"));
    }
}
