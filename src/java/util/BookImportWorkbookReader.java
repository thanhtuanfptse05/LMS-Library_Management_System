package util;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import model.BookImportError;
import model.BookImportPreview;
import model.BookImportRowDTO;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class BookImportWorkbookReader {

    public static final List<String> BOOK_HEADERS = Arrays.asList(
            "isbn", "title", "author", "publisher", "publicationYear", "price", "categories", "tags");
    public static final List<String> COPY_HEADERS = Arrays.asList("isbn", "barcode", "location");
    private final DataFormatter formatter = new DataFormatter(Locale.ROOT);

    public BookImportPreview read(InputStream input, String fileName) throws IOException {
        BookImportPreview preview = new BookImportPreview();
        preview.setFileName(fileName);
        try (XSSFWorkbook workbook = new XSSFWorkbook(input)) {
            Sheet books = workbook.getSheet("Books");
            Sheet copies = workbook.getSheet("BookCopies");
            if (books == null) {
                preview.getErrors().add(new BookImportError("Books", 1, null, "Thiếu sheet bắt buộc Books."));
            } else if (validateHeaders(books, BOOK_HEADERS, preview)) {
                readBooks(books, preview);
            }
            if (copies == null) {
                preview.getErrors().add(new BookImportError("BookCopies", 1, null,
                        "Thiếu sheet bắt buộc BookCopies."));
            } else if (validateHeaders(copies, COPY_HEADERS, preview)) {
                readCopies(copies, preview);
            }
        }
        validateInternalDuplicates(preview);
        if (preview.getBookCopies().size() > 5000) {
            preview.getErrors().add(new BookImportError("BookCopies", 1, null,
                    "Tệp vượt quá giới hạn 5.000 bản sao."));
        }
        return preview;
    }

    private boolean validateHeaders(Sheet sheet, List<String> expected, BookImportPreview preview) {
        Row header = sheet.getRow(0);
        if (header == null) {
            preview.getErrors().add(new BookImportError(sheet.getSheetName(), 1, null,
                    "Thiếu dòng tiêu đề."));
            return false;
        }
        boolean valid = true;
        for (int i = 0; i < expected.size(); i++) {
            String actual = value(header, i);
            if (!expected.get(i).equals(actual)) {
                preview.getErrors().add(new BookImportError(sheet.getSheetName(), 1, expected.get(i),
                        "Cột thứ " + (i + 1) + " phải có tên " + expected.get(i) + "."));
                valid = false;
            }
        }
        for (int i = expected.size(); i < header.getLastCellNum(); i++) {
            if (!value(header, i).isBlank()) {
                preview.getErrors().add(new BookImportError(sheet.getSheetName(), 1, value(header, i),
                        "Tệp có cột không thuộc mẫu chuẩn."));
                valid = false;
            }
        }
        return valid;
    }

    private void readBooks(Sheet sheet, BookImportPreview preview) {
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (isBlank(row, BOOK_HEADERS.size())) {
                continue;
            }
            BookImportRowDTO item = base(sheet, i, row);
            item.setTitle(value(row, 1));
            item.setAuthor(nullIfBlank(value(row, 2)));
            item.setPublisher(nullIfBlank(value(row, 3)));
            item.setPublicationYear(integerValue(sheet, i, row, 4, "publicationYear", preview));
            item.setPrice(decimalValue(sheet, i, row, 5, "price", preview));
            item.setCategories(split(value(row, 6)));
            item.setTags(split(value(row, 7)));
            require(item.getIsbn(), sheet, i, "isbn", preview);
            require(item.getTitle(), sheet, i, "title", preview);
            preview.getBooks().add(item);
        }
    }

    private void readCopies(Sheet sheet, BookImportPreview preview) {
        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (isBlank(row, COPY_HEADERS.size())) {
                continue;
            }
            BookImportRowDTO item = base(sheet, i, row);
            item.setBarcode(value(row, 1));
            item.setLocation(value(row, 2));
            require(item.getIsbn(), sheet, i, "isbn", preview);
            require(item.getBarcode(), sheet, i, "barcode", preview);
            require(item.getLocation(), sheet, i, "location", preview);
            preview.getBookCopies().add(item);
        }
    }

    private BookImportRowDTO base(Sheet sheet, int rowIndex, Row row) {
        BookImportRowDTO item = new BookImportRowDTO();
        item.setSheetName(sheet.getSheetName());
        item.setRowNumber(rowIndex + 1);
        item.setIsbn(value(row, 0));
        return item;
    }

    private Integer integerValue(Sheet sheet, int rowIndex, Row row, int column, String name,
            BookImportPreview preview) {
        String raw = value(row, column);
        if (raw.isBlank()) {
            return null;
        }
        try {
            return new BigDecimal(raw).intValueExact();
        } catch (ArithmeticException | NumberFormatException e) {
            preview.getErrors().add(new BookImportError(sheet.getSheetName(), rowIndex + 1, name,
                    "Giá trị phải là số nguyên."));
            return null;
        }
    }

    private BigDecimal decimalValue(Sheet sheet, int rowIndex, Row row, int column, String name,
            BookImportPreview preview) {
        String raw = value(row, column);
        if (raw.isBlank()) {
            return null;
        }
        try {
            return new BigDecimal(raw);
        } catch (NumberFormatException e) {
            preview.getErrors().add(new BookImportError(sheet.getSheetName(), rowIndex + 1, name,
                    "Giá trị phải là số hợp lệ."));
            return null;
        }
    }

    private void validateInternalDuplicates(BookImportPreview preview) {
        Set<String> isbns = new HashSet<>();
        for (BookImportRowDTO row : preview.getBooks()) {
            if (!row.getIsbn().isBlank() && !isbns.add(row.getIsbn().toLowerCase())) {
                preview.getErrors().add(new BookImportError("Books", row.getRowNumber(), "isbn",
                        "ISBN bị trùng trong tệp."));
            }
        }
        Set<String> barcodes = new HashSet<>();
        for (BookImportRowDTO row : preview.getBookCopies()) {
            if (!row.getBarcode().isBlank() && !barcodes.add(row.getBarcode().toLowerCase())) {
                preview.getErrors().add(new BookImportError("BookCopies", row.getRowNumber(), "barcode",
                        "Mã vạch bị trùng trong tệp."));
            }
        }
    }

    private void require(String value, Sheet sheet, int rowIndex, String column, BookImportPreview preview) {
        if (value == null || value.isBlank()) {
            preview.getErrors().add(new BookImportError(sheet.getSheetName(), rowIndex + 1, column,
                    "Dữ liệu bắt buộc không được để trống."));
        }
    }

    private boolean isBlank(Row row, int columns) {
        if (row == null) {
            return true;
        }
        for (int i = 0; i < columns; i++) {
            if (!value(row, i).isBlank()) {
                return false;
            }
        }
        return true;
    }

    private String value(Row row, int column) {
        return row == null ? "" : formatter.formatCellValue(row.getCell(column)).trim();
    }

    private List<String> split(String value) {
        List<String> result = new ArrayList<>();
        Set<String> seen = new HashSet<>();
        for (String item : value.split(";")) {
            String trimmed = item.trim();
            if (!trimmed.isEmpty() && seen.add(trimmed.toLowerCase())) {
                result.add(trimmed);
            }
        }
        return result;
    }

    private String nullIfBlank(String value) {
        return value.isBlank() ? null : value;
    }
}
