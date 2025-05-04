<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unauthorized Access - Aaonews</title>
    <%@ include file="../layouts/reusable.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/errorpage.css">
</head>
<body>
<jsp:include page="../layouts/navbar.jsp" />

<div class="container">
    <div class="error-container">
        <i class="fas fa-lock error-icon"></i>
        <h1 class="error-code">403</h1>
        <h2 class="error-title">Access Denied</h2>

        <div class="error-message">
            <p>Sorry, you don't have permission to access this page or resource.</p>
            <p>This might be because:</p>
            <ul style="text-align: left; display: inline-block;">
                <li>You need to log in with different credentials</li>
                <li>Your account doesn't have the required permissions</li>
                <li>You're trying to access an admin or restricted area</li>
            </ul>
        </div>

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
