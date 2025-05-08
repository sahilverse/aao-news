<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Set up mock data if real data is not available --%>

<c:if test="${empty publisherStats}">
    <c:set var="totalArticles" value="24" />
    <c:set var="totalViews" value="15742" />
    <c:set var="totalLikes" value="3891" />
    <c:set var="totalComments" value="527" />
    <c:set var="publishedArticles" value="18" />
    <c:set var="pendingArticles" value="3" />
    <c:set var="draftArticles" value="5" />
    <c:set var="rejectedArticles" value="2" />
</c:if>

<c:if test="${empty topArticle}">
    <jsp:useBean id="publishedDate" class="java.util.Date" />
    <jsp:useBean id="now" class="java.util.Date" />
    <c:set target="${publishedDate}" property="time" value="${now.time - 7776000000}" /> <%-- 90 days ago --%>

    <c:set var="topArticleTitle" value="The Future of Renewable Energy: Breakthroughs in Solar Technology" />
    <c:set var="topArticleSlug" value="future-renewable-energy-solar-breakthroughs" />
    <c:set var="topArticleSummary" value="Recent advancements in solar panel efficiency and energy storage are revolutionizing how we think about renewable energy. This article explores the latest technologies and their potential impact on global energy markets." />
    <c:set var="topArticleViews" value="4256" />
    <c:set var="topArticleLikes" value="982" />
    <c:set var="topArticleComments" value="137" />
</c:if>

<c:if test="${empty recentActivities}">
    <jsp:useBean id="activity1Time" class="java.util.Date" />
    <jsp:useBean id="activity2Time" class="java.util.Date" />
    <jsp:useBean id="activity3Time" class="java.util.Date" />
    <jsp:useBean id="activity4Time" class="java.util.Date" />
    <jsp:useBean id="activity5Time" class="java.util.Date" />

    <c:set target="${activity1Time}" property="time" value="${now.time - 1800000}" /> <%-- 30 minutes ago --%>
    <c:set target="${activity2Time}" property="time" value="${now.time - 7200000}" /> <%-- 2 hours ago --%>
    <c:set target="${activity3Time}" property="time" value="${now.time - 86400000}" /> <%-- 1 day ago --%>
    <c:set target="${activity4Time}" property="time" value="${now.time - 172800000}" /> <%-- 2 days ago --%>
    <c:set target="${activity5Time}" property="time" value="${now.time - 259200000}" /> <%-- 3 days ago --%>
