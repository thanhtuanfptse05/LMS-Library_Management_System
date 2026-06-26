<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp">
    <jsp:param name="title" value="Cấu hình Thư viện | Quản lý" />
</jsp:include>

<style>
    /* Premium Scholastic CSS overrides matching ui_rule.md */
    .config-card {
        background: #ffffff;
        border: 1px solid #e5e5e5;
        border-radius: 12px;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.04), 0 2px 4px -1px rgba(0, 0, 0, 0.02);
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    
    /* Modern Monospace Font Stack */
    .font-code {
        font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
        font-size: 12.5px;
        letter-spacing: -0.02em;
    }
    
    /* Config Key tag style */
    .config-key-badge {
        color: #1e293b;
        background-color: #f1f5f9;
        border: 1px solid #e2e8f0;
        padding: 5px 10px;
        border-radius: 6px;
        display: inline-block;
        word-break: break-all;
    }
    
    /* Config Value box */
    .config-val-box {
        background-color: #fef3c7; /* Warm background */
        border: 1px solid #fde68a;
        color: #b45309; /* Dark warm terracotta highlight */
        padding: 4px 12px;
        border-radius: 6px;
        font-weight: 700;
        display: inline-block;
        box-shadow: inset 0 1px 1px rgba(0,0,0,0.02);
    }
    
    /* Custom button tweaks */
    .btn-action {
        border-radius: 8px;
        padding: 6px 14px;
        font-size: 13px;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        transition: all 0.15s ease;
        height: 34px;
    }
    .btn-action-edit {
        background-color: #fcf6f0;
        color: #d97706;
        border: 1px solid #f5e3d1;
    }
    .btn-action-edit:hover {
        background-color: #d97706;
        color: #ffffff;
        border-color: #d97706;
    }
    .btn-action-delete {
        background-color: #fef2f2;
        color: #ef4444;
        border: 1px solid #fee2e2;
    }
    .btn-action-delete:hover {
        background-color: #ef4444;
        color: #ffffff;
        border-color: #ef4444;
    }
    
    /* Table style overrides */
    .table-lms thead th {
        background-color: #f8f7f6 !important; /* Soft warm gray background */
        border-bottom: 2px solid #e5e5e5 !important;
        color: #262626 !important;
        font-weight: 700 !important;
        font-size: 11.5px !important;
        text-transform: uppercase !important;
        letter-spacing: 0.06em !important;
        padding: 14px 18px !important;
    }
    
    .table-lms tbody td {
        padding: 16px 18px !important;
        border-bottom: 1px solid #f1f1f1 !important;
    }
    
    .table-lms tbody tr {
        transition: background-color 0.15s ease;
    }
    .table-lms tbody tr:hover {
        background-color: #fafaf9 !important;
    }
