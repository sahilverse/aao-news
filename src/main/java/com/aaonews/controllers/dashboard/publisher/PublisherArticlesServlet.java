package com.aaonews.controllers.dashboard.publisher;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "PublisherArticlesServlet", urlPatterns = {"/publisher/articles"})
public class PublisherArticlesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("activePage", "publisherArticles");

        request.getRequestDispatcher("/WEB-INF/views/dashboard/publisher/publisher.jsp").forward(request, response);

    }
}
