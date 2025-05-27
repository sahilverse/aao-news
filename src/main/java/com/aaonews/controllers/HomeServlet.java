package com.aaonews.controllers;

import com.aaonews.dao.ArticleDAO;
import com.aaonews.models.Article;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class HomeServlet
 * This servlet handles requests to the home page of the application.
 * It forwards the request to the home.jsp page for rendering.
 */

@WebServlet(name = "HomeServlet", urlPatterns = {"/home", ""})
public class HomeServlet extends HttpServlet {
    private ArticleDAO articleDAO;


    @Override
    public void init() throws ServletException {
        super.init();
        articleDAO = new ArticleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetch latest articles for the main section
        List<Article> featuredArticles = articleDAO.getLatestArticles(5);
        request.setAttribute("featuredArticles", featuredArticles);

        // Fetch articles by category for different sections
        List<Article> technologyArticles = articleDAO.getArticlesByCategory(1,3);  // Technology - 3 articles
        request.setAttribute("technologyArticles", technologyArticles);

        List<Article> businessArticles = articleDAO.getArticlesByCategory(2, 3);   // Business - 3 articles
        request.setAttribute("businessArticles", businessArticles);

        List<Article> healthArticles = articleDAO.getArticlesByCategory(3, 3);     // Health - 3 articles
        request.setAttribute("healthArticles", healthArticles);

        List<Article> sportsArticles = articleDAO.getArticlesByCategory(4, 3);     // Sports - 3 articles
        request.setAttribute("sportsArticles", sportsArticles);

        List<Article> politicsArticles = articleDAO.getArticlesByCategory(6, 3);   // Politics - 3 articles
        request.setAttribute("politicsArticles", politicsArticles);

    //        Trending articles
        List<Article> trendingArticles = articleDAO.getTrendingArticles(5);
        request.setAttribute("trendingArticles", trendingArticles);

        // Get main article
        Article mainArticle = null;
        if (!featuredArticles.isEmpty()) {
            mainArticle = featuredArticles.get(0);
        }
        request.setAttribute("mainArticle", mainArticle);

        // Get side articles
        List<Article> sideArticles = null;
        if (featuredArticles.size() > 1) {
            int endIndex = Math.min(featuredArticles.size(), 4);
            sideArticles = featuredArticles.subList(1, endIndex);
        }
        request.setAttribute("sideArticles", sideArticles);


        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/home.jsp");
        dispatcher.forward(request, response);
    }

}
