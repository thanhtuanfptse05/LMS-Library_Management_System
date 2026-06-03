<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="common/_head.jsp" />
<body class="d-flex flex-column">

    <jsp:include page="common/_header.jsp" />

    <main>
        <jsp:include page="common/_section-hero.jsp" />
        <jsp:include page="common/_section-news.jsp" />
        <jsp:include page="common/_section-services.jsp" />
        <jsp:include page="common/_section-policies.jsp" />
        <jsp:include page="common/_section-cta.jsp" />
    </main>

    <jsp:include page="common/_footer.jsp" />

</body>
</html>
