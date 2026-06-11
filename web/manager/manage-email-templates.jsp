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
                    <span class="text-dark">Quản lý Mẫu Email</span>
                </nav>

                <!-- ─── Page Title ─── -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h3 fw-bold mb-1" style="color: var(--on-surface);">Quản lý Mẫu Email</h1>
                        <p class="text-on-surface-variant mb-0" style="font-size: 14px;">
                            Xem và chỉnh sửa nội dung các mẫu email tự động gửi cho sinh viên và giảng viên.
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

                    <!-- Left: Danh sách mẫu Email -->
                    <div class="col-12 col-lg-4">
                        <div class="raised-card overflow-hidden">
                            <div class="p-3" style="border-bottom: 1px solid var(--outline-variant); background-color: var(--surface-container-low);">
                                <h5 class="fw-bold mb-0" style="color: var(--on-surface);">Danh sách mẫu Email</h5>
                                <p class="text-on-surface-variant mb-0 small">Tổng: ${templates.size()} mẫu</p>
                            </div>
                            <div class="d-flex flex-column gap-0">
                                <c:forEach var="tmpl" items="${templates}">
                                    <a href="${pageContext.request.contextPath}/manager/email-templates?action=edit&tempId=${tmpl.tempId}"
                                       class="p-3 text-decoration-none d-flex align-items-start gap-2 template-list-item ${editTemplate != null and editTemplate.tempId == tmpl.tempId ? 'active-template' : ''}"
                                       style="border-bottom: 1px solid var(--outline-variant);">
                                        <span class="material-symbols-outlined text-primary-custom mt-1" style="font-size: 20px;">mail</span>
                                        <div class="flex-grow-1 min-w-0">
                                            <p class="fw-bold mb-0 small text-dark text-truncate"><c:out value="${tmpl.tempName}" /></p>
                                            <p class="text-on-surface-variant mb-0" style="font-size: 11px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                                <c:out value="${tmpl.subject}" />
                                            </p>
                                            <span class="text-on-surface-variant" style="font-size: 10px;">
                                                Cập nhật: <fmt:formatDate value="${tmpl.updatedAt != null ? tmpl.updatedAt : tmpl.createdAt}" pattern="dd/MM/yyyy" />
                                            </span>
                                        </div>
                                        <span class="material-symbols-outlined text-on-surface-variant align-self-center" style="font-size: 16px;">chevron_right</span>
                                    </a>
                                </c:forEach>

                                <c:if test="${empty templates}">
                                    <div class="text-center py-4">
                                        <p class="text-on-surface-variant small mb-0">Chưa có mẫu Email nào trong hệ thống.</p>
                                        <p class="text-on-surface-variant" style="font-size: 11px;">Chèn dữ liệu mẫu vào bảng DocumentTemp.</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Form chỉnh sửa / Hướng dẫn -->
                    <div class="col-12 col-lg-8">
                        <c:choose>
                            <c:when test="${not empty editTemplate}">
                                <!-- Form chỉnh sửa mẫu -->
                                <div class="raised-card p-4">
                                    <div class="d-flex align-items-center gap-2 mb-4">
                                        <span class="material-symbols-outlined text-primary-custom">edit_note</span>
                                        <div>
                                            <h5 class="fw-bold mb-0" style="color: var(--on-surface);">Chỉnh sửa mẫu: <code><c:out value="${editTemplate.tempName}" /></code></h5>
                                            <p class="text-on-surface-variant mb-0 small">Thay đổi sẽ ảnh hưởng tới các Email hệ thống gửi tự động.</p>
                                        </div>
                                    </div>

                                    <form method="post" action="${pageContext.request.contextPath}/manager/email-templates">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="tempId" value="${editTemplate.tempId}">

                                        <div class="mb-3">
                                            <label class="form-label small fw-semibold text-on-surface-variant">Tên mẫu (không thể sửa)</label>
                                            <input type="text" class="form-control rounded-3 bg-light" value="<c:out value='${editTemplate.tempName}'/>" disabled>
                                        </div>

                                        <div class="mb-3">
                                            <label for="emailSubject" class="form-label small fw-semibold text-on-surface-variant">Tiêu đề Email <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control rounded-3" id="emailSubject" name="subject"
                                                   value="<c:out value='${editTemplate.subject}'/>" required maxlength="255">
                                        </div>

                                        <div class="mb-3">
                                            <label for="emailBody" class="form-label small fw-semibold text-on-surface-variant">Nội dung Email <span class="text-danger">*</span></label>
                                            <textarea class="form-control rounded-3 font-monospace" id="emailBody" name="bodyContent"
                                                      rows="12" style="font-size: 13px;"><c:out value="${editTemplate.bodyContent}" /></textarea>
                                            <div class="form-text" style="font-size: 11px;">
                                                Sử dụng placeholder dạng <code>&#123;&#123;tenBien&#125;&#125;</code> để chèn dữ liệu động.
                                                VD: <code>&#123;&#123;userName&#125;&#125;</code>, <code>&#123;&#123;bookTitle&#125;&#125;</code>, <code>&#123;&#123;dueDate&#125;&#125;</code>
                                            </div>
                                        </div>

                                        <div class="d-flex gap-2">
                                            <button type="submit" class="btn btn-primary-custom rounded-3 fw-bold px-4">
                                                <span class="material-symbols-outlined me-1 align-middle">save</span>
                                                Lưu thay đổi
                                            </button>
                                            <a href="${pageContext.request.contextPath}/manager/email-templates"
                                               class="btn btn-outline-secondary rounded-3 px-4">Hủy</a>
                                        </div>
                                    </form>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Placeholder hướng dẫn -->
                                <div class="raised-card p-5 text-center" style="border: 2px dashed var(--outline-variant);">
                                    <span class="material-symbols-outlined text-on-surface-variant" style="font-size: 56px;">mail_outline</span>
                                    <h5 class="fw-bold mt-3 text-on-surface-variant">Chọn một mẫu Email để chỉnh sửa</h5>
                                    <p class="text-on-surface-variant small mb-0">Nhấp vào tên mẫu ở danh sách bên trái để xem và sửa nội dung.</p>
                                    <div class="mt-4 p-3 rounded-3 text-start" style="background-color: var(--surface-container-low);">
                                        <p class="fw-bold small mb-2">Các placeholder được hỗ trợ:</p>
                                        <code class="d-block small text-on-surface-variant">&#123;&#123;userName&#125;&#125;</code> — Tên người nhận<br>
                                        <code class="d-block small text-on-surface-variant">&#123;&#123;bookTitle&#125;&#125;</code> — Tên sách<br>
                                        <code class="d-block small text-on-surface-variant">&#123;&#123;dueDate&#125;&#125;</code> — Ngày đến hạn trả<br>
                                        <code class="d-block small text-on-surface-variant">&#123;&#123;fineAmount&#125;&#125;</code> — Số tiền phạt<br>
                                        <code class="d-block small text-on-surface-variant">&#123;&#123;barcode&#125;&#125;</code> — Mã barcode sách
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div><!-- /.row -->

            </div><!-- /.container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.main-wrapper -->

    <style>
        .template-list-item {
            transition: background-color 0.15s ease;
        }
        .template-list-item:hover {
            background-color: var(--surface-container-low);
        }
        .active-template {
            background-color: var(--primary-fixed);
            border-left: 3px solid var(--primary);
        }
    </style>

</body>
</html>
