<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <!-- ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ BODY WRAPPER ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ -->
    <div class="d-flex main-wrapper overflow-hidden">

        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: var(--background);">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1300px; margin: 0 auto;">

                <!-- ΓöÇΓöÇΓöÇ Breadcrumb ΓöÇΓöÇΓöÇ -->
                <nav class="mb-2 d-flex align-items-center gap-1 text-muted small fw-semibold text-uppercase"
                     aria-label="breadcrumb" style="font-size: 12px; letter-spacing: 0.05em;">
                    <a class="text-decoration-none text-muted" href="${pageContext.request.contextPath}/manager/dashboard">Bß║úng ─æiß╗üu khiß╗ân</a>
                    <span class="material-symbols-outlined fs-6">chevron_right</span>
                    <span style="color: var(--on-surface);">Mß║½u Email</span>
                </nav>

                <!-- ΓöÇΓöÇΓöÇ Page Title ΓöÇΓöÇΓöÇ -->
                <div class="d-flex justify-content-between align-items-start mb-5 flex-wrap gap-3">
                    <div>
                        <h1 class="fw-bold mb-1" style="font-size: 28px; color: var(--on-surface);">
                            <span class="material-symbols-outlined me-2 align-middle"
                                  style="font-size: 30px; color: var(--primary); font-variation-settings: 'FILL' 1;">mail</span>
                            Quß║ún l├╜ Mß║½u Email
                        </h1>
                        <p style="color: var(--on-surface-variant); font-size: 14px;" class="mb-0">
                            T├╣y chß╗ënh nß╗Öi dung c├íc mß║½u email hß╗ç thß╗æng gß╗¡i tß╗▒ ─æß╗Öng. Thay ─æß╗òi sß║╜ c├│ hiß╗çu lß╗▒c ngay lß║¡p tß╗⌐c.
                        </p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <div class="px-3 py-2 rounded-3 d-flex align-items-center gap-2"
                             style="background: linear-gradient(135deg, rgba(157,67,0,0.08), rgba(249,115,22,0.05)); border: 1px solid rgba(157,67,0,0.15);">
                            <span class="material-symbols-outlined" style="color: var(--primary); font-size: 18px;">mail_outline</span>
                            <span class="fw-bold" style="font-size: 22px; color: var(--primary);">${templates.size()}</span>
                            <span style="font-size: 12px; color: var(--on-surface-variant);">mß║½u email</span>
                        </div>
                    </div>
                </div>

                <!-- ΓöÇΓöÇΓöÇ Alert Messages ΓöÇΓöÇΓöÇ -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-dismissible fade show mb-4 d-flex align-items-center gap-2 rounded-3"
                         role="alert"
                         style="background: linear-gradient(135deg, rgba(22,163,74,0.08), rgba(22,163,74,0.04)); border: 1px solid rgba(22,163,74,0.25); color: #15803d;">
                        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1; color: #16a34a;">check_circle</span>
                        <span class="fw-semibold"><c:out value="${param.success}" /></span>
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="─É├│ng"></button>
                    </div>
                </c:if>
                <c:if test="${not empty param.error}">
                    <div class="alert alert-dismissible fade show mb-4 d-flex align-items-center gap-2 rounded-3"
                         role="alert"
                         style="background: linear-gradient(135deg, rgba(186,26,26,0.08), rgba(186,26,26,0.04)); border: 1px solid rgba(186,26,26,0.2); color: #93000a;">
                        <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1; color: #ef4444;">error</span>
                        <span class="fw-semibold"><c:out value="${param.error}" /></span>
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="─É├│ng"></button>
                    </div>
                </c:if>

                <div class="row g-4">

                    <!-- ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ
                         LEFT: Danh s├ích + Th├¬m mß╗¢i template
                    ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ -->
                    <div class="col-12 col-xl-4">

                        <!-- Danh s├ích mß║½u -->
                        <div class="raised-card overflow-hidden mb-4">
                            <div class="p-3 d-flex align-items-center justify-content-between"
                                 style="border-bottom: 1px solid var(--outline-variant); background-color: var(--surface-container-low);">
                                <div>
                                    <h5 class="fw-bold mb-0" style="color: var(--on-surface); font-size: 15px;">Danh s├ích mß║½u</h5>
                                    <p class="mb-0 small" style="color: var(--on-surface-variant);">Tß╗òng: ${templates.size()} mß║½u</p>
                                </div>
                                <button class="btn btn-sm btn-primary-custom rounded-3 d-flex align-items-center gap-1"
                                        onclick="toggleCreateForm()" id="btnToggleCreate" title="Th├¬m mß║½u mß╗¢i">
                                    <span class="material-symbols-outlined" style="font-size: 16px;">add</span>
                                    Th├¬m mß╗¢i
                                </button>
                            </div>

                            <div class="d-flex flex-column">
                                <c:forEach var="tmpl" items="${templates}">
                                    <a href="${pageContext.request.contextPath}/manager/email-templates?action=edit&tempId=${tmpl.tempId}"
                                       class="email-tmpl-item px-3 py-3 text-decoration-none d-flex align-items-start gap-3
                                              ${editTemplate != null and editTemplate.tempId == tmpl.tempId ? 'active-template' : ''}"
                                       style="border-bottom: 1px solid var(--outline-variant);">

                                        <!-- M├áu icon theo t├¬n mß║½u -->
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
                                                        Sß╗¡a lß║ºn cuß╗æi: <fmt:formatDate value="${tmpl.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        Tß║ío: <fmt:formatDate value="${tmpl.createdAt}" pattern="dd/MM/yyyy" />
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
                                        <p class="fw-semibold mb-1" style="color: var(--on-surface);">Ch╞░a c├│ mß║½u n├áo</p>
                                        <p class="small mb-0" style="color: var(--on-surface-variant);">Nhß║Ñn "Th├¬m mß╗¢i" ─æß╗â tß║ío mß║½u ─æß║ºu ti├¬n.</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Form th├¬m mß╗¢i template (ß║⌐n mß║╖c ─æß╗ïnh) -->
                        <div class="raised-card p-4" id="createFormCard" style="display: none;">
                            <div class="d-flex align-items-center gap-2 mb-3">
                                <div class="rounded-2 d-flex align-items-center justify-content-center"
                                     style="width: 32px; height: 32px; background: linear-gradient(135deg, rgba(157,67,0,0.12), rgba(249,115,22,0.08));">
                                    <span class="material-symbols-outlined"
                                          style="color: var(--primary); font-size: 18px; font-variation-settings: 'FILL' 1;">add_circle</span>
                                </div>
                                <h6 class="fw-bold mb-0" style="color: var(--on-surface);">Tß║ío mß║½u Email mß╗¢i</h6>
                            </div>

                            <form method="post" action="${pageContext.request.contextPath}/manager/email-templates">
                                <input type="hidden" name="action" value="create">

                                <div class="mb-3">
                                    <label for="newTempName" class="form-label small fw-semibold"
                                           style="color: var(--on-surface-variant);">M├ú ─æß╗ïnh danh mß║½u <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control rounded-3 font-monospace" id="newTempName"
                                           name="tempName" placeholder="VD: URGENT_NOTIFICATION"
                                           required style="font-size: 13px; text-transform: uppercase;"
                                           oninput="this.value = this.value.toUpperCase().replace(/\s/g,'_')">
                                    <div class="form-text" style="font-size: 11px;">Chß╗ë d├╣ng chß╗» HOA v├á dß║Ñu gß║ích d╞░ß╗¢i.</div>
                                </div>

                                <div class="mb-3">
                                    <label for="newSubject" class="form-label small fw-semibold"
                                           style="color: var(--on-surface-variant);">Ti├¬u ─æß╗ü Email <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control rounded-3" id="newSubject"
                                           name="subject" placeholder="VD: [LMS] Th├┤ng b├ío: {{notificationTitle}}"
                                           required maxlength="255">
                                </div>

                                <div class="mb-3">
                                    <label for="newBody" class="form-label small fw-semibold"
                                           style="color: var(--on-surface-variant);">Nß╗Öi dung HTML <span class="text-danger">*</span></label>
                                    <textarea class="form-control rounded-3 font-monospace" id="newBody"
                                              name="bodyContent" rows="8"
                                              style="font-size: 12px;" required></textarea>
                                </div>

                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary-custom flex-grow-1 rounded-3 fw-bold py-2">
                                        <span class="material-symbols-outlined me-1 align-middle">save</span>Tß║ío mß║½u
                                    </button>
                                    <button type="button" class="btn rounded-3 py-2"
                                            onclick="toggleCreateForm()"
                                            style="background-color: var(--surface-container-high); color: var(--on-surface-variant);">Hß╗ºy</button>
                                </div>
                            </form>
                        </div>

                        <!-- H╞░ß╗¢ng dß║½n Placeholders -->
                        <div class="raised-card p-4" id="placeholderGuide"
                             style="background: linear-gradient(135deg, var(--surface-container-low), var(--surface-container));">
                            <h6 class="fw-bold mb-3" style="color: var(--on-surface); font-size: 12px; text-transform: uppercase; letter-spacing: 0.05em;">
                                Placeholder ─æ╞░ß╗úc hß╗ù trß╗ú
                            </h6>
                            <div class="d-flex flex-column gap-2" style="font-size: 12px;">
                                <div class="d-flex align-items-center gap-2">
                                    <code class="px-2 py-1 rounded-2" style="background: rgba(0,99,152,0.08); color: var(--tertiary); font-size: 11px;">{{userName}}</code>
                                    <span style="color: var(--on-surface-variant);">T├¬n ng╞░ß╗¥i nhß║¡n</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <code class="px-2 py-1 rounded-2" style="background: rgba(239,68,68,0.08); color: #dc2626; font-size: 11px;">{{notificationTitle}}</code>
                                    <span style="color: var(--on-surface-variant);">Ti├¬u ─æß╗ü th├┤ng b├ío</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <code class="px-2 py-1 rounded-2" style="background: rgba(239,68,68,0.08); color: #dc2626; font-size: 11px;">{{notificationContent}}</code>
                                    <span style="color: var(--on-surface-variant);">Nß╗Öi dung th├┤ng b├ío (HTML)</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <code class="px-2 py-1 rounded-2" style="background: rgba(22,163,74,0.08); color: #15803d; font-size: 11px;">{{bookTitle}}</code>
                                    <span style="color: var(--on-surface-variant);">T├¬n s├ích</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <code class="px-2 py-1 rounded-2" style="background: rgba(22,163,74,0.08); color: #15803d; font-size: 11px;">{{dueDate}}</code>
                                    <span style="color: var(--on-surface-variant);">Ng├áy ─æß║┐n hß║ín trß║ú</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <code class="px-2 py-1 rounded-2" style="background: rgba(22,163,74,0.08); color: #15803d; font-size: 11px;">{{fineAmount}}</code>
                                    <span style="color: var(--on-surface-variant);">Sß╗æ tiß╗ün phß║ít</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ
                         RIGHT: Editor / Preview
                    ΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉΓòÉ -->
                    <div class="col-12 col-xl-8">
                        <c:choose>
                            <c:when test="${not empty editTemplate}">
                                <!-- Form chß╗ënh sß╗¡a mß║½u -->
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
                                                    Chß╗ënh sß╗¡a mß║½u:
                                                    <code style="background: rgba(0,0,0,0.05); padding: 2px 8px; border-radius: 4px; font-size: 13px;">
                                                        <c:out value="${editTemplate.tempName}" />
                                                    </code>
                                                </h5>
                                                <p class="mb-0" style="font-size: 11px; color: var(--on-surface-variant);">
                                                    Thay ─æß╗òi sß║╜ c├│ hiß╗çu lß╗▒c ngay lß║¡p tß╗⌐c vß╗¢i c├íc email gß╗¡i tiß║┐p theo.
                                                </p>
                                            </div>
                                        </div>
                                        <!-- Tab toggle -->
                                        <div class="d-flex align-items-center gap-1 p-1 rounded-3"
                                             style="background-color: var(--surface-container);">
                                            <button type="button" class="btn btn-sm rounded-2 fw-semibold tab-btn active-tab"
                                                    id="tabEdit" onclick="switchTab('edit')" style="font-size: 12px; padding: 4px 12px;">
                                                <span class="material-symbols-outlined me-1 align-middle" style="font-size: 14px;">code</span>Soß║ín thß║úo
                                            </button>
                                            <button type="button" class="btn btn-sm rounded-2 fw-semibold tab-btn"
                                                    id="tabPreview" onclick="switchTab('preview')" style="font-size: 12px; padding: 4px 12px;">
                                                <span class="material-symbols-outlined me-1 align-middle" style="font-size: 14px;">preview</span>Xem thß╗¡
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Editor content -->
                                    <div class="p-4">
                                        <form method="post" action="${pageContext.request.contextPath}/manager/email-templates"
                                              id="editTemplateForm">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="tempId" value="${editTemplate.tempId}">

                                            <!-- T├¬n mß║½u (readonly) -->
                                            <div class="mb-3">
                                                <label class="form-label small fw-semibold"
                                                       style="color: var(--on-surface-variant);">M├ú ─æß╗ïnh danh (Kh├┤ng thß╗â thay ─æß╗òi)</label>
                                                <div class="form-control rounded-3 d-flex align-items-center gap-2"
                                                     style="background: var(--surface-container-low); cursor: not-allowed;">
                                                    <span class="material-symbols-outlined" style="font-size: 16px; color: var(--on-surface-variant);">lock</span>
                                                    <code style="color: var(--on-surface-variant); background: transparent; padding: 0;">
                                                        <c:out value="${editTemplate.tempName}" />
                                                    </code>
                                                </div>
                                            </div>

                                            <!-- Ti├¬u ─æß╗ü email -->
                                            <div class="mb-3">
                                                <label for="emailSubject" class="form-label small fw-semibold"
                                                       style="color: var(--on-surface-variant);">
                                                    Ti├¬u ─æß╗ü Email <span class="text-danger">*</span>
                                                </label>
                                                <input type="text" class="form-control rounded-3" id="emailSubject"
                                                       name="subject"
                                                       value="<c:out value='${editTemplate.subject}'/>"
                                                       required maxlength="255">
                                            </div>

                                            <!-- Nß╗Öi dung (Tab Edit / Tab Preview) -->
                                            <div id="panelEdit">
                                                <div class="mb-3">
                                                    <label for="emailBody" class="form-label small fw-semibold"
                                                           style="color: var(--on-surface-variant);">
                                                        Nß╗Öi dung HTML <span class="text-danger">*</span>
                                                    </label>
                                                    <textarea class="form-control rounded-3 font-monospace" id="emailBody"
                                                              name="bodyContent" rows="16"
                                                              style="font-size: 12px; resize: vertical;"
                                                              oninput="syncPreview()"><c:out value="${editTemplate.bodyContent}" /></textarea>
                                                    <div class="form-text d-flex align-items-center gap-1 mt-2" style="font-size: 11px;">
                                                        <span class="material-symbols-outlined" style="font-size: 13px;">info</span>
                                                        Nhß║¡p HTML hoß║╖c v─ân bß║ún c├│ Placeholder dß║íng <code>{{tenBien}}</code>. Khi gß╗¡i, Markdown trong nß╗Öi dung th├┤ng b├ío sß║╜ ─æ╞░ß╗úc tß╗▒ ─æß╗Öng chuyß╗ân sang HTML.
                                                    </div>
                                                </div>
                                            </div>

                                            <div id="panelPreview" style="display:none;">
                                                <div class="mb-3">
                                                    <label class="form-label small fw-semibold"
                                                           style="color: var(--on-surface-variant);">Xem thß╗¡ Email (dß╗» liß╗çu giß║ú)</label>
                                                    <div class="rounded-3 overflow-hidden"
                                                         style="border: 1px solid var(--outline-variant); min-height: 360px;">
                                                        <!-- Giß║ú lß║¡p thanh ti├¬u ─æß╗ü email client -->
                                                        <div class="px-3 py-2 d-flex align-items-center gap-3"
                                                             style="background: #f8f8f8; border-bottom: 1px solid #eee; font-size: 12px;">
                                                            <span class="material-symbols-outlined" style="font-size: 16px; color: #888;">mail</span>
                                                            <div>
                                                                <span class="fw-semibold text-dark">Tß╗½:</span>
                                                                <span class="text-secondary"> LMS University Library &lt;lms@university.edu.vn&gt;</span>
                                                            </div>
                                                        </div>
                                                        <!-- Ti├¬u ─æß╗ü preview -->
                                                        <div class="px-3 py-2"
                                                             style="background: #f8f8f8; border-bottom: 1px solid #eee;">
                                                            <span class="fw-semibold text-dark" style="font-size: 12px;">Ti├¬u ─æß╗ü: </span>
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
                                                    <span class="material-symbols-outlined me-1 align-middle">save</span>L╞░u thay ─æß╗òi
                                                </button>
                                                <a href="${pageContext.request.contextPath}/manager/email-templates"
                                                   class="btn rounded-3 py-2 px-4"
                                                   style="background-color: var(--surface-container-high); color: var(--on-surface-variant);">Hß╗ºy</a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <!-- Trß║íng th├íi rß╗ùng ΓÇö Placeholder h╞░ß╗¢ng dß║½n -->
                                <div class="raised-card p-5 text-center h-100 d-flex flex-column align-items-center justify-content-center"
                                     style="min-height: 420px; border: 2px dashed var(--outline-variant);">
                                    <div class="rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                                         style="width: 80px; height: 80px; background: linear-gradient(135deg, rgba(157,67,0,0.06), rgba(249,115,22,0.04));">
                                        <span class="material-symbols-outlined"
                                              style="font-size: 36px; color: var(--primary); font-variation-settings: 'FILL' 0;">mail_outline</span>
                                    </div>
                                    <h5 class="fw-bold mb-1" style="color: var(--on-surface);">Chß╗ìn mß╗Öt mß║½u Email ─æß╗â chß╗ënh sß╗¡a</h5>
                                    <p style="color: var(--on-surface-variant); font-size: 14px;" class="mb-4">
                                        Nhß║Ñp v├áo bß║Ñt kß╗│ mß║½u n├áo ß╗ƒ danh s├ích b├¬n tr├íi ─æß╗â xem v├á chß╗ënh sß╗¡a nß╗Öi dung.
                                    </p>

                                    <!-- H╞░ß╗¢ng dß║½n URGENT_NOTIFICATION -->
                                    <div class="rounded-3 p-3 text-start w-100"
                                         style="background: rgba(239,68,68,0.04); border: 1px solid rgba(239,68,68,0.15); max-width: 480px;">
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <span class="material-symbols-outlined" style="font-size: 18px; color: #ef4444; font-variation-settings: 'FILL' 1;">priority_high</span>
                                            <span class="fw-bold" style="font-size: 13px; color: #dc2626;">L╞░u ├╜ quan trß╗ìng</span>
                                        </div>
                                        <p class="small mb-1" style="color: var(--on-surface-variant);">
                                            ─Éß╗â bß║¡t t├¡nh n─âng <strong>gß╗¡i Email tß╗▒ ─æß╗Öng</strong> khi ─æ─âng Th├┤ng b├ío Khß║⌐n cß║Ñp,
                                            bß║ín cß║ºn tß║ío mß╗Öt mß║½u email vß╗¢i m├ú ─æß╗ïnh danh:
                                        </p>
                                        <code class="d-block px-3 py-2 rounded-2 text-center fw-bold"
                                              style="background: rgba(239,68,68,0.08); color: #dc2626; font-size: 14px; letter-spacing: 1px;">
                                            URGENT_NOTIFICATION
                                        </code>
                                        <p class="small mt-2 mb-0" style="color: var(--on-surface-variant);">
                                            Sß╗¡ dß╗Ñng c├íc placeholder:
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // ΓöÇΓöÇΓöÇ Sidebar active link ΓöÇΓöÇΓöÇ
        document.querySelectorAll('.sidebar-link').forEach(link => {
            if (link.href === window.location.href.split('?')[0]) {
                link.classList.add('active');
            }
        });

        // ΓöÇΓöÇΓöÇ Toggle form tß║ío mß╗¢i ΓöÇΓöÇΓöÇ
        function toggleCreateForm() {
            const card = document.getElementById('createFormCard');
            const guide = document.getElementById('placeholderGuide');
            const isHidden = card.style.display === 'none';
            card.style.display = isHidden ? 'block' : 'none';
            guide.style.display = isHidden ? 'none' : 'block';
            if (isHidden) card.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }

        // ΓöÇΓöÇΓöÇ Tab Edit / Preview ΓöÇΓöÇΓöÇ
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

        // ΓöÇΓöÇΓöÇ Render Preview iframe ΓöÇΓöÇΓöÇ
        function renderPreview() {
            const body = document.getElementById('emailBody');
            const subject = document.getElementById('emailSubject');
            const frame = document.getElementById('previewFrame');
            const previewSubject = document.getElementById('previewSubject');

            if (!body || !frame) return;

            // Thay placeholder bß║▒ng dß╗» liß╗çu giß║ú ─æß╗â xem thß╗¡
            let previewHtml = body.value
                .replace(/\{\{userName\}\}/g, 'Nguyß╗àn V─ân A')
                .replace(/\{\{notificationTitle\}\}/g, 'Th╞░ viß╗çn tß║ím ngß╗½ng hoß║ít ─æß╗Öng')
                .replace(/\{\{notificationContent\}\}/g,
                    '<p style="color:#dc2626;">Th╞░ viß╗çn sß║╜ ─æ├│ng cß╗¡a tß╗½ 14:00 h├┤m nay ─æß╗â bß║úo tr├¼ hß╗ç thß╗æng. Vui l├▓ng ho├án trß║ú s├ích tr╞░ß╗¢c giß╗¥ ─æ├│ng cß╗¡a.</p>')
                .replace(/\{\{bookTitle\}\}/g, 'Gi├ío tr├¼nh Lß║¡p tr├¼nh Java')
                .replace(/\{\{dueDate\}\}/g, '30/06/2025')
                .replace(/\{\{fineAmount\}\}/g, '15.000 ─æß╗ông')
                .replace(/\{\{barcode\}\}/g, 'LMS-2024-00123');

            const doc = frame.contentDocument || frame.contentWindow.document;
            doc.open();
            doc.write(previewHtml);
            doc.close();

            if (subject) {
                previewSubject.textContent = subject.value
                    .replace(/\{\{notificationTitle\}\}/g, 'Th╞░ viß╗çn tß║ím ngß╗½ng hoß║ít ─æß╗Öng')
                    .replace(/\{\{userName\}\}/g, 'Nguyß╗àn V─ân A');
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
        /* ΓöÇΓöÇΓöÇ Template list item ΓöÇΓöÇΓöÇ */
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

        /* ΓöÇΓöÇΓöÇ Tabs ΓöÇΓöÇΓöÇ */
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
