package model;

import java.util.ArrayList;
import java.util.List;

public class BookImportPreview {

    private String fileName;
    private List<BookImportRowDTO> books = new ArrayList<>();
    private List<BookImportRowDTO> bookCopies = new ArrayList<>();
    private List<BookImportError> errors = new ArrayList<>();

    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public List<BookImportRowDTO> getBooks() { return books; }
    public void setBooks(List<BookImportRowDTO> books) { this.books = books; }
    public List<BookImportRowDTO> getBookCopies() { return bookCopies; }
    public void setBookCopies(List<BookImportRowDTO> bookCopies) { this.bookCopies = bookCopies; }
    public List<BookImportError> getErrors() { return errors; }
    public void setErrors(List<BookImportError> errors) { this.errors = errors; }
    public int getTotalRows() { return books.size() + bookCopies.size(); }
    public boolean isValid() { return errors.isEmpty(); }
}
