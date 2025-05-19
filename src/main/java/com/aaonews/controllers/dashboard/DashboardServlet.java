package com.aaonews.controllers.dashboard;

import com.aaonews.dao.AdminDAO;
import com.aaonews.dao.ArticleDAO;
import com.aaonews.dao.PublisherDAO;
import com.aaonews.dao.UserDAO;
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


@WebServlet(name = "DashboardServlet", urlPatterns = {"/admin/user-management",
        "/dashboard",
        "/admin/pending-publishers",
"/admin/content-management",
"/edit-user"})

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
                            request.getRequestDispatcher("/WEB-INF/views/dashboard/admin/admin-dashboard.jsp").forward(request, response);
                        } catch (SQLException e) {
                            throw new RuntimeException(e);
                        }

                case "/admin/user-management":
                    List<User> allUsers = adminDAO.getAllUsers();
                    List<Publisher> pendingPublishersU = adminDAO.getPendingPublishers();


                    request.setAttribute("pendingPublishers", pendingPublishersU);
                    request.setAttribute("users", allUsers);
                    request.getRequestDispatcher("/WEB-INF/views/dashboard/admin/admin.jsp").forward(request, response);

            }

            System.out.println("this is admin");



            return;
        } else if (currentUser.getRole() == Role.PUBLISHER) {
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
