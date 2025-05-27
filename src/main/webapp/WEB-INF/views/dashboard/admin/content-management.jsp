<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Article Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard/admin/content-management.css"/>
</head>
<body>
<div class="container">
    <h1>Article Management</h1>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">${errorMessage}</div>
    </c:if>

    <table class="table">
        <thead>
        <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Author</th>
            <th>Summary</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty pendingArticles}">
                <c:forEach var="article" items="${pendingArticles}">
                    <tr>
                        <td><c:out value="${article.id}"/></td>
                        <td><c:out value="${article.title}"/></td>
                        <td><c:out value="${article.authorId != null ? article.authorId : 'N/A'}"/></td>
                        <td>
                            <c:set var="summaryText" value="${fn:length(article.summary) > 100 ? fn:substring(article.summary, 0, 100) : article.summary}" />
                            <c:out value="${summaryText}"/>...
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="viewArticle?id=${article.id}" class="btn btn-info">View</a>
                                <a href="approveArticle?id=${article.id}" class="btn btn-success">Approve</a>
                                <a href="#${article.id}" class="btn btn-danger" onclick="openRejectModal('${article.id}')">Reject</a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr><td colspan="5" style="text-align:center;">No pending articles found.</td></tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>


<!-- Reject Modal -->
<div id="rejectModal" class="modal">
    <div class="modal-dialog">
        <div class="modal-header">
            <span class="modal-title">Reject Article</span>
            <button class="close" onclick="closeModal('rejectModal')">&times;</button>
        </div>
        <form method="get" action="rejectArticle">
            <div class="modal-body">
                <input type="hidden" name="articleId" id="rejectArticleId">
                <div class="form-group">
                    <label for="rejectionReason">Reason for rejection</label>
                    <textarea name="rejectionReason" id="rejectionReason" class="form-control" rows="4" required></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('rejectModal')">Cancel</button>
                <button type="submit" class="btn btn-danger">Reject</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openRejectModal(articleId) {
        console.log("this is funciton clicked");
        console.log("this is article id of reject",articleId);
        document.getElementById("rejectArticleId").value = articleId;
        document.getElementById("rejectionReason").value = ""; // Clear previous input
        document.getElementById("rejectModal").classList.add("show");
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.remove("show");
    }
</script>

</body>
</html>
