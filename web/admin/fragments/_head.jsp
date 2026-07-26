<%-- Fragment: _head.jsp — <head> block for Admin Dashboard --%>
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Bảng điều khiển Quản trị viên - Thư viện Đại học LMS</title>
    <meta name="description" content="System administration panel for LMS University Library — manage users, configurations, and audit logs." />

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,300..800;1,14..32,300..800&display=swap" rel="stylesheet" />
    <%-- Font icon ligature: bắt buộc display=block. Dùng swap sẽ lòi chữ nguồn ("menu_book") ra màn hình. --%>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=block" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/assets/css/lms-dashboard.css" rel="stylesheet" />

    <style>
        /* Admin-specific overrides */
        :root {
            --background: #f7f9fb;
            --on-background: #191c1e;
            --on-surface: #191c1e;
            --on-surface-variant: #584237;
            --secondary-container: #dae2fd;
            --on-secondary-container: #5c647a;
            --secondary-fixed: #dae2fd;
            --secondary-fixed-dim: #bec6e0;
            --on-secondary-fixed: #131b2e;
            --on-secondary-fixed-variant: #3f465c;
            --surface-container-lowest: #ffffff;
            --surface-container-low: #f2f4f6;
            --surface-container: #eceef0;
            --surface-container-high: #e6e8ea;
            --surface-container-highest: #e0e3e5;
            --surface-variant: #e0e3e5;
            --outline: #8c7164;
            --outline-variant: #e0c0b1;
        }
    </style>
</head>
