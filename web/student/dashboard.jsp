<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<%--
    Student Dashboard — Shell page
    Cấu trúc: file này chỉ là "khung", toàn bộ UI được chia thành các JSP fragment
    trong thư mục fragments/. Mỗi fragment đảm nhiệm một phần UI riêng biệt.
    Sử dụng <jsp:include> (dynamic include) để giữ nguyên request scope & session.

    Fragment inventory:
        _head.jsp              — <head>: meta, CSS links, custom styles
        _header.jsp            — Fixed top navigation bar
        _sidebar.jsp           — Left sidebar navigation
        _section-welcome.jsp   — Welcome banner
        _section-stats.jsp     — Quick Stats Grid (4 KPI cards)
        _section-reading.jsp   — Currently Reading + Recommended Books
        _section-activity.jsp  — Recent Activity table
        _section-alert.jsp     — Overdue / Due-Soon system alert
        _footer.jsp            — Footer links
--%>

<jsp:include page="fragments/_head.jsp" />

<body class="d-flex flex-column">

<jsp:include page="fragments/_sidebar.jsp" />

<!-- ════════════════ BODY WRAPPER ════════════════ -->
<div class="d-flex main-wrapper overflow-hidden">

    <!-- ════════════════ MAIN CONTENT ════════════════ -->
    <main class="flex-grow-1 overflow-y-auto main-content-layout" style="background-color: #f7f9fb;">
        
        <jsp:include page="fragments/_header.jsp" />

        <div class="container-xl px-4 py-5">

            <jsp:include page="fragments/_section-welcome.jsp" />
            <jsp:include page="fragments/_section-stats.jsp" />
            <jsp:include page="fragments/_section-reading.jsp" />
            <jsp:include page="fragments/_section-activity.jsp" />
            <jsp:include page="fragments/_section-alert.jsp" />

        </div><!-- /.container-xl -->

        <jsp:include page="fragments/_footer.jsp" />
    </main>
</div><!-- /.d-flex.main-wrapper -->

    <!-- Floating Action Button (Mobile Search) -->
    <a href="${pageContext.request.contextPath}/book-search"
       class="d-lg-none position-fixed bottom-0 end-0 m-4 rounded-circle d-flex align-items-center justify-content-center shadow border-0 text-white bg-primary-custom text-decoration-none"
       style="width: 56px; height: 56px; z-index: 1050;"
       title="Tra cứu Mục lục">
        <span class="material-symbols-outlined" style="font-size: 24px;">search</span>
    </a>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Micro-interaction: Subtle hover lift on raised-cards via JS for older browser compat
        document.querySelectorAll('.raised-card').forEach(function (card) {
            card.addEventListener('mouseenter', function () {
                this.style.transform = 'translateY(-2px)';
                this.style.boxShadow = '0 10px 20px rgba(0,0,0,0.06)';
            });
            card.addEventListener('mouseleave', function () {
                this.style.transform = '';
                this.style.boxShadow = '';
            });
        });

        // Header search: forward to book-search with query param
        const headerSearch = document.querySelector('.header-search-input');
        if (headerSearch) {
            headerSearch.addEventListener('keydown', function (e) {
                if (e.key === 'Enter' && this.value.trim()) {
                    window.location.href = '${pageContext.request.contextPath}/book-search?keyword=' + encodeURIComponent(this.value.trim());
                }
            });
        }
    </script>

</body>
</html>
