package service;

import exception.ValidationException;
import model.Tag;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

public class TagServiceTest {

    private TagService tagService;

    @Before
    public void setUp() {
        tagService = new TagService(null, null);
    }

    @Test
    public void validateAcceptsValidTag() throws Exception {
        Tag tag = new Tag();
        tag.setName("Java");
        tag.setStatus("active");
        tagService.validate(tag);
        assertTrue(true);
    }

    @Test
    public void validateRejectsInvalidStatus() throws Exception {
        Tag tag = new Tag();
        tag.setName("Java");
        tag.setStatus("deleted");
        try {
            tagService.validate(tag);
            fail("Expected ValidationException");
        } catch (ValidationException e) {
            assertTrue(e.getMessage().contains("Trạng thái tag sách không hợp lệ."));
        }
    }
}
