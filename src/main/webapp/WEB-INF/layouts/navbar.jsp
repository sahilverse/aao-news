<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<header>
    <div class="navbar container ">
        <a href="${pageContext.request.contextPath}/">
            <div class="logo">Aaonews</div>
        </a>


        <div class="nav-icons">
            <i class="fas fa-bars hamburger" id="hamburger"></i>
            <i class="fas fa-times close-icon" id="close-icon"></i>
        </div>

        <ul class="nav-links" id="nav-links">
            <li><a href="${pageContext.request.contextPath}/home"
                   class="${pageContext.request.requestURI.contains('/home') ? 'active' : ''}">Home</a></li>

            <li><a href="${pageContext.request.contextPath}/trending"
                   class="${pageContext.request.requestURI.contains('/trending') ? 'active' : ''}">Trending</a></li>

            <li><a href="${pageContext.request.contextPath}/about"
                   class="${pageContext.request.requestURI.contains('/about') ? 'active' : ''}">About</a></li>

            <li><a href="${pageContext.request.contextPath}/contact"
                   class="${pageContext.request.requestURI.contains('/contact') ? 'active' : ''}">Contact</a></li>

        </ul>


        <c:if test="${empty sessionScope.currentUser}">
            <div class="nav-actions">
                <button class="nav-btn"><a href="${pageContext.request.contextPath}/login">Login</a></button>
                <button class="nav-btn nav-btn-white"><a href="${pageContext.request.contextPath}/register">Register</a>
                </button>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.currentUser}">
            <div class="nav-actions">
                <div class="dropdown">
                    <button class="dropdown-toggle">
                        <span style="margin-right: 20px;">Hi, ${fn:split(sessionScope.currentUser.fullName, " ")[0]}</span>
                        <img src="${pageContext.request.contextPath}/user-image?id=${sessionScope.currentUser.id}" alt="User Photo" class="profile-photo">
                        <i class="fas fa-chevron-down" style="font-size: 0.8rem; margin-left: 8px;"></i>
                    </button>
                    <div class="dropdown-menu">
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.role == 'PUBLISHER' || sessionScope.currentUser.role == 'ADMIN'}">
                                <a href="${pageContext.request.contextPath}/dashboard" class="dropdown-item">
                                    <i class="fas fa-tachometer-alt"></i> Dashboard
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/profile" class="dropdown-item">
                                    <i class="fas fa-user"></i> Profile
                                </a>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/bookmark" class="dropdown-item">
                            <i class="fas fa-bookmark"></i> Saved Articles
                        </a>
                        <a href="#" class="dropdown-item" onclick="showLogoutModal();">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Logout Confirmation Modal -->
    <%@ include file="../layouts/logoutModal.jsp" %>

</header>

<script src="${pageContext.request.contextPath}/assets/js/logoutModal.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const navLinks = document.getElementById("nav-links");
        const hamburger = document.getElementById("hamburger");
        const closeIcon = document.getElementById("close-icon");

        // Initial state
        closeIcon.style.display = "none";

        hamburger.addEventListener("click", () => {
            navLinks.classList.add("active-ham");
            hamburger.style.display = "none";
            closeIcon.style.display = "block";
        });

        closeIcon.addEventListener("click", () => {
            navLinks.classList.remove("active-ham");
            closeIcon.style.display = "none";
            hamburger.style.display = "block";
        });
    });



    // Dropdown functionality
    document.addEventListener("DOMContentLoaded", function() {
        const dropdownToggle = document.querySelector('.dropdown-toggle');

        if (dropdownToggle) {
            dropdownToggle.addEventListener('click', function(e) {
                e.stopPropagation();
                this.parentElement.classList.toggle('active');
            });

            // Close dropdown when clicking outside
            document.addEventListener('click', function(e) {
                const dropdown = document.querySelector('.dropdown');
                if (dropdown && !dropdown.contains(e.target)) {
                    dropdown.classList.remove('active');
                }
            });
        }
    });
</script>
