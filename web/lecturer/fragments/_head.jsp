<%-- Fragment: _head.jsp — <head> block for Lecturer Dashboard --%>
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Bảng điều khiển Giảng viên - Thư viện Đại học LMS</title>
    <meta name="description" content="Academic resource and course material management panel for Lecturers at LMS University Library." />

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
            --secondary-fixed: #ffddb7;
            --secondary-fixed-dim: #e6c095;
            --on-secondary-fixed: #2a1800;
            --on-secondary-fixed-variant: #5b4220;
            --secondary-container: #fdd6a9;
            --on-secondary-container: #785c38;
            --tertiary: #006398;
            --tertiary-fixed: #cde5ff;
            --on-tertiary-fixed: #001d32;
            --on-tertiary-fixed-variant: #004b74;
            --error: #ba1a1a;
            --error-container: #ffdad6;
            --on-error-container: #93000a;
            --success: #16a34a;
            --background: #fff8f6;
            --on-background: #251913;
            --on-surface: #251913;
            --on-surface-variant: #584237;
            --surface-container-lowest: #ffffff;
            --surface-container-low: #fff1eb;
            --surface-container: #ffeae0;
            --surface-container-high: #efe3d9;
            --surface-variant: #f5e0d2;
            --outline: #8c7164;
            --outline-variant: #e0c0b1;
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
        .main-wrapper { height: calc(100vh - 64px); margin-top: 64px; }

        .sidebar-link {
            display: flex; align-items: center; gap: 12px;
            padding: 10px 14px; color: var(--on-surface-variant);
            text-decoration: none; border-radius: 0.5rem;
            font-size: 14px; font-weight: 600;
            transition: all 0.2s ease; border-right: 3px solid transparent;
        }
        .sidebar-link.active {
            background-color: rgba(255, 219, 202, 0.5);
            color: var(--primary); border-right-color: var(--primary);
        }
        .sidebar-link:not(.active):hover {
            background-color: var(--surface-container-high); color: var(--primary);
        }

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
        }

        .bg-primary-custom { background-color: var(--primary) !important; }
        .text-primary-custom { color: var(--primary) !important; }
        .text-on-surface-variant { color: var(--on-surface-variant) !important; }
        .bg-surface-container-low { background-color: var(--surface-container-low) !important; }
        .border-outline-variant { border-color: var(--outline-variant) !important; }

        .btn-primary-custom {
            background-color: var(--primary); color: white; border: none;
            transition: transform 0.2s ease, filter 0.2s ease;
        }
        .btn-primary-custom:hover { background-color: #803700; color: white; transform: scale(1.02); }
        .btn-primary-custom:active { transform: scale(0.98); }

        .badge-pill {
            padding: 3px 10px; border-radius: 999px;
            font-size: 11px; font-weight: 700; letter-spacing: 0.05em;
        }

        .mini-progress {
            width: 100%; height: 5px; border-radius: 999px;
            background-color: var(--surface-container-low); overflow: hidden;
        }
        .mini-progress-bar { height: 100%; border-radius: 999px; }

        .table-lms thead th {
            background-color: var(--surface-container-low);
            color: var(--on-surface-variant); font-size: 11px; font-weight: 600;
            letter-spacing: 0.05em; text-transform: uppercase;
            padding: 14px 16px; border-bottom: 1px solid var(--outline-variant);
        }
        .table-lms tbody td {
            padding: 13px 16px; border-bottom: 1px solid var(--outline-variant); vertical-align: middle;
        }
        .table-lms tbody tr:hover { background-color: var(--surface-container-low); }
        .table-lms tbody tr:last-child td { border-bottom: none; }

        .btn-icon {
            background: transparent; border: none; padding: 4px 6px;
            border-radius: 6px; color: var(--on-surface-variant); cursor: pointer;
        }
        .btn-icon:hover { background-color: var(--surface-container-high); }

        .avatar {
            width: 32px; height: 32px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 11px; font-weight: 700; flex-shrink: 0;
        }

        .notif-dot {
            position: absolute; top: 6px; right: 6px;
            width: 8px; height: 8px;
            background-color: var(--primary); border-radius: 50%;
        }

        /* ─── Course chip ─── */
        .course-chip {
            display: inline-flex; align-items: center; gap: 8px;
            padding: 8px 14px; border-radius: 999px; font-size: 12px;
            font-weight: 600; background-color: var(--surface-container-low);
            border: 1px solid var(--outline-variant);
            transition: border-color 0.2s ease, background-color 0.2s ease;
            cursor: pointer; text-decoration: none; color: var(--on-surface);
        }
        .course-chip:hover {
            border-color: var(--primary);
            background-color: var(--primary-fixed);
            color: var(--on-primary-container);
        }
        .course-chip.active {
            background-color: var(--primary-fixed);
            border-color: var(--primary);
            color: var(--on-primary-container);
        }

        /* ─── Resource card ─── */
        .resource-card {
            display: flex; align-items: center; gap: 12px;
            padding: 12px 14px; border-radius: 12px;
            border: 1px solid var(--outline-variant);
            transition: border-color 0.2s ease, transform 0.2s ease;
            cursor: pointer;
        }
        .resource-card:hover {
            border-color: var(--primary); transform: translateX(3px);
        }

        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: var(--outline-variant); border-radius: 10px;
        }

        @media (max-width: 991.98px) { .header-search-input { width: 100%; } }
    </style>
</head>
