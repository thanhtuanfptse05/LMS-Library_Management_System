<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Member Dashboard | UniLibrary</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css" />
</head>
<body class="dash-body">
    <!-- SideNavBar Shell -->
    <aside class="dash-sidebar">
        <div class="mb-10">
            <h1 class="text-title-lg font-bold text-primary">UniLibrary</h1>
            <p class="text-label-md text-on-surface-variant opacity-70">LMS Portal</p>
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
            <button class="btn btn-primary w-full shadow-md" style="padding: 12px 16px;">
                <span class="material-symbols-outlined icon-sm" data-icon="search">search</span>
                Search Books
            </button>
        </div>
    </aside>

    <!-- TopNavBar Shell -->
    <header class="dash-header">
        <div class="d-flex items-center gap-4 flex-1">
            <div class="relative w-full" style="max-width: 28rem;">
                <span class="material-symbols-outlined absolute left-3 top-1/2 text-on-surface-variant" style="transform: translateY(-50%);">search</span>
                <input class="dash-input dash-input-icon-left" placeholder="Search by title, author, or ISBN..." type="text"/>
            </div>
        </div>
        <div class="d-flex items-center gap-6">
            <button class="material-symbols-outlined hover-primary relative" style="background: none; border: none; cursor: pointer;">
                notifications
                <span class="absolute top-0 right-0 w-8 h-8 bg-primary rounded-full" style="width: 8px; height: 8px; right: -2px; top: -2px;"></span>
            </button>
            <button class="material-symbols-outlined hover-primary" style="background: none; border: none; cursor: pointer;">
                help
            </button>
            <div class="h-8 bg-outline-variant mx-2" style="width: 1px;"></div>
            <div class="d-flex items-center gap-3">
                <div class="text-right">
                    <p class="text-label-md font-bold text-on-surface">Alex Riverton</p>
                    <span class="badge badge-primary" style="font-size: 10px;">MEMBER</span>
                </div>
                <img alt="User Profile" class="w-10 h-10 rounded-full object-cover" style="border: 2px solid var(--color-primary-container);" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAyr71dURI8CCCSnRq2ZLLf1FLjnLqvExIy4AkGE5pzNUR7k14DptKiy1SeTLCCzwP5yOXJLeDBHWGIhG4fNt_j5hHX3jAop5E5TP6Q8IMdfdZ_y4qEu6i5AoAklyS4LGi97-IDeaTNUCCcw3sLcCq8DP3oq2mj87RGhBYbWI8sJOnoWYHrDi4puv2U--jokdm4uzbMds51McjrpC90RDItfFXMEUaGEmxZ2o0ujyuF8gE5YCDUlVxBxXJ6rNZzcUpMCoPSQYAUFVTy"/>
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
            <!-- Welcome Section -->
            <section class="mb-section-gap">
                <div class="d-flex flex-col gap-2">
                    <h2 class="text-headline-lg text-on-surface">Welcome back, Alex!</h2>
                    <p class="text-body-lg text-on-surface-variant" style="max-width: 42rem;">
                        You have <span class="text-error font-bold">1 book overdue</span> and 2 reservations waiting for pick up. Remember to return your loans on time to avoid further fines.
                    </p>
                </div>
            </section>

            <!-- Metrics Row -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-gutter mb-section-gap">
                <!-- Active Loans -->
                <div class="metric-card" style="border-left: 1px solid var(--color-surface-container); transition: box-shadow 0.3s; cursor: pointer;" onmouseover="this.style.boxShadow='var(--shadow-lg)'" onmouseout="this.style.boxShadow='var(--shadow-sm)'">
                    <div class="d-flex items-center justify-between mb-4">
                        <div class="p-3 bg-primary-container rounded-xl">
                            <span class="material-symbols-outlined text-white" data-icon="menu_book">menu_book</span>
                        </div>
                        <span class="text-label-sm text-on-surface-variant">Active Loans</span>
                    </div>
                    <p class="text-display-lg text-on-surface">4</p>
                    <p class="text-label-md text-on-surface-variant mt-1">2 due this week</p>
                </div>
                <!-- Overdue -->
                <div class="metric-card" style="border: 1px solid var(--color-error-container); transition: box-shadow 0.3s; cursor: pointer;" onmouseover="this.style.boxShadow='var(--shadow-lg)'" onmouseout="this.style.boxShadow='var(--shadow-sm)'">
                    <div class="d-flex items-center justify-between mb-4">
                        <div class="p-3 bg-error text-white rounded-xl">
                            <span class="material-symbols-outlined" data-icon="warning">warning</span>
                        </div>
                        <span class="text-label-sm text-error font-bold">Overdue</span>
                    </div>
                    <p class="text-display-lg text-error">1</p>
                    <p class="text-label-md text-on-surface-variant mt-1">Return immediately</p>
                </div>
                <!-- Unpaid Fines -->
                <div class="metric-card" style="border-left: 1px solid var(--color-surface-container); transition: box-shadow 0.3s; cursor: pointer;" onmouseover="this.style.boxShadow='var(--shadow-lg)'" onmouseout="this.style.boxShadow='var(--shadow-sm)'">
                    <div class="d-flex items-center justify-between mb-4">
                        <div class="p-3 bg-secondary-container rounded-xl text-on-secondary-container">
                            <span class="material-symbols-outlined" data-icon="payments">payments</span>
                        </div>
                        <span class="text-label-sm text-on-surface-variant">Unpaid Fines</span>
                    </div>
                    <p class="text-display-lg text-on-surface">$5.00</p>
                    <p class="text-label-md text-on-surface-variant mt-1">Pay at reception</p>
                </div>
                <!-- Reservations -->
                <div class="metric-card" style="border-left: 1px solid var(--color-surface-container); transition: box-shadow 0.3s; cursor: pointer;" onmouseover="this.style.boxShadow='var(--shadow-lg)'" onmouseout="this.style.boxShadow='var(--shadow-sm)'">
                    <div class="d-flex items-center justify-between mb-4">
                        <div class="p-3 bg-tertiary-container rounded-xl text-white">
                            <span class="material-symbols-outlined" data-icon="bookmark">bookmark</span>
                        </div>
                        <span class="text-label-sm text-on-surface-variant">Reservations</span>
                    </div>
                    <p class="text-display-lg text-on-surface">2</p>
                    <p class="text-label-md text-on-surface-variant mt-1">Ready for pickup</p>
                </div>
            </div>

            <!-- Main Content Area (Two Columns) -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-gutter items-start">
                <!-- Left Column: Current Borrowings -->
                <div class="lg:col-span-8 dash-card" style="padding: 0; overflow: hidden;">
                    <div class="px-6 py-6 border-b border-surface-container-highest d-flex items-center justify-between">
                        <h3 class="text-title-lg text-on-surface">My Current Borrowings</h3>
                        <button class="btn btn-ghost hover:underline" style="padding: 0; background: none;">View History</button>
                    </div>
                    <div class="dash-table-container">
                        <table class="dash-table" style="margin-bottom: 0;">
                            <thead class="bg-surface-container-low text-on-surface-variant">
                                <tr>
                                    <th class="px-6 py-4 text-label-md" style="text-transform: none;">Book Title</th>
                                    <th class="px-6 py-4 text-label-md" style="text-transform: none;">Barcode</th>
                                    <th class="px-6 py-4 text-label-md" style="text-transform: none;">Borrow Date</th>
                                    <th class="px-6 py-4 text-label-md" style="text-transform: none;">Due Date</th>
                                    <th class="px-6 py-4 text-label-md" style="text-transform: none;">Status</th>
                                    <th class="px-6 py-4 text-label-md" style="text-transform: none;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="px-6 py-5">
                                        <div class="d-flex items-center gap-3">
                                            <div class="w-10 h-14 bg-surface-container rounded shadow-sm overflow-hidden flex-shrink-0" style="height: 56px;">
                                                <img class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCBPETUWIo6-atbe67Xjv8JAW_LkAdLRhdXps_W7Ty-Hu87ZQclr_eCRjovmYX1A4al0ehxMgeWppLTU495q25IFPB_WHo0CC2QjvpTz5vmQDjdnjsNTnRZBLGKMaSvVRUBpLZDlSJ-HSpQtPriNybf3Wz2G7b6WEC0MFnLBP55eQ7kSeh6j6VcL8iSCXSLRueQOgasOPWRh_n-ro7D25VvfS7Cg4cpWiuw0a9jICTSSvvUi-rndZHCybPLSUQK_84599g_f9gaxlKk"/>
                                            </div>
                                            <span class="text-body-md text-on-surface font-medium" style="line-height: 1.25;">Advanced Engineering Mathematics</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-5 text-body-md text-on-surface-variant">123456</td>
                                    <td class="px-6 py-5 text-body-md text-on-surface-variant">Oct 10</td>
                                    <td class="px-6 py-5 text-body-md text-on-surface-variant">Oct 24</td>
                                    <td class="px-6 py-5">
                                        <span class="badge badge-success rounded-full px-2.5 py-0.5 text-xs font-medium" style="text-transform: none;">
                                            Borrowed
                                        </span>
                                    </td>
                                    <td class="px-6 py-5">
                                        <button class="btn bg-secondary-container text-on-secondary-container" style="padding: 8px 16px;">Extend</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="px-6 py-5">
                                        <div class="d-flex items-center gap-3">
                                            <div class="w-10 h-14 bg-surface-container rounded shadow-sm overflow-hidden flex-shrink-0" style="height: 56px;">
                                                <img class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBzu4bsJBkBdEBclnmLvbCb5hqfTAkaYK1-7N-2pNzavPxPL3sOfqVcS-fdmncuyyk7S-llbNzYKW_kBG1dvdK2kS094aur63xgt8NWuW4-Zv3C9Wk6aYpI93uewJ3exXzNBsYzy-mB5eY6b1XvvKpu6Q4yH656sbxSOpWfuDBRuaLzayFwb8il5Yq9tLacoIdgp_dmVHa77pSL4jQxYE5yuPcoUZY7JOju9WM64ol6sfsdtu6bhl0BY4Y_WTiXGOn8nt9hCRA0FiAJ"/>
                                            </div>
                                            <span class="text-body-md text-on-surface font-medium" style="line-height: 1.25;">Modern Physics</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-5 text-body-md text-on-surface-variant">789012</td>
                                    <td class="px-6 py-5 text-body-md text-on-surface-variant">Sept 20</td>
                                    <td class="px-6 py-5 text-error font-medium">Oct 04</td>
                                    <td class="px-6 py-5">
                                        <span class="badge badge-error rounded-full px-2.5 py-0.5 text-xs font-medium" style="text-transform: none;">
                                            Overdue
                                        </span>
                                    </td>
                                    <td class="px-6 py-5">
                                        <button class="btn btn-primary" style="padding: 8px 16px;">Return</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Right Column: Widgets -->
                <div class="lg:col-span-4 d-flex flex-col gap-gutter">
                    <!-- Quick Search Widget -->
                    <div class="dash-card">
                        <h3 class="text-title-lg text-on-surface mb-4">Quick Search</h3>
                        <div class="d-flex flex-col gap-4">
                            <div class="relative">
                                <input class="w-full bg-white border border-outline-variant shadow-sm" style="padding: 12px 16px; border-radius: 12px; outline: none;" placeholder="Title / Author / ISBN" type="text"/>
                            </div>
                            <div class="d-flex flex-wrap gap-2">
                                <button class="btn bg-surface-container-high text-on-surface-variant text-label-sm hover-primary" style="padding: 6px 12px; border-radius: 9999px;">By Title</button>
                                <button class="btn bg-surface-container-high text-on-surface-variant text-label-sm hover-primary" style="padding: 6px 12px; border-radius: 9999px;">By Author</button>
                                <button class="btn bg-surface-container-high text-on-surface-variant text-label-sm hover-primary" style="padding: 6px 12px; border-radius: 9999px;">By ISBN</button>
                            </div>
                            <button class="btn btn-primary w-full mt-2" style="padding: 12px;">
                                Find Now
                            </button>
                        </div>
                    </div>

                    <!-- Recent Notifications Feed -->
                    <div class="dash-card d-flex flex-col h-full" style="min-height: 300px;">
                        <div class="d-flex items-center justify-between mb-6">
                            <h3 class="text-title-lg text-on-surface">Recent Notifications</h3>
                            <span class="material-symbols-outlined text-on-surface-variant hover-primary icon-md" style="cursor: pointer;">settings</span>
                        </div>
                        <div class="d-flex flex-col gap-6">
                            <div class="d-flex gap-4">
                                <div class="w-10 h-10 rounded-full bg-error-container text-error d-flex items-center justify-center flex-shrink-0">
                                    <span class="material-symbols-outlined icon-sm" data-icon="alarm">alarm</span>
                                </div>
                                <div class="flex-1 border-b border-surface-container-low pb-4" style="cursor: pointer;">
                                    <p class="text-body-md font-medium text-on-surface hover-primary transition-colors">Due date reminder</p>
                                    <p class="text-label-sm text-on-surface-variant mt-1">Modern Physics is 10 days overdue.</p>
                                    <span class="text-label-sm text-on-surface-variant opacity-70 mt-1" style="display: block; font-size: 10px;">2 hours ago</span>
                                </div>
                            </div>
                            <div class="d-flex gap-4">
                                <div class="w-10 h-10 rounded-full bg-secondary-container text-secondary d-flex items-center justify-center flex-shrink-0">
                                    <span class="material-symbols-outlined icon-sm" data-icon="done_all">done_all</span>
                                </div>
                                <div class="flex-1 border-b border-surface-container-low pb-4" style="cursor: pointer;">
                                    <p class="text-body-md font-medium text-on-surface hover-primary transition-colors">Reserved book available</p>
                                    <p class="text-label-sm text-on-surface-variant mt-1">"Data Science Basics" is ready at Desk 4.</p>
                                    <span class="text-label-sm text-on-surface-variant opacity-70 mt-1" style="display: block; font-size: 10px;">Yesterday</span>
                                </div>
                            </div>
                            <div class="d-flex gap-4">
                                <div class="w-10 h-10 rounded-full bg-surface-container-highest text-on-surface-variant d-flex items-center justify-center flex-shrink-0">
                                    <span class="material-symbols-outlined icon-sm" data-icon="event">event</span>
                                </div>
                                <div class="flex-1" style="cursor: pointer;">
                                    <p class="text-body-md font-medium text-on-surface hover-primary transition-colors">Library holiday notice</p>
                                    <p class="text-label-sm text-on-surface-variant mt-1">Closed this Sunday for maintenance.</p>
                                    <span class="text-label-sm text-on-surface-variant opacity-70 mt-1" style="display: block; font-size: 10px;">3 days ago</span>
                                </div>
                            </div>
                        </div>
                        <button class="btn btn-ghost w-full mt-auto pt-6" style="padding-top: 24px; justify-content: center; background: none;">View All Notifications</button>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- FAB for quick action (Dashboard contextual) -->
    <button class="fixed bg-primary text-white rounded-full shadow-lg d-flex items-center justify-center transition-all z-50 group hover-primary" style="bottom: 40px; right: 40px; width: 56px; height: 56px; border: none; cursor: pointer; color: white;" onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'">
        <span class="material-symbols-outlined" data-icon="add">add</span>
        <!-- Tooltip placeholder -->
    </button>

    <script>
        // Micro-interaction for extend button
        document.querySelectorAll('button').forEach(btn => {
            btn.addEventListener('mousedown', () => {
                btn.style.transform = 'scale(0.96)';
            });
            btn.addEventListener('mouseup', () => {
                btn.style.transform = 'scale(1)';
            });
        });
    </script>
</body>
</html>
