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
                                <h2 class="mb-0" style="font-size: 22px; font-weight: 700; color: var(--on-surface);">Danh sách vi phạm (Phạt)</h2>
                            </div>
                            <p class="text-on-surface-variant mb-0 ms-5" style="font-size: 13px;">
                                Danh sách đầy đủ các khoản phạt trên hệ thống
                            </p>
                        </div>
                    </div>

                    <div class="raised-card overflow-hidden">
                        <div class="card-header-row">
                            <div>
                                <h3 class="card-title">Tất cả vi phạm</h3>
                                <p class="card-subtitle">
                                    <span class="badge-pill badge-info"><c:out value="${fn:length(allFines)}" /> Khoản</span>
                                </p>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-lms mb-0">
                                <thead>
                                    <tr>
                                        <th>Thành viên</th>
                                        <th>Lý do vi phạm</th>
                                        <th>Sách (nếu có)</th>
                                        <th>Thời gian</th>
                                        <th class="text-end">Số tiền</th>
                                        <th>Trạng thái</th>
                                        <th class="text-end">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty allFines}">
                                            <tr>
                                                <td colspan="7" class="text-center py-5">
                                                    <span class="material-symbols-outlined text-muted" style="font-size: 48px;">inbox</span>
                                                    <p class="text-muted mt-2 mb-0" style="font-size: 14px;">Chưa có dữ liệu vi phạm</p>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="fine" items="${allFines}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center gap-2">
                                                            <div class="avatar avatar-sm" style="background-color: var(--error-container); color: var(--error);">
                                                                <c:out value="${fn:toUpperCase(fn:substring(fine.memberName, 0, 2))}" />
                                                            </div>
                                                            <div>
                                                                <span style="font-size: 13px; font-weight: 600;"><c:out value="${fine.memberName}" /></span>
                                                                <div class="text-muted" style="font-size: 11px;"><c:out value="${fine.memberCode}" /></div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td style="font-size: 13px; max-width: 200px;">
                                                        <span class="d-block text-truncate" title="${fine.reason}"><c:out value="${fine.reason}" /></span>
                                                    </td>
                                                    <td style="font-size: 13px; max-width: 150px;">
                                                        <c:choose>
                                                            <c:when test="${not empty fine.bookTitle}">
                                                                <span class="d-block text-truncate" title="${fine.bookTitle}"><c:out value="${fine.bookTitle}" /></span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted fst-italic">Không có</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-on-surface-variant" style="font-size: 13px;">
                                                        <fmt:formatDate value="${fine.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                    </td>
                                                    <td class="text-end" style="font-size: 14px; font-weight: 700; color: var(--error);">
                                                        <fmt:formatNumber value="${fine.amount}" type="currency" currencySymbol="đ" maxFractionDigits="0" />
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${fine.status eq 'paid'}">
                                                                <span class="badge-pill badge-success">Đã thu</span>
                                                            </c:when>
                                                            <c:when test="${fine.status eq 'cancelled'}">
                                                                <span class="badge-pill badge-info">Đã hủy</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-pill badge-error">Chưa thu</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-end">
                                                        <c:choose>
                                                            <c:when test="${fine.status eq 'unpaid'}">
                                                                <a href="${pageContext.request.contextPath}/librarian/desk-dashboard?memberCode=${fine.memberCode}"
                                                                   class="btn btn-sm fw-bold px-3 text-decoration-none rounded-2"
                                                                   style="font-size: 11px; color: var(--error); background-color: var(--error-container); border: none; display: inline-block;">
                                                                    Thu
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted fw-bold">-</span>
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
