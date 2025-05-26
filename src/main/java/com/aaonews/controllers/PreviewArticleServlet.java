package com.aaonews.controllers;

import com.aaonews.dao.ArticleDAO;
import com.aaonews.enums.ArticleStatus;
import com.aaonews.enums.Role;
import com.aaonews.models.Article;
import com.aaonews.models.User;
import com.aaonews.utils.SessionUtil;
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
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing article ID");
            return;
        }
        String articleId = request.getPathInfo().substring(1);

        // Fetch the article from the database
        Optional<Article> article = articleDAO.getArticleById(Integer.parseInt(articleId));
        User author = articleDAO.getArticleAuthor(Integer.parseInt(articleId));
        article.ifPresent(a -> a.setAuthor(author));


        if (article.isPresent()) {
            // increase the view count if only the article is being previewed and the user is not the author and admin
            User currentUser = SessionUtil.getCurrentUser(request);
            if (currentUser == null) {
               // create null user to avoid null pointer exception
                currentUser = new User();
            }
            if (!(currentUser.getRole() == Role.ADMIN) && !(currentUser.getId() == author.getId())) {
                articleDAO.incrementViewCount(Integer.parseInt(articleId));
            }

            if(!(article.get().getStatus() == ArticleStatus.PUBLISHED) && currentUser.getRole() == Role.READER) {

                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Article is not available for preview");
                return;

            }
         
            request.setAttribute("article", article.get());
            request.getRequestDispatcher("/WEB-INF/views/article-preview.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Article not found");
        }

    }

}
