<%-- 
    navbar.jsp — Top Navigation Bar
    Included by all pages via <jsp:include page="/WEB-INF/views/common/navbar.jsp"/>
    
    Expected variables (set via <c:set> before include):
      - currentPage : String — Active page identifier (home, about, news, policy, guide, contact)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- Navigation Link Data --%>
<c:set var="navLinks" value="home,about,news,policy,guide,contact"/>
<c:set var="navLabels" value="Home,About Us,News,Policy,User Guide,Contact"/>
<c:set var="navUrls" value="#,#,#,#,#,#"/>

<header class="main-header" id="mainHeader">
    <nav class="main-nav" aria-label="Main Navigation">
        <%-- Brand / Logo --%>
        <a href="<c:url value='/'/>" class="nav-brand">
            <span class="material-symbols-outlined nav-brand__icon">local_library</span>
            <span class="nav-brand__text">LMS University Library</span>
        </a>

        <%-- Desktop Navigation Links --%>
        <div class="nav-links" id="desktopNav">
            <c:forTokens items="home,about,news,policy,guide,contact" delims="," var="page" varStatus="status">
                <c:set var="labels" value="${'Home,About Us,News,Policy,User Guide,Contact'}"/>
                <c:forTokens items="${labels}" delims="," var="label" varStatus="labelStatus">
                    <c:if test="${status.index == labelStatus.index}">
                        <c:choose>
                            <c:when test="${currentPage == page}">
                                <a class="nav-link nav-link--active" href="#">${label}</a>
                            </c:when>
                            <c:otherwise>
                                <a class="nav-link" href="#">${label}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </c:forTokens>
            </c:forTokens>
        </div>

        <%-- Action Buttons --%>
        <div class="nav-actions">
            <%-- Search Button --%>
            <button class="btn-icon" type="button" aria-label="Search">
                <span class="material-symbols-outlined">search</span>
            </button>

            <%-- Mobile Hamburger Menu Button --%>
            <button class="hamburger-btn" type="button" aria-label="Toggle Navigation Menu" onclick="toggleMobileMenu()">
                <span class="material-symbols-outlined" id="hamburgerIcon">menu</span>
            </button>

            <%-- Login Button --%>
            <a href="<c:url value='/auth/login.jsp'/>" class="btn btn-primary">Login</a>
        </div>
    </nav>

    <%-- Mobile Dropdown Menu --%>
    <div class="mobile-menu" id="mobileMenu">
        <c:forTokens items="home,about,news,policy,guide,contact" delims="," var="page" varStatus="status">
            <c:set var="labels" value="${'Home,About Us,News,Policy,User Guide,Contact'}"/>
            <c:forTokens items="${labels}" delims="," var="label" varStatus="labelStatus">
                <c:if test="${status.index == labelStatus.index}">
                    <c:choose>
                        <c:when test="${currentPage == page}">
                            <a class="nav-link nav-link--active" href="#">${label}</a>
                        </c:when>
                        <c:otherwise>
                            <a class="nav-link" href="#">${label}</a>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </c:forTokens>
        </c:forTokens>
    </div>
</header>
