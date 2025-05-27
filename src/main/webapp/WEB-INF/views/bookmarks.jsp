<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Saved Article</title>

    <%@ include file="../layouts/reusable.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bookmark.css">

</head>
<body>
<jsp:include page="../layouts/navbar.jsp"/>
<%--Navbar End--%>

<!-- Articles List -->
<div class="container" style="margin: 20px auto;">
    <div class="articles-list">
        <c:choose>
            <c:when test="${not empty requestScope.bookmarks}">
                <c:forEach var="article" items="${requestScope.bookmarks}">
                    <div class="article-card">
                        <div class="article-header">
                            <h2 class="article-title">
                                <a href="${pageContext.request.contextPath}/article/${article.id}">${article.title}</a>
                            </h2>
                            <div class="article-meta">
                                <c:choose>
                                    <c:when test="${article.status eq 'PUBLISHED' and not empty article.createdAt}">
                                        <span class="article-date">Published <fmt:formatDate
                                                value="${article.createdAt}" pattern="MMM d, yyyy"/></span>
                                    </c:when>
                                    <c:when test="${not empty article.updatedAt}">
                                        <span class="article-date">Last updated <fmt:formatDate
                                                value="${article.updatedAt}" pattern="MMM d, yyyy"/></span>
                                    </c:when>
                                </c:choose>

                            </div>
                        </div>
                        <div class="article-content">
                            <p class="article-excerpt">
                                    ${article.summary}
                            </p>

                        </div>
                        <div class="article-footer">
                            <div class="article-category">
                                <span class="category-label">Category:</span>
                                <span class="category-value">
                                    <c:choose>
                                        <c:when test="${article.categoryId eq 1}">Technology</c:when>
                                        <c:when test="${article.categoryId eq 2}">Business</c:when>
                                        <c:when test="${article.categoryId eq 3}">Health</c:when>
                                        <c:when test="${article.categoryId eq 4}">Sports</c:when>
                                        <c:when test="${article.categoryId eq 5}">Culture</c:when>
                                        <c:when test="${article.categoryId eq 6}">Politics</c:when>
                                        <c:when test="${article.categoryId eq 7}">Science</c:when>
                                        <c:when test="${article.categoryId eq 8}">Entertainment</c:when>
                                        <c:otherwise>Uncategorized</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <div class="article-actions">
                                <a href="${pageContext.request.contextPath}/article/${article.id}"
                                   class="action-btn preview-btn" target="_blank">
                                    <i class="fas fa-eye"></i> Preview
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="no-articles-message">
                    <i class="fas fa-file-alt fa-3x"></i>
                    <h3>No articles found</h3>
                    <p>You haven't Saved any articles yet.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>


<%--Footer--%>
<jsp:include page="../layouts/footer.jsp"/>
</body>
</html>
