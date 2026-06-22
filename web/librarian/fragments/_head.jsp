<%-- Fragment: _head.jsp — <head> block for Librarian Dashboard --%>

    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Bảng điều khiển Thủ thư - Thư viện Đại học LMS</title>
        <meta name="description"
            content="Bảng điều khiển quản lý lưu thông và danh mục cho thủ thư Thư viện Đại học LMS." />

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,300..800;1,14..32,300..800&display=swap" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/lms-dashboard.css" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/book-management.css?v=20260621-1" rel="stylesheet" />

        <style>
            /* Librarian-specific token overrides matching ui_rule.md for high-contrast */
            :root {
                --primary: #d97706; /* Terracotta Orange */
                --primary-hover: #b45309; /* Darker Terracotta Orange */
                --primary-container: #fee2e2;
                --primary-fixed: #ffedd5;
                --primary-fixed-dim: #fed7aa;
                --on-primary-container: #7c2d12;
                
                --background: #f4f3f0; /* Scholastic Warm Off-White (slightly darker for better card contrast) */
                --on-background: #1c1917; /* Very dark stone (sharp typography) */
                --surface: #ffffff;
                --on-surface: #1c1917; /* Very dark stone (sharp typography) */
                --on-surface-variant: #44403c; /* Darker neutral gray for high readability secondary text */
                
                --secondary-fixed: #e7e5e4;
                --secondary-fixed-dim: #d6d3d1;
                --on-secondary-fixed: #1c1917;
                --on-secondary-fixed-variant: #44403c;
                
                --surface-container-lowest: #ffffff;
                --surface-container-low: #faf9f6;
                --surface-container: #f5f2eb;
                --surface-container-high: #e7e3da;
                --surface-container-highest: #d6cfc4;
                --surface-variant: #faf9f6;
                
                --outline: #57534e; /* Darker outline for borders and elements */
                --outline-variant: #d6d3d1; /* Sharp, visible borders (previously was e5e5e5) */
                
                --error: #dc2626; /* Rose Red */
                --error-container: #fee2e2;
                --success: #059669; /* Emerald Green */
                --success-container: #d1fae5;
                --warning: #d97706;
                --warning-container: #fef3c7;
            }

            /* Custom high-contrast overrides for librarian panel */
            body {
                color: var(--on-background) !important;
                -webkit-font-smoothing: antialiased;
            }
            .raised-card {
                border: 1.5px solid var(--outline-variant) !important;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.04), 0 1px 3px rgba(0, 0, 0, 0.02) !important;
            }
            .raised-card:hover {
                border-color: var(--primary) !important;
                box-shadow: 0 10px 25px rgba(217, 119, 6, 0.06), 0 4px 12px rgba(0, 0, 0, 0.02) !important;
            }
            .stat-card {
                border: 1.5px solid var(--outline-variant) !important;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.04) !important;
            }
            .stat-card:hover {
                border-color: var(--primary) !important;
            }
            .table-lms thead th {
                background-color: var(--surface-container) !important;
                color: var(--on-surface) !important;
                font-weight: 700 !important;
                border-bottom: 2px solid var(--outline-variant) !important;
                text-transform: uppercase;
                font-size: 11px;
                letter-spacing: 0.05em;
            }
            .table-lms tbody td {
                border-bottom: 1px solid var(--outline-variant) !important;
                color: var(--on-surface) !important;
            }
            .sidebar-link {
                color: var(--on-surface-variant) !important;
                font-weight: 600 !important;
            }
            .sidebar-link:hover {
                color: var(--primary) !important;
                background-color: var(--surface-container-high) !important;
            }
            .sidebar-link.active {
                color: var(--primary) !important;
                background: linear-gradient(135deg, rgba(255, 237, 213, 0.7) 0%, rgba(254, 215, 170, 0.3) 100%) !important;
                border-right: 3px solid var(--primary) !important;
            }
            .sidebar-section-label {
                color: var(--primary) !important;
                font-weight: 800 !important;
                opacity: 0.9 !important;
            }
            .card-title {
                color: var(--on-surface) !important;
                font-weight: 700 !important;
            }
            .card-subtitle {
                color: var(--on-surface-variant) !important;
                opacity: 0.95 !important;
            }
            /* Form inputs styling */
            .form-control {
                border: 1.5px solid var(--outline-variant) !important;
                color: var(--on-surface) !important;
                background-color: var(--surface) !important;
            }
            .form-control:focus {
                border-color: var(--primary) !important;
                box-shadow: 0 0 0 3px rgba(217, 119, 6, 0.15) !important;
            }
        </style>
    </head>
