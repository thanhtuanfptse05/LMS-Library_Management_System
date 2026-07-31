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
        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: #f7f9fb;">

            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1400px; margin: 0 auto;">

                <!-- ─── Alert Messages ─── -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">check_circle</span>
                        <c:out value="${sessionScope.successMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4" role="alert">
                        <span class="material-symbols-outlined me-2">error</span>
                        <c:out value="${sessionScope.errorMessage}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- ─── Section Header ─── -->
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="fw-bold mb-0 text-primary-custom" style="font-size: 22px;">Quản lý tài khoản người dùng</h2>
                        <p class="text-on-surface-variant mb-0" style="font-size: 13px;">Tra cứu, thêm mới, cập nhật thông tin và kiểm soát trạng thái hoạt động của độc giả/nhân viên.</p>
                    </div>
                    <div class="d-flex flex-wrap gap-2 w-100 w-md-auto">
                        <button class="btn btn-outline-secondary rounded-3 fw-bold px-3 d-flex align-items-center justify-content-center gap-1 flex-grow-1 flex-md-grow-0" 
                                style="font-size: 14px; border: 1px solid var(--outline-variant);"
                                onclick="exportUsers()">
                            <span class="material-symbols-outlined" style="font-size: 18px;">download</span> Xuất Excel
                        </button>
                        <button class="btn btn-outline-secondary rounded-3 fw-bold px-3 d-flex align-items-center justify-content-center gap-1 flex-grow-1 flex-md-grow-0" 
                                style="font-size: 14px; border: 1px solid var(--outline-variant);"
                                data-bs-toggle="modal" data-bs-target="#importUserModal">
                            <span class="material-symbols-outlined" style="font-size: 18px;">upload_file</span> Nhập từ Excel/CSV
                        </button>
                        <button class="btn btn-primary-custom rounded-3 fw-bold px-3 d-flex align-items-center justify-content-center gap-1 flex-grow-1 flex-md-grow-0" 
                                style="font-size: 14px;"
                                data-bs-toggle="modal" data-bs-target="#createUserModal">
                            <span class="material-symbols-outlined" style="font-size: 18px;">person_add</span> Thêm người dùng
                        </button>
                    </div>
                </div>

                <!-- ─── Search & Filter Card ─── -->
                <div class="raised-card p-3 mb-4 bg-white">
                    <form action="${pageContext.request.contextPath}/admin/user" method="GET" id="searchForm" class="row g-3 align-items-end">
                        <input type="hidden" name="page" value="1">
                        
                        <div class="col-12 col-md-5">
                            <label for="searchInput" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 10px; letter-spacing: 0.05em;">Từ khóa tìm kiếm</label>
                            <div class="position-relative">
                                <span class="material-symbols-outlined text-on-surface-variant position-absolute" style="left: 12px; top: 50%; transform: translateY(-50%); font-size: 20px;">search</span>
                                <input type="text" class="form-control config-input w-100 ps-5" id="searchInput" name="search" value="<c:out value="${search}" />" placeholder="Tìm theo Email, Họ tên, Mã số định danh...">
                            </div>
                        </div>

                        <div class="col-6 col-md-3">
                            <label for="roleFilter" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 10px; letter-spacing: 0.05em;">Vai trò</label>
                            <select class="form-select config-input w-100" id="roleFilter" name="role" onchange="this.form.submit();">
                                <option value="ALL" ${role eq 'ALL' ? 'selected' : ''}>— Tất cả vai trò —</option>
                                <option value="STUDENT" ${role eq 'STUDENT' ? 'selected' : ''}>Độc giả Sinh viên</option>
                                <option value="LECTURER" ${role eq 'LECTURER' ? 'selected' : ''}>Độc giả Giảng viên</option>
                                <option value="LIBRARIAN" ${role eq 'LIBRARIAN' ? 'selected' : ''}>Thủ thư</option>
                                <option value="ADMIN" ${role eq 'ADMIN' ? 'selected' : ''}>Quản trị viên</option>
                            </select>
                        </div>

                        <div class="col-6 col-md-2">
                            <label for="statusFilter" class="form-label fw-semibold text-on-surface-variant text-uppercase" style="font-size: 10px; letter-spacing: 0.05em;">Trạng thái</label>
                            <select class="form-select config-input w-100" id="statusFilter" name="status" onchange="this.form.submit();">
                                <option value="ALL" ${status eq 'ALL' ? 'selected' : ''}>— Tất cả —</option>
                                <option value="active" ${status eq 'active' ? 'selected' : ''}>Hoạt động</option>
                                <option value="locked" ${status eq 'locked' ? 'selected' : ''}>Bị khóa</option>
                            </select>
                        </div>

                        <div class="col-12 col-md-2 d-grid">
                            <button type="submit" class="btn btn-primary-custom rounded-3 fw-bold" style="height: 40px; font-size: 14px;">Tìm kiếm</button>
                        </div>
                    </form>
                </div>

                <!-- ─── Users List Table ─── -->
                <div class="raised-card overflow-hidden bg-white mb-4">
                    <div class="table-responsive">
                        <table class="table table-lms table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Thông tin người dùng</th>
                                    <th>Mã định danh</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Số điện thoại</th>
                                    <th class="text-end" style="width: 150px;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty users}">
                                        <c:forEach var="u" items="${users}">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <div class="avatar" style="background-color: var(--primary-fixed); color: var(--on-primary-container); width: 36px; height: 36px; font-size: 13px;">
                                                            <c:out value="${fn:substring(u.fullName != null ? u.fullName : u.email, 0, 1).toUpperCase()}" />
                                                        </div>
                                                        <div>
                                                            <p class="fw-bold mb-0" style="font-size: 14px; color: var(--on-surface);"><c:out value="${u.fullName != null ? u.fullName : '—'}" /></p>
                                                            <p class="text-on-surface-variant mb-0" style="font-size: 12px;"><c:out value="${u.email}" /></p>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="fw-semibold" style="font-size: 13px; color: var(--on-surface);">
                                                    <c:out value="${u.code != null ? u.code : '—'}" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${fn:toUpperCase(u.role) eq 'STUDENT'}">
                                                            <span class="badge-pill" style="background-color: var(--tertiary-fixed); color: var(--on-tertiary-fixed-variant);">STUDENT</span>
                                                        </c:when>
                                                        <c:when test="${fn:toUpperCase(u.role) eq 'LECTURER'}">
                                                            <span class="badge-pill" style="background-color: #fef3c7; color: #d97706;">LECTURER</span>
                                                        </c:when>
                                                        <c:when test="${fn:toUpperCase(u.role) eq 'LIBRARIAN'}">
                                                            <span class="badge-pill" style="background-color: #d1fae5; color: #065f46;">LIBRARIAN</span>
                                                        </c:when>
                                                        <c:when test="${fn:toUpperCase(u.role) eq 'ADMIN'}">
                                                            <span class="badge-pill" style="background-color: var(--primary-fixed); color: var(--on-primary-container);">ADMIN</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-pill bg-light text-dark"><c:out value="${u.role}" /></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${u.status eq 'active'}">
                                                            <span class="d-flex align-items-center gap-1 fw-semibold" style="color: #10b981; font-size: 13px;">
                                                                <span class="rounded-circle d-inline-block" style="width: 8px; height: 8px; background: #10b981;"></span>
                                                                Hoạt động
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="d-flex flex-column align-items-start">
                                                                <span class="d-flex align-items-center gap-1 fw-semibold" style="color: var(--error); font-size: 13px;" title="Tài khoản bị khóa">
                                                                    <span class="rounded-circle d-inline-block animate-pulse" style="width: 8px; height: 8px; background: var(--error);"></span>
                                                                    Đã khóa
                                                                </span>
                                                                <span class="text-danger mt-1 fw-medium" style="font-size: 11px; padding-left: 12px;">
                                                                    <c:choose>
                                                                        <c:when test="${u.lockReason eq 'unpaid'}">
                                                                            Lý do: Nợ phạt quá hạn
                                                                        </c:when>
                                                                        <c:when test="${u.lockReason eq 'securitybreach' or (not empty u.lockedUntil)}">
                                                                            Lý do: Nhập sai MK quá 5 lần
                                                                        </c:when>
                                                                        <c:when test="${not empty u.lockReason}">
                                                                            Lý do: <c:out value="${u.lockReason}" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Lý do: Bởi quản trị viên
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-on-surface-variant" style="font-size: 13px;">
                                                    <c:out value="${u.phoneNumber != null and not empty u.phoneNumber ? u.phoneNumber : '—'}" />
                                                </td>
                                                <td class="text-end">
                                                    <div class="d-inline-flex gap-1">
                                                        <c:if test="${!(fn:toUpperCase(u.role) eq 'ADMIN' and u.userId != sessionScope.userId)}">
                                                            <c:choose>
                                                                <c:when test="${u.status eq 'active'}">
                                                                    <button class="btn-icon" title="Khóa tài khoản" 
                                                                            onclick="openLockModal('${u.userId}', '<c:out value="${u.fullName != null ? u.fullName : ''}" />', '<c:out value="${u.email}" />')">
                                                                        <span class="material-symbols-outlined text-danger" style="font-size: 19px;">lock</span>
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button class="btn-icon" title="Mở khóa tài khoản" onclick="quickUnlock('${u.userId}')">
                                                                        <span class="material-symbols-outlined text-success" style="font-size: 19px;">lock_open</span>
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            
                                                            <button class="btn-icon" title="Chi tiết / Chỉnh sửa" 
                                                                    data-bs-toggle="modal" data-bs-target="#editUserModal"
                                                                    data-userid="${u.userId}"
                                                                    data-email="${u.email}"
                                                                    data-fullname="${u.fullName}"
                                                                    data-phone="${u.phoneNumber}"
                                                                    data-gender="${u.gender}"
                                                                    data-dob="${u.dateOfBirth}"
                                                                    data-code="${u.code}"
                                                                    data-role="${u.role}"
                                                                    data-status="${u.status}"
                                                                    data-major="${u.major}"
                                                                    data-year="${u.enrollmentYear}"
                                                                    data-dept="${u.department}"
                                                                    onclick="populateEditModal(this)">
                                                                <span class="material-symbols-outlined text-primary-custom" style="font-size: 19px;">edit</span>
                                                            </button>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="text-center py-5 text-muted">
                                                <span class="material-symbols-outlined d-block mb-2" style="font-size: 40px; color: var(--outline-variant);">group_off</span>
                                                Không tìm thấy người dùng nào phù hợp với bộ lọc tìm kiếm.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- ─── Pagination Footer ─── -->
                    <div class="p-3 bg-surface-container-low border-top border-outline-variant d-flex flex-column flex-sm-row justify-content-between align-items-center gap-3" style="font-size: 13px;">
                        <div class="text-on-surface-variant">
                            Hiển thị <strong>${fn:length(users)}</strong> trên <strong>${totalUsers}</strong> người dùng
                        </div>
                        
                        <c:if test="${totalPages > 1}">
                            <nav aria-label="Page navigation">
                                <ul class="pagination pagination-sm mb-0">
                                    <!-- Nút Trang trước -->
                                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                        <c:url var="prevUrl" value="/admin/user">
                                            <c:param name="search" value="${search}" />
                                            <c:param name="role" value="${role}" />
                                            <c:param name="status" value="${status}" />
                                            <c:param name="page" value="${page - 1}" />
                                            <c:param name="pageSize" value="${pageSize}" />
                                        </c:url>
                                        <a class="page-link" href="${prevUrl}" aria-label="Trang trước">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                    
                                    <!-- Các số trang -->
                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <li class="page-item ${page == i ? 'active' : ''}">
                                            <c:url var="pageUrl" value="/admin/user">
                                                <c:param name="search" value="${search}" />
                                                <c:param name="role" value="${role}" />
                                                <c:param name="status" value="${status}" />
                                                <c:param name="page" value="${i}" />
                                                <c:param name="pageSize" value="${pageSize}" />
                                            </c:url>
                                            <a class="page-link" href="${pageUrl}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    
                                    <!-- Nút Trang sau -->
                                    <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                                        <c:url var="nextUrl" value="/admin/user">
                                            <c:param name="search" value="${search}" />
                                            <c:param name="role" value="${role}" />
                                            <c:param name="status" value="${status}" />
                                            <c:param name="page" value="${page + 1}" />
                                            <c:param name="pageSize" value="${pageSize}" />
                                        </c:url>
                                        <a class="page-link" href="${nextUrl}" aria-label="Trang sau">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </div>

                </div>

            </div><!-- /container-fluid -->

            <jsp:include page="fragments/_footer.jsp" />

        </main>
    </div><!-- /.d-flex.main-wrapper -->

    <!-- Nhúng các Modal Fragments -->
    <jsp:include page="fragments/_user_create_modal.jsp" />
    <jsp:include page="fragments/_user_edit_modal.jsp" />
    <jsp:include page="fragments/_user_import_modal.jsp" />
    <jsp:include page="fragments/_user_lock_modal.jsp" />

    <!-- Form ẩn để thay đổi trạng thái nhanh -->
    <form id="quickToggleForm" action="${pageContext.request.contextPath}/admin/user/update" method="POST" style="display:none;">
        <input type="hidden" name="action" value="toggleStatus">
        <input type="hidden" name="userId" id="quickUserId">
        <input type="hidden" name="status" id="quickStatus">
        <input type="hidden" name="lockReason" id="quickLockReason">
    </form>

    <script>
        function openLockModal(userId, fullName, email) {
            document.getElementById('lockModalUserId').value = userId;
            const userText = fullName ? fullName + ' (' + email + ')' : email;
            document.getElementById('lockModalUserText').textContent = userText;
            document.getElementById('lockModalReason').value = '';
            var charCount = document.getElementById('lockReasonCharCount');
            if (charCount) charCount.textContent = '0/50';
            
            const lockModal = new bootstrap.Modal(document.getElementById('lockUserModal'));
            lockModal.show();
        }

        function quickUnlock(userId) {
            if (confirm('Bạn có chắc chắn muốn mở khóa tài khoản này?')) {
                document.getElementById('quickUserId').value = userId;
                document.getElementById('quickStatus').value = 'active';
                document.getElementById('quickLockReason').value = '';
                document.getElementById('quickToggleForm').submit();
            }
        }

        function exportUsers() {
            const search = document.getElementById("searchInput").value;
            const role = document.getElementById("roleFilter").value;
            const status = document.getElementById("statusFilter").value;
            
            const url = "${pageContext.request.contextPath}/admin/user/export?search=" 
                + encodeURIComponent(search) 
                + "&role=" + encodeURIComponent(role) 
                + "&status=" + encodeURIComponent(status);
                
            window.location.href = url;
        }
    </script>

</body>
</html>
