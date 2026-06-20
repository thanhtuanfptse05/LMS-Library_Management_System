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
                            <span class="material-symbols-outlined align-middle me-2" style="font-size: 26px; color: var(--primary); font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24;">settings</span>
                            Cài đặt Hệ thống
                        </h1>
                        <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Quản lý toàn bộ cấu hình hệ thống — phân nhóm theo chức năng</p>
                    </div>
                    <button type="button" class="btn btn-primary-custom d-flex align-items-center gap-2"
                            data-bs-toggle="modal" data-bs-target="#createModal" id="btn-add-config">
                        <span class="material-symbols-outlined" style="font-size: 18px;">add</span>
                        Thêm cấu hình mới
                    </button>
                </div>

                <!-- ▶ Group Filter Tabs ◀ -->
                <div class="d-flex align-items-center gap-2 mb-4 flex-wrap">
                    <a href="${pageContext.request.contextPath}/admin/system-config"
                       class="btn btn-sm rounded-pill ${empty groupFilter || groupFilter == 'all' ? 'btn-primary-custom' : 'btn-outline-secondary'}">
                        Tất cả
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/system-config?group=library"
                       class="btn btn-sm rounded-pill ${groupFilter == 'library' ? 'btn-primary-custom' : 'btn-outline-secondary'}">
                        📚 Thư viện
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/system-config?group=fine"
                       class="btn btn-sm rounded-pill ${groupFilter == 'fine' ? 'btn-primary-custom' : 'btn-outline-secondary'}">
                        💰 Tiền phạt
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/system-config?group=sepay"
                       class="btn btn-sm rounded-pill ${groupFilter == 'sepay' ? 'btn-primary-custom' : 'btn-outline-secondary'}">
                        💳 SePay
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/system-config?group=notification"
                       class="btn btn-sm rounded-pill ${groupFilter == 'notification' ? 'btn-primary-custom' : 'btn-outline-secondary'}">
                        🔔 Thông báo
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/system-config?group=system"
                       class="btn btn-sm rounded-pill ${groupFilter == 'system' ? 'btn-primary-custom' : 'btn-outline-secondary'}">
                        ⚙️ Hệ thống
                    </a>
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

                <%-- ▶ Render sections theo từng group ◀ --%>

                <%-- Section: sepay --%>
                <c:set var="hasSepay" value="false"/>
                <c:forEach var="cfg" items="${configs}">
                    <c:if test="${cfg.configGroup == 'sepay'}"><c:set var="hasSepay" value="true"/></c:if>
                </c:forEach>
                <c:if test="${hasSepay == 'true' || empty groupFilter || groupFilter == 'all' || groupFilter == 'sepay'}">
                    <c:set var="hasSepayContent" value="false"/>
                    <c:forEach var="cfg" items="${configs}">
                        <c:if test="${cfg.configGroup == 'sepay'}"><c:set var="hasSepayContent" value="true"/></c:if>
                    </c:forEach>
                    <c:if test="${hasSepayContent == 'true'}">
                        <div class="raised-card mb-4">
                            <div class="card-header-row" style="border-bottom: 1px solid var(--outline-variant); padding-bottom: 16px; margin-bottom: 20px;">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="material-symbols-outlined" style="color: #6366f1; font-size: 22px; font-variation-settings: 'FILL' 1;">credit_card</span>
                                    <div>
                                        <h3 class="card-title mb-0">Thông tin chuyển khoản (SePay)</h3>
                                        <p class="card-subtitle mb-0" style="font-size: 12px;">API key, số tài khoản, tên ngân hàng, QR code</p>
                                    </div>
                                </div>
                            </div>
                            <div class="px-1">
                                <c:forEach var="cfg" items="${configs}">
                                    <c:if test="${cfg.configGroup == 'sepay'}">
                                        <form action="${pageContext.request.contextPath}/admin/system-config" method="POST"
                                              class="d-flex align-items-center gap-3 py-3"
                                              style="border-bottom: 1px solid var(--outline-variant);">
                                            <input type="hidden" name="configKey" value="${cfg.configKey}">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="groupFilter" value="${groupFilter}">

                                            <div class="flex-grow-1">
                                                <label class="form-label fw-bold mb-0" style="font-size: 13px; color: var(--on-surface);">
                                                    <c:out value="${cfg.description}"/>
                                                </label>
                                                <div style="font-size: 11px; font-family: 'Courier New', monospace; color: var(--on-surface-variant);">
                                                    <c:out value="${cfg.configKey}"/>
                                                </div>
                                            </div>

                                            <div style="width: 260px;">
                                                <c:choose>
                                                    <c:when test="${cfg.configKey == 'SEPAY_QR_URL'}">
                                                        <input type="url" class="form-control form-control-sm"
                                                               name="configValue" value="${cfg.configValue}"
                                                               placeholder="https://qr.sepay.vn/..."
                                                               style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md);">
                                                        <c:if test="${not empty cfg.configValue}">
                                                            <img src="${cfg.configValue}" alt="QR Preview"
                                                                 class="mt-2 rounded-2"
                                                                 style="width: 100px; height: 100px; object-fit: cover; border: 1px solid var(--outline-variant);"
                                                                 onerror="this.style.display='none'">
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="text" class="form-control form-control-sm fw-bold"
                                                               name="configValue" value="${cfg.configValue}"
                                                               style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md); font-family: 'Courier New', monospace;">
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div style="min-width: 90px;" class="text-end">
                                                <button type="submit" class="btn btn-sm btn-primary-custom rounded-2 d-inline-flex align-items-center gap-1">
                                                    <span class="material-symbols-outlined" style="font-size: 14px;">save</span> Lưu
                                                </button>
                                            </div>

                                            <div style="min-width: 90px;" class="text-end">
                                                <%-- Nút xóa chỉ hiện với config không cứng --%>
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
                    </c:if>
                </c:if>

                <%-- Macro JSP include không có, dùng forEach render tất cả nhóm còn lại --%>

                <%-- Section helper — render các nhóm library, fine, notification, system --%>
                <c:set var="groupsToRender" value="library,fine,notification,system"/>

                <c:forEach var="grp" items="library,fine,notification,system">
                    <c:set var="hasGroup" value="false"/>
                    <c:forEach var="cfg" items="${configs}">
                        <c:if test="${cfg.configGroup == grp}"><c:set var="hasGroup" value="true"/></c:if>
                    </c:forEach>

                    <c:if test="${hasGroup == 'true'}">
                        <%-- Header theo group --%>
                        <div class="raised-card mb-4">
                            <div class="card-header-row" style="border-bottom: 1px solid var(--outline-variant); padding-bottom: 16px; margin-bottom: 20px;">
                                <div class="d-flex align-items-center gap-2">
                                    <c:choose>
                                        <c:when test="${grp == 'library'}">
                                            <span class="material-symbols-outlined" style="color: var(--primary); font-size: 22px; font-variation-settings: 'FILL' 1;">menu_book</span>
                                            <div><h3 class="card-title mb-0">Chính sách Mượn - Trả - Gia hạn</h3>
                                                <p class="card-subtitle mb-0" style="font-size:12px;">Giới hạn mượn, số ngày trả, số lần gia hạn, đặt trước</p></div>
                                        </c:when>
                                        <c:when test="${grp == 'fine'}">
                                            <span class="material-symbols-outlined" style="color: #f59e0b; font-size: 22px; font-variation-settings: 'FILL' 1;">payments</span>
                                            <div><h3 class="card-title mb-0">Quy định Tiền phạt</h3>
                                                <p class="card-subtitle mb-0" style="font-size:12px;">Mức phạt trễ hạn, hệ số đền bù sách hỏng/mất</p></div>
                                        </c:when>
                                        <c:when test="${grp == 'notification'}">
                                            <span class="material-symbols-outlined" style="color: #10b981; font-size: 22px; font-variation-settings: 'FILL' 1;">notifications</span>
                                            <div><h3 class="card-title mb-0">Cấu hình Thông báo & Email</h3>
                                                <p class="card-subtitle mb-0" style="font-size:12px;">OTP timeout, nhắc nhở quá hạn</p></div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="material-symbols-outlined" style="color: #64748b; font-size: 22px; font-variation-settings: 'FILL' 1;">computer</span>
                                            <div><h3 class="card-title mb-0">Cấu hình Hệ thống</h3>
                                                <p class="card-subtitle mb-0" style="font-size:12px;">Import, API, các thông số nội bộ</p></div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="px-1">
                                <c:forEach var="cfg" items="${configs}">
                                    <c:if test="${cfg.configGroup == grp}">
                                        <div class="d-flex align-items-center gap-3 py-3"
                                             style="border-bottom: 1px solid var(--outline-variant);">

                                            <%-- Form Update --%>
                                            <form action="${pageContext.request.contextPath}/admin/system-config" method="POST"
                                                  class="d-flex align-items-center gap-3 flex-grow-1">
                                                <input type="hidden" name="configKey" value="${cfg.configKey}">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="groupFilter" value="${groupFilter}">

                                                <div class="flex-grow-1">
                                                    <label class="form-label fw-bold mb-0" style="font-size: 13px; color: var(--on-surface);">
                                                        <c:out value="${cfg.description}"/>
                                                    </label>
                                                    <div style="font-size: 11px; font-family: 'Courier New', monospace; color: var(--on-surface-variant);">
                                                        <c:out value="${cfg.configKey}"/>
                                                        <span class="ms-2 badge" style="background: var(--surface-container); color: var(--on-surface-variant); font-size: 10px; font-weight: 500;">
                                                            <c:out value="${cfg.configGroup}"/>
                                                        </span>
                                                    </div>
                                                </div>

                                                <div style="width: 220px;">
                                                    <input type="text"
                                                           class="form-control form-control-sm fw-bold text-center"
                                                           name="configValue"
                                                           value="${cfg.configValue}"
                                                           style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md); font-family: 'Courier New', monospace;">
                                                </div>

                                                <button type="submit" class="btn btn-sm btn-primary-custom rounded-2 d-inline-flex align-items-center gap-1" style="white-space: nowrap;">
                                                    <span class="material-symbols-outlined" style="font-size: 14px;">save</span> Lưu
                                                </button>
                                            </form>

                                            <%-- Form Delete — chỉ hiện nếu không phải config cứng --%>
                                            <%-- Config cứng: STUDENT_MAX_BORROW_DAYS, FINE_RATE_PER_DAY, SEPAY_API_KEY... --%>
                                            <c:set var="isHard" value="false"/>
                                            <c:if test="${cfg.configKey == 'STUDENT_MAX_BORROW_DAYS' || cfg.configKey == 'LECTURER_MAX_BORROW_DAYS'
                                                          || cfg.configKey == 'STUDENT_MAX_BORROW_LIMIT' || cfg.configKey == 'LECTURER_MAX_BORROW_LIMIT'
                                                          || cfg.configKey == 'MAX_EXTENSION_COUNT' || cfg.configKey == 'RENEW_DURATION_DAYS'
                                                          || cfg.configKey == 'RESERVATION_HOLD_DAYS' || cfg.configKey == 'RENEW_THRESHOLD_PERCENT'
                                                          || cfg.configKey == 'FINE_RATE_PER_DAY' || cfg.configKey == 'LOST_FINE_MULTIPLIER'
                                                          || cfg.configKey == 'DAMAGED_FINE_MULTIPLIER' || cfg.configKey == 'DEFAULT_BOOK_PRICE'
                                                          || cfg.configKey == 'EMAIL_OTP_EXPIRE_MINUTES' || cfg.configKey == 'EMAIL_OVERDUE_NOTICE_DAYS'
                                                          || cfg.configKey == 'MAX_IMPORT_ROWS' || cfg.configKey == 'IMPORT_EXPIRE_DAYS'
                                                          || cfg.configKey == 'SEPAY_API_KEY' || cfg.configKey == 'SEPAY_ACCOUNT_NUMBER'
                                                          || cfg.configKey == 'SEPAY_BANK_CODE' || cfg.configKey == 'SEPAY_ACCOUNT_NAME'
                                                          || cfg.configKey == 'SEPAY_QR_URL'
                                                          || cfg.configKey == 'GEMINI_API_KEY' || cfg.configKey == 'GEMINI_CHATBOT_API_KEY'}">
                                                <c:set var="isHard" value="true"/>
                                            </c:if>

                                            <c:choose>
                                                <c:when test="${isHard == 'false'}">
                                                    <form action="${pageContext.request.contextPath}/admin/system-config" method="POST"
                                                          onsubmit="return confirm('Xác nhận xóa cấu hình \'${cfg.configKey}\'?')">
                                                        <input type="hidden" name="configKey" value="${cfg.configKey}">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="groupFilter" value="${groupFilter}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-2 d-inline-flex align-items-center gap-1">
                                                            <span class="material-symbols-outlined" style="font-size: 14px;">delete</span>
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="min-width: 36px;">
                                                        <span class="material-symbols-outlined text-muted" style="font-size: 18px;" title="Cấu hình hệ thống cố định, không thể xóa">lock</span>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>

                                            <div style="min-width: 110px; font-size: 11px; color: var(--on-surface-variant); text-align: right;">
                                                <span class="material-symbols-outlined" style="font-size: 12px; vertical-align: middle;">person</span>
                                                <c:out value="${cfg.updaterName}"/><br>
                                                <fmt:formatDate value="${cfg.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>

                <c:if test="${empty configs}">
                    <div class="raised-card text-center py-5">
                        <span class="material-symbols-outlined d-block mb-2" style="font-size: 40px; color: var(--outline);">inbox</span>
                        <span style="color: var(--on-surface-variant); font-size: 14px;">Không có cấu hình nào trong nhóm này.</span>
                    </div>
                </c:if>

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <!-- ▶ Modal Tạo cấu hình mới ◀ -->
    <div class="modal fade" id="createModal" tabindex="-1" aria-labelledby="createModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <form action="${pageContext.request.contextPath}/admin/system-config" method="POST" class="modal-content" style="border-radius: var(--radius-lg);">
                <div class="modal-header" style="border-bottom: 1px solid var(--outline-variant);">
                    <h5 class="modal-title fw-bold" id="createModalLabel">
                        <span class="material-symbols-outlined align-middle me-2" style="color: var(--primary); font-size: 20px;">add_circle</span>
                        Thêm cấu hình mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body p-4">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="groupFilter" value="${groupFilter}">

                    <div class="mb-3">
                        <label for="newConfigKey" class="form-label fw-bold">
                            Mã cấu hình <span class="text-danger">*</span>
                        </label>
                        <input type="text" class="form-control" id="newConfigKey" name="configKey" required
                               placeholder="VD: MY_CUSTOM_KEY"
                               style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md); font-family: 'Courier New', monospace; text-transform: uppercase;"
                               oninput="this.value = this.value.toUpperCase().replace(/[^A-Z0-9_]/g,'')">
                        <div class="form-text">Chỉ dùng chữ IN HOA, số và dấu gạch dưới. Tối đa 100 ký tự.</div>
                    </div>

                    <div class="mb-3">
                        <label for="newConfigGroup" class="form-label fw-bold">
                            Nhóm <span class="text-danger">*</span>
                        </label>
                        <select class="form-select" id="newConfigGroup" name="configGroup" required
                                style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md);">
                            <option value="">-- Chọn nhóm --</option>
                            <option value="library">library — Chính sách thư viện</option>
                            <option value="fine">fine — Tiền phạt</option>
                            <option value="sepay">sepay — Tích hợp SePay</option>
                            <option value="notification">notification — Thông báo & Email</option>
                            <option value="system">system — Hệ thống</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="newConfigValue" class="form-label fw-bold">Giá trị</label>
                        <input type="text" class="form-control" id="newConfigValue" name="configValue"
                               placeholder="Giá trị khởi tạo"
                               style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md);">
                    </div>

                    <div class="mb-3">
                        <label for="newConfigDesc" class="form-label fw-bold">Mô tả</label>
                        <input type="text" class="form-control" id="newConfigDesc" name="description"
                               placeholder="Mô tả ngắn gọn về cấu hình này"
                               style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md);">
                    </div>
                </div>
                <div class="modal-footer" style="border-top: 1px solid var(--outline-variant);">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary-custom rounded-2 d-flex align-items-center gap-2">
                        <span class="material-symbols-outlined" style="font-size: 16px;">save</span>
                        Tạo cấu hình
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
