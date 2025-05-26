<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>



<div class="dashboard-content">
    <!-- Welcome Section -->
    <div class="welcome-section">
        <div class="welcome-text">
            <h1>Welcome, ${sessionScope.currentPublisher.fullName}</h1>
            <p>
                <c:choose>
                    <c:when test="${ sessionScope.currentPublisher.isVerified}">
                        <span class="verified-badge"><i class="fas fa-check-circle"></i> Verified Publisher</span>
                    </c:when>
                    <c:otherwise>
                        <span class="pending-badge"><i class="fas fa-clock"></i> Verification Pending</span>
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
        <div class="date-info">
            <p><i class="fas fa-calendar"></i> <fmt:formatDate value="<%= new java.util.Date() %>" pattern="EEEE, MMMM d, yyyy" /></p>
        </div>
    </div>

    <!-- Stats Overview -->
    <div class="stats-overview">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-newspaper"></i>
            </div>
            <div class="stat-content">
                <h3>Total Articles</h3>
                <p class="stat-number">${requestScope.totalArticles}</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-eye"></i>
            </div>
            <div class="stat-content">
                <h3>Total Views</h3>
                <p class="stat-number">${requestScope.totalViews}</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-thumbs-up"></i>
            </div>
            <div class="stat-content">
                <h3>Total Likes</h3>
                <p class="stat-number">${requestScope.totalLikes}</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-comment"></i>
            </div>
            <div class="stat-content">
                <h3>Total Comments</h3>
                <p class="stat-number">${requestScope.totalComments}</p>
            </div>
        </div>
    </div>

    <!-- Top Performing Article -->
    <div class="section-container">
        <div class="section-header">
            <h2><i class="fas fa-trophy"></i> Top Performing Article</h2>
        </div>

        <c:choose>
            <c:when test="${not empty requestScope.topArticle}">
                <div class="top-article-card">
                    <div class="article-info">
                        <h3>${topArticle.title}</h3>
                        <p class="article-date"><i class="fas fa-calendar-alt"></i> Published:
                            <fmt:formatDate value="${topArticle.createdAt}" pattern="MMM d, yyyy" />
                        </p>
                        <p class="article-summary">${topArticle.summary}</p>

                        <div class="article-metrics">
                            <div class="metric">
                                <i class="fas fa-eye"></i>
                                <span>${topArticle.viewCount} views</span>
                            </div>
                            <div class="metric">
                                <i class="fas fa-thumbs-up"></i>
                                <span>${topArticle.likeCount} likes</span>
                            </div>
                            <div class="metric">
                                <i class="fas fa-comment"></i>
                                <span>${topArticle.commentCount } comments</span>
                            </div>
                        </div>

                        <a href="${pageContext.request.contextPath}/article/${topArticle.id}" class="view-article-btn">View Article</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-data-message">
                    <p>You haven't published any articles yet. Start creating content to see performance metrics.</p>
                    <a href="${pageContext.request.contextPath}/publisher/create" class="create-article-btn">Create Your First Article</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Quick Actions -->
    <div class="section-container">
        <div class="section-header">
            <h2><i class="fas fa-bolt"></i> Quick Actions</h2>
        </div>

        <div class="quick-actions">
            <a href="${pageContext.request.contextPath}/publisher/create" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-pen-to-square"></i>
                </div>
                <div class="action-content">
                    <h3>Create New Article</h3>
                    <p>Start writing a new article</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/publisher/articles" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-list-ul"></i>
                </div>
                <div class="action-content">
                    <h3>Manage Articles</h3>
                    <p>View and edit your articles</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/publisher/profile" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-user-edit"></i>
                </div>
                <div class="action-content">
                    <h3>Edit Profile</h3>
                    <p>Update your publisher profile</p>
                </div>
            </a>
        </div>
    </div>

    <!-- Publishing Status -->
    <div class="section-container">
        <div class="section-header">
            <h2><i class="fas fa-tasks"></i> Publishing Status</h2>
        </div>

        <div class="publishing-status">
            <div class="status-card">
                <div class="status-icon published">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="status-content">
                    <h3>Published</h3>
                    <p class="status-number">${requestScope.publishedCount}</p>
                </div>
            </div>

            <div class="status-card">
                <div class="status-icon pending">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="status-content">
                    <h3>Pending Review</h3>
                    <p class="status-number">${requestScope.pendingCount}</p>
                </div>
            </div>

            <div class="status-card">
                <div class="status-icon draft">
                    <i class="fas fa-file-lines"></i>
                </div>
                <div class="status-content">
                    <h3>Drafts</h3>
                    <p class="status-number">${requestScope.draftCount}</p>
                </div>
            </div>

            <div class="status-card">
                <div class="status-icon rejected">
                    <i class="fas fa-times-circle"></i>
                </div>
                <div class="status-content">
                    <h3>Rejected</h3>
                    <p class="status-number">${requestScope.rejectedCount}</p>
                </div>
            </div>
        </div>
    </div>
</div>
