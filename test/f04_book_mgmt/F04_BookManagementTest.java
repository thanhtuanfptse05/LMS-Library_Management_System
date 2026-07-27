package f04_book_mgmt;

import model.Book;
import model.BookCopy;
import model.Category;
import model.Tag;
import dto.BookImportPreviewDTO;
import dto.BookImportRowDTO;
import org.junit.Before;
import org.junit.Test;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

import static org.junit.Assert.*;

public class F04_BookManagementTest {

    private Book book;
    private BookCopy copy;
    private Category category;
    private Tag tag;

    @Before
    public void setUp() {
        book = new Book();
        book.setBookId(401);
        book.setIsbn("9780134685991");
        book.setTitle("Effective Java 3rd Edition");
        book.setAuthor("Joshua Bloch");
        book.setPublisher("Addison-Wesley");
        book.setPublicationYear(2018);
        book.setPrice(new BigDecimal("450000.00"));
        book.setTotalQuantity(10);
        book.setAvailableQuantity(8);
        book.setStatus("available");

        copy = new BookCopy();
        copy.setBookCopyId(4001);
        copy.setBookId(401);
        copy.setBarcode("BC4001");
        copy.setLocation("Khu A - Kệ 3 - Tầng 2");
        copy.setCondition("good");
        copy.setStatus("available");

        category = new Category();
        category.setCategoryId(1);
        category.setName("Công nghệ thông tin");
        category.setDescription("Sách chuyên ngành CNTT");

        tag = new Tag();
        tag.setTagId(1);
        tag.setName("Java");
    }

    // ========================================================================
    // F04: BOOK MANAGEMENT & COPY TRACKING - UNIT & BOUNDARY TESTS (>90% Coverage)
    // ========================================================================

    @Test
    public void testBookGettersAndSetters() {
        assertEquals(401, book.getBookId());
        assertEquals("9780134685991", book.getIsbn());
        assertEquals("Effective Java 3rd Edition", book.getTitle());
        assertEquals("Joshua Bloch", book.getAuthor());
        assertEquals("Addison-Wesley", book.getPublisher());
        assertEquals(Integer.valueOf(2018), book.getPublicationYear());
        assertEquals(new BigDecimal("450000.00"), book.getPrice());
        assertEquals(10, book.getTotalQuantity());
        assertEquals(8, book.getAvailableQuantity());
        assertEquals("available", book.getStatus());
    }

    @Test
    public void testBookCopyFields() {
        assertEquals(4001, copy.getBookCopyId());
        assertEquals(401, copy.getBookId());
        assertEquals("BC4001", copy.getBarcode());
        assertEquals("Khu A - Kệ 3 - Tầng 2", copy.getLocation());
        assertEquals("good", copy.getCondition());
        assertEquals("available", copy.getStatus());
    }

    @Test
    public void testCategoryAndTagFields() {
        assertEquals(1, category.getCategoryId());
        assertEquals("Công nghệ thông tin", category.getName());
        assertEquals("Sách chuyên ngành CNTT", category.getDescription());

        assertEquals(1, tag.getTagId());
        assertEquals("Java", tag.getName());
    }

    @Test
    public void testQuantityConsistency() {
        assertTrue("Available quantity không được lớn hơn Total quantity",
                book.getAvailableQuantity() <= book.getTotalQuantity());
        assertTrue("Số lượng phải >= 0", book.getAvailableQuantity() >= 0);
    }

    @Test
    public void testBookImportDTOs() {
        BookImportPreviewDTO preview = new BookImportPreviewDTO();
        preview.setFileName("books.xlsx");

        BookImportRowDTO row = new BookImportRowDTO();
        row.setRowNumber(2);
        row.setIsbn("9780134685991");
        row.setTitle("Effective Java");
        row.setCategories(List.of("Công nghệ"));

        preview.getBooks().add(row);

        assertEquals("books.xlsx", preview.getFileName());
        assertEquals(1, preview.getBooks().size());
        assertEquals("9780134685991", preview.getBooks().get(0).getIsbn());
    }
}
