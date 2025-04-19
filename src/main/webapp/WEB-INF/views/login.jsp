<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 4/17/2025
  Time: 10:34 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">

</head>
<body>
<jsp:include page="../layouts/header.jsp"/>

<div class="container form-container">
    <form name="loginForm" onsubmit="return submitForm()">
        <h1>Login to Aao-news</h1>
        <div class="input">
            <label for="email">Email</label>
            <input type="email" name="email" id="email"/>
        </div>
        <div class="input">
            <label for="password">Password</label>
            <input type="password" name="password" id="password">
        </div>

        <div class="remember-forgot" style="margin-top: 4px;">

            <div class="checkbox">
                <input type="checkbox" name="checkbox">Remember me
            </div>
            <div class="forget-password">
                <a href="${pageContext.request.contextPath}/forgot-password" style="color: black;"> Forgot Password?</a>
            </div>

        </div>
        <button type="submit" class="btn btn-default">Login</button>
        <div class="separator" style="margin-top: 4px;"></div>
        <div class="already-account" style="margin-top: 1rem;">
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/register" style="color: black;">Register</a>
            </p>

        </div>
    </form>

</div>
<script src="${pageContext.request.contextPath}/assets/js/loginValidation.js"></script>
</body>
</html>
