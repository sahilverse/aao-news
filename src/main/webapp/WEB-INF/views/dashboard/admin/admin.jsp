<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Aaonews | Admin Dashboard</title>

    <c:if test="${requestScope.activePage == 'adminProfile'}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    </c:if>

    <c:if test="${requestScope.activePage == 'dashboard'}">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/dashboard/admin/adminDashboard.css">
    </c:if>

    <c:if test="${requestScope.activePage == 'publisherApproval'}">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/dashboard/admin/publisherApproval.css">
    </c:if>

    <c:if test="${requestScope.activePage == 'userManagement'}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard/admin/userManagement.css">
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
                <jsp:include page="./layouts/dashboard.jsp"/>
            </c:when>

            <%--User Management - FIXED: Changed = to == --%>
            <c:when test="${requestScope.activePage == 'userManagement'}">
                <jsp:include page="./layouts/userManagement.jsp"/>
            </c:when>

            <%--Pending Publishers--%>
            <c:when test="${requestScope.activePage == 'publisherApproval'}">
                <jsp:include page="./layouts/publisherApproval.jsp"/>
            </c:when>

            <%--Content Management--%>
            <c:when test="${requestScope.activePage == 'contentManagement'}">
                <jsp:include page="./layouts/contentManagement.jsp"/>
            </c:when>

            <%--Admin Profile--%>
            <c:when test="${requestScope.activePage == 'adminProfile'}">
                <jsp:include page="../../../layouts/commonProfile.jsp"/>
            </c:when>

            <%--Default case for debugging--%>
            <c:otherwise>
                <div class="error-message">
                    <h3>Page Not Found</h3>
                    <p>Active Page: <strong>${requestScope.activePage}</strong></p>
                    <p>Available pages: dashboard, userManagement, publisherApproval, contentManagement, adminProfile</p>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

</body>
</html>