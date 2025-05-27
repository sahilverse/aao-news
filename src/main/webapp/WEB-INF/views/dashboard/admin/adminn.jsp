<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Aaonews | Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard/sidebar.css">
    <c:if test="${requestScope.activePage == 'publisherProfile'}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    </c:if>

    <c:if test="${requestScope.activePage == 'dashboard'}">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/dashboard/publisher/publisherDashboard.css">
    </c:if>
    <c:if test="${requestScope.activePage=='pendingPublishers'}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard/admin/adminDashboard.css">
    </c:if>

    <c:if test="${requestScope.activePage=='approvedPublisher'}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashbaord/admin/adminDashboard.css">
    </c:if>





    <c:if test="${requestScope.activePage == 'contentManagement'}">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/dashboard/admin/content-management.css">
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

            <%--Verifeid publishers--%>
            <c:when test="${requestScope.activePage='approvedPublisher'}">
                <jsp:include page="layouts/userManagement.jsp"/>
            </c:when>
            <%--Publisher Articles--%>
            <c:when test="${requestScope.activePage == 'pendingPublishers'}">
                <jsp:include page="layouts/publisherApproval.jsp"/>
            </c:when>

            <%--Create Articles--%>
            <c:when test="${requestScope.activePage == 'contentManagement'}">
                <jsp:include page="layouts/contentManagement.jsp"/>

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
