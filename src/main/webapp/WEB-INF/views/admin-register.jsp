<%--
  Created by IntelliJ IDEA.
  User: Sahil Dahal
  Date: 4/21/2025
  Time: 2:49 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Registration</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/form.css">

    <%@ include file="../layouts/reusable.jsp" %>

    <style>

    </style>
</head>
<body>
<%-- This is the admin registration page --%>
<jsp:include page="../layouts/navbar.jsp"/>

<%--Admin Registration Form--%>

<div class="container form-container" style="margin-top: 50px;">
    <form name="adminForm" action="register" method="post">
        <h1>Admin Registration</h1>


        <div class="input">
            <label for="adminCode">Admin Code</label>
            <input type="text" name="adminCode" id="adminCode"/>
        </div>


        <div class="input">
            <label for="email">Email</label>
            <input type="email" name="email" id="email"/>
        </div>
        <div class="input">
            <label for="fullName">Full Name</label>
            <input type="text" name="fullName" id="fullName"/>
        </div>
        <div class="input">
            <label for="password">Password</label>
            <input type="password" name="password" id="password">

        </div>

        <div class="input">
            <label for="confirmPassword">Confirm Password</label>
            <input type="password" name="confirmPassword" id="confirmPassword">

        </div>

        <input type="hidden" name="registrationType" value="admin"/>


        <button type="submit" class="btn btn-default">Register</button>
        <div class="separator" style="margin-top: 4px;"></div>
        <div class="already-account" style="margin-top: 1rem;">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/login"
                                           style="color: black;">Login</a>
            </p>

        </div>
    </form>

</div>
<script src="${pageContext.request.contextPath}/assets/js/formValidation.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/adminValidation.js"></script>
</body>
</html>
