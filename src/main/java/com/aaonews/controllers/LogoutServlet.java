package com.aaonews.controllers;

import com.aaonews.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;


@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Invalidate the session
        SessionUtil.invalidateSession(request);

        // Remove the "Remember Me" cookie
        SessionUtil.clearRememberMeCookie(response);

        response.sendRedirect(request.getContextPath());
    }
}
