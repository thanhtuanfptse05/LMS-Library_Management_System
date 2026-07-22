package util;

import dto.BookImportPreviewDTO;
import dto.BookImportRowDTO;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.junit.Before;
import org.junit.Test;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import static org.junit.Assert.*;

public class BookImportWorkbookReaderTest {

    private BookImportWorkbookReader reader;

    @Before
    public void setUp() {
        reader = new BookImportWorkbookReader();
    }

    private byte[] createTestWorkbook(boolean includeBooks, boolean includeCopies,
                                      boolean validBookHeaders, boolean validCopyHeaders) throws IOException {
        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            if (includeBooks) {
                Sheet booksSheet = workbook.createSheet("Books");
                Row headerRow = booksSheet.createRow(0);
                if (validBookHeaders) {
                    for (int i = 0; i < BookImportWorkbookReader.BOOK_HEADERS.size(); i++) {
                        headerRow.createCell(i).setCellValue(BookImportWorkbookReader.BOOK_HEADERS.get(i));
                    }
                    // Thêm 1 dòng dữ liệu hợp lệ
                    Row dataRow = booksSheet.createRow(1);
                    dataRow.createCell(0).setCellValue("9780306406157"); // isbn
                    dataRow.createCell(1).setCellValue("Lập trình Java Web"); // title
                    dataRow.createCell(2).setCellValue("Nguyễn Văn A"); // author
                    dataRow.createCell(3).setCellValue("NXB Giáo Dục"); // publisher
                    dataRow.createCell(4).setCellValue(2023); // publicationYear
                    dataRow.createCell(5).setCellValue(150000); // price
                    dataRow.createCell(6).setCellValue("Công nghệ thông tin"); // categories
                    dataRow.createCell(7).setCellValue("Java, Servlet"); // tags
                } else {
                    headerRow.createCell(0).setCellValue("wrong_header");
                }
            }

            if (includeCopies) {
                Sheet copiesSheet = workbook.createSheet("BookCopies");
                Row headerRow = copiesSheet.createRow(0);
                if (validCopyHeaders) {
                    for (int i = 0; i < BookImportWorkbookReader.COPY_HEADERS.size(); i++) {
                        headerRow.createCell(i).setCellValue(BookImportWorkbookReader.COPY_HEADERS.get(i));
                    }
                    // Thêm 1 dòng bản sao hợp lệ
                    Row dataRow = copiesSheet.createRow(1);
                    dataRow.createCell(0).setCellValue("9780306406157"); // isbn
                    dataRow.createCell(1).setCellValue("BC-1001"); // barcode
                    dataRow.createCell(2).setCellValue("Kệ A1-02"); // location
                } else {
                    headerRow.createCell(0).setCellValue("wrong_header");
                }
            }

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            workbook.write(baos);
            return baos.toByteArray();
        }
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testReadValidWorkbook() throws IOException {
        byte[] excelBytes = createTestWorkbook(true, true, true, true);
        BookImportPreviewDTO preview = reader.read(new ByteArrayInputStream(excelBytes), "test_books.xlsx");

        assertNotNull(preview);
        assertEquals("test_books.xlsx", preview.getFileName());
        assertTrue("Không được có lỗi với file hợp lệ", preview.getErrors().isEmpty());
        assertEquals(1, preview.getBooks().size());
        assertEquals(1, preview.getBookCopies().size());

        BookImportRowDTO bookRow = preview.getBooks().get(0);
        assertEquals("9780306406157", bookRow.getIsbn());
        assertEquals("Lập trình Java Web", bookRow.getTitle());
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testReadWorkbookWithOnlyHeaderRows() throws IOException {
        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            Sheet booksSheet = workbook.createSheet("Books");
            Row bHeader = booksSheet.createRow(0);
            for (int i = 0; i < BookImportWorkbookReader.BOOK_HEADERS.size(); i++) {
                bHeader.createCell(i).setCellValue(BookImportWorkbookReader.BOOK_HEADERS.get(i));
            }
            Sheet copiesSheet = workbook.createSheet("BookCopies");
            Row cHeader = copiesSheet.createRow(0);
            for (int i = 0; i < BookImportWorkbookReader.COPY_HEADERS.size(); i++) {
                cHeader.createCell(i).setCellValue(BookImportWorkbookReader.COPY_HEADERS.get(i));
            }

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            workbook.write(baos);
            BookImportPreviewDTO preview = reader.read(new ByteArrayInputStream(baos.toByteArray()), "empty_headers.xlsx");

            assertNotNull(preview);
            assertTrue(preview.getBooks().isEmpty());
            assertTrue(preview.getBookCopies().isEmpty());
        }
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Errors
    // ==========================================

    @Test
    public void testReadWorkbookMissingBooksSheet() throws IOException {
        byte[] excelBytes = createTestWorkbook(false, true, true, true);
        BookImportPreviewDTO preview = reader.read(new ByteArrayInputStream(excelBytes), "no_books.xlsx");

        assertFalse("Phải chứa báo lỗi do thiếu sheet Books", preview.getErrors().isEmpty());
        assertTrue(preview.getErrors().stream().anyMatch(e -> e.getErrorMessage().contains("Books")));
    }

    @Test
    public void testReadWorkbookMissingCopiesSheet() throws IOException {
        byte[] excelBytes = createTestWorkbook(true, false, true, true);
        BookImportPreviewDTO preview = reader.read(new ByteArrayInputStream(excelBytes), "no_copies.xlsx");

        assertFalse("Phải chứa báo lỗi do thiếu sheet BookCopies", preview.getErrors().isEmpty());
        assertTrue(preview.getErrors().stream().anyMatch(e -> e.getErrorMessage().contains("BookCopies")));
    }

    @Test
    public void testReadWorkbookInvalidHeaders() throws IOException {
        byte[] excelBytes = createTestWorkbook(true, true, false, false);
        BookImportPreviewDTO preview = reader.read(new ByteArrayInputStream(excelBytes), "invalid_headers.xlsx");

        assertFalse("Phải chứa báo lỗi do sai tên tiêu đề cột", preview.getErrors().isEmpty());
    }
}
