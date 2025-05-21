<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="articles-container">
    <!-- Page Header -->
    <div class="articles-header">
        <div class="articles-title">
            <h1>My Articles</h1>
            <span class="article-count">${fn:length(requestScope.articles)} articles</span>
        </div>
        <div class="articles-actions">

            <a href="${pageContext.request.contextPath}/publisher/create" class="create-article-btn">
                <i class="fas fa-plus"></i> Create New Article
            </a>
        </div>
    </div>

    <!-- Display Error message if any -->
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert">
                ${sessionScope.errorMessage}
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Display success message if any -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="success">
                ${sessionScope.successMessage}
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <!-- Filters -->
    <div class="articles-filters">
        <div class="filter-group">
            <label>Status:</label>
            <select class="filter-select" id="status-filter">
                <option value="all">All</option>
                <option value="published">Published</option>
                <option value="pending_review">Pending Review</option>
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
            <c:when test="${not empty requestScope.articles}">
                <c:forEach var="article" items="${requestScope.articles}">
                    <div class="article-card">
                        <div class="article-header">
                            <h2 class="article-title">
                                <a href="${pageContext.request.contextPath}/article/${article.id}">${article.title}</a>
                            </h2>
                            <div class="article-meta">
                                <c:choose>
                                    <c:when test="${article.status eq 'PUBLISHED' and not empty article.createdAt}">
                                        <span class="article-date">Published <fmt:formatDate value="${article.createdAt}" pattern="MMM d, yyyy" /></span>
                                    </c:when>
                                    <c:when test="${not empty article.updatedAt}">
                                        <span class="article-date">Last updated <fmt:formatDate value="${article.updatedAt}" pattern="MMM d, yyyy" /></span>
                                    </c:when>
                                </c:choose>

                                <c:choose>
                                    <c:when test="${article.status eq 'PUBLISHED'}">
                                        <span class="article-status published">
                                            <i class="fas fa-check-circle"></i> Published
                                        </span>
                                    </c:when>
                                    <c:when test="${article.status eq 'PENDING_REVIEW'}">
                                        <span class="article-status pending">
                                            <i class="fas fa-clock"></i> Pending Review
                                        </span>
                                    </c:when>
                                    <c:when test="${article.status eq 'DRAFT'}">
                                        <span class="article-status draft">
                                            <i class="fas fa-file"></i> Draft
                                        </span>
                                    </c:when>
                                    <c:when test="${article.status eq 'REJECTED'}">
                                        <span class="article-status rejected">
                                            <i class="fas fa-times-circle"></i> Rejected
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="article-status">
                                            <i class="fas fa-question-circle"></i> ${article.status}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="article-content">
                            <p class="article-excerpt">
                                    ${article.summary}
                            </p>
                            <c:if test="${not empty article.rejectionMessage and article.status eq 'REJECTED'}">
                                <p class="rejection-reason">
                                    <strong>Rejection reason:</strong> ${article.rejectionMessage}
                                </p>
                            </c:if>
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
                            <div class="article-stats">
                                <span class="stat"><i class="fas fa-eye"></i> ${article.viewCount}</span>
                                <span class="stat"><i class="fas fa-heart"></i>
                                    <c:out value="${article.likeCount}" default="0"/>
                                </span>
                                <span class="stat"><i class="fas fa-comment"></i>
                                    <c:out value="${article.commentCount}" default="0"/>
                                </span>
                            </div>
                            <div class="article-actions">
                                <a href="${pageContext.request.contextPath}/publisher/edit?id=${article.id}" class="action-btn edit-btn">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                                <button class="action-btn delete-btn" onclick="confirmDelete(${article.id})">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                                <a href="${pageContext.request.contextPath}/article/${article.id}" class="action-btn preview-btn" target="_blank">
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
                    <p>You haven't created any articles yet. Click the "Create New Article" button to get started.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Pagination -->
    <c:if test="${not empty requestScope.articles and fn:length(requestScope.articles) > 0}">
        <div class="articles-pagination">
            <div class="pagination-info">
                Showing <span>${requestScope.startIndex + 1}-${requestScope.endIndex}</span> of <span>${requestScope.totalArticles}</span> articles
            </div>
            <div class="pagination-controls">
                <c:choose>
                    <c:when test="${requestScope.currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/publisher/articles?page=${requestScope.currentPage - 1}&size=${requestScope.pageSize}&status=${requestScope.statusFilter}&sort=${requestScope.sortFilter}" class="pagination-btn">
                            <i class="fas fa-chevron-left"></i> Previous
                        </a>
                    </c:when>
                    <c:otherwise>
                        <button class="pagination-btn" disabled><i class="fas fa-chevron-left"></i> Previous</button>
                    </c:otherwise>
                </c:choose>

                <div class="pagination-pages">
                    <c:forEach begin="1" end="${requestScope.totalPages}" var="i">
                        <c:choose>
                            <c:when test="${requestScope.currentPage eq i}">
                                <button class="page-btn active">${i}</button>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/publisher/articles?page=${i}&size=${requestScope.pageSize}&status=${requestScope.statusFilter}&sort=${requestScope.sortFilter}" class="page-btn">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>

                <c:choose>
                    <c:when test="${requestScope.currentPage < requestScope.totalPages}">
                        <a href="${pageContext.request.contextPath}/publisher/articles?page=${requestScope.currentPage + 1}&size=${requestScope.pageSize}&status=${requestScope.statusFilter}&sort=${requestScope.sortFilter}" class="pagination-btn">
                            Next <i class="fas fa-chevron-right"></i>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <button class="pagination-btn" disabled>Next <i class="fas fa-chevron-right"></i></button>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="pagination-per-page">
                <label for="pageSelect" >Items per page:</label>
                <select  id="pageSelect"  class="per-page-select" onchange="changePageSize(this.value)">
                    <option value="5" ${requestScope.pageSize eq 5 ? 'selected' : ''}>5</option>
                    <option value="10" ${requestScope.pageSize eq 10 ? 'selected' : ''}>10</option>
                    <option value="20" ${requestScope.pageSize eq 20 ? 'selected' : ''}>20</option>
                    <option value="50" ${requestScope.pageSize eq 50 ? 'selected' : ''}>50</option>
                </select>
            </div>
        </div>
    </c:if>


        <%--    Modal--%>
    <div id="deleteModal" class="custom-modal" style="display: none;">
        <div class="custom-modal-content">
            <span class="custom-close" onclick="closeModal()">&times;</span>
            <h2>Confirm Deletion</h2>
            <p id="deleteModalMessage">Are you sure you want to delete this article? This action cannot be undone.</p>
            <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/publisher/delete-article">
                <input type="hidden" name="articleId" id="deleteArticleId">
                <div class="modal-actions">
                    <button type="button" onclick="closeModal()" class="cancel-btn">Cancel</button>
                    <button type="submit" class="confirm-btn">Delete</button>
                </div>
            </form>
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
        const status = document.getElementById('status-filter').value;
        window.location.href = '${pageContext.request.contextPath}/publisher/articles?status=' + status +
            '&sort=' + document.getElementById('sort-filter').value + "&page=1&size=${requestScope.pageSize}"
    }

    function sortArticles() {
        const sort = document.getElementById('sort-filter').value;
        window.location.href = '${pageContext.request.contextPath}/publisher/articles?status=' +
            document.getElementById('status-filter').value + '&sort=' + sort + "&page=1&size=${requestScope.pageSize}"
    }

    function resetFilters() {
        window.location.href = '${pageContext.request.contextPath}/publisher/articles';
    }

    function changePageSize(size) {
        window.location.href = '${pageContext.request.contextPath}/publisher/articles?page=1&size=' + size + "&status=${requestScope.statusFilter}&sort=${requestScope.sortFilter}";
    }

    function confirmDelete(articleId) {
        document.getElementById("deleteArticleId").value = articleId;
        document.getElementById("deleteModal").style.display = "flex";
    }

    function closeModal() {
        document.getElementById("deleteModal").style.display = "none";
    }


    // Set the current filter values based on URL parameters
    window.addEventListener('load', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status');
        const sort = urlParams.get('sort');

        if (status) {
            document.getElementById('status-filter').value = status;
        }

        if (sort) {
            document.getElementById('sort-filter').value = sort;
        }
    });
</script>