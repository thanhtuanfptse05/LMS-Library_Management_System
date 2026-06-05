<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Quản lý Mẫu Email | Thư viện Lumina</title>

                <!-- Bootstrap 5 CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

                <!-- Google Fonts & Icons -->
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap"
                    rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                    rel="stylesheet" />

                <style>
                    body {
                        font-family: 'Inter', sans-serif;
                        background-color: #f7f9fb;
                        color: #191c1e;
                        overflow-x: hidden;
                    }

                    /* Sidebar Layout Customization */
                    .sidebar {
                        width: 260px;
                        height: 100vh;
                        position: fixed;
                        left: 0;
                        top: 0;
                        background-color: #f2f4f6;
                        z-index: 1000;
                        border-right: 1px solid #e0e3e5;
                    }

                    .main-content {
                        margin-left: 260px;
                        min-height: 100vh;
                        display: flex;
                        flex-direction: column;
                    }

                    .nav-link-custom {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        padding: 12px 16px;
                        color: #565e74;
                        text-decoration: none;
                        border-radius: 8px;
                        transition: all 0.2s;
                    }

                    .nav-link-custom:hover {
                        background-color: #e6e8ea;
                        color: #191c1e;
                    }

                    .nav-link-custom.active {
                        color: #9d4300;
                        font-weight: bold;
                        background-color: rgba(255, 182, 144, 0.2);
                        border-right: 4px solid #9d4300;
                    }

                    .material-symbols-outlined {
                        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                        vertical-align: middle;
                    }

                    .avatar-img {
                        width: 32px;
                        height: 32px;
                        border-radius: 50%;
                        object-cover: cover;
                        border: 2px solid #ffdbca;
                    }

                    .preview-box {
                        background: #ffffff;
                        border: 1px solid #e0e3e5;
                        border-radius: 8px;
                        padding: 20px;
                        min-height: 250px;
                    }
                </style>
            </head>

            <body>

                <!-- Sidebar Navigation -->
                <div class="sidebar d-flex flex-col p-3">
                    <div class="mb-4 px-2">
                        <h2 class="h4 fw-bold text-danger m-0" style="color: #9d4300 !important;">Cổng thông tin Thư viện</h2>
                        <small class="text-muted">Trung tâm Tài nguyên Học thuật</small>
                    </div>

                    <ul class="nav flex-column flex-grow-1 gap-1">
                        <li class="nav-item">
                            <a href="dashboard" class="nav-link-custom">
                                <span class="material-symbols-outlined">dashboard</span>Bảng điều khiển
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="catalog" class="nav-link-custom">
                                <span class="material-symbols-outlined">menu_book</span>Danh mục Sách
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="loans" class="nav-link-custom">
                                <span class="material-symbols-outlined">auto_stories</span>Sách tôi mượn
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="reservations" class="nav-link-custom">
                                <span class="material-symbols-outlined">bookmark</span>Đặt trước
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="templates" class="nav-link-custom active">
                                <span class="material-symbols-outlined">description</span>Mẫu Tài liệu
                            </a>
                        </li>
                    </ul>

                    <div class="mt-auto pt-3 border-top border-secondary-subtle">
                        <a href="settings" class="nav-link-custom mb-1">
                            <span class="material-symbols-outlined">settings</span>Cài đặt
                        </a>
                        <a href="help" class="nav-link-custom">
                            <span class="material-symbols-outlined">help</span>Trợ giúp
                        </a>
                    </div>
                </div>

                <!-- Main Content Area -->
                <div class="main-content">
                    <!-- Top Navbar -->
                    <header class="navbar navbar-expand bg-white border-bottom px-4 sticky-top justify-content-between"
                        style="height: 64px;">
                        <div class="d-flex align-items-center gap-3">
                            <span class="navbar-brand h5 m-0 fw-semibold" style="color: #9d4300;">Hệ thống Quản lý Thư viện
                                </span>
                            <div class="d-none d-md-flex gap-3 ms-4">
                                <a href="#" class="text-secondary text-decoration-none small">Hướng dẫn Nghiên cứu</a>
                                <a href="#" class="text-secondary text-decoration-none small">Lưu trữ</a>
                                <a href="#" class="text-secondary text-decoration-none small">Tài nguyên điện tử</a>
                            </div>
                        </div>

                        <div class="d-flex align-items-center gap-3">
                            <div class="position-relative p-2 btn btn-light rounded-circle border-0">
                                <span class="material-symbols-outlined text-secondary">notifications</span>
                                <span
                                    class="position-absolute top-2 start-75 translate-middle p-1 bg-danger border border-light rounded-circle"></span>
                            </div>
                            <div class="d-flex align-items-center gap-2 cursor-pointer">
                                <img alt="Avatar" class="avatar-img"
                                    src="https://lh3.googleusercontent.com/aida-public/..." />
                                <span class="material-symbols-outlined text-secondary">expand_more</span>
                            </div>
                        </div>
                    </header>

                    <!-- Content Body -->
                    <div class="container-fluid p-4">
                        <!-- Header Section -->
                        <div class="d-flex justify-content-between align-items-end mb-4">
                            <div>
                                <h2 class="fw-bold m-0">Quản lý Mẫu Email Tự động</h2>
                                <p class="text-muted m-0">Quản lý các thông báo và liên lạc email do hệ thống tạo ra.
                                    </p>
                            </div>
                            <button class="btn text-white fw-bold d-flex align-items-center gap-2 px-3 py-2 shadow-sm"
                                style="background-color: #9d4300;" data-bs-toggle="modal"
                                data-bs-target="#editTemplateModal" onclick="clearForm()">
                                <span class="material-symbols-outlined">add_circle</span> Tạo Mẫu mới
                            </button>
                        </div>

                        <!-- Main Grid Layout -->
                        <div class="row g-4">
                            <!-- Templates Table Card -->
                            <div class="col-12 col-xl-9">
                                <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                                    <div
                                        class="card-header bg-white p-3 border-bottom d-flex justify-content-between align-items-center">
                                        <div class="position-relative flex-grow-1 max-w-sm" style="max-width: 400px;">
                                            <input class="form-control ps-5 bg-light border-0"
                                                placeholder="Search templates..." type="text" />
                                            <span
                                                class="material-symbols-outlined position-absolute top-50 start-0 translate-middle-y ms-3 text-secondary">search</span>
                                        </div>
                                        <div class="d-flex align-items-center gap-2 text-secondary small">
                                            <span class="material-symbols-outlined">filter_list</span>
                                            <span class="fw-bold text-uppercase tracking-wider"
                                                style="font-size: 11px;">Sắp xếp: Gần đây</span>
                                        </div>
                                    </div>

                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="table-light text-secondary uppercase tracking-wider"
                                                style="font-size: 12px;">
                                                <tr>
                                                    <th class="px-4 py-3">Tên Mẫu</th>
                                                    <th class="px-3 py-3">Tiêu đề Email</th>
                                                    <th class="px-3 py-3">Cập nhật lần cuối</th>
                                                    <th class="px-3 py-3">Trạng thái</th>
                                                    <th class="px-4 py-3 text-end">Hành động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <!-- JSTL Core Loop to Render Templates Dynamically From Database -->
                                                <c:forEach var="template" items="${emailTemplates}">
                                                    <tr>
                                                        <td class="px-4 py-3">
                                                            <div class="d-flex flex-column">
                                                                <span class="fw-bold">${template.name}</span>
                                                                <small
                                                                    class="text-muted">${template.description}</small>
                                                            </div>
                                                        </td>
                                                        <td class="px-3 py-3 text-truncate" style="max-width: 250px;">
                                                            ${template.subject}</td>
                                                        <td class="px-3 py-3 text-muted">
                                                            <fmt:formatDate value="${template.lastUpdated}"
                                                                pattern="MMM dd, yyyy" />
                                                        </td>
                                                        <td class="px-3 py-3">
                                                            <c:choose>
                                                                <c:when class="${template.status == 'Active'}">
                                                                    <span
                                                                        class="badge bg-success-subtle text-success rounded-pill px-2.5 py-1">Hoạt động</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span
                                                                        class="badge bg-secondary-subtle text-secondary rounded-pill px-2.5 py-1">Nháp</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="px-4 py-3 text-end">
                                                            <div class="btn-group gap-1">
                                                                <button
                                                                    class="btn btn-sm btn-outline-secondary d-inline-flex align-items-center"
                                                                    title="Xem trước" data-bs-toggle="modal"
                                                                    data-bs-target="#previewTemplateModal"
                                                                    onclick="loadPreview('${template.subject}', '${template.body}')">
                                                                    <span class="material-symbols-outlined"
                                                                        style="font-size: 18px;">visibility</span>
                                                                </button>
                                                                <button
                                                                    class="btn btn-sm btn-outline-primary d-inline-flex align-items-center"
                                                                    title="Chỉnh sửa Mẫu" data-bs-toggle="modal"
                                                                    data-bs-target="#editTemplateModal"
                                                                    onclick="populateForm('${template.id}', '${template.name}', '${template.subject}', '${template.body}', '${template.status}')">
                                                                    <span class="material-symbols-outlined"
                                                                        style="font-size: 18px;">edit</span>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>

                                                <%-- Fallback UI if data list is empty --%>
                                                    <c:if test="${empty emailTemplates}">
                                                        <tr>
                                                            <td colspan="5" class="text-center py-5 text-muted">
                                                                <span
                                                                    class="material-symbols-outlined display-6 d-block mb-2">mail_lock</span>
                                                                Không có mẫu email nào trong hệ thống.
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <!-- Sidebar Info Widgets -->
                            <div class="col-12 col-xl-3 d-flex flex-column gap-4">
                                <!-- Stats Card -->
                                <div class="card border-0 shadow-sm rounded-3 p-4 text-white"
                                    style="background-color: #ffdbca; color: #341100 !important;">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span class="fw-bold text-uppercase tracking-wider"
                                            style="font-size: 11px; opacity: 0.8;">Tỷ lệ Tương tác</span>
                                        <span class="material-symbols-outlined">trending_up</span>
                                    </div>
                                    <h3 class="display-6 fw-bold m-0 mb-1">92.4%</h3>
                                    <p class="small m-0 opacity-70">Tỷ lệ mở email trên tất cả các mẫu trong tháng này.</p>
                                    <div class="progress mt-3"
                                        style="height: 6px; background-color: rgba(52, 17, 0, 0.1);">
                                        <div class="progress-bar" role="progressbar"
                                            style="width: 92%; background-color: #9d4300;"></div>
                                    </div>
                                </div>

                                <!-- Guidelines Card -->
                                <div class="card border-0 shadow-sm rounded-3 p-4 bg-light border">
                                    <h5 class="fw-bold d-flex align-items-center gap-2 mb-3">
                                        <span class="material-symbols-outlined" style="color: #9d4300;">info</span> Thực hành Tốt nhất
                                    </h5>
                                    <ul class="list-unstyled d-flex flex-column gap-2 small text-muted mb-0">
                                        <li class="d-flex align-items-start gap-2">
                                            <span class="material-symbols-outlined text-success"
                                                style="font-size: 16px; margin-top: 2px;">check_circle</span>
                                            Sử dụng các biến như {student_name} hoặc {due_date} cho dữ liệu động.
                                        </li>
                                        <li class="d-flex align-items-start gap-2">
                                            <span class="material-symbols-outlined text-success"
                                                style="font-size: 16px; margin-top: 2px;">check_circle</span>
                                            Đảm bảo liên kết CTA dẫn đến cổng thông tin FAP một cách an toàn.
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ==================== INTERACTIVE LAYER: BOOTSTRAP MODALS ==================== -->

                <!-- Form Edit / Create Template Modal -->
                <div class="modal fade" id="editTemplateModal" tabindex="-1" aria-labelledby="editModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                        <div class="modal-content border-0 shadow">
                            <form action="templates/save" method="POST">
                                <div class="modal-header">
                                    <h5 class="modal-title fw-bold" id="editModalLabel">Chỉnh sửa Mẫu Email</h5>
                                    <button type="button" class="btn-close" data-bs-shadow="none"
                                        data-bs-dismiss="modal" aria-label="Đóng"></button>
                                </div>
                                <div class="modal-body p-4">
                                    <input type="hidden" id="templateId" name="id">

                                    <div class="row g-3">
                                        <div class="col-md-8">
                                            <label for="templateName" class="form-label fw-semibold small">Mã Định danh Mẫu</label>
                                            <input type="text" class="form-control text-uppercase" id="templateName"
                                                name="name" required placeholder="e.g., OVERDUE_NOTICE_1">
                                        </div>
                                        <div class="col-md-4">
                                            <label for="templateStatus" class="form-label fw-semibold small">Trạng thái Xuất bản</label>
                                            <select class="form-select" id="templateStatus" name="status">
                                                <option value="Active">Hoạt động</option>
                                                <option value="Draft">Nháp</option>
                                            </select>
                                        </div>
                                        <div class="col-12">
                                            <label for="templateSubject" class="form-label fw-semibold small">Tiêu đề Email</label>
                                            <input type="text" class="form-control" id="templateSubject" name="subject"
                                                required placeholder="Nhập tiêu đề email">
                                        </div>
                                        <div class="col-12">
                                            <label for="templateBody" class="form-label fw-semibold small">Nội dung Email
                                                (HTML/Văn bản)</label>
                                            <textarea class="form-control" id="templateBody" name="body" rows="8"
                                                required placeholder="Dear {student_name}, ..."></textarea>
                                            <div class="form-text text-muted" style="font-size: 11px;">
                                                Các biến có sẵn: <code>{student_name}</code>,
                                                <code>{book_title}</code>, <code>{due_date}</code>.
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer bg-light">
                                    <button type="button" class="btn btn-secondary px-4"
                                        data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn text-white px-4"
                                        style="background-color: #9d4300;">Lưu Thay đổi Mẫu</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Live Preview Email Modal -->
                <div class="modal fade" id="previewTemplateModal" tabindex="-1" aria-labelledby="previewModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content border-0 shadow">
                            <div class="modal-header">
                                <h5 class="modal-title fw-bold" id="previewModalLabel">Xem trước Email</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Đóng"></button>
                            </div>
                            <div class="modal-body p-4 bg-light">
                                <div class="card border-0 shadow-sm p-3 mb-3 bg-white">
                                    <div class="small mb-1"><strong>Từ:</strong> Trung tâm Hỗ trợ Học thuật
                                        &lt;noreply@fpt.edu.vn&gt;</div>
                                    <div class="small mb-1"><strong>Đến:</strong> student_sample@fpt.edu.vn</div>
                                    <div class="small"><strong>Tiêu đề:</strong> <span id="previewSubjectText"
                                            class="text-primary fw-semibold"></span></div>
                                </div>
                                <div class="preview-box shadow-sm" id="previewBodyContent">
                                    <!-- Simulated compilation output populated via JavaScript inside layout -->
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary w-100" data-bs-dismiss="modal">Đóng
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bootstrap 5 JS Bundle with Popper -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

                <!-- JavaScript Data Transfer Mapping Drivers -->
                <script>
                    // Mapping dynamic model rows data to Form Inputs when editing
                    function populateForm(id, name, subject, body, status) {
                        document.getElementById('templateId').value = id;
                        document.getElementById('templateName').value = name;
                        document.getElementById('templateSubject').value = subject;
                        document.getElementById('templateBody').value = body;
                        document.getElementById('templateStatus').value = status;
                        document.getElementById('editModalLabel').innerText = 'Chỉnh sửa Mẫu Hệ thống: ' + name;
                    }

                    // Reset inputs clear trigger for creation flows
                    function clearForm() {
                        document.getElementById('templateId').value = '';
                        document.getElementById('templateName').value = '';
                        document.getElementById('templateSubject').value = '';
                        document.getElementById('templateBody').value = '';
                        document.getElementById('templateStatus').value = 'Active';
                        document.getElementById('editModalLabel').innerText = 'Tạo Mẫu Tự động mới';
                    }

                    // Live Render simulation logic replacing placeholders variables tags
                    function loadPreview(subject, body) {
                        // Replace tags to mock data for presentation values demo
                        let mockedBody = body
                            .replace(/{student_name}/g, '<strong>Vũ Doanh Thái</strong>')
                            .replace(/{book_title}/g, '<em>"Java Web Development with Tomcat"</em>')
                            .replace(/{due_date}/g, '<span class="text-danger fw-bold">June 15, 2026</span>');

                        document.getElementById('previewSubjectText').innerText = subject;
                        document.getElementById('previewBodyContent').innerHTML = mockedBody;
                    }
                </script>
            </body>

            </html>