package controllers;

import dao.UserDAO;
import dao.MemberProfileDAO;
import dao.UserLookupDAO;
import dao.ReservationDAO;
import dao.BorrowRecordDAO;
import dao.FineDAO;
import dao.UserLockReasonDAO;
import dao.BookCopyDAO;
import model.User;
import model.MemberProfile;
import model.Reservation;
import model.BorrowRecord;
import model.Fine;
import util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DeskDashboardServlet — Hub điều phối tra cứu độc giả và quản lý 3 danh sách giao dịch tại quầy.
 * Phân quyền cứng chỉ dành cho role LIBRARIAN.
 */
@WebServlet(name = "DeskDashboardServlet", urlPatterns = {"/librarian/desk-dashboard"})
public class DeskDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DeskDashboardServlet.class.getName());
    private static final String VIEW_PATH = "/librarian/desk-dashboard.jsp";

    private final UserDAO userDAO;
    private final MemberProfileDAO memberProfileDAO;
    private final UserLookupDAO userLookupDAO;
    private final ReservationDAO reservationDAO;
    private final BorrowRecordDAO borrowRecordDAO;
    private final FineDAO fineDAO;
    private final UserLockReasonDAO userLockReasonDAO;
    private final BookCopyDAO bookCopyDAO;

    public DeskDashboardServlet() {
        this.userDAO = new UserDAO();
        this.memberProfileDAO = new MemberProfileDAO();
        this.userLookupDAO = new UserLookupDAO();
        this.reservationDAO = new ReservationDAO();
        this.borrowRecordDAO = new BorrowRecordDAO();
        this.fineDAO = new FineDAO();
        this.userLockReasonDAO = new UserLockReasonDAO();
        this.bookCopyDAO = new BookCopyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAuthorized(request, response)) return;

        String memberCodeRaw = request.getParameter("memberCode");
        if (memberCodeRaw != null && !memberCodeRaw.isBlank()) {
            String memberCode = memberCodeRaw.trim();
            request.setAttribute("memberCode", memberCode);

            try (Connection conn = DatabaseConnection.getConnection()) {
                // Bước 1: Ánh xạ memberCode sang userId
                Integer userId = userLookupDAO.findUserIdByMemberCode(conn, memberCode);

                if (userId != null) {
                    // Bước 2: Tải thông tin tài khoản và hồ sơ
                    User user = userDAO.findByUserId(userId);
                    MemberProfile profile = memberProfileDAO.findByUserId(userId);

                    // Bước 3: Tải các lý do khóa và 3 danh sách giao dịch
                    List<String> lockReasons = userLockReasonDAO.getReasonsByUserId(conn, userId);
                    List<String> friendlyReasons = new java.util.ArrayList<>();
                    for (String r : lockReasons) {
                        if ("unpaid".equalsIgnoreCase(r)) {
                            friendlyReasons.add("Nợ phạt quá hạn / Chưa thanh toán");
                        } else if ("securitybreach".equalsIgnoreCase(r)) {
                            friendlyReasons.add("Khóa tạm thời do đăng nhập sai nhiều lần");
                        } else if ("adminban".equalsIgnoreCase(r)) {
                            friendlyReasons.add("Bị quản trị viên khóa");
                        } else {
                            friendlyReasons.add(r);
                        }
                    }
                    String lockReasonsStr = String.join(", ", friendlyReasons);

                    List<Reservation> readyReservations = reservationDAO.findReadyPickupByUserId(conn, userId);
                    List<BorrowRecord> activeBorrows = borrowRecordDAO.findActiveBorrowRecordsByUserId(conn, userId);
                    List<Fine> unpaidFines = fineDAO.findUnpaidFinesByUserId(conn, userId);
                    
                    // Fetch paid fines (status = 'paid')
                    List<Fine> allFines = fineDAO.findFinesByUserId(conn, userId);
                    List<Fine> paidFines = new java.util.ArrayList<>();
                    for (Fine f : allFines) {
                        if ("paid".equals(f.getStatus())) {
                            paidFines.add(f);
                        }
                    }

                    // Ánh xạ bookCopyId -> barcode cho các sách đang mượn và đặt trước
                    List<Integer> copyIds = new java.util.ArrayList<>();
                    for (BorrowRecord br : activeBorrows) {
                        copyIds.add(br.getBookCopyId());
                    }
                    for (Reservation res : readyReservations) {
                        if (res.getBookCopyId() != null) {
                            copyIds.add(res.getBookCopyId());
                        }
                    }
                    java.util.Map<Integer, String> copyBarcodeMap = bookCopyDAO.findBarcodesForCopyIds(conn, copyIds);

                    // Bước 4: Đẩy dữ liệu ra Request Attributes
                    request.setAttribute("searchedUser", user);
                    request.setAttribute("searchedUserLockReasons", lockReasonsStr);
                    request.setAttribute("searchedProfile", profile);
                    request.setAttribute("readyReservations", readyReservations);
                    request.setAttribute("activeBorrows", activeBorrows);
                    request.setAttribute("copyBarcodeMap", copyBarcodeMap);
                    request.setAttribute("unpaidFines", unpaidFines);
                    request.setAttribute("paidFines", paidFines);
                } else {
                    request.setAttribute("errorMessage", "Không tìm thấy độc giả có mã số: " + memberCode);
                }

            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Lỗi SQL khi tra cứu độc giả: " + memberCode, e);
                request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống khi tra cứu dữ liệu độc giả.");
            }
        }

        // Đọc thông tin thông báo flash nếu có từ session (như thông báo mượn/trả thành công)
        HttpSession session = request.getSession(false);
        if (session != null) {
            String successMsg = (String) session.getAttribute("successMessage");
            if (successMsg != null) {
                request.setAttribute("successMessage", successMsg);
                session.removeAttribute("successMessage");
            }
            String errorMsg = (String) session.getAttribute("errorMessage");
            if (errorMsg != null) {
                request.setAttribute("errorMessage", errorMsg);
                session.removeAttribute("errorMessage");
            }
        }

        request.getRequestDispatcher(VIEW_PATH).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET và POST đều map chung hoặc redirect về GET
        doGet(request, response);
    }

    private boolean isAuthorized(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null
                || session.getAttribute("userId") == null
                || !"LIBRARIAN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
