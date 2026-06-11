<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1200px; margin: 0 auto;">

                <!-- ─── Breadcrumb ─── -->
                <nav class="mb-2 d-flex align-items-center gap-1 text-muted small fw-semibold text-uppercase"
                     aria-label="breadcrumb" style="font-size: 12px; letter-spacing: 0.05em;">
                    <a class="text-decoration-none text-muted" href="${pageContext.request.contextPath}/manager/dashboard">Bảng điều khiển</a>
                    <span class="material-symbols-outlined fs-6">chevron_right</span>
                    <span class="text-dark">Quản lý Bảng tin</span>
                </nav>

                <!-- ─── Page Title ─── -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h3 fw-bold mb-1" style="color: var(--on-surface);">Quản lý Bảng tin</h1>
                        <p class="text-on-surface-variant mb-0" style="font-size: 14px;">
                            Đăng thông báo chung cho toàn bộ Sinh viên và Giảng viên.
                        </p>
                    </div>
                </div>

                <!-- ─── Alert Messages ─── -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">check_circle</span>
                        <c:out value="${param.success}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                </c:if>
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">error</span>
                        <c:out value="${param.error}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                </c:if>

                <div class="row g-4">

                    <!-- Left: Form tạo thông báo mới -->
                    <div class="col-12 col-lg-4">
                        <div class="raised-card p-4">
                            <h5 class="fw-bold mb-3" style="color: var(--on-surface);">
                                <span class="material-symbols-outlined me-2 align-middle" style="color: var(--primary);">campaign</span>
                                Đăng thông báo mới
                            </h5>
                            <form method="post" action="${pageContext.request.contextPath}/manager/notifications">
                                <input type="hidden" name="action" value="create">
                                <div class="mb-3">
                                    <label for="notifTitle" class="form-label small fw-semibold text-on-surface-variant">Tiêu đề <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control rounded-3" id="notifTitle" name="title"
                                           placeholder="Nhập tiêu đề thông báo..." required maxlength="500">
                                </div>
                                <div class="mb-4">
                                    <label for="notifContent" class="form-label small fw-semibold text-on-surface-variant">Nội dung</label>
                                    <textarea class="form-control rounded-3" id="notifContent" name="content"
                                              rows="6" placeholder="Nhập nội dung chi tiết thông báo..."></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary-custom w-100 rounded-3 fw-bold py-2">
                                    <span class="material-symbols-outlined me-1 align-middle">send</span>
                                    Đăng lên Bảng tin
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- Right: Danh sách thông báo -->
                    <div class="col-12 col-lg-8">
                        <div class="raised-card overflow-hidden">
                            <div class="p-3 d-flex justify-content-between align-items-center"
                                 style="border-bottom: 1px solid var(--outline-variant); background-color: var(--surface-container-low);">
                                <div>
                                    <h5 class="fw-bold mb-0" style="color: var(--on-surface);">Danh sách thông báo đã đăng</h5>
                                    <p class="text-on-surface-variant mb-0" style="font-size: 12px;">Tổng: ${notifications.size()} thông báo</p>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${not empty notifications}">
                                    <div class="d-flex flex-column">
                                        <c:forEach var="notif" items="${notifications}">
                                            <div class="p-3 d-flex align-items-start gap-3" style="border-bottom: 1px solid var(--outline-variant);">
                                                <div class="rounded-circle d-flex align-items-center justify-content-center bg-info-subtle text-info flex-shrink-0"
                                                     style="width: 40px; height: 40px;">
                                                    <span class="material-symbols-outlined">campaign</span>
                                                </div>
                                                <div class="flex-grow-1 min-w-0">
                                                    <div class="d-flex justify-content-between align-items-start gap-2">
                                                        <h6 class="fw-bold mb-1 text-truncate" style="color: var(--on-surface);">
                                                            <c:out value="${notif.title}" />
                                                        </h6>
                                                        <span class="text-on-surface-variant small font-monospace flex-shrink-0">
                                                            <fmt:formatDate value="${notif.createdAt}" pattern="dd/MM/yyyy" />
                                                        </span>
                                                    </div>
                                                    <p class="text-on-surface-variant small mb-1 text-truncate">
                                                        <c:out value="${notif.content}" />
                                                    </p>
                                                    <span class="small text-on-surface-variant">
                                                        Đăng bởi: <c:out value="${not empty notif.createdByName ? notif.createdByName : 'Quản trị viên'}" />
                                                    </span>
                                                </div>
                                                <!-- Nút xóa -->
                                                <form method="post" action="${pageContext.request.contextPath}/manager/notifications"
                                                      onsubmit="return confirm('Xác nhận xóa thông báo này?')">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="notificationId" value="${notif.notificationId}">
                                                    <button type="submit" class="btn btn-link text-danger p-1 rounded-circle" title="Xóa thông báo">
                                                        <span class="material-symbols-outlined">delete</span>
                                                    </button>
                                                </form>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5">
                                        <span class="material-symbols-outlined text-on-surface-variant" style="font-size: 48px;">notifications_off</span>
                                        <p class="fw-semibold mt-3 text-on-surface-variant">Chưa có thông báo nào được đăng.</p>
                                        <p class="text-on-surface-variant small">Sử dụng form bên trái để tạo thông báo đầu tiên.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div><!-- /.row -->

            </div><!-- /.container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.main-wrapper -->

</body>
</html>
