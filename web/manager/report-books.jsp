<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Báo cáo Hiệu suất &amp; Lưu hành Thư viện | Thư viện Lumina</title>

                <!-- Bootstrap 5 CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

                <!-- Google Fonts & Icons -->
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap"
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

                    /* Sidebar Navigation Layout Wrapper */
                    .sidebar {
                        width: 260px;
                        height: 100vh;
                        position: fixed;
                        left: 0;
                        top: 0;
                        background-color: #f2f4f6;
                        border-right: 1px solid #e0e3e5;
                        z-index: 1000;
                    }

                    .main-content {
                        margin-left: 260px;
                        min-height: 100vh;
                        max-width: 1400px;
                    }

                    @media (max-width: 991.98px) {
                        .sidebar {
                            display: none !important;
                        }

                        .main-content {
                            margin-left: 0 !important;
                        }
                    }

                    .nav-link-custom {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        padding: 10px 16px;
                        color: #565e74;
                        text-decoration: none;
                        border-radius: 8px;
                        font-size: 14px;
                        font-weight: 600;
                        transition: all 0.2s;
                    }

                    .nav-link-custom:hover {
                        background-color: #e0e3e5;
                        color: #191c1e;
                    }

                    .nav-link-custom.active {
                        color: #003554;
                        background-color: #cde5ff;
                        font-weight: 700;
                    }

                    .material-symbols-outlined {
                        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                    }

                    .nav-link-custom.active .material-symbols-outlined {
                        font-variation-settings: 'FILL' 1;
                    }

                    /* Custom UI Cards Styling */
                    .stat-card {
                        background-color: #ffffff;
                        border: 1px solid rgba(255, 255, 255, 0.8);
                        border-radius: 12px;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
                        transition: all 0.2s ease-in-out;
                    }

                    .stat-card:hover {
                        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
                    }

                    .chart-box-wrapper {
                        height: 400px;
                    }

                    .custom-scrollbar::-webkit-scrollbar {
                        width: 4px;
                    }

                    .custom-scrollbar::-webkit-scrollbar-track {
                        background: transparent;
                    }

                    .custom-scrollbar::-webkit-scrollbar-thumb {
                        background: #e0e3e5;
                        border-radius: 10px;
                    }

                    /* Floating Action Button (FAB) */
                    .fab-btn {
                        position: fixed;
                        bottom: 24px;
                        right: 24px;
                        width: 56px;
                        height: 56px;
                        border-radius: 50%;
                        background-color: #f97316;
                        color: white;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        box-shadow: 0 4px 10px rgba(249, 115, 22, 0.3);
                        border: none;
                        z-index: 2000;
                        transition: all 0.2s;
                    }

                    .fab-btn:hover {
                        transform: scale(1.1);
                        color: white;
                        background-color: #e26612;
                    }

                    .fab-btn .material-symbols-outlined {
                        transition: transform 0.2s;
                    }

                    .fab-btn:hover .material-symbols-outlined {
                        transform: rotate(90deg);
                    }
                </style>
            </head>

            <body>

                <!-- Sidebar Navigation Shell Drawer -->
                <aside class="sidebar d-flex flex-column p-3">
                    <div class="d-flex align-items-center gap-2 mb-4 px-2">
                        <div class="rounded-lg text-white d-flex align-items-center justify-content-center"
                            style="width: 40px; height: 40px; background-color: #ffdbca;">
                            <span class="material-symbols-outlined"
                                style="font-variation-settings: 'FILL' 1; color: #9d4300;">menu_book</span>
                        </div>
                        <div>
                            <h1 class="h6 fw-bold m-0 text-dark">Lumina System</h1>
                            <small class="text-muted opacity-75">Trung tâm Học thuật</small>
                        </div>
                    </div>

                    <nav class="nav flex-column flex-grow-1 gap-1">
                        <a class="nav-link-custom" href="dashboard"><span
                                class="material-symbols-outlined">dashboard</span>Bảng điều khiển</a>
                        <a class="nav-link-custom" href="catalog"><span
                                class="material-symbols-outlined">menu_book</span>Danh mục Sách</a>
                        <a class="nav-link-custom" href="circulation"><span
                                class="material-symbols-outlined">swap_horiz</span>Lưu hành</a>
                        <a class="nav-link-custom" href="members"><span
                                class="material-symbols-outlined">group</span>Thành viên</a>
                        <a class="nav-link-custom active" href="reports"><span
                                class="material-symbols-outlined">analytics</span>Báo cáo</a>
                        <a class="nav-link-custom" href="settings"><span
                                class="material-symbols-outlined">settings</span>Cài đặt</a>
                    </nav>

                        <button
                        class="btn btn-sm text-white w-100 fw-bold py-2 rounded-3 mt-auto d-flex align-items-center justify-content-center gap-1"
                        style="background-color: #f97316;">
                        <span class="material-symbols-outlined fs-5">add</span> Thêm Tài nguyên mới
                    </button>
                </aside>

                <!-- Main Workspace Content Canvas Context -->
                <div class="main-content p-3 p-md-4">

                    <!-- Header Section Controllers Row -->
                    <header
                        class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                        <div>
                            <h2 class="fw-bold text-dark m-0">Báo cáo Hiệu suất &amp; Lưu hành Thư viện</h2>
                            <p class="text-muted small m-0">Phân tích toàn diện cho quản lý tài nguyên học thuật</p>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <div class="bg-white border rounded-3 px-3 py-2 d-flex align-items-center gap-2 shadow-sm"
                                style="font-size: 14px;">
                                <span class="material-symbols-outlined text-secondary fs-5">calendar_today</span>
                                <span class="fw-medium text-dark">Oct 1, 2023 - Oct 31, 2023</span>
                            </div>
                            <button
                                class="btn btn-white bg-white border rounded-3 px-3 py-2 d-flex align-items-center gap-2 shadow-sm text-dark small fw-semibold"
                                id="exportBtn">
                                <span class="material-symbols-outlined text-primary fs-5">download</span> Xuất Báo cáo
                            </button>
                        </div>
                    </header>

                    <!-- Summary Statistics Grid Blocks Row (4 Cards) -->
                    <section class="row g-4 mb-4">
                        <!-- Total Books in Stock Card -->
                        <div class="col-12 col-sm-6 col-lg-3">
                            <div class="stat-card p-3 d-flex flex-column gap-2">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="rounded p-2" style="background-color: #ffdbca; color: #783200;"><span
                                            class="material-symbols-outlined d-block">inventory_2</span></div>
                                    <span class="badge bg-light text-success border small fw-bold">+2.4% so với
                                        tháng trước</span>
                                </div>
                                <div class="mt-2">
                                    <p class="small text-muted fw-semibold m-0 opacity-75">Tổng sách trong kho</p>
                                    <h3 class="fw-bold text-dark m-0 mt-1">${reportStats.totalBooks != null ?
                                        reportStats.totalBooks : '42,850'}</h3>
                                </div>
                            </div>
                        </div>

                        <!-- In Circulation Card -->
                        <div class="col-12 col-sm-6 col-lg-3">
                            <div class="stat-card p-3 d-flex flex-column gap-2">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="rounded p-2" style="background-color: #cde5ff; color: #004b74;"><span
                                            class="material-symbols-outlined d-block">auto_stories</span></div>
                                    <span class="badge bg-light text-primary border small fw-bold">+12% đỉnh điểm</span>
                                </div>
                                <div class="mt-2">
                                    <p class="small text-muted fw-semibold m-0 opacity-75">Hiện đang Lưu hành</p>
                                    <h3 class="fw-bold text-dark m-0 mt-1">${reportStats.inCirculation != null ?
                                        reportStats.inCirculation : '15,640'}</h3>
                                </div>
                            </div>
                        </div>

                        <!-- Circulation Rate Progress Bars Card -->
                        <div class="col-12 col-sm-6 col-lg-3">
                            <div class="stat-card p-3 d-flex flex-column gap-2">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="rounded p-2" style="background-color: #dae2fd; color: #3f465c;"><span
                                            class="material-symbols-outlined d-block">analytics</span></div>
                                    <div class="progress rounded-pill overflow-hidden"
                                        style="width: 70px; height: 8px;">
                                        <div class="progress-bar" role="progressbar"
                                            style="width: 36.5%; background-color: #9d4300;"></div>
                                    </div>
                                </div>
                                <div class="mt-2">
                                    <p class="small text-muted fw-semibold m-0 opacity-75">Tỷ lệ Lưu hành</p>
                                    <h3 class="fw-bold text-dark m-0 mt-1">${reportStats.circulationRate != null ?
                                        reportStats.circulationRate : '36.5%'}</h3>
                                </div>
                            </div>
                        </div>

                        <!-- Active Reservations Card -->
                        <div class="col-12 col-sm-6 col-lg-3">
                            <div class="stat-card p-3 d-flex flex-column gap-2">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="rounded p-2" style="background-color: #ffdad6; color: #93000a;"><span
                                            class="material-symbols-outlined d-block">bookmark_manager</span></div>
                                    <span class="text-danger fw-bold small" style="font-size: 11px;">82 Chờ lấy
                                        sách</span>
                                </div>
                                <div class="mt-2">
                                    <p class="small text-muted fw-semibold m-0 opacity-75">Hoạt động Đặt trước</p>
                                    <h3 class="fw-bold text-dark m-0 mt-1">${reportStats.activeReservations != null ?
                                        reportStats.activeReservations : '1,208'}</h3>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Analytics Diagrams Vectors Chart & Category Breakdowns Layout -->
                    <section class="row g-4 mb-4">
                        <!-- Left Chart Canvas Component Box (8 Columns Grid) -->
                        <div class="col-12 col-lg-8">
                            <div
                                class="card border-0 shadow-sm p-4 rounded-3 bg-white chart-box-wrapper d-flex flex-column position-relative">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h5 class="fw-bold m-0 text-dark">Xu hướng Lưu hành Sách</h5>
                                    <div class="d-flex gap-3 small text-muted">
                                        <div class="d-flex align-items-center gap-1.5">
                                            <span class="d-inline-block rounded-circle"
                                                style="width: 10px; height: 10px; background-color: #f97316;"></span>
                                            Mượn sách
                                        </div>
                                        <div class="d-flex align-items-center gap-1.5">
                                            <span class="d-inline-block rounded-circle"
                                                style="width: 10px; height: 10px; background-color: #006398;"></span>
                                            Trả sách
                                        </div>
                                    </div>
                                </div>

                                <!-- SVG Chart Sandbox Container Box Panel -->
                                <div class="position-relative flex-grow-1 w-100 group-hover-trigger"
                                    style="cursor: pointer;">
                                    <svg class="w-100 h-100" viewBox="0 0 800 230" preserveAspectRatio="none">
                                        <!-- Horizontal Guide Helper Lines Elements -->
                                        <line stroke="#f1f5f9" stroke-width="1" x1="0" x2="800" y1="30" y2="30"></line>
                                        <line stroke="#f1f5f9" stroke-width="1" x1="0" x2="800" y1="90" y2="90"></line>
                                        <line stroke="#f1f5f9" stroke-width="1" x1="0" x2="800" y1="150" y2="150">
                                        </line>
                                        <line stroke="#f1f5f9" stroke-width="1" x1="0" x2="800" y1="210" y2="210">
                                        </line>

                                        <!-- Borrows Engine Path Curves (Orange Line Vector) -->
                                        <path d="M 0,180 Q 100,150 200,160 T 400,90 T 600,120 T 800,50" fill="none"
                                            stroke="#f97316" stroke-linecap="round" stroke-width="4"></path>
                                        <path d="M 0,180 Q 100,150 200,160 T 400,90 T 600,120 T 800,50 V 230 H 0 Z"
                                            fill="url(#orangeGradPattern)" opacity="0.08"></path>

                                        <!-- Returns Engine Path Curves (Blue Dashed Line Vector) -->
                                        <path d="M 0,200 Q 100,190 200,150 T 400,130 T 600,80 T 800,100" fill="none"
                                            stroke="#006398" stroke-dasharray="8 4" stroke-linecap="round"
                                            stroke-width="4"></path>

                                        <defs>
                                            <linearGradient id="orangeGradPattern" x1="0%" x2="0%" y1="0%" y2="100%">
                                                <stop offset="0%" style="stop-color:#f97316; stop-opacity:1"></stop>
                                                <stop offset="100%" style="stop-color:#f97316; stop-opacity:0"></stop>
                                            </linearGradient>
                                        </defs>
                                    </svg>

                                    <!-- Tooltip Layout Simulation (Displays over layout node hover bounds) -->
                                    <div class="position-absolute bg-dark text-white p-2 rounded-3 text-center small opacity-0 hover-target-tooltip shadow-lg"
                                        style="top: 20%; left: 50%; transform: translateX(-50%); pointer-events: none; transition: opacity 0.2s; font-size: 12px; z-index: 10;">
                                        <strong class="d-block mb-0.5">15/10/2026</strong>
                                        <span class="d-block">Mượn: 842</span>
                                        <span class="d-block">Trả: 620</span>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between mt-3 text-secondary px-1 fw-semibold opacity-50"
                                    style="font-size: 12px;">
                                    <span>01/10</span><span>08/10</span><span>15/10</span><span>22/10</span><span>31/10
                                        </span>
                                </div>
                            </div>
                        </div>

                        <!-- Right Inventory Categories Breakdowns Lists (4 Columns Grid) -->
                        <div class="col-12 col-lg-4">
                            <div
                                class="card border-0 shadow-sm p-4 rounded-3 bg-white chart-box-wrapper d-flex flex-column">
                                <h5 class="fw-bold mb-4 text-dark">Phân bố Thể loại</h5>
                                <div class="d-flex flex-column gap-3 overflow-auto flex-grow-1 pe-1 custom-scrollbar">
                                    <!-- Iteration dynamic nodes rendering looping blocks pattern layout -->
                                    <c:forEach var="cat" items="${categoryDistributions}">
                                        <div>
                                            <div class="d-flex justify-content-between mb-1 small fw-semibold">
                                                <span class="text-dark">${cat.categoryName}</span>
                                                <span class="text-muted">${cat.bookCount} cuốn</span>
                                            </div>
                                            <div class="progress rounded-pill"
                                                style="height: 8px; background-color: #eceef0;">
                                                <div class="progress-bar rounded-pill"
                                                    style="width: ${cat.percentage}%; background-color: #f97316;"></div>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <!-- Static samples mock render blocks for fallback cases validation code views -->
                                    <c:if test="${empty categoryDistributions}">
                                        <div>
                                            <div class="d-flex justify-content-between mb-1 small fw-semibold">
                                                <span class="text-dark">Khoa học Máy tính</span><span
                                                    class="text-muted">8.420 cuốn</span>
                                            </div>
                                            <div class="progress rounded-pill"
                                                style="height: 8px; background-color: #eceef0;">
                                                <div class="progress-bar rounded-pill"
                                                    style="width: 85%; background-color: #f97316;"></div>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-content-between mb-1 small fw-semibold">
                                                <span class="text-dark">Vật lý Lý thuyết</span><span
                                                    class="text-muted">5.100 cuốn</span>
                                            </div>
                                            <div class="progress rounded-pill"
                                                style="height: 8px; background-color: #eceef0;">
                                                <div class="progress-bar rounded-pill"
                                                    style="width: 62%; background-color: #f97316;"></div>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-content-between mb-1 small fw-semibold">
                                                <span class="text-dark">Văn học Thế giới</span><span
                                                    class="text-muted">12.300 cuốn</span>
                                            </div>
                                            <div class="progress rounded-pill"
                                                style="height: 8px; background-color: #eceef0;">
                                                <div class="progress-bar rounded-pill"
                                                    style="width: 94%; background-color: #f97316;"></div>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-content-between mb-1 small fw-semibold">
                                                <span class="text-dark">Lịch sử Kinh tế</span><span
                                                    class="text-muted">4.250 cuốn</span>
                                            </div>
                                            <div class="progress rounded-pill"
                                                style="height: 8px; background-color: #eceef0;">
                                                <div class="progress-bar rounded-pill"
                                                    style="width: 48%; background-color: #f97316;"></div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Detailed Database Records Analytical Tables Grid Matrix Row -->
                    <section class="row g-4">
                        <!-- Table Box Left (Most Borrowed Item Entity Rows) -->
                        <div class="col-12 col-xl-6">
                            <div class="card border-0 shadow-sm p-4 rounded-3 bg-white">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5 class="fw-bold m-0 text-dark">Sách được Mượn nhiều nhất</h5>
                                    <a href="catalog/popular"
                                        class="text-decoration-none small fw-bold d-flex align-items-center gap-0.5"
                                        style="color: #9d4300;">
                                        Xem Tất cả <span class="material-symbols-outlined fs-6">arrow_forward</span>
                                    </a>
                                </div>

                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead
                                            class="table-light text-secondary uppercase text-uppercase tracking-wider"
                                            style="font-size: 11px;">
                                            <tr>
                                                <th class="py-2.5 px-3">Chi tiết Sách</th>
                                                <th class="py-2.5 px-2">ISBN</th>
                                                <th class="py-2.5 px-3 text-end">Lượt Mượn</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="book" items="${mostBorrowedBooks}">
                                                <tr class="action-row-tr" style="cursor: default;">
                                                    <td class="px-3">
                                                        <div class="d-flex align-items-center gap-3">
                                                            <div class="rounded shadow-sm overflow-hidden flex-shrink-0 border"
                                                                style="width: 40px; height: 56px;">
                                                                <img class="w-100 h-100 object-fit-cover"
                                                                    src="${book.imageCoverUrl}" />
                                                            </div>
                                                            <div>
                                                                <p class="fw-bold text-dark m-0 small">${book.title}</p>
                                                                <small class="text-muted d-block mt-0.5"
                                                                    style="font-size: 12px;">${book.author}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="px-2 font-monospace text-secondary small">${book.isbn}
                                                    </td>
                                                    <td class="px-3 text-end">
                                                        <span class="badge rounded-pill fw-bold"
                                                            style="background-color: #ffdbca; color: #783200; padding: 6px 12px; font-size: 12px;">${book.borrowCount}</span>
                                                    </td>
                                                </tr>
                                            </c:forEach>

                                            <c:if test="${empty mostBorrowedBooks}">
                                                <!-- Fallback sample rows visualization models checks inputs logic endpoints -->
                                                <tr class="action-row-tr" style="cursor: default;">
                                                    <td class="px-3">
                                                        <div class="d-flex align-items-center gap-3">
                                                            <div class="rounded shadow-sm overflow-hidden flex-shrink-0 border"
                                                                style="width: 40px; height: 56px;">
                                                                <img class="w-100 h-100 object-fit-cover"
                                                                    src="https://lh3.googleusercontent.com/aida-public/AB6AXuDCNRpPoKyec7gL1HSVOlBbRdlXUqjdLPFwq1wC3FG55ouA7bfmv49rG3L8ILhumXeuwxqFNARXup94SDoyP6DgucOoidk8ziUXRRi0f_zkm6-P0_QMhhO_NVC9Zk7a40ColA-sTZv-yPsKhwbzMey9PIrKhHjb8g2uYVEKueL89q-ConzS8Z_Duca6RctAcYY3F4tcsPaSYPT-IWBeLo9_0Qx8E1NtpXMXE3NNpI83KD61dtPbjJaG1Qay7LickGYyd38NRo7u-O0" />
                                                            </div>
                                                            <div>
                                                                <p class="fw-bold text-dark m-0 small">The Great Gatsby
                                                                </p>
                                                                <small class="text-muted d-block mt-0.5"
                                                                    style="font-size: 12px;">F. Scott Fitzgerald</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="px-2 font-monospace text-secondary small">9780743273565
                                                    </td>
                                                    <td class="px-3 text-end"><span class="badge rounded-pill fw-bold"
                                                            style="background-color: #ffdbca; color: #783200; padding: 6px 12px; font-size: 12px;">248</span>
                                                    </td>
                                                </tr>
                                                <tr class="action-row-tr" style="cursor: default;">
                                                    <td class="px-3">
                                                        <div class="d-flex align-items-center gap-3">
                                                            <div class="rounded shadow-sm overflow-hidden flex-shrink-0 border"
                                                                style="width: 40px; height: 56px;">
                                                                <img class="w-100 h-100 object-fit-cover"
                                                                    src="https://lh3.googleusercontent.com/aida-public/AB6AXuCmAs0m2aauCTM7_Ya3OqLb44NoAdq2yB2poGoY8HbptkjygTwqxowGI2GaLALKY8GdsY_y09RUeiABf9G85I1K_KGgktObnKj88LChm4rrdUvFSyTll3hj0wq-8J8tNHiuyUULwGl_M0AC5ZALV52aMxBUjxHGJOjuzChCg46EOEKtiiO2r2v5fewUYyc_7tH4I2KQquG7xBXJIOX3TSYKEDOrFOhVnsHS_c3UgKc42q43MkYZcw7YvoqI0x09eOlPnH2u8sUOKQs" />
                                                            </div>
                                                            <div>
                                                                <p class="fw-bold text-dark m-0 small">Principles of
                                                                    Economics</p>
                                                                <small class="text-muted d-block mt-0.5"
                                                                    style="font-size: 12px;">N. Gregory Mankiw</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="px-2 font-monospace text-secondary small">9781305155914
                                                    </td>
                                                    <td class="px-3 text-end"><span class="badge rounded-pill fw-bold"
                                                            style="background-color: #ffdbca; color: #783200; padding: 6px 12px; font-size: 12px;">215</span>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Table Box Right (Category Volume vs Active Flow Rates Grid matrix) -->
                        <div class="col-12 col-xl-6">
                            <div class="card border-0 shadow-sm p-4 rounded-3 bg-white">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5 class="fw-bold m-0 text-dark">Hiệu suất Thể loại</h5>
                                    <span class="small text-muted opacity-75">30 ngày qua</span>
                                </div>

                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light text-secondary text-uppercase tracking-wider"
                                            style="font-size: 11px;">
                                            <tr>
                                                <th class="py-2.5 px-3">Thể loại</th>
                                                <th class="py-2.5 px-2 text-end">Kho sách</th>
                                                <th class="py-2.5 px-2 text-end">Lưu hành</th>
                                                <th class="py-2.5 px-3 text-end">Tỷ lệ</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="perf" items="${categoryPerformanceStats}">
                                                <tr class="action-row-tr">
                                                    <td class="px-3 fw-bold text-dark small">${perf.categoryName}</td>
                                                    <td class="px-2 text-end text-secondary small">
                                                        <fmt:formatNumber value="${perf.inventoryCount}" />
                                                    </td>
                                                    <td class="px-2 text-end text-secondary small">
                                                        <fmt:formatNumber value="${perf.circulatingCount}" />
                                                    </td>
                                                    <td class="px-3 text-end">
                                                        <div class="d-inline-flex align-items-center gap-1 fw-bold text-danger"
                                                            style="font-size: 14px; color: #9d4300 !important;">
                                                            <fmt:formatNumber value="${perf.circulationPercentage}"
                                                                type="percent" maxFractionDigits="1" />
                                                            <span
                                                                class="material-symbols-outlined fs-6">trending_up</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>

                                            <c:if test="${empty categoryPerformanceStats}">
                                                <tr class="action-row-tr">
                                                    <td class="px-3 fw-bold text-dark small">Văn học</td>
                                                    <td class="px-2 text-end text-secondary small">12,300</td>
                                                    <td class="px-2 text-end text-secondary small">4,850</td>
                                                    <td class="px-3 text-end">
                                                        <div class="d-inline-flex align-items-center gap-1 fw-bold"
                                                            style="font-size: 14px; color: #9d4300;">
                                                            39.4% <span
                                                                class="material-symbols-outlined fs-6">trending_up</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr class="action-row-tr">
                                                    <td class="px-3 fw-bold text-dark small">Công nghệ</td>
                                                    <td class="px-2 text-end text-secondary small">8,420</td>
                                                    <td class="px-2 text-end text-secondary small">5,210</td>
                                                    <td class="px-3 text-end">
                                                        <div class="d-inline-flex align-items-center gap-1 fw-bold"
                                                            style="font-size: 14px; color: #9d4300;">
                                                            61.8% <span
                                                                class="material-symbols-outlined fs-6">trending_up</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Bottom Informational Disclaimers Footers Status Card Bar -->
                    <section class="mt-4">
                        <div class="card border-0 p-3 rounded-3 shadow-sm bg-light-subtle"
                            style="background-color: #eceef0;">
                            <div
                                class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="rounded-circle bg-white d-flex align-items-center justify-content-center shadow-sm"
                                        style="width: 44px; height: 44px; flex-shrink: 0;">
                                        <span class="material-symbols-outlined fill-1"
                                            style="color: #9d4300;">info</span>
                                    </div>
                                    <div>
                                        <h6 class="fw-bold text-dark m-0" style="font-size: 15px;">Lưu ý Cập nhật Dữ liệu
                                        </h6>
                                        <p class="text-muted small m-0 mt-0.5">Tất cả giá trị được đồng bộ thời gian thực
                                            với cơ sở dữ liệu SQL Server trung tâm. Tỷ lệ lưu hành được tính bằng
                                            `(Mượn / TổngKho) * 100`.</p>
                                    </div>
                                </div>
                                <div class="text-md-end ps-5 ps-md-0">
                                    <small class="text-muted d-block fw-semibold" style="font-size: 12px;">Cập nhật lần cuối:
                                        Hôm nay, 10:45 SA</small>
                                    <form action="reports/recalculate" method="POST" class="m-0 p-0 mt-1">
                                        <button type="submit"
                                            class="btn btn-link p-0 text-decoration-none fw-bold small d-flex align-items-center gap-0.5 ms-md-auto shadow-none"
                                            style="color: #9d4300; font-size: 13px;">
                                            <span class="material-symbols-outlined fs-6">refresh</span> Tính toán lại
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </section>

                </div>

                <!-- Floating Action Trigger Buttons Context (FAB) -->
                <button type="button" class="fab-btn" onclick="location.href='catalog/add'" title="Thêm Tài nguyên mới">
                    <span class="material-symbols-outlined fs-3">add</span>
                </button>

                <!-- Bootstrap 5 JS Bundle Combo Packages Components -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

                <!-- UI Micro-interactions Scripts Driver Matrix -->
                <script>
                    // Custom animation interactive hover response handlers
                    document.querySelectorAll('.action-row-tr').forEach(row => {
                        row.addEventListener('mouseenter', () => {
                            row.style.transform = 'translateX(6px)';
                            row.style.transition = 'transform 0.22s ease-out';
                        });
                        row.addEventListener('mouseleave', () => {
                            row.style.transform = 'translateX(0)';
                        });
                    });

                    // Toggle simple interactive simulated visibility hooks on chart canvas area bounding layout box
                    const chartWrapper = document.querySelector('.group-hover-trigger');
                    const tooltipNode = document.querySelector('.hover-target-tooltip');
                    if (chartWrapper && tooltipNode) {
                        chartWrapper.addEventListener('mouseenter', () => tooltipNode.classList.remove('opacity-0'));
                        chartWrapper.addEventListener('mouseleave', () => tooltipNode.classList.add('opacity-0'));
                    }
                </script>
            </body>

            </html>