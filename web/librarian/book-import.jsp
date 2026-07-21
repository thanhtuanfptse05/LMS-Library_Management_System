<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Trang: book-import.jsp - Nhập dữ liệu sách hàng loạt từ file Excel --%>
<%-- Cho phép Thủ thư upload file Excel mẫu chứa thông tin đầu sách và bản sao --%>
<%-- Thực hiện kiểm tra lỗi định dạng, dữ liệu trùng lặp trước khi lưu chính thức --%>

<!DOCTYPE html>
<html lang="vi">
    <jsp:include page="fragments/_head.jsp" />
    <body class="d-flex flex-column">
        <jsp:include page="fragments/_sidebar.jsp" />
        <div class="d-flex main-wrapper overflow-hidden">
            <main class="flex-grow-1 overflow-y-auto main-content-layout">
                <jsp:include page="fragments/_header.jsp" />
                <div class="container-fluid px-4 py-4 bm-page">
                    <%-- Thông báo kết quả thao tác --%>
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success alert-dismissible fade show">
                            <c:out value="${sessionScope.successMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                        </div>
                        <c:remove var="successMessage" scope="session" />
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            <c:out value="${sessionScope.errorMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                        </div>
                        <c:remove var="errorMessage" scope="session" />
                    </c:if>

                    <%-- Tiêu đề và nút Tải tệp mẫu Excel chuẩn --%>
                    <section class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
                        <div>
                            <p class="bm-page__eyebrow mb-1">Nhập dữ liệu &amp; lịch sử</p>
                            <h2 class="bm-page__title mb-1">Nhập dữ liệu sách</h2>
                            <p class="bm-page__subtitle mb-0">Tạo hàng loạt đầu sách và bản sao từ tệp Excel theo mẫu chuẩn.</p>
                        </div>
                        <a class="btn bm-btn-secondary" href="${pageContext.request.contextPath}/librarian/book-management/import?action=template">
                            <span class="material-symbols-outlined">download</span>Tải tệp mẫu
                        </a>
                    </section>

                    <div class="row g-3">
                        <%-- Cột bên trái: Drag-and-drop upload file và Bảng xem trước dữ liệu/lỗi --%>
                        <section class="col-xl-8">
                            <%-- Biểu mẫu gửi file Excel lên Server để thực hiện bước Validation --%>
                            <div class="bm-side-card mb-3">
                                <form class="bm-import-dropzone" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/librarian/book-management/import">
                                    <input type="hidden" name="action" value="upload">
                                    <span class="material-symbols-outlined bm-import-dropzone__icon">upload_file</span>
                                    <h3 class="bm-section-title mt-3 mb-1">Chọn tệp Excel để kiểm tra</h3>
                                    <p class="bm-section-note mb-3">Chỉ nhận tệp .xlsx, tối đa 5.000 bản sao và 10 MB.</p>
                                    <input class="form-control mb-3" id="importFile" name="importFile" type="file" accept=".xlsx" required>
                                    <button class="btn btn-primary-custom" type="submit">Kiểm tra tệp</button>
                                </form>
                            </div>

                            <%-- Khối xem trước kết quả sau khi upload file thành công --%>
                            <c:if test="${not empty preview}">
                                <%-- 1. Bảng liệt kê chi tiết các lỗi dữ liệu (nếu có) trên từng dòng/cột của các sheet --%>
                                <section class="bm-table-card bm-table-card--primary mb-3">
                                    <div class="bm-table-card__header d-flex flex-wrap justify-content-between gap-2">
                                        <div>
                                            <h3 class="bm-section-title mb-1">Kết quả kiểm tra</h3>
                                            <p class="bm-section-note mb-0">
                                                <c:out value="${preview.fileName}" /> · ${preview.books.size()} đầu sách · ${preview.bookCopies.size()} bản sao
                                            </p>
                                        </div>
                                        <c:choose>
                                            <c:when test="${preview.valid}">
                                                <span class="bm-badge bm-badge--success">Tệp hợp lệ</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="bm-badge bm-badge--danger">${preview.errors.size()} lỗi cần sửa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-lms">
                                            <thead>
                                                <tr>
                                                    <th>Trang tính</th>
                                                    <th>Dòng</th>
                                                    <th>Cột</th>
                                                    <th>Kết quả kiểm tra</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="error" items="${preview.errors}">
                                                    <tr>
                                                        <td><strong><c:out value="${error.sheetName}" /></strong></td>
                                                        <td>${error.rowNumber}</td>
                                                        <td><c:out value="${empty error.columnName ? 'Cấu trúc' : error.columnName}" /></td>
                                                        <td class="bm-text-danger"><c:out value="${error.errorMessage}" /></td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${preview.valid}">
                                                    <tr>
                                                        <td colspan="4">
                                                            <div class="bm-empty-state">
                                                                <span class="material-symbols-outlined">verified</span>
                                                                <strong>Không phát hiện lỗi</strong>
                                                                <span>Dữ liệu sẵn sàng để nhập theo nguyên tắc toàn bộ hoặc không.</span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </section>

                                <%-- 2. Bảng xem trước 10 dòng đầu tiên của sheet Bản sao để người dùng kiểm đối --%>
                                <section class="bm-table-card bm-table-card--primary">
                                    <div class="bm-table-card__header">
                                        <h3 class="bm-section-title mb-1">Xem trước bản sao</h3>
                                        <p class="bm-section-note mb-0">Hiển thị tối đa 10 dòng đầu tiên trong trang tính Bản sao sách.</p>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-lms">
                                            <thead>
                                                <tr>
                                                    <th>Dòng</th>
                                                    <th>ISBN</th>
                                                    <th>Mã vạch</th>
                                                    <th>Vị trí</th>
                                                    <th>Khởi tạo</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="row" items="${preview.bookCopies}" varStatus="loop">
                                                    <c:if test="${loop.index < 10}">
                                                        <tr>
                                                            <td>${row.rowNumber}</td>
                                                            <td><c:out value="${row.isbn}" /></td>
                                                            <td><strong><c:out value="${row.barcode}" /></strong></td>
                                                            <td><c:out value="${row.location}" /></td>
                                                            <td><span class="bm-badge bm-badge--success">Tốt · Sẵn sàng</span></td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </section>
                            </c:if>
                        </section>

                        <%-- Cột bên phải: Hướng dẫn quy trình nhập và các nút hành động xác nhận lưu chính thức --%>
                        <aside class="col-xl-4">
                            <%-- Các bước thực hiện --%>
                            <div class="bm-side-card mb-3">
                                <h3 class="bm-section-title mb-3">Quy trình nhập dữ liệu</h3>
                                <div class="bm-step mb-3">
                                    <span class="bm-step__number">1</span>
                                    <div>
                                        <strong>Tải tệp mẫu</strong>
                                        <p class="bm-section-note mb-0">Giữ nguyên trang tính và thứ tự cột.</p>
                                    </div>
                                </div>
                                <div class="bm-step mb-3">
                                    <span class="bm-step__number">2</span>
                                    <div>
                                        <strong>Kiểm tra tệp</strong>
                                        <p class="bm-section-note mb-0">Hệ thống đọc và hiển thị toàn bộ lỗi.</p>
                                    </div>
                                </div>
                                <div class="bm-step mb-3">
                                    <span class="bm-step__number">3</span>
                                    <div>
                                        <strong>Sửa toàn bộ lỗi</strong>
                                        <p class="bm-section-note mb-0">Không thể xác nhận khi còn dòng lỗi.</p>
                                    </div>
                                </div>
                                <div class="bm-step">
                                    <span class="bm-step__number">4</span>
                                    <div>
                                        <strong>Xác nhận nhập dữ liệu</strong>
                                        <p class="bm-section-note mb-0">Toàn bộ dữ liệu được lưu trong một giao dịch.</p>
                                    </div>
                                </div>
                            </div>

                            <%-- Lưu ý quy tắc nghiệp vụ về tính toàn vẹn của đợt nhập --%>
                            <div class="bm-rule-note mb-3"><strong>Nguyên tắc toàn bộ hoặc không:</strong> nếu một thao tác lưu thất bại, toàn bộ phiên nhập sẽ được hoàn tác.</div>

                            <%-- Nút Xác nhận lưu vào CSDL (chỉ hoạt động khi tệp hợp lệ - không còn lỗi validation) --%>
                            <c:if test="${not empty preview}">
                                <form method="post" action="${pageContext.request.contextPath}/librarian/book-management/import">
                                    <input type="hidden" name="action" value="confirm">
                                    <button class="btn btn-primary-custom w-100 mb-2" type="submit" ${preview.valid ? '' : 'disabled'}>
                                        Xác nhận nhập ${preview.totalRows} dòng
                                    </button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/librarian/book-management/import">
                                    <input type="hidden" name="action" value="clear">
                                    <button class="btn bm-btn-secondary w-100" type="submit">
                                        Bỏ tệp đang kiểm tra
                                    </button>
                                </form>
                            </c:if>
                        </aside>
                    </div>
                </div>
                <jsp:include page="fragments/_footer.jsp" />
            </main>
        </div>
    </body>
</html>
