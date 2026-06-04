<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>System Health & Maintenance | Lumina Library</title>

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
                        overflow-x: hidden;
                    }

                    /* Sidebar Configuration */
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
                        .sidebar {
                            display: none !important;
                        }

                        .top-navbar {
                            left: 0 !important;
                        }

                        .main-content {
                            margin-left: 0 !important;
                        }
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
                        background-color: #ffdbca;
                    }

                    .material-symbols-outlined {
                        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                        vertical-align: middle;
                    }

                    /* KPI & Bento Custom Cards */
                    .kpi-card {
                        background-color: #ffffff;
                        border: 1px solid rgba(224, 227, 229, 0.5);
                        border-radius: 12px;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
                        transition: transform 0.3s ease, box-shadow 0.3s ease;
                    }

                    .kpi-card:hover {
                        transform: translateY(-4px);
                        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
                    }

                    /* CSS Virtual Line Chart Bars Layout */
                    .chart-canvas-box {
                        height: 256px;
                        position: relative;
                    }

                    .trend-bar-node {
                        flex: 1;
                        background-color: rgba(157, 67, 0, 0.2);
                        border-radius: 4px 4px 0 0;
                        transition: background-color 0.2s, transform 0.2s;
                        cursor: pointer;
                    }

                    .trend-bar-node:hover {
                        background-color: #9d4300 !important;
                        transform: scaleX(1.05);
                    }

                    /* Custom Tooltip Styling */
                    .chart-node-tooltip {
                        position: absolute;
                        top: -35px;
                        left: 50%;
                        transform: translateX(-50%);
                        background-color: #191c1e;
                        color: #ffffff;
                        font-size: 10px;
                        padding: 4px 8px;
                        border-radius: 4px;
                        opacity: 0;
                        transition: opacity 0.2s;
                        pointer-events: none;
                        white-space: nowrap;
                        z-index: 5;
                    }

                    .chart-bar-wrapper:hover .chart-node-tooltip {
                        opacity: 1;
                    }

                    /* Floating Action Button (FAB) */
                    .fab-bolt-btn {
                        position: fixed;
                        bottom: 32px;
                        right: 32px;
                        width: 56px;
                        height: 56px;
                        border-radius: 50%;
                        background-color: #9d4300;
                        color: white;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        box-shadow: 0 8px 24px rgba(157, 67, 0, 0.3);
                        border: none;
                        z-index: 2000;
                        transition: transform 0.2s, box-shadow 0.2s;
                    }

                    .fab-bolt-btn:hover {
                        transform: scale(1.1);
                        color: white;
                    }

                    .fab-bolt-btn:active {
                        transform: scale(0.95);
                    }

                    /* Custom Scrollbar Override */
                    ::-webkit-scrollbar {
                        width: 6px;
                    }

                    ::-webkit-scrollbar-track {
                        background: #f1f5f9;
                    }

                    ::-webkit-scrollbar-thumb {
                        background: #cbd5e1;
                        border-radius: 10px;
                    }
                </style>
            </head>

            <body>

                <aside class="sidebar d-flex flex-column py-3 px-2">
                    <div class="px-3 mb-4 d-flex align-items-center gap-3">
                        <div class="rounded-lg text-white d-flex align-items-center justify-content-center"
                            style="width: 40px; height: 40px; background-color: #f97316;">
                            <span class="material-symbols-outlined"
                                style="font-variation-settings: 'FILL' 1;">library_books</span>
                        </div>
                        <div>
                            <h1 class="h6 fw-bold m-0 text-dark">Lumina Library</h1>
                            <small class="text-muted opacity-75">System Admin</small>
                        </div>
                    </div>

                    <nav class="nav flex-column gap-1 flex-grow-1">
                        <a class="nav-link-custom active" href="dashboard"><span
                                class="material-symbols-outlined">dashboard</span>Dashboard</a>
                        <a class="nav-link-custom" href="catalog"><span
                                class="material-symbols-outlined">menu_book</span>Catalog</a>
                        <a class="nav-link-custom" href="circulation"><span
                                class="material-symbols-outlined">swap_horiz</span>Circulation</a>
                        <a class="nav-link-custom" href="members"><span
                                class="material-symbols-outlined">group</span>Members</a>
                        <a class="nav-link-custom" href="reports"><span
                                class="material-symbols-outlined">assessment</span>Reports</a>
                        <a class="nav-link-custom" href="settings"><span
                                class="material-symbols-outlined">settings</span>Settings</a>
                    </nav>

                    <div class="px-3 mt-auto">
                        <div class="p-3 rounded-3 border"
                            style="background-color: rgba(249, 115, 22, 0.08); border-color: rgba(249, 115, 22, 0.2) !important;">
                            <p class="small fw-bold mb-1" style="color: #9d4300;">System Version</p>
                            <span class="text-muted" style="font-size: 11px;">v2.4.0-stable (Build 892)</span>
                        </div>
                    </div>
                </aside>

                <header class="top-navbar d-flex align-items-center justify-content-between px-4">
                    <div class="d-flex align-items-center bg-light rounded-pill px-3 py-1.5" style="width: 400px;">
                        <span class="material-symbols-outlined text-secondary me-2 fs-5">search</span>
                        <input class="form-control bg-transparent border-0 p-0 shadow-none small"
                            placeholder="Search system logs or users..." type="text" />
                    </div>

                    <div class="d-flex align-items-center gap-4">
                        <div class="d-flex gap-3 align-items-center text-secondary">
                            <button class="btn btn-link p-0 text-secondary position-relative">
                                <span class="material-symbols-outlined">notifications</span>
                                <span
                                    class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-white rounded-circle"></span>
                            </button>
                            <button class="btn btn-link p-0 text-secondary"><span
                                    class="material-symbols-outlined">help_outline</span></button>
                        </div>
                        <div class="border-start h-100 style"
                            style="height: 24px !important; border-color: #e0e3e5 !important;"></div>
                        <div class="d-flex align-items-center gap-3">
                            <div class="text-end d-none d-sm-block lh-tight">
                                <p class="small fw-bold text-dark m-0">Admin Profile</p>
                                <span class="text-muted" style="font-size: 11px;">Super Administrator</span>
                            </div>
                            <div class="rounded-circle overflow-hidden border border-2 border-orange"
                                style="width: 40px; height: 40px; border-color: #f97316 !important;">
                                <img alt="Administrator Profile Photo" class="w-100 h-100 object-fit-cover"
                                    src="https://lh3.googleusercontent.com/aida-public/AB6AXuDi0_V8g0u_P8YftytpHhtI56d7Yy2lR0Lave7RRMmntGNzKunf6twa_nAp3xmASgiyMEyhOYfbvNd-I37LyGCHcvE0Sk4EIuz4p2lTiC6PGBjyKJjTmRAApy7PcLH59Xraws5osN8XU-Vj8J7-WvOCPPTIlpemr9WMX2eanEOhq2hML0gy-teAIZ48lEyFGy-rxbG4Moj8GLMCm-2_ph8RS83y-1uhCHoyw5swMC67BHkc_lyUJXL1w1MmxBJOpkobKUlVMCB3YWY" />
                            </div>
                        </div>
                    </div>
                </header>

                <main class="main-content p-3 p-md-4">
                    <div class="container-fluid p-0" style="max-width: 1280px;">

                        <div
                            class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-end gap-3 mb-4">
                            <div>
                                <h2 class="fw-bold text-dark m-0 tracking-tight">System Health & Maintenance</h2>
                                <p class="text-muted small m-0">Real-time monitoring of account activity and server
                                    stability.</p>
                            </div>
                            <div class="d-flex gap-2">
                                <button
                                    class="btn btn-light border bg-white rounded-3 px-3 py-2 d-flex align-items-center gap-2 small fw-semibold text-secondary shadow-sm">
                                    <span class="material-symbols-outlined fs-5">download</span> Export Report
                                </button>
                                <form action="system/refresh" method="POST" class="m-0 p-0">
                                    <button type="submit"
                                        class="btn text-white rounded-3 px-3 py-2 d-flex align-items-center gap-2 small fw-semibold shadow-sm"
                                        style="background-color: #9d4300;">
                                        <span class="material-symbols-outlined fs-5">refresh</span> Refresh Data
                                    </button>
                                </form>
                            </div>
                        </div>

                        <section class="row g-4 mb-4">
                            <div class="col-12 class col-sm-6 col-lg-3">
                                <div class="kpi-card p-4">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div class="rounded p-2" style="background-color: #ffdbca; color: #9d4300;">
                                            <span class="material-symbols-outlined d-block">person_add</span></div>
                                        <span
                                            class="badge bg-info-subtle text-info border-0 rounded-pill px-2.5 py-1 d-flex align-items-center gap-0.5"
                                            style="font-size: 10px; font-weight: 700;">
                                            <span class="material-symbols-outlined"
                                                style="font-size: 12px; font-variation-settings: 'FILL' 1;">trending_up</span>
                                            +5%
                                        </span>
                                    </div>
                                    <p class="text-muted fw-semibold uppercase mb-1"
                                        style="font-size: 12px; tracking-wider: 0.05em;">New Accounts (24h)</p>
                                    <h3 class="fw-bold text-dark m-0">${systemStats.newAccounts != null ?
                                        systemStats.newAccounts : '128'}</h3>
                                </div>
                            </div>
                            <div class="col-12 class col-sm-6 col-lg-3">
                                <div class="kpi-card p-4">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div class="rounded p-2" style="background-color: #dae2fd; color: #565e74;">
                                            <span class="material-symbols-outlined d-block">lan</span></div>
                                    </div>
                                    <p class="text-muted fw-semibold uppercase mb-1"
                                        style="font-size: 12px; tracking-wider: 0.05em;">Active Sessions</p>
                                    <h3 class="fw-bold text-dark m-0">${systemStats.activeSessions != null ?
                                        systemStats.activeSessions : '1,240'}</h3>
                                </div>
                            </div>
                            <div class="col-12 class col-sm-6 col-lg-3">
                                <div class="kpi-card p-4">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div class="rounded p-2" style="background-color: #ffdad6; color: #ba1a1a;">
                                            <span class="material-symbols-outlined d-block">report_problem</span></div>
                                    </div>
                                    <p class="text-muted fw-semibold uppercase mb-1"
                                        style="font-size: 12px; tracking-wider: 0.05em;">System Error Rate</p>
                                    <h3 class="fw-bold text-dark m-0">${systemStats.errorRate != null ?
                                        systemStats.errorRate : '0.04%'}</h3>
                                </div>
                            </div>
                            <div class="col-12 class col-sm-6 col-lg-3">
                                <div class="kpi-card p-4">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div class="rounded p-2" style="background-color: #cde5ff; color: #006398;">
                                            <span class="material-symbols-outlined d-block">speed</span></div>
                                    </div>
                                    <p class="text-muted fw-semibold uppercase mb-1"
                                        style="font-size: 12px; tracking-wider: 0.05em;">Server Uptime</p>
                                    <h3 class="fw-bold text-dark m-0">${systemStats.serverUptime != null ?
                                        systemStats.serverUptime : '99.98%'}</h3>
                                </div>
                            </div>
                        </section>

                        <section class="row g-4 mb-4">
                            <div class="col-12 col-lg-8">
                                <div class="card border-0 shadow-sm p-4 rounded-3 bg-white h-100">
                                    <div class="d-flex justify-content-between align-items-center mb-4">
                                        <h5 class="fw-bold text-dark m-0">Account Creation Trend</h5>
                                        <select class="form-select bg-light border-0 px-3 py-1.5 small font-weight-bold"
                                            style="width: auto; font-size: 13px; box-shadow: none;">
                                            <option>Last 30 Days</option>
                                            <option>Last 7 Days</option>
                                            <option>Current Year</option>
                                        </select>
                                    </div>

                                    <div
                                        class="chart-canvas-box d-flex align-items-end justify-content-between gap-2 px-3 border-bottom border-start pb-1">
                                        <div class="position-absolute inset-0 w-100 h-100 d-flex flex-column justify-content-between opacity-10 pointer-events-none"
                                            style="padding-bottom: 28px;">
                                            <div class="border-top border-dark w-100"></div>
                                            <div class="border-top border-dark w-100"></div>
                                            <div class="border-top border-dark w-100"></div>
                                        </div>

                                        <c:forEach var="bar" items="${accountTrendBars}">
                                            <div class="position-relative d-flex flex-column align-items-center chart-bar-wrapper"
                                                style="flex: 1; height: 100%; justify-content: flex-end;">
                                                <div class="chart-node-tooltip">Students: ${bar.studentCount}</div>
                                                <div class="trend-bar-node" style="height: ${bar.percentage}%;"></div>
                                            </div>
                                        </c:forEach>

                                        <c:if test="${empty accountTrendBars}">
                                            <div class="position-relative d-flex flex-column align-items-center chart-bar-wrapper"
                                                style="flex: 1; height: 100%; justify-content: flex-end;">
                                                <div class="chart-node-tooltip">Students</div>
                                                <div class="trend-bar-node" style="height: 66%;"></div>
                                            </div>
                                            <div class="position-relative d-flex flex-column align-items-center chart-bar-wrapper"
                                                style="flex: 1; height: 100%; justify-content: flex-end;">
                                                <div class="trend-bar-node" style="height: 75%;"></div>
                                            </div>
                                            <div class="position-relative d-flex flex-column align-items-center chart-bar-wrapper"
                                                style="flex: 1; height: 100%; justify-content: flex-end;">
                                                <div class="trend-bar-node" style="height: 83%;"></div>
                                            </div>
                                            <div class="position-relative d-flex flex-column align-items-center chart-bar-wrapper"
                                                style="flex: 1; height: 100%; justify-content: flex-end;">
                                                <div class="trend-bar-node" style="height: 50%;"></div>
                                            </div>
                                            <div class="position-relative d-flex flex-column align-items-center chart-bar-wrapper"
                                                style="flex: 1; height: 100%; justify-content: flex-end;">
                                                <div class="trend-bar-node" style="height: 66%;"></div>
                                            </div>
                                            <div class="position-relative d-flex flex-column align-items-center chart-bar-wrapper"
                                                style="flex: 1; height: 100%; justify-content: flex-end;">
                                                <div class="trend-bar-node" style="height: 33%;"></div>
                                            </div>
                                            <div class="position-relative d-flex flex-column align-items-center chart-bar-wrapper"
                                                style="flex: 1; height: 100%; justify-content: flex-end;">
                                                <div class="trend-bar-node" style="height: 75%;"></div>
                                            </div>
                                            <div class="position-relative d-flex flex-column align-items-center chart-bar-wrapper"
                                                style="flex: 1; height: 100%; justify-content: flex-end;">
                                                <div class="trend-bar-node" style="height: 25%;"></div>
                                            </div>
                                            <div class="position-relative d-flex flex-column align-items-center chart-bar-wrapper"
                                                style="flex: 1; height: 100%; justify-content: flex-end;">
                                                <div class="trend-bar-node" style="height: 100%;"></div>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="d-flex justify-content-between mt-2 text-secondary px-2 fw-semibold opacity-50"
                                        style="font-size: 11px;">
                                        <span>Oct 01</span><span>Oct 15</span><span>Oct 30</span>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 col-lg-4 d-flex flex-column gap-4">
                                <div class="card border-0 p-4 rounded-3 text-white position-relative overflow-hidden flex-grow-1 d-flex flex-column justify-content-center"
                                    style="background-color: #9d4300;">
                                    <div class="position-absolute text-white opacity-5"
                                        style="right: -16px; bottom: -16px; transform: scale(1.5); pointer-events: none;">
                                        <span class="material-symbols-outlined"
                                            style="font-size: 120px;">lightbulb</span>
                                    </div>
                                    <div class="d-flex align-items-center gap-2 mb-2">
                                        <span class="material-symbols-outlined">tips_and_updates</span>
                                        <h5 class="fw-bold m-0">Pro-Tip</h5>
                                    </div>
                                    <p class="m-0 small lh-base" style="opacity: 0.9;">
                                        Monitor spike in 500 errors during peak enrollment periods to prevent system
                                        overload.
                                    </p>
                                </div>

                                <div class="card border-0 shadow-sm p-4 rounded-3 bg-white flex-grow-1">
                                    <h5 class="fw-bold text-dark m-0">Error Frequency</h5>
                                    <small class="text-muted d-block mt-0.5">Status 500 Log Tracker</small>

                                    <div class="d-flex align-items-end gap-1.5 mt-4 border-bottom pb-1"
                                        style="height: 80px;">
                                        <div class="bg-danger-subtle flex-grow-1"
                                            style="height: 10%; border-radius: 2px 2px 0 0;"></div>
                                        <div class="bg-danger-subtle flex-grow-1"
                                            style="height: 15%; border-radius: 2px 2px 0 0;"></div>
                                        <div class="bg-danger flex-grow-1"
                                            style="height: 80%; border-radius: 2px 2px 0 0;"></div>
                                        <div class="bg-danger-subtle flex-grow-1"
                                            style="height: 20%; border-radius: 2px 2px 0 0;"></div>
                                        <div class="bg-danger-subtle flex-grow-1"
                                            style="height: 5%; border-radius: 2px 2px 0 0;"></div>
                                        <div class="bg-danger-subtle flex-grow-1"
                                            style="height: 12%; border-radius: 2px 2px 0 0;"></div>
                                        <div class="bg-danger opacity-50 flex-grow-1"
                                            style="height: 40%; border-radius: 2px 2px 0 0;"></div>
                                    </div>

                                    <div class="mt-3 d-flex align-items-center justify-content-between small">
                                        <span class="text-danger fw-bold" style="font-size: 13px;">Critical Peak
                                            Detected</span>
                                        <span class="text-muted opacity-75">2h ago</span>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section class="card border-0 shadow-sm rounded-3 bg-white overflow-hidden">
                            <div class="p-3 bg-white border-bottom d-flex align-items-center justify-content-between">
                                <h5 class="fw-bold m-0 text-dark">Recent System Events</h5>
                                <a href="logs/all" class="text-decoration-none small fw-bold"
                                    style="color: #9d4300;">View All Logs</a>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light text-secondary text-uppercase tracking-wider"
                                        style="font-size: 11px;">
                                        <tr>
                                            <th class="py-3 px-4">Timestamp</th>
                                            <th class="py-3 px-3">Action</th>
                                            <th class="py-3 px-3">User ID</th>
                                            <th class="py-3 px-4">Status</th>
                                        </tr>
                                    </thead>
                                    <tbody class="border-top-0">
                                        <c:forEach var="log" items="${recentSystemEvents}">
                                            <tr class="event-tr-row" style="transition: transform 0.2s;">
                                                <td class="px-4 text-muted small">${log.timestamp}</td>
                                                <td class="px-3 small fw-semibold text-dark">
                                                    <span class="d-flex align-items-center gap-2">
                                                        <span
                                                            class="material-symbols-outlined fs-5 text-${log.iconColor != null ? log.iconColor : 'secondary'}">
                                                            ${log.iconName != null ? log.iconName : 'circle'}
                                                        </span>
                                                        ${log.actionName}
                                                    </span>
                                                </td>
                                                <td class="px-3 font-monospace text-secondary small">${log.userId}</td>
                                                <td class="px-4">
                                                    <c:choose>
                                                        <c:when test="${log.status == 'Success'}">
                                                            <span
                                                                class="badge bg-green-100 text-success rounded-pill px-2.5 py-1 text-uppercase"
                                                                style="font-size: 10px; font-weight: 700; letter-spacing: 0.05em;">Success</span>
                                                        </c:when>
                                                        <c:when test="${log.status == 'Critical'}">
                                                            <span
                                                                class="badge bg-danger-100 text-danger rounded-pill px-2.5 py-1 text-uppercase"
                                                                style="font-size: 10px; font-weight: 700; letter-spacing: 0.05em;">Critical</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span
                                                                class="badge bg-warning-100 text-warning rounded-pill px-2.5 py-1 text-uppercase"
                                                                style="font-size: 10px; font-weight: 700; letter-spacing: 0.05em;">Warning</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty recentSystemEvents}">
                                            <tr class="event-tr-row" style="transition: transform 0.2s;">
                                                <td class="px-4 text-muted small">2023-10-27 14:32:01</td>
                                                <td class="px-3 small fw-semibold text-dark"><span
                                                        class="d-flex align-items-center gap-2"><span
                                                            class="material-symbols-outlined fs-5 text-info">person_add</span>
                                                        Account Created</span></td>
                                                <td class="px-3 font-monospace text-secondary small">USR-88219</td>
                                                <td class="px-4"><span
                                                        class="badge bg-success-subtle text-success rounded-pill px-2.5 py-1"
                                                        style="font-size: 10px; font-weight: 700;">SUCCESS</span></td>
                                            </tr>
                                            <tr class="event-tr-row" style="transition: transform 0.2s;">
                                                <td class="px-4 text-muted small">2023-10-27 14:30:45</td>
                                                <td class="px-3 small fw-semibold text-dark"><span
                                                        class="d-flex align-items-center gap-2"><span
                                                            class="material-symbols-outlined fs-5 text-danger">error_outline</span>
                                                        System Error (500)</span></td>
                                                <td class="px-3 font-monospace text-secondary small">SYS-ADMIN</td>
                                                <td class="px-4"><span
                                                        class="badge bg-danger-subtle text-danger rounded-pill px-2.5 py-1"
                                                        style="font-size: 10px; font-weight: 700;">CRITICAL</span></td>
                                            </tr>
                                            <tr class="event-tr-row" style="transition: transform 0.2s;">
                                                <td class="px-4 text-muted small">2023-10-27 14:28:12</td>
                                                <td class="px-3 small fw-semibold text-dark"><span
                                                        class="d-flex align-items-center gap-2"><span
                                                            class="material-symbols-outlined fs-5 text-secondary">update</span>
                                                        Database Backup</span></td>
                                                <td class="px-3 font-monospace text-secondary small">CRON-TASK</td>
                                                <td class="px-4"><span
                                                        class="badge bg-primary-subtle text-primary rounded-pill px-2.5 py-1"
                                                        style="font-size: 10px; font-weight: 700;">SUCCESS</span></td>
                                            </tr>
                                            <tr class="event-tr-row" style="transition: transform 0.2s;">
                                                <td class="px-4 text-muted small">2023-10-27 14:25:00</td>
                                                <td class="px-3 small fw-semibold text-dark"><span
                                                        class="d-flex align-items-center gap-2"><span
                                                            class="material-symbols-outlined fs-5 text-warning">security</span>
                                                        Password Reset</span></td>
                                                <td class="px-3 font-monospace text-secondary small">USR-44210</td>
                                                <td class="px-4"><span
                                                        class="badge bg-warning-subtle text-warning rounded-pill px-2.5 py-1"
                                                        style="font-size: 10px; font-weight: 700;">WARNING</span></td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </section>

                    </div>
                </main>

                <button type="button" class="fab-bolt-btn" title="Quick Actions">
                    <span class="material-symbols-outlined fs-3">bolt</span>
                </button>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        // Smooth zoom macro interactive responses for table record rows
                        const rows = document.querySelectorAll('.event-tr-row');
                        rows.forEach(row => {
                            row.addEventListener('mouseenter', () => {
                                row.style.transform = 'scale(1.002)';
                            });
                            row.addEventListener('mouseleave', () => {
                                row.style.transform = 'scale(1)';
                            });
                        });

                        // Trigger real-time visual height compilation animations on chart load flows
                        const trendBars = document.querySelectorAll('.trend-bar-node');
                        trendBars.forEach(bar => {
                            const finalHeight = bar.style.height;
                            bar.style.height = '0';
                            setTimeout(() => {
                                bar.style.height = finalHeight;
                            }, 120);
                        });
                    });
                </script>
            </body>

            </html>