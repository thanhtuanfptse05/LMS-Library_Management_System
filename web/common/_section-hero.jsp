<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Hero Section -->
<section class="position-relative w-100 overflow-hidden hero-section">
    <img alt="Modern University Library Interior" class="hero-img"
        src="https://lh3.googleusercontent.com/aida-public/AB6AXuC8iUEjUng4gNMu7_eJCVZTEhZAwhz64AhW9zJxcJsw1cgm9HBKKlECRjp9EQc4DdNzGtR3gthndmunJAnJbMjMcabGKYdZMpKilxzV0NXZse_7QpRSv_mkWKJdYaG1YS63Eoko3NvP2Q2PLl9zllXbqHHyzA023iir_aYUZ5uwCCKQqIAlNh_8TIiP97ZLQDShPaYa3ugmv72JHW9U6WZFDsfx9gsvOfajtzpFR7R04p9ssNJ3eWBoTLYa0Cm7jGOGoaX6anou__2V" />
    <div class="hero-overlay"></div>

    <!-- Glassmorphism search panel — centered -->
    <div class="position-relative w-100 h-100 hero-content d-flex align-items-center justify-content-center px-3 px-md-4">
        <div class="w-100 glass-search p-4 p-md-5 rounded-4 shadow-lg" style="max-width: 900px;">
            <div class="text-center mb-4">
                <h1 class="fw-bold mb-2" style="font-size: 32px; color: var(--bs-body-color);">
                    Khám phá bộ sưu tập
                </h1>
                <p class="mb-0" style="color: var(--text-muted-custom); font-size: 16px;">
                    Tìm kiếm hàng triệu cuốn sách, tạp chí và tài nguyên số.
                </p>
            </div>

            <!-- Search Form / Login CTA -->
            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <form action="${pageContext.request.contextPath}/book-search" method="GET">
                        <div class="row g-3">
                            <!-- Filter Dropdown -->
                            <div class="col-md-3">
                                <select class="form-select border-0 px-3 py-3 rounded-3 h-100"
                                    name="filter"
                                    style="background-color: var(--surface-container-low); color: var(--text-muted-custom); font-size: 14px;">
                                    <option value="all">Tất cả</option>
                                    <option value="title">Tiêu đề</option>
                                    <option value="author">Tác giả</option>
                                    <option value="keyword">Từ khóa</option>
                                    <option value="ddc">Chủ đề / DDC</option>
                                </select>
                            </div>

                            <!-- Search Input -->
                            <div class="col-md-6 position-relative">
                                <input class="form-control border-0 px-3 py-3 rounded-3 h-100"
                                    style="background-color: var(--surface-container-low); color: var(--bs-body-color); padding-right: 2.5rem !important;"
                                    placeholder="Tìm kiếm theo tiêu đề, tác giả hoặc từ khóa..."
                                    type="text" name="keyword" id="hero-search-query"
                                    autocomplete="off" oninput="showHeroSuggestions(this.value)" />
                                <span class="position-absolute end-0 top-50 translate-middle-y me-3 z-3 text-secondary" style="pointer-events: none;">
                                    <i class="bi bi-search"></i>
                                </span>
                                <!-- Auto-suggest box -->
                                <div id="hero-autosuggest-box"
                                    class="position-absolute w-100 bg-white rounded-3 shadow-lg mt-1 d-none"
                                    style="z-index: 1000; max-height: 250px; overflow-y: auto; border: 1px solid rgba(219,194,176,0.5);">
                                </div>
                            </div>

                            <!-- Search Button -->
                            <div class="col-md-3">
                                <button type="submit"
                                    class="btn btn-primary-custom w-100 h-100 py-3 rounded-3 fw-semibold"
                                    style="font-size: 16px;">
                                    Tìm kiếm
                                </button>
                            </div>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}/login?redirect=book-search" class="btn btn-primary-custom px-5 py-3 rounded-3 fw-bold shadow" style="font-size: 16px;">
                            <i class="bi bi-box-arrow-in-right me-2"></i> Đăng nhập để tra cứu
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Quick links below search bar -->
            <div class="d-flex flex-wrap gap-3 mt-3 justify-content-center">
                <a href="${pageContext.request.contextPath}/book-search?advanced=true"
                    class="text-decoration-none small d-flex align-items-center gap-1"
                    style="color: var(--text-muted-custom);">
                    <i class="bi bi-sliders"></i> Tìm kiếm nâng cao
                </a>
                <span style="color: var(--outline-variant);">|</span>
                <a href="${pageContext.request.contextPath}/book-search?digital=true"
                    class="text-decoration-none small d-flex align-items-center gap-1"
                    style="color: var(--text-muted-custom);">
                    <i class="bi bi-journal-bookmark"></i> Giáo trình theo ngành
                </a>
                <span style="color: var(--outline-variant);">|</span>
                <a href="#contact" onclick="openLibrarianChat(event)"
                    class="text-decoration-none small d-flex align-items-center gap-1"
                    style="color: var(--text-muted-custom);">
                    <i class="bi bi-chat-dots"></i> Trò chuyện với Thủ thư
                </a>
            </div>
        </div>
    </div>
</section>

<script>
    const heroMockSuggestions = [
        "Giới thiệu về lập trình Java",
        "Cấu trúc dữ liệu và giải thuật trong Java",
        "Hệ quản trị cơ sở dữ liệu",
        "Nguyên lý kỹ nghệ phần mềm",
        "Toán học rời rạc và ứng dụng",
        "Giới thiệu về trí tuệ nhân tạo",
        "Mạng máy tính: Cách tiếp cận hệ thống",
        "Các khái niệm hệ điều hành"
    ];

    function showHeroSuggestions(val) {
        const box = document.getElementById('hero-autosuggest-box');
        if (!val || val.trim().length === 0) { box.classList.add('d-none'); return; }

        const filtered = heroMockSuggestions.filter(item => item.toLowerCase().includes(val.toLowerCase()));
        if (filtered.length === 0) { box.classList.add('d-none'); return; }

        box.innerHTML = '';
        filtered.forEach(item => {
            const div = document.createElement('div');
            div.className = 'px-3 py-2 border-bottom small text-dark';
            div.style.cursor = 'pointer';
            div.innerText = item;
            div.onmouseenter = () => div.style.backgroundColor = 'var(--surface-container-low)';
            div.onmouseleave = () => div.style.backgroundColor = '';
            div.onclick = () => {
                document.getElementById('hero-search-query').value = item;
                box.classList.add('d-none');
            };
            box.appendChild(div);
        });
        box.classList.remove('d-none');
    }

    document.addEventListener('click', function(e) {
        if (!e.target.closest('#hero-search-query') && !e.target.closest('#hero-autosuggest-box')) {
            const box = document.getElementById('hero-autosuggest-box');
            if (box) box.classList.add('d-none');
        }
    });

    function openLibrarianChat(e) {
        e.preventDefault();
        alert("Đang kết nối đến Chatbot AI của UniLib / Hỗ trợ thủ thư trực tiếp...");
    }
</script>
