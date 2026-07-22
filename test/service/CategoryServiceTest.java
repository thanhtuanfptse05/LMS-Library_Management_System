package service;

import exception.ValidationException;
import model.Category;
import org.junit.Before;
import org.junit.Test;

public class CategoryServiceTest {

    private CategoryService categoryService;

    @Before
    public void setUp() {
        categoryService = new CategoryService();
    }

    private Category createValidCategory() {
        Category category = new Category();
        category.setName("Khoa Học Máy Tính");
        category.setDescription("Sách về công nghệ và khoa học máy tính");
        category.setStatus("active");
        return category;
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateValidActiveCategory() throws ValidationException {
        Category category = createValidCategory();
        categoryService.validate(category);
    }

    @Test
    public void testValidateValidHiddenCategory() throws ValidationException {
        Category category = createValidCategory();
        category.setStatus("hidden");
        categoryService.validate(category);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateBoundaryNameLength255() throws ValidationException {
        Category category = createValidCategory();
        category.setName("C".repeat(255));
        categoryService.validate(category);
    }

    @Test
    public void testValidateBoundaryNameLength1() throws ValidationException {
        Category category = createValidCategory();
        category.setName("A");
        categoryService.validate(category);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateNullName() throws ValidationException {
        Category category = createValidCategory();
        category.setName(null);
        categoryService.validate(category);
    }

    @Test(expected = ValidationException.class)
    public void testValidateBlankName() throws ValidationException {
        Category category = createValidCategory();
        category.setName("   ");
        categoryService.validate(category);
    }

    @Test(expected = ValidationException.class)
    public void testValidateNameExceeds255Chars() throws ValidationException {
        Category category = createValidCategory();
        category.setName("C".repeat(256));
        categoryService.validate(category);
    }

    @Test(expected = ValidationException.class)
    public void testValidateInvalidStatus() throws ValidationException {
        Category category = createValidCategory();
        category.setStatus("archived");
        categoryService.validate(category);
    }
}
