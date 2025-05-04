package com.aaonews.controllers;

import com.aaonews.enums.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import java.io.IOException;

import com.aaonews.utils.SessionUtil;
import com.aaonews.models.User;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User currentUser = SessionUtil.getCurrentUser(request);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (currentUser.getRole() == Role.ADMIN) {
            request.getRequestDispatcher("/WEB-INF/views/dashboard/admin.jsp").forward(request, response);
        } else if (currentUser.getRole() == Role.PUBLISHER) {
            request.getRequestDispatcher("/WEB-INF/views/dashboard/publisher.jsp").forward(request, response);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/unauthorized.jsp").forward(request, response);
    }

}
