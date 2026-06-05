<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Kết quả tìm kiếm | UniLib LMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
        rel="stylesheet" />

    <style>
        /* Khai báo hệ màu và cấu hình tương đương Tailwind tùy chỉnh trước đó */
        :root {
            --bs-body-font-family: 'Inter', sans-serif;
            --primary-color: #9d4300;
            --primary-container: #f97316;
            --on-primary: #ffffff;
            --secondary: #565e74;
            --on-surface: #191c1e;
            --on-surface-variant: #584237;
            --surface-container-lowest: #ffffff;
            --surface-container-low: #f2f4f6;
            --surface-container: #eceef0;
            --surface-container-highest: #e0e3e5;
            --outline-variant: #e0c0b1;
            --outline: #8c7164;
        }

        body {
            background-color: #f7f9fb;
            color: var(--on-surface);
            font-size: 16px;
            line-height: 24px;
        }

        /* Tiện ích màu sắc tùy chỉnh */
        .text-primary-custom {
            color: var(--primary-color);
        }

        .bg-primary-custom {
            background-color: var(--primary-color);
        }

        .text-secondary-custom {
            color: var(--secondary);
        }

        .bg-primary-container {
            background-color: var(--primary-container);
        }

        .text-on-primary {
            color: var(--on-primary);
        }

        .bg-surface-lowest {
            background-color: var(--surface-container-lowest);
        }

        .bg-surface-low {
            background-color: var(--surface-container-low);
        }

        .bg-surface-container {
            background-color: var(--surface-container);
        }

        .bg-surface-highest {
            background-color: var(--surface-container-highest);
        }

        .border-outline-variant {
            border-color: var(--outline-variant) !important;
        }

        .text-on-surface-variant {
            color: var(--on-surface-variant);
        }

        /* Giả lập Glassmorphism & Bo góc đặc thù */
        .glass-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .rounded-xl {
            border-radius: 0.75rem !important;
        }

        .rounded-full-custom {
            border-radius: 9999px !important;
        }

        /* Hiệu ứng bóng mềm */
        .shadow-soft {
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
        }

        /* Material Icons hiệu chỉnh căn giữa dọc */
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
        }

        /* Tối ưu ô tìm kiếm */
        .search-container {
            background-color: var(--surface-container-low);
            border: 1px solid var(--outline-variant);
            border-radius: 0.75rem;
            padding: 0.5rem 1rem;
            width: 320px;
            transition: all 0.2s ease-in-out;
        }

        .search-container:focus-within {
            border-color: var(--primary-color) !important;
            box-shadow: 0 0 0 2px rgba(157, 67, 0, 0.2);
        }

        .search-container input {
            background: transparent;
            border: none;
            outline: none;
            width: 100%;
            font-size: 14px;
        }

        .search-container input:focus {
            box-shadow: none;
            outline: none;
        }

        /* Nút tùy chỉnh */
        .btn-primary-custom {
            background-color: var(--primary-container);
            color: var(--on-primary);
            border-radius: 9999px;
            padding: 0.5rem 1.5rem;
            font-weight: 600;
            font-size: 12px;
            letter-spacing: 0.05em;
            border: none;
            transition: opacity 0.2s;
        }

        .btn-primary-custom:hover {
            opacity: 0.9;
            color: var(--on-primary);
        }

        .btn-clear-filter {
            background-color: var(--surface-container-highest);
            color: var(--primary-color);
            font-weight: 600;
            font-size: 12px;
            border: none;
            transition: all 0.2s;
        }

        .btn-clear-filter:hover {
            background-color: var(--primary-color);
            color: var(--on-primary);
        }

        /* Định dạng giới hạn dòng (Line Clamp) */
        .line-clamp-1 {
            display: -webkit-box;
            -webkit-line-clamp: 1;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .line-clamp-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        /* Định dạng khung ảnh */
        .img-cover-wrapper {
            width: 100%;
            height: 192px;
        }

        @media (min-width: 768px) {
            .img-cover-wrapper {
                width: 128px;
                height: 192px;
            }
        }

        /* Card tương tác */
        .hover-translate:hover {
            transform: translateY(-2px);
            transition: transform 0.2s ease-in-out;
        }

        .border-l-primary-custom {
            border-left: 4px solid var(--primary-color) !important;
        }

        .hover-border-primary:hover {
            border-color: var(--primary-color) !important;
            transition: border-color 0.2s ease-in-out;
        }

        /* Header dính có hiệu ứng mờ */
        header.sticky-top {
            transition: all 0.2s ease-in-out;
        }

        .backdrop-blur {
            backdrop-filter: blur(12px);
            background-color: rgba(255, 255, 255, 0.9) !important;
        }

        /* Tùy chỉnh phân trang */
        .pagination-custom .btn {
            width: 40px;
            height: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0;
        }

        .pagination-custom .btn-active {
            background-color: var(--primary-color) !important;
            color: #fff !important;
            border: none;
        }
    </style>
</head>

<body class="min-vh-screen d-flex flex-column">

    <!-- Header điều hướng -->
    <header class="bg-surface-lowest sticky-top shadow-sm">
        <div class="container-xl d-flex justify-content-between align-items-center py-3 px-4">
            <div class="d-flex align-items-center">
                <a class="fs-5 fw-bold text-primary-custom text-decoration-none me-4" href="${pageContext.request.contextPath}/">UniLib LMS</a>
                <nav class="d-none d-md-flex gap-4 ms-4">
                    <a class="text-primary-custom fw-semibold border-bottom border-2 border-primary-custom pb-1 text-decoration-none"
                        href="${pageContext.request.contextPath}/">Trang chủ</a>
                    <a class="text-secondary-custom text-decoration-none link-primary-hover" href="${pageContext.request.contextPath}/services.jsp"
                        onmouseover="this.style.color='var(--primary-color)'"
                        onmouseout="this.style.color='var(--secondary)'">Dịch vụ</a>
                    <a class="text-secondary-custom text-decoration-none link-primary-hover" href="${pageContext.request.contextPath}/policies.jsp"
                        onmouseover="this.style.color='var(--primary-color)'"
                        onmouseout="this.style.color='var(--secondary)'">Chính sách</a>
                    <a class="text-secondary-custom text-decoration-none link-primary-hover" href="${pageContext.request.contextPath}/news.jsp"
                        onmouseover="this.style.color='var(--primary-color)'"
                        onmouseout="this.style.color='var(--secondary)'">Tin tức</a>
                    <a class="text-secondary-custom text-decoration-none link-primary-hover" href="${pageContext.request.contextPath}/#contact"
                        onmouseover="this.style.color='var(--primary-color)'"
                        onmouseout="this.style.color='var(--secondary)'">Liên hệ</a>
                </nav>
            </div>
            <div class="d-flex align-items-center gap-4">
                <!-- Form tìm kiếm nhanh tại header công cộng -->
                <form action="${pageContext.request.contextPath}/book-search.jsp" method="GET" class="d-none d-md-flex align-items-center search-container">
                    <span class="material-symbols-outlined text-secondary-custom me-2">search</span>
                    <input name="query" placeholder="Tìm kiếm tài nguyên..." type="text" value="<c:out value="${param.query}"/>" />
                </form>
                
                <!-- Chuyển hướng Sign In động -->
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary-custom text-decoration-none d-inline-flex align-items-center justify-content-center">
                    Đăng nhập
                </a>
            </div>
        </div>
    </header>

    <main class="flex-grow-1 container-xl py-4 px-4">
        <div class="row g-4">

            <!-- Bộ lọc bên cạnh -->
            <aside class="col-12 col-md-3 flex-column d-flex gap-4">
                <div class="bg-surface-low rounded-xl p-4 shadow-soft border border-outline-variant">
                    <h2 class="fs-5 fw-bold mb-4 d-flex align-items-center gap-2">
                        <span class="material-symbols-outlined text-primary-custom">filter_list</span>
                        Thông tin tìm kiếm
                    </h2>
                    <form action="${pageContext.request.contextPath}/book-search.jsp" method="GET" class="d-flex flex-column gap-4">
                        <!-- Truyền lại từ khóa tìm kiếm khi submit bộ lọc -->
                        <input type="hidden" name="query" value="<c:out value="${param.query}"/>" />
                        
                        <div>
                            <span class="d-block text-secondary-custom fw-bold text-uppercase small tracking-wider mb-2"
                                style="font-size: 12px; letter-spacing: 0.05em;">Thể loại</span>
                            <div class="d-flex flex-column gap-2">
                                <label class="d-flex align-items-center gap-2 cursor-pointer group">
                                    <input checked class="form-check-input mt-0" type="checkbox"
                                        style="border-color: var(--outline-variant); shadow: none;" />
                                    <span class="text-on-surface">Sách</span>
                                </label>
                                <label class="d-flex align-items-center gap-2 cursor-pointer group">
                                    <input class="form-check-input mt-0" type="checkbox"
                                        style="border-color: var(--outline-variant);" />
                                    <span class="text-on-surface">Tin tức</span>
                                </label>
                                <label class="d-flex align-items-center gap-2 cursor-pointer group">
                                    <input class="form-check-input mt-0" type="checkbox"
                                        style="border-color: var(--outline-variant);" />
                                    <span class="text-on-surface">Hướng dẫn</span>
                                </label>
                                <label class="d-flex align-items-center gap-2 cursor-pointer group">
                                    <input class="form-check-input mt-0" type="checkbox"
                                        style="border-color: var(--outline-variant);" />
                                    <span class="text-on-surface">Chính sách</span>
                                </label>
                            </div>
                        </div>

                        <div class="pt-3 border-top border-outline-variant">
                            <span class="d-block text-secondary-custom fw-bold text-uppercase small tracking-wider mb-2"
                                style="font-size: 12px; letter-spacing: 0.05em;">Tình trạng khả dụng</span>
                            <div class="d-flex flex-column gap-2">
                                <label class="d-flex align-items-center gap-2 cursor-pointer">
                                    <input checked class="form-check-input mt-0" name="availability" type="radio"
                                        style="border-color: var(--outline-variant);" />
                                    <span class="text-on-surface">Sẵn sàng ngay</span>
                                </label>
                                <label class="d-flex align-items-center gap-2 cursor-pointer">
                                    <input class="form-check-input mt-0" name="availability" type="radio"
                                        style="border-color: var(--outline-variant);" />
                                    <span class="text-on-surface">Chỉ tài nguyên điện tử</span>
                                </label>
                            </div>
                        </div>

                        <div class="pt-3 border-top border-outline-variant">
                            <span class="d-block text-secondary-custom fw-bold text-uppercase small tracking-wider mb-2"
                                style="font-size: 12px; letter-spacing: 0.05em;">Khoảng thời gian</span>
                            <select
                                class="form-select bg-surface-lowest border border-outline-variant rounded-3 p-2 small shadow-none">
                                <option>5 năm qua</option>
                                <option>10 năm qua</option>
                                <option>Bất kỳ lúc nào</option>
                            </select>
                        </div>

                        <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/book-search.jsp'" class="w-100 py-2 btn-clear-filter rounded-3 mt-2">
                            Xóa tất cả bộ lọc
                        </button>
                    </form>
                </div>

                <div class="bg-primary-custom text-on-primary rounded-xl p-4 shadow-soft">
                    <span class="material-symbols-outlined fs-1 mb-2">help_center</span>
                    <h3 class="fs-5 fw-bold mb-1">Cần trợ giúp?</h3>
                    <p class="small opacity-75 mb-3">Các thủ thư của chúng tôi sẵn sàng hỗ trợ qua trò chuyện trực tiếp trong giờ làm việc.</p>
                    <a href="${pageContext.request.contextPath}/login"
                        class="btn btn-light text-primary-custom px-4 py-2 rounded-3 fw-bold w-100 shadow-sm border-0 small text-decoration-none d-block text-center">
                        Trò chuyện với nhân viên
                    </a>
                </div>
            </aside>

            <!-- Vùng hiển thị kết quả -->
            <section class="col-12 col-md-9 d-flex flex-column gap-3">
                <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 mb-2">
                    <h1 class="fs-4 fw-bold m-0">
                        Kết quả tìm kiếm cho <span class="text-primary-custom">"<c:out value="${not empty param.query ? param.query : 'Nền tảng Vật lý Lượng tử'}"/>"</span>
                    </h1>
                    <p class="small text-secondary-custom m-0">Hiển thị 1-12 trong số 148 kết quả</p>
                </div>

                <div class="row g-3">

                    <!-- XỬ LÝ DỮ LIỆU ĐỘNG TỪ SERVLET HOẶC DỰ PHÒNG MOCKUP -->
                    <c:choose>
                        <c:when test="${not empty books}">
                            <!-- Sử dụng JSTL c:forEach để lặp qua danh sách sách thật truyền từ Backend -->
                            <c:forEach var="book" items="${books}">
                                <article class="col-12">
                                    <div class="glass-card rounded-xl p-4 d-flex flex-column flex-md-row gap-4 shadow-soft border-l-primary-custom hover-translate">
                                        <div class="img-cover-wrapper flex-shrink-0 bg-surface-container rounded-3 overflow-hidden">
                                            <img alt="Book Cover" class="w-100 h-100 object-fit-cover"
                                                src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?q=80&w=387&auto=format&fit=cover" />
                                        </div>
                                        <div class="flex-grow-1 d-flex flex-column justify-content-between">
                                            <div>
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <c:choose>
                                                        <c:when test="${book.availableQuantity > 0}">
                                                            <span class="badge bg-success-subtle text-success px-3 py-2 rounded-full-custom small">Trong thư viện</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger-subtle text-danger px-3 py-2 rounded-full-custom small">Đang mượn</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <span class="material-symbols-outlined text-secondary-custom cursor-pointer" style="cursor: pointer;">bookmark</span>
                                                </div>
                                                <h3 class="fs-5 fw-bold text-on-surface mb-1"><c:out value="${book.title}"/></h3>
                                                <p class="small text-secondary-custom mb-2"><c:out value="${book.author}"/> | <c:out value="${book.publisher}"/>, <c:out value="${book.publicationYear}"/></p>
                                                <p class="text-on-surface-variant line-clamp-2 mb-3">
                                                    ISBN: <c:out value="${book.isbn}"/> - Chi tiết sách và sơ đồ vị trí kệ có sẵn trong thư viện.
                                                </p>
                                            </div>
                                            <div class="d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/student/book-detail?id=${book.bookId}"
                                                   class="btn bg-primary-container text-on-primary px-4 py-2 rounded-3 small border-0 fw-semibold text-decoration-none d-inline-flex align-items-center justify-content-center">Đọc thêm</a>
                                                <button class="btn border border-secondary-subtle text-secondary-custom px-4 py-2 rounded-3 small fw-semibold bg-transparent">Vị trí trên giá</button>
                                            </div>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <!-- KỊCH BẢN DỰ PHÒNG: HIỂN THỊ MẪU TĨNH SANG TRỌNG NHƯ BẢN HTML KHI CHƯA TRUYỀN DATA BACKEND -->
                            
                            <!-- Thẻ sách mẫu 1 -->
                            <article class="col-12">
                                <div class="glass-card rounded-xl p-4 d-flex flex-column flex-md-row gap-4 shadow-soft border-l-primary-custom hover-translate">
                                    <div class="img-cover-wrapper flex-shrink-0 bg-surface-container rounded-3 overflow-hidden">
                                        <img alt="Book Cover" class="w-100 h-100 object-fit-cover"
                                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuCXeMGmhwMbOfodzo3y8KaJpt_p8ogKaM0c_cOC8P_RjnHLYXIObWGWnxjb9lHMt5A_i-OPlOfwA6h-_9bSkvDe-H4agmDrucTR4E1psBYY51pGwCtOWQ94OIcTSnayufQalHjmRH9R5vbvgSsnpObn4E4xwxDL4vZxBYD9kqVeZbdguAM6enHXAIbC4WFfI4Eb8JGpj3cS_uCHTIKqPS9xw0M-323i7408liM3Dp8TJ9wxf3VdYvB1Ot5496W7sCsklpoqLB660oRJ" />
                                    </div>
                                    <div class="flex-grow-1 d-flex flex-column justify-content-between">
                                        <div>
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <span class="badge bg-success-subtle text-success px-3 py-2 rounded-full-custom small">Trong thư viện</span>
                                                <span class="material-symbols-outlined text-secondary-custom cursor-pointer" style="cursor: pointer;">bookmark</span>
                                            </div>
                                            <h3 class="fs-5 fw-bold text-on-surface mb-1">Nền tảng của Vật lý Lượng tử Hiện đại</h3>
                                            <p class="small text-secondary-custom mb-2">Tiến sĩ Elena Rostova | Oxford University Press, 2022</p>
                                            <p class="text-on-surface-variant line-clamp-2 mb-3">Hướng dẫn toàn diện này khám phá các nguyên tắc cốt lõi của cơ học lượng tử, từ lưỡng tính sóng-hạt đến lý thuyết rối lượng tử, với các nghiên cứu cập nhật từ CERN...</p>
                                        </div>
                                        <div class="d-flex gap-2">
                                            <button class="btn bg-primary-container text-on-primary px-4 py-2 rounded-3 small border-0 fw-semibold">Đọc thêm</button>
                                            <button class="btn border border-secondary-subtle text-secondary-custom px-4 py-2 rounded-3 small fw-semibold bg-transparent">Vị trí trên giá</button>
                                        </div>
                                    </div>
                                </div>
                            </article>

                            <!-- Thẻ sách mẫu 2 -->
                            <div class="col-12 col-lg-6">
                                <article class="glass-card rounded-xl p-4 h-100 shadow-soft border border-outline-variant hover-border-primary d-flex flex-column justify-content-between">
                                    <div>
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <span class="material-symbols-outlined text-primary-custom small">article</span>
                                            <span class="text-secondary-custom fw-bold text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;">Hướng dẫn</span>
                                        </div>
                                        <h3 class="fs-5 fw-bold text-on-surface mb-1">Cách trích dẫn tạp chí vật lý: APA Phiên bản 7</h3>
                                        <p class="small text-on-surface-variant mb-4">Hướng dẫn từng bước về việc tham chiếu các bài báo vật lý lượng tử phức tạp và các bộ dữ liệu kỹ thuật số trong hệ thống thư viện đại học.</p>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mt-auto">
                                        <span class="small text-secondary-custom">Cập nhật: 12 tháng 10, 2023</span>
                                        <button class="btn btn-link p-0 text-primary-custom fw-bold text-decoration-none small">Tải xuống PDF</button>
                                    </div>
                                </article>
                            </div>

                            <!-- Thẻ sách mẫu 3 -->
                            <div class="col-12 col-lg-6">
                                <article class="glass-card rounded-xl p-4 h-100 shadow-soft border border-outline-variant hover-border-primary d-flex flex-column justify-content-between">
                                    <div>
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <span class="material-symbols-outlined text-primary-custom small">book</span>
                                            <span class="text-secondary-custom fw-bold text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;">Sách</span>
                                        </div>
                                        <h3 class="fs-5 fw-bold text-on-surface mb-1">Giới thiệu về Động lực học hạt</h3>
                                        <p class="small text-secondary-custom mb-4">James Miller | 2019</p>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mt-auto">
                                        <span class="badge bg-danger-subtle text-danger px-3 py-2 rounded-full-custom small">Đang mượn</span>
                                        <button class="btn bg-surface-highest text-secondary-custom px-4 py-2 rounded-3 small border-0 fw-semibold">Đặt giữ sách</button>
                                    </div>
                                </article>
                            </div>

                            <!-- Tin tức mẫu 4 -->
                            <div class="col-12">
                                <article class="glass-card rounded-xl p-4 shadow-soft border border-outline-variant d-flex align-items-center gap-4">
                                    <div class="d-none d-sm-block bg-surface-container rounded-3 flex-shrink-0" style="width: 96px; height: 96px;">
                                        <img alt="Physics Lab" class="w-100 h-100 object-fit-cover rounded-3"
                                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuD_2bXh41-8VLy9zawsSoWDbPYBpWEVlKKxZ3_t0_VNxEQ5qpJ3ObY2EzmhOMQgVyBcO_cGHnnpu4MnWWMt_NiuTciCcWTqlVgbKdbdax9EaJ9hhTUJITDBpO3ZTxJMIUz_FU5Wg0TlRHVy1JTj3sSY7b83U3pvJnZEJm9-lE5GfMT2UeY_tjb40_ReIT0eVNkV3QxEFl2qziHAy_huD-KKaGI4Sk-Kgjao-hYWm1meszWNCktLdGYNY1pxWxmyZxcQ3Wvjs9YOqvpf" />
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="d-flex align-items-center gap-2 mb-1">
                                            <span class="material-symbols-outlined text-primary-custom small">news</span>
                                            <span class="text-secondary-custom fw-bold text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;">Tin tức Thư viện</span>
                                        </div>
                                        <h3 class="fs-5 fw-bold text-on-surface mb-1">Thiết bị phòng thí nghiệm lượng tử mới hiện có sẵn cho các dự án của sinh viên</h3>
                                        <p class="small text-on-surface-variant line-clamp-1 m-0">Khoa vật lý đã mở rộng nhóm tài nguyên của mình với ba máy quang phổ có độ chính xác cao mới...</p>
                                    </div>
                                    <button class="btn bg-primary-custom text-on-primary p-0 d-flex align-items-center justify-content-center rounded-circle hover-translate shadow-none" style="width: 40px; height: 40px;">
                                        <span class="material-symbols-outlined">arrow_forward</span>
                                    </button>
                                </article>
                            </div>

                            <!-- Hướng dẫn mẫu 5 -->
                            <div class="col-12 col-lg-6">
                                <article class="glass-card rounded-xl p-4 h-100 shadow-soft border border-outline-variant hover-border-primary d-flex flex-column justify-content-between">
                                    <div>
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <span class="material-symbols-outlined text-primary-custom small">gavel</span>
                                            <span class="text-secondary-custom fw-bold text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;">Chính sách</span>
                                        </div>
                                        <h3 class="fs-5 fw-bold text-on-surface mb-1">Quy định mượn tạp chí khoa học hạn chế</h3>
                                        <p class="small text-on-surface-variant mb-4">Tìm hiểu về các giới hạn mượn cụ thể và chính sách trả lại đối với các văn bản khoa học hiếm và dễ hỏng trong các bộ sưu tập đặc biệt của chúng tôi.</p>
                                    </div>
                                    <a class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1 small mt-auto" href="#">
                                        Đọc chính sách <span class="material-symbols-outlined small">open_in_new</span>
                                    </a>
                                </article>
                            </div>

                            <!-- Thẻ sách mẫu 6 -->
                            <div class="col-12 col-lg-6">
                                <article class="glass-card rounded-xl p-4 h-100 shadow-soft border border-outline-variant hover-border-primary d-flex flex-column justify-content-between">
                                    <div>
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <span class="material-symbols-outlined text-primary-custom small">book</span>
                                            <span class="text-secondary-custom fw-bold text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;">Sách</span>
                                        </div>
                                        <h3 class="fs-5 fw-bold text-on-surface mb-1">Kỷ nguyên lượng tử: Lịch sử và Tương lai</h3>
                                        <p class="small text-secondary-custom mb-4">Marcus Thorne | 2024</p>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mt-auto">
                                        <span class="badge bg-success-subtle text-success px-3 py-2 rounded-full-custom small">Sẵn có</span>
                                        <button class="btn bg-primary-container text-on-primary px-4 py-2 rounded-3 small border-0 fw-semibold">Yêu cầu</button>
                                    </div>
                                </article>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Phân trang -->
                <nav class="d-flex align-items-center justify-content-center gap-2 py-4 pagination-custom">
                    <button class="btn border border-secondary-subtle text-secondary-custom bg-surface-low rounded-3">
                        <span class="material-symbols-outlined">chevron_left</span>
                    </button>
                    <button class="btn btn-active rounded-3 fw-bold">1</button>
                    <button class="btn border border-secondary-subtle text-secondary-custom rounded-3 fw-bold bg-transparent">2</button>
                    <button class="btn border border-secondary-subtle text-secondary-custom rounded-3 fw-bold bg-transparent">3</button>
                    <span class="text-secondary-custom px-1">...</span>
                    <button class="btn border border-secondary-subtle text-secondary-custom rounded-3 fw-bold bg-transparent">13</button>
                    <button class="btn border border-secondary-subtle text-secondary-custom bg-surface-low rounded-3">
                        <span class="material-symbols-outlined">chevron_right</span>
                    </button>
                </nav>
            </section>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-surface-highest mt-5">
        <div class="container-xl py-4 px-4 d-flex flex-column flex-md-row justify-content-between align-items-center gap-4">
            <div class="text-center text-md-start">
                <span class="fs-4 fw-bold text-primary-custom">UniLib LMS</span>
                <p class="small text-secondary-custom mt-2 mb-0">Trao quyền cho sự xuất sắc trong học thuật thông qua kiến thức được tổ chức.</p>
            </div>
            <div class="d-flex flex-wrap justify-content-center gap-3">
                <a class="text-secondary-custom small text-decoration-underline fw-bold" href="#">Hướng dẫn</a>
                <a class="text-secondary-custom small text-decoration-underline fw-bold" href="#">Chính sách bảo mật</a>
                <a class="text-secondary-custom small text-decoration-underline fw-bold" href="#">Điều khoản dịch vụ</a>
                <a class="text-secondary-custom small text-decoration-underline fw-bold" href="#">Câu hỏi thường gặp</a>
                <a class="text-secondary-custom small text-decoration-underline fw-bold" href="${pageContext.request.contextPath}/login">Đăng nhập Nhân viên</a>
            </div>
        </div>
        <div class="w-100 text-center py-3 border-top border-secondary-subtle" style="--bs-border-opacity: .3;">
            <p class="small text-secondary-custom m-0">© 2024 Hệ thống LMS Thư viện Đại học. Bản quyền đã được bảo lưu.</p>
        </div>
    </footer>

    <script>
        // Tạo hiệu ứng trong suốt cho header khi cuộn trang
        window.addEventListener('scroll', () => {
            const header = document.querySelector('header');
            if (header) {
                if (window.scrollY > 20) {
                    header.classList.add('backdrop-blur');
                } else {
                    header.classList.remove('backdrop-blur');
                }
            }
        });
    </script>
</body>

</html>
