package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * HomeServlet — Controller for the home/landing page.
 *
 * Handles GET requests to "/" and "/home".
 * In the future, this servlet will load dynamic data from DAOs
 * (e.g., news articles, stats, categories) and set them as
 * request attributes before forwarding to home.jsp.
 *
 * @author Smart LMS Team
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    /**
     * Handles HTTP GET requests for the home page.
     *
     * @param request  the HttpServletRequest object
     * @param response the HttpServletResponse object
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Future: Load dynamic data from DAO layer
        // Example:
        //   List<News> newsList = newsDAO.getLatestNews(3);
        //   request.setAttribute("newsList", newsList);
        //
        //   Map<String, Integer> stats = statsDAO.getHomeStats();
        //   request.setAttribute("stats", stats);
        //
        //   List<Category> categories = categoryDAO.getAllCategories();
        //   request.setAttribute("categories", categories);

        request.getRequestDispatcher("/WEB-INF/views/guest/home.jsp").forward(request, response);
    }
}
