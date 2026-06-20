<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <jsp:include page="fragments/_head.jsp">
            <jsp:param name="title" value="Cấu hình Hệ thống | Admin" />
        </jsp:include>
    </head>
    <body class="d-flex flex-column">
        <!-- SIDEBAR -->
        <jsp:include page="fragments/_sidebar.jsp" />

        <div class="d-flex main-wrapper overflow-hidden">
            <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: #f7f9fb;">
                <!-- HEADER -->
                <jsp:include page="fragments/_header.jsp" />

                <div class="container-fluid px-4 py-4" style="max-width: 1400px; margin: 0 auto;">
                
                <!-- Flash Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined align-middle me-2">check_circle</span>
                        <c:out value="${sessionScope.successMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined align-middle me-2">error</span>
                        <c:out value="${sessionScope.errorMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- Section Header -->
                <div class="d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center gap-3 mb-4">
                    <div>
                        <h2 class="fw-bold mb-0 text-primary-custom" style="font-size: 22px;">Cấu hình Hệ thống Toàn cầu</h2>
                        <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Quản lý toàn bộ thông số hoạt động của Thư viện (Chỉ dành cho Admin)</p>
                    </div>
                </div>

                <div class="row">
                    <!-- Left Column: Configurations -->
                    <div class="col-lg-8">
                        <!-- Bộ lọc -->
                        <div class="raised-card p-3 mb-4 bg-white">
                            <form action="${pageContext.request.contextPath}/admin/system-config" method="GET" class="row g-3 align-items-end">
                                <div class="col-12 col-md-6">
                                    <label for="groupFilter" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 10px; letter-spacing: 0.05em;">Lọc theo nhóm cấu hình</label>
                                    <select class="form-select config-input w-100" id="groupFilter" name="group" onchange="this.form.submit();">
                                        <option value="all" ${empty groupFilter or groupFilter == 'all' ? 'selected' : ''}>Tất cả cấu hình</option>
                                        <option value="library" ${groupFilter == 'library' ? 'selected' : ''}>Chính sách Thư viện</option>
                                        <option value="fine" ${groupFilter == 'fine' ? 'selected' : ''}>Chính sách Phạt</option>
                                        <option value="notification" ${groupFilter == 'notification' ? 'selected' : ''}>Thông báo & Email</option>
                                        <option value="system" ${groupFilter == 'system' ? 'selected' : ''}>Hệ thống</option>
                                        <option value="sepay" ${groupFilter == 'sepay' ? 'selected' : ''}>Tích hợp SePay</option>
                                    </select>
                                </div>
                            </form>
                        </div>

                        <!-- Bảng danh sách cấu hình -->
                        <div class="raised-card overflow-hidden bg-white mb-4">
                            <div class="table-responsive">
                                <table class="table table-lms table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th scope="col" class="ps-4">Tên Cấu Hình</th>
                                            <th scope="col">Nhóm</th>
                                            <th scope="col" class="text-center">Giá Trị</th>
                                            <th scope="col" class="pe-4 text-end">Thao Tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty configs}">
                                                <c:forEach var="cfg" items="${configs}">
                                                    <tr>
                                                        <td class="ps-4">
                                                            <div class="fw-bold" style="font-size: 13px; color: var(--on-surface);">
                                                                <c:out value="${cfg.configKey}"/>
                                                            </div>
                                                            <div class="text-on-surface-variant text-truncate" style="font-size: 11px; max-width: 200px;" title="<c:out value="${cfg.description}"/>">
                                                                <c:out value="${cfg.description}"/>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${cfg.configGroup == 'library'}"><span class="badge-pill" style="background-color: #d1fae5; color: #065f46;">Library</span></c:when>
                                                                <c:when test="${cfg.configGroup == 'fine'}"><span class="badge-pill" style="background-color: #fef3c7; color: #d97706;">Fine</span></c:when>
                                                                <c:when test="${cfg.configGroup == 'notification'}"><span class="badge-pill" style="background-color: #e0f2fe; color: #0369a1;">Notification</span></c:when>
                                                                <c:when test="${cfg.configGroup == 'system'}"><span class="badge-pill" style="background-color: #f3f4f6; color: #374151;">System</span></c:when>
                                                                <c:when test="${cfg.configGroup == 'sepay'}"><span class="badge-pill" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">SePay</span></c:when>
                                                                <c:otherwise><span class="badge-pill bg-light text-dark">${cfg.configGroup}</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-center">
                                                            <span class="badge-pill fw-bold" style="background-color: #f8fafc; color: #0f172a; border: 1px solid #e2e8f0;">
                                                                <c:out value="${cfg.configValue}"/>
                                                            </span>
                                                        </td>
                                                        <td class="pe-4 text-end">
                                                            <button class="btn-icon" title="Chỉnh sửa"
                                                                    data-bs-toggle="modal" data-bs-target="#editModal"
                                                                    data-key="<c:out value='${cfg.configKey}'/>"
                                                                    data-val="<c:out value='${cfg.configValue}'/>"
                                                                    data-desc="<c:out value='${cfg.description}'/>"
                                                                    onclick="prefillModal(this)">
                                                                <span class="material-symbols-outlined text-primary-custom" style="font-size: 19px;">edit</span>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="4" class="text-center py-5 text-muted">
                                                        <span class="material-symbols-outlined d-block mb-2" style="font-size: 40px; color: var(--outline-variant);">settings_suggest</span>
                                                        Không có cấu hình nào.
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: History -->
                    <div class="col-lg-4">
                        <div class="raised-card bg-white h-100 d-flex flex-column">
                            <div class="p-3 border-bottom d-flex align-items-center gap-2" style="background-color: #f8fafc;">
                                <span class="material-symbols-outlined text-primary-custom">history</span>
                                <h6 class="mb-0 fw-bold text-on-surface">Lịch sử thay đổi</h6>
                            </div>
                            <div class="p-0 overflow-y-auto" style="max-height: 600px;">
                                <c:choose>
                                    <c:when test="${not empty configLogs}">
                                        <div class="list-group list-group-flush">
                                            <c:forEach var="log" items="${configLogs}">
                                                <div class="list-group-item p-3 border-bottom border-light">
                                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                                        <span class="fw-bold text-primary-custom" style="font-size: 13px;"><c:out value="${log.configKey}"/></span>
                                                        <span class="text-on-surface-variant" style="font-size: 11px;"><fmt:formatDate value="${log.updatedAt}" pattern="dd/MM HH:mm"/></span>
                                                    </div>
                                                    <div class="d-flex align-items-center gap-2 mb-2" style="font-size: 12px;">
                                                        <span class="text-danger text-decoration-line-through bg-danger-subtle px-2 py-1 rounded"><c:out value="${log.oldValue}"/></span>
                                                        <span class="material-symbols-outlined text-muted" style="font-size: 14px;">arrow_forward</span>
                                                        <span class="text-success fw-bold bg-success-subtle px-2 py-1 rounded"><c:out value="${log.newValue}"/></span>
                                                    </div>
                                                    <div class="text-on-surface-variant" style="font-size: 11px;">
                                                        Bởi: <span class="fw-semibold"><c:out value="${log.updaterName}"/></span>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-5 text-muted">
                                            <span class="material-symbols-outlined d-block mb-2" style="font-size: 30px; opacity: 0.5;">history_toggle_off</span>
                                            <p style="font-size: 13px;">Chưa có lịch sử thay đổi.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Modal Cập Nhật Cấu Hình -->
                <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <form action="${pageContext.request.contextPath}/admin/system-config" method="POST" class="modal-content">
                            <div class="modal-header border-0 pb-0">
                                <h5 class="modal-title fw-bold text-primary-custom" id="editModalLabel" style="font-size: 18px;">Cập nhật cấu hình hệ thống</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" name="configKey" id="modalConfigKey">
                                <input type="hidden" name="groupFilter" value="${groupFilter}">
                                
                                <div class="mb-4">
                                    <label class="form-label fw-semibold text-on-surface-variant text-uppercase mb-1" style="font-size: 10px; letter-spacing: 0.05em;">Mô tả cấu hình</label>
                                    <p id="modalConfigDesc" class="text-on-surface mb-0" style="font-size: 14px; background-color: #f8fafc; padding: 12px; border-radius: 8px; border: 1px solid #e2e8f0;"></p>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="modalConfigValue" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 10px; letter-spacing: 0.05em;">Giá trị mới <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control config-input fw-bold" id="modalConfigValue" name="configValue" required style="font-size: 15px; color: var(--primary-custom);">
                                </div>
                            </div>
                            <div class="modal-footer border-0 pt-0">
                                <button type="button" class="btn btn-outline-secondary rounded-3 fw-bold px-4" data-bs-dismiss="modal" style="font-size: 14px; border: 1px solid var(--outline-variant);">Hủy bỏ</button>
                                <button type="submit" class="btn btn-primary-custom rounded-3 fw-bold px-4" style="font-size: 14px;">Lưu thay đổi</button>
                            </div>
                        </form>
                    </div>
                </div>

                </div><!-- /container-fluid -->

                <!-- FOOTER -->
                <jsp:include page="fragments/_footer.jsp" />

            </main>
        </div><!-- /.d-flex.main-wrapper -->

        <script>
            function prefillModal(btn) {
                var key = btn.getAttribute('data-key');
                var value = btn.getAttribute('data-val');
                var desc = btn.getAttribute('data-desc');
                document.getElementById('modalConfigKey').value = key;
                document.getElementById('modalConfigValue').value = value;
                document.getElementById('modalConfigDesc').textContent = desc;
            }
        </script>
    </body>
</html>
