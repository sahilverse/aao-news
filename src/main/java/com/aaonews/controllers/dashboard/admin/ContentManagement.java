package com.aaonews.controllers.dashboard.admin;

import com.aaonews.dao.AdminDAO;
import com.aaonews.dao.ArticleDAO;
import com.aaonews.dao.PublisherDAO;
import com.aaonews.dao.UserDAO;
import com.aaonews.models.Article;
import com.aaonews.models.Publisher;
import com.aaonews.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jdk.jfr.Category;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@WebServlet("/admin/content-management")

public class ContentManagement extends HttpServlet {

    ArticleDAO articledao = new ArticleDAO();
    PublisherDAO publisherdao = new PublisherDAO();
    UserDAO userdao = new UserDAO();
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List <Article> articlesByStatus = articledao.getArticlesByStatus(2);
        for (Article article : articlesByStatus) {
            int id = article.getAuthorId();
            User publisher = userdao.getUserById(id);
            if(publisher != null) {
                article.setAuthor(publisher);
            }

        }

        request.setAttribute("articles", articlesByStatus);
        request.setAttribute("activePage","contentManagement");
        System.out.println("this is from the article dao "+ articlesByStatus.size());
        request.getRequestDispatcher("/WEB-INF/views/dashboard/admin/admin.jsp").forward(request, response);

    }



    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String articleId = String.valueOf(Integer.parseInt(request.getParameter("articleId")));
        String action = request.getParameter("action");
        System.out.println("this is article id "+articleId);
        AdminDAO admindao = new AdminDAO();
        if (action.equals("approve")) {
            try {
                admindao.approveArticle(Integer.parseInt(articleId));
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        } else if (action.equals("reject")) {
            try {
                admindao.rejectArticle(Integer.parseInt(articleId), request.getParameter("reason"));
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        } else if (action.equals("delete")) {
            articledao.deleteArticle(Integer.parseInt(articleId));
        }

        response.sendRedirect(request.getContextPath() + "/admin/content-management");
    }
}