<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Phân tích Mượn sách Thành viên - Lumina LMS</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Google Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f7f9fb;
            color: #191c1e;
            overflow-x: hidden;
        }
        /* Sidebar Layout Configuration */
        .sidebar {
            width: 260px;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            background-color: #eceef0;
            border-right: 1px solid #e0e3e5;
            z-index: 1000;
        }
        .main-content {
            margin-left: 260px;
            padding-top: 64px;
            min-height: 100vh;
        }
        .top-navbar {
            height: 64px;
            position: fixed;
            top: 0;
            right: 0;
            left: 260px;
            background-color: #ffffff;
            border-bottom: 1px solid #e0e3e5;
            z-index: 990;
        }
        @media (max-width: 991.98px) {
            .sidebar { display: none !important; }
            .top-navbar { left: 0 !important; }
            .main-content { margin-left: 0 !important; }
        }
        .nav-link-custom {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: #565e74;
            text-decoration: none;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.2s;
        }
        .nav-link-custom:hover {
            background-color: #e6e8ea;
            color: #191c1e;
        }
        .nav-link-custom.active {
            color: #341100;
            font-weight: 600;
            background-color: rgba(255, 219, 202, 0.7);
        }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        /* Bento Style Grid Dashboard Cards */
        .bento-card-dashboard {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
            padding: 24px;
            border: 1px solid rgba(224, 227, 229, 0.4);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            height: 100%;
        }
        .bento-card-dashboard:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.06);
        }
        /* Double Layer Stack Bar Graphics Layout */
        .bar-container-stack {
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            align-items: center;
            height: 280px;
            flex: 1;
        }
        .stack-student-bar {
            background-color: rgba(157, 67, 0, 0.7); /* Primary theme color */
            border-radius: 4px 4px 0 0;
            width: 100%;
            transition: opacity 0.2s;
        }
        .stack-lecturer-bar {
            background-color: rgba(86, 94, 116, 0.4); /* Secondary theme color */
            border-radius: 4px 4px 0 0;
            width: 100%;
            transition: opacity 0.2s;
        }
        .bar-container-stack:hover .stack-student-bar,
        .bar-container-stack:hover .stack-lecturer-bar {
            opacity: 0.9;
        }
        .divider-horizontal-item {
            height: 1px;
            background-color: #e0e3e5;
            margin: 12px 8px;
        }
    </style>
