<header>
<div class="navbar container ">
    <a href="${pageContext.request.contextPath}/"><div class="logo">aao-news</div></a>

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

    <div class="nav-actions">
        <button class="nav-btn"><a href="${pageContext.request.contextPath}/login">Login</a></button>
        <button class="nav-btn nav-btn-white"><a href="${pageContext.request.contextPath}/register">Register</a></button>
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
</script>