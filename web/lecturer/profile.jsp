<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<jsp:include page="fragments/_head.jsp" />

<style>
    :root {
        --bs-primary: #9d4300;
        --bs-primary-rgb: 157, 67, 0;
        --primary-container: #f97316;
        --primary-fixed: #ffdbca;
        --on-surface: #191c1e;
        --on-surface-variant: #584237;
        --surface-container-lowest: #ffffff;
        --surface-container-low: #f2f4f6;
        --surface-container-high: #e6e8ea;
        --secondary-container: #dae2fd;
        --on-secondary-container: #5c647a;
        --outline-variant: #e0c0b1;
        --surface-variant: #e0e3e5;
        --background: #f7f9fb;
    }

    .font-headline-lg { font-size: 32px; line-height: 40px; letter-spacing: -0.01em; font-weight: 600; }
    @media (max-width: 768px) { .font-headline-lg { font-size: 24px; line-height: 32px; } }
    .font-headline-md { font-size: 24px; line-height: 32px; font-weight: 600; }
    .font-title-lg { font-size: 20px; line-height: 28px; font-weight: 600; }
    .font-body-md { font-size: 16px; line-height: 24px; font-weight: 400; }
    .font-body-sm { font-size: 14px; line-height: 20px; font-weight: 400; }
    .font-label-md { font-size: 12px; line-height: 16px; letter-spacing: 0.05em; font-weight: 600; }
    .font-display { font-size: 48px; line-height: 56px; letter-spacing: -0.02em; font-weight: 700; }

    .rounded-xl { border-radius: 0.75rem !important; }
    .card-shadow { box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04); transition: transform 0.2s ease-out; }
    .card-shadow:hover { transform: translateY(-2px); }

    .profile-img-container { width: 128px; height: 128px; border: 4px solid var(--primary-fixed); }
    .btn-camera {
        position: absolute; bottom: 0; right: 0; background-color: var(--bs-primary);
        color: white; border: none; padding: 6px; border-radius: 50%;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); transition: transform 0.2s ease;
    }
    .btn-camera:hover { transform: scale(1.05); }
</style>

