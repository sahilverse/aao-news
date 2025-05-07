<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Not Found - Aaonews</title>
    <%@ include file="../layouts/reusable.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/errorpage.css">
</head>
<body>
<jsp:include page="../layouts/navbar.jsp" />

<div class="container">
    <div class="error-container">
        <i class="fa-solid fa-ban error-icon"></i>
        <h1 class="error-code">404</h1>
        <h2 class="error-title">Page Not Found</h2>
        <p class="error-message">
            Oops! We couldn't find the page you're looking for. The page might have been moved,
            deleted, or perhaps the URL was mistyped.
        </p>

        <div class="action-buttons">
            <button class="btn btn-outline-primary" onclick="history.back()">
                <i class="fas fa-arrow-left" style="margin-right: 4px;"></i> Go Back
            </button>
            <a href="${pageContext.request.contextPath}/" class="btn btn-default">
                <i class="fas fa-home" style="margin-right: 4px;"></i> Go to Homepage
            </a>
        </div>
    </div>
</div>

<jsp:include page="../layouts/footer.jsp" />
</body>
</html>
