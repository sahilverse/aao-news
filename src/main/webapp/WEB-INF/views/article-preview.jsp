<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Article</title>

    <%@ include file="../layouts/reusable.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/article-preview.css">

</head>
<body>
<jsp:include page="../layouts/navbar.jsp"/>


<!-- Header -->
<section class="article-header container">
    <div class="top">
        <div class="date-container">
            <p class="date"><fmt:formatDate value="${requestScope.article.createdAt}" pattern="MMM d, yyyy" /></p>
        </div>
        <div class="category-container">
            <p class="category-name">
                <c:choose>
                    <c:when test="${requestScope.article.categoryId eq 1}">Technology</c:when>
                    <c:when test="${requestScope.article.categoryId eq 2}">Business</c:when>
                    <c:when test="${requestScope.article.categoryId eq 3}">Health</c:when>
                    <c:when test="${requestScope.article.categoryId eq 4}">Sports</c:when>
                    <c:when test="${requestScope.article.categoryId eq 5}">Culture</c:when>
                    <c:when test="${requestScope.article.categoryId eq 6}">Politics</c:when>
                    <c:when test="${requestScope.article.categoryId eq 7}">Science</c:when>
                    <c:when test="${requestScope.article.categoryId eq 8}">Entertainment</c:when>
                    <c:otherwise>Uncategorized</c:otherwise>
                </c:choose>
            </p>
        </div>
        <div class="author-container">
            <p class="author">By <span class="author-name">${requestScope.article.author.username}</span></p>
        </div>
    </div>

    <div class="heading-container">
        <div class="divider"></div>
        <h1 class="heading">${requestScope.article.title}</h1>
        <div class="divider"></div>
    </div>
</section>

<!-- Article Content -->
<section class="article container">

    <div class="article-container">
        <c:if test="${not empty requestScope.article.featureImage}">
            <div class="article-image-container">
                <img src="${pageContext.request.contextPath}/article-image?id=${requestScope.article.id}" alt="" class="article-image">
            </div>
        </c:if>

        <div class="share-container">
            <p>Share this post</p>
            <div class="share-icons">
                <a href="#" class="remove-a"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="remove-a"><i class="fab fa-twitter"></i></a>
                <a href="#" class="remove-a"><i class="fab fa-linkedin-in"></i></a>
                <a href="#" class="remove-a"><i class="fab fa-pinterest-p"></i></a>
            </div>
        </div>
        <div class="article-content-container">
            ${requestScope.article.content}
        </div>
    </div>
</section>

<jsp:include page="../layouts/footer.jsp"/>
</body>
</html>
