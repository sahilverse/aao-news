package com.aaonews.controllers;


import com.aaonews.dao.UserDAO;
import com.aaonews.enums.Role;
import com.aaonews.models.User;
import com.aaonews.utils.PasswordUtil;
import com.aaonews.utils.SessionUtil;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;



import java.io.IOException;
import com.aaonews.utils.ValidationUtil;



@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/login.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("checkbox");

        // Validate email and password
        if (!ValidationUtil.isValidEmail(email.trim())) {
            forwardWithError(request, response, "Invalid Email");
            return;
        }


        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);

        if (user == null) {
            forwardWithError(request, response, "User not found");
            return;
        }

        boolean passwordMatch = PasswordUtil.comparePassword(password, user.getPassword());
        if (!passwordMatch) {
            forwardWithError(request, response, "Incorrect password");
            return;
        }

        // Successful login
        SessionUtil.createUserSession(request, user);


        if ("on".equals(rememberMe)) {
            SessionUtil.createRememberMeCookie(response, user.getId());
        } else{
            SessionUtil.clearRememberMeCookie(response);
        }

        if (user.getRole() == Role.ADMIN || user.getRole() == Role.PUBLISHER) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }

        response.sendRedirect(request.getContextPath());
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String errorMsg)
            throws ServletException, IOException {
        request.setAttribute("loginAttempted", true);
        request.setAttribute("error", errorMsg);
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

}
