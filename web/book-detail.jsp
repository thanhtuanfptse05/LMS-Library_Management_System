<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/common/_head.jsp" />

<style>
    .detail-card {
        border-radius: 1rem;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
        border: 1px solid var(--outline-variant);
        background-color: var(--surface-lowest);
        overflow: hidden;
    }

    .cover-container {
        background-color: var(--surface-container-low);
        display: flex;
        align-items: center;
        justify-content: center;
        min-height: 400px;
        padding: 2rem;
    }

    .cover-container img {
        max-width: 100%;
        max-height: 500px;
        border-radius: 0.5rem;
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        object-fit: cover;
    }

    .meta-label {
        font-size: 13px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        color: var(--text-muted-custom);
    }

    .meta-value {
        font-size: 15px;
        color: var(--bs-body-color);
        font-weight: 500;
    }

    .badge-status-available {
        background-color: rgba(16, 185, 129, 0.1);
        color: #10b981;
    }

    .badge-status-borrowed {
        background-color: rgba(239, 68, 68, 0.1);
        color: #ef4444;
    }

    /* Badges */
    .badge-category {
        background-color: #f97316;
        color: #fff;
        border-radius: 50rem;
        padding: 0.35em 0.75em;
    }
    .badge-tag {
        background-color: #3b82f6;
        color: #fff;
        border-radius: 50rem;
        padding: 0.35em 0.75em;
    }
</style>

