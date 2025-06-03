<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trending News - AaoNews</title>

    <%@ include file="../layouts/reusable.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/trending.css">
</head>
<body>
<jsp:include page="../layouts/navbar.jsp"/>

<main class="main-content">
    <!-- Hero Section -->
    <section class="trending-hero">
        <div class="container">
            <div class="hero-content">
                <div class="hero-text">
                    <h1 class="hero-title">
                        <i class="fas fa-fire trending-icon"></i>
                        Trending News
                    </h1>
                    <p class="hero-subtitle">
                        Discover the most popular and talked-about stories right now
                    </p>
                    <div class="trending-stats">
                        <div class="stat-badge">
                            <span class="stat-number">${not empty trendingArticles ? trendingArticles.size() : '0'}</span>
                            <span class="stat-label">Trending Articles</span>
                        </div>
                        <div class="stat-badge">
                            <span class="stat-number">Live</span>
                            <span class="stat-label">Updated</span>
                        </div>
                    </div>
                </div>
                <div class="hero-visual">
                    <div class="trending-pulse">
                        <i class="fas fa-chart-line"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Trending Article -->
    <c:if test="${not empty trendingArticles}">
        <section class="featured-trending">
            <div class="container">
                <div class="featured-header">
                    <h2 class="featured-title">
                        <i class="fas fa-crown"></i>
                        Most Trending Right Now
                    </h2>
                </div>

                <c:set var="featuredArticle" value="${trendingArticles[0]}" />
                <article class="featured-article">
                    <a href="${pageContext.request.contextPath}/article/${featuredArticle.id}" class="featured-link">
                        <div class="featured-content">
                            <div class="featured-image-section">
                                <c:choose>
                                    <c:when test="${not empty featuredArticle.featureImage}">
                                        <img src="${pageContext.request.contextPath}/article-image?id=${featuredArticle.id}"
                                             alt="${featuredArticle.title}" class="featured-image">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="featured-placeholder">
                                            <i class="fas fa-newspaper"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="trending-overlay">
                                    <div class="trending-badge">
                                        <i class="fas fa-fire"></i>
                                        #1 Trending
                                    </div>
                                </div>
                            </div>

                            <div class="featured-text">
                                <div class="featured-meta">
                                        <span class="category-badge category-${featuredArticle.categoryId}">
                                            <c:choose>
                                                <c:when test="${featuredArticle.categoryId eq 1}">Technology</c:when>
                                                <c:when test="${featuredArticle.categoryId eq 2}">Business</c:when>
                                                <c:when test="${featuredArticle.categoryId eq 3}">Health</c:when>
                                                <c:when test="${featuredArticle.categoryId eq 4}">Sports</c:when>
                                                <c:when test="${featuredArticle.categoryId eq 5}">Culture</c:when>
                                                <c:when test="${featuredArticle.categoryId eq 6}">Politics</c:when>
                                                <c:when test="${featuredArticle.categoryId eq 7}">Science</c:when>
                                                <c:when test="${featuredArticle.categoryId eq 8}">Entertainment</c:when>
                                                <c:otherwise>News</c:otherwise>
                                            </c:choose>
                                        </span>
                                    <span class="trending-time">
                                            <fmt:formatDate value="${featuredArticle.publishedAt}" pattern="MMM d, yyyy"/>
                                        </span>
                                </div>

                                <h3 class="featured-article-title">${featuredArticle.title}</h3>

                                <c:if test="${not empty featuredArticle.summary}">
                                    <p class="featured-excerpt">${featuredArticle.summary}</p>
                                </c:if>

                                <div class="featured-footer">
                                    <div class="author-info">
                                        <span class="author-name">By ${featuredArticle.author.username}</span>
                                    </div>
                                    <div class="engagement-info">
                                            <span class="views-count">
                                                <i class="fas fa-eye"></i>
                                                ${featuredArticle.viewCount} views
                                            </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </a>
                </article>
            </div>
        </section>
    </c:if>

    <!-- Trending Articles Grid -->
    <section class="trending-articles">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">All Trending Articles</h2>
                <p class="section-subtitle">Stay updated with the most popular stories</p>
            </div>

            <c:choose>
                <c:when test="${not empty trendingArticles}">
                    <div class="articles-grid">
                        <c:forEach var="article" items="${trendingArticles}" varStatus="status">
                            <c:if test="${status.index > 0}"> <!-- Skip first article as it's featured -->
                                <article class="article-card rank-${status.index + 1}">
                                    <a href="${pageContext.request.contextPath}/article/${article.id}" class="article-link">
                                        <div class="card-header">
                                            <div class="rank-badge">
                                                <span class="rank-number">#${status.index + 1}</span>
                                                <div class="trend-indicator">
                                                    <i class="fas fa-arrow-up"></i>
                                                </div>
                                            </div>
                                            <div class="card-image-container">
                                                <c:choose>
                                                    <c:when test="${not empty article.featureImage}">
                                                        <img src="${pageContext.request.contextPath}/article-image?id=${article.id}"
                                                             alt="${article.title}" class="card-image">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="image-placeholder">
                                                            <i class="fas fa-newspaper"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="card-body">
                                            <div class="card-meta">
                                                    <span class="category-tag category-${article.categoryId}">
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
                                                <span class="publish-time">
                                                        <fmt:formatDate value="${article.publishedAt}" pattern="MMM d"/>
                                                    </span>
                                            </div>

                                            <h3 class="card-title">${article.title}</h3>

                                            <c:if test="${not empty article.summary}">
                                                <p class="card-excerpt">${article.summary}</p>
                                            </c:if>

                                            <div class="card-footer">
                                                <div class="author-meta">
                                                    <span class="author">By ${article.author.username}</span>
                                                </div>
                                                <div class="engagement-stats">
                                                        <span class="views">
                                                            <i class="fas fa-eye"></i>
                                                            ${article.viewCount}
                                                        </span>
                                                    <span class="trending-score">
                                                            <i class="fas fa-fire"></i>
                                                            ${status.index <= 3 ? 'Hot' : status.index <= 6 ? 'Rising' : 'Trending'}
                                                        </span>
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                </article>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-trending">
                        <div class="no-trending-content">
                            <i class="fas fa-chart-line no-trending-icon"></i>
                            <h3>No Trending Articles</h3>
                            <p>No trending articles are available at the moment. Check back later for the latest trending news!</p>
                            <a href="${pageContext.request.contextPath}/home" class="back-home-btn">
                                <i class="fas fa-home"></i>
                                Back to Home
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- Call to Action -->
    <c:if test="${not empty trendingArticles}">
        <section class="trending-cta">
            <div class="container">
                <div class="cta-content">
                    <h2 class="cta-title">Stay Updated with Trending News</h2>
                    <p class="cta-subtitle">Don't miss out on the stories everyone is talking about</p>
                    <div class="cta-actions">
                        <a href="${pageContext.request.contextPath}/home" class="cta-btn primary">
                            <i class="fas fa-home"></i>
                            Explore All News
                        </a>
                        <a href="${pageContext.request.contextPath}/categories" class="cta-btn secondary">
                            <i class="fas fa-th-large"></i>
                            Browse Categories
                        </a>
                    </div>
                </div>
            </div>
        </section>
    </c:if>
</main>

<jsp:include page="../layouts/footer.jsp"/>


<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Add smooth scrolling for internal links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Add intersection observer for animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('animate-in');
                }
            });
        }, observerOptions);

        // Observe article cards for animation
        document.querySelectorAll('.article-card, .featured-article').forEach(card => {
            observer.observe(card);
        });

        });

        // Add hover effects for better UX
        document.querySelectorAll('.article-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px)';
            });

            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });
    });
</script>
</body>
</html>
