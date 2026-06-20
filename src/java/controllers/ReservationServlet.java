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
 * ReservationServlet — Xử lý yêu cầu đặt trước sách trực tuyến của Student và Lecturer.
 */
@WebServlet(name = "ReservationServlet", urlPatterns = {"/student/reserve", "/lecturer/reserve"})
public class ReservationServlet extends HttpServlet {

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

        String bookIdStr = request.getParameter("bookId");
        int bookId = 0;
        try {
            if (bookIdStr != null) {
                bookId = Integer.parseInt(bookIdStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        if (bookId <= 0) {
            session.setAttribute("errorMessage", "Mã sách không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/" + role.toLowerCase() + "/dashboard");
            return;
        }

        try {
            circulationService.reserveBook(userId, bookId, role);
            session.setAttribute("successMessage", "Đặt trước sách thành công!");
        } catch (ValidationException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (DatabaseException e) {
            session.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/book-detail?id=" + bookId);
    }
}
