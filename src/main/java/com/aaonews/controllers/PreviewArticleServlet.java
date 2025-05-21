package com.aaonews.controllers;

import com.aaonews.dao.ArticleDAO;
import com.aaonews.models.Article;
import com.aaonews.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "PreviewArticleServlet", urlPatterns = {"/article/*"})
public class PreviewArticleServlet extends HttpServlet {
    private ArticleDAO articleDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        articleDAO = new ArticleDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String articleId = request.getPathInfo().substring(1);

        // Fetch the article from the database
        Optional<Article> article = articleDAO.getArticleById(Integer.parseInt(articleId));
        User author = articleDAO.getArticleAuthor(Integer.parseInt(articleId));
        article.ifPresent(a -> a.setAuthor(author));

        if (article.isPresent()) {
            request.setAttribute("article", article.get());
            request.getRequestDispatcher("/WEB-INF/views/article-preview.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Article not found");
        }

    }

}
