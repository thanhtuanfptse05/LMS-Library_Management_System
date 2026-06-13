<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/common/_head.jsp" />

<style>
    /* Các tùy chỉnh riêng cho Book Search bám theo DESIGN.md */
    .search-card {
        border-radius: 0.75rem;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        border: 1px solid var(--outline-variant);
        background-color: var(--surface-lowest);
    }
    
    .book-img-wrapper {
        height: 240px;
        background-color: var(--surface-container-low);
        border-radius: 0.75rem 0.75rem 0 0;
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .book-img-wrapper img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.3s ease;
    }

    .book-card:hover .book-img-wrapper img {
        transform: scale(1.05);
    }

    .book-card {
        transition: transform 0.2s ease, box-shadow 0.2s ease;
        border-radius: 0.75rem;
        border: 1px solid var(--surface-container-high);
        background-color: var(--surface-lowest);
        height: 100%;
    }

    .book-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.08);
        border-color: var(--outline-variant);
    }

    .filter-section-title {
        font-size: 13px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        color: var(--text-muted-custom);
        margin-bottom: 0.75rem;
    }

    .pagination .page-item.active .page-link {
        background-color: var(--primary-color);
        border-color: var(--primary-color);
        color: white;
    }

    .pagination .page-link {
        color: var(--primary-color);
    }

    .badge-status-available {
        background-color: rgba(16, 185, 129, 0.1);
        color: #10b981;
    }

    .badge-status-borrowed {
        background-color: rgba(239, 68, 68, 0.1);
        color: #ef4444;
    }

    .text-truncate-2 {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
</style>

<body class="d-flex flex-column min-vh-100">

    <jsp:include page="/common/_header.jsp" />

    <!-- Breadcrumb & Tiêu đề chính (Hero Banner) -->
    <div class="py-5" style="background-color: var(--surface-container-low); border-bottom: 1px solid var(--surface-container-high);">
        <div class="container-xxl px-4">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-2" style="font-size: 14px;">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none" style="color: var(--primary-color);">Trang chủ</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Tra cứu mục lục</li>
                </ol>
            </nav>
            <h1 class="display-5 fw-bold mt-2 mb-3" style="color: var(--bs-body-color);">Khám phá tài liệu</h1>
            <p class="lead mb-0" style="color: var(--text-muted-custom); font-weight: 400;">
                <c:choose>
                    <c:when test="${not empty param.keyword}">
                        Hiển thị kết quả tìm kiếm cho từ khóa: <strong style="color: var(--primary-color);"><c:out value="${param.keyword}"/></strong>
                    </c:when>
                    <c:otherwise>
                        Tra cứu hàng ngàn đầu sách, tạp chí và tài liệu học thuật.
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
    </div>

    <!-- Nội dung chính -->
    <main class="container-xxl flex-grow-1 py-5 px-4">
        <div class="row g-4">
            
            <!-- Sidebar Lọc -->
            <aside class="col-12 col-lg-3">
                <div class="search-card p-4 sticky-top" style="top: 20px;">
                    <h5 class="fw-bold mb-4 d-flex align-items-center gap-2" style="color: var(--bs-body-color);">
                        <i class="bi bi-funnel"></i> Bộ lọc tìm kiếm
                    </h5>
                    
                    <form action="book-search" method="GET">
                        <!-- Lọc theo từ khóa -->
                        <div class="mb-4">
                            <label class="form-label filter-section-title">Từ khóa</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0" style="border-color: var(--outline-variant); color: var(--text-muted-custom);">
                                    <i class="bi bi-search"></i>
                                </span>
                                <input type="text" name="keyword" class="form-control border-start-0 ps-0" 
                                       placeholder="Tên sách, tác giả..." 
                                       value="<c:out value="${param.keyword}"/>"
                                       style="border-color: var(--outline-variant); box-shadow: none;">
                            </div>
                        </div>

                        <!-- Lọc theo danh mục -->
                        <div class="mb-4">
                            <label class="form-label filter-section-title">Thể loại</label>
                            <div class="d-flex flex-wrap gap-2">
                                <input type="radio" class="btn-check" name="categoryId" id="cat_0" value="0" ${empty param.categoryId or param.categoryId == '0' ? 'checked' : ''}>
                                <label class="btn btn-outline-primary btn-sm" for="cat_0">Tất cả</label>
                                <c:forEach var="cat" items="${categories}">
                                    <input type="radio" class="btn-check" name="categoryId" id="cat_${cat.categoryId}" value="${cat.categoryId}" ${param.categoryId == cat.categoryId ? 'checked' : ''}>
                                    <label class="btn btn-outline-primary btn-sm" for="cat_${cat.categoryId}">
                                        <c:out value="${cat.name}"/>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Lọc theo Tag -->
                        <div class="mb-4">
                            <label class="form-label filter-section-title">Nhãn</label>
                            <div class="d-flex flex-wrap gap-2">
                                <c:forEach var="tag" items="${tags}">
                                    <input type="checkbox" class="btn-check" name="tagId" id="tag_${tag.tagId}" value="${tag.tagId}" ${selectedTags.contains(tag.tagId) ? 'checked' : ''}>
                                    <label class="btn btn-outline-primary btn-sm" for="tag_${tag.tagId}">
                                        <c:out value="${tag.name}"/>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Lọc theo trạng thái -->
                        <div class="mb-4">
                            <label class="form-label filter-section-title">Trạng thái mượn</label>
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="radio" name="availableOnly" id="statusAll" value="" 
                                       ${empty param.availableOnly ? 'checked' : ''} style="border-color: var(--outline-variant);">
                                <label class="form-check-label" for="statusAll" style="color: var(--bs-body-color);">
                                    Tất cả tài liệu
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="availableOnly" id="statusAvailable" value="true" 
                                       ${param.availableOnly == 'true' ? 'checked' : ''} style="border-color: var(--outline-variant);">
                                <label class="form-check-label" for="statusAvailable" style="color: var(--bs-body-color);">
                                    Chỉ hiện sách có sẵn
                                </label>
                            </div>
                        </div>

                        <div class="d-grid gap-2 mt-4">
                            <button type="submit" class="btn btn-primary-custom fw-bold py-2">
                                Áp dụng bộ lọc
                            </button>
                            <a href="book-search" class="btn btn-light" style="color: var(--text-muted-custom);">
                                Xóa bộ lọc
                            </a>
                        </div>
                    </form>
                </div>
            </aside>

            <!-- Lưới hiển thị sách -->
            <section class="col-12 col-lg-9">
                <c:choose>
                    <c:when test="${empty books}">
                        <!-- Empty State -->
                        <div class="search-card p-5 text-center d-flex flex-column align-items-center justify-content-center" style="min-height: 400px;">
                            <div style="width: 80px; height: 80px; background-color: var(--surface-container-low); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-bottom: 1.5rem;">
                                <i class="bi bi-journal-x" style="font-size: 32px; color: var(--text-muted-custom);"></i>
                            </div>
                            <h4 class="fw-bold mb-2" style="color: var(--bs-body-color);">Không tìm thấy tài liệu</h4>
                            <p class="mb-4" style="color: var(--text-muted-custom); max-width: 400px;">
                                Không có cuốn sách nào khớp với từ khóa hoặc bộ lọc của bạn. Hãy thử dùng từ khóa ngắn hơn hoặc phổ biến hơn.
                            </p>
                            <a href="book-search" class="btn btn-primary-custom fw-bold px-4 py-2">Quay lại danh mục</a>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span style="font-size: 14px; color: var(--text-muted-custom);">
                                Hiển thị <strong style="color: var(--bs-body-color);"><c:out value="${books.size()}"/></strong> tài liệu trên trang này
                            </span>
                        </div>

                        <!-- Grid -->
                        <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4 mb-5">
                            <c:forEach var="book" items="${books}">
                                <div class="col">
                                    <div class="book-card d-flex flex-column">
                                        <div class="book-img-wrapper">
                                            <c:choose>
                                                <c:when test="${not empty book.coverImage}">
                                                    <img src="<c:out value="${book.coverImage}"/>" alt="Bìa sách <c:out value="${book.title}"/>" onerror="this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Hiển thị ảnh mặc định nếu không có cover -->
                                                    <div class="d-flex flex-column align-items-center justify-content-center h-100 w-100" style="background-color: var(--surface-container-high); color: var(--text-muted-custom);">
                                                        <i class="bi bi-book" style="font-size: 48px;"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <div class="card-body p-4 d-flex flex-column flex-grow-1">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <c:choose>
                                                    <c:when test="${book.availableQuantity > 0}">
                                                        <span class="badge rounded-pill badge-status-available px-3 py-1">Trong thư viện</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge rounded-pill badge-status-borrowed px-3 py-1">Đang mượn</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            
                                            <h5 class="fw-bold text-truncate-2 mt-2 mb-1" style="color: var(--bs-body-color); line-height: 1.4;" title="<c:out value="${book.title}"/>">
                                                <c:out value="${book.title}"/>
                                            </h5>
                                            
                                            <p class="mb-2" style="font-size: 13px; color: var(--text-muted-custom);">
                                                <i class="bi bi-person-badge"></i> <c:out value="${book.author}"/>
                                            </p>

                                            <!-- Categories & Tags Badges -->
                                            <div class="d-flex flex-wrap gap-1 mb-3">
                                                <c:forEach var="cat" items="${book.categories}">
                                                    <span class="badge fw-normal" style="font-size: 11px; background-color: rgba(249, 115, 22, 0.1); color: #f97316; border: 1px solid rgba(249, 115, 22, 0.2);">
                                                        <c:out value="${cat.name}"/>
                                                    </span>
                                                </c:forEach>
                                                <c:forEach var="tg" items="${book.tags}">
                                                    <span class="badge fw-normal" style="font-size: 11px; background-color: rgba(59, 130, 246, 0.1); color: #3b82f6; border: 1px solid rgba(59, 130, 246, 0.2);">
                                                        #<c:out value="${tg.name}"/>
                                                    </span>
                                                </c:forEach>
                                            </div>
                                            
                                            <div class="mt-auto pt-3" style="border-top: 1px solid var(--surface-container-high);">
                                                <a href="${pageContext.request.contextPath}/book-detail?id=${book.bookId}" class="btn btn-custom-outline w-100 py-2 d-flex justify-content-center align-items-center gap-2">
                                                    Đọc thêm <i class="bi bi-arrow-right"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Prepare multi tag params for pagination -->
                        <c:set var="tagParams" value="" />
                        <c:if test="${not empty tagIds}">
                            <c:forEach var="tId" items="${tagIds}">
                                <c:set var="tagParams" value="${tagParams}&tagId=${tId}" />
                            </c:forEach>
                        </c:if>

                        <!-- Phân trang Bootstrap -->
                        <c:if test="${totalPages > 1}">
                            <nav aria-label="Phân trang tìm kiếm" class="mt-4">
                                <ul class="pagination justify-content-center">
                                    <!-- Nút Previous -->
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="book-search?keyword=${param.keyword}&categoryId=${param.categoryId}${tagParams}&availableOnly=${param.availableOnly}&page=${currentPage - 1}" aria-label="Trang trước">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                    
                                    <!-- Số trang -->
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="book-search?keyword=${param.keyword}&categoryId=${param.categoryId}${tagParams}&availableOnly=${param.availableOnly}&page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>

                                    <!-- Nút Next -->
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="book-search?keyword=${param.keyword}&categoryId=${param.categoryId}${tagParams}&availableOnly=${param.availableOnly}&page=${currentPage + 1}" aria-label="Trang tiếp theo">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </main>

    <jsp:include page="/common/_footer.jsp" />
    
</body>
</html>
