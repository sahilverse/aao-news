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
import java.util.List;

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
        for (Article article : articlesByStatus) {
            System.out.println(article.getAuthor());
            System.out.println(article.getTitle());
            System.out.println(article.getContent());
            System.out.println(article.getSummary());
        }
        request.setAttribute("articles", articlesByStatus);
        request.setAttribute("activePage","contentManagement");
        System.out.println("this is from the article dao "+ articlesByStatus.size());
        request.getRequestDispatcher("/WEB-INF/views/dashboard/admin/adminn.jsp").forward(request, response);

    }



    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String articleId = String.valueOf(Integer.parseInt(request.getParameter("articleId")));
        String action = request.getParameter("action");
        System.out.println("this is article id "+articleId);

        if ("approve".equals(action)) {
            System.out.println("approve");





        } else if ("reject".equals(action)) {
            System.out.println("reject");


        }

        response.sendRedirect(request.getContextPath() + "/admin/content-management");
    }
}