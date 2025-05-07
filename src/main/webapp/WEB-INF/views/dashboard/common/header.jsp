<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header>
    <nav class="nav-header">
        <div class="navbar-container">
            <a href="${pageContext.request.contextPath}/dashboard" class="logo">
                <span>Aaonews</span>
            </a>
            <div class="dp-container">
                <span style="margin-right: 4px;">Hi, ${fn:split(sessionScope.currentUser.fullName, " ")[0]}</span>

                <img src="${pageContext.request.contextPath}/user-image?id=${sessionScope.currentUser.id}" alt="User Photo" class="profile-photo">
            </div>
        </div>
    </nav>
</header>
