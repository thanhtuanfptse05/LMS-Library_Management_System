<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp">
    <jsp:param name="title" value="Cấu hình Hệ thống | Admin" />
</jsp:include>

<body class="d-flex flex-column">

    <!-- SIDEBAR -->
    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <!-- ════════════════ MAIN CONTENT ════════════════ -->
        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4">

                <!-- ─── Page Header ─── -->
                <div class="page-header d-flex justify-content-between align-items-end mb-4">
                    <div>
                        <h2 class="mb-1" style="font-size: 22px; font-weight: 700; color: var(--on-surface);">
                            <span class="material-symbols-outlined align-middle me-2" style="font-size: 26px; color: var(--primary); font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24;">settings</span>
                            Cấu hình Hệ thống Toàn cầu
                        </h2>
                        <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Quản lý toàn bộ thông số hoạt động của Thư viện (Chỉ dành cho Admin)</p>
                    </div>
                    <div>
                        <button type="button" class="btn btn-primary-custom rounded-3 fw-bold px-4 d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#createModal">
                            <span class="material-symbols-outlined" style="font-size: 18px;">add</span> Thêm Cấu Hình
                        </button>
                    </div>
                </div>

                <!-- ─── Alert Messages ─── -->
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

                <!-- ─── Bộ lọc ─── -->
                <div class="raised-card mb-4 p-4">
                    <form action="${pageContext.request.contextPath}/admin/system-config" method="GET" class="d-flex gap-3 align-items-end">
                        <div class="flex-grow-1" style="max-width: 320px;">
                            <label for="groupFilter" class="d-block mb-1 fw-bold text-on-surface-variant text-uppercase"
                                   style="font-size: 10px; letter-spacing: 0.08em;">Lọc theo nhóm cấu hình</label>
                            <select class="form-select" id="groupFilter" name="group" style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md);">
                                <option value="all" ${empty groupFilter or groupFilter == 'all' ? 'selected' : ''}>Tất cả cấu hình</option>
                                <option value="library" ${groupFilter == 'library' ? 'selected' : ''}>Chính sách Thư viện (library)</option>
                                <option value="fine" ${groupFilter == 'fine' ? 'selected' : ''}>Phạt &amp; Thanh toán (fine)</option>
                                <option value="sepay" ${groupFilter == 'sepay' ? 'selected' : ''}>Tích hợp SePay QR (sepay)</option>
                                <option value="system" ${groupFilter == 'system' ? 'selected' : ''}>Hệ thống (system)</option>
                                <option value="notification" ${groupFilter == 'notification' ? 'selected' : ''}>Thông báo (notification)</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary-custom rounded-3 fw-bold px-4 d-flex align-items-center gap-2">
                            <span class="material-symbols-outlined" style="font-size: 18px;">filter_alt</span> Lọc
                        </button>
                    </form>
                </div>

                <!-- ─── Bảng danh sách cấu hình ─── -->
                <div class="raised-card overflow-hidden">
                    <div class="card-header-row">
                        <div>
                            <h3 class="card-title">Danh sách Cấu hình</h3>
                            <p class="card-subtitle">
                                <c:choose>
                                    <c:when test="${empty groupFilter or groupFilter == 'all'}">Hiển thị tất cả cấu hình hệ thống</c:when>
                                    <c:otherwise>Đang lọc theo nhóm: <strong>${groupFilter}</strong></c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-lms mb-0">
                            <thead>
                                <tr>
                                    <th>Tên Cấu Hình</th>
                                    <th>Nhóm</th>
                                    <th>Mô Tả</th>
                                    <th class="text-center">Giá Trị</th>
                                    <th>Cập Nhật Bởi</th>
                                    <th>Lần Cuối</th>
                                    <th class="text-end">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cfg" items="${configs}">
                                    <tr>
                                        <td class="fw-bold" style="font-size: 13px; font-family: 'Courier New', monospace;">
                                            <c:out value="${cfg.configKey}"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${cfg.configGroup == 'library'}"><span class="badge-pill badge-success"><span class="material-symbols-outlined" style="font-size: 12px;">menu_book</span> Library</span></c:when>
                                                <c:when test="${cfg.configGroup == 'fine'}"><span class="badge-pill badge-error"><span class="material-symbols-outlined" style="font-size: 12px;">payments</span> Fine</span></c:when>
                                                <c:when test="${cfg.configGroup == 'sepay'}"><span class="badge-pill" style="background: #e8f4fd; color: #0c63a4; border: 1px solid #b3d9f7;"><span class="material-symbols-outlined" style="font-size: 12px;">qr_code_2</span> SePay</span></c:when>
                                                <c:when test="${cfg.configGroup == 'notification'}"><span class="badge-pill badge-neutral"><span class="material-symbols-outlined" style="font-size: 12px;">notifications</span> Notification</span></c:when>
                                                <c:when test="${cfg.configGroup == 'system'}"><span class="badge-pill badge-neutral"><span class="material-symbols-outlined" style="font-size: 12px;">computer</span> System</span></c:when>
                                                <c:otherwise><span class="badge-pill badge-neutral"><c:out value="${cfg.configGroup}"/></span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="font-size: 13px; color: var(--on-surface-variant); max-width: 240px;">
                                            <c:out value="${cfg.description}"/>
                                        </td>
                                        <td class="text-center">
                                            <span style="background: var(--surface-container-low); border: 1px solid var(--outline-variant); border-radius: var(--radius-sm); padding: 4px 12px; font-family: 'Courier New', monospace; font-size: 13px; font-weight: 700; color: var(--primary);">
                                                <c:out value="${cfg.configValue}"/>
                                            </span>
                                        </td>
                                        <td style="font-size: 13px;">
                                            <c:out value="${cfg.updaterName}"/>
                                        </td>
                                        <td style="font-size: 12px; color: var(--on-surface-variant);">
                                            <fmt:formatDate value="${cfg.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td class="text-end" style="white-space: nowrap;">
                                            <button type="button"
                                                    class="btn btn-sm btn-primary-custom rounded-2 d-inline-flex align-items-center gap-1"
                                                    data-bs-toggle="modal" data-bs-target="#editModal"
                                                    onclick="prefillModal('<c:out value="${cfg.configKey}"/>', '<c:out value="${cfg.configValue}"/>', '<c:out value="${cfg.description}"/>')">
                                                <span class="material-symbols-outlined" style="font-size: 15px;">edit</span> Sửa
                                            </button>
                                            <form action="${pageContext.request.contextPath}/admin/system-config" method="POST" class="d-inline-block m-0" onsubmit="return confirm('Bạn có chắc chắn muốn xóa cấu hình này không?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="configKey" value="<c:out value="${cfg.configKey}"/>">
                                                <input type="hidden" name="groupFilter" value="${groupFilter}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-2 d-inline-flex align-items-center gap-1 ms-1">
                                                    <span class="material-symbols-outlined" style="font-size: 15px;">delete</span> Xóa
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty configs}">
                                    <tr>
                                        <td colspan="7" class="text-center py-5">
                                            <span class="material-symbols-outlined d-block mb-2" style="font-size: 40px; color: var(--outline);">inbox</span>
                                            <span style="color: var(--on-surface-variant); font-size: 14px;">Không có cấu hình nào trong nhóm này.</span>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <!-- Modal Thêm Mới Cấu Hình -->
    <div class="modal fade" id="createModal" tabindex="-1" aria-labelledby="createModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <form action="${pageContext.request.contextPath}/admin/system-config" method="POST" class="modal-content" style="border-radius: var(--radius-lg);">
                <input type="hidden" name="action" value="create">
                <input type="hidden" name="groupFilter" value="${groupFilter}">
                <div class="modal-header" style="border-bottom: 1px solid var(--outline-variant);">
                    <h5 class="modal-title fw-bold" id="createModalLabel">
                        <span class="material-symbols-outlined align-middle me-2" style="color: var(--primary); font-size: 20px;">add_circle</span>
                        Thêm Cấu Hình Mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label for="createConfigKey" class="form-label fw-bold">Khóa Cấu Hình (Key) <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="createConfigKey" name="configKey" required
                               style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md);">
                        <div class="form-text">Ví dụ: MAX_RETRY_COUNT (Viết hoa, ngăn cách bằng dấu gạch dưới). Key phải nằm trong whitelist.</div>
                    </div>
                    <div class="mb-3">
                        <label for="createConfigGroup" class="form-label fw-bold">Nhóm Cấu Hình <span class="text-danger">*</span></label>
                        <select class="form-select" id="createConfigGroup" name="configGroup" required style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md);">
                            <option value="library">Library (Chính sách Thư viện)</option>
                            <option value="system">System (Hệ thống toàn cầu)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="createDescription" class="form-label fw-bold">Mô tả chi tiết</label>
                        <input type="text" class="form-control" id="createDescription" name="description"
                               style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md);">
                    </div>
                    <div class="mb-3">
                        <label for="createConfigValue" class="form-label fw-bold">Giá Trị <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="createConfigValue" name="configValue" required
                               style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md);">
                    </div>
                </div>
                <div class="modal-footer" style="border-top: 1px solid var(--outline-variant);">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary-custom rounded-2 d-flex align-items-center gap-2">
                        <span class="material-symbols-outlined" style="font-size: 16px;">add</span>
                        Tạo Cấu Hình
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Cập Nhật Cấu Hình -->
    <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <form action="${pageContext.request.contextPath}/admin/system-config" method="POST" class="modal-content" style="border-radius: var(--radius-lg);">
                <div class="modal-header" style="border-bottom: 1px solid var(--outline-variant);">
                    <h5 class="modal-title fw-bold" id="editModalLabel">
                        <span class="material-symbols-outlined align-middle me-2" style="color: var(--primary); font-size: 20px;">tune</span>
                        Cập nhật cấu hình toàn cầu
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <input type="hidden" name="configKey" id="modalConfigKey">
                    <input type="hidden" name="groupFilter" value="${groupFilter}">

                    <div class="mb-3">
                        <label class="d-block mb-1 fw-bold text-on-surface-variant text-uppercase"
                               style="font-size: 10px; letter-spacing: 0.08em;">Mô tả cấu hình</label>
                        <p id="modalConfigDesc" class="text-muted mb-0 p-3 rounded-2" style="font-size: 13.5px; background: var(--surface-container-low); border: 1px solid var(--outline-variant);"></p>
                    </div>

                    <div class="mb-3">
                        <label for="modalConfigValue" class="form-label fw-bold">Giá trị mới <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="modalConfigValue" name="configValue" required
                               style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md);">
                    </div>
                </div>
                <div class="modal-footer" style="border-top: 1px solid var(--outline-variant);">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary-custom rounded-2 d-flex align-items-center gap-2">
                        <span class="material-symbols-outlined" style="font-size: 16px;">save</span>
                        Lưu Thay Đổi
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function prefillModal(key, value, desc) {
            document.getElementById('modalConfigKey').value = key;
            document.getElementById('modalConfigValue').value = value;
            document.getElementById('modalConfigDesc').textContent = desc;
        }
    </script>
</body>
</html>
