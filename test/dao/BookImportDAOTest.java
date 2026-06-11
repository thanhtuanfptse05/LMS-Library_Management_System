package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import model.BookImportBatch;
import model.BookImportError;
import model.Book;
import model.BookCopy;
import model.Category;
import model.Tag;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import util.DatabaseConnection;

public class BookImportDAOTest {

    @Test
    public void importTransactionCreatesRelationsCopiesAndInventoryTogether() throws Exception {
        BookDAO bookDAO = new BookDAO();
        BookCopyDAO copyDAO = new BookCopyDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        TagDAO tagDAO = new TagDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int actorId = findUserId(conn);
                String suffix = String.valueOf(System.nanoTime());
                Category category = new Category();
                category.setName("Thể loại import " + suffix);
                category.setStatus("active");
                int categoryId = categoryDAO.insert(conn, category, actorId);
                Tag tag = new Tag();
                tag.setName(("Tag " + suffix).substring(0, Math.min(100, ("Tag " + suffix).length())));
                tag.setStatus("active");
                int tagId = tagDAO.insert(conn, tag, actorId);
                Book book = new Book();
                book.setIsbn(("IMP" + suffix).substring(0, Math.min(20, ("IMP" + suffix).length())));
                book.setTitle("Đầu sách kiểm thử import");
                book.setStatus("available");
                int bookId = bookDAO.insert(conn, book);
                bookDAO.replaceCategories(conn, bookId, new int[]{categoryId});
                bookDAO.replaceTags(conn, bookId, new int[]{tagId});
                BookCopy copy = new BookCopy();
                copy.setBookId(bookId);
                copy.setBarcode(("BC-" + suffix).substring(0, Math.min(50, ("BC-" + suffix).length())));
                copy.setLocation("Kho kiểm thử import");
                copyDAO.insert(conn, copy);
                bookDAO.updateQuantities(conn, bookId, 1, 1);
                Book saved = bookDAO.findById(conn, bookId);
                assertEquals(1, saved.getTotalQuantity());
                assertEquals(1, saved.getAvailableQuantity());
                assertEquals(1, saved.getCategories().size());
                assertEquals(1, saved.getTags().size());
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    @Test
    public void insertsFailedBatchAndErrorsInsideTransaction() throws Exception {
        BookImportDAO dao = new BookImportDAO();
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                BookImportBatch batch = new BookImportBatch();
                batch.setImportedBy(findUserId(conn));
                batch.setFileName("kiem-thu.xlsx");
                batch.setTotalRows(1);
                batch.setSuccessRows(0);
                batch.setFailedRows(1);
                batch.setStatus("failed");
                int batchId = dao.insertBatch(conn, batch);
                dao.insertErrors(conn, batchId,
                        List.of(new BookImportError("Books", 2, "isbn", "ISBN không hợp lệ.")));
                assertTrue(batchId > 0);
                assertEquals(1, countErrors(conn, batchId));
            } finally {
                conn.rollback();
                conn.setAutoCommit(true);
            }
        }
    }

    private int findUserId(Connection conn) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement("SELECT TOP 1 userId FROM [User] ORDER BY userId");
             ResultSet rs = ps.executeQuery()) {
            assertTrue(rs.next());
            return rs.getInt(1);
        }
    }

    private int countErrors(Connection conn, int batchId) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM BookImportError WHERE importBatchId = ?")) {
            ps.setInt(1, batchId);
            try (ResultSet rs = ps.executeQuery()) {
                assertTrue(rs.next());
                return rs.getInt(1);
            }
        }
    }
}
