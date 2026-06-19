package controllers;

import exception.DatabaseException;
import exception.ValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import service.OnlineCirculationService;

/**
 * RenewalServlet — Xử lý gia hạn mượn sách trực tuyến của Student và Lecturer.
 */
@WebServlet(name = "RenewalServlet", urlPatterns = {"/student/renew", "/lecturer/renew"})
public class RenewalServlet extends HttpServlet {

    private final OnlineCirculationService circulationService = new OnlineCirculationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        String borrowRecordIdStr = request.getParameter("borrowRecordId");
        int borrowRecordId = 0;
        try {
            if (borrowRecordIdStr != null) {
                borrowRecordId = Integer.parseInt(borrowRecordIdStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        if (borrowRecordId <= 0) {
            session.setAttribute("errorMessage", "Mã lượt mượn sách không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/" + role.toLowerCase() + "/my-borrowings");
            return;
        }

        try {
            circulationService.renewBook(userId, borrowRecordId);
            session.setAttribute("successMessage", "Gia hạn mượn sách thành công!");
        } catch (ValidationException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (DatabaseException e) {
            session.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/" + role.toLowerCase() + "/my-borrowings");
    }
}
