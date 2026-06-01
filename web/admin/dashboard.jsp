<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>UniLibrary System Admin Dashboard</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css" />
    <style>
        .glass-card { background: rgba(255, 255, 255, 0.8); backdrop-filter: blur(12px); }
    </style>
</head>
<body class="dash-body">
    <!-- SideNavBar Shell -->
    <aside class="dash-sidebar">
        <div class="mb-10">
            <h1 class="text-title-lg font-bold text-primary">UniLibrary</h1>
            <p class="text-label-sm text-on-surface-variant">LMS Portal</p>
        </div>
        <nav class="d-flex flex-col flex-1 gap-2">
            <a class="nav-link active" href="#">
                <span class="material-symbols-outlined icon-md">dashboard</span>
                <span class="text-label-md">Dashboard</span>
            </a>
            <a class="nav-link" href="#">
                <span class="material-symbols-outlined icon-md">person</span>
                <span class="text-label-md">User Management</span>
            </a>
            <a class="nav-link" href="#">
                <span class="material-symbols-outlined icon-md">settings</span>
                <span class="text-label-md">System Config</span>
            </a>
            <a class="nav-link" href="#">
                <span class="material-symbols-outlined icon-md">history</span>
                <span class="text-label-md">Audit Logs</span>
            </a>
        </nav>
        <div class="mt-auto border-t border-outline-variant py-4">
            <button class="btn btn-primary w-full bg-primary-container text-on-primary">
                <span class="material-symbols-outlined icon-sm">search</span>
                Search Books
            </button>
        </div>
    </aside>

    <!-- TopNavBar Shell -->
    <header class="dash-header">
        <div class="d-flex items-center gap-4">
            <h2 class="text-title-lg font-bold text-primary">System Admin</h2>
        </div>
        <div class="d-flex items-center gap-6">
            <div class="relative group d-flex items-center">
                <span class="material-symbols-outlined text-on-surface-variant hover-primary icon-md" style="cursor: pointer;">notifications</span>
                <span class="absolute top-0 right-0 w-8 h-8 bg-error rounded-full" style="width: 8px; height: 8px; right: -4px; top: -4px;"></span>
            </div>
            <span class="material-symbols-outlined text-on-surface-variant hover-primary icon-md" style="cursor: pointer;">help</span>
            <div class="d-flex items-center gap-3 ml-4 bg-surface-container px-3 py-1.5 rounded-full border border-outline-variant">
                <img alt="Admin Avatar" class="w-8 h-8 rounded-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBC0uyvVtQR7ZdDpAUD00R5_qDcEH47UXvo45rCDCf0sEnjMrui4FHQOJG2Ihr551R0qN4zU4LpqDFId_59TgeF8X29eIDl5zcYfXuR6yzm1zGmPBUMVoA-DEn3vkIBbXYhUksTD73feQRhiQBAxPseFpP5yNk8AVoVTdvI7WlLNk3lFwXm0eJCAXSEnIRucTNpk2vYf0Xv9j5D9ajcY8126aUlYTtxupQLP9-GCquwdwGFt-n-BmoGgd2nTR9Gr_nkwYK9ncUJpYxd"/>
                <span class="text-label-md text-on-surface">System Admin</span>
            </div>
            <!-- Logout Button -->
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline" style="padding: 4px 8px;">
                <span class="material-symbols-outlined icon-sm">logout</span>
            </a>
        </div>
    </header>

    <!-- Main Content Canvas -->
    <main class="dash-main">
        <div class="dash-container">
            <!-- Header Section -->
            <div class="mb-gutter">
                <h3 class="text-headline-lg text-on-surface">System Overview</h3>
                <p class="text-body-md text-on-surface-variant mt-1">Real-time infrastructure and security monitoring.</p>
            </div>

            <!-- Metrics Row (Bento Style) -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-gutter mb-section-gap">
                <!-- Total Users -->
                <div class="metric-card border-primary">
                    <div class="d-flex justify-between items-start mb-4">
                        <span class="material-symbols-outlined text-primary bg-primary-fixed p-2 rounded-xl">group</span>
                        <span class="text-label-sm text-on-surface-variant bg-surface-container-high px-2 py-1 rounded-md badge">Live</span>
                    </div>
                    <p class="text-label-md text-on-surface-variant">Total System Users</p>
                    <div class="d-flex items-center gap-2 mt-1 items-end">
                        <h4 class="text-headline-md text-on-surface">12,050</h4>
                        <span class="text-label-sm text-error">/ 45 Locked</span>
                    </div>
                </div>
                <!-- Failed Logins -->
                <div class="metric-card border-error">
                    <div class="d-flex justify-between items-start mb-4">
                        <span class="material-symbols-outlined text-error bg-error-container p-2 rounded-xl">shield_lock</span>
                        <span class="material-symbols-outlined text-error icon-sm">warning</span>
                    </div>
                    <p class="text-label-md text-on-surface-variant">Failed Login Attempts</p>
                    <h4 class="text-headline-md text-error mt-1">12</h4>
                </div>
                <!-- System Errors -->
                <div class="metric-card border-secondary">
                    <div class="d-flex justify-between items-start mb-4">
                        <span class="material-symbols-outlined text-secondary bg-secondary-container p-2 rounded-xl">bug_report</span>
                    </div>
                    <p class="text-label-md text-on-surface-variant">System Errors</p>
                    <div class="d-flex items-center gap-2 mt-1 items-end">
                        <h4 class="text-headline-md text-on-surface">3</h4>
                        <span class="text-label-sm text-on-surface-variant">today</span>
                    </div>
                </div>
                <!-- Audit Logs -->
                <div class="metric-card border-success">
                    <div class="d-flex justify-between items-start mb-4">
                        <span class="material-symbols-outlined text-success bg-secondary-container p-2 rounded-xl" style="background-color: #dcfce7;">database</span>
                    </div>
                    <p class="text-label-md text-on-surface-variant">Audit Logs Generated</p>
                    <h4 class="text-headline-md text-on-surface mt-1">1,200</h4>
                </div>
            </div>

            <!-- Asymmetric Main Area -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-gutter">
                <!-- Recent Audit Logs (Left Wide) -->
                <div class="lg:col-span-8 dash-card">
                    <div class="d-flex justify-between items-center mb-6">
                        <h5 class="text-title-lg text-on-surface">Recent Audit Logs</h5>
                        <button class="btn btn-ghost" style="padding: 0;">View All Logs</button>
                    </div>
                    <div class="dash-table-container">
                        <table class="dash-table">
                            <thead>
                                <tr>
                                    <th>Timestamp</th>
                                    <th>User</th>
                                    <th>Action Type</th>
                                    <th>Entity Name</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>14:23:05</td>
                                    <td class="font-semibold">Admin_Sarah</td>
                                    <td>
                                        <span class="badge badge-info">CREATE</span>
                                    </td>
                                    <td class="text-on-surface-variant">New Library Branch - North</td>
                                </tr>
                                <tr>
                                    <td>14:15:22</td>
                                    <td class="font-semibold">Librarian_John</td>
                                    <td>
                                        <span class="badge badge-warning">UPDATE</span>
                                    </td>
                                    <td class="text-on-surface-variant">Book Meta ID #9982</td>
                                </tr>
                                <tr>
                                    <td>13:58:10</td>
                                    <td class="font-semibold">Admin_Sarah</td>
                                    <td>
                                        <span class="badge badge-error">DELETE</span>
                                    </td>
                                    <td class="text-on-surface-variant">Expired Guest Account</td>
                                </tr>
                                <tr>
                                    <td>13:45:30</td>
                                    <td class="font-semibold">System_Core</td>
                                    <td>
                                        <span class="badge badge-info">CREATE</span>
                                    </td>
                                    <td class="text-on-surface-variant">Auto-Backup Snapshot</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Locked Accounts (Right Narrow) -->
                <div class="lg:col-span-4 d-flex flex-col gap-gutter">
                    <div class="dash-card">
                        <div class="d-flex items-center justify-between mb-6">
                            <h5 class="text-title-lg text-on-surface">Locked Accounts</h5>
                            <span class="badge badge-error">45 Total</span>
                        </div>
                        <div class="d-flex flex-col gap-4">
                            <!-- Locked Item 1 -->
                            <div class="d-flex items-center justify-between p-3 rounded-xl bg-surface-container-low border border-surface-container">
                                <div class="d-flex items-center gap-3">
                                    <div class="w-10 h-10 bg-error-container rounded-full d-flex items-center justify-center text-error">
                                        <span class="material-symbols-outlined icon-sm">lock</span>
                                    </div>
                                    <div>
                                        <p class="text-label-md text-on-surface">m.chen_24</p>
                                        <p class="text-label-sm text-on-surface-variant font-medium">Brute force detected</p>
                                    </div>
                                </div>
                                <button class="btn btn-primary" style="padding: 6px 12px; font-size: 12px;">Unlock</button>
                            </div>
                            <!-- Locked Item 2 -->
                            <div class="d-flex items-center justify-between p-3 rounded-xl bg-surface-container-low border border-surface-container">
                                <div class="d-flex items-center gap-3">
                                    <div class="w-10 h-10 bg-error-container rounded-full d-flex items-center justify-center text-error">
                                        <span class="material-symbols-outlined icon-sm">lock</span>
                                    </div>
                                    <div>
                                        <p class="text-label-md text-on-surface">j.doe_staff</p>
                                        <p class="text-label-sm text-on-surface-variant font-medium">Manual lock applied</p>
                                    </div>
                                </div>
                                <button class="btn btn-primary" style="padding: 6px 12px; font-size: 12px;">Unlock</button>
                            </div>
                            <!-- Locked Item 3 -->
                            <div class="d-flex items-center justify-between p-3 rounded-xl bg-surface-container-low border border-surface-container">
                                <div class="d-flex items-center gap-3">
                                    <div class="w-10 h-10 bg-error-container rounded-full d-flex items-center justify-center text-error">
                                        <span class="material-symbols-outlined icon-sm">lock</span>
                                    </div>
                                    <div>
                                        <p class="text-label-md text-on-surface">a.nguyen_stu</p>
                                        <p class="text-label-sm text-on-surface-variant font-medium">Dormant &gt; 90 days</p>
                                    </div>
                                </div>
                                <button class="btn btn-primary" style="padding: 6px 12px; font-size: 12px;">Unlock</button>
                            </div>
                        </div>
                        <button class="btn btn-outline w-full mt-6 justify-center bg-surface-container-low">
                            Manage All Security Locks
                        </button>
                    </div>

                    <!-- Decorative/Info Card -->
                    <div class="bg-primary p-6 rounded-2xl relative overflow-hidden text-on-primary shadow-lg" style="margin-top: 24px;">
                        <div class="relative z-10">
                            <h6 class="text-title-lg mb-2">System Status</h6>
                            <p class="text-body-md opacity-90 mb-4">All core clusters are healthy. Next maintenance scheduled for Sunday at 02:00 AM.</p>
                            <div class="d-flex items-center gap-2 text-label-sm badge" style="background-color: rgba(255,255,255,0.2);">
                                <span class="w-8 h-8 rounded-full" style="width: 8px; height: 8px; background-color: #4ade80;"></span>
                                Core Uptime: 99.98%
                            </div>
                        </div>
                        <div class="absolute inset-0" style="background: radial-gradient(circle at right bottom, rgba(255,255,255,0.2) 0%, transparent 60%);"></div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Success Toast Mockup -->
    <div class="fixed dash-card border-l-4" style="border-left-color: #22c55e; bottom: 40px; right: 40px; transform: translateY(100px); opacity: 0; transition: all 0.5s;" id="toast">
        <div class="d-flex items-center gap-4">
            <span class="material-symbols-outlined text-success">check_circle</span>
            <div>
                <p class="text-label-md text-on-surface">Account Unlocked</p>
                <p class="text-label-sm text-on-surface-variant">User m.chen_24 has been notified.</p>
            </div>
        </div>
    </div>

    <script>
        // Micro-interactions for buttons
        document.querySelectorAll('button').forEach(btn => {
            if (btn.innerText === 'Unlock') {
                btn.onclick = function() {
                    const toast = document.getElementById('toast');
                    toast.style.transform = 'translateY(0)';
                    toast.style.opacity = '1';
                    
                    btn.innerText = 'Processing...';
                    btn.disabled = true;
                    btn.style.opacity = '0.5';

                    setTimeout(() => {
                        toast.style.transform = 'translateY(100px)';
                        toast.style.opacity = '0';
                        btn.closest('.d-flex.items-center.justify-between').style.opacity = '0.4';
                        btn.innerText = 'Done';
                    }, 3000);
                };
            }
        });

        // Hover lift for metric cards
        document.querySelectorAll('.metric-card').forEach(card => {
            card.addEventListener('mouseenter', () => {
                card.style.transform = 'translateY(-4px)';
                card.style.transition = 'all 0.2s ease-out';
            });
            card.addEventListener('mouseleave', () => {
                card.style.transform = 'translateY(0)';
            });
        });
    </script>
</body>
</html>