</c:if>

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
                <p class="stat-number">${not empty publisherStats.totalArticles ? publisherStats.totalArticles : totalArticles}</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-eye"></i>
            </div>
            <div class="stat-content">
                <h3>Total Views</h3>
                <p class="stat-number">${not empty publisherStats.totalViews ? publisherStats.totalViews : totalViews}</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-thumbs-up"></i>
            </div>
            <div class="stat-content">
                <h3>Total Likes</h3>
                <p class="stat-number">${not empty publisherStats.totalLikes ? publisherStats.totalLikes : totalLikes}</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-comment"></i>
            </div>
            <div class="stat-content">
                <h3>Total Comments</h3>
                <p class="stat-number">${not empty publisherStats.totalComments ? publisherStats.totalComments : totalComments}</p>
            </div>
        </div>
    </div>

    <!-- Top Performing Article -->
    <div class="section-container">
        <div class="section-header">
            <h2><i class="fas fa-trophy"></i> Top Performing Article</h2>
        </div>

        <c:choose>
            <c:when test="${not empty topArticle || not empty topArticleTitle}">
                <div class="top-article-card">
                    <div class="article-info">
                        <h3>${not empty topArticle.title ? topArticle.title : topArticleTitle}</h3>
                        <p class="article-date"><i class="fas fa-calendar-alt"></i> Published:
                            <fmt:formatDate value="${not empty topArticle.publishedAt ? topArticle.publishedAt : publishedDate}" pattern="MMM d, yyyy" />
                        </p>
                        <p class="article-summary">${not empty topArticle.summary ? topArticle.summary : topArticleSummary}</p>

                        <div class="article-metrics">
                            <div class="metric">
                                <i class="fas fa-eye"></i>
                                <span>${not empty topArticle.viewCount ? topArticle.viewCount : topArticleViews} views</span>
                            </div>
                            <div class="metric">
                                <i class="fas fa-thumbs-up"></i>
                                <span>${not empty topArticle.likeCount ? topArticle.likeCount : topArticleLikes} likes</span>
                            </div>
                            <div class="metric">
                                <i class="fas fa-comment"></i>
                                <span>${not empty topArticle.commentCount ? topArticle.commentCount : topArticleComments} comments</span>
                            </div>
                        </div>

                        <a href="${pageContext.request.contextPath}/article/${not empty topArticle.slug ? topArticle.slug : topArticleSlug}" class="view-article-btn">View Article</a>
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
                    <p class="status-number">${not empty publisherStats.publishedArticles ? publisherStats.publishedArticles : publishedArticles}</p>
                </div>
            </div>

            <div class="status-card">
                <div class="status-icon pending">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="status-content">
                    <h3>Pending Review</h3>
                    <p class="status-number">${not empty publisherStats.pendingArticles ? publisherStats.pendingArticles : pendingArticles}</p>
                </div>
            </div>

            <div class="status-card">
                <div class="status-icon draft">
                    <i class="fas fa-file-lines"></i>
                </div>
                <div class="status-content">
                    <h3>Drafts</h3>
                    <p class="status-number">${not empty publisherStats.draftArticles ? publisherStats.draftArticles : draftArticles}</p>
                </div>
            </div>

            <div class="status-card">
                <div class="status-icon rejected">
                    <i class="fas fa-times-circle"></i>
                </div>
                <div class="status-content">
                    <h3>Rejected</h3>
                    <p class="status-number">${not empty publisherStats.rejectedArticles ? publisherStats.rejectedArticles : rejectedArticles}</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Activity -->
    <div class="section-container">
        <div class="section-header">
            <h2><i class="fas fa-history"></i> Recent Activity</h2>
        </div>

        <div class="activity-feed">
            <c:choose>
                <c:when test="${not empty recentActivities}">
                    <c:forEach items="${recentActivities}" var="activity">
                        <div class="activity-item">
                            <div class="activity-icon ${activity.type}">
                                <c:choose>
                                    <c:when test="${activity.type == 'comment'}">
                                        <i class="fas fa-comment"></i>
                                    </c:when>
                                    <c:when test="${activity.type == 'like'}">
                                        <i class="fas fa-thumbs-up"></i>
                                    </c:when>
                                    <c:when test="${activity.type == 'view'}">
                                        <i class="fas fa-eye"></i>
                                    </c:when>
                                    <c:when test="${activity.type == 'publish'}">
                                        <i class="fas fa-check-circle"></i>
                                    </c:when>
                                </c:choose>
                            </div>
                            <div class="activity-content">
                                <p>${activity.message}</p>
                                <span class="activity-time"><fmt:formatDate value="${activity.timestamp}" pattern="MMM d, yyyy h:mm a" /></span>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <%-- Mock activity data --%>
                    <div class="activity-item">
                        <div class="activity-icon comment">
                            <i class="fas fa-comment"></i>
                        </div>
                        <div class="activity-content">
                            <p>John Doe commented on your article "The Future of Renewable Energy"</p>
                            <span class="activity-time"><fmt:formatDate value="${activity1Time}" pattern="MMM d, yyyy h:mm a" /></span>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-icon like">
                            <i class="fas fa-thumbs-up"></i>
                        </div>
                        <div class="activity-content">
                            <p>Your article "Climate Change: The Road Ahead" received 15 new likes</p>
                            <span class="activity-time"><fmt:formatDate value="${activity2Time}" pattern="MMM d, yyyy h:mm a" /></span>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-icon view">
                            <i class="fas fa-eye"></i>
                        </div>
                        <div class="activity-content">
                            <p>Your article "Tech Innovations of 2023" reached 1,000 views</p>
                            <span class="activity-time"><fmt:formatDate value="${activity3Time}" pattern="MMM d, yyyy h:mm a" /></span>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-icon publish">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="activity-content">
                            <p>Your article "The Impact of AI on Modern Journalism" was approved and published</p>
                            <span class="activity-time"><fmt:formatDate value="${activity4Time}" pattern="MMM d, yyyy h:mm a" /></span>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-icon comment">
                            <i class="fas fa-comment"></i>
                        </div>
                        <div class="activity-content">
                            <p>Maria Garcia commented on your article "Global Economic Trends for 2023"</p>
                            <span class="activity-time"><fmt:formatDate value="${activity5Time}" pattern="MMM d, yyyy h:mm a" /></span>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
