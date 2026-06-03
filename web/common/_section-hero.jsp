<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Hero Section -->
<section class="hero-section d-flex align-items-center">
    <img alt="Modern University Library" class="hero-img"
        src="https://lh3.googleusercontent.com/aida-public/AB6AXuAXhwL3B82lHt70iVpVkR7bfy8MimqE7q3dKe0kFsVo7tjsnlheJNcmx_U9y-O4PHnsyTUkDrJLU3pD4Wk5K1nlm9fOvSB4cEgkpN0ZRjTWevp9BzeOcbYuj-51iud0mu-7OMrTm9doBITkCvxIiltV57-pe6G-2ODmimeIWygFXQdaIu9i6EZHOgD4ytVn5fjJuJGwf59A_NLHoXgj--56kW-NMGo5HhChnAc5WZuSE_qrUgosgYpqBjOVYLSTX430SBBQj7ZaNg8l" />
    <div class="hero-overlay"></div>
    <div class="container-xl hero-content w-100">
        <div class="max-width-custom" style="max-width: 650px;">
            <h1 class="text-white fw-bold display-4 mb-3">Welcome to the Heart of Knowledge</h1>
            <p class="text-white-50 fs-5 mb-4">Access millions of academic resources, journals, and digital
                archives at the UniLib University Library. Explore our collections as our guest today.</p>

            <!-- Form Tìm kiếm công cộng kết nối tới book-search.jsp -->
            <form action="${pageContext.request.contextPath}/book-search.jsp" method="GET" class="position-relative style-search-box">
                <span class="position-absolute top-50 start-0 translate-middle-y ms-3 material-symbols-outlined text-muted">search</span>
                <input class="form-control form-control-lg border-0 shadow-lg ps-5 pe-5 py-3 rounded-3"
                    name="query" placeholder="Search Info, Catalog, or Archives..." type="text" />
                <button type="submit"
                    class="btn bg-primary-container text-white position-absolute top-50 end-0 translate-middle-y me-2 px-4 py-2 rounded-3 fw-semibold">
                    Search
                </button>
            </form>
        </div>
    </div>
</section>
