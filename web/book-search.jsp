<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Search Results | UniLib LMS</title>

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
                        href="${pageContext.request.contextPath}/">Home</a>
                    <a class="text-secondary-custom text-decoration-none link-primary-hover" href="${pageContext.request.contextPath}/#services"
                        onmouseover="this.style.color='var(--primary-color)'"
                        onmouseout="this.style.color='var(--secondary)'">Services</a>
                    <a class="text-secondary-custom text-decoration-none link-primary-hover" href="${pageContext.request.contextPath}/#policies"
                        onmouseover="this.style.color='var(--primary-color)'"
                        onmouseout="this.style.color='var(--secondary)'">Policies</a>
                    <a class="text-secondary-custom text-decoration-none link-primary-hover" href="${pageContext.request.contextPath}/#news"
                        onmouseover="this.style.color='var(--primary-color)'"
                        onmouseout="this.style.color='var(--secondary)'">News</a>
                    <a class="text-secondary-custom text-decoration-none link-primary-hover" href="${pageContext.request.contextPath}/#contact"
                        onmouseover="this.style.color='var(--primary-color)'"
                        onmouseout="this.style.color='var(--secondary)'">Contact</a>
                </nav>
            </div>
            <div class="d-flex align-items-center gap-4">
                <!-- Form tìm kiếm nhanh tại header công cộng -->
                <form action="${pageContext.request.contextPath}/book-search.jsp" method="GET" class="d-none d-md-flex align-items-center search-container">
                    <span class="material-symbols-outlined text-secondary-custom me-2">search</span>
                    <input name="query" placeholder="Search resources..." type="text" value="<c:out value="${param.query}"/>" />
                </form>
                
                <!-- Chuyển hướng Sign In động -->
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary-custom text-decoration-none d-inline-flex align-items-center justify-content-center">
                    Sign In
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
                        Search Info
                    </h2>
                    <form action="${pageContext.request.contextPath}/book-search.jsp" method="GET" class="d-flex flex-column gap-4">
                        <!-- Truyền lại từ khóa tìm kiếm khi submit bộ lọc -->
                        <input type="hidden" name="query" value="<c:out value="${param.query}"/>" />
                        
                        <div>
                            <span class="d-block text-secondary-custom fw-bold text-uppercase small tracking-wider mb-2"
                                style="font-size: 12px; letter-spacing: 0.05em;">Category</span>
                            <div class="d-flex flex-column gap-2">
                                <label class="d-flex align-items-center gap-2 cursor-pointer group">
                                    <input checked class="form-check-input mt-0" type="checkbox"
                                        style="border-color: var(--outline-variant); shadow: none;" />
                                    <span class="text-on-surface">Books</span>
                                </label>
                                <label class="d-flex align-items-center gap-2 cursor-pointer group">
                                    <input class="form-check-input mt-0" type="checkbox"
                                        style="border-color: var(--outline-variant);" />
                                    <span class="text-on-surface">News</span>
                                </label>
                                <label class="d-flex align-items-center gap-2 cursor-pointer group">
                                    <input class="form-check-input mt-0" type="checkbox"
                                        style="border-color: var(--outline-variant);" />
                                    <span class="text-on-surface">Instructions</span>
                                </label>
                                <label class="d-flex align-items-center gap-2 cursor-pointer group">
                                    <input class="form-check-input mt-0" type="checkbox"
                                        style="border-color: var(--outline-variant);" />
                                    <span class="text-on-surface">Policies</span>
                                </label>
                            </div>
                        </div>

                        <div class="pt-3 border-top border-outline-variant">
                            <span class="d-block text-secondary-custom fw-bold text-uppercase small tracking-wider mb-2"
                                style="font-size: 12px; letter-spacing: 0.05em;">Availability</span>
                            <div class="d-flex flex-column gap-2">
                                <label class="d-flex align-items-center gap-2 cursor-pointer">
                                    <input checked class="form-check-input mt-0" name="availability" type="radio"
                                        style="border-color: var(--outline-variant);" />
                                    <span class="text-on-surface">Available Now</span>
                                </label>
                                <label class="d-flex align-items-center gap-2 cursor-pointer">
                                    <input class="form-check-input mt-0" name="availability" type="radio"
                                        style="border-color: var(--outline-variant);" />
                                    <span class="text-on-surface">E-Resources Only</span>
                                </label>
                            </div>
                        </div>

                        <div class="pt-3 border-top border-outline-variant">
                            <span class="d-block text-secondary-custom fw-bold text-uppercase small tracking-wider mb-2"
                                style="font-size: 12px; letter-spacing: 0.05em;">Date Range</span>
                            <select
                                class="form-select bg-surface-lowest border border-outline-variant rounded-3 p-2 small shadow-none">
                                <option>Last 5 years</option>
                                <option>Last 10 years</option>
                                <option>Anytime</option>
                            </select>
                        </div>

                        <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/book-search.jsp'" class="w-100 py-2 btn-clear-filter rounded-3 mt-2">
                            Clear All Filters
                        </button>
                    </form>
                </div>

                <div class="bg-primary-custom text-on-primary rounded-xl p-4 shadow-soft">
                    <span class="material-symbols-outlined fs-1 mb-2">help_center</span>
                    <h3 class="fs-5 fw-bold mb-1">Need help?</h3>
                    <p class="small opacity-75 mb-3">Our librarians are available for live chat support during business
                        hours.</p>
                    <a href="${pageContext.request.contextPath}/login"
                        class="btn btn-light text-primary-custom px-4 py-2 rounded-3 fw-bold w-100 shadow-sm border-0 small text-decoration-none d-block text-center">
                        Chat with Staff
                    </a>
                </div>
            </aside>

            <!-- Vùng hiển thị kết quả -->
            <section class="col-12 col-md-9 d-flex flex-column gap-3">
                <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2 mb-2">
                    <h1 class="fs-4 fw-bold m-0">
                        Search Results for <span class="text-primary-custom">"<c:out value="${not empty param.query ? param.query : 'Quantum Physics Foundations'}"/>"</span>
                    </h1>
                    <p class="small text-secondary-custom m-0">Showing 1-12 of 148 results</p>
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
                                                            <span class="badge bg-success-subtle text-success px-3 py-2 rounded-full-custom small">In Library</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger-subtle text-danger px-3 py-2 rounded-full-custom small">Checked Out</span>
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
                                                   class="btn bg-primary-container text-on-primary px-4 py-2 rounded-3 small border-0 fw-semibold text-decoration-none d-inline-flex align-items-center justify-content-center">Read More</a>
                                                <button class="btn border border-secondary-subtle text-secondary-custom px-4 py-2 rounded-3 small fw-semibold bg-transparent">Locate on Shelf</button>
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
                                                <span class="badge bg-success-subtle text-success px-3 py-2 rounded-full-custom small">In Library</span>
                                                <span class="material-symbols-outlined text-secondary-custom cursor-pointer" style="cursor: pointer;">bookmark</span>
                                            </div>
                                            <h3 class="fs-5 fw-bold text-on-surface mb-1">Foundations of Modern Quantum Physics</h3>
                                            <p class="small text-secondary-custom mb-2">Dr. Elena Rostova | Oxford University Press, 2022</p>
                                            <p class="text-on-surface-variant line-clamp-2 mb-3">This comprehensive guide explores the core principles of quantum mechanics, from wave-particle duality to entanglement theory, with updated research from CERN...</p>
                                        </div>
                                        <div class="d-flex gap-2">
                                            <button class="btn bg-primary-container text-on-primary px-4 py-2 rounded-3 small border-0 fw-semibold">Read More</button>
                                            <button class="btn border border-secondary-subtle text-secondary-custom px-4 py-2 rounded-3 small fw-semibold bg-transparent">Locate on Shelf</button>
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
                                            <span class="text-secondary-custom fw-bold text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;">Instruction</span>
                                        </div>
                                        <h3 class="fs-5 fw-bold text-on-surface mb-1">How to Cite Physics Journals: APA 7th Edition</h3>
                                        <p class="small text-on-surface-variant mb-4">A step-by-step guide on referencing complex quantum physics papers and digital datasets within the university library system.</p>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mt-auto">
                                        <span class="small text-secondary-custom">Updated: Oct 12, 2023</span>
                                        <button class="btn btn-link p-0 text-primary-custom fw-bold text-decoration-none small">Download PDF</button>
                                    </div>
                                </article>
                            </div>

                            <!-- Thẻ sách mẫu 3 -->
                            <div class="col-12 col-lg-6">
                                <article class="glass-card rounded-xl p-4 h-100 shadow-soft border border-outline-variant hover-border-primary d-flex flex-column justify-content-between">
                                    <div>
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <span class="material-symbols-outlined text-primary-custom small">book</span>
                                            <span class="text-secondary-custom fw-bold text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;">Book</span>
                                        </div>
                                        <h3 class="fs-5 fw-bold text-on-surface mb-1">Introduction to Particle Dynamics</h3>
                                        <p class="small text-secondary-custom mb-4">James Miller | 2019</p>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mt-auto">
                                        <span class="badge bg-danger-subtle text-danger px-3 py-2 rounded-full-custom small">Checked Out</span>
                                        <button class="btn bg-surface-highest text-secondary-custom px-4 py-2 rounded-3 small border-0 fw-semibold">Place Hold</button>
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
                                            <span class="text-secondary-custom fw-bold text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;">Library News</span>
                                        </div>
                                        <h3 class="fs-5 fw-bold text-on-surface mb-1">New Quantum Lab Equipment Now Available for Student Projects</h3>
                                        <p class="small text-on-surface-variant line-clamp-1 m-0">The physics department has expanded its resource pool with three new high-precision spectrometers...</p>
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
                                            <span class="text-secondary-custom fw-bold text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;">Policy</span>
                                        </div>
                                        <h3 class="fs-5 fw-bold text-on-surface mb-1">Borrowing Rules for Restricted Science Journals</h3>
                                        <p class="small text-on-surface-variant mb-4">Learn about the specific borrowing limits and return policies for rare and fragile scientific texts in our special collections.</p>
                                    </div>
                                    <a class="text-primary-custom fw-bold text-decoration-none d-inline-flex align-items-center gap-1 small mt-auto" href="#">
                                        Read Policy <span class="material-symbols-outlined small">open_in_new</span>
                                    </a>
                                </article>
                            </div>

                            <!-- Thẻ sách mẫu 6 -->
                            <div class="col-12 col-lg-6">
                                <article class="glass-card rounded-xl p-4 h-100 shadow-soft border border-outline-variant hover-border-primary d-flex flex-column justify-content-between">
                                    <div>
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <span class="material-symbols-outlined text-primary-custom small">book</span>
                                            <span class="text-secondary-custom fw-bold text-uppercase" style="font-size: 11px; letter-spacing: 0.05em;">Book</span>
                                        </div>
                                        <h3 class="fs-5 fw-bold text-on-surface mb-1">The Quantum Age: History and Future</h3>
                                        <p class="small text-secondary-custom mb-4">Marcus Thorne | 2024</p>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mt-auto">
                                        <span class="badge bg-success-subtle text-success px-3 py-2 rounded-full-custom small">Available</span>
                                        <button class="btn bg-primary-container text-on-primary px-4 py-2 rounded-3 small border-0 fw-semibold">Request</button>
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
                <p class="small text-secondary-custom mt-2 mb-0">Empowering academic excellence through organized knowledge.</p>
            </div>
            <div class="d-flex flex-wrap justify-content-center gap-3">
                <a class="text-secondary-custom small text-decoration-underline fw-bold" href="#">Instructions</a>
                <a class="text-secondary-custom small text-decoration-underline fw-bold" href="#">Privacy Policy</a>
                <a class="text-secondary-custom small text-decoration-underline fw-bold" href="#">Terms of Service</a>
                <a class="text-secondary-custom small text-decoration-underline fw-bold" href="#">FAQ</a>
                <a class="text-secondary-custom small text-decoration-underline fw-bold" href="${pageContext.request.contextPath}/login">Staff Login</a>
            </div>
        </div>
        <div class="w-100 text-center py-3 border-top border-secondary-subtle" style="--bs-border-opacity: .3;">
            <p class="small text-secondary-custom m-0">© 2024 LMS University Library System. All rights reserved.</p>
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
