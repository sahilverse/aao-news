package com.aaonews.controllers.dashboard.publisher;

import com.aaonews.dao.ArticleDAO;
import com.aaonews.dao.ArticleLikeDAO;
import com.aaonews.dao.CommentDAO;
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
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "PublisherArticlesServlet", urlPatterns = {"/publisher/articles"})
public class PublisherArticlesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if the user is logged in and has the publisher role
        User user = (User) SessionUtil.getCurrentUser(request);
        // If the user is not logged in or does not have the publisher role, redirect to login page
        if (user == null || user.getRole() != Role.PUBLISHER) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String statusFilter = request.getParameter("status");
        String sortFilter = request.getParameter("sort");
        String pageParam = request.getParameter("page");
        String sizeParam = request.getParameter("size");

        if (statusFilter == null) statusFilter = "all";
        if (sortFilter == null) sortFilter = "newest";


        int page = 1;
        int pageSize = 5;

        try {
            if (pageParam != null) page = Integer.parseInt(pageParam);
            if (sizeParam != null) pageSize = Integer.parseInt(sizeParam);
        } catch (NumberFormatException e) {
            page = 1;
            pageSize = 5;
        }

        if (page < 1) page = 1;



       // Fetch the list of articles for the publisher

        ArticleDAO articleDAO = new ArticleDAO();
        List<Article> articles = articleDAO.getArticlesByAuthor(user.getId());

        if(articles == null) {
            articles = new ArrayList<>();
        }

        for (Article article : articles) {
            CommentDAO commentDAO = new CommentDAO();
            ArticleLikeDAO articleLikeDAO = new ArticleLikeDAO();
            int commentCount = commentDAO.getArticleCommentCount(article.getId(), false);
            int likeCount = articleLikeDAO.getArticleLikeCount(article.getId());
            article.setCommentCount(commentCount);
            article.setLikeCount(likeCount);

        }

        // Filter by status
        if (!statusFilter.equalsIgnoreCase("all")) {
            String finalStatusFilter = statusFilter;
            articles = articles.stream()
                    .filter(article -> article.getStatus() == ArticleStatus.valueOf(finalStatusFilter.toUpperCase()))
                    .collect(Collectors.toList());
        }

        // Sort the articles based on the sort filter
        switch (sortFilter.toLowerCase()) {
            case "oldest":
                articles.sort(Comparator.comparing(Article::getCreatedAt));
                break;
            case "views":
                articles.sort((a, b) -> Integer.compare(b.getViewCount(), a.getViewCount()));
                break;
            case "likes":
                articles.sort((a, b) -> Integer.compare(b.getLikeCount(), a.getLikeCount()));
                break;
            case "newest":
            default:
                articles.sort((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()));
                break;
        }

        int totalArticles = articles.size();
        int totalPages = (int) Math.ceil((double) totalArticles / pageSize);
        int fromIndex = Math.min((page - 1) * pageSize, totalArticles);
        int toIndex = Math.min(fromIndex + pageSize, totalArticles);

        List<Article> paginatedArticles = articles.subList(fromIndex, toIndex);

        // Set the articles as a request attribute
        request.setAttribute("articles", paginatedArticles);
        System.out.println("Articles: " + paginatedArticles);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalArticles", totalArticles);
        request.setAttribute("startIndex", fromIndex);
        request.setAttribute("endIndex", toIndex);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("sortFilter", sortFilter);

        // Set the active page for the navigation bar
        request.setAttribute("activePage", "publisherArticles");
        request.getRequestDispatcher("/WEB-INF/views/dashboard/publisher/publisher.jsp").forward(request, response);

    }
}
