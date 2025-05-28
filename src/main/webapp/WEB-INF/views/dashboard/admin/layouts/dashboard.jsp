<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="dashboard-content">
    <div class="dashboard-header ">
        <h1 class="dashboard-title">Admin Dashboard</h1>
        <div class="dashboard-actions">
            <div class="date-display">
                <i class="fas fa-calendar-alt"></i>
                <span id="current-date">
                    <script>
                        document.getElementById('current-date').textContent = new Date().toLocaleDateString('en-US', {
                            weekday: 'long',
                            year: 'numeric',
                            month: 'long',
                            day: 'numeric'
                        });
                    </script>
                </span>
            </div>
            <button class="refresh-btn" onclick="window.location.reload();">
                <i class="fas fa-sync-alt"></i> Refresh Data
            </button>
        </div>
    </div>

    <!-- Stats Overview Cards -->
    <div class="stats-overview">
        <div class="stat-card users-card">
            <div class="stat-icon">
                <i class="fas fa-users"></i>
            </div>
            <div class="stat-details">
                <h3 class="stat-title">Total Users</h3>
                <p class="stat-value">${no_of_users}</p>
                <p class="stat-description">Registered users on the platform</p>
            </div>
        </div>

        <div class="stat-card publishers-card">
            <div class="stat-icon">
                <i class="fas fa-user-edit"></i>
            </div>
            <div class="stat-details">
                <h3 class="stat-title">Verified Publishers</h3>
                <p class="stat-value">${no_of_publishers}</p>
                <p class="stat-description">Active content creators</p>
            </div>
        </div>

        <div class="stat-card articles-card">
            <div class="stat-icon">
                <i class="fas fa-newspaper"></i>
            </div>
            <div class="stat-details">
                <h3 class="stat-title">Total Articles</h3>
                <p class="stat-value">${no_of_articles}</p>
                <p class="stat-description">Published content pieces</p>
            </div>
        </div>

        <div class="stat-card actions-card">
            <div class="stat-icon">
                <i class="fas fa-tasks"></i>
            </div>
            <div class="stat-details">
                <h3 class="stat-title">Quick Actions</h3>
                <div class="quick-actions">
                    <a href="${pageContext.request.contextPath}/admin/publisher-approval" class="quick-action-btn">
                        <i class="fas fa-user-check"></i> Approve Publishers
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/content-management" class="quick-action-btn">
                        <i class="fas fa-file-alt"></i> Manage Content
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Dashboard Content -->
    <div class="dashboard-main">
        <!-- Left Column - Most Viewed Articles -->
        <div class="dashboard-column">
            <div class="dashboard-card">
                <div class="card-header">
                    <h2 class="card-title"><i class="fas fa-chart-line"></i> Most Viewed Articles</h2>
                    <div class="card-actions">
                        <button class="card-action-btn" onclick="exportTableToCSV('most-viewed-articles')">
                            <i class="fas fa-download"></i> Export
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty most_viewedArticles}">
                            <div class="table-responsive">
                                <table class="data-table" id="most-viewed-articles">
                                    <thead>
                                    <tr>
                                        <th>Title</th>
                                        <th>Author</th>
                                        <th>Category</th>
                                        <th>Views</th>
                                        <th>Published</th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="article" items="${most_viewedArticles}">
                                        <tr>
                                            <td class="article-title">
                                                <a href="${pageContext.request.contextPath}/article/${article.id}"
                                                   target="_blank">
                                                        ${article.title}
                                                </a>
                                            </td>
                                            <td>
                                                <c:if test="${not empty article.author}">
                                                    ${article.author.username}
                                                </c:if>
                                                <c:if test="${empty article.author}">
                                                    Unknown
                                                </c:if>
                                            </td>
                                            <td>
                                                    <span class="category-badge category-${article.categoryId}">
                                                        <c:choose>
                                                            <c:when test="${article.categoryId eq 1}">Technology</c:when>
                                                            <c:when test="${article.categoryId eq 2}">Business</c:when>
                                                            <c:when test="${article.categoryId eq 3}">Health</c:when>
                                                            <c:when test="${article.categoryId eq 4}">Sports</c:when>
                                                            <c:when test="${article.categoryId eq 5}">Culture</c:when>
                                                            <c:when test="${article.categoryId eq 6}">Politics</c:when>
                                                            <c:when test="${article.categoryId eq 7}">Science</c:when>
                                                            <c:when test="${article.categoryId eq 8}">Entertainment</c:when>
                                                            <c:otherwise>General</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                            </td>
                                            <td class="view-count">${article.viewCount}</td>
                                            <td>
                                                <fmt:formatDate value="${article.publishedAt}" pattern="MMM dd, yyyy"/>
                                            </td>
                                            <td class="actions-cell">
                                                <div class="table-actions">
                                                    <a href="${pageContext.request.contextPath}/article/${article.id}"
                                                       class="action-btn view-btn" title="View Article">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/admin/content-management?edit=${article.id}"
                                                       class="action-btn edit-btn" title="Edit Article">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="no-data-message">
                                <i class="fas fa-chart-bar"></i>
                                <p>No article view data available yet.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Right Column - Search and Recent Activity -->
            <div class="dashboard-column">
                <!-- Article Search -->
                <div class="dashboard-card">
                    <div class="card-header">
                        <h2 class="card-title"><i class="fas fa-search"></i> Article Search</h2>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/dashboard" method="get" class="search-form">
                            <div class="search-container">
                                <input type="text" name="searchQuery"
                                       placeholder="Search articles by title, author, or content..."
                                       value="${searchQuery}" class="search-input">
                                <button type="submit" class="search-btn">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                            <div class="search-filters">
                                <div class="filter-group">
                                    <label for="categoryFilter">Category:</label>
                                    <select id="categoryFilter" name="category" class="filter-select">
                                        <option value="">All Categories</option>
                                        <option value="1">Technology</option>
                                        <option value="2">Business</option>
                                        <option value="3">Health</option>
                                        <option value="4">Sports</option>
                                        <option value="5">Culture</option>
                                        <option value="6">Politics</option>
                                        <option value="7">Science</option>
                                        <option value="8">Entertainment</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label for="statusFilter">Status:</label>
                                    <select id="statusFilter" name="status" class="filter-select">
                                        <option value="">All Statuses</option>
                                        <option value="PUBLISHED">Published</option>
                                        <option value="PENDING_REVIEW">Pending Review</option>
                                        <option value="REJECTED">Rejected</option>
                                        <option value="DRAFT">Draft</option>
                                    </select>
                                </div>
                            </div>
                        </form>


                        <!-- Search Results -->
                        <div class="search-results">
                            <c:if test="${not empty searchQuery}">
                                <h3 class="results-title">Search Results for "${searchQuery}"</h3>

                                <c:choose>
                                    <c:when test="${not empty searchResults}">
                                        <div class="table-responsive">
                                            <table class="data-table search-results-table">
                                                <thead>
                                                <tr>
                                                    <th>Title</th>
                                                    <th>Author</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:forEach var="article" items="${searchResults}">
                                                    <tr>
                                                        <td class="article-title">
                                                            <a href="${pageContext.request.contextPath}/article/${article.id}"
                                                               target="_blank">
                                                                    ${article.title}
                                                            </a>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty article.author}">
                                                                ${article.author.username}
                                                            </c:if>
                                                            <c:if test="${empty article.author}">
                                                                Unknown
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                                    <span class="status-badge status-${article.status}">
                                                                            ${article.status}
                                                                    </span>
                                                        </td>
                                                        <td class="actions-cell">
                                                            <div class="table-actions">
                                                                <a href="${pageContext.request.contextPath}/article/${article.id}"
                                                                   class="action-btn view-btn" title="View Article">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>

                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-results">
                                            <i class="fas fa-search"></i>
                                            <p>No articles found matching your search criteria.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>