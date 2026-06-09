/**
 * recommendation.js
 * JS xử lý gọi API Gợi ý sách AI và render lên giao diện (Trang chủ)
 */
document.addEventListener("DOMContentLoaded", function() {
    const container = document.getElementById('ai-recommendation-container');
    
    // Chỉ chạy nếu trang hiện tại có chứa khối AI Recommendation
    if (!container) return;

    // Render bộ khung Loading (Skeleton) với UI bám sát DESIGN.md
    container.innerHTML = `
        <div class="d-flex flex-column align-items-center justify-content-center py-5" style="min-height: 200px;">
            <div class="spinner-border mb-3" style="color: var(--primary-color); width: 2.5rem; height: 2.5rem;" role="status">
                <span class="visually-hidden">Đang tải...</span>
            </div>
            <h6 class="fw-bold" style="color: var(--bs-body-color);">Đang phân tích thói quen đọc...</h6>
            <p class="small mb-0" style="color: var(--text-muted-custom);">Hệ thống AI đang tìm kiếm những tài liệu phù hợp nhất với bạn</p>
        </div>
    `;

    // Fetch API gọi tới RecommendationServlet
    // Servlet này trả về chuỗi HTML của JSP Fragment (_recommendation.jsp)
    fetch('recommendation') // Cần đảm bảo contextPath đúng khi gọi
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.text();
        })
        .then(html => {
            // Nhúng thẳng HTML JSP fragment vào container
            container.innerHTML = html;
        })
        .catch(error => {
            console.error('Error fetching recommendations:', error);
            // Xử lý lỗi Fallback UI
            container.innerHTML = `
                <div class="text-center p-4 rounded-3" style="background-color: var(--surface-container-low); border: 1px dashed var(--outline-variant);">
                    <i class="bi bi-exclamation-triangle fs-1 mb-2 text-warning"></i>
                    <p class="fw-medium mb-0" style="color: var(--bs-body-color);">Hệ thống gợi ý đang bảo trì.</p>
                    <p class="small" style="color: var(--text-muted-custom);">Vui lòng quay lại sau hoặc tìm kiếm thủ công trong danh mục.</p>
                </div>
            `;
        });
});
