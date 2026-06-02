<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>UniLibrary System Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" />
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-brand">
            <h1>UniLibrary</h1>
            <p>LMS Portal</p>
        </div>
        <nav class="nav-menu">
            <a class="nav-item active" href="${pageContext.request.contextPath}/admin/dashboard">
                <span class="material-symbols-outlined">dashboard</span>
                <span>Dashboard</span>
            </a>
            <a class="nav-item" href="${pageContext.request.contextPath}/admin/users">
                <span class="material-symbols-outlined">person</span>
                <span>User Management</span>
            </a>
            <a class="nav-item" href="${pageContext.request.contextPath}/admin/config">
                <span class="material-symbols-outlined">settings</span>
                <span>System Config</span>
            </a>
            <a class="nav-item" href="${pageContext.request.contextPath}/admin/logs">
                <span class="material-symbols-outlined">history</span>
                <span>Audit Logs</span>
            </a>
        </nav>
        <div class="sidebar-footer">
            <button class="btn-search">
                <span class="material-symbols-outlined" style="font-size: 20px;">search</span>
                Search Books
            </button>
        </div>
    </aside>

    <header class="main-header">
        <div>
            <h2 class="header-title">System Admin</h2>
        </div>
        <div class="header-actions">
            <div class="notification-bell">
                <span class="material-symbols-outlined">notifications</span>
                <span class="notification-badge"></span>
            </div>
            <span class="material-symbols-outlined header-icon">help</span>
            <div class="profile-pill">
                <img alt="Admin Avatar" class="profile-avatar" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBC0uyvVtQR7ZdDpAUD00R5_qDcEH47UXvo45rCDCf0sEnjMrui4FHQOJG2Ihr551R0qN4zU4LpqDFId_59TgeF8X29eIDl5zcYfXuR6yzm1zGmPBUMVoA-DEn3vkIBbXYhUksTD73feQRhiQBAxPseFpP5yNk8AVoVTdvI7WlLNk3lFwXm0eJCAXSEnIRucTNpk2vYf0Xv9j5D9ajcY8126aUlYTtxupQLP9-GCquwdwGFt-n-BmoGgd2nTR9Gr_nkwYK9ncUJpYxd"/>
                <span class="profile-role">System Admin</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn" title="Logout">
                <span class="material-symbols-outlined">logout</span>
            </a>
        </div>
    </header>

    <main class="main-content">
        <div class="container-max">
            
            <div class="page-header">
                <h3>System Overview</h3>
                <p>Real-time infrastructure and security monitoring.</p>
            </div>

            <div class="metrics-grid">
                <div class="metric-card primary">
                    <div class="card-top">
                        <span class="material-symbols-outlined card-icon">group</span>
                        <span class="card-status-tag">Live</span>
                    </div>
                    <p class="card-label">Total System Users</p>
                    <div class="card-meta-holder">
                        <h4 class="card-value">12,050</h4>
                        <span class="card-subtext danger">/ 45 Locked</span>
                    </div>
                </div>
                <div class="metric-card error">
                    <div class="card-top">
                        <span class="material-symbols-outlined card-icon">shield_lock</span>
                        <span class="material-symbols-outlined card-subtext danger">warning</span>
                    </div>
                    <p class="card-label">Failed Login Attempts</p>
                    <h4 class="card-value error-text">12</h4>
                </div>
                <div class="metric-card secondary">
                    <div class="card-top">
                        <span class="material-symbols-outlined card-icon">bug_report</span>
                    </div>
                    <p class="card-label">System Errors</p>
                    <div class="card-meta-holder">
                        <h4 class="card-value">3</h4>
                        <span class="card-subtext">today</span>
                    </div>
                </div>
                <div class="metric-card tertiary">
                    <div class="card-top">
                        <span class="material-symbols-outlined card-icon">database</span>
                    </div>
                    <p class="card-label">Audit Logs Generated</p>
                    <h4 class="card-value">1,200</h4>
                </div>
            </div>

            <div class="asymmetric-grid">
                
                <div class="col-wide content-panel">
                    <div class="panel-top">
                        <h5>Recent Audit Logs</h5>
                        <button class="panel-btn-link">View All Logs</button>
                    </div>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Timestamp</th>
                                    <th>User</th>
                                    <th>Action Type</th>
                                    <th>Entity Name</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${mockList}" var="item">
                                    <tr>
                                        <td>${item.timestamp}</td>
                                        <td class="user-cell">${item.user}</td>
                                        <td><span class="badge ${item.action.toLowerCase()}">${item.action}</span></td>
                                        <td class="entity-cell">${item.entity}</td>
                                    </tr>
                                </c:forEach>
                                <!-- Static Fallback when mockList is empty -->
                                <c:if test="${empty mockList}">
                                    <tr>
                                        <td>14:23:05</td>
                                        <td class="user-cell">Admin_Sarah</td>
                                        <td><span class="badge create">CREATE</span></td>
                                        <td class="entity-cell">New Library Branch - North</td>
                                    </tr>
                                    <tr>
                                        <td>14:15:22</td>
                                        <td class="user-cell">Librarian_John</td>
                                        <td><span class="badge update">UPDATE</span></td>
                                        <td class="entity-cell">Book Meta ID #9982</td>
                                    </tr>
                                    <tr>
                                        <td>13:58:10</td>
                                        <td class="user-cell">Admin_Sarah</td>
                                        <td><span class="badge delete">DELETE</span></td>
                                        <td class="entity-cell">Expired Guest Account</td>
                                    </tr>
                                    <tr>
                                        <td>13:45:30</td>
                                        <td class="user-cell">System_Core</td>
                                        <td><span class="badge create">CREATE</span></td>
                                        <td class="entity-cell">Auto-Backup Snapshot</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="col-narrow">
                    <div class="content-panel">
                        <div class="panel-top">
                            <h5>Locked Accounts</h5>
                            <span class="badge-count">45 Total</span>
                        </div>
                        <div class="account-stack">
                            <div class="account-item">
                                <div class="account-profile">
                                    <div class="lock-icon-box">
                                        <span class="material-symbols-outlined" style="font-size: 20px;">lock</span>
                                    </div>
                                    <div>
                                        <p class="account-name">m.chen_24</p>
                                        <p class="account-reason">Brute force detected</p>
                                    </div>
                                </div>
                                <button class="btn-unlock">Unlock</button>
                            </div>
                            <div class="account-item">
                                <div class="account-profile">
                                    <div class="lock-icon-box">
                                        <span class="material-symbols-outlined" style="font-size: 20px;">lock</span>
                                    </div>
                                    <div>
                                        <p class="account-name">j.doe_staff</p>
                                        <p class="account-reason">Manual lock applied</p>
                                    </div>
                                </div>
                                <button class="btn-unlock">Unlock</button>
                            </div>
                            <div class="account-item">
                                <div class="account-profile">
                                    <div class="lock-icon-box">
                                        <span class="material-symbols-outlined" style="font-size: 20px;">lock</span>
                                    </div>
                                    <div>
                                        <p class="account-name">a.nguyen_stu</p>
                                        <p class="account-reason">Dormant &gt; 90 days</p>
                                    </div>
                                </div>
                                <button class="btn-unlock">Unlock</button>
                            </div>
                        </div>
                        <button class="btn-panel-action">Manage All Security Locks</button>
                    </div>

                    <div class="status-banner">
                        <div class="status-banner-content">
                            <h6>System Status</h6>
                            <p>All core clusters are healthy. Next maintenance scheduled for Sunday at 02:00 AM.</p>
                            <div class="status-pill-live">
                                <span class="pulse-dot"></span>
                                Core Uptime: 99.98%
                            </div>
                        </div>
                        <div class="decorative-blur"></div>
                    </div>
                </div>

            </div>
        </div>
    </main>

    <div class="toast" id="toast">
        <span class="material-symbols-outlined toast-icon">check_circle</span>
        <div>
            <p class="toast-content-title">Account Unlocked</p>
            <p class="toast-content-desc">User has been notified successfully.</p>
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
                        toast.style.transform = 'translateY(20px)';
                        toast.style.opacity = '0';
                        
                        const item = btn.closest('.account-item');
                        if(item) item.style.opacity = '0.4';
                        btn.innerText = 'Done';
                    }, 3000);
                };
            }
        });

        // Hover lift for metric cards
        document.querySelectorAll('.metric-card').forEach(card => {
            card.style.transition = 'transform 0.2s ease-out, box-shadow 0.2s ease-out';
            card.addEventListener('mouseenter', () => {
                card.style.transform = 'translateY(-4px)';
            });
            card.addEventListener('mouseleave', () => {
                card.style.transform = 'translateY(0)';
            });
        });
    </script>
</body>
</html>
