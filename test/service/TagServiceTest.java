package service;

import exception.ValidationException;
import model.Tag;
import org.junit.Before;
import org.junit.Test;

public class TagServiceTest {

    private TagService tagService;

    @Before
    public void setUp() {
        tagService = new TagService();
    }

    private Tag createValidTag() {
        Tag tag = new Tag();
        tag.setName("Java17");
        tag.setStatus("active");
        return tag;
    }

    // ==========================================
    // NORMAL (N) TEST CASES - Happy Path
    // ==========================================

    @Test
    public void testValidateValidActiveTag() throws ValidationException {
        Tag tag = createValidTag();
        tagService.validate(tag);
    }

    @Test
    public void testValidateValidHiddenTag() throws ValidationException {
        Tag tag = createValidTag();
        tag.setStatus("hidden");
        tagService.validate(tag);
    }

    // ==========================================
    // BOUNDARY (B) TEST CASES - Edge Cases
    // ==========================================

    @Test
    public void testValidateBoundaryNameLength100() throws ValidationException {
        Tag tag = createValidTag();
        tag.setName("T".repeat(100));
        tagService.validate(tag);
    }

    @Test
    public void testValidateBoundaryNameLength1() throws ValidationException {
        Tag tag = createValidTag();
        tag.setName("X");
        tagService.validate(tag);
    }

    // ==========================================
    // ABNORMAL (A) TEST CASES - Invalid / Exception
    // ==========================================

    @Test(expected = ValidationException.class)
    public void testValidateNullName() throws ValidationException {
        Tag tag = createValidTag();
        tag.setName(null);
        tagService.validate(tag);
    }

    @Test(expected = ValidationException.class)
    public void testValidateBlankName() throws ValidationException {
        Tag tag = createValidTag();
        tag.setName("   ");
        tagService.validate(tag);
    }

    @Test(expected = ValidationException.class)
    public void testValidateNameExceeds100Chars() throws ValidationException {
        Tag tag = createValidTag();
        tag.setName("T".repeat(101));
        tagService.validate(tag);
    }

    @Test(expected = ValidationException.class)
    public void testValidateInvalidStatus() throws ValidationException {
        Tag tag = createValidTag();
        tag.setStatus("deleted");
        tagService.validate(tag);
    }
}