<body class="d-flex flex-column min-vh-100">

    <jsp:include page="/common/_header.jsp" />

    <!-- Breadcrumb -->
    <div style="background-color: var(--surface-container-low); border-bottom: 1px solid var(--surface-container-high);">
        <div class="container-xl py-3 px-4">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb m-0" style="font-size: 14px;">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none" style="color: var(--primary-color);">Trang chủ</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/book-search" class="text-decoration-none" style="color: var(--primary-color);">Tra cứu mục lục</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Chi tiết tài liệu</li>
                </ol>
            </nav>
        </div>
    </div>

    <!-- Nội dung chi tiết sách -->
    <main class="container-xl flex-grow-1 py-5 px-4">
        <!-- Thông báo kết quả đặt trước / gia hạn -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show mb-4 rounded-3 border-0 shadow-sm d-flex align-items-center" role="alert" style="background-color: rgba(16, 185, 129, 0.15); color: #0f766e;">
                <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                <div>
                    <c:out value="${sessionScope.successMessage}"/>
                </div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show mb-4 rounded-3 border-0 shadow-sm d-flex align-items-center" role="alert" style="background-color: rgba(239, 68, 68, 0.15); color: #991b1b;">
                <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                <div>
                    <c:out value="${sessionScope.errorMessage}"/>
                </div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <c:choose>
            <c:when test="${empty book}">
                <!-- Lỗi không tìm thấy sách -->
                <div class="detail-card p-5 text-center my-5">
                    <i class="bi bi-exclamation-triangle display-1 text-warning mb-3"></i>
                    <h2 class="fw-bold" style="color: var(--bs-body-color);">Không tìm thấy tài liệu</h2>
                    <p class="text-secondary mb-4">Tài liệu bạn yêu cầu không tồn tại hoặc đã bị gỡ bỏ khỏi hệ thống.</p>
                    <a href="${pageContext.request.contextPath}/book-search" class="btn btn-primary-custom px-4 py-2 fw-bold">Quay lại danh mục</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="detail-card mb-5">
                    <div class="row g-0">
                        
                        <!-- Cột trái: Ảnh bìa -->
                        <div class="col-12 col-lg-4 border-end" style="border-color: var(--surface-container-high) !important;">
                            <div class="cover-container h-100">
                                <c:choose>
                                    <c:when test="${not empty book.imagePath}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(book.imagePath, 'http://') or fn:startsWith(book.imagePath, 'https://')}">
                                                <img src="<c:out value="${book.imagePath}"/>" alt="Bìa sách <c:out value="${book.title}"/>" onerror="this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/book-images/<c:out value="${book.imagePath}"/>" alt="Bìa sách <c:out value="${book.title}"/>" onerror="this.src='${pageContext.request.contextPath}/assets/images/book-placeholder.jpg'">
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="d-flex flex-column align-items-center justify-content-center h-100 w-100" style="color: var(--text-muted-custom);">
                                            <i class="bi bi-book display-1 mb-3"></i>
                                            <span class="fw-medium">Không có ảnh bìa</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <!-- Cột phải: Thông tin -->
                        <div class="col-12 col-lg-8">
                            <div class="p-4 p-md-5 d-flex flex-column h-100">
                                
                                <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-3">
                                      <c:choose>
                                          <c:when test="${isBookUnavailable or book.status eq 'unavailable'}">
                                              <span class="badge rounded-pill bg-secondary px-3 py-2 fw-bold" style="font-size: 13px;">
                                                  <i class="bi bi-slash-circle me-1"></i> Ngừng phục vụ (0/<c:out value="${book.totalQuantity}"/>)
                                              </span>
                                          </c:when>
                                          <c:when test="${book.availableQuantity > 0}">
                                              <span class="badge rounded-pill badge-status-available px-3 py-2 fw-bold" style="font-size: 13px;">
                                                  <i class="bi bi-check-circle me-1"></i> Còn sách (<c:out value="${book.availableQuantity}"/>/<c:out value="${book.totalQuantity}"/>)
                                              </span>
                                          </c:when>
                                          <c:otherwise>
                                              <span class="badge rounded-pill badge-status-borrowed px-3 py-2 fw-bold" style="font-size: 13px;">
                                                  <i class="bi bi-hourglass-split me-1"></i> Hết sách (0/<c:out value="${book.totalQuantity}"/>) — Có thể xếp hàng chờ
                                              </span>
                                          </c:otherwise>
                                      </c:choose>
                                     <span style="font-size: 13px; color: var(--text-muted-custom); font-weight: 600;">Mã tài liệu: <c:out value="${book.bookId}"/></span>
                                 </div>

                                <h1 class="fw-bold mb-2" style="color: var(--bs-body-color); line-height: 1.2;">
                                    <c:out value="${book.title}"/>
                                </h1>
                                <p class="fs-5 mb-3" style="color: var(--primary-color);">
                                    <i class="bi bi-person-badge"></i> Tác giả: <strong><c:out value="${book.author}"/></strong>
                                </p>

                                 <!-- Categories & Tags -->
                                 <div class="mb-4 d-flex flex-wrap gap-2">
                                     <c:forEach var="cat" items="${book.categories}">
                                         <span class="badge badge-category rounded-pill py-2 px-3 fw-normal" style="font-size: 13px;">
                                             <i class="bi bi-folder2-open me-1"></i> <c:out value="${cat.name}"/>
                                         </span>
                                     </c:forEach>
                                     <c:forEach var="tag" items="${book.tags}">
                                         <span class="badge badge-tag rounded-pill py-2 px-3 fw-normal" style="font-size: 13px;">
                                             <i class="bi bi-hash"></i><c:out value="${tag.name}"/>
                                         </span>
                                     </c:forEach>
                                 </div>

                                <div class="row g-4 mb-5">
                                    <div class="col-sm-6">
                                        <div class="meta-label">Nhà xuất bản</div>
                                        <div class="meta-value"><c:out value="${book.publisher}"/></div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="meta-label">Năm xuất bản</div>
                                        <div class="meta-value"><c:out value="${book.publicationYear}"/></div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="meta-label">Mã ISBN</div>
                                        <div class="meta-value"><c:out value="${book.isbn}"/></div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="meta-label">Số lượng khả dụng</div>
                                        <div class="meta-value">
                                            <c:out value="${book.availableQuantity}"/> / <c:out value="${book.totalQuantity}"/>
                                        </div>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="mt-auto pt-4" style="border-top: 1px solid var(--surface-container-high);">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.userId}">
                                            <c:choose>
                                                <c:when test="${sessionScope.role == 'STUDENT' or sessionScope.role == 'LECTURER'}">
                                                    <c:choose>
                                                        <c:when test="${hasActiveBorrow}">
                                                            <div class="d-flex flex-wrap align-items-center gap-3 mb-3">
                                                                <span class="text-success fw-bold"><i class="bi bi-check-circle-fill"></i> Bạn đang mượn cuốn sách này.</span>
                                                                <a href="${pageContext.request.contextPath}/${sessionScope.role.toLowerCase()}/my-borrowings" class="btn btn-outline-primary fw-bold rounded-3 px-4">Xem hạn trả & Gia hạn</a>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${hasActiveReservation}">
                                                            <div class="d-flex flex-wrap align-items-center gap-3 mb-3">
                                                                <span class="fw-bold" style="color: #ea580c;"><i class="bi bi-info-circle-fill"></i> Bạn đã đặt trước cuốn sách này.</span>
                                                                <a href="${pageContext.request.contextPath}/${sessionScope.role.toLowerCase()}/my-borrowings" class="btn btn-outline-warning fw-bold rounded-3 px-4" style="color: #ea580c; border-color: #ea580c;">Quản lý hàng đợi</a>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${isBookUnavailable or book.status eq 'unavailable'}">
                                                             <div class="alert alert-warning mb-0 d-inline-flex align-items-center gap-2 py-2 px-3 fw-medium" style="font-size: 14px;">
                                                                 <i class="bi bi-exclamation-triangle-fill fs-5 text-warning"></i> Tài liệu này hiện đang tạm ngưng phục vụ tại Thư viện.
                                                             </div>
                                                         </c:when>
                                                         <c:otherwise>
                                                             <form action="${pageContext.request.contextPath}/${sessionScope.role.toLowerCase()}/reserve" method="POST" class="d-inline-block">
                                                                 <input type="hidden" name="bookId" value="${book.bookId}">
                                                                 <button type="submit" class="btn btn-primary-custom px-5 py-3 fw-bold rounded-3 shadow-sm d-inline-flex align-items-center gap-2">
                                                                     <i class="bi bi-bookmark-plus-fill fs-5"></i> 
                                                                     <c:choose>
                                                                         <c:when test="${book.availableQuantity > 0}">Đặt trước (Lấy ngay)</c:when>
                                                                         <c:otherwise>Đặt trước (Xếp hàng chờ)</c:otherwise>
                                                                     </c:choose>
                                                                 </button>
                                                             </form>
                                                         </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="alert alert-secondary mb-0 d-inline-block py-2" style="font-size: 14px;">
                                                        <i class="bi bi-info-circle-fill me-1"></i> Tính năng đặt mượn sách trực tuyến chỉ dành cho Độc giả.
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Bắt buộc redirect về Login nếu Guest -->
                                            <a href="${pageContext.request.contextPath}/login?redirect=book-detail?id=${book.bookId}" 
                                               class="btn btn-primary-custom px-5 py-3 fw-bold rounded-3 shadow-sm d-inline-flex align-items-center gap-2">
                                                <i class="bi bi-box-arrow-in-right fs-5"></i> Đăng nhập để đặt mượn
                                            </a>
                                        </c:otherwise>
                                    </c:choose>

                                    <a href="${pageContext.request.contextPath}/book-search" class="btn btn-light px-4 py-3 fw-bold rounded-3 ms-2" style="color: var(--text-muted-custom);">
                                        Quay lại
                                    </a>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <jsp:include page="/common/_footer.jsp" />
    
</body>
</html>
