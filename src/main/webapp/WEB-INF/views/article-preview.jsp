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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/article-interactions.css">

</head>
<body>
<jsp:include page="../layouts/navbar.jsp"/>

<!-- Header -->
<section class="article-header container">
    <div class="top">
        <div class="date-container">
            <p class="date"><fmt:formatDate value="${requestScope.article.createdAt}" pattern="MMM d, yyyy"/></p>
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
                <img src="${pageContext.request.contextPath}/article-image?id=${requestScope.article.id}" alt=""
                     class="article-image">
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

<!-- Article Interactions -->
<c:if test="${requestScope.article.status == 'PUBLISHED'}">
    <section class="article-interactions">
        <div class="interactions-container">
            <div class="interaction-stats">
            <span class="stat-item">
                <i class="fas fa-heart"></i>
                <span class="stat-count" id="like-count">0</span> likes
            </span>
                <span class="stat-item">
                <i class="fas fa-comment"></i>
                <span class="stat-count" id="comment-count">0</span> comments
            </span>
                <span class="stat-item">
                <i class="fas fa-bookmark"></i>
                <span class="stat-count" id="save-count">0</span> saves
            </span>
            </div>
            <c:if test="${not empty sessionScope.currentUser}">
            <div class="interaction-buttons">
                <button class="interaction-btn like-btn" id="like-btn" onclick="toggleLike()">
                    <i class="far fa-heart" id="like-icon"></i>
                    <span>Like</span>
                </button>
                <button class="interaction-btn comment-btn" onclick="focusCommentInput()">
                    <i class="far fa-comment"></i>
                    <span>Comment</span>
                </button>
                <button class="interaction-btn save-btn" id="save-btn" onclick="toggleSave()">
                    <i class="far fa-bookmark" id="save-icon"></i>
                    <span>Save</span>
                </button>
            </div>
        </div>
        </c:if>
    </section>

    <!-- Comment Section -->
    <section class="comment-section container">
        <div class="comment-container">
            <h3 class="comment-section-title">Comments (0)</h3>

            <!-- Add Comment Form -->
            <c:if test="${not empty sessionScope.currentUser}">
            <div class="add-comment-form">
                <div class="comment-input-container">
                    <img src="${pageContext.request.contextPath}/user-image?id=${sessionScope.currentUser.id}"
                         alt="Your Avatar" class="comment-avatar">
                    <div class="comment-input-wrapper">
                    <textarea
                            id="comment-input"
                            placeholder="Add a comment..."
                            class="comment-input"
                            rows="3"
                    ></textarea>
                        <div class="comment-actions">
                            <button class="comment-submit-btn" onclick="addComment()">Post Comment</button>
                            <button class="comment-cancel-btn" onclick="cancelComment()">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        </c:if>

    </section>
</c:if>
<script>
    let currentArticleId = ${requestScope.article.id};
    const contextPath = "${pageContext.request.contextPath}";

</script>
<script src="${pageContext.request.contextPath}/assets/js/articlePreview.js"></script>

<jsp:include page="../layouts/footer.jsp"/>
</body>
</html>
