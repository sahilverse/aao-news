<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Set mock data if real data is not available --%>
<c:if test="${empty requestScope.articles}">
    <c:set var="mockArticles" value="true" />
</c:if>

<div class="articles-container">
    <!-- Page Header -->
    <div class="articles-header">
        <div class="articles-title">
            <h1>My Articles</h1>
            <span class="article-count">${mockArticles ? '24' : fn:length(requestScope.articles)} articles</span>
        </div>
        <div class="articles-actions">
            <div class="search-container">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Search articles..." class="search-input">
            </div>
            <a href="${pageContext.request.contextPath}/publisher/create" class="create-article-btn">
                <i class="fas fa-plus"></i> Create New Article
            </a>
        </div>
    </div>

    <!-- Filters -->
    <div class="articles-filters">
        <div class="filter-group">
            <label>Status:</label>
            <select class="filter-select" id="status-filter">
                <option value="all">All</option>
                <option value="published">Published</option>
                <option value="pending">Pending Review</option>
                <option value="draft">Draft</option>
                <option value="rejected">Rejected</option>
            </select>
        </div>
        <div class="filter-group">
            <label>Sort By:</label>
            <select class="filter-select" id="sort-filter">
                <option value="newest">Newest First</option>
                <option value="oldest">Oldest First</option>
                <option value="views">Most Viewed</option>
                <option value="likes">Most Liked</option>
            </select>
        </div>
        <button class="clear-filters-btn">
            <i class="fas fa-times"></i> Clear Filters
        </button>
    </div>

    <!-- Articles List -->
    <div class="articles-list">
        <c:choose>
            <c:when test="${not mockArticles}">
                <c:forEach var="article" items="${requestScope.articles}">
                    <!-- Real article data here -->
                    <div class="article-card">
                        <!-- Content populated from real data -->
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <!-- Mock Article 1 -->
                <div class="article-card">
                    <div class="article-header">
                        <h2 class="article-title">
                            <a href="#">The Future of Renewable Energy: Breakthroughs in Solar Technology</a>
                        </h2>
                        <div class="article-meta">
                            <span class="article-date">Published 3 months ago</span>
                            <span class="article-status published">
                                <i class="fas fa-check-circle"></i> Published
                            </span>
                        </div>
                    </div>
                    <div class="article-content">
                        <p class="article-excerpt">
                            Recent advancements in solar panel efficiency have revolutionized the renewable energy sector. This article explores the latest breakthroughs and their potential impact on global energy production.
                        </p>
                    </div>
                    <div class="article-footer">
                        <div class="article-category">
                            <span class="category-label">Category:</span>
                            <span class="category-value">Technology</span>
                        </div>
                        <div class="article-tags">
                            <span class="tag">Renewable Energy</span>
                            <span class="tag">Solar</span>
                            <span class="tag">Innovation</span>
                        </div>
                        <div class="article-stats">
                            <span class="stat"><i class="fas fa-eye"></i> 4,256</span>
                            <span class="stat"><i class="fas fa-heart"></i> 982</span>
                            <span class="stat"><i class="fas fa-comment"></i> 137</span>
                        </div>
                        <div class="article-actions">
                            <button class="action-btn edit-btn"><i class="fas fa-edit"></i> Edit</button>
                            <button class="action-btn delete-btn"><i class="fas fa-trash"></i> Delete</button>
                            <button class="action-btn preview-btn"><i class="fas fa-eye"></i> Preview</button>
                        </div>
                    </div>
                </div>

                <!-- Mock Article 2 -->
                <div class="article-card">
                    <div class="article-header">
                        <h2 class="article-title">
                            <a href="#">Understanding Artificial Intelligence: A Beginner's Guide</a>
                        </h2>
                        <div class="article-meta">
                            <span class="article-date">Published 2 weeks ago</span>
                            <span class="article-status published">
                                <i class="fas fa-check-circle"></i> Published
                            </span>
                        </div>
                    </div>
                    <div class="article-content">
                        <p class="article-excerpt">
                            Artificial Intelligence is transforming industries across the globe. This comprehensive guide explains the fundamentals of AI in simple terms for beginners.
                        </p>
                    </div>
                    <div class="article-footer">
                        <div class="article-category">
                            <span class="category-label">Category:</span>
                            <span class="category-value">Technology</span>
                        </div>
                        <div class="article-tags">
                            <span class="tag">AI</span>
                            <span class="tag">Machine Learning</span>
                            <span class="tag">Technology</span>
                        </div>
                        <div class="article-stats">
                            <span class="stat"><i class="fas fa-eye"></i> 2,187</span>
                            <span class="stat"><i class="fas fa-heart"></i> 543</span>
                            <span class="stat"><i class="fas fa-comment"></i> 89</span>
                        </div>
                        <div class="article-actions">
                            <button class="action-btn edit-btn"><i class="fas fa-edit"></i> Edit</button>
                            <button class="action-btn delete-btn"><i class="fas fa-trash"></i> Delete</button>
                            <button class="action-btn preview-btn"><i class="fas fa-eye"></i> Preview</button>
                        </div>
                    </div>
                </div>

                <!-- Mock Article 3 -->
                <div class="article-card">
                    <div class="article-header">
                        <h2 class="article-title">
                            <a href="#">The Psychology of Decision Making: Why We Make Poor Choices</a>
                        </h2>
                        <div class="article-meta">
                            <span class="article-date">Last updated 5 days ago</span>
                            <span class="article-status pending">
                                <i class="fas fa-clock"></i> Pending Review
                            </span>
                        </div>
                    </div>
                    <div class="article-content">
                        <p class="article-excerpt">
                            Cognitive biases affect our decision-making processes in profound ways. This article examines the psychological factors that lead to poor choices and offers strategies for improvement.
                        </p>
                    </div>
                    <div class="article-footer">
                        <div class="article-category">
                            <span class="category-label">Category:</span>
                            <span class="category-value">Psychology</span>
                        </div>
                        <div class="article-tags">
                            <span class="tag">Decision Making</span>
                            <span class="tag">Cognitive Bias</span>
                            <span class="tag">Psychology</span>
                        </div>
                        <div class="article-stats">
                            <span class="stat"><i class="fas fa-eye"></i> 0</span>
                            <span class="stat"><i class="fas fa-heart"></i> 0</span>
                            <span class="stat"><i class="fas fa-comment"></i> 0</span>
                        </div>
                        <div class="article-actions">
                            <button class="action-btn edit-btn"><i class="fas fa-edit"></i> Edit</button>
                            <button class="action-btn delete-btn"><i class="fas fa-trash"></i> Delete</button>
                            <button class="action-btn preview-btn"><i class="fas fa-eye"></i> Preview</button>
                        </div>
                    </div>
                </div>

                <!-- Mock Article 4 -->
                <div class="article-card">
                    <div class="article-header">
                        <h2 class="article-title">
                            <a href="#">Sustainable Living: 10 Simple Changes for a Greener Home</a>
                        </h2>
                        <div class="article-meta">
                            <span class="article-date">Created 2 days ago</span>
                            <span class="article-status draft">
                                <i class="fas fa-file"></i> Draft
                            </span>
                        </div>
                    </div>
                    <div class="article-content">
                        <p class="article-excerpt">
                            Making your home more environmentally friendly doesn't have to be complicated or expensive. These 10 simple changes can significantly reduce your carbon footprint.
                        </p>
                    </div>
                    <div class="article-footer">
                        <div class="article-category">
                            <span class="category-label">Category:</span>
                            <span class="category-value">Lifestyle</span>
                        </div>
                        <div class="article-tags">
                            <span class="tag">Sustainability</span>
                            <span class="tag">Environment</span>
                            <span class="tag">Home</span>
                        </div>
                        <div class="article-stats">
                            <span class="stat"><i class="fas fa-eye"></i> 0</span>
                            <span class="stat"><i class="fas fa-heart"></i> 0</span>
                            <span class="stat"><i class="fas fa-comment"></i> 0</span>
                        </div>
                        <div class="article-actions">
                            <button class="action-btn edit-btn"><i class="fas fa-edit"></i> Edit</button>
                            <button class="action-btn delete-btn"><i class="fas fa-trash"></i> Delete</button>
                            <button class="action-btn preview-btn"><i class="fas fa-eye"></i> Preview</button>
                        </div>
                    </div>
                </div>

                <!-- Mock Article 5 -->
                <div class="article-card">
                    <div class="article-header">
                        <h2 class="article-title">
                            <a href="#">The Impact of Social Media on Mental Health</a>
                        </h2>
                        <div class="article-meta">
                            <span class="article-date">Submitted 1 week ago</span>
                            <span class="article-status rejected">
                                <i class="fas fa-times-circle"></i> Rejected
                            </span>
                        </div>
                    </div>
                    <div class="article-content">
                        <p class="article-excerpt">
                            Social media has transformed how we communicate, but at what cost? This article examines the growing body of research on social media's impact on mental health and well-being.
                        </p>
                        <p class="rejection-reason">
                            <strong>Rejection reason:</strong> Needs more research citations and expert opinions. Please revise and resubmit.
                        </p>
                    </div>
                    <div class="article-footer">
                        <div class="article-category">
                            <span class="category-label">Category:</span>
                            <span class="category-value">Health</span>
                        </div>
                        <div class="article-tags">
                            <span class="tag">Mental Health</span>
                            <span class="tag">Social Media</span>
                            <span class="tag">Psychology</span>
                        </div>
                        <div class="article-stats">
                            <span class="stat"><i class="fas fa-eye"></i> 0</span>
                            <span class="stat"><i class="fas fa-heart"></i> 0</span>
                            <span class="stat"><i class="fas fa-comment"></i> 0</span>
                        </div>
                        <div class="article-actions">
                            <button class="action-btn edit-btn"><i class="fas fa-edit"></i> Edit</button>
                            <button class="action-btn delete-btn"><i class="fas fa-trash"></i> Delete</button>
                            <button class="action-btn preview-btn"><i class="fas fa-eye"></i> Preview</button>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Pagination -->
    <div class="articles-pagination">
        <div class="pagination-info">
            Showing <span>1-5</span> of <span>24</span> articles
        </div>
        <div class="pagination-controls">
            <button class="pagination-btn" disabled><i class="fas fa-chevron-left"></i> Previous</button>
            <div class="pagination-pages">
                <button class="page-btn active">1</button>
                <button class="page-btn">2</button>
                <button class="page-btn">3</button>
                <button class="page-btn">4</button>
                <button class="page-btn">5</button>
            </div>
            <button class="pagination-btn">Next <i class="fas fa-chevron-right"></i></button>
        </div>
        <div class="pagination-per-page">
            <label>Items per page:</label>
            <select class="per-page-select">
                <option value="5">5</option>
                <option value="10">10</option>
                <option value="20">20</option>
                <option value="50">50</option>
            </select>
        </div>
    </div>
</div>

<script>
    // Filter functionality
    document.getElementById('status-filter').addEventListener('change', function() {
        filterArticles();
    });

    document.getElementById('sort-filter').addEventListener('change', function() {
        sortArticles();
    });

    document.querySelector('.clear-filters-btn').addEventListener('click', function() {
        document.getElementById('status-filter').value = 'all';
        document.getElementById('sort-filter').value = 'newest';
        resetFilters();
    });

    function filterArticles() {
        // This would be implemented with real data
        console.log('Filtering articles...');
    }

    function sortArticles() {
        // This would be implemented with real data
        console.log('Sorting articles...');
    }

    function resetFilters() {
        // This would be implemented with real data
        console.log('Resetting filters...');
    }
</script>
