<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Aaonews | Publisher Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard/sidebar.css">
    <%@include file="../common/common.jsp" %>
</head>
<body>

<%@include file="../common/sidebar.jsp" %>

<c:choose>
    <c:when test="${pageContext.request.requestURI.contains('/dashboard')}">

        <p>We are in /publisher/dashboard</p>
    </c:when>

    <c:when test="${pageContext.request.requestURI.contains('/publisher/articles')}">

        <p>We are in /publisher/articles</p>
    </c:when>

</c:choose>

</body>
</html>
