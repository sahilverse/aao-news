<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header>
    <div class="navbar container ">
        <a href="${pageContext.request.contextPath}/">
            <div class="logo">aao-news</div>
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
                <button class="nav-btn"><a href="${pageContext.request.contextPath}/profile">Profile</a></button>
                <button type="button" class="nav-btn nav-btn-white" onclick="showLogoutModal()">Logout
                </button>
            </div>
        </c:if>
    </div>

    <!-- Logout Confirmation Modal -->
    <div id="logoutModal" class="modal-overlay">
        <div class="modal-box">
            <h2>Are you sure?</h2>
            <p>You will be logged out of your account.</p>
            <div class="modal-actions">
                <form id="logoutForm" method="post" action="${pageContext.request.contextPath}/logout">
                    <button type="submit" class="btn-confirm">Yes, Logout</button>
                </form>
                <button class="btn-cancel" onclick="hideLogoutModal()">Cancel</button>
            </div>
        </div>
    </div>
</header>


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


    // Logout Modal
    function showLogoutModal() {
        document.getElementById('logoutModal').classList.add('active-modal');
    }

    function hideLogoutModal() {
        document.getElementById('logoutModal').classList.remove('active-modal');
    }
</script>