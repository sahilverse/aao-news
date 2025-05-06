package com.aaonews.controllers;

import com.aaonews.dao.AdminDAO;
import com.aaonews.enums.Role;
import com.aaonews.models.Publisher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import java.io.IOException;
import java.util.List;

import com.aaonews.utils.SessionUtil;
import com.aaonews.models.User;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard",
        "/admin/dashboard",
        "/admin/pending-publishers",
"/admin/content-management"})
public class DashboardServlet extends HttpServlet {
    private AdminDAO adminDAO;

    public void init() throws ServletException {
        // Initialize DAO here
        adminDAO = new AdminDAO();
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
                    if(pendingPublishers==null){
                        System.out.println("pending publishers is null");
                        return;
                    }


                    request.setAttribute("pendingPublishers", pendingPublishers);
                    request.getRequestDispatcher("/WEB-INF/views/dashboard/admin/publisher-approval.jsp").forward(request, response);
                    return;
            }

            System.out.println("this is admin");


            List<User> allUsers = adminDAO.getAllUsers();
            List<Publisher> pendingPublishers = adminDAO.getPendingPublishers();



            request.setAttribute("pendingPublishers", pendingPublishers);
            request.setAttribute("users", allUsers);
            request.getRequestDispatcher("/WEB-INF/views/dashboard/admin/admin.jsp").forward(request, response);
            return;
        }
        else if (currentUser.getRole() == Role.PUBLISHER) {
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
                if("approve".equals(action)) {
                    boolean approved = adminDAO.approvePublisher(id);
                    System.out.println("approved: " + approved);

                    request.setAttribute("approved", approved);
                }
                else if("reject".equals(action)) {
                    boolean rejected = adminDAO.rejectPublisher(id);
                    System.out.println("rejected: " + rejected);
                    request.setAttribute("rejected", rejected);
                }


        }
    }


}
