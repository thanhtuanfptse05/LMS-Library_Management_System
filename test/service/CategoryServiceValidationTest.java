package service;

import exception.ValidationException;
import model.Category;
import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class CategoryServiceValidationTest {

    @Test
    public void categoryNameIsNormalizedBeforePersistence() throws ValidationException {
        Category category = new Category();
        category.setName("  Khoa học  ");
        category.setDescription("  Sách khoa học  ");
        category.setStatus("active");

        new CategoryService().validate(category);

        assertEquals("Khoa học", category.getName());
        assertEquals("Sách khoa học", category.getDescription());
    }
}
