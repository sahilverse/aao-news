<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>News Page</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <%@ include file="../layouts/reusable.jsp" %>
</head>
<body>
<jsp:include page="../layouts/navbar.jsp"/>


<!-- Top News Section -->
<div class="container">
    <div class="top-news">
        <div class="main-article">
            <h3>Politics</h3>
            <h1>Breaking News: Major Policy Changes Announced by Government</h1>
            <p>The government has announced sweeping changes to economic policies that will impact various sectors.
                Experts weigh in on the potential outcomes.</p>
            <p>By John Doe • 5 hours ago</p>
        </div>

        <div class="side-articles">
            <div class="article">
                <h4>Technology</h4>
                <h2>New AI Breakthrough Could Transform Healthcare Industry</h2>
                <p>By Jane Smith • Yesterday</p>
            </div>
            <div class="article">
                <h4>Business</h4>
                <h2>Global Markets React to Central Bank's Interest Rate Decision</h2>
                <p>By Robert Johnson • 2 days ago</p>
            </div>
        </div>
    </div>

    <!-- Trending Topics -->
    <div class="trending-topics">
        <h4>Trending:</h4>
        <a href="#">Climate Summit</a>
        <a href="#">Tech Layoffs</a>
        <a href="#">Healthcare Reform</a>
        <a href="#">Olympic Preparations</a>
        <a href="#">Stock Market</a>
    </div>

    <!-- Featured Categories -->
    <div class="featured-categories">
        <h2>Featured Categories</h2>
        <div class="category-grid">
            <div class="category-card">
                <h3>Technology</h3>
                <p>Latest updates in technology</p>
            </div>
            <div class="category-card">
                <h3>Business</h3>
                <p>Latest updates in business</p>
            </div>
            <div class="category-card">
                <h3>Health</h3>
                <p>Latest updates in health</p>
            </div>
            <div class="category-card">
                <h3>Sports</h3>
                <p>Latest updates in sports</p>
            </div>
        </div>
    </div>

</div>

</body>
</html>
