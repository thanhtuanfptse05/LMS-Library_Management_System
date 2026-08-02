package controllers;

import dao.BorrowRecordDAO;
import dao.FineDAO;
import dao.PaymentDAO;
import dao.SystemConfigDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Fine;
import util.DatabaseConnection;

/**
 * MemberFinesServlet — Hiển thị danh sách phạt và thông tin thanh toán QR
 * cho cả Student và Lecturer.
 *
 * <p>Route: {@code /student/fines} và {@code /lecturer/fines}</p>
 * <p>Lấy danh sách phạt từ FineDAO, tổng tiền nợ chưa thanh toán,
 * và cấu hình SePay (số tài khoản, ngân hàng, tên chủ TK) để sinh VietQR
 * động trên giao diện.</p>
 *
 * <p><strong>[BUG-FIX]</strong> Chỉ tạo Payment pending (QR) cho fine quá hạn
 * nếu BorrowRecord đã ở trạng thái {@code returned/lost/damaged}.
 * Nếu sách chưa trả, đánh dấu {@code fine.canPayOnline = false} để JSP
 * ẩn nút QR và hướng dẫn sinh viên trả sách tại quầy trước.</p>
 */
@WebServlet(name = "MemberFinesServlet", urlPatterns = {"/student/fines", "/lecturer/fines"})
public class MemberFinesServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(MemberFinesServlet.class.getName());

    private final FineDAO fineDAO = new FineDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final SystemConfigDAO systemConfigDAO = new SystemConfigDAO();
    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String role = ((String) session.getAttribute("role")).toLowerCase();

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Lấy danh sách phạt (cả paid và unpaid) kèm tên sách
                List<Fine> fines = fineDAO.findFinesByUserId(conn, userId);

                // 2. Tự động tạo Payment 'pending' cho Fine 'unpaid' chưa có paymentId
                //    [BUG-FIX] CHỈ tạo QR nếu sách đã được trả vật lý (returned/lost/damaged).
                //    Nếu sách chưa trả: đánh dấu canPayOnline=false, JSP sẽ ẩn nút QR.
                for (Fine fine : fines) {
                    if (!"unpaid".equals(fine.getStatus())) continue;

                    // Kiểm tra sách đã trả chưa (whitelist approach)
                    int brId = fine.getBorrowRecordId();
                    boolean canPayOnline = true;
                    if (brId > 0) {
                        String brStatus = borrowRecordDAO.findStatusById(conn, brId);
                        canPayOnline = "returned".equals(brStatus)
                                    || "lost".equals(brStatus)
                                    || "damaged".equals(brStatus);
                    }
                    fine.setCanPayOnline(canPayOnline);

                    if (canPayOnline && fine.getPaymentId() == null) {
                        // Sách đã trả → tạo Payment QR bình thường
                        int newPaymentId = paymentDAO.insertPayment(conn, fine.getFineId(),
                                fine.getAmount(), "pending");
                        fine.setPaymentId(newPaymentId);
                        LOGGER.log(Level.INFO,
                                "Tạo Payment pending mới: paymentId={0} cho fineId={1}, userId={2}",
                                new Object[]{newPaymentId, fine.getFineId(), userId});
                    }
                    // Nếu !canPayOnline: không tạo Payment, fine.paymentId = null
                    // → JSP sẽ hiển thị hướng dẫn "Trả sách tại quầy trước"
                }
                conn.commit();

                request.setAttribute("fines", fines);

                // 3. Tính tổng tiền phạt chưa thanh toán
                BigDecimal totalUnpaid = fineDAO.getTotalUnpaidFinesByUser(conn, userId);
                request.setAttribute("totalUnpaid", totalUnpaid);

                // 4. Đếm số khoản phạt unpaid
                long unpaidCount = fines.stream().filter(f -> "unpaid".equals(f.getStatus())).count();
                request.setAttribute("unpaidCount", unpaidCount);

                // 5. Lấy cấu hình SePay để sinh VietQR
                String sepayAccountNumber = systemConfigDAO.getValue(conn, "SEPAY_ACCOUNT_NUMBER", "");
                String sepayBankCode = systemConfigDAO.getValue(conn, "SEPAY_BANK_CODE", "BIDV");
                String sepayAccountName = systemConfigDAO.getValue(conn, "SEPAY_ACCOUNT_NAME", "");

                request.setAttribute("sepayAccountNumber", sepayAccountNumber);
                request.setAttribute("sepayBankCode", sepayBankCode);
                request.setAttribute("sepayAccountName", sepayAccountName);

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách phạt cho userId=" + userId, e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống khi tải dữ liệu. Vui lòng thử lại sau.");
        }

        // Forward tới JSP tương ứng theo vai trò
        String jspPath = "/" + role + "/fines.jsp";
        request.getRequestDispatcher(jspPath).forward(request, response);
    }
}
