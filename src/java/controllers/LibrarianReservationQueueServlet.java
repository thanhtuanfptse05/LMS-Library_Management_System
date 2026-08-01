package controllers;

import dao.ReservationDAO;
import exception.DatabaseException;
import exception.ValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Reservation;
import service.OnlineCirculationService;
import util.DatabaseConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * LibrarianReservationQueueServlet — Controller xử lý hiển thị và quản lý hàng chờ đặt trước dành cho Thủ thư.
 * Phân quyền: LIBRARIAN hoặc ADMIN.
 *
 * <p>Traceability: SPEC.md (feat-reservationQueueManagement), PLAN.md.</p>
 */
@WebServlet(name = "LibrarianReservationQueueServlet", urlPatterns = {"/librarian/reservation-queue"})
public class LibrarianReservationQueueServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LibrarianReservationQueueServlet.class.getName());

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final OnlineCirculationService onlineCirculationService = new OnlineCirculationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorized(request, response)) return;

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        if (status == null || status.isBlank()) {
            status = "all";
        }
        if (sortBy == null || sortBy.isBlank()) {
            sortBy = "queuePosition";
        }
        if (sortOrder == null || sortOrder.isBlank()) {
            sortOrder = "ASC";
        }

        int page = 1;
        int pageSize = 10;
        String pageRaw = request.getParameter("page");
        if (pageRaw != null && !pageRaw.isBlank()) {
            try {
                page = Math.max(1, Integer.parseInt(pageRaw));
            } catch (NumberFormatException ignored) {
            }
        }
        int offset = (page - 1) * pageSize;

        try (Connection conn = DatabaseConnection.getConnection()) {
            List<Reservation> queueList = reservationDAO.findReservationQueueForLibrarian(conn, keyword, status, sortBy, sortOrder, offset, pageSize);
            int totalItems = reservationDAO.countReservationQueueForLibrarian(conn, keyword, status);
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);
            if (totalPages < 1) totalPages = 1;

            request.setAttribute("queueList", queueList);
            request.setAttribute("keyword", keyword != null ? keyword.trim() : "");
            request.setAttribute("status", status);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);

            request.getRequestDispatcher("/librarian/reservation-queue.jsp").forward(request, response);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách hàng chờ đặt trước cho Thủ thư", e);
            request.setAttribute("errorMessage", "Không thể tải danh sách hàng chờ đặt trước. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/librarian/reservation-queue.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorized(request, response)) return;

        HttpSession session = request.getSession(false);
        int librarianId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");

        if ("cancel".equalsIgnoreCase(action)) {
            String resIdRaw = request.getParameter("reservationId");
            String reason = request.getParameter("reason");

            if (resIdRaw == null || resIdRaw.isBlank()) {
                session.setAttribute("errorMessage", "Mã đơn đặt trước không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/librarian/reservation-queue");
                return;
            }

            if (reason == null || reason.isBlank()) {
                session.setAttribute("errorMessage", "Vui lòng nhập lý do hủy lượt đặt trước.");
                response.sendRedirect(request.getContextPath() + "/librarian/reservation-queue");
                return;
            }

            try {
                int reservationId = Integer.parseInt(resIdRaw);
                // Tái sử dụng 100% Service có sẵn cancelReservationByLibrarian
                onlineCirculationService.cancelReservationByLibrarian(librarianId, reservationId, reason);
                session.setAttribute("successMessage", "Đã hủy đơn đặt trước thành công và đôn vị trí hàng chờ cho người tiếp theo.");
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Mã đơn đặt trước phải là một số hợp lệ.");
            } catch (ValidationException e) {
                session.setAttribute("errorMessage", e.getMessage());
            } catch (DatabaseException e) {
                LOGGER.log(Level.SEVERE, "Lỗi hệ thống khi Thủ thư hủy lượt đặt trước", e);
                session.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống khi hủy lượt đặt trước.");
            }
        } else if ("reorder".equalsIgnoreCase(action)) {
            String resIdRaw = request.getParameter("reservationId");
            String newPosRaw = request.getParameter("newPosition");

            if (resIdRaw == null || resIdRaw.isBlank() || newPosRaw == null || newPosRaw.isBlank()) {
                session.setAttribute("errorMessage", "Thông tin đổi vị trí hàng chờ không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/librarian/reservation-queue");
                return;
            }

            try (Connection conn = DatabaseConnection.getConnection()) {
                conn.setAutoCommit(false);
                try {
                    int reservationId = Integer.parseInt(resIdRaw);
                    int newPosition = Integer.parseInt(newPosRaw);

                    Reservation r = reservationDAO.findReservationByIdForUpdate(conn, reservationId);
                    if (r == null) {
                        throw new ValidationException("Không tìm thấy đơn đặt trước #" + reservationId);
                    }
                    if (!"pending".equalsIgnoreCase(r.getStatus()) || r.getQueuePosition() == null || r.getQueuePosition() < 1) {
                        throw new ValidationException("Chỉ có thể thay đổi vị trí cho các đơn đặt trước đang chờ (pending).");
                    }

                    int oldPosition = r.getQueuePosition();
                    int maxPendingPos = reservationDAO.getMaxPendingQueuePositionForBook(conn, r.getBookId());

                    if (newPosition < 1 || newPosition > maxPendingPos) {
                        throw new ValidationException("Vị trí mới phải từ 1 đến " + maxPendingPos + ".");
                    }
                    if (newPosition == oldPosition) {
                        throw new ValidationException("Vị trí mới trùng với vị trí hiện tại (#" + oldPosition + ").");
                    }

                    reservationDAO.reorderQueuePosition(conn, r.getBookId(), reservationId, oldPosition, newPosition);

                    dao.AuditLogDAO auditLogDAO = new dao.AuditLogDAO();
                    auditLogDAO.insert(conn, librarianId, "REORDER_RESERVATION_BY_LIBRARIAN", "Reservation", reservationId,
                            "{\"queuePosition\":" + oldPosition + "}", "{\"queuePosition\":" + newPosition + "}");

                    conn.commit();
                    session.setAttribute("successMessage", "Đã đổi vị trí hàng chờ đơn #" + reservationId + " từ #" + oldPosition + " sang #" + newPosition + " thành công.");
                } catch (Exception e) {
                    conn.rollback();
                    throw e;
                } finally {
                    conn.setAutoCommit(true);
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Mã đơn đặt trước và vị trí mới phải là các số nguyên hợp lệ.");
            } catch (ValidationException e) {
                session.setAttribute("errorMessage", e.getMessage());
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Lỗi CSDL khi thay đổi vị trí hàng chờ đặt trước", e);
                session.setAttribute("errorMessage", "Không thể thay đổi vị trí hàng chờ do lỗi CSDL. Vui lòng thử lại sau.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/librarian/reservation-queue");
    }

    private boolean isAuthorized(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        String role = (String) session.getAttribute("role");
        if (!"LIBRARIAN".equalsIgnoreCase(role) && !"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
