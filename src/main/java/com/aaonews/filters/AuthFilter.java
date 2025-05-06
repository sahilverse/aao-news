package com.aaonews.filters;

import com.aaonews.dao.PublisherDAO;
import com.aaonews.dao.UserDAO;
import com.aaonews.enums.Role;
import com.aaonews.models.User;
import com.aaonews.utils.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import java.io.IOException;

/**
 * Filter for handling authentication and "Remember Me" functionality
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    private UserDAO userDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Check if user is already in session
        User currentUser = SessionUtil.getCurrentUser(httpRequest);

        // If not in session, check for "Remember Me" cookie
        if (currentUser == null) {
            int userId = SessionUtil.getUserIdFromRememberMeCookie(httpRequest);
            if (userId > 0) {
                User user = userDAO.getUserById(userId);
                if (user != null) {
                    // Create session for user
                    SessionUtil.createUserSession(httpRequest, user);

                    // Create session for publisher if user is a publisher
                    if (user.getRole() == Role.PUBLISHER) {
                        PublisherDAO publisherDAO = new PublisherDAO();
                        SessionUtil.createPublisherSession(httpRequest, user, publisherDAO.getPublisherById(user.getId()));
                    }
                    // Update last login time
                    userDAO.updateLastLogin(userId);
                }
            }
        }

        // Redirect logged-in users away from login/register pages
        String uri = httpRequest.getRequestURI();
        if ((uri.endsWith("/login") || uri.endsWith("/register")) && currentUser != null) {
            httpResponse.sendRedirect(httpRequest.getContextPath());
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Nothing to do
    }
}
