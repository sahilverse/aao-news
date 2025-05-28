package com.aaonews.controllers.dashboard;

import com.aaonews.dao.*;
import com.aaonews.enums.ArticleStatus;
import com.aaonews.enums.Role;
import com.aaonews.models.Article;
import com.aaonews.models.Publisher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.aaonews.utils.SessionUtil;
import com.aaonews.models.User;



@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})


@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10,      // 10 MB
        maxRequestSize = 1024 * 1024 * 50)

public class DashboardServlet extends HttpServlet {
    private AdminDAO adminDAO;
    private UserDAO userDAO;
    private User user;

    public void init() throws ServletException {
        // Initialize DAO here
        adminDAO = new AdminDAO();
        userDAO = new UserDAO();
        user = new User();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User currentUser = SessionUtil.getCurrentUser(request);
        String path = request.getServletPath();
        String action = request.getParameter("action");
//        System.out.println("action: " + action);
        System.out.println("path: " + path);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("activePage", "dashboard");

        if (currentUser.getRole() == Role.ADMIN) {
            switch (path) {
                case "/admin/pending-publishers":
                    List<Publisher> pendingPublishers = adminDAO.getPendingPublishers();
                    if (pendingPublishers == null) {
                        System.out.println("pending publishers is null");
                        return;
                    }


                    request.setAttribute("pendingPublishers", pendingPublishers);
                    request.getRequestDispatcher("/WEB-INF/views/dashboard/admin/publisher-approval.jsp").forward(request, response);
                    return;
                    case "/dashboard":
                        PublisherDAO publisherdao = new PublisherDAO();
                        ArticleDAO articledao = new ArticleDAO();
                        Article article = new Article();
                        int no_of_users = userDAO.getAllUsersCount();
                        String searchQuery = request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "";


                        int most_viewed =0;
                        try {
                            int no_of_publishers = publisherdao.getAllVerifiedPublishersCount();
                            int no_of_articles = articledao.getAllArticlesCount();
                            List <Article> most_viewedArticles = articledao.getMostViewedArticles(5);
                            List<Article> searchResults = articledao.searchArticles(searchQuery, 10);

                            System.out.println("no_of_users: " + no_of_users);
                            System.out.println("no_of_publishers: " + no_of_publishers);
                            System.out.println("no_of_articles: " + no_of_articles);
                            System.out.println("most_viewed: " + most_viewed);

                            request.setAttribute("no_of_users", no_of_users);
                            request.setAttribute("no_of_publishers", no_of_publishers);
                            request.setAttribute("no_of_articles", no_of_articles);
                            request.setAttribute("most_viewedArticles", most_viewedArticles);
                            request.setAttribute("searchResults", searchResults);
                            request.setAttribute("searchQuery", searchQuery);
                            request.setAttribute("activePage","dashboard");
                            request.getRequestDispatcher("/WEB-INF/views/dashboard/admin/adminn.jsp").forward(request, response);
                        } catch (SQLException e) {
                            throw new RuntimeException(e);
                        }

                case "/admin/user-management":
                    List<User> allUsers = adminDAO.getAllUsers();
                    List<Publisher> pendingPublishersU = adminDAO.getPendingPublishers();


                    request.setAttribute("pendingPublishers", pendingPublishersU);
                    request.setAttribute("users", allUsers);
                    request.getRequestDispatcher("/WEB-INF/views/dashboard/admin/admin.jsp").forward(request, response);
                    return;



                    List <Article> articlesByStatus = articledao2.getArticlesByStatus(2);
                    System.out.println("articlesByStatus: " + articlesByStatus.size());
                    request.setAttribute("pendingArticles", articlesByStatus);
                    request.getRequestDispatcher("/WEB-INF/views/dashboard/admin/content-management.jsp").forward(request, response);
                    return;


                case "/admin/approveArticle":
                    ArticleDAO articledao3 = new ArticleDAO();
                    int articleId = Integer.parseInt(request.getParameter("id"));
                    System.out.println("articleId: " + articleId);
                   boolean published = articledao3.publishArticle(articleId,3);
                   if (published) {
                       request.setAttribute("published", true);

                   }

                   response.sendRedirect(request.getContextPath() + "/admin/content-management");
                   return;
                case "/admin/rejectArticle":
                    ArticleDAO articledao4 = new ArticleDAO();
                    String reason = request.getParameter("rejectionReason");
                    System.out.println("reason: " + reason);
                    int artId = Integer.parseInt(request.getParameter("articleId"));
                    System.out.println("articleId: " + artId);
                    boolean rejected = articledao4.rejectArticle(artId,4,reason);
                    if (rejected) {
                        request.setAttribute("rejected", true);
                        response.sendRedirect(request.getContextPath() + "/admin/content-management");
                    }
            }

            System.out.println("this is admin");



            return;
        } else if (currentUser.getRole() == Role.PUBLISHER) {

            User user = (User) SessionUtil.getCurrentUser(request);
            if (user == null || user.getRole() != Role.PUBLISHER) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            ArticleDAO articleDAO = new ArticleDAO();
            List<Article> articles = articleDAO.getArticlesByAuthor(user.getId());

            if (articles == null) {
                articles = List.of(); // Initialize to an empty list if null
            }

//            find the total number of articles
            int totalArticles = articles.size();

//            find total Number of Views, Likes
            int totalViews = articles.stream().mapToInt(Article::getViewCount).sum();
            int totalLikes = 0;
            ArticleLikeDAO articleLikeDAO = new ArticleLikeDAO();

            for (Article article : articles) {
                totalLikes += articleLikeDAO.getArticleLikeCount(article.getId());
            }


//            Top Performing Article
            Article topArticle = articles.stream()
                    .max((a1, a2) -> Integer.compare(a1.getViewCount(), a2.getViewCount()))
                    .orElse(null);


// find total comments and likes for top article
            if (topArticle != null) {
                CommentDAO commentDAO = new CommentDAO();
                int topArticleCommentCount = commentDAO.getArticleCommentCount(topArticle.getId(), false);
                int topArticleLikeCount = articleLikeDAO.getArticleLikeCount(topArticle.getId());
                topArticle.setCommentCount(topArticleCommentCount);
                topArticle.setLikeCount(topArticleLikeCount);
            }
//            filter and count articles by status
            int pendingCount = (int) articles.stream().filter(article -> article.getStatus() == ArticleStatus.PENDING_REVIEW).count();
            int publishedCount = (int) articles.stream().filter(article -> article.getStatus() == ArticleStatus.PUBLISHED).count();
            int rejectedCount = (int) articles.stream().filter(article -> article.getStatus() == ArticleStatus.REJECTED).count();
            int draftCount = (int) articles.stream().filter(article -> article.getStatus() == ArticleStatus.DRAFT).count();

            request.setAttribute("totalArticles", totalArticles);
            request.setAttribute("totalViews", totalViews);
            request.setAttribute("totalLikes", totalLikes);
            request.setAttribute("topArticle", topArticle);
            request.setAttribute("articles", articles);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("publishedCount", publishedCount);
            request.setAttribute("rejectedCount", rejectedCount);
            request.setAttribute("draftCount", draftCount);


            request.getRequestDispatcher("/WEB-INF/views/dashboard/publisher/publisher.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/unauthorized.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String path = request.getServletPath();

        switch (path) {
            case "/admin/pending-publishers":
                int id = Integer.parseInt(request.getParameter("id"));
                System.out.println("id: " + id);
                if ("approve".equals(action)) {
                    boolean approved = adminDAO.approvePublisher(id);
                    System.out.println("approved: " + approved);

                    request.setAttribute("approved", approved);
                    request.getRequestDispatcher("/WEB-INF/views/dashboard/admin/admin.jsp").forward(request, response);
                } else if ("reject".equals(action)) {
                    boolean rejected = adminDAO.rejectPublisher(id);
                    System.out.println("rejected: " + rejected);
                    request.setAttribute("rejected", rejected);
                }
        }
    }
}
