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
            /* Librarian-specific token overrides matching ui_rule.md */
            :root {
                --primary: #d97706;
                --primary-hover: #b45309;
                --primary-container: #fef3c7;
                --primary-fixed: #fde68a;
                --primary-fixed-dim: #fcd34d;
                --on-primary-container: #78350f;
                --background: #faf9f8;
                --on-background: #262626;
                --surface: #ffffff;
                --on-surface: #262626;
                --on-surface-variant: #737373;
                --secondary-fixed: #e5e5e5;
                --secondary-fixed-dim: #d4d4d4;
                --on-secondary-fixed: #171717;
                --on-secondary-fixed-variant: #404040;
                --surface-container-lowest: #ffffff;
                --surface-container-low: #f5f5f5;
                --surface-container: #e5e5e5;
                --surface-container-high: #d4d4d4;
                --surface-container-highest: #a3a3a3;
                --surface-variant: #f5f5f5;
                --outline: #737373;
                --outline-variant: #e5e5e5;
                --error: #ef4444;
                --error-container: #fee2e2;
                --success: #10b981;
                --success-container: #d1fae5;
                --warning: #f59e0b;
                --warning-container: #fef3c7;
            }
        </style>
    </head>
