<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/dashboard">
            <div class="logo">Aaonews</div>
        </a>
<%--        <h2>Publisher Portal</h2>--%>
    </div>

    <nav class="sidebar-nav">
        <ul>
            <c:choose>
                <%-- admin Navigation--%>
                <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
                    <li class="${currentPage eq 'dashboard' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>

                    <li class="${currentPage eq 'user-management' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/user-management">
                            <i class="fas fa-users"></i>
                            <span>User Management</span>
                        </a>
                    </li>

                    <li class="${currentPage eq 'publisher-approval' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/pending-publishers">
                            <i class="fas fa-check-circle"></i>
                            <span>Publisher Approval</span>
                        </a>
                    </li>

                    <li class="${currentPage eq 'content-management' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/content-management">
                            <i class="fas fa-newspaper"></i>
                            <span>Content Management</span>
                        </a>
                    </li>
                </c:when>

                <%-- Publisher Navigation--%>
                <c:when test="${sessionScope.currentUser.role == 'PUBLISHER'}">
                    <li class="${currentPage eq 'dashboard' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/publisher/dashboard">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="${currentPage eq 'articles' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/publisher/articles">
                            <i class="fas fa-newspaper"></i>
                            <span>My Articles</span>
                        </a>
                    </li>
                    <li class="${currentPage eq 'new-article' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/publisher/new-article">
                            <i class="fas fa-pen-to-square"></i>
                            <span>Create Article</span>
                        </a>
                    </li>
                    <li class="${currentPage eq 'analytics' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/publisher/analytics">
                            <i class="fas fa-chart-line"></i>
                            <span>Analytics</span>
                        </a>
                    </li>
                    <li class="${currentPage eq 'profile' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/publisher/profile">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>
                    <li class="${currentPage eq 'settings' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/publisher/settings">
                            <i class="fas fa-gear"></i>
                            <span>Settings</span>
                        </a>
                    </li>

                </c:when>



            </c:choose>

        </ul>
    </nav>

    <div class="sidebar-footer">
        <button class="logout-btn" onclick="showLogoutModal()">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
        </button>
    </div>
</aside>

<%@include file="../../../layouts/logoutModal.jsp"%>

<script src="${pageContext.request.contextPath}/assets/js/logoutModal.js"></script>
