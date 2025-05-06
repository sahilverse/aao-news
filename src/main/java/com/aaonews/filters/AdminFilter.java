package com.aaonews.filters;

import com.aaonews.enums.Role;
import com.aaonews.models.User;
import com.aaonews.utils.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import java.io.IOException;

/**
 * Filter to restrict access to admin-only resources
 */
@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Get current user from session
        User currentUser = SessionUtil.getCurrentUser(httpRequest);

        // Check if user is logged in and has ADMIN role
        if (currentUser != null && currentUser.getRole() == Role.ADMIN) {
            chain.doFilter(request, response);
        } else {

            httpRequest.getRequestDispatcher("/WEB-INF/views/unauthorized.jsp").forward(httpRequest, httpResponse);
        }
    }

    @Override
    public void destroy() {
    }
}
