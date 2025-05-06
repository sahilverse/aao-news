<%--
  Created by IntelliJ IDEA.
  User: Sahil Dahal
  Date: 4/21/2025
  Time: 2:49 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Admin Registration</title>
    <%@ include file="../layouts/reusable.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/form.css"/>

</head>
<body>

<jsp:include page="../layouts/navbar.jsp"/>

<div class="container form-container">

    <!-- Load errors and formData from session -->
    <c:set var="errors" value="${sessionScope.errors}"/>
    <c:set var="formData" value="${sessionScope.formData}"/>
    <c:remove var="errors" scope="session"/>
    <c:remove var="formData" scope="session"/>

    <form name="userForm" id="userForm" method="post" action="${pageContext.request.contextPath}/register">
        <h1>User Registration</h1>
        <input type="hidden" name="registrationType" value="user"/>

        <div class="input">
            <label for="email">Email</label>
            <input type="text" id="email" name="email" value="${formData.email}"/>
            <c:if test="${not empty errors.email}">

                <p class="error">${errors.email}</p>

            </c:if>
        </div>

        <div class="input">
            <label for="fullName">Full Name</label>
            <input type="text" id="fullName" name="fullName" value="${formData.fullName}"/>
            <c:if test="${not empty errors.fullName}">

                <p class="error">${errors.fullName}</p>

            </c:if>
        </div>

        <div class="input">
            <label for="password">Password</label>
            <div class="password-input-container">
                <input type="password" id="password" name="password"/>
                <button type="button" class="password-toggle">
                    <i class="fas fa-eye-slash"></i>
                </button>
            </div>
            <c:if test="${not empty errors.password}">

                <p class="error">${errors.password}</p>

            </c:if>
        </div>

        <div class="input">
            <label for="confirmPassword">Confirm Password</label>
            <div class="password-input-container">
                <input type="password" id="confirmPassword" name="confirmPassword"/>
                <button type="button" class="password-toggle">
                    <i class="fas fa-eye-slash"></i>
                </button>
            </div>
            <c:if test="${not empty errors.confirmPassword}">

                <p class="error">${errors.confirmPassword}</p>

            </c:if>
        </div>

        <div class="input">
            <label for="role">Register As</label>
            <select name="role" id="role">
                <option value="reader" ${formData.role == 'reader' ? 'selected' : ''}>Reader</option>
                <option value="publisher" ${formData.role == 'publisher' ? 'selected' : ''}>Publisher</option>
            </select>

            <c:if test="${not empty errors.role}">
                <div class="form-error">
                    <i class="fas fa-exclamation-triangle error-icon"></i>
                    <p>${errors.role}</p>
                </div>
            </c:if>
        </div>

        <button type="submit" class="btn btn-default">Register</button>

        <div class="separator" style="margin-top: 4px;"></div>
        <div class="already-account" style="margin-top: 1rem;">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/login"
                                           style="color: black;">Login</a>
            </p>

        </div>
    </form>
</div>

<jsp:include page="../layouts/footer.jsp"/>

<script src="${pageContext.request.contextPath}/assets/js/formValidation.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/passwordToggle.js"></script>
<script>
    attachFormValidator("userForm", {

        email: [
            {email: {message: "Please enter a valid email address."}},
            {required: {message: "Email is required."}}
        ],
        fullName: [
            {required: {message: "Full name is required."}}
        ],
        password: [
            {required: {message: "Password is required."}}
        ],
        confirmPassword: [
            {required: {message: "Please confirm your password."}},
            {match: {message: "Passwords do not match.", matchField: "password"}}
        ]
    });

</script>


</body>
</html>

