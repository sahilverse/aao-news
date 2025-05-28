package com.aaonews.controllers.dashboard.admin;
import com.aaonews.dao.AdminDAO;

import com.aaonews.models.Publisher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/user-management")


public class UserManagementServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String publisherId = String.valueOf(Integer.parseInt(request.getParameter("publisherId")));
        String action = request.getParameter("action");

        if ("approve".equals(action)) {
            System.out.println("approve");
            adminDAO.approvePublisher(Integer.parseInt(publisherId));



        } else if ("reject".equals(action)) {

            System.out.println("this is reject");
            adminDAO.rejectPublisher(Integer.parseInt(publisherId));
        }

        response.sendRedirect(request.getContextPath() + "/admin/pending-publishers");
    }
}

