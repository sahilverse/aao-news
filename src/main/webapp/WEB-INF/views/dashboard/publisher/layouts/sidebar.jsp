<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-header">
        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="AAO News Logo" class="logo">
        <h2>Publisher Portal</h2>
    </div>

    <nav class="sidebar-nav">
        <ul>
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
        </ul>
    </nav>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
        </a>
    </div>
</aside>
