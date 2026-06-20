<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp">
    <jsp:param name="title" value="Cấu hình Thanh toán SePay | Quản lý" />
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
                            <span class="material-symbols-outlined align-middle me-2" style="font-size: 26px; color: var(--primary); font-variation-settings: 'FILL' 1, 'wght' 500, 'GRAD' 0, 'opsz' 24;">qr_code_scanner</span>
                            Cấu hình Tích hợp Thanh toán QR
                        </h2>
                        <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Quản lý API Key và thông tin tài khoản ngân hàng để sinh mã VietQR cho SePay</p>
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

                <div class="row">
                    <!-- Preview QR -->
                    <div class="col-md-4 mb-4">
                        <div class="raised-card overflow-hidden h-100 text-center p-4 d-flex flex-column align-items-center justify-content-center">
                            <h4 class="fw-bold mb-3" style="font-size: 16px;">Xem trước VietQR</h4>
                            <div class="qr-preview-box bg-white p-2 rounded-3 shadow-sm mb-3" style="border: 2px dashed var(--outline-variant);">
                                <c:choose>
                                    <c:when test="${not empty sepayAccountNumber and not empty sepayBankCode}">
                                        <img src="https://qr.sepay.vn/img?acc=${sepayAccountNumber}&bank=${sepayBankCode}&amount=50000&des=LMSPF000" 
                                             alt="Preview QR" class="img-fluid rounded-2" style="max-width: 200px;" />
                                    </c:when>
                                    <c:otherwise>
                                        <div class="d-flex flex-column align-items-center justify-content-center" style="width: 200px; height: 200px; background: var(--surface-container-low);">
                                            <span class="material-symbols-outlined mb-2 text-muted" style="font-size: 40px;">qr_code</span>
                                            <span class="text-muted" style="font-size: 12px;">Chưa đủ thông tin</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="text-start w-100 px-3">
                                <p class="mb-1 fw-bold text-primary-custom" style="font-size: 14px;"><c:out value="${sepayAccountName}"/></p>
                                <p class="mb-0 text-muted" style="font-size: 13px;"><c:out value="${sepayBankCode}"/> - <c:out value="${sepayAccountNumber}"/></p>
                            </div>
                        </div>
                    </div>

                    <!-- Bảng cấu hình chi tiết -->
                    <div class="col-md-8 mb-4">
                        <div class="raised-card overflow-hidden h-100">
                            <div class="card-header-row">
                                <div>
                                    <h3 class="card-title">Chi tiết thông số kỹ thuật</h3>
                                    <p class="card-subtitle">Cẩn thận khi cập nhật API Key vì có thể làm gián đoạn webhook</p>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-lms mb-0">
                                    <thead>
                                        <tr>
                                            <th>Khóa Cấu Hình</th>
                                            <th>Mô Tả</th>
                                            <th class="text-center">Giá Trị</th>
                                            <th class="text-end">Thao Tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="cfg" items="${sepayConfigs}">
                                            <tr>
                                                <td class="fw-bold" style="font-size: 13px; font-family: 'Courier New', monospace;">
                                                    <c:out value="${cfg.configKey}"/>
                                                </td>
                                                <td style="font-size: 13px; color: var(--on-surface-variant); max-width: 200px;">
                                                    <c:out value="${cfg.description}"/>
                                                </td>
                                                <td class="text-center" style="max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                    <span style="background: var(--surface-container-low); border: 1px solid var(--outline-variant); border-radius: var(--radius-sm); padding: 4px 12px; font-family: 'Courier New', monospace; font-size: 13px; font-weight: 700; color: var(--primary);">
                                                        <c:choose>
                                                            <c:when test="${cfg.configKey == 'SEPAY_API_KEY' && not empty cfg.configValue}">
                                                                ••••••••••••••••
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:out value="${cfg.configValue}"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td class="text-end">
                                                    <button type="button"
                                                            class="btn btn-sm btn-primary-custom rounded-2 d-inline-flex align-items-center gap-1"
                                                            data-bs-toggle="modal" data-bs-target="#editModal"
                                                            onclick="prefillModal('<c:out value="${cfg.configKey}"/>', '<c:out value="${cfg.configValue}"/>', '<c:out value="${cfg.description}"/>')">
                                                        <span class="material-symbols-outlined" style="font-size: 15px;">edit</span> Sửa
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty sepayConfigs}">
                                            <tr>
                                                <td colspan="4" class="text-center py-5">
                                                    <span class="material-symbols-outlined d-block mb-2" style="font-size: 40px; color: var(--outline);">inbox</span>
                                                    <span style="color: var(--on-surface-variant); font-size: 14px;">Chưa có cấu hình tích hợp.</span>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <!-- Modal Cập Nhật Cấu Hình -->
    <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <form action="${pageContext.request.contextPath}/manager/payment-config" method="POST" class="modal-content" style="border-radius: var(--radius-lg);">
                <div class="modal-header" style="border-bottom: 1px solid var(--outline-variant);">
                    <h5 class="modal-title fw-bold" id="editModalLabel">
                        <span class="material-symbols-outlined align-middle me-2" style="color: var(--primary); font-size: 20px;">edit_document</span>
                        Cập nhật cấu hình SePay
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <input type="hidden" name="configKey" id="modalConfigKey">

                    <div class="mb-3">
                        <label class="d-block mb-1 fw-bold text-on-surface-variant text-uppercase"
                               style="font-size: 10px; letter-spacing: 0.08em;">Mô tả tham số</label>
                        <p id="modalConfigDesc" class="text-muted mb-0 p-3 rounded-2" style="font-size: 13.5px; background: var(--surface-container-low); border: 1px solid var(--outline-variant);"></p>
                    </div>

                    <div class="mb-3">
                        <label for="modalConfigValue" class="form-label fw-bold">Giá trị mới <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="modalConfigValue" name="configValue" required
                               style="border: 1.5px solid var(--outline-variant); border-radius: var(--radius-md);">
                        <div class="form-text mt-2 text-warning" id="modalWarningText" style="display: none; font-size: 12px;">
                            <span class="material-symbols-outlined align-middle" style="font-size: 14px;">warning</span>
                            Cảnh báo: Thay đổi API Key có thể khiến hệ thống không nhận được webhook từ SePay.
                        </div>
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
            
            var warningEl = document.getElementById('modalWarningText');
            if (key === 'SEPAY_API_KEY') {
                warningEl.style.display = 'block';
            } else {
                warningEl.style.display = 'none';
            }
        }
    </script>
</body>
</html>
