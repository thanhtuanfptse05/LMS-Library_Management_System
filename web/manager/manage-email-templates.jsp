<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
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

            <div class="container-fluid px-4 py-4" style="max-width: 1300px; margin: 0 auto;">

                <!-- ─── Breadcrumb ─── -->
                <nav class="mb-2 d-flex align-items-center gap-1 text-muted small fw-semibold text-uppercase"
                     aria-label="breadcrumb" style="font-size: 12px; letter-spacing: 0.05em;">
                    <a class="text-decoration-none text-muted" href="${pageContext.request.contextPath}/manager/dashboard">Bảng điều khiển</a>
                    <span class="material-symbols-outlined fs-6">chevron_right</span>
                    <span style="color: var(--on-surface);">Mẫu Email</span>
                </nav>

                <!-- ─── Page Title ─── -->
                <div class="d-flex justify-content-between align-items-start mb-5 flex-wrap gap-3">
                    <div>
                        <h1 class="fw-bold mb-1" style="font-size: 28px; color: var(--on-surface);">
                            <span class="material-symbols-outlined me-2 align-middle"
                                  style="font-size: 30px; color: var(--primary); font-variation-settings: 'FILL' 1;">mail</span>
                            Quản lý Mẫu Email
                        </h1>
                        <p style="color: var(--on-surface-variant); font-size: 14px;" class="mb-0">
                            Tùy chỉnh nội dung các mẫu email hệ thống gửi tự động. Thay đổi sẽ có hiệu lực ngay lập tức.
                        </p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <div class="px-3 py-2 rounded-3 d-flex align-items-center gap-2"
                             style="background: linear-gradient(135deg, rgba(157,67,0,0.08), rgba(249,115,22,0.05)); border: 1px solid rgba(157,67,0,0.15);">
                            <span class="material-symbols-outlined" style="color: var(--primary); font-size: 18px;">mail_outline</span>
                            <span class="fw-bold" style="font-size: 22px; color: var(--primary);">${templates.size()}</span>
                            <span style="font-size: 12px; color: var(--on-surface-variant);">mẫu email</span>
                        </div>
                    </div>
                </div>

                <!-- ─── Alert Messages ─── -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-dismissible fade show mb-4 d-flex align-items-center gap-2 rounded-3"
                         role="alert"
                         style="background: linear-gradient(135deg, rgba(22,163,74,0.08), rgba(22,163,74,0.04)); border: 1px solid rgba(22,163,74,0.25); color: #15803d;">
                        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1; color: #16a34a;">check_circle</span>
                        <span class="fw-semibold"><c:out value="${param.success}" /></span>
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                </c:if>
                <c:if test="${not empty param.error}">
                    <div class="alert alert-dismissible fade show mb-4 d-flex align-items-center gap-2 rounded-3"
                         role="alert"
                         style="background: linear-gradient(135deg, rgba(186,26,26,0.08), rgba(186,26,26,0.04)); border: 1px solid rgba(186,26,26,0.2); color: #93000a;">
                        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1; color: #ef4444;">error</span>
                        <span class="fw-semibold"><c:out value="${param.error}" /></span>
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                </c:if>

                <div class="row g-4">

                    <!-- ═══════════════════════════════════════════
                         LEFT: Danh sách + Thêm mới template
                    ═══════════════════════════════════════════ -->
                    <div class="col-12 col-xl-4">

                        <!-- Danh sách mẫu -->
                        <div class="raised-card overflow-hidden mb-4">
                            <div class="p-3 d-flex align-items-center justify-content-between"
                                 style="border-bottom: 1px solid var(--outline-variant); background-color: var(--surface-container-low);">
                                <div>
                                    <h5 class="fw-bold mb-0" style="color: var(--on-surface); font-size: 15px;">Danh sách mẫu</h5>
                                    <p class="mb-0 small" style="color: var(--on-surface-variant);">Tổng: ${templates.size()} mẫu</p>
                                </div>
                                <button class="btn btn-sm btn-primary-custom rounded-3 d-flex align-items-center gap-1"
                                        onclick="toggleCreateForm()" id="btnToggleCreate" title="Thêm mẫu mới">
                                    <span class="material-symbols-outlined" style="font-size: 16px;">add</span>
                                    Thêm mới
                                </button>
                            </div>

                            <div class="d-flex flex-column">
                                <c:forEach var="tmpl" items="${templates}">
                                    <a href="${pageContext.request.contextPath}/manager/email-templates?action=edit&tempId=${tmpl.tempId}"
                                       class="email-tmpl-item px-3 py-3 text-decoration-none d-flex align-items-start gap-3
                                              ${editTemplate != null and editTemplate.tempId == tmpl.tempId ? 'active-template' : ''}"
                                       style="border-bottom: 1px solid var(--outline-variant);">

                                        <!-- Màu icon theo tên mẫu -->
                                        <div class="rounded-2 d-flex align-items-center justify-content-center flex-shrink-0"
                                             style="width: 36px; height: 36px;
                                                    background: ${tmpl.tempName == 'URGENT_NOTIFICATION'
                                                        ? 'rgba(239,68,68,0.10)'
                                                        : tmpl.tempName == 'BORROW_SUCCESS'
                                                        ? 'rgba(22,163,74,0.10)'
                                                        : 'rgba(0,99,152,0.10)'};">
                                            <span class="material-symbols-outlined"
                                                  style="font-size: 18px; font-variation-settings: 'FILL' 1;
                                                         color: ${tmpl.tempName == 'URGENT_NOTIFICATION'
                                                             ? '#ef4444'
                                                             : tmpl.tempName == 'BORROW_SUCCESS'
                                                             ? '#16a34a'
                                                             : 'var(--tertiary)'};">
                                                ${tmpl.tempName == 'URGENT_NOTIFICATION' ? 'priority_high'
                                                  : tmpl.tempName == 'BORROW_SUCCESS'    ? 'check_circle'
                                                  : tmpl.tempName == 'RETURN_SUCCESS'    ? 'assignment_return'
                                                  : tmpl.tempName == 'FINE_WARNING'      ? 'warning'
                                                  : 'mail'}
                                            </span>
                                        </div>

                                        <div class="flex-grow-1 min-w-0">
                                            <p class="fw-bold mb-0 text-truncate" style="font-size: 13px; color: var(--on-surface);">
                                                <code style="background: transparent; color: inherit; padding: 0;">
                                                    <c:out value="${tmpl.tempName}" />
                                                </code>
                                            </p>
                                            <p class="mb-0 text-truncate" style="font-size: 12px; color: var(--on-surface-variant);">
                                                <c:out value="${tmpl.subject}" />
                                            </p>
                                            <span style="font-size: 10px; color: var(--on-surface-variant);">
                                                <c:choose>
                                                    <c:when test="${not empty tmpl.updatedAt}">
                                                        Sửa lần cuối: <fmt:formatDate value="${tmpl.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        Tạo: <fmt:formatDate value="${tmpl.createdAt}" pattern="dd/MM/yyyy" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <span class="material-symbols-outlined align-self-center"
                                              style="font-size: 16px; color: var(--on-surface-variant);">chevron_right</span>
                                    </a>
                                </c:forEach>

                                <c:if test="${empty templates}">
                                    <div class="text-center py-5">
                                        <span class="material-symbols-outlined d-block mb-2"
                                              style="font-size: 40px; color: var(--on-surface-variant); font-variation-settings: 'FILL' 0;">inbox</span>
                                        <p class="fw-semibold mb-1" style="color: var(--on-surface);">Chưa có mẫu nào</p>
                                        <p class="small mb-0" style="color: var(--on-surface-variant);">Nhấn "Thêm mới" để tạo mẫu đầu tiên.</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Form thêm mới template (ẩn mặc định) -->
                        <div class="raised-card p-4" id="createFormCard" style="display: none;">
                            <div class="d-flex align-items-center gap-2 mb-3">
                                <div class="rounded-2 d-flex align-items-center justify-content-center"
                                     style="width: 32px; height: 32px; background: linear-gradient(135deg, rgba(157,67,0,0.12), rgba(249,115,22,0.08));">
                                    <span class="material-symbols-outlined"
                                          style="color: var(--primary); font-size: 18px; font-variation-settings: 'FILL' 1;">add_circle</span>
                                </div>
                                <h6 class="fw-bold mb-0" style="color: var(--on-surface);">Tạo mẫu Email mới</h6>
                            </div>

                            <form method="post" action="${pageContext.request.contextPath}/manager/email-templates">
                                <input type="hidden" name="action" value="create">

                                <div class="mb-3">
                                    <label for="newTempName" class="form-label small fw-semibold"
                                           style="color: var(--on-surface-variant);">Mã định danh mẫu <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control rounded-3 font-monospace" id="newTempName"
                                           name="tempName" placeholder="VD: URGENT_NOTIFICATION"
                                           required style="font-size: 13px; text-transform: uppercase;"
                                           oninput="this.value = this.value.toUpperCase().replace(/\s/g,'_')">
                                    <div class="form-text" style="font-size: 11px;">Chỉ dùng chữ HOA và dấu gạch dưới.</div>
                                </div>

                                <div class="mb-3">
                                    <label for="newSubject" class="form-label small fw-semibold"
                                           style="color: var(--on-surface-variant);">Tiêu đề Email <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control rounded-3" id="newSubject"
                                           name="subject" placeholder="VD: [LMS] Thông báo: {{notificationTitle}}"
                                           required maxlength="255">
                                </div>

                                <div class="mb-3">
                                    <label for="newBody" class="form-label small fw-semibold"
                                           style="color: var(--on-surface-variant);">Nội dung HTML <span class="text-danger">*</span></label>
                                    <textarea class="form-control rounded-3 font-monospace" id="newBody"
                                              name="bodyContent" rows="8"
                                              style="font-size: 12px;" required></textarea>
                                </div>

                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary-custom flex-grow-1 rounded-3 fw-bold py-2">
                                        <span class="material-symbols-outlined me-1 align-middle">save</span>Tạo mẫu
                                    </button>
                                    <button type="button" class="btn rounded-3 py-2"
                                            onclick="toggleCreateForm()"
                                            style="background-color: var(--surface-container-high); color: var(--on-surface-variant);">Hủy</button>
                                </div>
                            </form>
                        </div>

                        <!-- Hướng dẫn Placeholders -->
                        <div class="raised-card p-4" id="placeholderGuide"
                             style="background: linear-gradient(135deg, var(--surface-container-low), var(--surface-container));">
                            <h6 class="fw-bold mb-3" style="color: var(--on-surface); font-size: 12px; text-transform: uppercase; letter-spacing: 0.05em;">
                                Placeholder được hỗ trợ
                            </h6>
                            <div class="d-flex flex-column gap-2" style="font-size: 12px;">
                                <div class="d-flex align-items-center gap-2">
                                    <code class="px-2 py-1 rounded-2" style="background: rgba(0,99,152,0.08); color: var(--tertiary); font-size: 11px;">{{userName}}</code>
                                    <span style="color: var(--on-surface-variant);">Tên người nhận</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <code class="px-2 py-1 rounded-2" style="background: rgba(239,68,68,0.08); color: #dc2626; font-size: 11px;">{{notificationTitle}}</code>
                                    <span style="color: var(--on-surface-variant);">Tiêu đề thông báo</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <code class="px-2 py-1 rounded-2" style="background: rgba(239,68,68,0.08); color: #dc2626; font-size: 11px;">{{notificationContent}}</code>
                                    <span style="color: var(--on-surface-variant);">Nội dung thông báo (HTML)</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <code class="px-2 py-1 rounded-2" style="background: rgba(22,163,74,0.08); color: #15803d; font-size: 11px;">{{bookTitle}}</code>
                                    <span style="color: var(--on-surface-variant);">Tên sách</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <code class="px-2 py-1 rounded-2" style="background: rgba(22,163,74,0.08); color: #15803d; font-size: 11px;">{{dueDate}}</code>
                                    <span style="color: var(--on-surface-variant);">Ngày đến hạn trả</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <code class="px-2 py-1 rounded-2" style="background: rgba(22,163,74,0.08); color: #15803d; font-size: 11px;">{{fineAmount}}</code>
                                    <span style="color: var(--on-surface-variant);">Số tiền phạt</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ═══════════════════════════════════════════
                         RIGHT: Editor / Preview
                    ═══════════════════════════════════════════ -->
                    <div class="col-12 col-xl-8">
                        <c:choose>
                            <c:when test="${not empty editTemplate}">
                                <!-- Form chỉnh sửa mẫu -->
                                <div class="raised-card overflow-hidden">

                                    <!-- Header editor -->
                                    <div class="px-4 py-3 d-flex align-items-center justify-content-between"
                                         style="border-bottom: 1px solid var(--outline-variant); background-color: var(--surface-container-low);">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="rounded-2 d-flex align-items-center justify-content-center"
                                                 style="width: 36px; height: 36px;
                                                        background: ${editTemplate.tempName == 'URGENT_NOTIFICATION' ? 'rgba(239,68,68,0.10)' : 'rgba(0,99,152,0.10)'};">
                                                <span class="material-symbols-outlined"
                                                      style="font-size: 18px; font-variation-settings: 'FILL' 1;
                                                             color: ${editTemplate.tempName == 'URGENT_NOTIFICATION' ? '#ef4444' : 'var(--tertiary)'};">
                                                    ${editTemplate.tempName == 'URGENT_NOTIFICATION' ? 'priority_high' : 'mail'}
                                                </span>
                                            </div>
                                            <div>
                                                <h5 class="fw-bold mb-0" style="color: var(--on-surface); font-size: 15px;">
                                                    Chỉnh sửa mẫu:
                                                    <code style="background: rgba(0,0,0,0.05); padding: 2px 8px; border-radius: 4px; font-size: 13px;">
                                                        <c:out value="${editTemplate.tempName}" />
                                                    </code>
                                                </h5>
                                                <p class="mb-0" style="font-size: 11px; color: var(--on-surface-variant);">
                                                    Thay đổi sẽ có hiệu lực ngay lập tức với các email gửi tiếp theo.
                                                </p>
                                            </div>
                                        </div>
                                        <!-- Tab toggle -->
                                        <div class="d-flex align-items-center gap-1 p-1 rounded-3"
                                             style="background-color: var(--surface-container);">
                                            <button type="button" class="btn btn-sm rounded-2 fw-semibold tab-btn active-tab"
                                                    id="tabEdit" onclick="switchTab('edit')" style="font-size: 12px; padding: 4px 12px;">
                                                <span class="material-symbols-outlined me-1 align-middle" style="font-size: 14px;">code</span>Soạn thảo
                                            </button>
                                            <button type="button" class="btn btn-sm rounded-2 fw-semibold tab-btn"
                                                    id="tabPreview" onclick="switchTab('preview')" style="font-size: 12px; padding: 4px 12px;">
                                                <span class="material-symbols-outlined me-1 align-middle" style="font-size: 14px;">preview</span>Xem thử
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Editor content -->
                                    <div class="p-4">
                                        <form method="post" action="${pageContext.request.contextPath}/manager/email-templates"
                                              id="editTemplateForm">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="tempId" value="${editTemplate.tempId}">

                                            <!-- Tên mẫu (readonly) -->
                                            <div class="mb-3">
                                                <label class="form-label small fw-semibold"
                                                       style="color: var(--on-surface-variant);">Mã định danh (Không thể thay đổi)</label>
                                                <div class="form-control rounded-3 d-flex align-items-center gap-2"
                                                     style="background: var(--surface-container-low); cursor: not-allowed;">
                                                    <span class="material-symbols-outlined" style="font-size: 16px; color: var(--on-surface-variant);">lock</span>
                                                    <code style="color: var(--on-surface-variant); background: transparent; padding: 0;">
                                                        <c:out value="${editTemplate.tempName}" />
                                                    </code>
                                                </div>
                                            </div>

                                            <!-- Tiêu đề email -->
                                            <div class="mb-3">
                                                <label for="emailSubject" class="form-label small fw-semibold"
                                                       style="color: var(--on-surface-variant);">
                                                    Tiêu đề Email <span class="text-danger">*</span>
                                                </label>
                                                <input type="text" class="form-control rounded-3" id="emailSubject"
                                                       name="subject"
                                                       value="<c:out value='${editTemplate.subject}'/>"
                                                       required maxlength="255">
                                            </div>

                                            <!-- Nội dung (Tab Edit / Tab Preview) -->
                                            <div id="panelEdit">
                                                <div class="mb-3">
                                                    <label for="emailBody" class="form-label small fw-semibold"
                                                           style="color: var(--on-surface-variant);">
                                                        Nội dung HTML <span class="text-danger">*</span>
                                                    </label>
                                                    <textarea class="form-control rounded-3 font-monospace" id="emailBody"
                                                              name="bodyContent" rows="16"
                                                              style="font-size: 12px; resize: vertical;"
                                                              oninput="syncPreview()"><c:out value="${editTemplate.bodyContent}" /></textarea>
                                                    <div class="form-text d-flex align-items-center gap-1 mt-2" style="font-size: 11px;">
                                                        <span class="material-symbols-outlined" style="font-size: 13px;">info</span>
                                                        Nhập HTML hoặc văn bản có Placeholder dạng <code>{{tenBien}}</code>. Khi gửi, dấu xuống dòng trong nội dung thông báo sẽ tự động được chuyển thành thẻ &lt;br&gt;.
                                                    </div>
                                                </div>
                                            </div>

                                            <div id="panelPreview" style="display:none;">
                                                <div class="mb-3">
                                                    <label class="form-label small fw-semibold"
                                                           style="color: var(--on-surface-variant);">Xem thử Email (dữ liệu giả)</label>
                                                    <div class="rounded-3 overflow-hidden"
                                                         style="border: 1px solid var(--outline-variant); min-height: 360px;">
                                                        <!-- Giả lập thanh tiêu đề email client -->
                                                        <div class="px-3 py-2 d-flex align-items-center gap-3"
                                                             style="background: #f8f8f8; border-bottom: 1px solid #eee; font-size: 12px;">
                                                            <span class="material-symbols-outlined" style="font-size: 16px; color: #888;">mail</span>
                                                            <div>
                                                                <span class="fw-semibold text-dark">Từ:</span>
                                                                <span class="text-secondary"> LMS University Library &lt;lms@university.edu.vn&gt;</span>
                                                            </div>
                                                        </div>
                                                        <!-- Tiêu đề preview -->
                                                        <div class="px-3 py-2"
                                                             style="background: #f8f8f8; border-bottom: 1px solid #eee;">
                                                            <span class="fw-semibold text-dark" style="font-size: 12px;">Tiêu đề: </span>
                                                            <span id="previewSubject" class="text-dark" style="font-size: 12px;"></span>
                                                        </div>
                                                        <!-- Body preview -->
                                                        <iframe id="previewFrame"
                                                                style="width:100%; height:340px; border:none; background:#fff;"
                                                                sandbox="allow-same-origin"></iframe>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="d-flex gap-2">
                                                <button type="submit" class="btn btn-primary-custom flex-grow-1 rounded-3 fw-bold py-2">
                                                    <span class="material-symbols-outlined me-1 align-middle">save</span>Lưu thay đổi
                                                </button>
                                                <button type="button" class="btn rounded-3 py-2 px-3 fw-semibold d-flex align-items-center gap-1"
                                                        style="color: var(--error); border: 1px solid rgba(186,26,26,0.2);"
                                                        onclick="confirmDeleteTemplate('${editTemplate.tempId}', '${editTemplate.tempName}')">
                                                    <span class="material-symbols-outlined" style="font-size: 18px;">delete</span>Xóa
                                                </button>
                                                <a href="${pageContext.request.contextPath}/manager/email-templates"
                                                   class="btn rounded-3 py-2 px-4"
                                                   style="background-color: var(--surface-container-high); color: var(--on-surface-variant);">Hủy</a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <!-- Trạng thái rỗng — Placeholder hướng dẫn -->
                                <div class="raised-card p-5 text-center h-100 d-flex flex-column align-items-center justify-content-center"
                                     style="min-height: 420px; border: 2px dashed var(--outline-variant);">
                                    <div class="rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                                         style="width: 80px; height: 80px; background: linear-gradient(135deg, rgba(157,67,0,0.06), rgba(249,115,22,0.04));">
                                        <span class="material-symbols-outlined"
                                              style="font-size: 36px; color: var(--primary); font-variation-settings: 'FILL' 0;">mail_outline</span>
                                    </div>
                                    <h5 class="fw-bold mb-1" style="color: var(--on-surface);">Chọn một mẫu Email để chỉnh sửa</h5>
                                    <p style="color: var(--on-surface-variant); font-size: 14px;" class="mb-4">
                                        Nhấp vào bất kỳ mẫu nào ở danh sách bên trái để xem và chỉnh sửa nội dung.
                                    </p>

                                    <!-- Hướng dẫn URGENT_NOTIFICATION -->
                                    <div class="rounded-3 p-3 text-start w-100"
                                         style="background: rgba(239,68,68,0.04); border: 1px solid rgba(239,68,68,0.15); max-width: 480px;">
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <span class="material-symbols-outlined" style="font-size: 18px; color: #ef4444; font-variation-settings: 'FILL' 1;">priority_high</span>
                                            <span class="fw-bold" style="font-size: 13px; color: #dc2626;">Lưu ý quan trọng</span>
                                        </div>
                                        <p class="small mb-1" style="color: var(--on-surface-variant);">
                                            Để bật tính năng <strong>gửi Email tự động</strong> khi đăng Thông báo Khẩn cấp,
                                            bạn cần tạo một mẫu email với mã định danh:
                                        </p>
                                        <code class="d-block px-3 py-2 rounded-2 text-center fw-bold"
                                              style="background: rgba(239,68,68,0.08); color: #dc2626; font-size: 14px; letter-spacing: 1px;">
                                            URGENT_NOTIFICATION
                                        </code>
                                        <p class="small mt-2 mb-0" style="color: var(--on-surface-variant);">
                                            Sử dụng các placeholder:
                                            <code style="color: #dc2626;">{{userName}}</code>,
                                            <code style="color: #dc2626;">{{notificationTitle}}</code>,
                                            <code style="color: #dc2626;">{{notificationContent}}</code>
                                        </p>
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

    <!-- ════════════════ Confirm Delete Modal ════════════════ -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 400px;">
            <div class="modal-content border-0 rounded-4 shadow-lg text-center p-4">
                <div class="mx-auto mb-3 d-flex align-items-center justify-content-center rounded-circle"
                     style="width: 64px; height: 64px; background-color: rgba(186,26,26,0.1);">
                    <span class="material-symbols-outlined" style="font-size: 32px; color: var(--error);">warning</span>
                </div>
                <h5 class="fw-bold mb-2">Xác nhận xóa mẫu email</h5>
                <p class="text-secondary small mb-4">Bạn có chắc chắn muốn xóa mẫu <code id="deleteTargetName"></code> không? Hành động này không thể hoàn tác.</p>
                <form method="post" action="${pageContext.request.contextPath}/manager/email-templates" class="d-flex gap-2 w-100">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="tempId" id="deleteTargetId">
                    <button type="button" class="btn btn-light flex-grow-1 rounded-3 fw-semibold" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger flex-grow-1 rounded-3 fw-semibold">Xóa ngay</button>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // ─── Sidebar active link ───
        document.querySelectorAll('.sidebar-link').forEach(link => {
            if (link.href === window.location.href.split('?')[0]) {
                link.classList.add('active');
            }
        });

        // ─── Toggle form tạo mới ───
        function toggleCreateForm() {
            const card = document.getElementById('createFormCard');
            const guide = document.getElementById('placeholderGuide');
            const isHidden = card.style.display === 'none';
            card.style.display = isHidden ? 'block' : 'none';
            guide.style.display = isHidden ? 'none' : 'block';
            if (isHidden) card.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }

        // ─── Xác nhận xóa ───
        function confirmDeleteTemplate(tempId, tempName) {
            document.getElementById('deleteTargetId').value = tempId;
            document.getElementById('deleteTargetName').textContent = tempName;
            new bootstrap.Modal(document.getElementById('deleteConfirmModal')).show();
        }

        // ─── Tab Edit / Preview ───
        function switchTab(tab) {
            const panelEdit = document.getElementById('panelEdit');
            const panelPreview = document.getElementById('panelPreview');
            const tabEdit = document.getElementById('tabEdit');
            const tabPreview = document.getElementById('tabPreview');

            if (tab === 'edit') {
                panelEdit.style.display = 'block';
                panelPreview.style.display = 'none';
                tabEdit.classList.add('active-tab');
                tabPreview.classList.remove('active-tab');
            } else {
                panelEdit.style.display = 'none';
                panelPreview.style.display = 'block';
                tabEdit.classList.remove('active-tab');
                tabPreview.classList.add('active-tab');
                renderPreview();
            }
        }

        // ─── Render Preview iframe ───
        function renderPreview() {
            const body = document.getElementById('emailBody');
            const subject = document.getElementById('emailSubject');
            const frame = document.getElementById('previewFrame');
            const previewSubject = document.getElementById('previewSubject');

            if (!body || !frame) return;

            // Thay placeholder bằng dữ liệu giả để xem thử
            let previewHtml = body.value
                .replace(/\{\{userName\}\}/g, 'Nguyễn Văn A')
                .replace(/\{\{notificationTitle\}\}/g, 'Thư viện tạm ngừng hoạt động')
                .replace(/\{\{notificationContent\}\}/g,
                    '<p style="color:#dc2626;">Thư viện sẽ đóng cửa từ 14:00 hôm nay để bảo trì hệ thống. Vui lòng hoàn trả sách trước giờ đóng cửa.</p>')
                .replace(/\{\{bookTitle\}\}/g, 'Giáo trình Lập trình Java')
                .replace(/\{\{dueDate\}\}/g, '30/06/2025')
                .replace(/\{\{fineAmount\}\}/g, '15.000 đồng')
                .replace(/\{\{barcode\}\}/g, 'LMS-2024-00123');

            const doc = frame.contentDocument || frame.contentWindow.document;
            doc.open();
            doc.write(previewHtml);
            doc.close();

            if (subject) {
                previewSubject.textContent = subject.value
                    .replace(/\{\{notificationTitle\}\}/g, 'Thư viện tạm ngừng hoạt động')
                    .replace(/\{\{userName\}\}/g, 'Nguyễn Văn A');
            }
        }

        function syncPreview() {
            const frame = document.getElementById('previewFrame');
            if (frame && document.getElementById('panelPreview').style.display !== 'none') {
                renderPreview();
            }
        }
    </script>

    <style>
        /* ─── Template list item ─── */
        .email-tmpl-item {
            transition: background-color 0.15s ease;
            color: inherit;
        }
        .email-tmpl-item:hover {
            background-color: var(--surface-container-low);
        }
        .active-template {
            background-color: var(--primary-fixed);
            border-left: 3px solid var(--primary) !important;
        }

        /* ─── Tabs ─── */
        .tab-btn {
            color: var(--on-surface-variant);
            background: transparent;
            border: none;
            transition: all 0.15s ease;
        }
        .tab-btn:hover {
            background-color: var(--surface-container-high);
            color: var(--on-surface);
        }
        .active-tab {
            background-color: white !important;
            color: var(--primary) !important;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08);
        }
    </style>

</body>
</html>