</style>

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
                <div class="page-header d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="mb-1" style="font-size: 22px; font-weight: 700; color: var(--on-surface);">
                            <span class="material-symbols-outlined align-middle me-2" style="font-size: 26px; color: var(--primary); font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24;">settings</span>
                            Cấu hình Chính sách Thư viện
                        </h2>
                        <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Quản lý các thông số mượn trả, gia hạn, đặt trước và tiền phạt</p>
                    </div>
                    <div>
                        <button type="button" class="btn btn-primary-custom rounded-3 fw-bold px-4 d-flex align-items-center gap-2" style="height: 42px; border-radius: 8px;" data-bs-toggle="modal" data-bs-target="#createModal">
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

                <!-- ─── Bảng danh sách cấu hình ─── -->
                <div class="card config-card overflow-hidden">
                    <div class="card-header bg-white py-3 px-4 border-bottom d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="mb-0 fw-bold" style="color: var(--on-surface); font-size: 16px;">Danh sách Cấu hình Chính sách</h5>
                            <p class="text-muted mb-0" style="font-size: 12.5px;">Chỉ hiển thị nhóm cấu hình bạn có quyền chỉnh sửa (<strong>library</strong>)</p>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-lms table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th style="width: 25%; min-width: 200px;">Khóa Cấu Hình</th>
                                    <th style="width: 32%; min-width: 300px;">Mô Tả</th>
                                    <th style="width: 14%; min-width: 110px;" class="text-center">Giá Trị</th>
                                    <th style="width: 15%; min-width: 140px;">Cập Nhật Bởi</th>
                                    <th style="width: 12%; min-width: 120px;">Lần Cuối</th>
                                    <th style="width: 10%; min-width: 150px;" class="text-end">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cfg" items="${configs}">
                                    <tr>
                                        <td>
                                            <span class="font-code config-key-badge">
                                                <c:out value="${cfg.configKey}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <div style="font-size: 13px; color: #4b5563; line-height: 1.5; font-weight: 500;">
                                                <c:out value="${cfg.description}"/>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <span class="font-code config-val-box">
                                                <c:out value="${cfg.configValue}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <span class="material-symbols-outlined text-secondary" style="font-size: 18px;">account_circle</span>
                                                <span style="font-size: 13px; font-weight: 500; color: #374151;">
                                                    <c:out value="${cfg.updaterName}"/>
                                                </span>
                                            </div>
                                        </td>
                                        <td>
                                            <div style="font-size: 12px; color: #6b7280; font-weight: 500;">
                                                <fmt:formatDate value="${cfg.updatedAt}" pattern="dd/MM/yyyy"/>
                                                <div class="text-muted" style="font-size: 10.5px;"><fmt:formatDate value="${cfg.updatedAt}" pattern="HH:mm"/></div>
                                            </div>
                                        </td>
                                        <td class="text-end">
                                            <div class="d-inline-flex gap-1">
                                                <button type="button"
                                                        class="btn btn-action btn-action-edit"
                                                        data-bs-toggle="modal" data-bs-target="#editModal"
                                                        onclick="prefillModal('<c:out value="${cfg.configKey}"/>', '<c:out value="${cfg.configValue}"/>', '<c:out value="${cfg.description}"/>')">
                                                    <span class="material-symbols-outlined" style="font-size: 15px;">edit</span> Sửa
                                                </button>
                                                <form action="${pageContext.request.contextPath}/manager/system-config" method="POST" class="m-0" onsubmit="return confirm('Bạn có chắc chắn muốn xóa cấu hình này không?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="configKey" value="<c:out value="${cfg.configKey}"/>">
                                                    <button type="submit" class="btn btn-action btn-action-delete">
                                                        <span class="material-symbols-outlined" style="font-size: 15px;">delete</span> Xóa
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty configs}">
                                    <tr>
                                        <td colspan="6" class="text-center py-5">
                                            <span class="material-symbols-outlined d-block mb-2 text-muted" style="font-size: 40px;">inbox</span>
                                            <span style="color: var(--on-surface-variant); font-size: 13.5px; font-weight: 500;">Không có cấu hình nào.</span>
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
            <form action="${pageContext.request.contextPath}/manager/system-config" method="POST" class="modal-content" style="border-radius: 12px; border: 1px solid var(--outline-variant); overflow: hidden;">
                <input type="hidden" name="action" value="create">
                <!-- Mặc định Manager tạo configGroup="library" trong Backend -->
                <div class="modal-header bg-light" style="border-bottom: 1px solid var(--outline-variant);">
                    <h5 class="modal-title fw-bold" id="createModalLabel" style="font-size: 16px; color: var(--on-surface);">
                        <span class="material-symbols-outlined align-middle me-2" style="color: var(--primary); font-size: 20px;">add_circle</span>
                        Thêm Cấu Hình Mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4" style="color: #262626;">
                    <div class="mb-3">
                        <label for="createConfigKey" class="form-label fw-bold small text-uppercase text-secondary" style="font-size: 11px; letter-spacing: 0.05em;">Khóa Cấu Hình (Key) <span class="text-danger">*</span></label>
                        <input type="text" class="form-control px-3" id="createConfigKey" name="configKey" required placeholder="Ví dụ: MAX_BORROW_LIMIT"
                               style="border: 1.5px solid var(--outline-variant); border-radius: 8px; height: 42px; font-size: 14.5px;">
                        <div class="form-text mt-1 text-muted" style="font-size: 11.5px;">Viết hoa, dùng dấu gạch dưới làm dấu phân cách. Key phải nằm trong danh sách whitelist cho phép.</div>
                    </div>
                    <div class="mb-3">
                        <label for="createDescription" class="form-label fw-bold small text-uppercase text-secondary" style="font-size: 11px; letter-spacing: 0.05em;">Mô tả chi tiết</label>
                        <input type="text" class="form-control px-3" id="createDescription" name="description" placeholder="Nhập mục đích hoặc hướng dẫn cấu hình..."
                               style="border: 1.5px solid var(--outline-variant); border-radius: 8px; height: 42px; font-size: 14.5px;">
                    </div>
                    <div class="mb-3">
                        <label for="createConfigValue" class="form-label fw-bold small text-uppercase text-secondary" style="font-size: 11px; letter-spacing: 0.05em;">Giá Trị <span class="text-danger">*</span></label>
                        <input type="text" class="form-control px-3" id="createConfigValue" name="configValue" required placeholder="Nhập giá trị tham số..."
                               style="border: 1.5px solid var(--outline-variant); border-radius: 8px; height: 42px; font-size: 14.5px;">
                    </div>
                </div>
                <div class="modal-footer bg-light" style="border-top: 1px solid var(--outline-variant);">
                    <button type="button" class="btn btn-secondary border border-secondary-subtle" style="border-radius: 8px; font-size: 13.5px; font-weight: 600;" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary-custom px-4 d-flex align-items-center gap-2" style="border-radius: 8px; font-size: 13.5px; font-weight: 700; height: 38px;">
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
            <form action="${pageContext.request.contextPath}/manager/system-config" method="POST" class="modal-content" style="border-radius: 12px; border: 1px solid var(--outline-variant); overflow: hidden;">
                <div class="modal-header bg-light" style="border-bottom: 1px solid var(--outline-variant);">
                    <h5 class="modal-title fw-bold" id="editModalLabel" style="font-size: 16px; color: var(--on-surface);">
                        <span class="material-symbols-outlined align-middle me-2" style="color: var(--primary); font-size: 20px;">tune</span>
                        Cập nhật cấu hình
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4" style="color: #262626;">
                    <input type="hidden" name="configKey" id="modalConfigKey">

                    <div class="mb-3">
                        <label class="d-block mb-2 fw-bold small text-uppercase text-secondary"
                               style="font-size: 11px; letter-spacing: 0.05em;">Mô tả cấu hình</label>
                        <p id="modalConfigDesc" class="text-muted mb-0 p-3 rounded-3" style="font-size: 13.5px; background: #faf9f8; border: 1px solid var(--outline-variant); line-height: 1.5; font-weight: 500;"></p>
                    </div>

                    <div class="mb-3">
                        <label for="modalConfigValue" class="form-label fw-bold small text-uppercase text-secondary" style="font-size: 11px; letter-spacing: 0.05em;">Giá trị mới <span class="text-danger">*</span></label>
                        <input type="text" class="form-control px-3" id="modalConfigValue" name="configValue" required
                               style="border: 1.5px solid var(--outline-variant); border-radius: 8px; height: 42px; font-size: 14.5px;">
                        <div class="form-text mt-1 text-muted" style="font-size: 11.5px;">Vui lòng nhập định dạng số phù hợp (số nguyên hoặc số thực tuỳ cấu hình).</div>
                    </div>
                </div>
                <div class="modal-footer bg-light" style="border-top: 1px solid var(--outline-variant);">
                    <button type="button" class="btn btn-secondary border border-secondary-subtle" style="border-radius: 8px; font-size: 13.5px; font-weight: 600;" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary-custom px-4 d-flex align-items-center gap-2" style="border-radius: 8px; font-size: 13.5px; font-weight: 700; height: 38px;">
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
