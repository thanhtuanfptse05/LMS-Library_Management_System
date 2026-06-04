<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Fine &amp; Revenue Analytics | Lumina Library</title>

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

                    /* Sidebar Layout Configuration */
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
                    }

                    /* Custom Charts Components CSS */
                    .chart-container-box {
                        height: 300px;
                    }

                    .chart-bar-wrapper {
                        flex: 1;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        height: 100%;
                    }

                    .chart-bar-node {
                        width: 100%;
                        background-color: rgba(249, 115, 22, 0.2);
                        border-radius: 6px 6px 0 0;
                        transition: height 0.8s cubic-bezier(0.4, 0, 0.2, 1);
                        cursor: pointer;
                    }

                    .chart-bar-node:hover {
                        background-color: #f97316 !important;
                    }

                    /* Abstract Donut Pattern Wrapper */
                    .donut-container {
                        width: 192px;
                        height: 192px;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        background: conic-gradient(#f97316 0% 75%, #00a2f4 75% 100%);
                    }

                    .donut-center-hole {
                        width: 128px;
                        height: 128px;
                        background-color: #ffffff;
                        border-radius: 50%;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                        box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.05);
                    }
                </style>
            </head>

            <body>

                <!-- Sidebar Navigation Shell Container -->
                <aside class="sidebar d-flex flex-column py-3 px-2">
                    <div class="mb-4 px-3">
                        <h1 class="h4 fw-bold m-0" style="color: #9d4300;">Lumina Library</h1>
                        <small class="text-muted opacity-75">Admin Console</small>
                    </div>

                    <nav class="nav flex-column gap-1 flex-grow-1">
                        <a class="nav-link-custom" href="dashboard"><span
                                class="material-symbols-outlined">dashboard</span>Dashboard</a>
                        <a class="nav-link-custom" href="catalog"><span
                                class="material-symbols-outlined">menu_book</span>Catalog</a>
                        <a class="nav-link-custom" href="circulation"><span
                                class="material-symbols-outlined">swap_horiz</span>Circulation</a>
                        <a class="nav-link-custom" href="members"><span
                                class="material-symbols-outlined">group</span>Members</a>
                        <a class="nav-link-custom active" href="reports"><span
                                class="material-symbols-outlined">analytics</span>Reports</a>
                        <a class="nav-link-custom" href="settings"><span
                                class="material-symbols-outlined">settings</span>Settings</a>
                    </nav>

                    <div class="mt-auto pt-3 border-top px-3 d-flex align-items-center gap-3">
                        <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                            style="width: 40px; height: 40px; background-color: #ffdbca; color: #341100;">LA</div>
                        <div>
                            <p class="small fw-semibold m-0 leading-tight">Admin</p>
                            <span class="text-muted uppercase tracking-wider" style="font-size: 10px;">LMS
                                UNIVERSITY</span>
                        </div>
                    </div>
                </aside>

                <!-- Top Global Header Navigation Navbar -->
                <header class="top-navbar d-flex align-items-center justify-content-between px-4">
                    <div class="d-flex align-items-center bg-light rounded-pill px-3 py-1.5" style="width: 350px;">
                        <span class="material-symbols-outlined text-secondary me-2 fs-5">search</span>
                        <input class="form-control bg-transparent border-0 p-0 shadow-none small"
                            placeholder="Search analytics..." type="text" />
                    </div>

                    <div class="d-flex align-items-center gap-4">
                        <div class="d-flex gap-3">
                            <button class="btn btn-link p-0 text-secondary"><span
                                    class="material-symbols-outlined">notifications</span></button>
                            <button class="btn btn-link p-0 text-secondary"><span
                                    class="material-symbols-outlined">help_outline</span></button>
                        </div>
                        <div class="border-start h-100 style"
                            style="height: 24px !important; border-color: rgba(0,0,0,0.1) !important;"></div>
                        <div class="d-flex align-items-center gap-2">
                            <img alt="Administrator Profile" class="rounded-circle border object-fit-cover"
                                src="https://lh3.googleusercontent.com/aida-public/AB6AXuAdauV02VP7bKZtcH57Rn2csEZhg6Jf7ZRzX8XcU9DEfjNYiywJUgrfQoXI0F-W2G_4Q7GklF8bsUs96hxSJjEm48i5eiwJp8KOtQnqxSEsZUnqklKvlBMoWNEbf1BSQZ0jnG0DwmXhrH--CdoJxie5CcK8RDGdGKrqUju6sSQwtZHDtoEhSugf-mojxdOOb4SpBlmOwnxpwk8YIysjo8950GbZXvuZgx0aHJO8ivOZ6jcwPGX4ZgV1ztzRJ8pET3fb7h6VI1-nBY4"
                                style="width: 32px; height: 32px;" />
                            <span class="material-symbols-outlined text-secondary">expand_more</span>
                        </div>
                    </div>
                </header>

                <!-- Main Content Canvas Dynamic Content -->
                <main class="main-content">
                    <div class="container-fluid p-4" style="max-width: 1280px;">

                        <!-- Workspace Title Page Section Header -->
                        <div class="d-flex justify-content-between align-items-end mb-4">
                            <div>
                                <h2 class="fw-bold m-0 text-dark">Fine &amp; Revenue Analytics</h2>
                                <p class="text-muted m-0 small">Tracking library fiscal health and circulation
                                    penalties.</p>
                            </div>
                            <button class="btn text-white fw-bold d-flex align-items-center gap-2 px-4 py-2 shadow-sm"
                                style="background-color: #9d4300;">
                                <span class="material-symbols-outlined fs-5">download</span> Export Report
                            </button>
                        </div>

                        <!-- Bento Style Top Summary Cards Row -->
                        <section class="row g-4 mb-4">
                            <!-- Total Revenue -->
                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="card border-0 shadow-sm p-3 bg-white">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="rounded p-2" style="background-color: #ffdbca; color: #341100;">
                                            <span class="material-symbols-outlined d-block">payments</span></div>
                                        <span
                                            class="badge bg-success-subtle text-success border-0 rounded-pill px-2.5 py-1 small fw-bold">+12.4%</span>
                                    </div>
                                    <p class="text-muted text-uppercase tracking-wider fw-semibold mb-1"
                                        style="font-size: 11px;">Total Revenue (MTD)</p>
                                    <h3 class="fw-bold text-dark m-0">
                                        <c:choose>
                                            <c:when test="${financeStats.totalRevenue != null}">
                                                <fmt:formatNumber value="${financeStats.totalRevenue}" type="currency"
                                                    currencySymbol="$" />
                                            </c:when>
                                            <c:otherwise>$14,285.50</c:otherwise>
                                        </c:choose>
                                    </h3>
                                </div>
                            </div>
                            <!-- Quarterly Collection -->
                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="card border-0 shadow-sm p-3 bg-white">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="rounded p-2" style="background-color: #cde5ff; color: #001d32;">
                                            <span class="material-symbols-outlined d-block">calendar_month</span></div>
                                    </div>
                                    <p class="text-muted text-uppercase tracking-wider fw-semibold mb-1"
                                        style="font-size: 11px;">Quarterly Collection</p>
                                    <h3 class="fw-bold text-dark m-0">
                                        <c:choose>
                                            <c:when test="${financeStats.quarterlyCollection != null}">
                                                <fmt:formatNumber value="${financeStats.quarterlyCollection}"
                                                    type="currency" currencySymbol="$" />
                                            </c:when>
                                            <c:otherwise>$42,910.00</c:otherwise>
                                        </c:choose>
                                    </h3>
                                </div>
                            </div>
                            <!-- Outstanding Fines -->
                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="card border-0 shadow-sm p-3 bg-white">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="rounded p-2" style="background-color: #ffdad6; color: #ba1a1a;">
                                            <span class="material-symbols-outlined d-block">warning</span></div>
                                    </div>
                                    <p class="text-muted text-uppercase tracking-wider fw-semibold mb-1"
                                        style="font-size: 11px;">Outstanding Fines</p>
                                    <h3 class="fw-bold text-danger m-0">
                                        <c:choose>
                                            <c:when test="${financeStats.outstandingFines != null}">
                                                <fmt:formatNumber value="${financeStats.outstandingFines}"
                                                    type="currency" currencySymbol="$" />
                                            </c:when>
                                            <c:otherwise>$3,104.25</c:otherwise>
                                        </c:choose>
                                    </h3>
                                </div>
                            </div>
                            <!-- Payment Success Rate -->
                            <div class="col-12 col-md-6 col-lg-3">
                                <div class="card border-0 shadow-sm p-3 bg-white">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="rounded p-2" style="background-color: #dae2fd; color: #131b2e;">
                                            <span class="material-symbols-outlined d-block">check_circle</span></div>
                                        <span
                                            class="badge bg-light text-primary border rounded-pill px-2.5 py-1 small fw-bold">Stable</span>
                                    </div>
                                    <p class="text-muted text-uppercase tracking-wider fw-semibold mb-1"
                                        style="font-size: 11px;">Payment Success Rate</p>
                                    <h3 class="fw-bold text-dark m-0">${financeStats.successRate != null ?
                                        financeStats.successRate : '98.2%'}</h3>
                                </div>
                            </div>
                        </section>

                        <!-- Analytical Visual Dashboard Graphics Segment -->
                        <section class="row g-4 mb-4">
                            <!-- Left Section: Monthly Revenue Trends (Bar Chart CSS Engine Matrix) -->
                            <div class="col-12 col-lg-8">
                                <div class="card border-0 shadow-sm p-4 rounded-3 bg-white h-100">
                                    <div class="d-flex justify-content-between align-items-center mb-4">
                                        <h5 class="fw-bold m-0 text-dark">Monthly Revenue Trends</h5>
                                        <div class="d-flex gap-3 small text-muted font-weight-semibold">
                                            <div class="d-flex align-items-center gap-1.5"><span
                                                    class="d-inline-block rounded-circle"
                                                    style="width: 10px; height: 10px; background-color: #f97316;"></span>
                                                Fines</div>
                                            <div class="d-flex align-items-center gap-1.5"><span
                                                    class="d-inline-block rounded-circle"
                                                    style="width: 10px; height: 10px; background-color: #00a2f4;"></span>
                                                Services</div>
                                        </div>
                                    </div>

                                    <!-- Core CSS Flexbar Graphic Canvas Layout -->
                                    <div
                                        class="chart-container-box d-flex align-items-end justify-content-between gap-2 pt-3 border-bottom pb-1">
                                        <!-- Array configuration rows injection via loop mapping engines -->
                                        <c:forEach var="bar" items="${monthlyRevenueBars}">
                                            <div class="chart-bar-wrapper">
                                                <div class="chart-bar-node" data-bs-toggle="tooltip"
                                                    title="Revenue: $${bar.value}" style="height: ${bar.percentage}%;">
                                                </div>
                                                <span class="mt-2 text-secondary fw-medium"
                                                    style="font-size: 11px;">${bar.monthName}</span>
                                            </div>
                                        </c:forEach>

                                        <!-- Static samples blueprint fallback rows models validation layout views -->
                                        <c:if test="${empty monthlyRevenueBars}">
                                            <div class="chart-bar-wrapper">
                                                <div class="chart-bar-node" style="height: 40%;"></div><span
                                                    class="mt-2 text-secondary fw-medium"
                                                    style="font-size: 11px;">Jan</span>
                                            </div>
                                            <div class="chart-bar-wrapper">
                                                <div class="chart-bar-node" style="height: 55%;"></div><span
                                                    class="mt-2 text-secondary fw-medium"
                                                    style="font-size: 11px;">Feb</span>
                                            </div>
                                            <div class="chart-bar-wrapper">
                                                <div class="chart-bar-node" style="height: 45%;"></div><span
                                                    class="mt-2 text-secondary fw-medium"
                                                    style="font-size: 11px;">Mar</span>
                                            </div>
                                            <div class="chart-bar-wrapper">
                                                <div class="chart-bar-node" style="height: 70%;"></div><span
                                                    class="mt-2 text-secondary fw-medium"
                                                    style="font-size: 11px;">Apr</span>
                                            </div>
                                            <div class="chart-bar-wrapper">
                                                <div class="chart-bar-node" style="height: 60%;"></div><span
                                                    class="mt-2 text-secondary fw-medium"
                                                    style="font-size: 11px;">May</span>
                                            </div>
                                            <div class="chart-bar-wrapper">
                                                <div class="chart-bar-node" style="height: 85%;"></div><span
                                                    class="mt-2 text-secondary fw-medium"
                                                    style="font-size: 11px;">Jun</span>
                                            </div>
                                            <div class="chart-bar-wrapper">
                                                <div class="chart-bar-node" style="height: 75%;"></div><span
                                                    class="mt-2 text-secondary fw-medium"
                                                    style="font-size: 11px;">Jul</span>
                                            </div>
                                            <div class="chart-bar-wrapper">
                                                <div class="chart-bar-node" style="height: 90%;"></div><span
                                                    class="mt-2 text-secondary fw-medium"
                                                    style="font-size: 11px;">Aug</span>
                                            </div>
                                            <div class="chart-bar-wrapper">
                                                <div class="chart-bar-node" style="height: 65%;"></div><span
                                                    class="mt-2 text-secondary fw-medium"
                                                    style="font-size: 11px;">Sep</span>
                                            </div>
                                            <div class="chart-bar-wrapper">
                                                <div class="chart-bar-node" style="height: 80%;"></div><span
                                                    class="mt-2 text-secondary fw-medium"
                                                    style="font-size: 11px;">Oct</span>
                                            </div>
                                            <div class="chart-bar-wrapper">
                                                <div class="chart-bar-node" style="height: 95%;"></div><span
                                                    class="mt-2 text-secondary fw-medium"
                                                    style="font-size: 11px;">Nov</span>
                                            </div>
                                            <div class="chart-bar-wrapper">
                                                <div class="chart-bar-node" style="height: 100%;"></div><span
                                                    class="mt-2 text-secondary fw-medium"
                                                    style="font-size: 11px;">Dec</span>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <!-- Right Section: Payment Method Donut Segment View -->
                            <div class="col-12 col-lg-4">
                                <div class="card border-0 shadow-sm p-4 rounded-3 bg-white h-100 d-flex flex-column">
                                    <h5 class="fw-bold mb-3 text-dark">Payment Methods</h5>
                                    <div class="flex-grow-1 d-flex align-items-center justify-content-center py-3">
                                        <div class="donut-container">
                                            <div class="donut-center-hole">
                                                <span class="fw-bold text-dark h4 m-0">${donutOnlinePercentage != null ?
                                                    donutOnlinePercentage : '75%'}</span>
                                                <small class="text-uppercase text-muted tracking-wider"
                                                    style="font-size: 10px;">ONLINE</small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mt-auto d-flex flex-column gap-2 pt-3 border-top">
                                        <div class="d-flex justify-content-between align-items-center small">
                                            <div class="d-flex align-items-center gap-2">
                                                <span class="d-inline-block rounded-circle"
                                                    style="width: 10px; height: 10px; background-color: #f97316;"></span>Online
                                                Portal
                                            </div>
                                            <span class="fw-bold text-dark">$32,182.50</span>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center small">
                                            <div class="d-flex align-items-center gap-2">
                                                <span class="d-inline-block rounded-circle"
                                                    style="width: 10px; height: 10px; background-color: #00a2f4;"></span>Cash
                                                / In-Person
                                            </div>
                                            <span class="fw-bold text-dark">$10,727.50</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- Detailed Transactions Logs History Database Table Panels -->
                        <section class="card border-0 shadow-sm rounded-3 bg-white overflow-hidden mb-4">
                            <div class="p-3 bg-white border-bottom d-flex justify-content-between align-items-center">
                                <h5 class="fw-bold m-0 text-dark">Recent Fine Payments</h5>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-sm btn-light border px-3 rounded-2">Filter</button>
                                    <button class="btn btn-sm btn-light border px-3 rounded-2">View All</button>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light text-secondary text-uppercase tracking-wider"
                                        style="font-size: 11px;">
                                        <tr>
                                            <th class="py-3 px-4">Member Name</th>
                                            <th class="py-3 px-3">Amount</th>
                                            <th class="py-3 px-3">Date</th>
                                            <th class="py-3 px-3">Status</th>
                                            <th class="py-3 px-3">Method</th>
                                            <th class="py-3 px-4 text-end">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody class="border-top-0">
                                        <!-- Core Iteration Mapping rows array context fields controller tags -->
                                        <c:forEach var="payment" items="${recentFinePayments}">
                                            <tr>
                                                <td class="px-4">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <div class="rounded-circle d-flex align-items-center justify-content-center text-white small fw-bold"
                                                            style="width: 32px; height: 32px; background-color: #dae2fd; color: #131b2e !important;">
                                                            ${payment.memberInitials}
                                                        </div>
                                                        <div>
                                                            <p class="fw-bold text-dark small m-0">${payment.memberName}
                                                            </p>
                                                            <small class="text-muted d-block"
                                                                style="font-size: 11px;">${payment.memberCode}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="px-3 fw-bold text-dark">
                                                    <fmt:formatNumber value="${payment.amount}" type="currency"
                                                        currencySymbol="$" />
                                                </td>
                                                <td class="px-3 text-muted small">
                                                    <fmt:formatDate value="${payment.date}" pattern="MMM dd, yyyy" />
                                                </td>
                                                <td class="px-3">
                                                    <c:choose>
                                                        <c:when test="${payment.status == 'Paid'}">
                                                            <span
                                                                class="badge bg-success-subtle text-success rounded-pill px-2.5 py-1 text-uppercase"
                                                                style="font-size: 10px;">Paid</span>
                                                        </c:when>
                                                        <c:when test="${payment.status == 'Pending'}">
                                                            <span
                                                                class="badge bg-warning-subtle text-warning rounded-pill px-2.5 py-1 text-uppercase"
                                                                style="font-size: 10px;">Pending</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span
                                                                class="badge bg-danger-subtle text-danger rounded-pill px-2.5 py-1 text-uppercase"
                                                                style="font-size: 10px;">Failed</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-3 text-secondary small">
                                                    <div class="d-flex align-items-center gap-1.5">
                                                        <span class="material-symbols-outlined fs-6">${payment.method ==
                                                            'Online' ? 'public' : 'payments'}</span>
                                                        ${payment.method}
                                                    </div>
                                                </td>
                                                <td class="px-4 text-end">
                                                    <button class="btn btn-link text-secondary p-0 shadow-none"><span
                                                            class="material-symbols-outlined">more_vert</span></button>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <!-- Static templates fallbacks data visualization checks items triggers -->
                                        <c:if test="${empty recentFinePayments}">
                                            <tr>
                                                <td class="px-4">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                                            style="width: 32px; height: 32px; background-color: #dae2fd; color: #131b2e;">
                                                            JW</div>
                                                        <div>
                                                            <p class="fw-bold text-dark small m-0">Julianne Weaver</p>
                                                            <small class="text-muted d-block"
                                                                style="font-size: 11px;">LMS-STU-202304</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="px-3 fw-bold text-dark">$12.50</td>
                                                <td class="px-3 text-muted small">Oct 24, 2023</td>
                                                <td class="px-3"><span
                                                        class="badge bg-success-subtle text-success rounded-pill px-2.5 py-1"
                                                        style="font-size: 10px;">PAID</span></td>
                                                <td class="px-3 text-secondary small">
                                                    <div class="d-flex align-items-center gap-1.5"><span
                                                            class="material-symbols-outlined fs-6">public</span>Online
                                                    </div>
                                                </td>
                                                <td class="px-4 text-end"><button
                                                        class="btn btn-link text-secondary p-0"><span
                                                            class="material-symbols-outlined">more_vert</span></button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="px-4">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                                            style="width: 32px; height: 32px; background-color: #ffdbca; color: #341100;">
                                                            MK</div>
                                                        <div>
                                                            <p class="fw-bold text-dark small m-0">Marcus Knight</p>
                                                            <small class="text-muted d-block"
                                                                style="font-size: 11px;">LMS-FAC-201912</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="px-3 fw-bold text-dark">$45.00</td>
                                                <td class="px-3 text-muted small">Oct 24, 2023</td>
                                                <td class="px-3"><span
                                                        class="badge bg-warning-subtle text-warning rounded-pill px-2.5 py-1"
                                                        style="font-size: 10px;">PENDING</span></td>
                                                <td class="px-3 text-secondary small">
                                                    <div class="d-flex align-items-center gap-1.5"><span
                                                            class="material-symbols-outlined fs-6">payments</span>Cash
                                                    </div>
                                                </td>
                                                <td class="px-4 text-end"><button
                                                        class="btn btn-link text-secondary p-0"><span
                                                            class="material-symbols-outlined">more_vert</span></button>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Table Pagination Footer Navigation Row Controls -->
                            <div
                                class="p-3 bg-light-subtle border-top d-flex flex-column flex-sm-row justify-content-between align-items-center gap-3 small text-muted">
                                <p class="m-0">Showing 1 to 4 of 1,248 entries</p>
                                <nav aria-label="Page navigation">
                                    <ul class="pagination pagination-sm m-0 gap-1 border-0">
                                        <li class="page-item disabled"><a
                                                class="page-link rounded-2 border d-flex align-items-center p-1.5"
                                                href="#"><span
                                                    class="material-symbols-outlined fs-6">chevron_left</span></a></li>
                                        <li class="page-item active"><a
                                                class="page-link rounded-2 fw-bold text-white border-0 px-2.5"
                                                style="background-color: #9d4300;" href="#">1</a></li>
                                        <li class="page-item"><a class="page-link rounded-2 border text-dark px-2.5"
                                                href="#">2</a></li>
                                        <li class="page-item"><a class="page-link rounded-2 border text-dark px-2.5"
                                                href="#">3</a></li>
                                        <li class="page-item"><a
                                                class="page-link rounded-2 border d-flex align-items-center p-1.5"
                                                href="#"><span
                                                    class="material-symbols-outlined fs-6">chevron_right</span></a></li>
                                    </ul>
                                </nav>
                            </div>
                        </section>

                        <!-- Bottom Target Processing & Recommendation Panels Grid Row -->
                        <section class="row g-4">
                            <div class="col-12 col-md-6">
                                <div class="card border-0 p-4 rounded-3 bg-light border position-relative overflow-hidden group"
                                    style="height: 100%;">
                                    <div class="position-relative" style="z-index: 2;">
                                        <h5 class="fw-bold text-dark mb-2">Quarterly Revenue (Q4)</h5>
                                        <p class="small text-muted mb-3">You have reached 84% of your projected revenue
                                            target for this academic quarter.</p>
                                        <div class="progress rounded-pill overflow-hidden shadow-inner"
                                            style="height: 12px; background-color: rgba(255,255,255,0.7);">
                                            <div class="progress-bar rounded-pill" role="progressbar"
                                                style="width: 84%; background-color: #9d4300;"></div>
                                        </div>
                                    </div>
                                    <div class="position-absolute opacity-10 text-secondary"
                                        style="right: -32px; bottom: -32px; z-index: 1;">
                                        <span class="material-symbols-outlined animate-grow-trigger"
                                            style="font-size: 160px; font-variation-settings: 'FILL' 1;">trending_up</span>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 col-md-6">
                                <div class="card border-0 p-4 rounded-3 text-white position-relative overflow-hidden"
                                    style="background-color: #9d4300; height: 100%;">
                                    <div class="position-relative" style="z-index: 2;">
                                        <p class="text-uppercase fw-bold mb-2 tracking-widest"
                                            style="color: #ffdbca; font-size: 12px;">Pro-Tip</p>
                                        <p class="m-0 lh-relaxed" style="font-size: 16px;">Early automated reminders via
                                            the Lumina Online Portal have reduced outstanding fines by 24% compared to
                                            the previous semester.</p>
                                    </div>
                                    <div class="position-absolute bg-white rounded-circle opacity-5"
                                        style="width: 128px; height: 128px; top: -64px; right: -64px; z-index: 1;">
                                    </div>
                                </div>
                            </div>
                        </section>

                    </div>
                </main>

                <!-- Bootstrap 5 JS Bundle Combo Package Scripts -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

                <!-- JavaScript Interactive Function Drivers -->
                <script>
                    // Micro-interaction: Trigger dynamic column animations smoothly on page mount
                    window.addEventListener('load', () => {
                        const bars = document.querySelectorAll('.chart-bar-node');
                        bars.forEach(bar => {
                            const targetHeight = bar.style.height;
                            bar.style.height = '0';
                            setTimeout(() => {
                                bar.style.height = targetHeight;
                            }, 150);
                        });

                        // Initialization Bootstrap tooltips logic indicators mapping
                        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                        tooltipTriggerList.map(function (tooltipTriggerEl) {
                            return new bootstrap.Tooltip(tooltipTriggerEl);
                        });
                    });
                </script>
            </body>

            </html>