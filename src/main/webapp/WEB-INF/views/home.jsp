<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AaoNews - Latest News & Updates</title>

    <%@ include file="../layouts/reusable.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>
<body>
<jsp:include page="../layouts/navbar.jsp"/>

<main class="main-content">
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="top-news">
                <article class="main-article">
                    <c:choose>
                        <c:when test="${not empty mainArticle}">
                            <!-- Make the entire article clickable -->
                            <a href="${pageContext.request.contextPath}/article/${mainArticle.id}" class="main-article-link">
                                <c:if test="${not empty mainArticle.featureImage}">
                                    <div class="image-container">
                                        <img src="${pageContext.request.contextPath}/article-image?id=${mainArticle.id}"
                                             alt="${mainArticle.title}" class="main-article-image">
                                    </div>
                                </c:if>

                                <div class="article-content">
                                    <div class="article-meta">
                                            <span class="category-badge category-${mainArticle.categoryId}">
                                                <c:choose>
                                                    <c:when test="${mainArticle.categoryId eq 1}">Technology</c:when>
                                                    <c:when test="${mainArticle.categoryId eq 2}">Business</c:when>
                                                    <c:when test="${mainArticle.categoryId eq 3}">Health</c:when>
                                                    <c:when test="${mainArticle.categoryId eq 4}">Sports</c:when>
                                                    <c:when test="${mainArticle.categoryId eq 5}">Culture</c:when>
                                                    <c:when test="${mainArticle.categoryId eq 6}">Politics</c:when>
                                                    <c:when test="${mainArticle.categoryId eq 7}">Science</c:when>
                                                    <c:when test="${mainArticle.categoryId eq 8}">Entertainment</c:when>
                                                    <c:otherwise>News</c:otherwise>
                                                </c:choose>
                                            </span>
                                    </div>

                                    <h1 class="article-title">
                                            ${mainArticle.title}
                                    </h1>

                                    <c:if test="${not empty mainArticle.summary}">
                                        <p class="article-excerpt">${mainArticle.summary}</p>
                                    </c:if>

                                    <div class="article-info">
                                        <span class="author">By ${mainArticle.author.username}</span>
                                        <span class="date">
                                                <fmt:formatDate value="${mainArticle.publishedAt}" pattern="MMM d, yyyy 'at' h:mm a"/>
                                            </span>
                                    </div>
                                </div>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <div class="article-content">
                                <div class="article-meta">
                                    <span class="category-badge category-6">Politics</span>
                                </div>
                                <h1 class="article-title">Welcome to AAO News</h1>
                                <p class="article-excerpt">Stay updated with the latest news and developments from around the world.</p>
                                <p class="no-content">No featured articles available at the moment.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </article>

                <aside class="side-articles">
                    <c:choose>
                        <c:when test="${not empty sideArticles}">
                            <c:forEach var="article" items="${sideArticles}" varStatus="status">
                                <c:if test="${status.index < 2}">
                                    <article class="side-article">
                                        <a href="${pageContext.request.contextPath}/article/${article.id}" class="side-article-link">
                                            <c:if test="${not empty article.featureImage}">
                                                <div class="image-container">
                                                    <img src="${pageContext.request.contextPath}/article-image?id=${article.id}"
                                                         alt="${article.title}" class="side-article-image">
                                                </div>
                                            </c:if>

                                            <div class="article-content">
                                                    <span class="category-tag">
                                                        <c:choose>
                                                            <c:when test="${article.categoryId eq 1}">Technology</c:when>
                                                            <c:when test="${article.categoryId eq 2}">Business</c:when>
                                                            <c:when test="${article.categoryId eq 3}">Health</c:when>
                                                            <c:when test="${article.categoryId eq 4}">Sports</c:when>
                                                            <c:when test="${article.categoryId eq 5}">Culture</c:when>
                                                            <c:when test="${article.categoryId eq 6}">Politics</c:when>
                                                            <c:when test="${article.categoryId eq 7}">Science</c:when>
                                                            <c:when test="${article.categoryId eq 8}">Entertainment</c:when>
                                                            <c:otherwise>News</c:otherwise>
                                                        </c:choose>
                                                    </span>

                                                <h3 class="article-title">
                                                        ${article.title}
                                                </h3>

                                                <div class="article-info">
                                                    <span class="author">By ${article.author.username}</span>
                                                    <span class="date">
                                                            <fmt:formatDate value="${article.publishedAt}" pattern="MMM d, yyyy"/>
                                                        </span>
                                                </div>
                                            </div>
                                        </a>
                                    </article>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <article class="side-article">
                                <div class="article-content">
                                    <span class="category-tag">Technology</span>
                                    <h3 class="article-title">No recent articles available</h3>
                                    <p class="no-content">Check back later for updates</p>
                                </div>
                            </article>
                        </c:otherwise>
                    </c:choose>
                </aside>
            </div>
        </div>
    </section>

    <!-- Trending Topics -->
    <section class="trending-section">
        <div class="container">
            <div class="trending-topics">
                <h4 class="trending-title">
                    <i class="fas fa-fire trending-icon"></i>
                    Trending Articles
                </h4>
                <div class="trending-links">
                    <c:choose>
                        <c:when test="${not empty trendingArticles}">
                            <c:forEach var="article" items="${trendingArticles}" varStatus="status">
                                <c:if test="${status.index < 5}">
                                    <a href="${pageContext.request.contextPath}/article/${article.id}" class="trending-link">
                                            ${article.title}
                                    </a>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <a href="#" class="trending-link">Climate Summit</a>
                            <a href="#" class="trending-link">Tech Layoffs</a>
                            <a href="#" class="trending-link">Healthcare Reform</a>
                            <a href="#" class="trending-link">Olympic Preparations</a>
                            <a href="#" class="trending-link">Stock Market</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Categories -->
    <section class="categories-section">
        <div class="container">
            <div class="featured-categories">
                <div class="section-header">
                    <h2 class="section-title">Latest by Category</h2>
                    <p class="section-subtitle">Discover news across different topics</p>
                </div>

                <!-- Technology Section -->
                <div class="category-section" id="technology">
                    <div class="category-header">
                        <h3 class="category-title">
                            <i class="fas fa-microchip category-icon"></i>
                            Technology
                        </h3>
                    </div>
                    <c:choose>
                        <c:when test="${not empty technologyArticles}">
                            <div class="section-articles">
                                <c:forEach var="article" items="${technologyArticles}">
                                    <article class="section-article-card">
                                        <a href="${pageContext.request.contextPath}/article/${article.id}" class="card-link">
                                            <c:if test="${not empty article.featureImage}">
                                                <div class="card-image-container">
                                                    <img src="${pageContext.request.contextPath}/article-image?id=${article.id}"
                                                         alt="${article.title}" class="card-image">
                                                </div>
                                            </c:if>
                                            <div class="card-content">
                                                <h4 class="card-title">
                                                        ${article.title}
                                                </h4>
                                                <c:if test="${not empty article.summary}">
                                                    <p class="card-excerpt">${article.summary}</p>
                                                </c:if>
                                                <div class="card-meta">
                                                    <span class="author">By ${article.author.username}</span>
                                                    <span class="date">
                                                            <fmt:formatDate value="${article.publishedAt}" pattern="MMM d, yyyy"/>
                                                        </span>
                                                </div>
                                            </div>
                                        </a>
                                    </article>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="no-articles">
                                <i class="fas fa-newspaper no-articles-icon"></i>
                                <p>No technology articles available</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Business Section -->
                <div class="category-section" id="business">
                    <div class="category-header">
                        <h3 class="category-title">
                            <i class="fas fa-chart-line category-icon"></i>
                            Business
                        </h3>
                    </div>
                    <c:choose>
                        <c:when test="${not empty businessArticles}">
                            <div class="section-articles">
                                <c:forEach var="article" items="${businessArticles}">
                                    <article class="section-article-card">
                                        <a href="${pageContext.request.contextPath}/article/${article.id}" class="card-link">
                                            <c:if test="${not empty article.featureImage}">
                                                <div class="card-image-container">
                                                    <img src="${pageContext.request.contextPath}/article-image?id=${article.id}"
                                                         alt="${article.title}" class="card-image">
                                                </div>
                                            </c:if>
                                            <div class="card-content">
                                                <h4 class="card-title">
                                                        ${article.title}
                                                </h4>
                                                <c:if test="${not empty article.summary}">
                                                    <p class="card-excerpt">${article.summary}</p>
                                                </c:if>
                                                <div class="card-meta">
                                                    <span class="author">By ${article.author.username}</span>
                                                    <span class="date">
                                                            <fmt:formatDate value="${article.publishedAt}" pattern="MMM d, yyyy"/>
                                                        </span>
                                                </div>
                                            </div>
                                        </a>
                                    </article>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="no-articles">
                                <i class="fas fa-newspaper no-articles-icon"></i>
                                <p>No business articles available</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Health Section -->
                <div class="category-section" id="health">
                    <div class="category-header">
                        <h3 class="category-title">
                            <i class="fas fa-heartbeat category-icon"></i>
                            Health
                        </h3>
                    </div>
                    <c:choose>
                        <c:when test="${not empty healthArticles}">
                            <div class="section-articles">
                                <c:forEach var="article" items="${healthArticles}">
                                    <article class="section-article-card">
                                        <a href="${pageContext.request.contextPath}/article/${article.id}" class="card-link">
                                            <c:if test="${not empty article.featureImage}">
                                                <div class="card-image-container">
                                                    <img src="${pageContext.request.contextPath}/article-image?id=${article.id}"
                                                         alt="${article.title}" class="card-image">
                                                </div>
                                            </c:if>
                                            <div class="card-content">
                                                <h4 class="card-title">
                                                        ${article.title}
                                                </h4>
                                                <c:if test="${not empty article.summary}">
                                                    <p class="card-excerpt">${article.summary}</p>
                                                </c:if>
                                                <div class="card-meta">
                                                    <span class="author">By ${article.author.username}</span>
                                                    <span class="date">
                                                            <fmt:formatDate value="${article.publishedAt}" pattern="MMM d, yyyy"/>
                                                        </span>
                                                </div>
                                            </div>
                                        </a>
                                    </article>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="no-articles">
                                <i class="fas fa-newspaper no-articles-icon"></i>
                                <p>No health articles available</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Sports Section -->
                <div class="category-section" id="sports">
                    <div class="category-header">
                        <h3 class="category-title">
                            <i class="fas fa-futbol category-icon"></i>
                            Sports
                        </h3>
                    </div>
                    <c:choose>
                        <c:when test="${not empty sportsArticles}">
                            <div class="section-articles">
                                <c:forEach var="article" items="${sportsArticles}">
                                    <article class="section-article-card">
                                        <a href="${pageContext.request.contextPath}/article/${article.id}" class="card-link">
                                            <c:if test="${not empty article.featureImage}">
                                                <div class="card-image-container">
                                                    <img src="${pageContext.request.contextPath}/article-image?id=${article.id}"
                                                         alt="${article.title}" class="card-image">
                                                </div>
                                            </c:if>
                                            <div class="card-content">
                                                <h4 class="card-title">
                                                        ${article.title}
                                                </h4>
                                                <c:if test="${not empty article.summary}">
                                                    <p class="card-excerpt">${article.summary}</p>
                                                </c:if>
                                                <div class="card-meta">
                                                    <span class="author">By ${article.author.username}</span>
                                                    <span class="date">
                                                            <fmt:formatDate value="${article.publishedAt}" pattern="MMM d, yyyy"/>
                                                        </span>
                                                </div>
                                            </div>
                                        </a>
                                    </article>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="no-articles">
                                <i class="fas fa-newspaper no-articles-icon"></i>
                                <p>No sports articles available</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="../layouts/footer.jsp"/>
</body>
</html>