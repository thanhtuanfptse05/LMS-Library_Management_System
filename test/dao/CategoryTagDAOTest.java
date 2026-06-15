package dao;

import java.sql.Connection;
import model.Category;
import dto.ManagementSummaryDTO;
import model.Tag;
import org.junit.Test;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import util.DatabaseConnection;

public class CategoryTagDAOTest {

    @Test
    public void insertAndFindCategoryAndTag() throws Exception {
        CategoryDAO categoryDAO = new CategoryDAO();
        TagDAO tagDAO = new TagDAO();
        String suffix = String.valueOf(System.nanoTime());

        Category category = new Category();
        category.setName("Thể loại kiểm thử " + suffix);
        category.setDescription("Dữ liệu kiểm thử");
        category.setStatus("active");

        Tag tag = new Tag();
        tag.setName("Tag " + suffix.substring(Math.max(0, suffix.length() - 12)));
        tag.setStatus("active");

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Category savedCategory = categoryDAO.findById(conn, categoryDAO.insert(conn, category, 16));
                Tag savedTag = tagDAO.findById(conn, tagDAO.insert(conn, tag, 16));
                assertNotNull(savedCategory);
                assertNotNull(savedTag);
                assertEquals("active", savedCategory.getStatus());
                assertEquals("active", savedTag.getStatus());
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    @Test
    public void loadCategoryAndTagSummaries() throws Exception {
        ManagementSummaryDTO categorySummary = new CategoryDAO().getSummary();
        ManagementSummaryDTO tagSummary = new TagDAO().getSummary();

        assertNotNull(categorySummary);
        assertNotNull(tagSummary);
        assertTrue(categorySummary.getTotalCount() >= categorySummary.getActiveCount());
        assertTrue(categorySummary.getTotalCount() >= categorySummary.getHiddenCount());
        assertTrue(categorySummary.getTotalCount() >= categorySummary.getUnusedCount());
        assertTrue(tagSummary.getTotalCount() >= tagSummary.getActiveCount());
        assertTrue(tagSummary.getTotalCount() >= tagSummary.getHiddenCount());
        assertTrue(tagSummary.getTotalCount() >= tagSummary.getUnusedCount());
    }
}
