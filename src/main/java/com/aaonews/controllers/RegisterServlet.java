package com.aaonews.controllers;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet("/register")
public class RegisterServlet extends HttpServlet   {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward the request to the registration page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/register.jsp");
        dispatcher.forward(request, response);
    }
}
