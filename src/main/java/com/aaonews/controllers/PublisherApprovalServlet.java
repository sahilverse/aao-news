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

@WebServlet("/pending-publishers")
public class PublisherApprovalServlet extends HttpServlet {
    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        AdminDAO adminDAO = new AdminDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Publisher> pendingPublishers = adminDAO.getPendingPublishers();
        System.out.println("this is pending"+pendingPublishers);
        request.setAttribute("pendingPublishers", pendingPublishers);
//        request.getRequestDispatcher("/WEB-INF/views/admin/publisher-approval.jsp").forward(request, response);
    }
}
