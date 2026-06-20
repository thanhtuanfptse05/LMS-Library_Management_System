<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp">
    <jsp:param name="title" value="Cấu hình Chính sách Thư viện | Quản lý" />
</jsp:include>

<body class="d-flex flex-column">

    <!-- SIDEBAR -->
    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ▶ BODY WRAPPER ◀ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <!-- ▶ MAIN CONTENT ◀ -->
        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4">

                <!-- ▶ Page Header ◀ -->
                <div class="page-header d-flex justify-content-between align-items-end mb-4">
                    <div>
                        <h1 class="mb-1" style="font-size: 22px; font-weight: 700; color: var(--on-surface);">
                            <span class="material-symbols-outlined align-middle me-2" style="font-size: 26px; color: var(--primary); font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24;">tune</span>
                            Cài đặt Hệ thống
                        </h1>
                        <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Quản lý các thông số mượn trả, gia hạn, đặt trước và tiền phạt</p>
                    </div>
                </div>

                <!-- ▶ Alert Messages ◀ -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="lms-alert lms-alert-success mb-4 alert alert-dismissible fade show" role="alert">
                        <span class="material-symbols-outlined" style="font-size: 20px; font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24;">check_circle</span>
                        <span class="flex-grow-1"><c:out value="${sessionScope.successMessage}" /></span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="lms-alert lms-alert-error mb-4 alert alert-dismissible fade show" role="alert">
                        <span class="material-symbols-outlined" style="font-size: 20px; font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24;">error</span>
                        <span class="flex-grow-1"><c:out value="${sessionScope.errorMessage}" /></span>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- ▶ Group: library — Chính sách mượn trả ◀ -->
                <div class="raised-card mb-4">
                    <div class="card-header-row" style="border-bottom: 1px solid var(--outline-variant); padding-bottom: 16px; margin-bottom: 20px;">
                        <div class="d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined" style="color: var(--primary); font-size: 22px; font-variation-settings: 'FILL' 1;">menu_book</span>
                            <div>
                                <h3 class="card-title mb-0">Chính sách Mượn - Trả - Gia hạn</h3>
                                <p class="card-subtitle mb-0" style="font-size: 12px;">Giới hạn mượn, số ngày trả, số lần gia hạn</p>
                            </div>
                        </div>
                    </div>
                    <div class="px-1">
                        <c:forEach var="cfg" items="${configs}">
                            <c:if test="${cfg.configGroup == 'library'}">
                                <form action="${pageContext.request.contextPath}/manager/system-config" method="POST"
                                      class="d-flex align-items-center gap-3 py-3"
                                      style="border-bottom: 1px solid var(--outline-variant);"
                                      id="form-${cfg.configKey}">
                                    <input type="hidden" name="configKey" value="${cfg.configKey}">
                                    <input type="hidden" name="action" value="update">

                                    <div class="flex-grow-1">
                                        <label class="form-label fw-bold mb-0" style="font-size: 13px; color: var(--on-surface);">
                                            <c:out value="${cfg.description}"/>
                                        </label>
                                        <div style="font-size: 11px; font-family: 'Courier New', monospace; color: var(--on-surface-variant);">
                                            <c:out value="${cfg.configKey}"/>
                                        </div>
                                    </div>

                                    <div style="width: 180px;">
                                        <input type="text"
                                               class="form-control form-control-sm text-center fw-bold"
                                               name="configValue"
                                               value="${cfg.configValue}"
                                               id="input-${cfg.configKey}"
                                               style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md); font-family: 'Courier New', monospace;">
                                    </div>

                                    <div style="min-width: 90px;" class="text-end">
                                        <button type="submit" class="btn btn-sm btn-primary-custom rounded-2 d-inline-flex align-items-center gap-1">
                                            <span class="material-symbols-outlined" style="font-size: 14px;">save</span> Lưu
                                        </button>
                                    </div>

                                    <div style="min-width: 110px; font-size: 11px; color: var(--on-surface-variant); text-align: right;">
                                        <span class="material-symbols-outlined" style="font-size: 12px; vertical-align: middle;">person</span>
                                        <c:out value="${cfg.updaterName}"/><br>
                                        <fmt:formatDate value="${cfg.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </form>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <!-- ▶ Group: fine — Quy định phạt ◀ -->
                <div class="raised-card mb-4">
                    <div class="card-header-row" style="border-bottom: 1px solid var(--outline-variant); padding-bottom: 16px; margin-bottom: 20px;">
                        <div class="d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined" style="color: #f59e0b; font-size: 22px; font-variation-settings: 'FILL' 1;">payments</span>
                            <div>
                                <h3 class="card-title mb-0">Quy định Tiền phạt</h3>
                                <p class="card-subtitle mb-0" style="font-size: 12px;">Mức phạt trễ hạn, hệ số đền bù sách hỏng/mất</p>
                            </div>
                        </div>
                    </div>
                    <div class="px-1">
                        <c:forEach var="cfg" items="${configs}">
                            <c:if test="${cfg.configGroup == 'fine'}">
                                <form action="${pageContext.request.contextPath}/manager/system-config" method="POST"
                                      class="d-flex align-items-center gap-3 py-3"
                                      style="border-bottom: 1px solid var(--outline-variant);"
                                      id="form-${cfg.configKey}">
                                    <input type="hidden" name="configKey" value="${cfg.configKey}">
                                    <input type="hidden" name="action" value="update">

                                    <div class="flex-grow-1">
                                        <label class="form-label fw-bold mb-0" style="font-size: 13px; color: var(--on-surface);">
                                            <c:out value="${cfg.description}"/>
                                        </label>
                                        <div style="font-size: 11px; font-family: 'Courier New', monospace; color: var(--on-surface-variant);">
                                            <c:out value="${cfg.configKey}"/>
                                        </div>
                                    </div>

                                    <div style="width: 180px;">
                                        <input type="text"
                                               class="form-control form-control-sm text-center fw-bold"
                                               name="configValue"
                                               value="${cfg.configValue}"
                                               id="input-${cfg.configKey}"
                                               style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md); font-family: 'Courier New', monospace;">
                                    </div>

                                    <div style="min-width: 90px;" class="text-end">
                                        <button type="submit" class="btn btn-sm btn-primary-custom rounded-2 d-inline-flex align-items-center gap-1">
                                            <span class="material-symbols-outlined" style="font-size: 14px;">save</span> Lưu
                                        </button>
                                    </div>

                                    <div style="min-width: 110px; font-size: 11px; color: var(--on-surface-variant); text-align: right;">
                                        <span class="material-symbols-outlined" style="font-size: 12px; vertical-align: middle;">person</span>
                                        <c:out value="${cfg.updaterName}"/><br>
                                        <fmt:formatDate value="${cfg.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </form>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <c:if test="${empty configs}">
                    <div class="raised-card text-center py-5">
                        <span class="material-symbols-outlined d-block mb-2" style="font-size: 40px; color: var(--outline);">inbox</span>
                        <span style="color: var(--on-surface-variant); font-size: 14px;">Không có cấu hình nào.</span>
                    </div>
                </c:if>

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
