<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ════════════════ BODY WRAPPER ════════════════ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <!-- ════════════════ MAIN CONTENT ════════════════ -->
        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1440px; margin: 0 auto;">

                <!-- ─── Page Title ─── -->
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <div class="d-flex align-items-center gap-3">
                        <div class="d-flex align-items-center justify-content-center rounded-3"
                             style="width: 48px; height: 48px; background: linear-gradient(135deg, #7c3aed 0%, #a78bfa 100%);">
                            <span class="material-symbols-outlined text-white" style="font-size: 26px; font-variation-settings: 'FILL' 1;">receipt_long</span>
                        </div>
                        <div>
                            <h1 class="mb-0 fw-bold" style="font-size: 22px; color: var(--on-surface);">Nhật ký Kiểm toán</h1>
                            <p class="mb-0 text-on-surface-variant" style="font-size: 13px;">Theo dõi và truy vết toàn bộ hoạt động thay đổi dữ liệu hệ thống</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge rounded-pill" style="background: var(--surface-container-high); color: var(--on-surface); font-size: 12px; padding: 6px 14px;">
                            <span class="material-symbols-outlined" style="font-size: 14px; vertical-align: middle;">database</span>
                            <c:out value="${totalRecords}" /> bản ghi
                        </span>
                    </div>
                </div>

                <!-- ─── Filter Card ─── -->
                <div class="card border-0 mb-4" style="border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.06);">
                    <div class="card-body p-3">
                        <form id="filterForm" method="get" action="${pageContext.request.contextPath}/admin/audit-log">
                            <div class="row g-2 align-items-end">
                                <!-- Dropdown Loại hành động -->
                                <div class="col-lg-2 col-md-4 col-6">
                                    <label class="form-label fw-semibold" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: var(--on-surface-variant);">
                                        Loại hành động
                                    </label>
                                    <select name="actionType" class="form-select form-select-sm" style="border-radius: 8px; font-size: 13px;">
                                        <option value="">Tất cả</option>
                                        <c:forEach var="at" items="${actionTypes}">
                                            <option value="${fn:escapeXml(at)}" ${filterActionType == at ? 'selected' : ''}>
                                                <c:out value="${at}" />
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <!-- Dropdown Đối tượng -->
                                <div class="col-lg-2 col-md-4 col-6">
                                    <label class="form-label fw-semibold" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: var(--on-surface-variant);">
                                        Đối tượng
                                    </label>
                                    <select name="entityName" class="form-select form-select-sm" style="border-radius: 8px; font-size: 13px;">
                                        <option value="">Tất cả</option>
                                        <c:forEach var="en" items="${entityNames}">
                                            <option value="${fn:escapeXml(en)}" ${filterEntityName == en ? 'selected' : ''}>
                                                <c:out value="${en}" />
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <!-- Input Email -->
                                <div class="col-lg-2 col-md-4 col-6">
                                    <label class="form-label fw-semibold" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: var(--on-surface-variant);">
                                        Email
                                    </label>
                                    <input type="text" name="email" class="form-control form-control-sm"
                                           placeholder="Nhập email..." value="${fn:escapeXml(filterEmail)}"
                                           style="border-radius: 8px; font-size: 13px;" />
                                </div>
                                <!-- Input Từ ngày -->
                                <div class="col-lg-2 col-md-3 col-6">
                                    <label class="form-label fw-semibold" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: var(--on-surface-variant);">
                                        Từ ngày
                                    </label>
                                    <input type="date" name="fromDate" class="form-control form-control-sm"
                                           value="${fn:escapeXml(filterFromDate)}"
                                           style="border-radius: 8px; font-size: 13px;" />
                                </div>
                                <!-- Input Đến ngày -->
                                <div class="col-lg-2 col-md-3 col-6">
                                    <label class="form-label fw-semibold" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: var(--on-surface-variant);">
                                        Đến ngày
                                    </label>
                                    <input type="date" name="toDate" class="form-control form-control-sm"
                                           value="${fn:escapeXml(filterToDate)}"
                                           style="border-radius: 8px; font-size: 13px;" />
                                </div>
                                <!-- Input Từ khóa -->
                                <div class="col-lg-2 col-md-3 col-6">
                                    <label class="form-label fw-semibold" style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: var(--on-surface-variant);">
                                        Từ khóa
                                    </label>
                                    <input type="text" name="keyword" class="form-control form-control-sm"
                                           placeholder="Tìm trong giá trị..." value="${fn:escapeXml(filterKeyword)}"
                                           style="border-radius: 8px; font-size: 13px;" />
                                </div>
                            </div>
                            <div class="d-flex justify-content-end gap-2 mt-3">
                                <a href="${pageContext.request.contextPath}/admin/audit-log"
                                   class="btn btn-sm btn-light" style="border-radius: 8px; font-size: 13px;">
                                    <span class="material-symbols-outlined" style="font-size: 16px; vertical-align: middle;">restart_alt</span>
                                    Đặt lại
                                </a>
                                <button type="submit" class="btn btn-sm text-white" style="border-radius: 8px; font-size: 13px; background: #d97706;">
                                    <span class="material-symbols-outlined" style="font-size: 16px; vertical-align: middle;">filter_list</span>
                                    Lọc
                                </button>
                                <button type="button" id="btnExportCSV" class="btn btn-sm btn-outline-secondary" style="border-radius: 8px; font-size: 13px;">
                                    <span class="material-symbols-outlined" style="font-size: 16px; vertical-align: middle;">download</span>
                                    Xuất CSV
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- ─── Data Table ─── -->
                <div class="card border-0" style="border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.06);">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0" style="font-size: 13px;">
                                <thead>
                                    <tr style="background: #f4f3f2;">
                                        <th class="fw-semibold px-3 py-3" style="color: var(--on-surface-variant); width: 60px;">ID</th>
                                        <th class="fw-semibold px-3 py-3" style="color: var(--on-surface-variant); min-width: 150px;">Thời gian</th>
                                        <th class="fw-semibold px-3 py-3" style="color: var(--on-surface-variant); min-width: 160px;">Người thực hiện</th>
                                        <th class="fw-semibold px-3 py-3" style="color: var(--on-surface-variant); min-width: 140px;">Loại hành động</th>
                                        <th class="fw-semibold px-3 py-3" style="color: var(--on-surface-variant); min-width: 120px;">Đối tượng</th>
                                        <th class="fw-semibold px-3 py-3 text-end" style="color: var(--on-surface-variant); width: 80px;">ID ĐT</th>
                                        <th class="fw-semibold px-3 py-3 text-center" style="color: var(--on-surface-variant); width: 80px;">Chi tiết</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty auditLogs}">
                                            <tr>
                                                <td colspan="7" class="text-center py-5">
                                                    <span class="material-symbols-outlined d-block mx-auto mb-2" style="font-size: 48px; color: var(--outline-variant);">search_off</span>
                                                    <p class="mb-0 text-on-surface-variant" style="font-size: 14px;">Không tìm thấy bản ghi nào phù hợp</p>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="log" items="${auditLogs}">
                                                <tr class="audit-row" style="cursor: pointer;"
                                                    data-audit-id="${log.auditLogId}"
                                                    data-action-type="${fn:escapeXml(log.actionType)}"
                                                    data-entity-name="${fn:escapeXml(log.entityName)}"
                                                    data-entity-id="${log.entityId}"
                                                    data-user-email="${fn:escapeXml(log.userEmail)}"
                                                    data-timestamp="${log.timestamp}"
                                                    data-old="${fn:escapeXml(log.oldValues)}"
                                                    data-new="${fn:escapeXml(log.newValues)}">
                                                    <td class="px-3 py-2 text-on-surface-variant">${log.auditLogId}</td>
                                                    <td class="px-3 py-2">
                                                        <fmt:formatDate value="${log.timestamp}" pattern="dd/MM/yyyy HH:mm:ss" />
                                                    </td>
                                                    <td class="px-3 py-2">
                                                        <c:choose>
                                                            <c:when test="${log.userId == null}">
                                                                <span class="d-inline-flex align-items-center gap-1" style="color: #737373;">
                                                                    <span class="material-symbols-outlined" style="font-size: 15px;">smart_toy</span>
                                                                    Hệ thống
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:out value="${log.userEmail}" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="px-3 py-2">
                                                        <span class="badge rounded-pill audit-badge-${fn:escapeXml(log.actionType)}"
                                                              style="font-size: 11px; font-weight: 600; padding: 4px 10px;">
                                                            <c:out value="${log.actionType}" />
                                                        </span>
                                                    </td>
                                                    <td class="px-3 py-2"><c:out value="${log.entityName}" default="—" /></td>
                                                    <td class="px-3 py-2 text-end">${log.entityId != null ? log.entityId : '—'}</td>
                                                    <td class="px-3 py-2 text-center">
                                                        <button type="button" class="btn btn-sm btn-light btn-detail-audit"
                                                                style="border-radius: 8px; padding: 3px 10px;"
                                                                title="Xem chi tiết">
                                                            <span class="material-symbols-outlined" style="font-size: 18px; color: #7c3aed;">visibility</span>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- ─── Pagination ─── -->
                    <c:if test="${totalPages > 1}">
                        <div class="card-footer bg-transparent border-0 d-flex justify-content-between align-items-center px-3 py-3">
                            <span style="font-size: 12px; color: var(--on-surface-variant);">
                                Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                                (tổng <strong>${totalRecords}</strong> bản ghi)
                            </span>
                            <nav>
                                <ul class="pagination pagination-sm mb-0" style="gap: 2px;">
                                    <!-- Trang trước -->
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" style="border-radius: 6px;"
                                               href="${pageContext.request.contextPath}/admin/audit-log?page=${currentPage - 1}&actionType=${fn:escapeXml(filterActionType)}&entityName=${fn:escapeXml(filterEntityName)}&email=${fn:escapeXml(filterEmail)}&fromDate=${fn:escapeXml(filterFromDate)}&toDate=${fn:escapeXml(filterToDate)}&keyword=${fn:escapeXml(filterKeyword)}">
                                                <span class="material-symbols-outlined" style="font-size: 16px;">chevron_left</span>
                                            </a>
                                        </li>
                                    </c:if>

                                    <!-- Số trang -->
                                    <c:set var="startPage" value="${currentPage - 2 < 1 ? 1 : currentPage - 2}" />
                                    <c:set var="endPage" value="${startPage + 4 > totalPages ? totalPages : startPage + 4}" />
                                    <c:if test="${endPage - startPage < 4 && startPage > 1}">
                                        <c:set var="startPage" value="${endPage - 4 < 1 ? 1 : endPage - 4}" />
                                    </c:if>

                                    <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link" style="border-radius: 6px; ${i == currentPage ? 'background: #d97706; border-color: #d97706;' : ''}"
                                               href="${pageContext.request.contextPath}/admin/audit-log?page=${i}&actionType=${fn:escapeXml(filterActionType)}&entityName=${fn:escapeXml(filterEntityName)}&email=${fn:escapeXml(filterEmail)}&fromDate=${fn:escapeXml(filterFromDate)}&toDate=${fn:escapeXml(filterToDate)}&keyword=${fn:escapeXml(filterKeyword)}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <!-- Trang sau -->
                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" style="border-radius: 6px;"
                                               href="${pageContext.request.contextPath}/admin/audit-log?page=${currentPage + 1}&actionType=${fn:escapeXml(filterActionType)}&entityName=${fn:escapeXml(filterEntityName)}&email=${fn:escapeXml(filterEmail)}&fromDate=${fn:escapeXml(filterFromDate)}&toDate=${fn:escapeXml(filterToDate)}&keyword=${fn:escapeXml(filterKeyword)}">
                                                <span class="material-symbols-outlined" style="font-size: 16px;">chevron_right</span>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </div>
                    </c:if>
                </div>

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div>

    <!-- ════════════════ DETAIL MODAL ════════════════ -->
    <div class="modal fade" id="auditDetailModal" tabindex="-1" aria-labelledby="auditDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable">
            <div class="modal-content" style="border-radius: 16px; border: none;">
                <div class="modal-header border-0 pb-0" style="padding: 20px 24px 12px;">
                    <div>
                        <h5 class="modal-title fw-bold" id="auditDetailModalLabel" style="font-size: 18px; color: var(--on-surface);">
                            <span class="material-symbols-outlined me-1" style="font-size: 22px; vertical-align: middle; color: #7c3aed; font-variation-settings: 'FILL' 1;">visibility</span>
                            Chi tiết Nhật ký
                        </h5>
                        <p id="modalSubtitle" class="mb-0 text-on-surface-variant" style="font-size: 12px;"></p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body px-4 py-3">
                    <!-- Thông tin chung -->
                    <div class="row g-2 mb-4">
                        <div class="col-md-6">
                            <div class="p-3 rounded-3" style="background: var(--surface-container-low);">
                                <p class="mb-1 fw-semibold" style="font-size: 11px; text-transform: uppercase; color: var(--on-surface-variant); letter-spacing: 0.05em;">Thời gian</p>
                                <p id="modalTimestamp" class="mb-0 fw-bold" style="font-size: 14px;"></p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="p-3 rounded-3" style="background: var(--surface-container-low);">
                                <p class="mb-1 fw-semibold" style="font-size: 11px; text-transform: uppercase; color: var(--on-surface-variant); letter-spacing: 0.05em;">Người thực hiện</p>
                                <p id="modalEmail" class="mb-0 fw-bold" style="font-size: 14px;"></p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 rounded-3" style="background: var(--surface-container-low);">
                                <p class="mb-1 fw-semibold" style="font-size: 11px; text-transform: uppercase; color: var(--on-surface-variant); letter-spacing: 0.05em;">Loại hành động</p>
                                <p id="modalActionType" class="mb-0 fw-bold" style="font-size: 14px;"></p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 rounded-3" style="background: var(--surface-container-low);">
                                <p class="mb-1 fw-semibold" style="font-size: 11px; text-transform: uppercase; color: var(--on-surface-variant); letter-spacing: 0.05em;">Đối tượng</p>
                                <p id="modalEntityName" class="mb-0 fw-bold" style="font-size: 14px;"></p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 rounded-3" style="background: var(--surface-container-low);">
                                <p class="mb-1 fw-semibold" style="font-size: 11px; text-transform: uppercase; color: var(--on-surface-variant); letter-spacing: 0.05em;">ID Đối tượng</p>
                                <p id="modalEntityId" class="mb-0 fw-bold" style="font-size: 14px;"></p>
                            </div>
                        </div>
                    </div>

                    <!-- So sánh Old ↔ New -->
                    <h6 class="fw-bold mb-3" style="font-size: 14px; color: var(--on-surface);">
                        <span class="material-symbols-outlined me-1" style="font-size: 18px; vertical-align: middle;">compare_arrows</span>
                        So sánh thay đổi
                    </h6>
                    <div id="modalCompareContainer">
                        <!-- JS sẽ render nội dung cards ở đây -->
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0" style="padding: 12px 24px 20px;">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal" style="border-radius: 8px; font-size: 13px;">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ════════════════ PAGE-SPECIFIC STYLES ════════════════ -->
    <style>
        /* Mặc định cho các loại hành động khác chưa định nghĩa */
        [class^="audit-badge-"] {
            background: rgba(100, 116, 139, 0.12); color: #475569;
        }
        /* Badge màu theo nhóm actionType (FR-F12-02) */
        /* Hệ thống/Gửi Email — xanh xám */
        [class*="audit-badge-SYSTEM_EMAIL"], [class*="audit-badge-SYSTEM"] {
            background: rgba(100, 116, 139, 0.12) !important; color: #475569 !important;
        }
        /* Tạo mới — xanh lá */
        [class*="audit-badge-CREATE"], [class*="audit-badge-IMPORT"] {
            background: rgba(16, 185, 129, 0.12) !important; color: #059669 !important;
        }
        /* Cập nhật — vàng */
        [class*="audit-badge-UPDATE"], [class*="audit-badge-EDIT"], [class*="audit-badge-RESTORE"] {
            background: rgba(245, 158, 11, 0.12) !important; color: #b45309 !important;
        }
        /* Xóa/Hủy — đỏ */
        [class*="audit-badge-DELETE"], [class*="audit-badge-CANCEL"], [class*="audit-badge-SUSPEND"],
        [class*="audit-badge-LOCK"], [class*="audit-badge-REJECT"] {
            background: rgba(239, 68, 68, 0.12) !important; color: #dc2626 !important;
        }
        /* Giao dịch — xanh dương */
        [class*="audit-badge-CHECK_OUT"], [class*="audit-badge-CHECK_IN"], [class*="audit-badge-BORROW"],
        [class*="audit-badge-RETURN"], [class*="audit-badge-RESERVE"], [class*="audit-badge-EXTEND"] {
            background: rgba(59, 130, 246, 0.12) !important; color: #2563eb !important;
        }
        /* Bảo mật — tím */
        [class*="audit-badge-CHANGE_PASSWORD"], [class*="audit-badge-LOGIN"], [class*="audit-badge-LOGOUT"],
        [class*="audit-badge-RESET_PASSWORD"], [class*="audit-badge-UNLOCK"] {
            background: rgba(124, 58, 237, 0.12) !important; color: #7c3aed !important;
        }
        /* Thanh toán — cam */
        [class*="audit-badge-CASH_PAYMENT"], [class*="audit-badge-PAYMENT"], [class*="audit-badge-FINE"] {
            background: rgba(249, 115, 22, 0.12) !important; color: #ea580c !important;
        }

        /* Card so sánh trong modal */
        .compare-card-old {
            background: #fef2f2; border: 1px solid #fecaca; border-radius: 10px; padding: 12px 16px;
        }
        .compare-card-new {
            background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 10px; padding: 12px 16px;
        }
        .compare-card-label {
            font-size: 10px; text-transform: uppercase; letter-spacing: 0.08em; font-weight: 700; margin-bottom: 4px;
        }
        .compare-card-key {
            font-size: 12px; font-weight: 600; color: var(--on-surface); margin-bottom: 2px;
        }
        .compare-card-value {
            font-size: 13px; color: var(--on-surface-variant); word-break: break-all;
        }

        /* Raw text fallback card */
        .compare-raw-card {
            background: var(--surface-container-low); border: 1px solid var(--outline-variant); border-radius: 10px; padding: 14px 16px;
        }

        /* Hover hiệu ứng trên dòng bảng */
        .audit-row:hover { background: rgba(124, 58, 237, 0.03) !important; }

        /* Security message */
        .security-message {
            background: rgba(124, 58, 237, 0.06); border: 1px solid rgba(124, 58, 237, 0.15);
            border-radius: 10px; padding: 16px; text-align: center; color: #7c3aed; font-size: 13px;
        }
    </style>

    <!-- ════════════════ PAGE-SPECIFIC SCRIPTS ════════════════ -->
    <script>
    (function() {
        /* ─── Export CSV ─── */
        var btnExport = document.getElementById('btnExportCSV');
        if (btnExport) {
            btnExport.addEventListener('click', function() {
                var form = document.getElementById('filterForm');
                var params = new URLSearchParams(new FormData(form));
                params.set('action', 'export');
                params.delete('page');
                window.location.href = form.action + '?' + params.toString();
            });
        }

        /* ─── Detail Modal ─── */
        var modal = new bootstrap.Modal(document.getElementById('auditDetailModal'));

        document.querySelectorAll('.btn-detail-audit').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                var row = btn.closest('.audit-row');
                openDetailModal(row);
            });
        });

        document.querySelectorAll('.audit-row').forEach(function(row) {
            row.addEventListener('dblclick', function() {
                openDetailModal(row);
            });
        });

        function openDetailModal(row) {
            var auditId = row.getAttribute('data-audit-id');
            var actionType = row.getAttribute('data-action-type');
            var entityName = row.getAttribute('data-entity-name');
            var entityId = row.getAttribute('data-entity-id');
            var userEmail = row.getAttribute('data-user-email');
            var timestamp = row.getAttribute('data-timestamp');
            var oldVal = row.getAttribute('data-old');
            var newVal = row.getAttribute('data-new');

            document.getElementById('modalSubtitle').textContent = 'Mã nhật ký: #' + auditId;
            document.getElementById('modalTimestamp').textContent = formatTimestamp(timestamp);
            document.getElementById('modalEmail').textContent = userEmail ? userEmail : 'Hệ thống';
            document.getElementById('modalActionType').textContent = actionType || '—';
            document.getElementById('modalEntityName').textContent = entityName || '—';
            document.getElementById('modalEntityId').textContent = entityId || '—';

            var container = document.getElementById('modalCompareContainer');
            container.innerHTML = '';

            /* FR-F12-10: CHANGE_PASSWORD → thông báo bảo mật */
            if (actionType === 'CHANGE_PASSWORD' || actionType === 'RESET_PASSWORD') {
                var isEmptyJson = isEmptyJsonObj(oldVal) && isEmptyJsonObj(newVal);
                if (isEmptyJson || (!oldVal && !newVal)) {
                    container.innerHTML = '<div class="security-message">' +
                        '<span class="material-symbols-outlined" style="font-size: 24px; vertical-align: middle;">lock</span> ' +
                        'Mật khẩu đã được thay đổi (không hiển thị giá trị vì lý do bảo mật)</div>';
                    modal.show();
                    return;
                }
            }

            var oldObj = tryParseJSON(oldVal);
            var newObj = tryParseJSON(newVal);

            /* Cả hai đều parse được JSON → so sánh card-by-card */
            if (oldObj !== null || newObj !== null) {
                renderCardComparison(container, oldObj, newObj, actionType);
            } else {
                /* FR-F12-11: fallback raw text */
                renderRawFallback(container, oldVal, newVal);
            }

            modal.show();
        }

        function renderCardComparison(container, oldObj, newObj, actionType) {
            var allKeys = new Set();
            if (oldObj) Object.keys(oldObj).forEach(function(k) { allKeys.add(k); });
            if (newObj) Object.keys(newObj).forEach(function(k) { allKeys.add(k); });

            if (allKeys.size === 0) {
                container.innerHTML = '<p class="text-center text-on-surface-variant" style="font-size: 13px;">Không có dữ liệu thay đổi</p>';
                return;
            }

            /* Header row */
            var headerHtml = '<div class="row g-2 mb-2">' +
                '<div class="col-6"><p class="compare-card-label" style="color: #dc2626;">Giá trị cũ</p></div>' +
                '<div class="col-6"><p class="compare-card-label" style="color: #16a34a;">Giá trị mới</p></div>' +
                '</div>';
            container.innerHTML += headerHtml;

            allKeys.forEach(function(key) {
                var oldValue = (oldObj && oldObj[key] !== undefined) ? String(oldObj[key]) : '—';
                var newValue = (newObj && newObj[key] !== undefined) ? String(newObj[key]) : '—';

                var rowHtml = '<div class="row g-2 mb-2">' +
                    '<div class="col-6">' +
                        '<div class="compare-card-old">' +
                            '<p class="compare-card-key">' + escapeHtml(key) + '</p>' +
                            '<p class="compare-card-value mb-0">' + escapeHtml(oldValue) + '</p>' +
                        '</div>' +
                    '</div>' +
                    '<div class="col-6">' +
                        '<div class="compare-card-new">' +
                            '<p class="compare-card-key">' + escapeHtml(key) + '</p>' +
                            '<p class="compare-card-value mb-0">' + escapeHtml(newValue) + '</p>' +
                        '</div>' +
                    '</div>' +
                    '</div>';
                container.innerHTML += rowHtml;
            });
        }

        function renderRawFallback(container, oldVal, newVal) {
            var html = '<div class="row g-2">';

            html += '<div class="col-6">' +
                '<p class="compare-card-label" style="color: #dc2626;">Giá trị cũ</p>' +
                '<div class="compare-raw-card">' +
                    '<p class="compare-card-value mb-0">' + escapeHtml(oldVal || '—') + '</p>' +
                '</div></div>';

            html += '<div class="col-6">' +
                '<p class="compare-card-label" style="color: #16a34a;">Giá trị mới</p>' +
                '<div class="compare-raw-card">' +
                    '<p class="compare-card-value mb-0">' + escapeHtml(newVal || '—') + '</p>' +
                '</div></div>';

            html += '</div>';
            container.innerHTML = html;
        }

        function tryParseJSON(str) {
            if (!str || str.trim() === '') return null;
            try {
                var obj = JSON.parse(str);
                if (typeof obj === 'object' && obj !== null && !Array.isArray(obj)) {
                    return obj;
                }
                return null;
            } catch (e) {
                return null;
            }
        }

        function isEmptyJsonObj(str) {
            if (!str) return true;
            try {
                var obj = JSON.parse(str.trim());
                return typeof obj === 'object' && obj !== null && Object.keys(obj).length === 0;
            } catch(e) {
                return str.trim() === '' || str.trim() === '{}';
            }
        }

        function escapeHtml(text) {
            if (!text) return '';
            var div = document.createElement('div');
            div.appendChild(document.createTextNode(text));
            return div.innerHTML;
        }

        function formatTimestamp(ts) {
            if (!ts) return '—';
            try {
                var d = new Date(ts);
                if (isNaN(d.getTime())) return ts;
                var pad = function(n) { return n < 10 ? '0' + n : n; };
                return pad(d.getDate()) + '/' + pad(d.getMonth()+1) + '/' + d.getFullYear() + ' ' +
                       pad(d.getHours()) + ':' + pad(d.getMinutes()) + ':' + pad(d.getSeconds());
            } catch(e) {
                return ts;
            }
        }
    })();
    </script>

</body>
</html>
