package controllers;

import dao.MemberProfileDAO;
import dao.LibraryManagerDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.MemberProfile;
import model.LibraryManager;
import model.User;
import service.ProfileService;

@WebServlet(name = "ManagerProfileServlet", urlPatterns = {"/manager/profile"})
public class ManagerProfileServlet extends HttpServlet {

    private final ProfileService profileService;
    private final UserDAO userDAO;
    private final MemberProfileDAO memberProfileDAO;
    private final LibraryManagerDAO libraryManagerDAO;

    public ManagerProfileServlet() {
        this.profileService = new ProfileService();
        this.userDAO = new UserDAO();
        this.memberProfileDAO = new MemberProfileDAO();
        this.libraryManagerDAO = new LibraryManagerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"MANAGER".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        User user = userDAO.findByUserId(userId);
        MemberProfile profile = memberProfileDAO.findByUserId(userId);
        LibraryManager manager = libraryManagerDAO.findByUserId(userId);

        request.setAttribute("user", user);
        request.setAttribute("profile", profile);
        request.setAttribute("manager", manager);

        request.getRequestDispatcher("/manager/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"MANAGER".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");

        if ("updateInfo".equals(action)) {
            String fullName = request.getParameter("fullName");
            String phoneNumber = request.getParameter("phoneNumber");
            String gender = request.getParameter("gender");
            String dateOfBirth = request.getParameter("dateOfBirth");

            try {
                profileService.updateUserInfo(userId, fullName, phoneNumber, gender, dateOfBirth);
                session.setAttribute("successMessage", "Cập nhật thông tin cá nhân thành công.");
            } catch (Exception e) {
                session.setAttribute("errorMessage", e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/manager/profile");

        } else if ("changePw".equals(action)) {
            String currentPw = request.getParameter("currentPw");
            String newPw = request.getParameter("newPw");
            String confirmPw = request.getParameter("confirmPw");

            try {
                profileService.changePassword(userId, currentPw, newPw, confirmPw);
                session.setAttribute("successMessage", "Đổi mật khẩu thành công. Vui lòng đăng nhập lại với mật khẩu mới.");
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login");
            } catch (Exception e) {
                session.setAttribute("errorMessage", e.getMessage());
                response.sendRedirect(request.getContextPath() + "/manager/profile");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/manager/profile");
        }
    }
}
