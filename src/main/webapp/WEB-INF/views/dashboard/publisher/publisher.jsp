<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Publisher Dashboard | Aaonews</title>


    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/publisherDashboard.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="dashboard-container">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="AAO News Logo" class="logo">
            <h2>Publisher Portal</h2>
        </div>

        <nav class="sidebar-nav">
            <ul>
                <li class="active">
                    <a href="${pageContext.request.contextPath}/publisher/dashboard">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/publisher/articles">
                        <i class="fas fa-newspaper"></i>
                        <span>My Articles</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/publisher/new-article">
                        <i class="fas fa-pen-to-square"></i>
                        <span>Create Article</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/publisher/analytics">
                        <i class="fas fa-chart-line"></i>
                        <span>Analytics</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/publisher/profile">
                        <i class="fas fa-user"></i>
                        <span>Profile</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/publisher/settings">
                        <i class="fas fa-gear"></i>
                        <span>Settings</span>
                    </a>
                </li>
            </ul>
        </nav>

        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Top Navigation -->
        <header class="top-nav">
            <button id="sidebar-toggle" class="sidebar-toggle">
                <i class="fas fa-bars"></i>
            </button>

            <div class="search-container">
                <input type="text" placeholder="Search articles...">
                <button type="submit"><i class="fas fa-search"></i></button>
            </div>

            <div class="user-actions">
                <div class="notifications">
                    <button class="notification-btn">
                        <i class="fas fa-bell"></i>
                        <span class="notification-badge">3</span>
                    </button>
                    <div class="notification-dropdown">
                        <div class="notification-header">
                            <h3>Notifications</h3>
                            <a href="#">Mark all as read</a>
                        </div>
                        <ul class="notification-list">
                            <li class="unread">
                                <div class="notification-icon success">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="notification-content">
                                    <p>Your article "Climate Change Impact" has been approved.</p>
                                    <span class="notification-time">2 hours ago</span>
                                </div>
                            </li>
                            <li class="unread">
                                <div class="notification-icon warning">
                                    <i class="fas fa-exclamation-circle"></i>
                                </div>
                                <div class="notification-content">
                                    <p>Your article "Tech Innovations" needs revisions.</p>
                                    <span class="notification-time">1 day ago</span>
                                </div>
                            </li>
                            <li>
                                <div class="notification-icon info">
                                    <i class="fas fa-info-circle"></i>
                                </div>
                                <div class="notification-content">
                                    <p>New publishing guidelines have been released.</p>
                                    <span class="notification-time">3 days ago</span>
                                </div>
                            </li>
                        </ul>
                        <div class="notification-footer">
                            <a href="${pageContext.request.contextPath}/publisher/notifications">View all notifications</a>
                        </div>
                    </div>
                </div>

                <div class="user-profile">
                    <button class="profile-btn">
                        <img src="${pageContext.request.contextPath}/assets/images/avatar.jpg" alt="User Avatar">
                        <span>${publisher.name}</span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="profile-dropdown">
                        <ul>
                            <li>
                                <a href="${pageContext.request.contextPath}/publisher/profile">
                                    <i class="fas fa-user"></i> My Profile
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/publisher/settings">
                                    <i class="fas fa-gear"></i> Settings
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/help">
                                    <i class="fas fa-question-circle"></i> Help Center
                                </a>
                            </li>
                            <li class="divider"></li>
                            <li>
                                <a href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </header>

        <!-- Dashboard Content -->
        <div class="dashboard-content">
            <div class="page-header">
                <h1>Publisher Dashboard</h1>
                <p>Welcome back, ${publisher.name}! Here's an overview of your publishing activity.</p>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <a href="${pageContext.request.contextPath}/publisher/new-article" class="action-card primary">
                    <div class="action-icon">
                        <i class="fas fa-pen-to-square"></i>
                    </div>
                    <div class="action-content">
                        <h3>Create New Article</h3>
                        <p>Start writing a new article</p>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/publisher/drafts" class="action-card secondary">
                    <div class="action-icon">
                        <i class="fas fa-file-lines"></i>
                    </div>
                    <div class="action-content">
                        <h3>Continue Draft</h3>
                        <p>Resume your latest draft</p>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/publisher/analytics" class="action-card info">
                    <div class="action-icon">
                        <i class="fas fa-chart-simple"></i>
                    </div>
                    <div class="action-content">
                        <h3>View Analytics</h3>
                        <p>Check your article performance</p>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/publisher/feedback" class="action-card warning">
                    <div class="action-icon">
                        <i class="fas fa-comments"></i>
                    </div>
                    <div class="action-content">
                        <h3>Editorial Feedback</h3>
                        <p>Review editor comments</p>
                    </div>
                </a>
            </div>

            <!-- Stats Overview -->
            <div class="stats-overview">
                <div class="stat-card">
                    <div class="stat-icon published">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-content">
                        <h3>Published</h3>
                        <p class="stat-number">24</p>
                        <p class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i> 12% from last month
                        </p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon pending">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-content">
                        <h3>Pending Review</h3>
                        <p class="stat-number">5</p>
                        <p class="stat-trend">
                            <i class="fas fa-minus"></i> No change
                        </p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon drafts">
                        <i class="fas fa-file-lines"></i>
                    </div>
                    <div class="stat-content">
                        <h3>Drafts</h3>
                        <p class="stat-number">8</p>
                        <p class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i> 3 new drafts
                        </p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon views">
                        <i class="fas fa-eye"></i>
                    </div>
                    <div class="stat-content">
                        <h3>Total Views</h3>
                        <p class="stat-number">45.2K</p>
                        <p class="stat-trend positive">
                            <i class="fas fa-arrow-up"></i> 18% from last month
                        </p>
                    </div>
                </div>
            </div>

            <!-- Performance Chart -->
            <div class="chart-container">
                <div class="chart-header">
                    <h2>Article Performance</h2>
                    <div class="chart-controls">
                        <select id="chart-timeframe">
                            <option value="week">Last 7 days</option>
                            <option value="month" selected>Last 30 days</option>
                            <option value="quarter">Last 90 days</option>
                            <option value="year">Last 365 days</option>
                        </select>
                    </div>
                </div>
                <div class="chart-wrapper">
                    <canvas id="performance-chart"></canvas>
                </div>
            </div>

            <!-- Recent Articles -->
            <div class="recent-articles">
                <div class="section-header">
                    <h2>Recent Articles</h2>
                    <a href="${pageContext.request.contextPath}/publisher/articles" class="view-all">View All</a>
                </div>

                <div class="tabs">
                    <button class="tab-btn active" data-tab="all">All</button>
                    <button class="tab-btn" data-tab="published">Published</button>
                    <button class="tab-btn" data-tab="pending">Pending</button>
                    <button class="tab-btn" data-tab="drafts">Drafts</button>
                    <button class="tab-btn" data-tab="rejected">Rejected</button>
                </div>

                <div class="tab-content active" id="all-tab">
                    <div class="article-list">
                        <div class="article-card">
                            <div class="article-status published">
                                <span>Published</span>
                            </div>
                            <h3 class="article-title">The Impact of Climate Change on Global Agriculture</h3>
                            <div class="article-meta">
                                <span><i class="fas fa-calendar"></i> May 15, 2023</span>
                                <span><i class="fas fa-eye"></i> 3.2K views</span>
                                <span><i class="fas fa-comment"></i> 24 comments</span>
                            </div>
                            <div class="article-actions">
                                <a href="#" class="btn btn-sm btn-secondary">Edit</a>
                                <a href="#" class="btn btn-sm btn-default">View</a>
                                <button class="btn-icon"><i class="fas fa-ellipsis-vertical"></i></button>
                            </div>
                        </div>

                        <div class="article-card">
                            <div class="article-status pending">
                                <span>Pending</span>
                            </div>
                            <h3 class="article-title">Tech Innovations Shaping the Future of Healthcare</h3>
                            <div class="article-meta">
                                <span><i class="fas fa-calendar"></i> May 10, 2023</span>
                                <span><i class="fas fa-clock"></i> Awaiting review</span>
                            </div>
                            <div class="article-actions">
                                <a href="#" class="btn btn-sm btn-secondary">Edit</a>
                                <a href="#" class="btn btn-sm btn-default">Preview</a>
                                <button class="btn-icon"><i class="fas fa-ellipsis-vertical"></i></button>
                            </div>
                        </div>

                        <div class="article-card">
                            <div class="article-status draft">
                                <span>Draft</span>
                            </div>
                            <h3 class="article-title">The Rise of Sustainable Fashion in 2023</h3>
                            <div class="article-meta">
                                <span><i class="fas fa-calendar"></i> May 5, 2023</span>
                                <span><i class="fas fa-pen"></i> Last edited 2 days ago</span>
                            </div>
                            <div class="article-actions">
                                <a href="#" class="btn btn-sm btn-secondary">Continue Editing</a>
                                <a href="#" class="btn btn-sm btn-default">Preview</a>
                                <button class="btn-icon"><i class="fas fa-ellipsis-vertical"></i></button>
                            </div>
                        </div>

                        <div class="article-card">
                            <div class="article-status rejected">
                                <span>Rejected</span>
                            </div>
                            <h3 class="article-title">Cryptocurrency Market Analysis: Trends and Predictions</h3>
                            <div class="article-meta">
                                <span><i class="fas fa-calendar"></i> April 28, 2023</span>
                                <span><i class="fas fa-times-circle"></i> Rejected on May 2, 2023</span>
                            </div>
                            <div class="article-actions">
                                <a href="#" class="btn btn-sm btn-secondary">View Feedback</a>
                                <a href="#" class="btn btn-sm btn-default">Revise</a>
                                <button class="btn-icon"><i class="fas fa-ellipsis-vertical"></i></button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-content" id="published-tab">
                    <!-- Published articles content -->
                </div>

                <div class="tab-content" id="pending-tab">
                    <!-- Pending articles content -->
                </div>

                <div class="tab-content" id="drafts-tab">
                    <!-- Draft articles content -->
                </div>

                <div class="tab-content" id="rejected-tab">
                    <!-- Rejected articles content -->
                </div>
            </div>

            <!-- Editorial Calendar -->
            <div class="editorial-calendar">
                <div class="section-header">
                    <h2>Editorial Calendar</h2>
                    <a href="${pageContext.request.contextPath}/publisher/calendar" class="view-all">View Full Calendar</a>
                </div>

                <div class="calendar-wrapper">
                    <div class="calendar-header">
                        <button class="calendar-nav prev"><i class="fas fa-chevron-left"></i></button>
                        <h3>May 2023</h3>
                        <button class="calendar-nav next"><i class="fas fa-chevron-right"></i></button>
                    </div>

                    <div class="calendar-events">
                        <div class="calendar-event">
                            <div class="event-date">
                                <span class="day">15</span>
                                <span class="month">May</span>
                            </div>
                            <div class="event-content">
                                <h4>Deadline: Summer Tech Special</h4>
                                <p>Submit articles for the summer technology special edition</p>
                            </div>
                            <div class="event-status">
                                <span class="badge upcoming">Upcoming</span>
                            </div>
                        </div>

                        <div class="calendar-event">
                            <div class="event-date">
                                <span class="day">20</span>
                                <span class="month">May</span>
                            </div>
                            <div class="event-content">
                                <h4>Editorial Meeting</h4>
                                <p>Virtual meeting with the editorial team</p>
                            </div>
                            <div class="event-status">
                                <span class="badge upcoming">Upcoming</span>
                            </div>
                        </div>

                        <div class="calendar-event">
                            <div class="event-date">
                                <span class="day">01</span>
                                <span class="month">Jun</span>
                            </div>
                            <div class="event-content">
                                <h4>New Content Guidelines Release</h4>
                                <p>Updated content guidelines will be published</p>
                            </div>
                            <div class="event-status">
                                <span class="badge upcoming">Upcoming</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Trending Topics -->
            <div class="trending-topics">
                <div class="section-header">
                    <h2>Trending Topics</h2>
                    <a href="${pageContext.request.contextPath}/publisher/topics" class="view-all">View All Topics</a>
                </div>

                <div class="topics-wrapper">
                    <div class="topic-card">
                        <div class="topic-icon">
                            <i class="fas fa-microchip"></i>
                        </div>
                        <div class="topic-content">
                            <h3>AI & Machine Learning</h3>
                            <p>High reader interest in AI applications</p>
                            <div class="topic-trend">
                                <div class="trend-bar" style="width: 85%"></div>
                                <span>85% interest</span>
                            </div>
                        </div>
                    </div>

                    <div class="topic-card">
                        <div class="topic-icon">
                            <i class="fas fa-leaf"></i>
                        </div>
                        <div class="topic-content">
                            <h3>Sustainability</h3>
                            <p>Growing interest in eco-friendly practices</p>
                            <div class="topic-trend">
                                <div class="trend-bar" style="width: 78%"></div>
                                <span>78% interest</span>
                            </div>
                        </div>
                    </div>

                    <div class="topic-card">
                        <div class="topic-icon">
                            <i class="fas fa-virus"></i>
                        </div>
                        <div class="topic-content">
                            <h3>Public Health</h3>
                            <p>Consistent interest in health topics</p>
                            <div class="topic-trend">
                                <div class="trend-bar" style="width: 72%"></div>
                                <span>72% interest</span>
                            </div>
                        </div>
                    </div>

                    <div class="topic-card">
                        <div class="topic-icon">
                            <i class="fas fa-rocket"></i>
                        </div>
                        <div class="topic-content">
                            <h3>Space Exploration</h3>
                            <p>Rising interest in space missions</p>
                            <div class="topic-trend">
                                <div class="trend-bar" style="width: 68%"></div>
                                <span>68% interest</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="dashboard-footer">
            <p>&copy; 2023 Aaonews. All rights reserved.</p>
            <div class="footer-links">
                <a href="${pageContext.request.contextPath}/terms">Terms of Service</a>
                <a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a>
                <a href="${pageContext.request.contextPath}/help">Help Center</a>
            </div>
        </footer>
    </main>
</div>

<!-- JavaScript -->
<script src="${pageContext.request.contextPath}/assets/js/publisherDashboard.js"></script>
</body>
</html>
