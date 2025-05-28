package com.aaonews.controllers.dashboard.admin;

import com.aaonews.dao.AdminDAO;

import com.aaonews.dao.PublisherDAO;
import com.aaonews.models.Publisher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


@WebServlet("/admin/user-management")

public class UserManagementServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PublisherDAO publisherDAO = new PublisherDAO();
        List<Publisher> all = publisherDAO.getAllPublishers();
        List <Publisher> verified = new ArrayList<>();
        for (Publisher p : all){
            if(p.getIsVerified()){
                verified.add(p);
            }
        }
        request.setAttribute("verified",verified);
        request.setAttribute("activePage","userManagement");
        request.getRequestDispatcher("/WEB-INF/views/dashboard/admin/admin.jsp").forward(request, response);

    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        AdminDAO adminDAO = new AdminDAO();
        boolean unverified = false;

        try {
            unverified =adminDAO.unverifyPublisher(id);

            response.sendRedirect(request.getContextPath() + "/admin/user-management");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


    }
}
