<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/dashboard">
            <h1 class="logo">Dashboard</h1>
        </a>
    </div>


    <nav class="sidebar-nav">
        <ul>
            <li class="${requestScope.activePage == 'home' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-home"></i>
                    <span>Home</span>
                </a>
            </li>
            <c:choose>
                <%-- Admin Navigation--%>
                <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
                    <li class="${requestScope.activePage == 'dashboard' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>

                    <li class="${requestScope.activePage == 'user-management' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/user-management">
                            <i class="fas fa-users"></i>
                            <span>User Management</span>
                        </a>
                    </li>

                    <li class="${requestScope.activePage == 'pending-publishers' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/pending-publishers">
                            <i class="fas fa-check-circle"></i>
                            <span>Publisher Approval</span>
                        </a>
                    </li>

                    <li class="${requestScope.activePage == 'content-management' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/content-management">
                            <i class="fas fa-newspaper"></i>
                            <span>Content Management</span>
                        </a>
                    </li>
                </c:when>

                <%-- Publisher Navigation--%>
                <c:when test="${sessionScope.currentUser.role == 'PUBLISHER'}">
                    <li class="${requestScope.activePage == 'dashboard' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="${requestScope.activePage == 'publisherArticles' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/publisher/articles">
                            <i class="fas fa-newspaper"></i>
                            <span>My Articles</span>
                        </a>
                    </li>
                    <li class="${requestScope.activePage == 'createArticle' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/publisher/create">
                            <i class="fas fa-pen-to-square"></i>
                            <span>Create Article</span>
                        </a>
                    </li>
                    <li class="${requestScope.activePage == 'publisherAnalytics' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/publisher/analytics">
                            <i class="fas fa-chart-line"></i>
                            <span>Analytics</span>
                        </a>
                    </li>
                    <li class="${requestScope.activePage == 'publisherProfile' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/publisher/profile">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                        </a>
                    </li>
                    <li class="${requestScope.activePage == 'publisherSettings' ? 'active' : ''}">
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

<%@include file="../../../layouts/logoutModal.jsp" %>

<script src="${pageContext.request.contextPath}/assets/js/logoutModal.js"></script>
