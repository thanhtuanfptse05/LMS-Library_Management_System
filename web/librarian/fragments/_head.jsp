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
        <link href="${pageContext.request.contextPath}/assets/css/book-management.css?v=20260622-1" rel="stylesheet" />

        <style>
            /* Librarian-specific token overrides (warm library brand matching manager) */
            :root {
                --background: #fff8f6;
                --on-background: #251913;
                --on-surface: #251913;
                --on-surface-variant: #584237;
                --secondary-container: #fdd6a9;
                --on-secondary-container: #785c38;
                --secondary-fixed: #ffddb7;
                --secondary-fixed-dim: #e6c095;
                --on-secondary-fixed: #2a1800;
                --on-secondary-fixed-variant: #5b4220;
                --surface-container-lowest: #ffffff;
                --surface-container-low: #fff1eb;
                --surface-container: #ffeae0;
                --surface-container-high: #efe3d9;
                --surface-container-highest: #e9dcd4;
                --surface-variant: #f5e0d2;
                --outline: #8c7164;
                --outline-variant: #e0c0b1;
            }
        </style>
    </head>
