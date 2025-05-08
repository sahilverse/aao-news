<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Aaonews | Publisher Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
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


            </c:when>
            <%--Publisher Articles--%>
            <c:when test="${requestScope.activePage == 'publisherArticles'}">
                <jsp:include page="layouts/publisherArticles.jsp"/>
            </c:when>

            <%--Publisher Profile--%>
            <c:when test="${requestScope.activePage == 'publisherProfile'}">
                <jsp:include page="../../../layouts/commonProfile.jsp" />
            </c:when>

        </c:choose>
    </main>
</div>

</body>
</html>