<body class="d-flex flex-column">

    <jsp:include page="fragments/_sidebar.jsp" />

    <div class="d-flex main-wrapper overflow-hidden">
        
        <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: #f7f9fb;">
            
            <jsp:include page="fragments/_header.jsp" />

            <div class="container-fluid px-4 py-4" style="max-width: 1400px; margin: 0 auto;">

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

                <div class="mb-4">
                    <h2 class="font-headline-lg mb-1" style="color: var(--on-surface);">Hồ sơ giảng viên</h2>
                    <p class="font-body-md text-on-surface-variant">Quản lý thông tin đăng nhập thư viện và thông tin học thuật của bạn.</p>
                </div>

                <div class="row g-4 align-items-start">
                    <div class="col-12 col-lg-4">
                        <div class="d-flex flex-column gap-4">

                            <div class="bg-surface-container-lowest p-4 rounded-xl card-shadow border border-surface-variant text-center">
                                <div class="relative d-inline-block mb-3 position-relative">
                                    <div class="profile-img-container rounded-circle overflow-hidden mx-auto bg-primary-fixed d-flex align-items-center justify-content-center text-primary" style="font-size: 48px; font-weight: bold;">
                                        <c:out value="${not empty profile.fullName ? profile.fullName.substring(0,1).toUpperCase() : 'L'}" />
                                    </div>
                                </div>
                                <h3 class="font-headline-md mb-1" style="color: var(--on-surface);">
                                    <c:out value="${not empty profile.fullName ? profile.fullName : 'Giảng viên khách mời'}" />
                                </h3>
                                <p class="font-body-sm text-on-surface-variant mb-4">
                                    <c:out value="${not empty lecturer.department ? lecturer.department : 'Chưa thiết lập khoa'}" />
                                </p>
                                <div class="d-flex flex-column gap-2">
                                    <button class="btn btn-primary-custom w-100 py-2 rounded-3 fw-bold d-flex align-items-center justify-content-center gap-2"
                                            data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                        <span class="material-symbols-outlined">edit</span>
                                        Chỉnh sửa hồ sơ
                                    </button>
                                    <button class="btn btn-outline-secondary w-100 py-2 rounded-3 fw-bold d-flex align-items-center justify-content-center gap-2"
                                            data-bs-toggle="modal" data-bs-target="#changePwModal">
                                        <span class="material-symbols-outlined">security</span>
                                        Đổi mật khẩu
                                    </button>
                                </div>
                            </div>

                            <div class="bg-surface-container-lowest p-4 rounded-xl card-shadow border border-surface-variant">
                                <div class="d-flex align-items-center justify-content-between mb-4">
                                    <h4 class="font-title-lg mb-0" style="color: var(--on-surface);">Trạng thái thư viện</h4>
                                    <span class="badge bg-success-subtle text-success rounded-pill px-3 py-2 font-label-md d-flex align-items-center gap-2">
                                        <span class="spinner-grow spinner-grow-sm text-success" role="status"
                                              style="width: 8px; height: 8px; --bs-spinner-animation-speed: 1.2s;"></span>
                                        Giảng viên đang hoạt động
                                    </span>
                                </div>
                                <div class="d-flex flex-column gap-2">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="font-body-sm text-on-surface-variant">Sách đã mượn</span>
                                        <span class="font-label-md fw-bold"><c:out value="${activeLoansCount}" /> / 20</span>
                                    </div>
                                    <div class="progress" style="height: 8px; background-color: var(--surface-variant);">
                                        <div class="progress-bar" role="progressbar"
                                             style="width: <c:out value="${activeLoansCount * 5}" />%; background-color: var(--bs-primary);" 
                                             aria-valuenow="<c:out value="${activeLoansCount}" />"
                                             aria-valuemin="0" aria-valuemax="20"></div>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center pt-2">
                                        <span class="font-body-sm text-on-surface-variant">Đặt trước</span>
                                        <span class="font-label-md fw-bold"><c:out value="${activeReservationsCount}" /> Đang hoạt động</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-lg-8">
                        <div class="d-flex flex-column gap-4">

                            <div class="bg-surface-container-lowest p-4 rounded-xl card-shadow border border-surface-variant">
                                <div class="d-flex align-items-center gap-2 mb-4">
                                    <span class="material-symbols-outlined text-primary fs-4">badge</span>
                                    <h4 class="font-title-lg mb-0" style="color: var(--on-surface);">Thông tin cá nhân</h4>
                                </div>

                                <div class="row g-4">
                                    <div class="col-12 col-md-6">
                                        <div class="d-flex flex-column gap-1 border-bottom border-surface-variant pb-2">
                                            <label class="font-label-md text-on-surface-variant text-uppercase tracking-wider">Họ và tên</label>
                                            <p class="font-body-md mb-0 text-on-surface">
                                                <c:out value="${not empty profile.fullName ? profile.fullName : 'Chưa thiết lập'}" />
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <div class="d-flex flex-column gap-1 border-bottom border-surface-variant pb-2">
                                            <label class="font-label-md text-on-surface-variant text-uppercase tracking-wider">Mã giảng viên</label>
                                            <p class="font-body-md mb-0 text-on-surface fw-bold">
                                                <c:out value="${not empty lecturer.lecturerCode ? lecturer.lecturerCode : 'Chưa thiết lập'}" />
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <div class="d-flex flex-column gap-1 border-bottom border-surface-variant pb-2">
                                            <label class="font-label-md text-on-surface-variant text-uppercase tracking-wider">Địa chỉ Email</label>
                                            <p class="font-body-md mb-0 text-on-surface">
                                                <c:out value="${not empty user.email ? user.email : 'Chưa thiết lập'}" />
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <div class="d-flex flex-column gap-1 border-bottom border-surface-variant pb-2">
                                            <label class="font-label-md text-on-surface-variant text-uppercase tracking-wider">Số điện thoại</label>
                                            <p class="font-body-md mb-0 text-on-surface">
                                                <c:out value="${not empty profile.phoneNumber ? profile.phoneNumber : 'Chưa thiết lập'}" />
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <div class="d-flex flex-column gap-1 border-bottom border-surface-variant pb-2">
                                            <label class="font-label-md text-on-surface-variant text-uppercase tracking-wider">Giới tính</label>
                                            <p class="font-body-md mb-0 text-on-surface">
                                                <c:out value="${not empty profile.gender ? profile.gender : 'Chưa thiết lập'}" />
                                            </p>
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <div class="d-flex flex-column gap-1 border-bottom border-surface-variant pb-2">
                                            <label class="font-label-md text-on-surface-variant text-uppercase tracking-wider">Ngày sinh</label>
                                            <p class="font-body-md mb-0 text-on-surface">
                                                <c:choose>
                                                    <c:when test="${not empty profile.dateOfBirth}">
                                                        <fmt:formatDate value="${profile.dateOfBirth}" pattern="MMMM dd, yyyy" />
                                                    </c:when>
                                                    <c:otherwise>Chưa thiết lập</c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="bg-surface-container-lowest p-4 rounded-xl card-shadow border border-surface-variant">
                                <div class="d-flex align-items-center gap-2 mb-4">
                                    <span class="material-symbols-outlined text-primary fs-4">verified_user</span>
                                    <h4 class="font-title-lg mb-0" style="color: var(--on-surface);">Tư cách thành viên giảng viên</h4>
                                </div>

                                <div class="row g-3">
                                    <div class="col-12 col-md-6">
                                        <div class="bg-surface-container-low p-3 rounded-3 border border-outline-variant d-flex align-items-center gap-3">
                                            <div class="d-flex align-items-center justify-content-center bg-white rounded-3 shadow-sm text-primary" style="width: 48px; height: 48px;">
                                                <span class="material-symbols-outlined">event_available</span>
                                            </div>
                                            <div>
                                                <label class="font-label-md text-on-surface-variant d-block">Ngày bắt đầu</label>
                                                <p class="font-body-md fw-bold mb-0 text-on-surface">
                                                    <c:choose>
                                                        <c:when test="${not empty profile.startDate}">
                                                            <fmt:formatDate value="${profile.startDate}" pattern="MMMM dd, yyyy" />
                                                        </c:when>
                                                        <c:otherwise>Chưa thiết lập</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <div class="bg-surface-container-low p-3 rounded-3 border border-outline-variant d-flex align-items-center gap-3">
                                            <div class="d-flex align-items-center justify-content-center bg-white rounded-3 shadow-sm text-primary" style="width: 48px; height: 48px;">
                                                <span class="material-symbols-outlined">event_busy</span>
                                            </div>
                                            <div>
                                                <label class="font-label-md text-on-surface-variant d-block">Ngày kết thúc</label>
                                                <p class="font-body-md fw-bold mb-0 text-on-surface">
                                                    <c:choose>
                                                        <c:when test="${not empty profile.endDate}">
                                                            <fmt:formatDate value="${profile.endDate}" pattern="MMMM dd, yyyy" />
                                                        </c:when>
                                                        <c:otherwise>Không giới hạn</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="fragments/_footer.jsp" />
        </main>
    </div>

    <!-- Modals -->
    <div class="modal fade" id="editProfileModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title font-title-lg">Chỉnh sửa thông tin hồ sơ</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <form action="${pageContext.request.contextPath}/lecturer/profile" method="POST">
                    <input type="hidden" name="action" value="updateInfo" />
                    <div class="modal-body py-4">
                        <div class="d-flex flex-column gap-3">
                            <div>
                                <label class="form-label font-label-md text-on-surface-variant text-uppercase">Họ và tên</label>
                                <input type="text" name="fullName" class="form-control rounded-3 py-2" 
                                       value="<c:out value="${profile.fullName}" />" required />
                            </div>
                            <div>
                                <label class="form-label font-label-md text-on-surface-variant text-uppercase">Số điện thoại</label>
                                <input type="text" name="phoneNumber" class="form-control rounded-3 py-2" 
                                       value="<c:out value="${profile.phoneNumber}" />" />
                            </div>
                            <div>
                                <label class="form-label font-label-md text-on-surface-variant text-uppercase">Giới tính</label>
                                <select name="gender" class="form-select rounded-3 py-2">
                                    <option value="" ${empty profile.gender ? 'selected' : ''}>Chọn giới tính</option>
                                    <option value="Nam" ${profile.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                    <option value="Nữ" ${profile.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                    <option value="Khác" ${profile.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>
                            <div>
                                <label class="form-label font-label-md text-on-surface-variant text-uppercase">Ngày sinh</label>
                                <input type="date" name="dateOfBirth" class="form-control rounded-3 py-2" 
                                       value="<c:out value="${profile.dateOfBirth}" />" />
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4 fw-bold">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="changePwModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title font-title-lg">Thay đổi mật khẩu</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <form action="${pageContext.request.contextPath}/lecturer/profile" method="POST">
                    <input type="hidden" name="action" value="changePw" />
                    <div class="modal-body py-4">
                        <div class="d-flex flex-column gap-3">
                            <div>
                                <label class="form-label font-label-md text-on-surface-variant text-uppercase">Mật khẩu hiện tại</label>
                                <input type="password" name="currentPw" class="form-control rounded-3 py-2" required />
                            </div>
                            <div>
                                <label class="form-label font-label-md text-on-surface-variant text-uppercase">Mật khẩu mới</label>
                                <input type="password" name="newPw" class="form-control rounded-3 py-2" required minlength="8" />
                            </div>
                            <div>
                                <label class="form-label font-label-md text-on-surface-variant text-uppercase">Xác nhận mật khẩu mới</label>
                                <input type="password" name="confirmPw" class="form-control rounded-3 py-2" required minlength="8" />
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary-custom rounded-pill px-4 fw-bold">Cập nhật mật khẩu</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
