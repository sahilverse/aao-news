<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="content-container" style="margin-top: 20px;">
    <div class="header">
        <h1>Article Management</h1>
        <p>Review and manage pending articles</p>
    </div>

    <div class="stats-container">
        <div class="stat-card">
            <div class="stat-number">${fn:length(articles)}</div>
            <div class="stat-label">Pending Articles</div>
        </div>

    </div>

    <div class="table-container">
        <div class="table-header">
            <h2>Pending Articles for Review</h2>
            <p>Review, approve, or reject articles submitted by authors</p>
        </div>

        <c:choose>
            <c:when test="${empty articles}">
                <div class="no-articles">
                    <h3>🎉 No Pending Articles</h3>
                    <p>All articles have been reviewed. Great job!</p>
                </div>
            </c:when>
            <c:otherwise>
                <table class="articles-table">
                    <thead>
                    <tr>
                        <th>Title</th>
                        <th>Summary</th>
                        <th>Author</th>
                        <th>Category</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="article" items="${articles}" varStatus="status">
                        <tr>
                            <td>
                                <div class="article-title" title="${article.title}">${article.title}</div>
                                <div class="date-text">ID: #${article.id}</div>
                            </td>
                            <td>
                                <div class="article-summary" title="${article.summary}">
                                        ${fn:substring(article.summary, 0, 100)}
                                    <c:if test="${fn:length(article.summary) > 100}">...</c:if>
                                </div>
                            </td>
                            <td>Author: ${article.author.fullName}</td>
                            <td>Category: ${article.categoryId}</td>
                            <td>${article.viewCount}</td>
                            <td class="action-buttons">
                                <form method="post" action="${pageContext.request.contextPath}/admin/content-management" style="display:inline;">
                                    <input type="hidden" name="articleId" value="${article.id}" />
                                    <input type="hidden" name="action" value="approve">
                                    <button type="submit" class="btn btn-approve" onclick="return confirm('Are you sure you want to approve this article?')">✅ Approve</button>
                                </form>
                                <button type="button" class="btn btn-reject" onclick="openRejectModal(${article.id}, '${fn:escapeXml(article.title)}')">❌ Reject</button>
                                <a href="${pageContext.request.contextPath}/article/${article.id}" class="btn btn-view" target="_blank">Preview</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Rejection Modal -->
<div id="rejectModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Reject Article <span class="close" onclick="closeRejectModal()">&times;</span></h3>
        </div>
        <form id="rejectForm" method="post" action="${pageContext.request.contextPath}/admin/content-management">
            <div class="modal-body">
                <input type="hidden" id="rejectArticleId" name="articleId" />
                <input type="hidden" name="action" value="reject">
                <div class="form-group">
                    <label for="articleTitle">Article:</label>
                    <input type="text" id="articleTitle" class="form-control" readonly />
                </div>
                <div class="form-group">
                    <label for="rejectionReason">Reason for Rejection: <span style="color: red;">*</span></label>
                    <textarea id="rejectionReason" name="rejectionMessage" class="form-control" required
                              placeholder="Please provide a detailed reason for rejecting this article..."></textarea>
                </div>
                <div class="alert">
                    <strong>Note:</strong> The author will receive this message. Please be constructive and specific.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeRejectModal()">Cancel</button>
                <button type="submit" class="btn btn-reject">Reject Article</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openRejectModal(articleId, articleTitle) {
        document.getElementById('rejectArticleId').value = articleId;
        document.getElementById('articleTitle').value = articleTitle;
        document.getElementById('rejectionReason').value = '';
        document.getElementById('rejectModal').style.display = 'block';
        document.body.style.overflow = 'hidden';
    }

    function closeRejectModal() {
        document.getElementById('rejectModal').style.display = 'none';
        document.body.style.overflow = 'auto';
    }

    window.onclick = function (event) {
        const modal = document.getElementById('rejectModal');
        if (event.target == modal) {
            closeRejectModal();
        }
    }

    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape') {
            closeRejectModal();
        }
    });

    document.getElementById('rejectForm').addEventListener('submit', function (e) {
        const reason = document.getElementById('rejectionReason').value.trim();
        if (reason.length < 10) {
            e.preventDefault();
            alert('Please provide a more detailed rejection reason (at least 10 characters).');
            return false;
        }

        if (!confirm('Are you sure you want to reject this article? This action cannot be undone.')) {
            e.preventDefault();
            return false;
        }
    });

    document.getElementById('rejectionReason').addEventListener('input', function () {
        this.style.height = 'auto';
        this.style.height = this.scrollHeight + 'px';
    });
</script>
