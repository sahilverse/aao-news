package com.aaonews.controllers.dashboard.publisher;


import com.aaonews.dao.ArticleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(urlPatterns = {"/publisher/delete-article"})
public class DeleteArticle extends HttpServlet {
    private ArticleDAO articleDAO;

    public void init() throws ServletException {
        articleDAO = new ArticleDAO();
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String articleId = req.getParameter("articleId");

        if (articleId == null || articleId.isEmpty()) {
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }


        int id = Integer.parseInt(articleId);

        boolean isDeleted = articleDAO.deleteArticle(id);

        if (isDeleted) {
            req.getSession().setAttribute("successMessage", "Article deleted successfully.");
            // Redirect to the publisher dashboard or any other page
            res.sendRedirect(req.getContextPath() + "/publisher/articles");
            res.setStatus(HttpServletResponse.SC_OK);
        } else {
            req.getSession().setAttribute("errorMessage", "Failed to delete the article. Please try again.");
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }


    }
}
