package util;

import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;

public final class CsvExportUtil {

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private CsvExportUtil() {
    }

    public static PrintWriter utf8BomWriter(OutputStream output) throws IOException {
        OutputStreamWriter writer = new OutputStreamWriter(output, StandardCharsets.UTF_8);
        writer.write('\uFEFF');
        return new PrintWriter(writer);
    }

    public static String escape(String value) {
        if (value == null) {
            return "";
        }
        String safeValue = neutralizeFormula(value);
        if (safeValue.contains(",") || safeValue.contains("\"") || safeValue.contains("\n")
                || safeValue.contains("\r")) {
            return "\"" + safeValue.replace("\"", "\"\"") + "\"";
        }
        return safeValue;
    }

    public static String formatTimestamp(Timestamp value) {
        return value == null ? "" : value.toLocalDateTime().format(DATE_TIME_FORMATTER);
    }

    private static String neutralizeFormula(String value) {
        return startsLikeFormula(value) ? "'" + value : value;
    }

    private static boolean startsLikeFormula(String value) {
        if (value.isEmpty()) {
            return false;
        }
        if (isFormulaTrigger(value.charAt(0))) {
            return true;
        }
        int index = 0;
        while (index < value.length() && value.charAt(index) == ' ') {
            index++;
        }
        return index < value.length() && isFormulaTrigger(value.charAt(index));
    }

    private static boolean isFormulaTrigger(char value) {
        return value == '=' || value == '+' || value == '-' || value == '@'
                || value == '\t' || value == '\r' || value == '\n';
    }
}
