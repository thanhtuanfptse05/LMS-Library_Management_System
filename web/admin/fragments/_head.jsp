<%-- Fragment: _head.jsp — <head> block for Admin Dashboard --%>
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Bảng điều khiển Quản trị viên - Thư viện Đại học LMS</title>
    <meta name="description" content="System administration panel for LMS University Library — manage users, configurations, and audit logs." />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />

    <style>
        :root {
            --primary: #9d4300;
            --primary-container: #f97316;
            --primary-fixed: #ffdbca;
            --primary-fixed-dim: #ffb690;
            --on-primary-container: #582200;
            --secondary-container: #dae2fd;
            --on-secondary-container: #5c647a;
            --secondary-fixed: #dae2fd;
            --secondary-fixed-dim: #bec6e0;
            --on-secondary-fixed: #131b2e;
            --on-secondary-fixed-variant: #3f465c;
            --tertiary: #006398;
            --tertiary-fixed: #cde5ff;
            --on-tertiary-fixed: #001d32;
            --on-tertiary-fixed-variant: #004b74;
            --tertiary-container: #00a2f4;
            --on-tertiary-container: #003554;
            --error: #ba1a1a;
            --error-container: #ffdad6;
            --on-error-container: #93000a;
            --background: #f7f9fb;
            --on-background: #191c1e;
            --surface: #f7f9fb;
            --on-surface: #191c1e;
            --on-surface-variant: #584237;
            --surface-container-lowest: #ffffff;
            --surface-container-low: #f2f4f6;
            --surface-container: #eceef0;
            --surface-container-high: #e6e8ea;
            --surface-container-highest: #e0e3e5;
            --surface-variant: #e0e3e5;
            --outline: #8c7164;
            --outline-variant: #e0c0b1;
            --inverse-surface: #2d3133;
            --inverse-on-surface: #eff1f3;
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--background);
            color: var(--on-background);
            overflow-x: hidden;
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
        }

        /* ─── Layout ─── */
        .main-wrapper {
            height: calc(100vh - 64px);
            margin-top: 64px;
        }

        /* ─── Sidebar ─── */
        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 14px;
            color: var(--on-surface-variant);
            text-decoration: none;
            border-radius: 0.5rem;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
            border-right: 3px solid transparent;
        }

        .sidebar-link.active {
            background-color: rgba(255, 182, 144, 0.2);
            color: var(--primary);
            border-right-color: var(--primary);
        }

        .sidebar-link:not(.active):hover {
            background-color: var(--surface-container-high);
            color: var(--primary);
        }

        /* ─── Cards ─── */
        .raised-card {
            background-color: var(--surface-container-lowest);
            border: 1px solid var(--outline-variant);
            border-radius: 1rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .raised-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.06);
        }

        /* ─── Header Search ─── */
        .header-search-wrapper { position: relative; }
        .header-search-wrapper .material-symbols-outlined {
            position: absolute; left: 12px; top: 50%; transform: translateY(-50%);
        }
        .header-search-input {
            width: 300px; padding-left: 40px;
            background-color: var(--surface-container-low);
            border: none; border-radius: 0.75rem; height: 40px;
            transition: box-shadow 0.2s ease;
        }
        .header-search-input:focus {
            outline: none;
            box-shadow: 0 0 0 2px rgba(249, 115, 22, 0.3);
            background-color: var(--surface-container-low);
        }

        /* ─── Color Helpers ─── */
        .bg-primary-custom     { background-color: var(--primary) !important; }
        .text-primary-custom   { color: var(--primary) !important; }
        .bg-surface-container-low  { background-color: var(--surface-container-low) !important; }
        .bg-surface-container-high { background-color: var(--surface-container-high) !important; }
        .border-outline-variant { border-color: var(--outline-variant) !important; }
        .text-on-surface-variant { color: var(--on-surface-variant) !important; }

        /* ─── Buttons ─── */
        .btn-primary-custom {
            background-color: var(--primary); color: white; border: none;
            transition: transform 0.2s ease, filter 0.2s ease;
        }
        .btn-primary-custom:hover {
            background-color: #803700; color: white; transform: scale(1.02);
        }
        .btn-primary-custom:active { transform: scale(0.98); }

        /* ─── Mini Progress ─── */
        .mini-progress {
            width: 100%; height: 6px; border-radius: 999px;
            background-color: var(--surface-container-low); overflow: hidden;
        }
        .mini-progress-bar { height: 100%; border-radius: 999px; }

        /* ─── Badge pill ─── */
        .badge-pill {
            padding: 3px 10px; border-radius: 999px;
            font-size: 11px; font-weight: 700; letter-spacing: 0.05em;
        }

        /* ─── Audit Timeline ─── */
        .audit-item {
            padding: 4px 0 4px 16px;
            border-left: 2px solid var(--outline-variant);
            position: relative;
        }
        .audit-item .audit-dot {
            position: absolute; left: -5px; top: 8px;
            width: 10px; height: 10px; border-radius: 50%; border: 3px solid white;
        }

        /* ─── Table ─── */
        .table-lms thead th {
            background-color: var(--surface-container-low);
            color: var(--on-surface-variant);
            font-size: 11px; font-weight: 600;
            letter-spacing: 0.05em; text-transform: uppercase;
            padding: 14px 16px; border-bottom: 1px solid var(--outline-variant);
        }
        .table-lms tbody td {
            padding: 14px 16px; border-bottom: 1px solid var(--outline-variant); vertical-align: middle;
        }
        .table-lms tbody tr:hover { background-color: var(--surface-container-low); }

        /* ─── Config input ─── */
        .config-input {
            background-color: var(--surface-container-low);
            border: 1px solid var(--outline-variant);
            border-radius: 8px; padding: 6px 12px; font-size: 15px; flex: 1; outline: none;
        }
        .config-input:focus { border-color: var(--primary); }

        /* ─── Status pulse ─── */
        @keyframes pulse { 0%, 100% { opacity: 1 } 50% { opacity: .4 } }
        .animate-pulse { animation: pulse 2s infinite; }

        /* ─── Btn icon ─── */
        .btn-icon {
            background: transparent; border: none; padding: 4px 6px;
            border-radius: 6px; color: var(--on-surface-variant); cursor: pointer;
        }
        .btn-icon:hover { background-color: var(--surface-container-high); }

        /* ─── Avatar ─── */
        .avatar {
            width: 32px; height: 32px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 11px; font-weight: 700;
        }

        /* ─── Notification dot ─── */
        .notif-dot {
            position: absolute; top: 6px; right: 6px;
            width: 8px; height: 8px;
            background-color: var(--primary); border-radius: 50%;
        }

        /* ─── Custom scrollbar ─── */
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: var(--outline-variant); border-radius: 10px;
        }

        @media (max-width: 991.98px) {
            .header-search-input { width: 100%; }
        }

        /* ─── Responsive Layout Offset Styles ─── */
        @media (min-width: 992px) {
            .sidebar-layout {
                width: 280px !important;
            }
            .main-content-layout {
                margin-left: 280px !important;
            }
            .header-layout {
                margin-left: 280px !important;
            }
        }
        @media (max-width: 991.98px) {
            .main-content-layout {
                margin-left: 0 !important;
            }
            .header-layout {
                margin-left: 0 !important;
            }
        }
    </style>
</head>
