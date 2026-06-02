<%-- Fragment: _head.jsp — <head> block với meta, CSS links và custom styles --%>
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Student Dashboard - LMS University Library</title>
    <meta name="description" content="Manage your loans, reservations, and explore book recommendations on your personal student library dashboard." />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />

    <style>
        :root {
            --primary: #9d4300;
            --primary-container: #f97316;
            --primary-fixed-dim: #ffb690;
            --on-surface-variant: #584237;
            --surface-container-low: #f2f4f6;
            --surface-container-high: #e6e8ea;
            --surface-container: #eceef0;
            --outline-variant: #e0c0b1;
            --secondary-container: #fdd6a9;
            --on-secondary-container: #785c38;
            --tertiary: #006398;
            --error: #ba1a1a;
            --error-container: #ffdad6;
            --success: #16a34a;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f7f9fb;
            color: #191c1e;
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

        /* ─── Cards ─── */
        .raised-card {
            background-color: #ffffff;
            border: none;
            border-radius: 1rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .raised-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.06);
        }

        /* ─── Header Search ─── */
        .header-search-wrapper {
            position: relative;
        }

        .header-search-wrapper .material-symbols-outlined {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
        }

        .header-search-input {
            width: 384px;
            padding-left: 40px;
            background-color: var(--surface-container-low);
            border: none;
            border-radius: 0.75rem;
            height: 40px;
            transition: box-shadow 0.2s ease;
        }

        .header-search-input:focus {
            outline: none;
            box-shadow: 0 0 0 2px rgba(249, 115, 22, 0.3);
            background-color: var(--surface-container-low);
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
        }

        .sidebar-link.active {
            background-color: var(--secondary-container);
            color: var(--on-secondary-container);
        }

        .sidebar-link:not(.active):hover {
            background-color: var(--surface-container-high);
            color: var(--primary);
        }

        /* ─── Color Helpers ─── */
        .bg-primary-custom      { background-color: var(--primary) !important; }
        .text-primary-custom    { color: var(--primary) !important; }
        .bg-surface-container-low  { background-color: var(--surface-container-low) !important; }
        .bg-surface-container-high { background-color: var(--surface-container-high) !important; }
        .bg-surface-container   { background-color: var(--surface-container) !important; }
        .border-outline-variant { border-color: var(--outline-variant) !important; }
        .text-on-surface-variant { color: var(--on-surface-variant) !important; }

        /* ─── Buttons ─── */
        .btn-primary-custom {
            background-color: var(--primary);
            color: white;
            border: none;
            transition: transform 0.2s ease, filter 0.2s ease;
        }

        .btn-primary-custom:hover {
            background-color: #803700;
            color: white;
            transform: scale(1.02);
        }

        .btn-primary-custom:active { transform: scale(0.98); }

        .btn-outline-primary-custom {
            border: 2px solid var(--primary);
            color: var(--primary);
            font-weight: 700;
            background: transparent;
            transition: all 0.2s ease;
        }

        .btn-outline-primary-custom:hover {
            background-color: var(--primary);
            color: white;
            transform: scale(1.02);
        }

        .btn-outline-primary-custom:active { transform: scale(0.98); }

        /* ─── Book Cover ─── */
        .book-cover-img {
            width: 96px;
            height: 144px;
            object-fit: cover;
            border-radius: 0.5rem;
            flex-shrink: 0;
        }

        /* ─── Status Badges ─── */
        .badge-returned    { background-color: var(--surface-container-high); color: #555; }
        .badge-borrowed    { background-color: rgba(249, 115, 22, 0.1); color: var(--primary); }
        .badge-overdue     { background-color: var(--error-container); color: var(--error); }
        .badge-due-soon    { background-color: rgba(234, 179, 8, 0.12); color: #854d0e; }
        .badge-pending     { background-color: rgba(0, 99, 152, 0.1); color: var(--tertiary); }

        /* ─── Table ─── */
        .table > :not(caption) > * > * { border-color: rgba(224, 192, 177, 0.3); }
        .table-hover tbody tr:hover td  { background-color: var(--surface-container-low); }

        /* ─── Header notification dot ─── */
        .notif-dot {
            position: absolute;
            top: 6px;
            right: 6px;
            width: 8px;
            height: 8px;
            background-color: var(--primary);
            border-radius: 50%;
        }

        @media (max-width: 991.98px) {
            .header-search-input { width: 100%; }
        }
    </style>
</head>
