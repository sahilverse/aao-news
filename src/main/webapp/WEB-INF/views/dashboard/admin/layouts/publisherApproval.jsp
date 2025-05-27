<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>




<div class="container adminContainer">
    <h1>Pending Publishers Verification</h1>

    <div class="stats">
        <strong>Total Pending Publishers: ${fn:length(pendingPublishers)}</strong>
    </div>

    <c:choose>
        <c:when test="${empty pendingPublishers}">
            <div class="no-data">
                <h3>No Pending Publishers</h3>
                <p>All publishers have been verified or there are no pending requests at this time.</p>
            </div>
        </c:when>
        <c:otherwise>
            <table class="publisher-table">
                <thead>
                <tr>
                    <th>Publisher ID</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Status</th>
                    <th>Verification Date</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="publisher" items="${pendingPublishers}" varStatus="status">
                    <tr>
                        <td>
                            <span class="publisher-id">#${publisher.publisherId}</span>
                        </td>
                        <td>
                            <strong>${publisher.fullName}</strong>
                        </td>
                        <td>
                            <span class="email">${publisher.email}</span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${publisher.isVerified}">
                                    <span class="status-badge status-verified">Verified</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-pending">Pending</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${publisher.verificationDate != null}">
                                    <fmt:formatDate value="${publisher.verificationDate}"
                                                    pattern="MMM dd, yyyy HH:mm" />
                                </c:when>
                                <c:otherwise>
                                    <em>Not verified yet</em>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <c:if test="${!publisher.isVerified}">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/usermanagement" style="display: inline;">
                                        <input type="hidden" name="publisherId" value="${publisher.publisherId}">

                                        <button type="submit" class="btn btn-approve" value="approve" name="action"
                                                onclick="return confirm('Are you sure you want to approve this publisher?')">
                                            Approve
                                        </button>
                                        <button type="submit" class="btn btn-reject" value="reject" name="action"
                                                onclick="return confirm('Are you sure you want to reject this publisher?')">
                                            Reject
                                        </button>
                                    </form>

                                </c:if>
                                <a href="viewPublisher?id=${publisher.publisherId}" class="btn btn-view">
                                    View Details
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
