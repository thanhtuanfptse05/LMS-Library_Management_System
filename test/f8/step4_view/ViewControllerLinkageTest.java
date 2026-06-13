package f8.step4_view;

import org.junit.Test;
import static org.junit.Assert.*;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import controllers.BookSearchServlet;
import controllers.BookDetailServlet;
import controllers.RecommendationServlet;
import jakarta.servlet.annotation.WebServlet;

/**
 * ViewControllerLinkageTest
 * 
 * Kiểm thử việc liên kết (Linkage) giữa Tầng View (JSP) và Tầng Controller (Servlet).
 * Trong môi trường nội bộ không có framework như Mockito hay Selenium,
 * chúng ta sử dụng Reflection và Static Code Analysis để đảm bảo rằng:
 * 1. Controller được map đúng URL.
 * 2. Controller forward request về đúng trang JSP mong muốn.
 */
public class ViewControllerLinkageTest {

    @Test
    public void testBookSearchLinkage() throws Exception {
        // 1. Kiểm tra Annotation Controller (Routing)
        WebServlet annotation = BookSearchServlet.class.getAnnotation(WebServlet.class);
        assertNotNull("BookSearchServlet phải có @WebServlet annotation", annotation);
        assertEquals("URL pattern phải trỏ tới /book-search", "/book-search", annotation.urlPatterns()[0]);
        
        // 2. Kiểm tra Linkage tới View (JSP) qua Static Analysis
        File sourceFile = new File("src/java/controllers/BookSearchServlet.java");
        if (sourceFile.exists()) {
            String content = new String(Files.readAllBytes(Paths.get(sourceFile.getAbsolutePath())));
            assertTrue("BookSearchServlet phải liên kết tới view /book-search.jsp", 
                content.contains("getRequestDispatcher(\"/book-search.jsp\")"));
        } else {
            fail("Không tìm thấy mã nguồn BookSearchServlet để kiểm tra Linkage");
        }
    }
    
    @Test
    public void testBookDetailLinkage() throws Exception {
        WebServlet annotation = BookDetailServlet.class.getAnnotation(WebServlet.class);
        assertNotNull("BookDetailServlet phải có @WebServlet annotation", annotation);
        assertEquals("URL pattern phải trỏ tới /book-detail", "/book-detail", annotation.urlPatterns()[0]);
        
        File sourceFile = new File("src/java/controllers/BookDetailServlet.java");
        if (sourceFile.exists()) {
            String content = new String(Files.readAllBytes(Paths.get(sourceFile.getAbsolutePath())));
            assertTrue("BookDetailServlet phải liên kết tới view /book-detail.jsp", 
                content.contains("getRequestDispatcher(\"/book-detail.jsp\")"));
        } else {
            fail("Không tìm thấy mã nguồn BookDetailServlet để kiểm tra Linkage");
        }
    }

    @Test
    public void testRecommendationFragmentLinkage() throws Exception {
        WebServlet annotation = RecommendationServlet.class.getAnnotation(WebServlet.class);
        assertNotNull("RecommendationServlet phải có @WebServlet annotation", annotation);
        assertEquals("URL pattern phải trỏ tới /recommendation", "/recommendation", annotation.urlPatterns()[0]);
        
        File sourceFile = new File("src/java/controllers/RecommendationServlet.java");
        if (sourceFile.exists()) {
            String content = new String(Files.readAllBytes(Paths.get(sourceFile.getAbsolutePath())));
            assertTrue("RecommendationServlet phải liên kết tới JSP Fragment /common/_recommendation.jsp", 
                content.contains("getRequestDispatcher(\"/common/_recommendation.jsp\")"));
        } else {
            fail("Không tìm thấy mã nguồn RecommendationServlet để kiểm tra Linkage");
        }
    }
}
