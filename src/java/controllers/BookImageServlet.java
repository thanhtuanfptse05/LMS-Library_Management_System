package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import util.BookImageStorage;

@WebServlet(name = "BookImageServlet", urlPatterns = {"/book-images/*"})
public class BookImageServlet extends HttpServlet {

    private final BookImageStorage imageStorage = new BookImageStorage();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String fileName = pathInfo == null ? null : pathInfo.substring(1);
        try {
            Path image = imageStorage.resolve(fileName);
            if (!Files.isRegularFile(image)) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            response.setContentType(Files.probeContentType(image));
            response.setHeader("Cache-Control", "public, max-age=86400");
            response.setContentLengthLong(Files.size(image));
            Files.copy(image, response.getOutputStream());
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
