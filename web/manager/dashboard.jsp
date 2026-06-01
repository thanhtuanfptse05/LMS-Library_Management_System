<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>University Library Management System - Dashboard</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css" />
    <style>
        .bento-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 24px;
        }
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: var(--color-outline-variant); border-radius: 10px; }
    </style>
</head>
<body class="dash-body">
    <!-- Side Navigation Bar -->
    <aside class="dash-sidebar">
        <div class="mb-10 d-flex items-center gap-3">
            <div class="w-10 h-10 bg-primary-container rounded-xl d-flex items-center justify-center text-white">
                <span class="material-symbols-outlined">menu_book</span>
            </div>
            <div>
                <h1 class="text-title-lg font-bold text-primary">UniLibrary</h1>
                <p class="text-label-sm text-on-surface-variant opacity-70">LMS Portal</p>
            </div>
        </div>
        <nav class="d-flex flex-col flex-1 gap-2">
            <a class="nav-link active" href="#">
                <span class="material-symbols-outlined icon-md" data-icon="dashboard">dashboard</span>
                <span class="text-label-md">Dashboard</span>
            </a>
            <a class="nav-link" href="#">
                <span class="material-symbols-outlined icon-md" data-icon="auto_stories">auto_stories</span>
                <span class="text-label-md">My Loans</span>
            </a>
            <a class="nav-link" href="#">
                <span class="material-symbols-outlined icon-md" data-icon="menu_book">menu_book</span>
                <span class="text-label-md">Catalog</span>
            </a>
            <a class="nav-link" href="#">
                <span class="material-symbols-outlined icon-md" data-icon="person">person</span>
                <span class="text-label-md">Account</span>
            </a>
            <div class="pt-8 pb-4">
                <p class="px-4 text-[10px] font-bold uppercase text-outline mb-2" style="letter-spacing: 0.1em; font-size: 10px;">Management</p>
                <a class="nav-link" href="#" style="padding-top: 8px; padding-bottom: 8px;">
                    <span class="material-symbols-outlined icon-sm">settings_suggest</span>
                    <span class="text-label-md">Manage Books</span>
                </a>
                <a class="nav-link" href="#" style="padding-top: 8px; padding-bottom: 8px;">
                    <span class="material-symbols-outlined icon-sm">category</span>
                    <span class="text-label-md">Categories</span>
                </a>
                <a class="nav-link" href="#" style="padding-top: 8px; padding-bottom: 8px;">
                    <span class="material-symbols-outlined icon-sm">mail</span>
                    <span class="text-label-md">Email Templates</span>
                </a>
            </div>
        </nav>
        <button class="btn btn-primary w-full mt-auto justify-center shadow-lg">
            <span class="material-symbols-outlined icon-sm">search</span>
            Search Books
        </button>
    </aside>

    <!-- Main Content Wrapper -->
    <div class="d-flex flex-col w-full" style="margin-left: 256px;">
        <!-- Top Navigation Bar -->
        <header class="dash-header" style="margin-left: 0; width: 100%;">
            <div class="d-flex items-center gap-4 w-1/3" style="width: 33.333333%;">
                <div class="relative w-full" style="max-width: 24rem;">
                    <span class="material-symbols-outlined absolute left-3 top-1/2 text-outline" style="transform: translateY(-50%);">search</span>
                    <input class="dash-input dash-input-icon-left" placeholder="Global search..." type="text"/>
                </div>
            </div>
            <div class="d-flex items-center gap-6">
                <div class="d-flex items-center gap-4 text-on-surface-variant">
                    <button class="material-symbols-outlined hover-primary icon-md" style="background: none; border: none; cursor: pointer;">notifications</button>
                    <button class="material-symbols-outlined hover-primary icon-md" style="background: none; border: none; cursor: pointer;">help</button>
                </div>
                <div class="h-8 bg-outline-variant" style="width: 1px;"></div>
                <div class="d-flex items-center gap-3 bg-surface-container-high px-3 py-1.5 rounded-full">
                    <div class="d-flex flex-col items-end">
                        <span class="text-label-md text-on-surface" style="line-height: 1;">Alex Rivera</span>
                        <span class="font-bold text-primary" style="font-size: 10px; text-transform: uppercase;">Librarian Manager</span>
                    </div>
                    <img alt="Manager Avatar" class="w-8 h-8 rounded-full object-cover" style="border: 2px solid var(--color-primary);" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBN3f9A2lHooYxfgTRxOgSvElYjOLLD7frT3HX4jdMKb35RY4aCnY91vR9ZQTz5leT1slGYaUdZVLjwr_dKlK9Jwl0IqJXG3YrZt6yfzSbVyZp5Phtg2r3InhTNboCa7hkpA-ssPCzC9p0OmG4bt55uA9fb5vxL8SPhxuk8kOq6IpE1S3XN_nwfij2VGk0lTeTqheWJEI9Tk5lERWSh9bKTnWRv9Iu1btBNE2Hv7L9DSDDfKKLKl9s0xwJWFp6Mm9oBk7_JoIFIKcPW"/>
                </div>
                <!-- Logout Button -->
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline" style="padding: 4px 8px;">
                    <span class="material-symbols-outlined icon-sm">logout</span>
                </a>
            </div>
        </header>

        <!-- Page Canvas -->
        <main class="dash-main" style="margin-left: 0; width: 100%;">
            <div class="dash-container">
                <div class="mb-8 d-flex justify-between items-end">
                    <div>
                        <h2 class="text-headline-lg text-on-surface">Library Dashboard</h2>
                        <p class="text-body-md text-on-surface-variant">Overview of system health, inventory, and finances.</p>
                    </div>
                    <div class="d-flex gap-3">
                        <button class="btn btn-outline bg-surface">
                            <span class="material-symbols-outlined icon-sm">download</span>
                            Export Report
                        </button>
                        <button class="btn btn-primary shadow-md">
                            <span class="material-symbols-outlined icon-sm">add</span>
                            New Entry
                        </button>
                    </div>
                </div>

                <!-- Metrics Row -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-section-gap">
                    <!-- Total Books -->
                    <div class="metric-card border-primary">
                        <div class="d-flex justify-between items-start mb-4">
                            <div class="p-2 bg-primary-container rounded-lg" style="background-color: rgba(249, 115, 22, 0.1);">
                                <span class="material-symbols-outlined text-primary">inventory_2</span>
                            </div>
                            <span class="text-success text-label-sm d-flex items-center">+2.4% <span class="material-symbols-outlined" style="font-size: 14px;">trending_up</span></span>
                        </div>
                        <p class="text-label-md text-on-surface-variant">Total Books</p>
                        <h3 class="font-bold text-on-surface mt-1" style="font-size: 28px;">45,200</h3>
                    </div>
                    <!-- Active Members -->
                    <div class="metric-card border-tertiary">
                        <div class="d-flex justify-between items-start mb-4">
                            <div class="p-2 rounded-lg" style="background-color: rgba(98, 94, 86, 0.1);">
                                <span class="material-symbols-outlined text-tertiary">group</span>
                            </div>
                            <span class="text-success text-label-sm d-flex items-center">+1.2% <span class="material-symbols-outlined" style="font-size: 14px;">trending_up</span></span>
                        </div>
                        <p class="text-label-md text-on-surface-variant">Active Members</p>
                        <h3 class="font-bold text-on-surface mt-1" style="font-size: 28px;">12,400</h3>
                    </div>
                    <!-- Revenue -->
                    <div class="metric-card border-success">
                        <div class="d-flex justify-between items-start mb-4">
                            <div class="p-2 rounded-lg" style="background-color: #f0fdf4;">
                                <span class="material-symbols-outlined text-success">payments</span>
                            </div>
                            <span class="text-success text-label-sm d-flex items-center">+18% <span class="material-symbols-outlined" style="font-size: 14px;">trending_up</span></span>
                        </div>
                        <p class="text-label-md text-on-surface-variant">Fine Revenue (Month)</p>
                        <h3 class="font-bold text-on-surface mt-1" style="font-size: 28px;">$1,250</h3>
                    </div>
                    <!-- Missing Books -->
                    <div class="metric-card border-error">
                        <div class="d-flex justify-between items-start mb-4">
                            <div class="p-2 bg-error-container rounded-lg" style="background-color: rgba(255, 218, 214, 0.2);">
                                <span class="material-symbols-outlined text-error">report_problem</span>
                            </div>
                            <span class="text-error text-label-sm d-flex items-center">Alert <span class="material-symbols-outlined" style="font-size: 14px;">warning</span></span>
                        </div>
                        <p class="text-label-md text-on-surface-variant">Missing/Damaged</p>
                        <h3 class="font-bold text-error mt-1" style="font-size: 28px;">8</h3>
                    </div>
                </div>

                <!-- Bento Content Section -->
                <div class="bento-grid">
                    <!-- Popular Books Section (6 cols) -->
                    <div class="col-span-12 lg:col-span-8 dash-card">
                        <div class="d-flex justify-between items-center mb-6">
                            <h4 class="text-title-lg text-on-surface">Most Borrowed Books</h4>
                            <select class="dash-input" style="width: auto; padding-right: 32px;">
                                <option>This Week</option>
                                <option>This Month</option>
                            </select>
                        </div>
                        <div class="d-flex flex-col gap-6">
                            <!-- Book Item 1 -->
                            <div class="d-flex items-center gap-4">
                                <div class="w-12 h-16 bg-surface-container rounded-lg overflow-hidden flex-shrink-0">
                                    <img alt="Book Cover" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBJmtMw5JmvNih_2QXVKQqi6ZTWcjbwf2g_tcfNoI_RdbwqfvgM8xal3uz4NsX29KiIdHdllI96oEvB0dMoXftc_JBFO9SXgxmzZG6GinvoaYapV7o9A9CKzEftRrVe1G2IYfhSnfF4o2wH6O_FzUJjF2-pjmf4G2uvSfng0EFeFDRy5FO7BJMNq6okUmyvd5U2L_uEVrnLcGBwTibBOM_4R-ap-h69OcV5IzSHBiFK16H0CfsxBQTJxk-oCA0z1ndbtZ4F2IbNmAkI"/>
                                </div>
                                <div class="flex-1" style="min-width: 0;">
                                    <p class="text-label-md text-on-surface" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">Principles of Modern Physics</p>
                                    <p class="text-label-sm text-on-surface-variant">By Dr. Julian Thorne</p>
                                    <div class="mt-2 h-2 bg-surface-container-low rounded-full w-full" style="height: 8px;">
                                        <div class="h-full bg-primary rounded-full" style="width: 85%;"></div>
                                    </div>
                                </div>
                                <span class="font-bold text-on-surface">248 <span class="text-label-sm font-medium text-on-surface-variant">loans</span></span>
                            </div>
                            <!-- Book Item 2 -->
                            <div class="d-flex items-center gap-4">
                                <div class="w-12 h-16 bg-surface-container rounded-lg overflow-hidden flex-shrink-0">
                                    <img alt="Book Cover" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDu89o1UlELjZ0UM0JE3pDl7eNiZLjNw7YrC8Hq1zbAWO5PM2P-9JRjGfr4orM8mjcocGhmdKg81pF5kFxrbMFbSiBqqcwbUX9H7T6wGy6HWSpZ_1JIOpvYYUwWVMEaayEOARPwVmGhUjHMLkSTWxORQwpMj3K9UpHt6tMHTYywVkd2ZzM34kvUNbZEvpHu4NePkb13skkRGvRuGcfXRx4Vxnqr82USxqz5iV654CJ3AfQW15v36nu6ataBHOFwmQCFSzWMMJ9JCag5"/>
                                </div>
                                <div class="flex-1" style="min-width: 0;">
                                    <p class="text-label-md text-on-surface" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">The Art of Architecture</p>
                                    <p class="text-label-sm text-on-surface-variant">By Sarah L. May</p>
                                    <div class="mt-2 h-2 bg-surface-container-low rounded-full w-full" style="height: 8px;">
                                        <div class="h-full bg-primary rounded-full" style="width: 72%;"></div>
                                    </div>
                                </div>
                                <span class="font-bold text-on-surface">210 <span class="text-label-sm font-medium text-on-surface-variant">loans</span></span>
                            </div>
                            <!-- Book Item 3 -->
                            <div class="d-flex items-center gap-4">
                                <div class="w-12 h-16 bg-surface-container rounded-lg overflow-hidden flex-shrink-0">
                                    <img alt="Book Cover" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBqeBo7B5JG17k4BakudAAocBNYWrc-GWTXIA5DW5WIzfkYGO5Mn_dv1IBXmEu9ycjX9ZGTzgAx5iwzG4NTeOkregVvuaXJChVpAzxkhpw-whQMU-1Nyn7_R5UbV__WHzvnsozyoM8I_-1WBCal8wO_wsl1MXJiEEGkCpWk2P7cocydLbEIEUlFLU0Xa6Hz26WuTOEGzrOrtuk1xGZN0v2-4gecLpdOJ331oTG5cqBvvOs6-A3lWs4BS0SUkYWvV5okk6uSXi8-g_M_"/>
                                </div>
                                <div class="flex-1" style="min-width: 0;">
                                    <p class="text-label-md text-on-surface" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">Organic Chemistry III</p>
                                    <p class="text-label-sm text-on-surface-variant">By Prof. Michael Chen</p>
                                    <div class="mt-2 h-2 bg-surface-container-low rounded-full w-full" style="height: 8px;">
                                        <div class="h-full bg-primary rounded-full" style="width: 65%;"></div>
                                    </div>
                                </div>
                                <span class="font-bold text-on-surface">189 <span class="text-label-sm font-medium text-on-surface-variant">loans</span></span>
                            </div>
                            <!-- Book Item 4 -->
                            <div class="d-flex items-center gap-4">
                                <div class="w-12 h-16 bg-surface-container rounded-lg overflow-hidden flex-shrink-0">
                                    <img alt="Book Cover" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDwYG1RksQ_xdg6MPEO10M4gTsQCcvQwzF0MZ6ljcKdvbxre7ZxCKUEKXHt7PbFxYQ5IfSlCiSrueprfB38cj-dhR0WOP8vskVBzDeq-tjPCrC9QRJR3xLfV8i5Yzb3Nqj2xQeYydS4-Sm3JAsSL0SZKoOhoI8FXqNRPYJ--V_JmSp7dS_2CZ2oSgMP4y-N_QOHILN9nfkYMQtwnVz_bfx64JzynzWprCs4vcbqYaRYnbMJd0sCKCrV5yWlE7A8WeKPiY0zNbC5iBtq"/>
                                </div>
                                <div class="flex-1" style="min-width: 0;">
                                    <p class="text-label-md text-on-surface" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">Economic Foundations</p>
                                    <p class="text-label-sm text-on-surface-variant">By Dr. Elena Vance</p>
                                    <div class="mt-2 h-2 bg-surface-container-low rounded-full w-full" style="height: 8px;">
                                        <div class="h-full bg-primary rounded-full" style="width: 58%;"></div>
                                    </div>
                                </div>
                                <span class="font-bold text-on-surface">172 <span class="text-label-sm font-medium text-on-surface-variant">loans</span></span>
                            </div>
                        </div>
                    </div>

                    <!-- Inventory Alerts (4 cols) -->
                    <div class="col-span-12 lg:col-span-4 d-flex flex-col gap-6">
                        <div class="dash-card">
                            <div class="d-flex items-center gap-2 mb-4">
                                <span class="material-symbols-outlined text-primary">notification_important</span>
                                <h4 class="text-title-lg text-on-surface">Inventory Alerts</h4>
                            </div>
                            <p class="text-label-sm text-on-surface-variant mb-4 font-medium">The following items are running low.</p>
                            <ul class="d-flex flex-col gap-4" style="list-style: none; padding: 0;">
                                <li class="d-flex justify-between items-center p-3 rounded-xl border border-error-container" style="background-color: rgba(255, 218, 214, 0.1);">
                                    <div>
                                        <p class="text-label-md text-on-surface" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 140px;">Data Structures 101</p>
                                        <span class="text-label-sm text-error font-medium">1 copy left</span>
                                    </div>
                                    <button class="btn btn-ghost" style="padding: 8px;">
                                        <span class="material-symbols-outlined">add_shopping_cart</span>
                                    </button>
                                </li>
                                <li class="d-flex justify-between items-center p-3 rounded-xl border border-error-container" style="background-color: rgba(255, 218, 214, 0.1);">
                                    <div>
                                        <p class="text-label-md text-on-surface" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 140px;">Modern Sociology</p>
                                        <span class="text-label-sm text-error font-medium">Out of Stock</span>
                                    </div>
                                    <button class="btn btn-ghost" style="padding: 8px;">
                                        <span class="material-symbols-outlined">add_shopping_cart</span>
                                    </button>
                                </li>
                                <li class="d-flex justify-between items-center p-3 rounded-xl border" style="background-color: rgba(253, 214, 169, 0.1); border-color: rgba(253, 214, 169, 0.1);">
                                    <div>
                                        <p class="text-label-md text-on-surface" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 140px;">Linear Algebra II</p>
                                        <span class="text-label-sm text-secondary font-medium">2 copies left</span>
                                    </div>
                                    <button class="btn btn-ghost" style="padding: 8px;">
                                        <span class="material-symbols-outlined">add_shopping_cart</span>
                                    </button>
                                </li>
                            </ul>
                        </div>
                        <!-- Manage Highlights -->
                        <div class="bg-surface-container p-6 rounded-2xl">
                            <h4 class="text-title-lg text-on-primary-container mb-4">Quick Insights</h4>
                            <div class="d-flex flex-col gap-3">
                                <div class="p-4 rounded-xl d-flex items-center gap-3" style="background-color: rgba(255,255,255,0.5);">
                                    <span class="material-symbols-outlined text-primary">schedule</span>
                                    <div>
                                        <p class="font-bold uppercase text-on-surface-variant" style="font-size: 10px;">Peak Hours</p>
                                        <p class="text-label-md">11:00 AM - 2:00 PM</p>
                                    </div>
                                </div>
                                <div class="p-4 rounded-xl d-flex items-center gap-3" style="background-color: rgba(255,255,255,0.5);">
                                    <span class="material-symbols-outlined text-tertiary">star</span>
                                    <div>
                                        <p class="font-bold uppercase text-on-surface-variant" style="font-size: 10px;">Top Department</p>
                                        <p class="text-label-md">Computer Science</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Payments Table (12 cols) -->
                    <div class="col-span-12 dash-card" style="padding: 0; overflow: hidden;">
                        <div class="px-6 py-4 border-b border-surface-container-highest d-flex justify-between items-center">
                            <h4 class="text-title-lg text-on-surface">Recent Fine Payments</h4>
                            <button class="btn btn-ghost" style="padding: 0;">View All Transactions</button>
                        </div>
                        <div class="dash-table-container custom-scrollbar">
                            <table class="dash-table" style="margin-bottom: 0;">
                                <thead class="bg-surface-container-low">
                                    <tr>
                                        <th class="px-6 py-3 text-label-md text-on-surface-variant" style="text-transform: none;">Member Name</th>
                                        <th class="px-6 py-3 text-label-md text-on-surface-variant" style="text-transform: none;">Payment Method</th>
                                        <th class="px-6 py-3 text-label-md text-on-surface-variant" style="text-transform: none;">Amount</th>
                                        <th class="px-6 py-3 text-label-md text-on-surface-variant" style="text-transform: none;">Date</th>
                                        <th class="px-6 py-3 text-label-md text-on-surface-variant" style="text-transform: none; text-align: right;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="px-6 py-4">
                                            <div class="d-flex items-center gap-3">
                                                <div class="w-8 h-8 rounded-full bg-secondary-container d-flex items-center justify-center text-on-secondary-container font-bold text-label-sm">JD</div>
                                                <div>
                                                    <p class="text-label-md text-on-surface">John Doe</p>
                                                    <p class="text-label-sm text-on-surface-variant font-medium">ID: 2023-4552</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <span class="badge badge-info">Card</span>
                                        </td>
                                        <td class="px-6 py-4 text-label-md font-bold text-on-surface">$12.50</td>
                                        <td class="px-6 py-4 text-body-md text-on-surface-variant">Oct 24, 2023</td>
                                        <td class="px-6 py-4 text-right">
                                            <button class="material-symbols-outlined text-outline hover-primary" style="background: none; border: none; cursor: pointer;">more_vert</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="px-6 py-4">
                                            <div class="d-flex items-center gap-3">
                                                <div class="w-8 h-8 rounded-full d-flex items-center justify-center text-primary font-bold text-label-sm" style="background-color: rgba(249, 115, 22, 0.2);">AS</div>
                                                <div>
                                                    <p class="text-label-md text-on-surface">Anya Smith</p>
                                                    <p class="text-label-sm text-on-surface-variant font-medium">ID: 2021-9921</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <span class="badge badge-primary" style="background-color: rgba(249, 115, 22, 0.1); color: var(--color-primary);">Cash</span>
                                        </td>
                                        <td class="px-6 py-4 text-label-md font-bold text-on-surface">$5.00</td>
                                        <td class="px-6 py-4 text-body-md text-on-surface-variant">Oct 23, 2023</td>
                                        <td class="px-6 py-4 text-right">
                                            <button class="material-symbols-outlined text-outline hover-primary" style="background: none; border: none; cursor: pointer;">more_vert</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="px-6 py-4">
                                            <div class="d-flex items-center gap-3">
                                                <div class="w-8 h-8 rounded-full bg-secondary d-flex items-center justify-center text-white font-bold text-label-sm">RK</div>
                                                <div>
                                                    <p class="text-label-md text-on-surface">Robert King</p>
                                                    <p class="text-label-sm text-on-surface-variant font-medium">ID: 2024-0012</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <span class="badge badge-info">Card</span>
                                        </td>
                                        <td class="px-6 py-4 text-label-md font-bold text-on-surface">$22.10</td>
                                        <td class="px-6 py-4 text-body-md text-on-surface-variant">Oct 23, 2023</td>
                                        <td class="px-6 py-4 text-right">
                                            <button class="material-symbols-outlined text-outline hover-primary" style="background: none; border: none; cursor: pointer;">more_vert</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        
        <!-- Subtle Overlay Pattern Background (CSS only) -->
        <div class="fixed inset-0 pointer-events-none opacity-[0.03] z-[-1]" style="background-image: radial-gradient(#F97316 0.5px, transparent 0.5px); background-size: 24px 24px; opacity: 0.03; z-index: -1;"></div>
    </div>

    <!-- Script for interactive elements (Atmospheric micro-interactions) -->
    <script>
        document.querySelectorAll('.bento-grid > div').forEach(card => {
            card.addEventListener('mouseenter', () => {
                card.style.transform = 'translateY(-2px)';
                card.style.transition = 'all 0.3s ease';
            });
            card.addEventListener('mouseleave', () => {
                card.style.transform = 'translateY(0px)';
            });
        });
    </script>
</body>
</html>
