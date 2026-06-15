package service;

import exception.ValidationException;
import model.Category;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

public class CategoryServiceTest {

    private CategoryService categoryService;

    @Before
    public void setUp() {
        categoryService = new CategoryService(null, null);
    }

    @Test
    public void validateAcceptsValidCategory() throws Exception {
        Category category = new Category();
        category.setName("Công nghệ thông tin");
        category.setStatus("active");
        categoryService.validate(category);
        assertTrue(true);
    }

    @Test
    public void validateRejectsMissingName() throws Exception {
        Category category = new Category();
        category.setStatus("active");
        try {
            categoryService.validate(category);
            fail("Expected ValidationException");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("Tên thể loại không được để trống."));
        }
    }
}
