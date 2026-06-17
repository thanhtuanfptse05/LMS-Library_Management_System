<%-- Fragment: _head.jsp — <head> block cho Sinh viên Dashboard --%>
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Bảng điều khiển Sinh viên - Thư viện Đại học LMS</title>
    <meta name="description" content="Quản lý sách mượn, đặt chỗ và khám phá sách được đề xuất trên bảng điều khiển thư viện cá nhân của sinh viên." />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,300..800;1,14..32,300..800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/assets/css/lms-dashboard.css" rel="stylesheet" />

    <style>
        /* ─── Student-specific token overrides ─── */
        :root {
            --background: #f7f9fb;
            --on-background: #191c1e;
            --on-surface: #191c1e;
            --on-surface-variant: #584237;
            --surface-container-lowest: #ffffff;
            --surface-container-low: #f2f4f6;
            --surface-container: #eceef0;
            --surface-container-high: #e6e8ea;
            --outline-variant: #e0c0b1;
            --secondary-container: #fdd6a9;
            --on-secondary-container: #785c38;
        }

        /* Book Cover */
        .book-cover-img {
            width: 88px;
            height: 132px;
            object-fit: cover;
            border-radius: var(--radius-md);
            flex-shrink: 0;
            box-shadow: var(--shadow-sm);
            transition: transform var(--transition-base);
        }
        .book-cover-img:hover { transform: scale(1.04); }

        /* Status Badges (activity table) */
        .badge-returned  { background-color: var(--surface-container-high); color: #555; }
        .badge-borrowed  { background-color: rgba(249,115,22,0.1); color: var(--primary); }
        .badge-overdue   { background-color: var(--error-container); color: var(--error); }
        .badge-due-soon  { background-color: rgba(234,179,8,0.12); color: #854d0e; }
        .badge-pending   { background-color: rgba(0,99,152,0.1); color: var(--tertiary); }

        /* Book-list item */
        .book-list-item {
            display: flex;
            gap: 14px;
            padding: 14px;
            border-radius: var(--radius-md);
            background: var(--surface-container-low);
            border: 1px solid var(--outline-variant);
            transition: all var(--transition-base);
        }
        .book-list-item:hover {
            background: var(--surface-container);
            transform: translateX(3px);
            border-color: var(--primary-fixed-dim);
        }
    </style>
</head>
