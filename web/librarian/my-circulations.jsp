<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <jsp:include page="fragments/_head.jsp" />
    <body class="d-flex flex-column">
        <jsp:include page="fragments/_sidebar.jsp" />
        <div class="d-flex main-wrapper overflow-hidden">
            <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">
                <jsp:include page="fragments/_header.jsp" />

                <div class="container-fluid px-4 py-4" style="max-width: 1440px; margin: 0 auto;">
                    
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="lms-alert lms-alert-success mb-4 alert alert-dismissible fade show" role="alert">
                            <span class="material-symbols-outlined">check_circle</span>
                            <span class="flex-grow-1"><c:out value="${sessionScope.successMessage}" /></span>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                        </div>
                        <c:remove var="successMessage" scope="session" />
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="lms-alert lms-alert-error mb-4 alert alert-dismissible fade show" role="alert">
                            <span class="material-symbols-outlined">error</span>
                            <span class="flex-grow-1"><c:out value="${sessionScope.errorMessage}" /></span>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                        </div>
                        <c:remove var="errorMessage" scope="session" />
                    </c:if>

                    <div class="d-flex justify-content-between align-items-end mb-4">
                        <div>
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <a href="${pageContext.request.contextPath}/librarian/dashboard" class="btn btn-sm btn-icon text-muted" title="Trở lại">
                                    <span class="material-symbols-outlined">arrow_back</span>
                                </a>
                                <h2 class="mb-0" style="font-size: 22px; font-weight: 700; color: var(--on-surface);">Sách tôi đã xử lý</h2>
                            </div>
                            <p class="text-on-surface-variant mb-0 ms-5" style="font-size: 13px;">
                                Danh sách toàn bộ các giao dịch mượn/trả sách do bạn thực hiện.
                            </p>
                        </div>
                    </div>

                    <div class="raised-card overflow-hidden">
                        <div class="card-header-row">
                            <div>
                                <h3 class="card-title">Danh sách giao dịch</h3>
                                <p class="card-subtitle">
                                    <span class="badge-pill badge-info"><c:out value="${fn:length(myLoans)}" /> Giao dịch</span>
                                </p>
                            </div>
                            <a href="${pageContext.request.contextPath}/librarian/desk-dashboard"
                               class="btn btn-sm btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center gap-1 text-decoration-none">
                                <span class="material-symbols-outlined" style="font-size: 15px;">add</span> Cho mượn sách
                            </a>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-lms mb-0">
                                <thead>
                                    <tr>
                                        <th>Thành viên</th>
                                        <th>Tiêu đề sách</th>
                                        <th>Ngày mượn</th>
                                        <th>Hạn trả</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty myLoans}">
                                            <tr>
                                                <td colspan="5" class="text-center py-5">
                                                    <span class="material-symbols-outlined text-muted" style="font-size: 48px;">inbox</span>
                                                    <p class="text-muted mt-2 mb-0" style="font-size: 14px;">Chưa có dữ liệu giao dịch</p>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="loan" items="${myLoans}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar avatar-sm" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">
                                                                <c:out value="${fn:toUpperCase(fn:substring(loan.memberName, 0, 2))}" />
                                                            </div>
                                                            <div>
                                                                <span style="font-size: 13px; font-weight: 600;"><c:out value="${loan.memberName}" /></span>
                                                                <div class="text-muted" style="font-size: 11px;"><c:out value="${loan.memberCode}" /></div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td style="font-size: 13px;">
                                                        <span class="d-block" style="max-width: 300px;"><c:out value="${loan.bookTitle}" /></span>
                                                    </td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">
                                                        <fmt:formatDate value="${loan.startDate}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td style="font-size: 13px; <c:if test='${loan.status eq "borrowed" and loan.endDate.time lt now.time}'>color: var(--error); font-weight: bold;</c:if>">
                                                        <fmt:formatDate value="${loan.endDate}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${loan.status eq 'returned'}">
                                                                <span class="badge-pill badge-success">Đã trả</span>
                                                            </c:when>
                                                            <c:when test="${loan.endDate.time lt now.time}">
                                                                <span class="badge-pill badge-error">Quá hạn</span>
                                                            </c:when>
                                                            <c:when test="${(loan.endDate.time - now.time) lt 3 * 24 * 60 * 60 * 1000}">
                                                                <span class="badge-pill badge-warning">Sắp đến hạn</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-pill badge-info">Đang mượn</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>
                <jsp:include page="fragments/_footer.jsp" />
            </main>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
