package com.aaonews.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(urlPatterns = {"/profile", "/publisher/profile", "/admin/profile"})
public class ProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String path = req.getServletPath();
        System.out.println("path: " + path);

        switch (path) {
            case "/profile":
                req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, res);
                return;
            case "/publisher/profile":
                req.setAttribute("activePage", "publisherProfile");
                req.getRequestDispatcher("/WEB-INF/views/dashboard/publisher/publisher.jsp").forward(req, res);
                return;
            case "/admin/profile":
                req.getRequestDispatcher("/WEB-INF/views/admin-profile.jsp").forward(req, res);
                return;
            default:
                res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }

    }
}
