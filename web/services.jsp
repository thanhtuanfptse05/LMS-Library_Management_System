<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/_head.jsp" />
<body class="d-flex flex-column min-vh-100">

    <jsp:include page="common/_header.jsp" />

    <main class="flex-grow-1" style="padding-top: 20px;">
        <jsp:include page="common/_section-services.jsp" />
    </main>

    <jsp:include page="common/_footer.jsp" />

    <!-- Script to automatically switch tab based on URL query parameter -->
    <script>
        window.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            const tab = urlParams.get('tab');
            if (tab) {
                const btn = document.querySelector(`button[onclick*="pane-${tab}"]`);
                if (btn) {
                    btn.click();
                }
            }
        });
    </script>
</body>
</html>
