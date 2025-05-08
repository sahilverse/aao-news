package com.aaonews.controllers;

import com.aaonews.dao.UserDAO;
import com.aaonews.enums.Role;
import com.aaonews.models.User;
import com.aaonews.utils.PasswordUtil;
import com.aaonews.utils.SessionUtil;
import com.aaonews.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet for handling user profile-related actions
 */

@WebServlet(urlPatterns = {"/profile", "/publisher/profile", "/admin/profile", "/update-password", "/update-profile"})
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
                req.setAttribute("activePage", "adminProfile");
                req.getRequestDispatcher("/WEB-INF/views/dashboard/admin/admin.jsp").forward(req, res);
                return;
            default:
                res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String path = req.getServletPath();

        User currentUser = SessionUtil.getCurrentUser(req);

        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        System.out.println(path);

        Map<String, String> errors = new HashMap<>();
        UserDAO userDAO = new UserDAO();

        switch (path) {
            case "/update-password":

                String oldPassword = req.getParameter("oldPassword");
                String newPassword = req.getParameter("newPassword");
                String confirmPassword = req.getParameter("confirmPassword");

                // check if new password is not empty
                if (!ValidationUtil.isNotEmpty(newPassword)) {
                    errors.put("password", "Password cannot be empty.");
                }

                //check - confirm password and new password are same
                if (!ValidationUtil.areEqual(newPassword, confirmPassword)) {
                    errors.put("confirmPassword", "Passwords do not match.");
                }

                // check if current password is correct
                boolean passwordMatch = PasswordUtil.comparePassword(oldPassword, currentUser.getPassword());
                if (!passwordMatch) {
                    errors.put("oldPassword", "Incorrect password");
                }

                // check if new password is valid
                if (!ValidationUtil.isValidPassword(newPassword)) {
                    errors.put("password", "Password must be at least 8 characters and include uppercase, lowercase, number, and special character.");
                }

                // check if there are any errors
                if (!errors.isEmpty()) {
                    req.setAttribute("errors", errors);
                    dispatchRequestAsPerRole(req, res, currentUser);
                    return;
                }

                // update password
                boolean isUpdated = userDAO.updatePassword(currentUser.getId(), newPassword);


                if (isUpdated) {
                    // Update the user object in the session
                    currentUser.setPassword(PasswordUtil.hashPassword(newPassword));
                    SessionUtil.createUserSession(req, currentUser);
                    // Password updated successfully
                    req.setAttribute("successMessage", "Password updated successfully.");
                    dispatchRequestAsPerRole(req, res, currentUser);
                } else {
                    // Password update failed
                    req.setAttribute("errorMessage", "Failed to update password. Please try again.");
                }

                return;
            case "/update-profile":
                String name = req.getParameter("fullName");

                //  validate name
                if (!ValidationUtil.isNotEmpty(name)) {
                    errors.put("fullName", "Full name cannot be empty.");
                }

                // check if there are any errors
                if (!errors.isEmpty()) {
                    req.setAttribute("errors", errors);
                    dispatchRequestAsPerRole(req, res, currentUser);
                    return;
                }
                // update profile
                boolean isProfileUpdated = userDAO.updateProfile(currentUser.getId(), name);

                if (isProfileUpdated) {
                    currentUser.setFullName(name);
                    SessionUtil.createUserSession(req, currentUser);
                    req.setAttribute("successMessage", "Profile updated successfully.");
                    dispatchRequestAsPerRole(req, res, currentUser);
                } else {
                    // Profile update failed
                    req.setAttribute("errorMessage", "Failed to update profile. Please try again.");
                }
                return;
            default:
                res.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void dispatchRequestAsPerRole(HttpServletRequest req, HttpServletResponse res, User user) throws ServletException, IOException {
        if (user.getRole() == Role.PUBLISHER) {
            req.setAttribute("activePage", "publisherProfile");
            req.getRequestDispatcher("/WEB-INF/views/dashboard/publisher/publisher.jsp").forward(req, res);
        } else if (user.getRole() == Role.ADMIN) {
            req.setAttribute("activePage", "adminProfile");
            req.getRequestDispatcher("/WEB-INF/views/dashboard/admin/admin.jsp").forward(req, res);
        } else {
            req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, res);
        }
    }


}
