
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <%@ include file="../layouts/reusable.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/contact.css">
</head>
<body>

<jsp:include page="../layouts/navbar.jsp"/>

<!-- Hero Section -->
<section class="hero">
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <h1>Get in <span class="highlight">Touch</span></h1>
        <p>We'd love to hear from you. Reach out with questions, feedback, or partnership opportunities.</p>
    </div>
</section>

<!-- Contact Form Section -->
<section class="contact-form-section">
    <div class="container">
        <div class="contact-grid">
            <!-- Contact Information -->
            <div class="contact-info">
                <div class="info-header">
                    <h2 class="section-label">CONTACT INFORMATION</h2>
                    <h3 class="section-title">How to Reach Us</h3>
                </div>

                <div class="info-text">
                    <p>Have a question or feedback? Our team is ready to assist you. Use the contact details below or fill out the form, and we'll get back to you as soon as possible.</p>
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
                            <h4>Phone Numbers</h4>
                            <p>Main: +977 9876543210</p>
                            <p>Support: 01-2345678</p>
                        </div>
                    </div>

                    <div class="contact-item">
                        <div class="contact-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div>
                            <h4>Email Addresses</h4>
                            <p>General: info@aaonews.com</p>
                            <p>Press Releases: press@aaonews.com</p>
                        </div>
                    </div>

                    <div class="contact-item">
                        <div class="contact-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div>
                            <h4>Office Hours</h4>
                            <p>Sunday - Thursday: 9:00 AM - 6:00 PM</p>
                            <p>Friday: 10:00 AM - 4:00 PM</p>
                        </div>
                    </div>
                </div>

                <div class="social-connect">
                    <h4>Connect With Us</h4>
                    <div class="social-icons">
                        <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                        <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                        <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#" aria-label="YouTube"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
            </div>

            <!-- Contact Form -->
            <div class="form-container">
                <form id="contact-form" class="contact-form">
                    <h3>Send Us a Message</h3>

                    <div class="form-group">
                        <label for="name">Full Name</label>
                        <input type="text" id="name" name="name" placeholder="Your full name" required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" placeholder="Your email address" required>
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" placeholder="Your phone number (optional)">
                    </div>

                    <div class="form-group">
                        <label for="subject">Subject</label>
                        <select id="subject" name="subject" required>
                            <option value="" disabled selected>Select a subject</option>
                            <option value="general">General Inquiry</option>
                            <option value="support">Technical Support</option>
                            <option value="feedback">Feedback</option>
                            <option value="partnership">Partnership Opportunity</option>
                            <option value="press">Press Release</option>
                            <option value="other">Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="message">Message</label>
                        <textarea id="message" name="message" rows="5" placeholder="Your message" required></textarea>
                    </div>

                    <div class="form-group checkbox-group">
                        <input type="checkbox" id="newsletter" name="newsletter">
                        <label for="newsletter">Subscribe to our newsletter</label>
                    </div>

                    <button type="submit" class="btn btn-secondary">Send Message</button>
                </form>
            </div>
        </div>
    </div>
</section>

<!-- Map Section -->
<section class="map-section">
    <div class="container">
        <div class="map-header">
            <h2 class="section-label">OUR LOCATION</h2>
            <h3 class="section-title">Visit Our Office</h3>
        </div>
        <div class="map-container">
            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3565.513485235297!2d87.34792807656243!3d26.664055376796217!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x39ef6f007da2a0e7%3A0x4a8f6bfd5887f690!2sSundarharaicha-7%20gothaun!5e0!3m2!1sen!2snp!4v1745423456238!5m2!1sen!2snp" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
        </div>
    </div>
</section>

<!-- FAQ Section -->
<section class="faq-section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-label">FREQUENTLY ASKED QUESTIONS</h2>
            <h3 class="section-title">Common Inquiries</h3>
        </div>

        <div class="faq-container">
            <div class="faq-item">
                <div class="faq-question">
                    <h4>How can I submit a news tip?</h4>
                    <span class="faq-icon"><i class="fas fa-chevron-down"></i></span>
                </div>
                <div class="faq-answer">
                    <p>You can submit news tips by emailing tips@aaonews.com or by using the contact form on this page. Please include as much detail as possible, and our editorial team will review your submission.</p>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <h4>How do I become a publisher on Aaonews?</h4>
                    <span class="faq-icon"><i class="fas fa-chevron-down"></i></span>
                </div>
                <div class="faq-answer">
                    <p>To become a publisher, you need to register an account and apply for publisher status. We review all applications to ensure quality content. Visit our "Become a Publisher" page for detailed requirements and the application process.</p>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <h4>How can I report inaccurate information in an article?</h4>
                    <span class="faq-icon"><i class="fas fa-chevron-down"></i></span>
                </div>
                <div class="faq-answer">
                    <p>We take accuracy seriously. If you find inaccurate information, please use the "Report" button on the article or email corrections@aaonews.com with the article link and details about the error. Our fact-checking team will review and make necessary corrections.</p>
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <h4>Does Aaonews offer advertising opportunities?</h4>
                    <span class="faq-icon"><i class="fas fa-chevron-down"></i></span>
                </div>
                <div class="faq-answer">
                    <p>Yes, we offer various advertising options for businesses. Please contact our advertising team at ads@aaonews.com for our media kit and pricing information. We offer display ads, sponsored content, and newsletter placements.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta-section">
    <div class="container">
        <h2>Join Our Community</h2>
        <p>Stay informed with the latest news and updates by subscribing to our newsletter.</p>
        <div class="newsletter-form">
            <input type="email" placeholder="Your email address">
            <button class="btn btn-secondary">Subscribe</button>
        </div>
    </div>
</section>


<%--Footer--%>
<jsp:include page="../layouts/footer.jsp"/>


<!-- Scripts -->
<script>
    // FAQ Accordion functionality
    document.addEventListener('DOMContentLoaded', function() {
        const faqItems = document.querySelectorAll('.faq-item');

        faqItems.forEach(item => {
            const question = item.querySelector('.faq-question');

            question.addEventListener('click', () => {
                // Toggle active class on the clicked item
                item.classList.toggle('active');

                // Close other open items
                faqItems.forEach(otherItem => {
                    if (otherItem !== item && otherItem.classList.contains('active')) {
                        otherItem.classList.remove('active');
                    }
                });
            });
        });
    });
</script>

</body>
</html>
