<%-- 
    home.jsp — Smart LMS Home Page (Landing Page)
    MVC View: Receives data from HomeServlet and renders all home sections.
    
    Sections: Hero, Quick Search, Mission/Stats, News, Policies, User Guide, Contact
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- Page-level variables for included components --%>
<c:set var="pageTitle" value="Smart LMS - Intellectual Sanctuary" scope="request"/>
<c:set var="pageCss" value="/assets/css/home.css" scope="request"/>
<c:set var="currentPage" value="home" scope="request"/>

<%-- Include common header (<head> section) --%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<%-- Include navigation bar --%>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>

<%-- ==================== MAIN CONTENT ==================== --%>
<main class="main-content">

    <%-- ==================== HERO SECTION ==================== --%>
    <section class="hero" id="heroSection">
        <div class="hero__grid">
            <div class="hero__content">
                <h1 class="hero__title">Smart Library Management System</h1>
                <p class="hero__text">
                    Search books, discover resources, and stay updated with library activities within our intellectual sanctuary.
                </p>
                <div class="hero__actions">
                    <a href="#searchSection" class="btn btn-primary btn-primary--lg">Search Books</a>
                    <a href="#missionSection" class="btn btn-outline">Learn More</a>
                </div>
            </div>
            <div class="hero__image-wrapper">
                <div class="hero__image-bg"></div>
                <img class="hero__image"
                     src="https://lh3.googleusercontent.com/aida-public/AB6AXuBUi1FFagVxY1rxEBSlB5XKqTS2z40G3EnMdO0Lha5yGzEASOPT3dXx4JCMNir1N3Td5UNhCypu2UiLzCdOyoQT7qNdcsbuxoJCF4PNgrUhtCnRR00cqZ0RJEtwI6qI_MfSxRJcmtl-SZrePTdgzvVkT1-EYuajiwKISqyQiaP8yHrcrD6T7ZFwtKotkkrmCHBZM9nccYWzMRgM6HZLJ9S8S9c_PdkxGrNxBLdT2tYuUAAU63nwJrafhs2CQ3I_nDtuZBqKJIhtvdw"
                     alt="Modern university library interior with bookshelves and students studying"/>
            </div>
        </div>
    </section>

    <%-- ==================== QUICK SEARCH SECTION ==================== --%>
    <section class="search-section" id="searchSection">
        <div class="container">
            <div class="search-panel">
                <form class="search-grid" action="<c:url value='/search'/>" method="GET">
                    <%-- Keywords Input --%>
                    <div class="form-group">
                        <label class="form-label" for="searchKeywords">Keywords</label>
                        <div class="form-input-wrapper">
                            <span class="material-symbols-outlined form-input-icon">search</span>
                            <input class="form-input form-input--with-icon"
                                   id="searchKeywords"
                                   type="text"
                                   name="keywords"
                                   placeholder="Search books, authors, ISBN..."/>
                        </div>
                    </div>

                    <%-- Title Select --%>
                    <div class="form-group">
                        <label class="form-label" for="searchTitle">Title</label>
                        <select class="form-select" id="searchTitle" name="title">
                            <option value="">All Titles</option>
                        </select>
                    </div>

                    <%-- Author Select --%>
                    <div class="form-group">
                        <label class="form-label" for="searchAuthor">Author</label>
                        <select class="form-select" id="searchAuthor" name="author">
                            <option value="">All Authors</option>
                        </select>
                    </div>

                    <%-- Category Select --%>
                    <div class="form-group">
                        <label class="form-label" for="searchCategory">Category</label>
                        <select class="form-select" id="searchCategory" name="category">
                            <option value="">All Categories</option>
                        </select>
                    </div>

                    <%-- Search Button --%>
                    <div class="form-group">
                        <label class="form-label sr-only" for="searchSubmit">Search</label>
                        <button class="btn-search" id="searchSubmit" type="submit" aria-label="Search">
                            <span class="material-symbols-outlined">search</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <%-- ==================== MISSION & STATS SECTION ==================== --%>
    <section class="mission-section" id="missionSection">
        <div class="section-header">
            <h2 class="section-header__title">Our Mission &amp; Vision</h2>
            <p class="section-header__subtitle">
                We aim to provide a seamless gateway to knowledge, fostering a culture of continuous learning and academic excellence through modern technology.
            </p>
        </div>

        <%-- Statistics Cards (data-driven via c:forEach) --%>
        <c:set var="statIcons" value="menu_book,group,visibility"/>
        <c:set var="statValues" value="50000+,12000+,1500+"/>
        <c:set var="statLabels" value="Total Books,Registered Members,Daily Visitors"/>

        <div class="stats-grid">
            <c:forTokens items="${statIcons}" delims="," var="icon" varStatus="status">
                <c:forTokens items="${statValues}" delims="," var="value" varStatus="valStatus">
                    <c:if test="${status.index == valStatus.index}">
                        <c:forTokens items="${statLabels}" delims="," var="label" varStatus="lblStatus">
                            <c:if test="${status.index == lblStatus.index}">
                                <div class="stat-card">
                                    <span class="material-symbols-outlined stat-card__icon">${icon}</span>
                                    <h3 class="stat-card__value">
                                        <c:out value="${value}"/>
                                    </h3>
                                    <p class="stat-card__label">
                                        <c:out value="${label}"/>
                                    </p>
                                </div>
                            </c:if>
                        </c:forTokens>
                    </c:if>
                </c:forTokens>
            </c:forTokens>
        </div>
    </section>

    <%-- ==================== NEWS & ANNOUNCEMENTS SECTION ==================== --%>
    <section class="news-section" id="newsSection">
        <div class="container">
            <div class="news-section__header">
                <div>
                    <h2 class="news-section__title">News &amp; Announcements</h2>
                    <p class="news-section__subtitle">Stay updated with the latest library events.</p>
                </div>
                <a href="#" class="btn-link">
                    View All News <span class="material-symbols-outlined">arrow_forward</span>
                </a>
            </div>

            <%-- News Cards Data --%>
            <c:set var="newsImages" value="https://lh3.googleusercontent.com/aida-public/AB6AXuBokMf_m9nhHLmrCKqh9O8p4H9nDGIGuX2He3knuwECaRDDzuGgjw9drmhHOiLyhy1pPhFTPTw-XcIvlnHiLj8Gog4uoDbvcKIVvbRdUZgYDkqky5-FBf37RAUIQOv-NenEmcZ_OBblIHcszEfYzyGTXcp5D5jzqUsDHj1kJbueld1djb4RI9r6TXlKpoce-pehyNVeFG_BoKyh0bsLldbTNSWp1wgMonXnqmSTAEFTUqrfNNBULYp62nUXA5KJ-0Lbny7cMFojPtc"/>
            <c:set var="newsImage2" value="https://lh3.googleusercontent.com/aida-public/AB6AXuCUt_Hpl58NCbAne9KDU5gyWF4pJfmX3FO8N1sRiuxJgAIos9wiRijq9lbexh-nIwyVw_8qYNUEjEeUIhhFIcoQLxuYU1qCs9L9_pgIRxo3ZwsE0kkkPPUYjN8qVmPNo0bBquWM3XMjZZbPuMPJ8vTg6zHgdkLdOGrTIbOf2Uz_X2ip_Hy2HLfGoeacTBv7QvzOUMtXj6gPu2kNxRAbaEcTxQUTAZ2kXXiKbp-gMn8KomSSfXPm7lPrjI_-8ELCNmPafc4ZBE6OORQ"/>
            <c:set var="newsImage3" value="https://lh3.googleusercontent.com/aida-public/AB6AXuCHZviWiIONBn_KWiayxRgEd1cWXjEPhNX74jjeErn98yNcEoBQOeI0zR7K_B40f-GKUOQp7N_cT32dNVBqrkuRoLXWTiFBIxKPj25CFiHNDjP9FAAQxDLlDBjqcsGqbVb7ARhb_Wvbht90DcbmBhJApIJbe4oIRzMlTioJgcLunOIViLncLBpvJwa4asxpzYzprjgP3R0bmwLwjo2KoUexMEM51Nw-aVHI4sVk8gbAL8EVHyeq76cVV3pUdiUBHLqIY381Dv9tLU8"/>

            <div class="news-grid">
                <%-- News Card 1 --%>
                <article class="news-card">
                    <div class="news-card__image-wrapper">
                        <img class="news-card__image"
                             src="${newsImages}"
                             alt="Digital library interface showing archival manuscripts being digitized"/>
                    </div>
                    <div class="news-card__body">
                        <span class="news-card__badge">Updates</span>
                        <h3 class="news-card__title">New Digital Archive Launch</h3>
                        <p class="news-card__excerpt">Our collection of historical manuscripts is now available digitally for all registered members.</p>
                        <div class="news-card__meta">
                            <span class="news-card__date">Oct 12, 2023</span>
                            <a href="#" class="btn-text">Read More</a>
                        </div>
                    </div>
                </article>

                <%-- News Card 2 --%>
                <article class="news-card">
                    <div class="news-card__image-wrapper">
                        <img class="news-card__image"
                             src="${newsImage2}"
                             alt="Modern reading lounge with ergonomic furniture in the library"/>
                    </div>
                    <div class="news-card__body">
                        <span class="news-card__badge">Renovation</span>
                        <h3 class="news-card__title">Quiet Study Zone Expanded</h3>
                        <p class="news-card__excerpt">We've added 50 new individual study pods in the North Wing to accommodate more students during finals.</p>
                        <div class="news-card__meta">
                            <span class="news-card__date">Oct 08, 2023</span>
                            <a href="#" class="btn-text">Read More</a>
                        </div>
                    </div>
                </article>

                <%-- News Card 3 --%>
                <article class="news-card">
                    <div class="news-card__image-wrapper">
                        <img class="news-card__image"
                             src="${newsImage3}"
                             alt="Students gathered around a table participating in a research workshop"/>
                    </div>
                    <div class="news-card__body">
                        <span class="news-card__badge">Workshop</span>
                        <h3 class="news-card__title">Information Literacy Series</h3>
                        <p class="news-card__excerpt">Join our upcoming workshops on advanced citation methods and research databases.</p>
                        <div class="news-card__meta">
                            <span class="news-card__date">Oct 05, 2023</span>
                            <a href="#" class="btn-text">Read More</a>
                        </div>
                    </div>
                </article>
            </div>
        </div>
    </section>

    <%-- ==================== LIBRARY POLICIES SECTION ==================== --%>
    <section class="policies-section" id="policiesSection">
        <h2 class="policies-section__title">Library Policies</h2>

        <div class="accordion">
            <%-- Policy Data for c:forEach --%>
            <c:set var="policyTitles" value="Borrowing Rules|Return Policy|Late Fee Policy|Membership Policy"/>
            <c:set var="policyContents" value="Members can borrow up to 5 books for a duration of 14 days. Faculty members are eligible for up to 10 books for 30 days. Renewals are possible if no hold has been placed on the item.|Books must be returned to the main circulation desk or the overnight drop-box. Items should be in the same condition as when they were borrowed.|A fine of $0.50 per day is applicable for overdue books. Lost or damaged books will incur a replacement fee plus a processing charge.|Membership is open to all students, faculty, and staff. External visitors can apply for a Guest Membership with an annual fee."/>

            <c:forTokens items="${policyTitles}" delims="|" var="pTitle" varStatus="status">
                <c:forTokens items="${policyContents}" delims="|" var="pContent" varStatus="cStatus">
                    <c:if test="${status.index == cStatus.index}">
                        <div class="accordion__item">
                            <button class="accordion__trigger" type="button" onclick="toggleAccordion(this)" aria-expanded="false">
                                <span><c:out value="${pTitle}"/></span>
                                <span class="material-symbols-outlined accordion__trigger-icon">expand_more</span>
                            </button>
                            <div class="accordion__content">
                                <p class="accordion__content-text">
                                    <c:out value="${pContent}"/>
                                </p>
                            </div>
                        </div>
                    </c:if>
                </c:forTokens>
            </c:forTokens>
        </div>
    </section>

    <%-- ==================== USER GUIDE SECTION ==================== --%>
    <section class="guide-section" id="guideSection">
        <div class="container">
            <h2 class="guide-section__title">User Guide</h2>

            <%-- Guide Card Data --%>
            <c:set var="guideIcons" value="search_insights,bookmark_added,update,quiz"/>
            <c:set var="guideTitles" value="How to Search|How to Borrow|How to Renew|FAQs"/>
            <c:set var="guideDescs" value="Use our advanced discovery tool to find books by ISBN or title.|Visit the circulation desk with your student ID card.|Log in to your account to extend your loan period online.|Find quick answers to common questions about our services."/>

            <div class="guide-grid">
                <c:forTokens items="${guideIcons}" delims="," var="gIcon" varStatus="status">
                    <c:forTokens items="${guideTitles}" delims="|" var="gTitle" varStatus="tStatus">
                        <c:if test="${status.index == tStatus.index}">
                            <c:forTokens items="${guideDescs}" delims="|" var="gDesc" varStatus="dStatus">
                                <c:if test="${status.index == dStatus.index}">
                                    <div class="guide-card">
                                        <span class="material-symbols-outlined guide-card__icon">${gIcon}</span>
                                        <h4 class="guide-card__title">
                                            <c:out value="${gTitle}"/>
                                        </h4>
                                        <p class="guide-card__text">
                                            <c:out value="${gDesc}"/>
                                        </p>
                                    </div>
                                </c:if>
                            </c:forTokens>
                        </c:if>
                    </c:forTokens>
                </c:forTokens>
            </div>
        </div>
    </section>

    <%-- ==================== CONTACT & MAP SECTION ==================== --%>
    <section class="contact-section" id="contactSection">
        <div class="contact-grid">
            <%-- Contact Information --%>
            <div class="contact-info">
                <h2 class="contact-info__title">Get in Touch</h2>
                <div class="contact-info__list">
                    <%-- Address --%>
                    <div class="contact-item">
                        <span class="material-symbols-outlined contact-item__icon">location_on</span>
                        <div>
                            <h5 class="contact-item__title">Address</h5>
                            <p class="contact-item__text">123 University Ave, Scholars Park, CA 90210</p>
                        </div>
                    </div>

                    <%-- Phone --%>
                    <div class="contact-item">
                        <span class="material-symbols-outlined contact-item__icon">call</span>
                        <div>
                            <h5 class="contact-item__title">Phone</h5>
                            <p class="contact-item__text">+1 (555) 123-4567</p>
                        </div>
                    </div>

                    <%-- Email --%>
                    <div class="contact-item">
                        <span class="material-symbols-outlined contact-item__icon">mail</span>
                        <div>
                            <h5 class="contact-item__title">Email</h5>
                            <p class="contact-item__text">library-help@university.edu</p>
                        </div>
                    </div>

                    <%-- Opening Hours --%>
                    <div class="contact-item">
                        <span class="material-symbols-outlined contact-item__icon">schedule</span>
                        <div>
                            <h5 class="contact-item__title">Opening Hours</h5>
                            <p class="contact-item__text">Mon-Fri: 8AM - 10PM<br/>Sat-Sun: 10AM - 6PM</p>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Map Image --%>
            <div class="contact-map">
                <img class="contact-map__image"
                     src="https://lh3.googleusercontent.com/aida-public/AB6AXuCTDeJHcwgyLcJiIt3TdWe1JLonPOKOREqvH-vZugxskv7ZvYAsFWrNcvS5S6S-UrjVSiywMVZZiXAH4T6TAWmyZwjbzk6RH-jHLjDLPrOOJsFO9h8oXeoWmnOFi5V8zG9NlxWmyl-Y1W8bZJoQo06cV282bKauZF_lYWbh_rG-EC25YNojzHnazXhFF81Wwoekao1zaMMIiETu02l96wHpgUIAm5vndqNeaBk6sNT86F3RhZxhnC4C1he9x5Pz4wFJmhYzoWTgp1w"
                     alt="University campus map highlighting the library building location"/>
            </div>
        </div>
    </section>

</main>

<%-- Include common footer + scripts --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
