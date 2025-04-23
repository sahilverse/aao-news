<%--
  Created by IntelliJ IDEA.
  User: Dell
  Date: 4/17/2025
  Time: 10:34 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%@ include file="../layouts/reusable.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/form.css">

</head>
<body>
<jsp:include page="../layouts/navbar.jsp"/>


<div class="container form-container">
    <form name="loginForm"  action="login" method="POST">
        <h1>Login to Aao-news</h1>

        <c:if test="${requestScope.loginAttempted}">
            <c:choose>
                <c:when test="${not empty requestScope.error}">
                    <div class="form-error">
                        <i class="fas fa-exclamation-triangle error-icon"></i>
                        <p> ${requestScope.error}</p>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="form-error">
                        <i class="fas fa-exclamation-triangle error-icon"></i>
                        <p> An unknown error occurred. Please try again later.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>


        <div class="input">
            <label for="email">Email</label>
            <input type="text" name="email" id="email"/>


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

<jsp:include page="../layouts/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/formValidation.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/loginValidation.js"></script>

</body>
</html>
