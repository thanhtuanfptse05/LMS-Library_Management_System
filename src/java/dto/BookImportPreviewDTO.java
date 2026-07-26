package dto;

import java.util.ArrayList;
import java.util.List;
import model.BookImportError;

public class BookImportPreviewDTO {

    private String fileName;
    private List<BookImportRowDTO> books = new ArrayList<>();
    private List<BookImportRowDTO> bookCopies = new ArrayList<>();
    private List<BookImportError> errors = new ArrayList<>();
    /** Cảnh báo không chặn import, ví dụ dòng đầu sách có ISBN đã tồn tại nên bị bỏ qua. */
    private List<BookImportError> warnings = new ArrayList<>();

    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public List<BookImportRowDTO> getBooks() { return books; }
    public void setBooks(List<BookImportRowDTO> books) { this.books = books; }
    public List<BookImportRowDTO> getBookCopies() { return bookCopies; }
    public void setBookCopies(List<BookImportRowDTO> bookCopies) { this.bookCopies = bookCopies; }
    public List<BookImportError> getErrors() { return errors; }
    public void setErrors(List<BookImportError> errors) { this.errors = errors; }
    public List<BookImportError> getWarnings() { return warnings; }
    public void setWarnings(List<BookImportError> warnings) { this.warnings = warnings; }
    public int getTotalRows() { return books.size() + bookCopies.size(); }
    public boolean isValid() { return errors.isEmpty(); }
    public boolean hasWarnings() { return !warnings.isEmpty(); }

    /** Số dòng đầu sách sẽ bị bỏ qua vì ISBN đã tồn tại trên hệ thống. */
    public int getSkippedBookRows() {
        int skipped = 0;
        for (BookImportRowDTO row : books) {
            if (row.isExistingBook()) {
                skipped++;
            }
        }
        return skipped;
    }

    /** Số dòng thực sự sẽ được ghi vào CSDL khi xác nhận import. */
    public int getImportableRows() { return getTotalRows() - getSkippedBookRows(); }
}
