<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Xem trước Email - Quản lý Thư viện</title>

                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

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
                    }

                    /* Top Navigation Bar */
                    .top-navbar {
                        height: 64px;
                        background-color: #f7f9fb;
                        border-bottom: 1px solid #e0e3e5;
                    }

                    /* Sidebar Navigation Layout */
                    .sidebar {
                        width: 260px;
                        height: calc(100vh - 64px);
                        position: fixed;
                        left: 0;
                        top: 64px;
                        background-color: #f2f4f6;
                        border-right: 1px solid #e0e3e5;
                        z-index: 1000;
                    }

                    .main-workspace {
                        margin-left: 260px;
                        min-height: calc(100vh - 64px);
                        background-color: #f7f9fb;
                    }

                    @media (max-width: 991.98px) {
                        .sidebar {
                            display: none !important;
                        }

                        .main-workspace {
                            margin-left: 0 !important;
                            padding-bottom: 90px !important;
                        }
                    }

                    .nav-link-custom {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        padding: 12px 16px;
                        color: #565e74;
                        text-decoration: none;
                        border-radius: 12px;
                        font-size: 14px;
                        font-weight: 600;
                        transition: all 0.2s;
                    }

                    .nav-link-custom:hover {
                        background-color: #e6e8ea;
                        color: #191c1e;
                    }

                    .nav-link-custom.active {
                        color: #131b2e;
                        background-color: #dae2fd;
                    }

                    .material-symbols-outlined {
                        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                        vertical-align: middle;
                    }

                    /* Email Canvas Container */
                    .email-preview-wrapper {
                        background-color: #ffffff;
                        border: 1px solid rgba(224, 192, 177, 0.3);
                        border-radius: 12px;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
                        overflow: hidden;
                        transition: all 0.3s ease-in-out;
                        width: 100%;
                        margin: 0 auto;
                    }

                    /* Responsive Viewport Simulator Matrix */
                    .view-desktop {
                        max-width: 100% !important;
                    }

                    .view-mobile {
                        max-width: 420px !important;
                    }
                </style>
            </head>

            <body>

                <header
                    class="navbar navbar-expand bg-white border-bottom px-4 sticky-top justify-content-between top-navbar">
                    <div class="d-flex align-items-center gap-4">
                        <span class="navbar-brand h4 m-0 fw-bold" style="color: #9d4300;">LibraryManager</span>
                        <div class="d-none d-md-flex gap-3 align-items-center">
                            <a href="collections"
                                class="text-secondary text-decoration-none small fw-semibold">Bộ sưu tập</a>
                            <a href="circulation"
                                class="text-secondary text-decoration-none small fw-semibold">Lưu hành</a>
                            <a href="templates"
                                class="text-decoration-none small fw-bold pb-1 border-bottom border-2 border-primary"
                                style="color: #9d4300;">Mẫu email</a>
                            <a href="reports" class="text-secondary text-decoration-none small fw-semibold">Báo cáo</a>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <a href="templates"
                            class="btn btn-light text-secondary fw-semibold btn-sm px-3 py-2 border">Quay lại Danh sách</a>
                        <a href="templates/edit?id=${template.id}" class="btn btn-sm text-white fw-semibold px-3 py-2"
                            style="background-color: #f97316;">Sửa Template</a>
                    </div>
                </header>

                <div class="d-flex">
                    <aside class="sidebar d-flex flex-column p-3">
                        <div class="d-flex align-items-center gap-2 mb-4 px-2">
                            <div class="rounded-circle text-white d-flex align-items-center justify-content-center font-bold"
                                style="width: 40px; height: 40px; background-color: #9d4300;">M</div>
                            <div>
                                <div class="fw-bold text-dark m-0 leading-tight" style="font-size: 16px;">Email Studio
                                </div>
                                <small class="text-muted" style="font-size: 12px;">Quản lý Mẫu</small>
                            </div>
                        </div>

                        <nav class="nav flex-column flex-grow-1 gap-1">
                            <a href="#" class="nav-link-custom">
                                <span class="material-symbols-outlined">drafts</span>Bản nháp
                            </a>
                            <a href="#" class="nav-link-custom active">
                                <span class="material-symbols-outlined">mark_email_read</span>Hoạt động
                            </a>
                            <a href="#" class="nav-link-custom">
                                <span class="material-symbols-outlined">auto_fix_high</span>Tự động hóa
                            </a>
                            <a href="#" class="nav-link-custom">
                                <span class="material-symbols-outlined">history</span>Nhật ký
                            </a>
                            <a href="#" class="nav-link-custom">
                                <span class="material-symbols-outlined">settings</span>Cài đặt
                            </a>
                        </nav>

                        <div class="mt-auto pt-3 border-top">
                            <button class="btn btn-sm text-dark w-100 fw-bold py-2"
                                style="background-color: #ffdbca;">Gửi Email Kiểm thử</button>
                        </div>
                    </aside>

                    <main class="main-workspace flex-grow-1 p-3 p-md-4 p-lg-5">
                        <div class="container-fluid p-0" style="max-width: 1140px;">

                            <div class="mb-4">
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb mb-1" style="font-size: 12px; font-weight: 600;">
                                        <li class="breadcrumb-item text-secondary">Quản lý Thư viện</li>
                                        <li class="breadcrumb-item text-secondary">Mẫu email</li>
                                        <li class="breadcrumb-item active" style="color: #9d4300;">Xem trước</li>
                                    </ol>
                                </nav>
                                <h2 class="fw-bold m-0">Xem trước Mẫu Email</h2>
                            </div>

                            <div class="row g-4">
                                <div class="col-12 col-xl-8">
                                    <div class="email-preview-wrapper" id=" emailFrameWindow" class="view-desktop">

                                        <div class="bg-light p-3 border-bottom text-dark" style="font-size: 14px;">
                                            <div class="row mb-1">
                                                <div class="col-2 col-sm-1 text-secondary">Từ:</div>
                                                <div class="col-10 col-sm-11 fw-semibold">UniLib Thông báo
                                                    &lt;noreply@unilib.edu.vn&gt;</div>
                                            </div>
                                            <div class="row mb-1">
                                                <div class="col-2 col-sm-1 text-secondary">Gửi đến:</div>
                                                <div class="col-10 col-sm-11">
                                                    <span class="badge bg-secondary-subtle text-secondary px-2 py-1"
                                                        id="previewReceiverName">Alex Johnson</span>
                                                </div>
                                            </div>
                                            <div class="row mt-2">
                                                <div class="col-2 col-sm-1 text-secondary">Tiêu đề:</div>
                                                <div class="col-10 col-sm-11 fw-bold text-dark" id="previewSubjectLine">
                                                    ${template.subject != null ? template.subject : 'Your reserved item
                                                    is ready at the front desk!'}
                                                </div>
                                            </div>
                                        </div>

                                        <div
                                            class="p-4 p-md-5 bg-white d-flex flex-column align-items-center min-vh-50">
                                            <div class="w-100" style="max-width: 512px;">

                                                <div class="mb-4 text-center">
                                                    <div class="d-inline-flex align-items-center gap-2">
                                                        <div class="rounded p-2 text-white d-flex align-items-center justify-content-center"
                                                            style="background-color: #9d4300; width: 40px; height: 40px;">
                                                            <span class="material-symbols-outlined">menu_book</span>
                                                        </div>
                                                        <span class="h5 m-0 fw-bold tracking-tight"
                                                            style="color: #9d4300;">UniLib Global</span>
                                                    </div>
                                                </div>

                                                <div class="text-dark d-flex flex-column gap-3 mb-4"
                                                    id="compiledBodyMarkup">
                                                    <p class="m-0">Kính gửi <span class="receiver-tag">Alex Johnson</span>,
                                                    </p>
                                                    <p class="m-0 lh-base">
                                                        Chúng tôi vui mừng thông báo rằng <strong
                                                            style="color: #9d4300;" id="previewBookName">"Principles of
                                                            Quantum Mechanics"</strong> hiện có sẵn để nhận tại
                                                        quầy lưu hành thư viện chính.
                                                    </p>

                                                    <div class="p-3 my-2 border-start border-4 rounded-end"
                                                        style="background-color: #eceef0; border-color: #9d4300 !important; font-size: 14px;">
                                                        <div class="text-uppercase fw-bold text-secondary mb-1"
                                                            style="font-size: 11px; tracking-wider: 0.05em;">Hướng dẫn
                                                            Nhận sách</div>
                                                        <p class="m-0 lh-sm">
                                                            <strong>Vị trí:</strong> Quầy Lưu hành, Tầng 1<br />
                                                            <strong>Có sẵn đến:</strong> 24/10/2023 (17:00)<br />
                                                            <strong>Mã giữ chỗ:</strong> #RES-9921-X
                                                        </p>
                                                    </div>

                                                    <p class="m-0 lh-base">
                                                        Vui lòng mang theo thẻ sinh viên để thuận tiện trong quá trình làm thủ tục. Nếu bạn không thể lấy sách trước ngày trên, sách sẽ được trả về bộ sưu tập chung hoặc chuyển cho người tiếp theo trong hàng đợi.
                                                    </p>

                                                    <div class="pt-2">
                                                        <a class="btn text-white px-4 py-2 small fw-bold shadow-sm"
                                                            style="background-color: #9d4300; font-size: 14px;"
                                                            href="account/dashboard">Xem Tài khoản Bảng điều khiển</a>
                                                    </div>

                                                    <div
                                                        class="pt-4 mt-3 border-top border-light-subtle small text-secondary fst-italic">
                                                        Trân trọng,<br />
                                                        <span class="fw-bold text-dark not-italic d-block mt-1">Ban
                                                            Quản lý Thư viện</span>
                                                        Các dịch vụ Thư viện Trường Đại học
                                                    </div>
                                                </div>

                                                <div class="mt-5 text-center text-secondary" style="font-size: 12px;">
                                                    <p class="mb-1">© 2026 University Library. Bản quyền đã được bảo lưu.</p>
                                                    <p class="m-0">Bạn nhận được email này vì bạn có
                                                        tài khoản đã đăng ký và đặt chỗ hoạt động.</p>
                                                </div>

                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <div class="col-12 col-xl-4 d-flex flex-column gap-4">
                                    <div class="card border-0 shadow-sm p-4 rounded-3 bg-white border">
                                        <h4 class="h5 fw-bold text-dark mb-3">Tùy chỉnh Xem trước</h4>

                                        <div class="d-flex flex-column gap-3 mb-4">
                                            <div>
                                                <label class="form-label text-secondary fw-semibold small mb-1">Chọn
                                                    Thành viên Kiểm thử</label>
                                                <select class="form-select shadow-none small" id="memberSelector"
                                                    onchange="applyMockData()">
                                                    <option value="Alex Johnson" selected>Alex Johnson (Sinh viên)
                                                    </option>
                                                    <option value="Sarah Miller">Sarah Miller (Nhà nghiên cứu)</option>
                                                    <option value="Professor Higgins">Giáo sư Higgins (Giảng viên)
                                                    </option>
                                                    <option value="Vũ Doanh Thái">Vũ Doanh Thái (FPT Sinh viên)</option>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="form-label text-secondary fw-semibold small mb-1">Chọn
                                                    Sách Kiểm thử</label>
                                                <select class="form-select shadow-none small" id="bookSelector"
                                                    onchange="applyMockData()">
                                                    <option value="Principles of Quantum Mechanics" selected>Principles
                                                        of Quantum Mechanics</option>
                                                    <option value="The Great Gatsby">The Great Gatsby</option>
                                                    <option value="Introduction to Algorithms">Introduction to
                                                        Algorithms</option>
                                                    <option value="Java Web Development with Tomcat">Java Web
                                                        Development with Tomcat</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="mb-4">
                                            <label class="form-label text-secondary fw-semibold small mb-1">Bộ chức năng
                                                Xem</label>
                                            <div class="btn-group w-100 bg-light p-1 rounded-3 border">
                                                <button type="button"
                                                    class="btn btn-sm btn-white border shadow-sm fw-semibold active-device-switch d-flex align-items-center justify-content-center gap-1 py-2"
                                                    id="btnDesktop" onclick="switchDevice('desktop')">
                                                    <span class="material-symbols-outlined fs-6">desktop_windows</span>
                                                    Desktop
                                                </button>
                                                <button type="button"
                                                    class="btn btn-sm text-secondary border-0 fw-semibold d-flex align-items-center justify-content-center gap-1 py-2"
                                                    id="btnMobile" onclick="switchDevice('mobile')">
                                                    <span class="material-symbols-outlined fs-6">smartphone</span>
                                                    Mobile
                                                </button>
                                            </div>
                                        </div>

                                        <div class="d-flex flex-column gap-2">
                                            <label class="text-secondary fw-semibold small mb-1">Thao tác nhanh</label>
                                            <button
                                                class="btn text-white w-100 py-2.5 d-flex align-items-center justify-content-center gap-2 fw-semibold"
                                                style="background-color: #9d4300;">
                                                <span class="material-symbols-outlined fs-5">send</span> Gửi Kiểm thử đến
                                                Email của tôi
                                            </button>
                                            <a href="templates/edit?id=${template.id}"
                                                class="btn btn-outline-secondary w-100 py-2.5 d-flex align-items-center justify-content-center gap-2">
                                                <span class="material-symbols-outlined fs-5">edit</span> Sửa Nội dung
                                                Mẫu
                                            </a>
                                            <button
                                                class="btn btn-outline-secondary w-100 py-2.5 d-flex align-items-center justify-content-center gap-2">
                                                <span class="material-symbols-outlined fs-5">picture_as_pdf</span>
                                                Xuất PDF
                                            </button>
                                        </div>
                                    </div>

                                    <div class="card border-0 p-4 rounded-3"
                                        style="background-color: rgba(0, 99, 152, 0.08); border: 1px solid rgba(0, 99, 152, 0.2) !important;">
                                        <div class="d-flex gap-2">
                                            <span class="material-symbols-outlined fill-1"
                                                style="color: #006398;">info</span>
                                            <div>
                                                <h6 class="fw-bold text-uppercase m-0"
                                                    style="color: #006398; font-size: 12px; letter-spacing: 0.05em;">
                                                    MẸO SỬ DỤNG MẪU</h6>
                                                <p class="small text-muted m-0 mt-1 lh-base">
                                                    Các biến số placeholder trong hệ thống được tự động khớp và định dạng dựa trên dữ liệu thực tế.
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </main>
                </div>

                <nav class="navbar fixed-bottom bg-white border-top d-md-none p-0" style="height: 64px; z-index: 2000;">
                    <div class="container-fluid h-100 px-0">
                        <div
                            class="d-flex w-100 justify-content-around align-items-center text-center small text-secondary h-100">
                            <div class="p-2 cursor-pointer"><span
                                    class="material-symbols-outlined d-block fs-4">collections_bookmark</span>Bộ sưu tập
                            </div>
                            <div class="p-2 cursor-pointer"><span
                                    class="material-symbols-outlined d-block fs-4">sync_alt</span>Lưu hành</div>
                            <div class="p-2 cursor-pointer fw-bold" style="color: #9d4300;"><span
                                    class="material-symbols-outlined d-block fs-4">mail</span>Mẫu email</div>
                            <div class="p-2 cursor-pointer"><span
                                    class="material-symbols-outlined d-block fs-4">assessment</span>Báo cáo</div>
                        </div>
                    </div>
                </nav>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    // Matrix driver to simulate screen responsive viewports sizes
                    function switchDevice(mode) {
                        const frame = document.getElementById('emailFrameWindow');
                        const btnD = document.getElementById('btnDesktop');
                        const btnM = document.getElementById('btnMobile');

                        if (mode === 'desktop') {
                            frame.classList.remove('view-mobile');
                            frame.classList.add('view-desktop');

                            // Active switch element style changes updates
                            btnD.classList.add('btn-white', 'border', 'shadow-sm');
                            btnD.classList.remove('text-secondary', 'border-0');
                            btnM.classList.add('text-secondary', 'border-0');
                            btnM.classList.remove('btn-white', 'border', 'shadow-sm');
                        } else {
                            frame.classList.remove('view-desktop');
                            frame.classList.add('view-mobile');

                            btnM.classList.add('btn-white', 'border', 'shadow-sm');
                            btnM.classList.remove('text-secondary', 'border-0');
                            btnD.classList.add('text-secondary', 'border-0');
                            btnD.classList.remove('btn-white', 'border', 'shadow-sm');
                        }
                    }

                    // Live Selectors simulation mapping fields injection updates driver
                    function applyMockData() {
                        const memberName = document.getElementById('memberSelector').value;
                        const bookName = document.getElementById('bookSelector').value;

                        // Target elements modifications mappings
                        document.getElementById('previewReceiverName').innerText = memberName;
                        document.getElementById('previewBookName').innerText = `"${bookName}"`;

                        // Loop updates all targeted names elements matches nodes classes
                        const dynamicTags = document.querySelectorAll('.receiver-tag');
                        dynamicTags.forEach(tag => {
                            tag.innerText = memberName;
                        });
                    }
                </script>
            </body>

            </html>