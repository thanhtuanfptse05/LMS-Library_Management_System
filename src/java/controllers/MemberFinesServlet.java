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
 * MemberFinesServlet — Controller hiển thị danh sách khoản phạt và tạo mã QR thanh toán online (SePay).
 *
 * <p>Dành cho các vai trò độc giả: Student (Sinh viên) và Lecturer (Giảng viên).</p>
 * <p>Route: {@code /student/fines} và {@code /lecturer/fines}</p>
 *
 * <p><b>Quy tắc quan trọng (Nghiệp vụ mượn/trả):</b></p>
 * <ul>
 *   <li>Khoản phạt trễ hạn CHỈ cho phép thanh toán QR trực tuyến khi độc giả <b>ĐÃ TRẢ SÁCH VẬT LÝ</b> tại quầy
 *       (BorrowRecord.status thuộc: 'returned', 'lost', 'damaged').</li>
 *   <li>Nếu độc giả chưa trả sách (status='overdue'): Đặt {@code canPayOnline = false}. Trang JSP sẽ ẩn nút QR
 *       và hiển thị cảnh báo yêu cầu mang sách đến trả tại quầy thư viện trước.</li>
 * </ul>
 */
@WebServlet(name = "MemberFinesServlet", urlPatterns = {"/student/fines", "/lecturer/fines"})
public class MemberFinesServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(MemberFinesServlet.class.getName());

    // Các lớp DAO hỗ trợ truy vấn thông tin Phạt, Thanh toán, Cấu hình và Phiếu mượn
    private final FineDAO fineDAO = new FineDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final SystemConfigDAO systemConfigDAO = new SystemConfigDAO();
    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Bước 1: Kiểm tra Session và Xác thực quyền truy cập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String role = ((String) session.getAttribute("role")).toLowerCase();

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false); // Bắt đầu Transaction đọc và khởi tạo Payment nếu cần
            try {
                // Bước 2: Lấy danh sách tất cả khoản phạt của độc giả (gồm cả 'unpaid' và 'paid') kèm tiêu đề sách
                List<Fine> fines = fineDAO.findFinesByUserId(conn, userId);

                // Bước 3: Duyệt danh sách các khoản phạt CHƯA THANH TOÁN ('unpaid') để xử lý logic tạo Payment QR
                for (Fine fine : fines) {
                    if (!"unpaid".equals(fine.getStatus())) continue;

                    // Kiểm tra xem sách mượn đã được trả vật lý hay chưa
                    int brId = fine.getBorrowRecordId();
                    boolean canPayOnline = true;
                    if (brId > 0) {
                        String brStatus = borrowRecordDAO.findStatusById(conn, brId);
                        // Chỉ cho phép thanh toán online nếu sách ở 1 trong 3 trạng thái đã kết thúc
                        canPayOnline = "returned".equals(brStatus)
                                    || "lost".equals(brStatus)
                                    || "damaged".equals(brStatus);
                    }
                    fine.setCanPayOnline(canPayOnline); // Truyền flag này sang giao diện JSP

                    // NẾU sách đã được trả VÀ khoản phạt chưa có Payment ID -> Tạo Payment ở trạng thái 'pending'
                    if (canPayOnline && fine.getPaymentId() == null) {
                        int newPaymentId = paymentDAO.insertPayment(conn, fine.getFineId(),
                                fine.getAmount(), "pending");
                        fine.setPaymentId(newPaymentId);
                        LOGGER.log(Level.INFO,
                                "Tạo Payment pending mới: paymentId={0} cho fineId={1}, userId={2}",
                                new Object[]{newPaymentId, fine.getFineId(), userId});
                    }
                    // Trường hợp !canPayOnline: Không tạo Payment, fine.paymentId = null
                    // -> JSP sẽ nhận biết fine.canPayOnline = false để ẩn nút QR và nhắc "Trả sách trước"
                }
                conn.commit(); // Hoàn tất Transaction khởi tạo Payment

                request.setAttribute("fines", fines);

                // Bước 4: Tính tổng số tiền phạt chưa thanh toán (để hiển thị trên thẻ tổng nợ)
                BigDecimal totalUnpaid = fineDAO.getTotalUnpaidFinesByUser(conn, userId);
                request.setAttribute("totalUnpaid", totalUnpaid);

                // Bước 5: Đếm tổng số khoản phạt còn nợ
                long unpaidCount = fines.stream().filter(f -> "unpaid".equals(f.getStatus())).count();
                request.setAttribute("unpaidCount", unpaidCount);

                // Bước 6: Lấy cấu hình tài khoản SePay để render mã VietQR tự động trên giao diện
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

        // Bước 7: Điều hướng người dùng đến đúng trang JSP tương ứng theo vai trò (Student hoặc Lecturer)
        String jspPath = "/" + role + "/fines.jsp";
        request.getRequestDispatcher(jspPath).forward(request, response);
    }
}

