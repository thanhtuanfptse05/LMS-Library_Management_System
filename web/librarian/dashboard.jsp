<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Academic Nexus - Librarian Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/librarian-dashboard.css" />
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-brand">
            <h1>UniLibrary</h1>
            <p>LMS Portal</p>
        </div>
        <nav class="sidebar-nav">
            <a class="nav-item active" href="${pageContext.request.contextPath}/librarian/dashboard">
                <span class="material-symbols-outlined">dashboard</span>
                <span>Dashboard</span>
            </a>
            <a class="nav-item" href="#">
                <span class="material-symbols-outlined">auto_stories</span>
                <span>My Loans</span>
            </a>
            <a class="nav-item" href="#">
                <span class="material-symbols-outlined">menu_book</span>
                <span>Catalog</span>
            </a>
            <a class="nav-item" href="#">
                <span class="material-symbols-outlined">person</span>
                <span>Account</span>
            </a>
        </nav>
        <div class="sidebar-footer">
            <button class="btn-search">
                <span class="material-symbols-outlined">search</span>
                Search Books
            </button>
        </div>
    </aside>

    <header class="header">
        <div>
            <span class="header-title">Library Management System</span>
        </div>
        <div class="header-actions">
            <div class="badge-librarian">
                <span class="material-symbols-outlined" style="font-size:18px;">shield_person</span>
                <span>Librarian</span>
            </div>
            <div class="icon-btn-group">
                <button class="icon-btn">
                    <span class="material-symbols-outlined">notifications</span>
                </button>
                <button class="icon-btn">
                    <span class="material-symbols-outlined">help</span>
                </button>
            </div>
            <img alt="User Profile" class="profile-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuD5VRrad2RbKAU58gvnSjPgYAZD5KmF00CcsYiD74d-QLCGjPPF3V6jIYriy7t23xGVsP3FzRMWZ9L-5lHiJciEG925mlByE1YKxnkliQH-Fpvoj3EI9ybuNoG5d6XhHFQVXIsC9sVyYGFWztGtw-bTHkdeXok7qW3EDaUA0J7rL7isR2Kt9q1g7LCzm3m2vOBBZgeT4qxhRd0-Hj4oYMa7IM79Uh84NulmZ8WwJY1z3B2XjXd6-9OfklAYfAA0utiELofinOAtAy64"/>
            <!-- Logout Button -->
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                <span class="material-symbols-outlined">logout</span>
            </a>
        </div>
    </header>

    <main class="main-content">
        <section class="quick-actions">
            <button class="btn-action">
                <span class="material-symbols-outlined" style="font-size:40px;">barcode_scanner</span>
                <span class="text-headline-md">Scan Barcode to Checkout</span>
            </button>
            <button class="btn-action">
                <span class="material-symbols-outlined" style="font-size:40px;">keyboard_return</span>
                <span class="text-headline-md">Scan Barcode to Return</span>
            </button>
            <button class="btn-action">
                <span class="material-symbols-outlined" style="font-size:40px;">person_add</span>
                <span class="text-headline-md">Register New Member</span>
            </button>
        </section>

        <section class="metrics-grid">
            <div class="metric-card primary">
                <p class="metric-label">Books Checked Out Today</p>
                <h3 class="metric-value primary">142</h3>
            </div>
            <div class="metric-card secondary">
                <p class="metric-label">Books Returned Today</p>
                <h3 class="metric-value secondary">98</h3>
            </div>
            <div class="metric-card tertiary">
                <p class="metric-label">Pending Reservations</p>
                <h3 class="metric-value tertiary">15</h3>
            </div>
            <div class="metric-card error">
                <p class="metric-label">Members Overdue</p>
                <h3 class="metric-value error">24</h3>
            </div>
        </section>

        <div class="content-grid">
            <section class="panel col-wide">
                <div class="panel-header">
                    <h2 class="panel-title">Today's Transactions</h2>
                    <button class="btn-link">
                        View All <span class="material-symbols-outlined" style="font-size:18px;">chevron_right</span>
                    </button>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Book Barcode</th>
                                <th>Action</th>
                                <th>Time</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>U-2023-4412</td>
                                <td>978-3-16-148410-0</td>
                                <td><span class="badge-borrow">Borrow</span></td>
                                <td>09:45 AM</td>
                                <td class="status-success">Success</td>
                            </tr>
                            <tr>
                                <td>U-2023-8821</td>
                                <td>978-0-26-203384-8</td>
                                <td><span class="badge-return">Return</span></td>
                                <td>10:12 AM</td>
                                <td class="status-success">Success</td>
                            </tr>
                            <tr>
                                <td>U-2024-1029</td>
                                <td>978-1-11-853164-8</td>
                                <td><span class="badge-borrow">Borrow</span></td>
                                <td>10:30 AM</td>
                                <td class="status-pending">Pending</td>
                            </tr>
                            <tr>
                                <td>U-2023-3390</td>
                                <td>978-0-13-235088-4</td>
                                <td><span class="badge-return">Return</span></td>
                                <td>10:48 AM</td>
                                <td class="status-success">Success</td>
                            </tr>
                            <tr>
                                <td>U-2022-7715</td>
                                <td>978-0-59-600712-6</td>
                                <td><span class="badge-borrow">Borrow</span></td>
                                <td>11:05 AM</td>
                                <td class="status-success">Success</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="panel col-narrow">
                <div class="panel-header">
                    <h2 class="panel-title">Overdue Alerts</h2>
                </div>
                <div class="alerts-container">
                    <div class="alert-card">
                        <div class="alert-header">
                            <div class="alert-user">
                                <h4>Alex Johnston</h4>
                                <p>3 days overdue</p>
                            </div>
                            <span class="alert-fine">-$15.00</span>
                        </div>
                        <div class="alert-actions">
                            <button class="btn-alert-action">
                                <span class="material-symbols-outlined" style="font-size:16px;">mail</span> Email
                            </button>
                            <button class="btn-alert-action">
                                <span class="material-symbols-outlined" style="font-size:16px;">phone</span> Phone
                            </button>
                        </div>
                    </div>
                    <div class="alert-card">
                        <div class="alert-header">
                            <div class="alert-user">
                                <h4>Sarah Miller</h4>
                                <p>7 days overdue</p>
                            </div>
                            <span class="alert-fine">-$35.00</span>
                        </div>
                        <div class="alert-actions">
                            <button class="btn-alert-action">
                                <span class="material-symbols-outlined" style="font-size:16px;">mail</span> Email
                            </button>
                            <button class="btn-alert-action">
                                <span class="material-symbols-outlined" style="font-size:16px;">phone</span> Phone
                            </button>
                        </div>
                    </div>
                    <div class="alert-card">
                        <div class="alert-header">
                            <div class="alert-user">
                                <h4>Michael Chen</h4>
                                <p>1 day overdue</p>
                            </div>
                            <span class="alert-fine">-$5.00</span>
                        </div>
                        <div class="alert-actions">
                            <button class="btn-alert-action">
                                <span class="material-symbols-outlined" style="font-size:16px;">mail</span> Email
                            </button>
                            <button class="btn-alert-action">
                                <span class="material-symbols-outlined" style="font-size:16px;">phone</span> Phone
                            </button>
                        </div>
                    </div>
                    <button class="btn-view-all-alerts">
                        View All Alerts (24)
                    </button>
                </div>
            </section>
        </div>
    </main>

    <div class="toast translate-y-20 opacity-0" id="toast">
        <div class="toast-icon-wrapper">
            <span class="material-symbols-outlined">check_circle</span>
        </div>
        <div class="toast-content">
            <h4>Scan Successful</h4>
            <p>Book has been checked out to U-2023-4412.</p>
        </div>
    </div>

    <script>
        // Micro-interaction: Show Toast after 2 seconds to simulate a background event
        window.addEventListener('load', () => {
            setTimeout(() => {
                const toast = document.getElementById('toast');
                toast.classList.remove('translate-y-20', 'opacity-0');
                
                setTimeout(() => {
                    toast.classList.add('translate-y-20', 'opacity-0');
                }, 4000);
            }, 2000);
        });

        // Hover lift effect for action cards
        document.querySelectorAll('button').forEach(btn => {
            btn.addEventListener('mousedown', () => {
                btn.style.transform = 'scale(0.98)';
            });
            btn.addEventListener('mouseup', () => {
                btn.style.transform = '';
            });
        });
    </script>
</body>
</html>
