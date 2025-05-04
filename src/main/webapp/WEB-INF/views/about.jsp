<%--
  Created by IntelliJ IDEA.
  User: Sahil Dahal
  Date: 4/23/2025
  Time: 8:51 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>About Us</title>
    <%@ include file="../layouts/reusable.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/about.css">
</head>
<body>
<jsp:include page="../layouts/navbar.jsp"/>
<!-- Hero Section -->
<section class="hero">
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <h1>Discover News <span class="highlight">That Matters</span></h1>
        <p>Where journalism meets community engagement for a more informed world</p>
    </div>
</section>

<!-- Our Story Section -->
<section class="story-section">
    <div class="container">
        <div class="story-grid">
            <div class="story-image">
                <img src="${pageContext.request.contextPath}/assets/images/about-hero.jpg"
                     alt="Newsroom">
            </div>
            <div class="story-content">
                <div>
                    <h2 class="section-label">OUR STORY</h2>
                    <h3 class="section-title">Redefining Digital News Since 2020</h3>
                </div>
                <div class="story-text">
                    <p>
                        Aaonews was founded with a mission to create more than just another news outlet—we wanted to
                        build a platform where information meets interaction, where readers become participants.
                    </p>
                    <p>
                        Our journey began with a simple vision: to deliver accurate, timely news while fostering a
                        community of engaged citizens. Today, we're proud to be a premier destination for news
                        enthusiasts and casual readers alike.
                    </p>
                    <p>
                        Every aspect of our platform has been thoughtfully designed to enhance your news experience,
                        from our intuitive interface to our community-driven features that allow you to comment, like,
                        share, and bookmark stories that matter to you.
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Explore News</a>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="features-section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-label">WHAT WE OFFER</h2>
            <h3 class="section-title">Premium News Experience</h3>
        </div>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-newspaper"></i>
                </div>
                <h4>Breaking News</h4>
                <p>Stay informed with real-time updates on developing stories from around the globe, delivered with
                    accuracy and context.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-comments"></i>
                </div>
                <h4>Community Engagement</h4>
                <p>Join the conversation with our interactive comment system that connects readers and fosters
                    meaningful discussions.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-bookmark"></i>
                </div>
                <h4>Personalized Bookmarks</h4>
                <p>Save articles for later with our bookmark feature, creating your own personalized news library to
                    revisit anytime.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-share-alt"></i>
                </div>
                <h4>Easy Sharing</h4>
                <p>Share important stories across all major social platforms with a single click, helping spread
                    reliable information.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-pen-fancy"></i>
                </div>
                <h4>Publisher Platform</h4>
                <p>Registered publishers can contribute their own stories, bringing diverse perspectives and voices to
                    our platform.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-mobile-alt"></i>
                </div>
                <h4>Mobile Optimized</h4>
                <p>Access your news anywhere with our fully responsive design that delivers a seamless experience across
                    all devices.</p>
            </div>
        </div>
    </div>
</section>


<!-- Contact Section -->
<section class="contact-section">
    <div class="container">
        <div class="contact-grid">
            <!-- Contact Information -->
            <div class="contact-info">
                <div>
                    <h2 class="section-label">GET IN TOUCH</h2>
                    <h3 class="section-title">Contact Information</h3>
                </div>

                <div class="contact-details">
                    <div class="contact-item">
                        <div class="contact-icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div>
                            <h4>Location</h4>
                            <p>SundarHaraincha - 7</p>
                            <p>Morang, Nepal</p>
                        </div>
                    </div>

                    <div class="contact-item">
                        <div class="contact-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div>
                            <h4>Phone</h4>
                            <p>+977 9876543210</p>
                            <p>01-2345678</p>
                        </div>
                    </div>

                    <div class="contact-item">
                        <div class="contact-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div>
                            <h4>Email</h4>
                            <p>info@aaonews.com</p>
                            <p>press@aaonews.com</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Hours & Map -->
            <div class="hours-map">
                <div>
                    <h2 class="section-label">VISIT US</h2>
                    <h3 class="section-title">Office Hours</h3>
                </div>

                <div class="hours-card">
                    <div class="hours-header">
                        <div class="hours-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div>
                            <h4>Business Hours</h4>
                            <p>Our newsroom is active 24/7</p>
                        </div>
                    </div>

                    <div class="schedule">
                        <div class="schedule-item">
                            <span>Sunday - Thursday</span>
                            <span class="highlight">9:00 AM - 6:00 PM</span>
                        </div>
                        <div class="schedule-item">
                            <span>Friday</span>
                            <span class="highlight">10:00 AM - 4:00 PM</span>
                        </div>
                        <div class="schedule-item">
                            <span>Saturday</span>
                            <span class="highlight">Closed</span>
                        </div>
                    </div>
                </div>

                <div class="map-container">
                    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3565.513485235297!2d87.34792807656243!3d26.664055376796217!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x39ef6f007da2a0e7%3A0x4a8f6bfd5887f690!2sSundarharaicha-7%20gothaun!5e0!3m2!1sen!2snp!4v1745423456238!5m2!1sen!2snp" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta-section">
    <div class="container">
        <h2>Ready to Stay Informed and Engaged?</h2>
        <p>Join Aaonews today and become part of a community that values accurate reporting and meaningful
            engagement.</p>
        <div class="cta-buttons">
            <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary">Sign Up Now</a>
            <a href="${pageContext.request.contextPath}/register?type=user" class="btn btn-default">Become a Publisher</a>
        </div>
    </div>
</section>

<div id="footer-container">
    <jsp:include page="../layouts/footer.jsp"/>

</div>

</body>
</html>
