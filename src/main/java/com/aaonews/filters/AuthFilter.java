package com.aaonews.filters;

import com.aaonews.dao.UserDAO;
import com.aaonews.models.User;
import com.aaonews.utils.JWTUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;


/**
 * AuthFilter checks if the user is logged in and manages JWT token validation.
 * It redirects logged-in users away from login/register pages.
 */

@WebFilter("/*")
public class AuthFilter implements Filter {

    private final UserDAO userDAO = new UserDAO();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    /**
     * Filters requests to check if the user is logged in.
     * If not, it checks for a JWT token in cookies and validates it.
     * If valid, it sets the user in the session.
     * Redirects logged-in users away from login/register pages.
     */

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("user") != null);

        if (!loggedIn) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("session".equals(cookie.getName())) {
                        String email = JWTUtil.validateToken(cookie.getValue());
                        if (email != null) {
                            User user = userDAO.getUserByEmail(email);
                            if (user != null) {
                                request.getSession().setAttribute("user", user);
                            }
                        }
                    }
                }
            }
        }

        // Redirect logged-in users away from login/register pages
        String uri = request.getRequestURI();
        if ((uri.endsWith("/login") || uri.endsWith("/register")) &&
                request.getSession().getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath());
            return;
        }

        chain.doFilter(request, response);
    }


    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}
