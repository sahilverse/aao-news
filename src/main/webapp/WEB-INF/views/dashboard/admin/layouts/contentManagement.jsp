<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="content-management-container">
    <!-- Page Header -->
    <div class="page-header">
        <div class="header-content">
            <h1 class="page-title">
                <i class="fas fa-file-alt"></i> Content Management
            </h1>
            <p class="page-description">
                Review and moderate pending articles before publication
            </p>
        </div>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/admin/analytics" class="action-button">
                <i class="fas fa-chart-bar"></i> Analytics
            </a>
            <button class="action-button refresh-btn" onclick="window.location.reload();">
                <i class="fas fa-sync-alt"></i> Refresh
            </button>
        </div>
    </div>

    <!-- Content Statistics -->
    <div class="content-stats">
        <div class="stat-card pending-card">
            <div class="stat-icon">
                <i class="fas fa-clock"></i>
            </div>
            <div class="stat-details">
                <h3 class="stat-title">Pending Review</h3>
                <p class="stat-value">${articles.size()}</p>
                <p class="stat-description">Articles awaiting approval</p>
            </div>
        </div>

        <div class="stat-card approved-card">
            <div class="stat-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-details">
                <h3 class="stat-title">Approved Today</h3>
                <p class="stat-value" id="approvedToday">0</p>
                <p class="stat-description">Articles published</p>
            </div>
        </div>

        <div class="stat-card rejected-card">
            <div class="stat-icon">
                <i class="fas fa-times-circle"></i>
            </div>
            <div class="stat-details">
                <h3 class="stat-title">Rejected Today</h3>
                <p class="stat-value" id="rejectedToday">0</p>
                <p class="stat-description">Articles rejected</p>
            </div>
        </div>

        <div class="stat-card processing-card">
            <div class="stat-icon">
                <i class="fas fa-hourglass-half"></i>
            </div>
            <div class="stat-details">
                <h3 class="stat-title">Avg. Review Time</h3>
                <p class="stat-value">1.2 hours</p>
                <p class="stat-description">Average processing time</p>
            </div>
        </div>
    </div>

    <!-- Content Management Tools -->
    <div class="content-tools">
        <div class="search-filter-section">
            <div class="search-container">
                <input type="text" id="articleSearchInput" placeholder="Search by title, author, or content..." class="search-input">
                <button class="search-btn">
                    <i class="fas fa-search"></i>
                </button>
            </div>

            <div class="filter-container">
                <select id="categoryFilter" class="filter-select">
                    <option value="">All Categories</option>
                    <option value="politics">Politics</option>
                    <option value="technology">Technology</option>
                    <option value="sports">Sports</option>
                    <option value="entertainment">Entertainment</option>
                    <option value="business">Business</option>
                    <option value="health">Health</option>
                </select>

                <select id="sortFilter" class="filter-select">
                    <option value="date_desc">Newest First</option>
                    <option value="date_asc">Oldest First</option>
                    <option value="title_asc">Title (A-Z)</option>
                    <option value="title_desc">Title (Z-A)</option>
                    <option value="author_asc">Author (A-Z)</option>
                </select>

                <button class="filter-btn" id="bulkActionsBtn">
                    <i class="fas fa-tasks"></i> Bulk Actions
                </button>
            </div>
        </div>
    </div>

    <!-- Articles Content -->
    <div class="articles-content">
        <c:choose>
            <c:when test="${not empty articles}">
                <!-- Bulk Actions Bar -->
                <div class="bulk-actions-bar" id="bulkActionsBar" style="display: none;">
                    <div class="bulk-info">
                        <span id="selectedCount">0</span> article(s) selected
                    </div>
                    <div class="bulk-buttons">
                        <button class="bulk-btn approve-bulk" onclick="bulkApprove()">
                            <i class="fas fa-check"></i> Approve Selected
                        </button>
                        <button class="bulk-btn reject-bulk" onclick="bulkReject()">
                            <i class="fas fa-times"></i> Reject Selected
                        </button>
                        <button class="bulk-btn cancel-bulk" onclick="cancelBulkSelection()">
                            Cancel
                        </button>
                    </div>
                </div>

                <!-- Articles Grid -->
                <div class="articles-grid" id="articlesGrid">
                    <c:forEach var="article" items="${articles}">
                        <div class="article-card" data-id="${article.id}">
                            <div class="card-header">
                                <div class="selection-checkbox">
                                    <input type="checkbox" class="article-checkbox" value="${article.id}">
                                </div>
                                <div class="article-meta">
                                    <div class="author-info">

                                        <div class="author-details">
                                            <span class="author-name">${article.author.username}</span>
                                            <span class="submission-date">
                                                <fmt:formatDate value="${article.createdAt}" pattern="MMM dd, yyyy" />
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card-body">
                                <div class="article-content">
                                    <h3 class="article-title">${article.title}</h3>

                                    <c:if test="${not empty article.summary}">
                                        <div class="article-summary">
                                            <h4>Summary:</h4>
                                            <p>${article.summary}</p>
                                        </div>
                                    </c:if>

                                    <div class="article-preview">
                                        <h4>Content Preview:</h4>
                                        <div class="content-preview">
                                            <c:choose>
                                                <c:when test="${fn:length(article.content) > 300}">
                                                    ${fn:substring(article.content, 0, 300)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${article.content}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <button class="read-more-btn" onclick="viewFullArticle(${article.id})">
                                            <i class="fas fa-expand-alt"></i> Read Full Article
                                        </button>
                                    </div>

                                    <div class="article-details">
                                        <div class="detail-item">
                                            <i class="fas fa-file-alt"></i>
                                            <span>Article ID: ${article.id}</span>
                                        </div>
                                        <div class="detail-item">
                                            <i class="fas fa-user"></i>
                                            <span>Author: ${article.author.username}</span>
                                        </div>
                                        <div class="detail-item">
                                            <i class="fas fa-calendar-alt"></i>
                                            <span>Submitted:
                                                <fmt:formatDate value="${article.createdAt}" pattern="MMM dd, yyyy 'at' h:mm a" />
                                            </span>
                                        </div>
                                        <div class="detail-item">
                                            <i class="fas fa-align-left"></i>
                                            <span>Word Count: <span class="word-count" data-content="${article.content}">--</span></span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card-footer">
                                <div class="action-buttons">
                                    <button class="action-btn view-btn" onclick="viewFullArticle(${article.id})" title="View Full Article">
                                        <i class="fas fa-eye"></i>
                                        View Full
                                    </button>

                                    <button class="action-btn approve-btn" onclick="approveArticle(${article.id}, '${article.title}')" title="Approve Article">
                                        <i class="fas fa-check"></i>
                                        Approve
                                    </button>
                                    <button class="action-btn reject-btn" onclick="rejectArticle(${article.id}, '${article.title}')" title="Reject Article">
                                        <i class="fas fa-times"></i>
                                        Reject
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Load More Section -->
                <div class="load-more-section">
                    <button class="load-more-btn" id="loadMoreBtn" style="display: none;">
                        <i class="fas fa-plus"></i>
                        Load More Articles
                    </button>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-articles-message">
                    <i class="fas fa-check-circle"></i>
                    <h3>All Articles Reviewed!</h3>
                    <p>There are no pending articles requiring review at the moment.</p>
                    <p>New submissions will appear here when they need moderation.</p>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="action-button">
                        <i class="fas fa-tachometer-alt"></i> Back to Dashboard
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Full Article Modal -->
<div class="modal" id="fullArticleModal">
    <div class="modal-content large-modal">
        <div class="modal-header">
            <h3>Article Review</h3>
            <button class="close-btn" onclick="closeFullArticleModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body" id="fullArticleContent">
            <!-- Content will be loaded dynamically -->
        </div>
        <div class="modal-footer">
            <button class="cancel-btn" onclick="closeFullArticleModal()">Close</button>
            <button class="edit-btn" id="modalEditBtn">
                <i class="fas fa-edit"></i> Edit
            </button>
            <button class="approve-btn" id="modalApproveBtn">
                <i class="fas fa-check"></i> Approve
            </button>
            <button class="reject-btn" id="modalRejectBtn">
                <i class="fas fa-times"></i> Reject
            </button>
        </div>
    </div>
</div>

<!-- Approval Confirmation Modal -->
<div class="modal" id="approvalModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Approve Article</h3>
            <button class="close-btn" onclick="closeApprovalModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <div class="confirmation-content">
                <div class="confirmation-icon approve-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <p>Are you sure you want to approve and publish this article?</p>
                <p class="article-title-confirm" id="approveArticleTitle"></p>
                <p class="confirmation-note">
                    This article will be immediately published and visible to all users.
                </p>
            </div>
        </div>
        <div class="modal-footer">
            <button class="cancel-btn" onclick="closeApprovalModal()">Cancel</button>
            <form id="approveForm" method="post" action="${pageContext.request.contextPath}/admin/content-management">
                <input type="hidden" id="approveArticleId" name="articleId" value="">
                <input type="hidden" name="action" value="approve">
                <button type="submit" class="confirm-btn approve-confirm">
                    <i class="fas fa-check"></i> Approve & Publish
                </button>
            </form>
        </div>
    </div>
</div>

<!-- Rejection Confirmation Modal -->
<div class="modal" id="rejectionModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Reject Article</h3>
            <button class="close-btn" onclick="closeRejectionModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <div class="confirmation-content">
                <div class="confirmation-icon reject-icon">
                    <i class="fas fa-times-circle"></i>
                </div>
                <p>Are you sure you want to reject this article?</p>
                <p class="article-title-confirm" id="rejectArticleTitle"></p>

                <div class="rejection-reason">
                    <label for="rejectionReason">Reason for rejection:</label>
                    <textarea id="rejectionReason" name="rejectionReason" class="form-textarea" rows="4"
                              placeholder="Please provide a reason for rejection to help the author improve..." required></textarea>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="cancel-btn" onclick="closeRejectionModal()">Cancel</button>
            <form id="rejectForm" method="post" action="${pageContext.request.contextPath}/admin/content-management">
                <input type="hidden" id="rejectArticleId" name="articleId" value="">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" id="rejectReasonInput" name="rejectionReason" value="">
                <button type="submit" class="confirm-btn reject-confirm">
                    <i class="fas fa-times"></i> Reject Article
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    // Initialize page
    document.addEventListener('DOMContentLoaded', function() {
        initializeSearch();
        initializeSorting();
        initializeBulkActions();
        calculateWordCounts();
        updateStats();
    });

    // Calculate word counts for articles
    function calculateWordCounts() {
        const wordCountElements = document.querySelectorAll('.word-count');
        wordCountElements.forEach(element => {
            const content = element.getAttribute('data-content');
            if (content) {
                const wordCount = content.trim().split(/\s+/).length;
                element.textContent = wordCount.toLocaleString();
            }
        });
    }

    // Search functionality
    function initializeSearch() {
        const searchInput = document.getElementById('articleSearchInput');
        const categoryFilter = document.getElementById('categoryFilter');

        function performSearch() {
            const searchTerm = searchInput.value.toLowerCase();
            const selectedCategory = categoryFilter.value.toLowerCase();
            const articleCards = document.querySelectorAll('.article-card');

            let visibleCount = 0;

            articleCards.forEach(card => {
                const title = card.querySelector('.article-title').textContent.toLowerCase();
                const author = card.querySelector('.author-name').textContent.toLowerCase();
                const content = card.querySelector('.content-preview').textContent.toLowerCase();
                const category = card.getAttribute('data-category').toLowerCase();

                const matchesSearch = title.includes(searchTerm) ||
                    author.includes(searchTerm) ||
                    content.includes(searchTerm);
                const matchesCategory = !selectedCategory || category === selectedCategory;

                if (matchesSearch && matchesCategory) {
                    card.style.display = '';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });
        }

        searchInput.addEventListener('keyup', performSearch);
        categoryFilter.addEventListener('change', performSearch);
    }

    // Sorting functionality
    function initializeSorting() {
        const sortFilter = document.getElementById('sortFilter');
        sortFilter.addEventListener('change', function() {
            const sortValue = this.value;
            const container = document.getElementById('articlesGrid');
            const cards = Array.from(container.querySelectorAll('.article-card'));

            cards.sort((a, b) => {
                switch(sortValue) {
                    case 'title_asc':
                        return a.querySelector('.article-title').textContent.localeCompare(
                            b.querySelector('.article-title').textContent
                        );
                    case 'title_desc':
                        return b.querySelector('.article-title').textContent.localeCompare(
                            a.querySelector('.article-title').textContent
                        );
                    case 'author_asc':
                        return a.querySelector('.author-name').textContent.localeCompare(
                            b.querySelector('.author-name').textContent
                        );
                    case 'date_asc':
                        return new Date(a.querySelector('.submission-date').textContent.trim()) -
                            new Date(b.querySelector('.submission-date').textContent.trim());
                    case 'date_desc':
                        return new Date(b.querySelector('.submission-date').textContent.trim()) -
                            new Date(a.querySelector('.submission-date').textContent.trim());
                    default:
                        return 0;
                }
            });

            // Clear container and append sorted cards
            while (container.firstChild) {
                container.removeChild(container.firstChild);
            }

            cards.forEach(card => container.appendChild(card));
        });
    }

    // Bulk actions functionality
    function initializeBulkActions() {
        const bulkActionsBtn = document.getElementById('bulkActionsBtn');
        const checkboxes = document.querySelectorAll('.article-checkbox');

        bulkActionsBtn.addEventListener('click', function() {
            const bulkBar = document.getElementById('bulkActionsBar');
            const isVisible = bulkBar.style.display !== 'none';

            if (isVisible) {
                cancelBulkSelection();
            } else {
                bulkBar.style.display = 'flex';
                this.textContent = 'Cancel Bulk';
                this.innerHTML = '<i class="fas fa-times"></i> Cancel Bulk';
            }
        });

        checkboxes.forEach(checkbox => {
            checkbox.addEventListener('change', updateBulkSelection);
        });
    }

    function updateBulkSelection() {
        const selectedCheckboxes = document.querySelectorAll('.article-checkbox:checked');
        const selectedCount = selectedCheckboxes.length;

        document.getElementById('selectedCount').textContent = selectedCount;

        const bulkButtons = document.querySelectorAll('.bulk-btn:not(.cancel-bulk)');
        bulkButtons.forEach(btn => {
            btn.disabled = selectedCount === 0;
        });
    }

    function cancelBulkSelection() {
        const bulkBar = document.getElementById('bulkActionsBar');
        const bulkActionsBtn = document.getElementById('bulkActionsBtn');
        const checkboxes = document.querySelectorAll('.article-checkbox');

        bulkBar.style.display = 'none';
        bulkActionsBtn.innerHTML = '<i class="fas fa-tasks"></i> Bulk Actions';

        checkboxes.forEach(checkbox => {
            checkbox.checked = false;
        });

        updateBulkSelection();
    }

    function bulkApprove() {
        const selectedIds = Array.from(document.querySelectorAll('.article-checkbox:checked'))
            .map(cb => cb.value);

        if (selectedIds.length === 0) return;

        if (confirm(`Are you sure you want to approve and publish ${selectedIds.length} article(s)?`)) {
            alert(`Bulk approval of ${selectedIds.length} articles would be processed here.`);
            cancelBulkSelection();
        }
    }

    function bulkReject() {
        const selectedIds = Array.from(document.querySelectorAll('.article-checkbox:checked'))
            .map(cb => cb.value);

        if (selectedIds.length === 0) return;

        if (confirm(`Are you sure you want to reject ${selectedIds.length} article(s)?`)) {
            alert(`Bulk rejection of ${selectedIds.length} articles would be processed here.`);
            cancelBulkSelection();
        }
    }

    // Article actions
    function viewFullArticle(articleId) {
        const modal = document.getElementById('fullArticleModal');
        const content = document.getElementById('fullArticleContent');

        content.innerHTML = `
            <div class="loading-spinner">
                <i class="fas fa-spinner fa-spin"></i>
                Loading full article...
            </div>
        `;

        modal.style.display = 'flex';

        setTimeout(() => {
            content.innerHTML = `
                <div class="full-article-content">
                    <h2>Full Article Content</h2>
                    <p>This would display the complete article content for review.</p>
                    <p>Article ID: ${articleId}</p>
                </div>
            `;
        }, 1000);
    }

    function editArticle(articleId) {
        alert(`Edit functionality for article ${articleId} would be implemented here.`);
    }

    function approveArticle(articleId, articleTitle) {
        document.getElementById('approveArticleId').value = articleId;
        document.getElementById('approveArticleTitle').textContent = articleTitle;
        document.getElementById('approvalModal').style.display = 'flex';
    }

    function rejectArticle(articleId, articleTitle) {
        document.getElementById('rejectArticleId').value = articleId;
        document.getElementById('rejectArticleTitle').textContent = articleTitle;
        document.getElementById('rejectionModal').style.display = 'flex';
    }

    // Modal functions
    function closeFullArticleModal() {
        document.getElementById('fullArticleModal').style.display = 'none';
    }

    function closeApprovalModal() {
        document.getElementById('approvalModal').style.display = 'none';
    }

    function closeRejectionModal() {
        document.getElementById('rejectionModal').style.display = 'none';
    }

    // Handle rejection form submission
    document.getElementById('rejectForm').addEventListener('submit', function(e) {
        const reason = document.getElementById('rejectionReason').value;
        if (!reason.trim()) {
            e.preventDefault();
            alert('Please provide a reason for rejection.');
            return;
        }
        document.getElementById('rejectReasonInput').value = reason;
    });

    // Update statistics
    function updateStats() {
        document.getElementById('approvedToday').textContent = Math.floor(Math.random() * 20);
        document.getElementById('rejectedToday').textContent = Math.floor(Math.random() * 5);
    }

    // Close modals when clicking outside
    window.onclick = function(event) {
        const modals = document.querySelectorAll('.modal');
        modals.forEach(modal => {
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        });
    }
</script>