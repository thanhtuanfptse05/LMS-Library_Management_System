package controllers;

import dao.NotificationDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Notification;

/**
 * Servlet API for rendering the Notification Bell Widget.
 * Fetches the recent notifications and unread count, then includes the JSP fragment.
 */
@WebServlet(name = "NotificationWidgetServlet", urlPatterns = {"/components/notification-bell"})
public class NotificationWidgetServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            int userId = (Integer) session.getAttribute("userId");
            NotificationDAO notificationDAO = new NotificationDAO();
            
            // Get unread count
            int unreadCount = notificationDAO.countUnread(userId);
            request.setAttribute("unreadNotificationCount", unreadCount);
            
            // Get 5 most recent notifications
            List<Notification> recentNotifications = notificationDAO.getAllForUser(userId, null, null, 1, 5);
            request.setAttribute("recentNotifications", recentNotifications);
        }
        
        // Include the actual HTML fragment
        request.getRequestDispatcher("/common/fragments/_notification_bell.jsp").include(request, response);
    }
}
