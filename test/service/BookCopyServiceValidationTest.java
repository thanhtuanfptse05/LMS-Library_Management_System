package service;

import exception.ValidationException;
import model.BookCopy;
import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class BookCopyServiceValidationTest {

    @Test
    public void createNormalizesBarcodeAndLocation() throws ValidationException {
        BookCopy copy = new BookCopy();
        copy.setBookId(1);
        copy.setBarcode("  COPY-001  ");
        copy.setLocation("  Kệ A1  ");

        new BookCopyService().validateCreate(copy);

        assertEquals("COPY-001", copy.getBarcode());
        assertEquals("Kệ A1", copy.getLocation());
    }
}
