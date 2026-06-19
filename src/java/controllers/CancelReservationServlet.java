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
 * CancelReservationServlet — Xử lý hủy đặt trước sách của Student và Lecturer.
 */
@WebServlet(name = "CancelReservationServlet", urlPatterns = {"/student/cancel-reservation", "/lecturer/cancel-reservation"})
public class CancelReservationServlet extends HttpServlet {

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

        String reservationIdStr = request.getParameter("reservationId");
        int reservationId = 0;
        try {
            if (reservationIdStr != null) {
                reservationId = Integer.parseInt(reservationIdStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        if (reservationId <= 0) {
            session.setAttribute("errorMessage", "Mã đơn đặt trước không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/" + role.toLowerCase() + "/my-borrowings");
            return;
        }

        try {
            circulationService.cancelReservation(userId, reservationId);
            session.setAttribute("successMessage", "Hủy đặt trước sách thành công!");
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
