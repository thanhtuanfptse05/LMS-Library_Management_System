package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Locale;

/**
 * LanguageServlet — Servlet xử lý thay đổi ngôn ngữ động (i18n).
 * Mapped tới URL: /change-language
 */
@WebServlet(name = "LanguageServlet", urlPatterns = {"/change-language"})
public class LanguageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String lang = request.getParameter("lang");
        
        if (lang != null && (lang.equalsIgnoreCase("en") || lang.equalsIgnoreCase("vi"))) {
            HttpSession session = request.getSession(true);
            String selectedLang = lang.toLowerCase();
            session.setAttribute("lang", selectedLang);
            
            // Cấu hình Locale cho JSTL Format tags (fmt:message)
            Locale locale = new Locale(selectedLang);
            jakarta.servlet.jsp.jstl.core.Config.set(
                session, 
                jakarta.servlet.jsp.jstl.core.Config.FMT_LOCALE, 
                locale
            );
        }
        
        // Quay trở lại trang cũ hoặc về trang chủ
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
