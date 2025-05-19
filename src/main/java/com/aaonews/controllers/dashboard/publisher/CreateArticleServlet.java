package com.aaonews.controllers.dashboard.publisher;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "CreateArticleServlet", urlPatterns = {"/publisher/create"})
public class CreateArticleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("activePage", "createArticle");

        req.getRequestDispatcher("/WEB-INF/views/dashboard/publisher/publisher.jsp").forward(req, resp);
    }
}
