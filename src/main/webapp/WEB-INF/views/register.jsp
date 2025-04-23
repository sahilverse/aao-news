<%--
  Created by IntelliJ IDEA.
  User: Sahil Dahal
  Date: 4/17/2025
  Time: 9:52 PM
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aaonews - Registration</title>
    <%@ include file="../layouts/reusable.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/register.css">
</head>
<body>
<jsp:include page="../layouts/navbar.jsp"/>
<div class="container" style="margin-top: 40px;">
    <div class="header">
        <h1>Choose Registration Type</h1>
        <p class="subtitle">Select the appropriate registration option based on your role</p>
    </div>

    <div class="cards-container">
        <!-- User/Publisher Registration Card -->
        <div class="card">
            <div class="card-header user-publisher">
                <i class="fas fa-users card-icon"></i>
                <h2>User / Publisher</h2>
            </div>
            <div class="card-body">
                <div class="role-description">
                    <div class="role-item">
                        <h3><i class="fas fa-user"></i> User</h3>
                        <p>Register as a regular user to:</p>
                        <ul class="list-items">
                            <li>Access personalized news feed</li>
                            <li>Save articles to read later</li>
                            <li>Comment on articles</li>
                            <li>Receive newsletters</li>
                        </ul>
                    </div>
                    <div class="role-item">
                        <h3><i class="fas fa-pen-fancy"></i> Publisher</h3>
                        <p>Register as a publisher to:</p>
                        <ul class="list-items">
                            <li>Create and publish articles</li>
                            <li>Manage your content</li>
                            <li>Build your audience</li>
                            <li>Access analytics</li>
                        </ul>
                        <p class="note"><i class="fas fa-info-circle"></i> Publisher accounts require approval</p>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/register?type=user" class="btn btn-secondary">Continue <i
                        class="fas fa-arrow-right"></i></a>
            </div>
        </div>

        <!-- Admin Registration Card -->
        <div class="card">
            <div class="card-header admin">
                <i class="fas fa-shield-alt card-icon"></i>
                <h2>Administrator</h2>
            </div>
            <div class="card-body">
                <div class="admin-description">
                    <p class="admin-intro">Administrator accounts have elevated privileges and responsibilities for
                        managing the aao-news platform.</p>

                    <h3><i class="fas fa-key" style="margin-block: 10px;"></i> Admin Privileges</h3>
                    <ul class="list-items">
                        <li>Manage all users and publishers</li>
                        <li>Review and moderate content</li>
                        <li>Access system settings</li>
                        <li>View comprehensive analytics</li>
                        <li>Handle security and compliance</li>
                    </ul>

                    <div class="security-notice">
                        <i class="fas fa-exclamation-triangle"></i>
                        <div>
                            <h4>Security Notice</h4>
                            <p>Admin registration requires admin code. All admin
                                actions are logged for security purposes.</p>
                        </div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/register?type=admin" class="btn btn-secondary">Admin
                    Access <i class="fas fa-lock"></i></a>
            </div>
        </div>
    </div>

    <div class="login-link" style="margin-bottom: 20px;">
        Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a>
    </div>
</div>

<jsp:include page="../layouts/footer.jsp"/>

</body>
</html>

