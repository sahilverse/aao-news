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
import java.util.*;


/**
 * Servlet implementation class TrendingServlet
 * Handles requests for trending news articles and related functionality
 */
@WebServlet(name = "TrendingServlet", urlPatterns = "/trending")
public class TrendingServlet extends HttpServlet {

    private ArticleDAO articleDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        articleDAO = new ArticleDAO();

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Fetch trending articles
        List<Article> trendingArticles = articleDAO.getTrendingArticles(10);
        request.setAttribute("trendingArticles", trendingArticles);


        // Forward to the trending.jsp page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/trending.jsp");
        dispatcher.forward(request, response);

    }



}