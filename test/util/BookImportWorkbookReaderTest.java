package util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import dto.BookImportPreviewDTO;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class BookImportWorkbookReaderTest {

    @Test
    public void readsValidWorkbookAndSkipsBlankRows() throws Exception {
        byte[] workbook = workbook(false, false);
        BookImportPreviewDTO preview = new BookImportWorkbookReader().read(
                new ByteArrayInputStream(workbook), "valid.xlsx");
        assertTrue(preview.isValid());
        assertEquals(1, preview.getBooks().size());
        assertEquals(1, preview.getBookCopies().size());
    }

    @Test
    public void rejectsDuplicateBarcodeInsideWorkbook() throws Exception {
        BookImportPreviewDTO preview = new BookImportWorkbookReader().read(
                new ByteArrayInputStream(workbook(true, false)), "duplicate.xlsx");
        assertFalse(preview.isValid());
        assertTrue(preview.getErrors().stream()
                .anyMatch(error -> error.getErrorMessage().contains("Mã vạch bị trùng trong tệp")));
    }

    @Test
    public void rejectsMissingRequiredSheet() throws Exception {
        BookImportPreviewDTO preview = new BookImportWorkbookReader().read(
                new ByteArrayInputStream(workbook(false, true)), "missing.xlsx");
        assertFalse(preview.isValid());
        assertTrue(preview.getErrors().stream()
                .anyMatch(error -> error.getErrorMessage().contains("Thiếu sheet bắt buộc BookCopies")));
    }

    private byte[] workbook(boolean duplicateBarcode, boolean omitCopies) throws Exception {
        try (XSSFWorkbook workbook = new XSSFWorkbook(); ByteArrayOutputStream output = new ByteArrayOutputStream()) {
            Sheet books = workbook.createSheet("Books");
            header(books, BookImportWorkbookReader.BOOK_HEADERS.toArray(String[]::new));
            Row book = books.createRow(1);
            values(book, "978604TEST001", "Sách kiểm thử", "Tác giả", "NXB", "2026", "100000",
                    "Kiểm thử; Giáo trình", "Java; Test");
            books.createRow(2);
            if (!omitCopies) {
                Sheet copies = workbook.createSheet("BookCopies");
                header(copies, BookImportWorkbookReader.COPY_HEADERS.toArray(String[]::new));
                values(copies.createRow(1), "978604TEST001", "BC-TEST-IMPORT-001", "Kho kiểm thử");
                if (duplicateBarcode) {
                    values(copies.createRow(2), "978604TEST001", "BC-TEST-IMPORT-001", "Kho kiểm thử");
                }
            }
            workbook.write(output);
            return output.toByteArray();
        }
    }

    private void header(Sheet sheet, String... values) {
        values(sheet.createRow(0), values);
    }

    private void values(Row row, String... values) {
        for (int i = 0; i < values.length; i++) {
            row.createCell(i).setCellValue(values[i]);
        }
    }
}
