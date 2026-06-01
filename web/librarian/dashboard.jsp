<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Academic Nexus - Librarian Dashboard</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css" />
    <style>
        .glass-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .quick-action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            gap: var(--space-sm);
            padding: var(--space-xl);
            background-color: var(--color-primary);
            color: #ffffff;
            border-radius: var(--radius-2xl);
            box-shadow: var(--shadow-lg);
            transition: all var(--transition-base);
            border: none;
            cursor: pointer;
            width: 100%;
        }
        .quick-action-btn:hover {
            filter: brightness(0.9);
            transform: scale(1.02);
        }
    </style>
</head>
<body class="dash-body" style="background-color: #FFF7ED;">
    <!-- Side Navigation Bar -->
    <aside class="dash-sidebar">
        <div class="mb-10">
            <h1 class="text-title-lg font-bold text-primary">UniLibrary</h1>
            <p class="text-label-md text-on-surface-variant">LMS Portal</p>
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
        </nav>
        <div class="mt-auto">
            <button class="btn btn-primary w-full text-white py-3 rounded-xl">
                <span class="material-symbols-outlined icon-sm" data-icon="search">search</span>
                Search Books
            </button>
        </div>
    </aside>

    <!-- Top Navigation Bar -->
    <header class="dash-header">
        <div class="d-flex items-center gap-4">
            <span class="text-title-lg font-bold text-primary">Library Management System</span>
        </div>
        <div class="d-flex items-center gap-6">
            <div class="d-flex items-center gap-2 px-3 py-1 bg-primary text-white rounded-full">
                <span class="material-symbols-outlined icon-sm" data-icon="shield_person">shield_person</span>
                <span class="text-label-sm">Librarian</span>
            </div>
            <div class="d-flex items-center gap-4 text-on-surface-variant">
                <button class="material-symbols-outlined hover-primary icon-md" style="background: none; border: none; cursor: pointer;" data-icon="notifications">notifications</button>
                <button class="material-symbols-outlined hover-primary icon-md" style="background: none; border: none; cursor: pointer;" data-icon="help">help</button>
            </div>
            <img alt="User Profile" class="w-10 h-10 rounded-full object-cover" style="border: 2px solid var(--color-primary-container);" src="https://lh3.googleusercontent.com/aida-public/AB6AXuD5VRrad2RbKAU58gvnSjPgYAZD5KmF00CcsYiD74d-QLCGjPPF3V6jIYriy7t23xGVsP3FzRMWZ9L-5lHiJciEG925mlByE1YKxnkliQH-Fpvoj3EI9ybuNoG5d6XhHFQVXIsC9sVyYGFWztGtw-bTHkdeXok7qW3EDaUA0J7rL7isR2Kt9q1g7LCzm3m2vOBBZgeT4qxhRd0-Hj4oYMa7IM79Uh84NulmZ8WwJY1z3B2XjXd6-9OfklAYfAA0utiELofinOAtAy64"/>
            <!-- Logout Button -->
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline" style="padding: 4px 8px; margin-left: 12px;">
                <span class="material-symbols-outlined icon-sm">logout</span>
            </a>
        </div>
    </header>

    <!-- Main Content -->
    <main class="dash-main">
        <div class="dash-container">
            <!-- Quick Action Section -->
            <section class="grid grid-cols-1 md:grid-cols-3 gap-gutter mb-section-gap">
                <button class="quick-action-btn">
                    <span class="material-symbols-outlined icon-xl" data-icon="barcode_scanner">barcode_scanner</span>
                    <span class="text-headline-md">Scan Barcode to Checkout</span>
                </button>
                <button class="quick-action-btn">
                    <span class="material-symbols-outlined icon-xl" data-icon="keyboard_return">keyboard_return</span>
                    <span class="text-headline-md">Scan Barcode to Return</span>
                </button>
                <button class="quick-action-btn">
                    <span class="material-symbols-outlined icon-xl" data-icon="person_add">person_add</span>
                    <span class="text-headline-md">Register New Member</span>
                </button>
            </section>

            <!-- Metrics Row -->
            <section class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-gutter mb-section-gap">
                <div class="metric-card bg-white border-primary">
                    <p class="text-on-surface-variant text-label-md mb-2">Books Checked Out Today</p>
                    <h3 class="text-display-lg text-primary">142</h3>
                </div>
                <div class="metric-card bg-white border-secondary">
                    <p class="text-on-surface-variant text-label-md mb-2">Books Returned Today</p>
                    <h3 class="text-display-lg text-secondary">98</h3>
                </div>
                <div class="metric-card bg-white border-tertiary">
                    <p class="text-on-surface-variant text-label-md mb-2">Pending Reservations</p>
                    <h3 class="text-display-lg text-tertiary">15</h3>
                </div>
                <div class="metric-card bg-white border-error">
                    <p class="text-on-surface-variant text-label-md mb-2">Members Overdue</p>
                    <h3 class="text-display-lg text-error">24</h3>
                </div>
            </section>

            <!-- Main Content Grid -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-gutter">
                <!-- Transactions Table (Left Wide) -->
                <section class="lg:col-span-8 dash-card bg-white" style="padding: 0; overflow: hidden;">
                    <div class="p-6 border-b border-outline-variant d-flex justify-between items-center">
                        <h2 class="text-title-lg text-on-surface">Today's Transactions</h2>
                        <button class="btn btn-ghost d-flex items-center gap-1" style="padding: 0;">
                            View All <span class="material-symbols-outlined icon-sm" data-icon="chevron_right">chevron_right</span>
                        </button>
                    </div>
                    <div class="dash-table-container">
                        <table class="dash-table" style="margin-bottom: 0;">
                            <thead class="bg-surface-container-low text-on-surface-variant text-label-sm">
                                <tr>
                                    <th class="px-6 py-4">User ID</th>
                                    <th class="px-6 py-4">Book Barcode</th>
                                    <th class="px-6 py-4">Action</th>
                                    <th class="px-6 py-4">Time</th>
                                    <th class="px-6 py-4">Status</th>
                                </tr>
                            </thead>
                            <tbody class="text-body-md">
                                <tr>
                                    <td class="px-6 py-4">U-2023-4412</td>
                                    <td class="px-6 py-4">978-3-16-148410-0</td>
                                    <td class="px-6 py-4">
                                        <span class="badge badge-primary rounded-full px-3 py-1">Borrow</span>
                                    </td>
                                    <td class="px-6 py-4">09:45 AM</td>
                                    <td class="px-6 py-4 text-success font-semibold">Success</td>
                                </tr>
                                <tr>
                                    <td class="px-6 py-4">U-2023-8821</td>
                                    <td class="px-6 py-4">978-0-26-203384-8</td>
                                    <td class="px-6 py-4">
                                        <span class="badge badge-warning rounded-full px-3 py-1">Return</span>
                                    </td>
                                    <td class="px-6 py-4">10:12 AM</td>
                                    <td class="px-6 py-4 text-success font-semibold">Success</td>
                                </tr>
                                <tr>
                                    <td class="px-6 py-4">U-2024-1029</td>
                                    <td class="px-6 py-4">978-1-11-853164-8</td>
                                    <td class="px-6 py-4">
                                        <span class="badge badge-primary rounded-full px-3 py-1">Borrow</span>
                                    </td>
                                    <td class="px-6 py-4">10:30 AM</td>
                                    <td class="px-6 py-4 text-secondary font-semibold" style="font-style: italic;">Pending</td>
                                </tr>
                                <tr>
                                    <td class="px-6 py-4">U-2023-3390</td>
                                    <td class="px-6 py-4">978-0-13-235088-4</td>
                                    <td class="px-6 py-4">
                                        <span class="badge badge-warning rounded-full px-3 py-1">Return</span>
                                    </td>
                                    <td class="px-6 py-4">10:48 AM</td>
                                    <td class="px-6 py-4 text-success font-semibold">Success</td>
                                </tr>
                                <tr>
                                    <td class="px-6 py-4">U-2022-7715</td>
                                    <td class="px-6 py-4">978-0-59-600712-6</td>
                                    <td class="px-6 py-4">
                                        <span class="badge badge-primary rounded-full px-3 py-1">Borrow</span>
                                    </td>
                                    <td class="px-6 py-4">11:05 AM</td>
                                    <td class="px-6 py-4 text-success font-semibold">Success</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </section>

                <!-- Overdue Alerts (Right Narrow) -->
                <section class="lg:col-span-4 dash-card bg-white" style="padding: 0; overflow: hidden;">
                    <div class="p-6 border-b border-outline-variant">
                        <h2 class="text-title-lg text-on-surface">Overdue Alerts</h2>
                    </div>
                    <div class="p-4 d-flex flex-col gap-4">
                        <!-- Alert Item 1 -->
                        <div class="p-4 border border-error-container rounded-xl" style="background-color: rgba(255, 218, 214, 0.1);">
                            <div class="d-flex justify-between items-start mb-3">
                                <div>
                                    <h4 class="text-label-md font-bold text-on-surface">Alex Johnston</h4>
                                    <p class="text-label-sm text-on-surface-variant">3 days overdue</p>
                                </div>
                                <span class="text-error font-bold text-label-sm">-$15.00</span>
                            </div>
                            <div class="d-flex gap-2">
                                <button class="btn btn-outline flex-1 bg-white hover-bg-surface-low" style="padding: 8px;">
                                    <span class="material-symbols-outlined icon-sm" data-icon="mail">mail</span> Email
                                </button>
                                <button class="btn btn-outline flex-1 bg-white hover-bg-surface-low" style="padding: 8px;">
                                    <span class="material-symbols-outlined icon-sm" data-icon="phone">phone</span> Phone
                                </button>
                            </div>
                        </div>
                        <!-- Alert Item 2 -->
                        <div class="p-4 border border-error-container rounded-xl" style="background-color: rgba(255, 218, 214, 0.1);">
                            <div class="d-flex justify-between items-start mb-3">
                                <div>
                                    <h4 class="text-label-md font-bold text-on-surface">Sarah Miller</h4>
                                    <p class="text-label-sm text-on-surface-variant">7 days overdue</p>
                                </div>
                                <span class="text-error font-bold text-label-sm">-$35.00</span>
                            </div>
                            <div class="d-flex gap-2">
                                <button class="btn btn-outline flex-1 bg-white hover-bg-surface-low" style="padding: 8px;">
                                    <span class="material-symbols-outlined icon-sm" data-icon="mail">mail</span> Email
                                </button>
                                <button class="btn btn-outline flex-1 bg-white hover-bg-surface-low" style="padding: 8px;">
                                    <span class="material-symbols-outlined icon-sm" data-icon="phone">phone</span> Phone
                                </button>
                            </div>
                        </div>
                        <!-- Alert Item 3 -->
                        <div class="p-4 border border-error-container rounded-xl" style="background-color: rgba(255, 218, 214, 0.1);">
                            <div class="d-flex justify-between items-start mb-3">
                                <div>
                                    <h4 class="text-label-md font-bold text-on-surface">Michael Chen</h4>
                                    <p class="text-label-sm text-on-surface-variant">1 day overdue</p>
                                </div>
                                <span class="text-error font-bold text-label-sm">-$5.00</span>
                            </div>
                            <div class="d-flex gap-2">
                                <button class="btn btn-outline flex-1 bg-white hover-bg-surface-low" style="padding: 8px;">
                                    <span class="material-symbols-outlined icon-sm" data-icon="mail">mail</span> Email
                                </button>
                                <button class="btn btn-outline flex-1 bg-white hover-bg-surface-low" style="padding: 8px;">
                                    <span class="material-symbols-outlined icon-sm" data-icon="phone">phone</span> Phone
                                </button>
                            </div>
                        </div>
                        <button class="btn btn-ghost w-full py-3 text-label-md" style="background-color: rgba(157, 67, 0, 0.05);">
                            View All Alerts (24)
                        </button>
                    </div>
                </section>
            </div>
        </div>
    </main>

    <!-- Success Toast Notification -->
    <div class="fixed dash-card border-l-4" style="border-left-color: #22c55e; bottom: 32px; right: 32px; z-index: 100; transform: translateY(100px); opacity: 0; transition: all 0.5s;" id="toast">
        <div class="d-flex items-center gap-4">
            <div class="w-10 h-10 rounded-full d-flex items-center justify-center text-success" style="background-color: #dcfce7;">
                <span class="material-symbols-outlined" data-icon="check_circle">check_circle</span>
            </div>
            <div>
                <h4 class="font-bold text-on-surface">Scan Successful</h4>
                <p class="text-label-sm text-on-surface-variant">Book has been checked out to U-2023-4412.</p>
            </div>
        </div>
    </div>

    <script>
        // Simple Micro-interaction: Show Toast after 2 seconds to simulate a background event
        window.addEventListener('load', () => {
            setTimeout(() => {
                const toast = document.getElementById('toast');
                toast.style.transform = 'translateY(0)';
                toast.style.opacity = '1';
                
                setTimeout(() => {
                    toast.style.transform = 'translateY(100px)';
                    toast.style.opacity = '0';
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