</head>
<body>

    <!-- Sidebar Navigation Layout Shell Component -->
    <aside class="sidebar d-flex flex-column py-3 px-2">
        <div class="mb-4 px-3">
            <h1 class="h4 fw-bold m-0" style="color: #9d4300;">Lumina LMS</h1>
            <small class="text-muted opacity-75">Bảng điều khiển Admin</small>
        </div>
        
        <nav class="nav flex-column gap-1 flex-grow-1">
            <a class="nav-link-custom" href="dashboard"><span class="material-symbols-outlined">dashboard</span>Bảng điều khiển</a>
            <a class="nav-link-custom" href="catalog"><span class="material-symbols-outlined">menu_book</span>Danh mục Sách</a>
            <a class="nav-link-custom" href="circulation"><span class="material-symbols-outlined">swap_horiz</span>Lưu hành</a>
            <a class="nav-link-custom" href="members"><span class="material-symbols-outlined">group</span>Thành viên</a>
            <a class="nav-link-custom active" href="reports"><span class="material-symbols-outlined">analytics</span>Báo cáo</a>
            <a class="nav-link-custom" href="settings"><span class="material-symbols-outlined">settings</span>Cài đặt</a>
        </nav>
        
        <div class="p-2 bg-light rounded-3 d-flex align-items-center gap-3 mt-auto">
            <div class="rounded-circle overflow-hidden border border-white" style="width: 40px; height: 40px;">
                <img alt="Hồ sơ Admin" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAQI62idQAK6Uke2_fhE8x27hqCo4I4Mqy24011_ZumkM6bwKQV8uMOUOf8NTf-4VSGBzRkR7iorc5oEvqSyDHw_5aA5CspGCph4FW-_uHaLm-VZwtEkCMSzRF0n_aI8iA_LsK--u4PFCabYgiQWPSMXSjluxIGfqpR9AmzrOYq-zY7OZ5J7YqpTiVygKAyV4y-BHMLelJTz0t9XSXQf58aKWBJfodq6X1uBbkXA3RqUSErvQ_m21l7sXqk47pNKaxnTfPbEpWkb08" class="w-100 h-100 object-fit-cover"/>
            </div>
            <div>
                <p class="small fw-bold text-dark m-0 leading-tight">Thư viện Quản trị viên</p>
                <span class="text-muted uppercase tracking-wider" style="font-size: 10px;">Trường Đại học Lumina</span>
            </div>
        </div>
    </aside>

    <!-- Top Global Layout Header Navigation Navbar -->
    <header class="top-navbar d-flex align-items-center justify-content-between px-4">
        <div class="d-flex align-items-center bg-light rounded-pill px-3 py-1.5" style="width: 450px;">
            <span class="material-symbols-outlined text-secondary me-2 fs-5">search</span>
            <input class="form-control bg-transparent border-0 p-0 shadow-none small" placeholder="Tìm kiếm thành viên, báo cáo, sách..." type="text"/>
        </div>
        
        <div class="d-flex align-items-center gap-3">
            <button class="btn btn-link p-1 text-secondary"><span class="material-symbols-outlined">notifications</span></button>
            <button class="btn btn-link p-1 text-secondary"><span class="material-symbols-outlined">help_outline</span></button>
            <div class="border-start mx-1" style="height: 24px; border-color: #e0e3e5 !important;"></div>
            <div class="d-flex align-items-center gap-2">
                <div class="text-end lh-tight">
                    <p class="small fw-bold text-dark m-0">Quản trị viên</p>
                    <span class="text-success uppercase" style="font-size: 10px; font-weight: 700;">Trực tuyến</span>
                </div>
                <div class="rounded-circle overflow-hidden border" style="width: 32px; height: 32px;">
                    <img alt="Administrator Avatar" src="https://lh3.googleusercontent.com/aida-public/AB6AXuD7BTjoz-z7hpNoeCquFSHNjKHOCPeCgrjMJnyxTm_ctxY-jOMvp9hsMetOyJ2oEiJMDByqZvV0PbPSa4nuN5swTb2733dcLxxvMBAcXuim_AF1hguCIemAVtBPCwHCPS31FaTq_IUDAAOqRJaS_ORupWsuPvRFNEibYlJiT7HQ_GSirHGyuihwdz4H_qUS4eMwdS-n8MC3UAmo9_myZ0kxa09LWP0HVXR1cdf_tN7nLtq7m0yrmV9IkvvLXhBKRyu0E2A1EV3RTvQ" class="w-100 h-100 object-fit-cover"/>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Dynamic Content Base Layout Space -->
    <main class="main-content">
        <div class="container-fluid p-4" style="max-width: 1280px;">
            
            <!-- Dashboard Main Control Filters Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
                <div>
                    <h2 class="fw-bold text-dark m-0 tracking-tight">Phân tích Mượn sách của Thành viên</h2>
                    <p class="text-muted small m-0">Chỉ số hiệu suất và thông tin hành vi cho kỳ học hiện tại.</p>
                </div>
                <div class="d-flex align-items-center bg-white p-2 rounded-3 shadow-sm border gap-2">
                    <span class="material-symbols-outlined fs-5 ms-1" style="color: #9d4300;">calendar_today</span>
                    <select class="form-select bg-transparent border-0 p-0 pe-4 shadow-none fw-semibold text-dark small cursor-pointer" style="width: auto;">
                        <option>01/10/2023 - 31/10/2023</option>
                        <option>30 ngày qua</option>
                        <option>Học kỳ hiện tại</option>
                    </select>
                    <button class="btn text-white px-3 py-1 fw-semibold small rounded" style="background-color: #9d4300; font-size: 13px;">Xuất</button>
                </div>
            </div>

            <!-- Summary KPI Indicator Boxes Row (4 Cards) -->
            <section class="row g-4 mb-4">
                <!-- Total Borrowed -->
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="bento-card-dashboard">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div class="rounded p-2" style="background-color: rgba(249, 115, 22, 0.15); color: #9d4300;"><span class="material-symbols-outlined d-block">auto_stories</span></div>
                            <span class="badge bg-success-subtle text-success border-0 rounded px-2 py-1 small fw-bold">+12%</span>
                        </div>
                        <h6 class="text-muted text-uppercase tracking-wider fw-bold mb-1" style="font-size: 11px;">Tổng Mượn (Trong tháng)</h6>
                        <h2 class="fw-bold text-dark m-0 display-6">${kpiStats.totalBorrowed != null ? kpiStats.totalBorrowed : '1,842'}</h2>
                    </div>
                </div>
                <!-- Active Borrowers -->
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="bento-card-dashboard">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div class="rounded p-2" style="background-color: rgba(86, 94, 116, 0.15); color: #565e74;"><span class="material-symbols-outlined d-block">person_check</span></div>
                            <span class="badge bg-secondary-subtle text-secondary border-0 rounded px-2 py-1 small fw-bold">Hoạt động</span>
                        </div>
                        <h6 class="text-muted text-uppercase tracking-wider fw-bold mb-1" style="font-size: 11px;">Người Mượn Thiếu tích cực</h6>
                        <h2 class="fw-bold text-dark m-0 display-6">${kpiStats.activeBorrowers != null ? kpiStats.activeBorrowers : '456'}</h2>
                    </div>
                </div>
                <!-- Top Major -->
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="bento-card-dashboard d-flex flex-column justify-content-between">
                        <div>
                            <div class="rounded p-2 d-inline-block mb-2" style="background-color: rgba(0, 99, 152, 0.15); color: #006398;"><span class="material-symbols-outlined d-block">school</span></div>
                            <h6 class="text-muted text-uppercase tracking-wider fw-bold mb-1" style="font-size: 11px;">Ngành phổ biến nhất (Khối lượng)</h6>
                            <h4 class="fw-bold text-dark m-0 mt-1">${kpiStats.topMajorName != null ? kpiStats.topMajorName : 'Comp. Science'}</h4>
                        </div>
                        <small class="text-muted mt-2 d-block" style="font-size: 12px;">32.4% tổng khối lượng sinh viên</small>
                    </div>
                </div>
                <!-- Top Dept -->
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="bento-card-dashboard d-flex flex-column justify-content-between">
                        <div>
                            <div class="rounded p-2 d-inline-block mb-2" style="background-color: rgba(255, 182, 144, 0.3); color: #9d4300;"><span class="material-symbols-outlined d-block">diversity_3</span></div>
                            <h6 class="text-muted text-uppercase tracking-wider fw-bold mb-1" style="font-size: 11px;">Khoa phổ biến nhất (Khối lượng)</h6>
                            <h4 class="fw-bold text-dark m-0 mt-1">${kpiStats.topDeptName != null ? kpiStats.topDeptName : 'Bio Sciences'}</h4>
                        </div>
                        <small class="text-muted mt-2 d-block" style="font-size: 12px;">15.8% tổng khối lượng nhân viên</small>
                    </div>
                </div>
            </section>

            <!-- Main Charts & Insight Block Analytics Section Row -->
            <section class="row g-4 mb-4">
                <!-- Large Composite Dual Stack Histograms Column (8 Columns Grid) -->
                <div class="col-12 col-lg-8">
                    <div class="card border-0 shadow-sm p-4 rounded-3 bg-white h-100">
                        <div class="d-flex flex-col flex-sm-row justify-content-between align-items-start align-items-sm-center gap-2 mb-4">
                            <div>
                                <h5 class="fw-bold text-dark m-0">Xu hướng Mượn theo Nhóm người dùng</h5>
                                <p class="text-muted small m-0">Phân tích so sánh việc mượn sách của Sinh viên vs. Giảng viên</p>
                            </div>
                            <div class="d-flex gap-3 small text-muted font-weight-semibold">
                                <div class="d-flex align-items-center gap-1.5"><span class="d-inline-block rounded-circle" style="width: 10px; height: 10px; background-color: #9d4300;"></span> Sinh viên</div>
                                <div class="d-flex align-items-center gap-1.5"><span class="d-inline-block rounded-circle" style="width: 10px; height: 10px; background-color: #565e74;"></span> Giảng viên</div>
                            </div>
                        </div>

                        <!-- Stacked Comparative Column Bars Graphic Board Sandbox Panel -->
                        <div class="position-relative w-100 mt-2 d-flex flex-column flex-grow-1 justify-content-between">
                            <div class="d-flex align-items-end justify-content-between gap-1.5 px-2 border-bottom pb-1" style="height: 250px;">
                                <!-- Sample Node loop points configuration model array mapper blocks -->
                                <c:forEach var="trend" items="${borrowingGroupTrends}">
                                    <div class="bar-container-stack">
                                        <div class="stack-lecturer-bar" style="height: ${trend.lecturerPercent}%;"></div>
                                        <div class="stack-student-bar mt-0.5" style="height: ${trend.studentPercent}%;"></div>
                                    </div>
                                </c:forEach>
                                
                                <!-- Static blueprint schema fallbacks rendering columns display matrix -->
                                <c:if test="${empty borrowingGroupTrends}">
                                    <div class="bar-container-stack"><div class="stack-lecturer-bar" style="height: 15%;"></div><div class="stack-student-bar mt-0.5" style="height: 40%;"></div></div>
                                    <div class="bar-container-stack"><div class="stack-lecturer-bar" style="height: 20%;"></div><div class="stack-student-bar mt-0.5" style="height: 55%;"></div></div>
                                    <div class="bar-container-stack"><div class="stack-lecturer-bar" style="height: 10%;"></div><div class="stack-student-bar mt-0.5" style="height: 35%;"></div></div>
                                    <div class="bar-container-stack"><div class="stack-lecturer-bar" style="height: 25%;"></div><div class="stack-student-bar mt-0.5" style="height: 65%;"></div></div>
                                    <div class="bar-container-stack"><div class="stack-lecturer-bar" style="height: 15%;"></div><div class="stack-student-bar mt-0.5" style="height: 45%;"></div></div>
                                    <div class="bar-container-stack"><div class="stack-lecturer-bar" style="height: 30%;"></div><div class="stack-student-bar mt-0.5" style="height: 80%;"></div></div>
                                    <div class="bar-container-stack"><div class="stack-lecturer-bar" style="height: 18%;"></div><div class="stack-student-bar mt-0.5" style="height: 50%;"></div></div>
                                    <div class="bar-container-stack"><div class="stack-lecturer-bar" style="height: 22%;"></div><div class="stack-student-bar mt-0.5" style="height: 60%;"></div></div>
                                    <div class="bar-container-stack"><div class="stack-lecturer-bar" style="height: 12%;"></div><div class="stack-student-bar mt-0.5" style="height: 40%;"></div></div>
                                    <div class="bar-container-stack"><div class="stack-lecturer-bar" style="height: 35%;"></div><div class="stack-student-bar mt-0.5" style="height: 90%;"></div></div>
                                </c:if>
                            </div>
                            
                            <div class="d-flex justify-content-between mt-2 text-secondary px-1 font-weight-bold opacity-50" style="font-size: 11px;">
                                <span>01/10</span><span>08/10</span><span>15/10</span><span>22/10</span><span>31/10</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Promotion Atmospheric Insights Notification Card Panel (4 Columns Grid) -->
                <div class="col-12 col-lg-4">
                    <div class="card border-0 p-4 rounded-3 text-white d-flex flex-column justify-content-between h-100 overflow-hidden position-relative" style="background-color: #9d4300;">
                        <div class="position-relative" style="z-index: 2;">
                            <h5 class="fw-bold mb-3 d-flex align-items-center gap-2"><span class="material-symbols-outlined">lightbulb</span> Thông tin Thư viện</h5>
                            <p class="lh-relaxed mb-4" style="font-size: 16px; opacity: 0.95;">
                                Giờ mượn sách cao điểm được phát hiện trong khoảng <span class="fw-bold">14:00 đến 16:30</span>. Sinh viên tập trung nhiều vào tài liệu ôn thi cho các khóa học Khoa Khoa học.
                            </p>
                        </div>
                        <div class="w-100 z-10 pt-3">
                            <button class="btn btn-light bg-white border-0 w-100 py-2.5 fw-bold" style="color: #9d4300;" onclick="location.href='logs/activity'">Xem Nhật ký Hoạt động</button>
                        </div>
                        <!-- Secondary decorative elements background vector patterns icons footprint -->
                        <div class="position-absolute opacity-10 text-white" style="right: -24px; bottom: -24px; z-index: 1;">
                            <span class="material-symbols-outlined" style="font-size: 140px;">auto_stories</span>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Detailed Grid Analytical Ranking Modules Row -->
            <section class="row g-4">
                <!-- Left Module Card: Top Performing Majors Volume List -->
                <div class="col-12 col-md-6">
                    <div class="card border-0 shadow-sm p-4 rounded-3 bg-white">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold m-0 text-dark">Ngành hoạt động nhất</h5>
                            <a href="reports/majors" class="text-decoration-none small fw-bold" style="color: #9d4300;">Báo cáo chi tiết</a>
                        </div>
                        
                        <div class="d-flex flex-column gap-3">
                            <!-- Matrix loops entities loader parser rows blocks -->
                            <c:forEach var="major" items="${topPerformingMajors}">
                                <div>
                                    <div class="d-flex justify-content-between align-items-center mb-1 small fw-semibold">
                                        <span class="text-dark">${major.name}</span>
                                        <span class="text-muted">${major.volumeCount} cuốn</span>
                                    </div>
                                    <div class="progress rounded-pill" style="height: 8px; background-color: #eceef0;">
                                        <div class="progress-bar rounded-pill" style="width: ${major.percentage}%; background-color: #9d4300;"></div>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <!-- Static samples mocks indicators values checkpoints schemas -->
                            <c:if test="${empty topPerformingMajors}">
                                <div>
                                    <div class="d-flex justify-content-between align-items-center mb-1 small fw-semibold">
                                        <span class="text-dark">Khoa học Máy tính</span><span class="text-muted">612 cuốn</span>
                                    </div>
                                    <div class="progress rounded-pill" style="height: 8px; background-color: #eceef0;">
                                        <div class="progress-bar rounded-pill" style="width: 85%; background-color: #9d4300;"></div>
                                    </div>
                                </div>
                                <div>
                                    <div class="d-flex justify-content-between align-items-center mb-1 small fw-semibold">
                                        <span class="text-dark">Kỹ thuật Cơ khí</span><span class="text-muted">428 cuốn</span>
                                    </div>
                                    <div class="progress rounded-pill" style="height: 8px; background-color: #eceef0;">
                                        <div class="progress-bar rounded-pill" style="width: 60%; background-color: #9d4300;"></div>
                                    </div>
                                </div>
                                <div>
                                    <div class="d-flex justify-content-between align-items-center mb-1 small fw-semibold">
                                        <span class="text-dark">Quản trị Kinh doanh</span><span class="text-muted">385 cuốn</span>
                                    </div>
                                    <div class="progress rounded-pill" style="height: 8px; background-color: #eceef0;">
                                        <div class="progress-bar rounded-pill" style="width: 55%; background-color: #9d4300;"></div>
                                    </div>
                                </div>
                                <div>
                                    <div class="d-flex justify-content-between align-items-center mb-1 small fw-semibold">
                                        <span class="text-dark">Tâm lý học</span><span class="text-muted">210 cuốn</span>
                                    </div>
                                    <div class="progress rounded-pill" style="height: 8px; background-color: #eceef0;">
                                        <div class="progress-bar rounded-pill" style="width: 30%; background-color: #9d4300;"></div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Right Module Card: Top Performing Departments Records Lists -->
                <div class="col-12 col-md-6">
                    <div class="card border-0 shadow-sm p-4 rounded-3 bg-white h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold m-0 text-dark">Khoa hoạt động nhất</h5>
                            <span class="material-symbols-outlined text-secondary" style="cursor: pointer;">more_horiz</span>
                        </div>
                        
                        <div class="d-flex flex-column">
                            <c:forEach var="dept" items="${topPerformingDepartments}" varStatus="status">
                                <div class="d-flex align-items-center justify-content-between p-2 rounded-3 hover-row-item transition-colors">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rounded-3 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px; background-color: rgba(0, 99, 152, 0.1); color: #006398;">
                                            <span class="material-symbols-outlined fs-5">${dept.iconName != null ? dept.iconName : 'biotech'}</span>
                                        </div>
                                        <div>
                                            <p class="fw-bold text-dark m-0 small">${dept.departmentName}</p>
                                            <small class="text-muted" style="font-size: 11px;">${dept.facultyCount} Giảng viên</small>
                                        </div>
                                    </div>
                                    <div class="text-end lh-tight">
                                        <p class="fw-bold m-0 small" style="color: #9d4300;">${dept.loanCount}</p>
                                        <span class="text-muted text-uppercase fw-bold" style="font-size: 9px; letter-spacing: 0.05em;">Lượt mượn</span>
                                    </div>
                                </div>
                                <c:if test="${!status.last}"><div class="divider-horizontal-item"></div></c:if>
                            </c:forEach>
                            
                            <!-- Static templates fallbacks loops validations checkers layouts -->
                            <c:if test="${empty topPerformingDepartments}">
                                <div class="d-flex align-items-center justify-content-between p-2 rounded-3 hover-row-item">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rounded-3 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px; background-color: rgba(0, 99, 152, 0.1); color: #006398;"><span class="material-symbols-outlined fs-5">biotech</span></div>
                                        <div><p class="fw-bold text-dark m-0 small">Khoa học Sinh học</p><small class="text-muted" style="font-size: 11px;">24 Giảng viên</small></div>
                                    </div>
                                    <div class="text-end lh-tight"><p class="fw-bold m-0 small" style="color: #9d4300;">156</p><span class="text-muted text-uppercase fw-bold" style="font-size: 9px;">Lượt mượn</span></div>
                                </div>
                                <div class="divider-horizontal-item"></div>
                                <div class="d-flex align-items-center justify-content-between p-2 rounded-3 hover-row-item">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rounded-3 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px; background-color: rgba(86, 94, 116, 0.1); color: #565e74;"><span class="material-symbols-outlined fs-5">history_edu</span></div>
                                        <div><p class="fw-bold text-dark m-0 small">Văn học &amp; Ngôn ngữ</p><small class="text-muted" style="font-size: 11px;">18 Giảng viên</small></div>
                                    </div>
                                    <div class="text-end lh-tight"><p class="fw-bold m-0 small" style="color: #9d4300;">132</p><span class="text-muted text-uppercase fw-bold" style="font-size: 9px;">Lượt mượn</span></div>
                                </div>
                                <div class="divider-horizontal-item"></div>
                                <div class="d-flex align-items-center justify-content-between p-2 rounded-3 hover-row-item">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="rounded-3 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px; background-color: rgba(157, 67, 0, 0.1); color: #9d4300;"><span class="material-symbols-outlined fs-5">calculate</span></div>
                                        <div><p class="fw-bold text-dark m-0 small">Toán học</p><small class="text-muted" style="font-size: 11px;">15 Giảng viên</small></div>
                                    </div>
                                    <div class="text-end lh-tight"><p class="fw-bold m-0 small" style="color: #9d4300;">118</p><span class="text-muted text-uppercase fw-bold" style="font-size: 9px;">Lượt mượn</span></div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <!-- Bootstrap 5 JS Bundle Script Compilation Engine Package -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- JavaScript Live UI Interactions Actions Triggers Scripts -->
    <script>
        // Micro-interaction indicator log trace for selector date filters changes
        document.querySelector('select').addEventListener('change', function(e) {
            console.log('Target date analysis range altered successfully to: ', e.target.value);
            // Dynamic form reload trigger route could be injected safely here
        });

        // Trigger dynamic height compilation on graph node items over initialization loader bounds
        window.addEventListener('load', () => {
            const lecturerBars = document.querySelectorAll('.stack-lecturer-bar');
            const studentBars = document.querySelectorAll('.stack-student-bar');
            
            lecturerBars.forEach(bar => {
                const finalHeight = bar.style.height;
                bar.style.height = '0';
                setTimeout(() => { bar.style.height = finalHeight; }, 100);
            });
            
            studentBars.forEach(bar => {
                const finalHeight = bar.style.height;
                bar.style.height = '0';
                setTimeout(() => { bar.style.height = finalHeight; }, 100);
            });
        });
    </script>
</body>
</html>