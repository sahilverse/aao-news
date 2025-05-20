<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Aaonews | Publisher Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard/sidebar.css">
    <c:if test="${requestScope.activePage == 'publisherProfile'}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    </c:if>

    <c:if test="${requestScope.activePage == 'dashboard'}">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/dashboard/publisher/publisherDashboard.css">
    </c:if>

    <c:if test="${requestScope.activePage == 'createArticle'}">
        <!-- Include Jodit Editor from CDN -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jodit/3.24.2/jodit.min.css" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jodit/3.24.2/jodit.min.js"></script>
        
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/dashboard/publisher/createArticle.css">
    </c:if>

    <c:if test="${requestScope.activePage == 'publisherArticles'}">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/dashboard/publisher/publisherArticles.css">
    </c:if>
    <%@include file="../common/common.jsp" %>

    <style>
        /* Profile Header */
        .profile-header {
            background-color: var(--db-only);
        }

    </style>
</head>
<body>
<div class="dashboard-container">

    <jsp:include page="../common/sidebar.jsp"/>

    <main class="main-content container">

        <!-- header -->
        <jsp:include page="../common/header.jsp"/>

        <c:choose>
            <%--Dashboard Main--%>
            <c:when test="${requestScope.activePage == 'dashboard'}">
                <jsp:include page="layouts/dashboard.jsp"/>

            </c:when>
            <%--Publisher Articles--%>
            <c:when test="${requestScope.activePage == 'publisherArticles'}">
                <jsp:include page="layouts/publisherArticles.jsp"/>
            </c:when>

            <%--Create Articles--%>
            <c:when test="${requestScope.activePage == 'createArticle'}">
                <jsp:include page="layouts/createArticle.jsp"/>
            </c:when>

            <%--Publisher Profile--%>
            <c:when test="${requestScope.activePage == 'publisherProfile'}">
                <jsp:include page="../../../layouts/commonProfile.jsp"/>
            </c:when>

        </c:choose>
    </main>
</div>

</body>
</html>
