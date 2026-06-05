<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Latest News Section (Full Categorized) -->
<section class="bg-container-low py-5" id="news">
    <style>
        .news-categories {
            border-bottom: 2px solid var(--surface-container-highest);
            padding-bottom: 0.75rem;
        }
        .news-category-btn {
            background: transparent;
            border: none;
            color: var(--secondary);
            font-weight: 600;
            font-size: 15px;
            padding: 0.5rem 1.25rem;
            border-radius: 8px;
            transition: all 0.2s ease;
            cursor: pointer;
        }
        .news-category-btn:hover {
            background-color: rgba(157, 67, 0, 0.05);
            color: var(--primary-color);
        }
        .news-category-btn.active {
            background-color: var(--primary-color);
            color: white;
            box-shadow: 0 4px 12px rgba(157, 67, 0, 0.25);
        }
        .news-pane {
            display: none;
            animation: newsFadeIn 0.4s ease-out forwards;
        }
        .news-pane.active {
            display: block;
        }
        @keyframes newsFadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>

    <div class="container-xl py-3">
        <div class="mb-4">
            <span class="text-primary-custom fw-bold text-uppercase small" style="font-size: 12px; letter-spacing: 0.1em;">Cập nhật</span>
            <h2 class="fw-bold text-dark mt-1 mb-0" style="font-size: 28px;">Tin tức Thư viện &amp; Thông báo hệ thống</h2>
        </div>

        <!-- News Categories Navigation -->
        <div class="news-categories d-flex flex-wrap gap-2 mb-4">
            <button class="news-category-btn active" onclick="switchNewsCategory(event, 'pane-news-activity')">
                Tin tức Hoạt động
            </button>
            <button class="news-category-btn" onclick="switchNewsCategory(event, 'pane-news-library')">
                Tin tức Thư viện
            </button>
            <button class="news-category-btn" onclick="switchNewsCategory(event, 'pane-news-event')">
                Tin tức Sự kiện
            </button>
        </div>

        <!-- Content Area -->
        <div class="news-content">
            <!-- TAB 1: ACTIVITY NEWS -->
            <div class="news-pane active" id="pane-news-activity">
                <div class="row g-4 justify-content-center">
                    <div class="col-12 col-md-8 text-center py-5">
                        <div class="p-5 bg-white rounded-3 shadow-sm border border-outline-variant">
                            <span class="material-symbols-outlined text-muted" style="font-size: 56px;">campaign</span>
                            <h4 class="fw-bold mt-3 mb-2 text-dark">Không có Tin tức Hoạt động</h4>
                            <p class="text-muted mx-auto mb-0" style="max-width: 450px;">
                                Các cập nhật về hội thảo thư viện, chương trình đào tạo sinh viên và các hoạt động hợp tác sẽ được đăng tại đây.
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- TAB 2: LIBRARY NEWS -->
            <div class="news-pane" id="pane-news-library">
                <div class="row g-4 justify-content-center">
                    <div class="col-12 col-md-8 text-center py-5">
                        <div class="p-5 bg-white rounded-3 shadow-sm border border-outline-variant">
                            <span class="material-symbols-outlined text-muted" style="font-size: 56px;">local_library</span>
                            <h4 class="fw-bold mt-3 mb-2 text-dark">Không có Tin tức Thư viện</h4>
                            <p class="text-muted mx-auto mb-0" style="max-width: 450px;">
                                Các thông báo chính thức, cập nhật tài nguyên cơ sở dữ liệu và thay đổi lịch trình dịch vụ sẽ được đăng tại đây.
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- TAB 3: EVENT NEWS -->
            <div class="news-pane" id="pane-news-event">
                <div class="row g-4 justify-content-center">
                    <div class="col-12 col-md-8 text-center py-5">
                        <div class="p-5 bg-white rounded-3 shadow-sm border border-outline-variant">
                            <span class="material-symbols-outlined text-muted" style="font-size: 56px;">event</span>
                            <h4 class="fw-bold mt-3 mb-2 text-dark">Không có Tin tức Sự kiện</h4>
                            <p class="text-muted mx-auto mb-0" style="max-width: 450px;">
                                Thông tin về các hội chợ sách thường niên sắp tới, chiến dịch đọc sách và triển lãm tác giả sẽ được đăng tại đây.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
