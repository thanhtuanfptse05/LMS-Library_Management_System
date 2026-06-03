<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Hero Section -->
<section class="hero-section d-flex align-items-center">
    <img alt="Modern University Library" class="hero-img"
        src="https://lh3.googleusercontent.com/aida-public/AB6AXuAXhwL3B82lHt70iVpVkR7bfy8MimqE7q3dKe0kFsVo7tjsnlheJNcmx_U9y-O4PHnsyTUkDrJLU3pD4Wk5K1nlm9fOvSB4cEgkpN0ZRjTWevp9BzeOcbYuj-51iud0mu-7OMrTm9doBITkCvxIiltV57-pe6G-2ODmimeIWygFXQdaIu9i6EZHOgD4ytVn5fjJuJGwf59A_NLHoXgj--56kW-NMGo5HhChnAc5WZuSE_qrUgosgYpqBjOVYLSTX430SBBQj7ZaNg8l" />
    <div class="hero-overlay"></div>
    <div class="container-xl hero-content w-100">
        <div class="max-width-custom" style="max-width: 750px;">
            <h1 class="text-white fw-bold display-4 mb-3">Welcome to the Heart of Knowledge</h1>
            <p class="text-white-50 fs-5 mb-4">Access millions of academic resources, journals, and digital archives at the UniLib University Library.</p>

            <!-- Form Tìm kiếm công cộng kết nối tới book-search.jsp -->
            <form action="${pageContext.request.contextPath}/book-search.jsp" method="GET" class="bg-white p-2 rounded-3 shadow-lg d-flex flex-column flex-md-row gap-2 align-items-stretch align-items-md-center">
                <!-- Dropdown Bộ lọc nhanh -->
                <div class="dropdown flex-shrink-0">
                    <button class="btn btn-light dropdown-toggle text-secondary-custom fw-semibold d-flex align-items-center gap-1 h-100 border-0" type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false" style="padding: 12px 16px;">
                        <span class="material-symbols-outlined fs-5">tune</span>
                        <span id="selected-filter-label">All</span>
                    </button>
                    <ul class="dropdown-menu border-0 shadow-sm" aria-labelledby="filterDropdown">
                        <li><a class="dropdown-item active" href="#" onclick="selectFilter('all')">All Fields</a></li>
                        <li><a class="dropdown-item" href="#" onclick="selectFilter('title')">Title</a></li>
                        <li><a class="dropdown-item" href="#" onclick="selectFilter('author')">Author</a></li>
                        <li><a class="dropdown-item" href="#" onclick="selectFilter('keyword')">Keyword</a></li>
                        <li><a class="dropdown-item" href="#" onclick="selectFilter('ddc')">Subject / DDC</a></li>
                    </ul>
                    <input type="hidden" name="filter" id="search-filter-input" value="all" />
                </div>
                
                <!-- Thanh tìm kiếm thông minh -->
                <div class="position-relative flex-grow-1">
                    <span class="position-absolute top-50 start-0 translate-middle-y ms-2 material-symbols-outlined text-muted">search</span>
                    <input class="form-control border-0 bg-transparent ps-5 py-3 h-100"
                        name="query" id="search-query-input" placeholder="Search title, author, keyword, DDC..." type="text" autocomplete="off" oninput="showSuggestions(this.value)" />
                    
                    <!-- Hộp gợi ý tự động (Auto-suggest dropdown) -->
                    <div id="autosuggest-box" class="position-absolute w-100 bg-white rounded-3 shadow-lg border border-outline-variant mt-1 d-none" style="z-index: 1000; max-height: 250px; overflow-y: auto;">
                        <!-- JS will populate suggestions here -->
                    </div>
                </div>
                
                <!-- Nút tìm kiếm -->
                <button type="submit" class="btn bg-primary-container text-white px-4 py-3 rounded-3 fw-bold border-0 shadow-sm">
                    Search Catalog
                </button>
            </form>

            <!-- Hàng liên kết nhanh ngay dưới thanh search -->
            <div class="d-flex flex-wrap gap-3 mt-3 justify-content-center justify-content-md-start">
                <a href="${pageContext.request.contextPath}/book-search.jsp?advanced=true" class="text-white text-decoration-none small d-flex align-items-center gap-1 hover-underline">
                    <span class="material-symbols-outlined fs-6">saved_search</span> Advanced Search
                </a>
                <span class="text-white-50">|</span>
                <a href="${pageContext.request.contextPath}/book-search.jsp?digital=true" class="text-white text-decoration-none small d-flex align-items-center gap-1 hover-underline">
                    <span class="material-symbols-outlined fs-6">menu_book</span> Courseware by Major
                </a>
                <span class="text-white-50">|</span>
                <a href="#" onclick="openLibrarianChat(event)" class="text-white text-decoration-none small d-flex align-items-center gap-1 hover-underline">
                    <span class="material-symbols-outlined fs-6">forum</span> Chat with Librarian
                </a>
            </div>
        </div>
    </div>
</section>

<style>
    .hover-bg-light:hover {
        background-color: var(--surface-container-low) !important;
        color: var(--primary-color) !important;
    }
</style>

<script>
    function selectFilter(filterType) {
        document.getElementById('search-filter-input').value = filterType;
        
        let label = 'All';
        if (filterType === 'title') label = 'Title';
        else if (filterType === 'author') label = 'Author';
        else if (filterType === 'keyword') label = 'Keyword';
        else if (filterType === 'ddc') label = 'Subject / DDC';
        
        document.getElementById('selected-filter-label').innerText = label;
        
        // Update active class in dropdown items
        const items = document.querySelectorAll('#filterDropdown + .dropdown-menu .dropdown-item');
        items.forEach(item => {
            item.classList.remove('active');
            if (item.getAttribute('onclick').includes(filterType)) {
                item.classList.add('active');
            }
        });
    }

    const mockSuggestions = [
        "Introduction to Java Programming",
        "Data Structures and Algorithms in Java",
        "Database Management Systems",
        "Software Engineering Principles",
        "Discrete Mathematics and Its Applications",
        "Introduction to Artificial Intelligence",
        "Computer Networks: A Systems Approach",
        "Operating System Concepts"
    ];

    function showSuggestions(val) {
        const box = document.getElementById('autosuggest-box');
        if (!val || val.trim().length === 0) {
            box.classList.add('d-none');
            return;
        }
        
        const filtered = mockSuggestions.filter(item => item.toLowerCase().includes(val.toLowerCase()));
        if (filtered.length === 0) {
            box.classList.add('d-none');
            return;
        }
        
        box.innerHTML = '';
        filtered.forEach(item => {
            const div = document.createElement('div');
            div.className = 'px-3 py-2 border-bottom hover-bg-light cursor-pointer small text-dark';
            div.style.cursor = 'pointer';
            div.innerText = item;
            div.onclick = function() {
                document.getElementById('search-query-input').value = item;
                box.classList.add('d-none');
            };
            box.appendChild(div);
        });
        box.classList.remove('d-none');
    }

    // Close suggestion box on click outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('#search-query-input') && !e.target.closest('#autosuggest-box')) {
            const box = document.getElementById('autosuggest-box');
            if (box) box.classList.add('d-none');
        }
    });

    function openLibrarianChat(e) {
        e.preventDefault();
        alert("Connecting to the UniLib AI Chatbot/Live Librarian support...");
    }
</script>
