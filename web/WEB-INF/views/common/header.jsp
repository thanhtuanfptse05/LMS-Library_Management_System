<%-- 
    header.jsp — Common <head> section
    Included by all pages via <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    
    Expected variables (set via <c:set> before include):
      - pageTitle : String — Page title for <title> tag
      - pageCss   : String — (optional) Additional page-specific CSS file path
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="description" content="Smart LMS - A modern Library Management System providing seamless access to knowledge resources for the university community."/>

    <title><c:out value="${pageTitle}" default="Smart LMS - Intellectual Sanctuary"/></title>

    <%-- Google Fonts: Inter (body) + Geist (headlines) --%>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
    <link href="https://fonts.googleapis.com/css2?family=Geist:wght@100..900&family=Inter:wght@100..900&display=swap" rel="stylesheet"/>

    <%-- Material Symbols Outlined (Icon font) --%>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>

    <%-- Design System CSS --%>
    <link rel="stylesheet" href="<c:url value='/assets/css/variables.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/assets/css/base.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/assets/css/layout.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/assets/css/components.css'/>"/>

    <%-- Page-specific CSS (optional) --%>
    <c:if test="${not empty pageCss}">
        <link rel="stylesheet" href="<c:url value='${pageCss}'/>"/>
    </c:if>
</head>
<body>
