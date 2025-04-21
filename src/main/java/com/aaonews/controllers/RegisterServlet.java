package com.aaonews.controllers;

import com.aaonews.dao.UserDAO;
import com.aaonews.enums.Role;
import com.aaonews.models.Publisher;
import com.aaonews.models.User;
import com.aaonews.utils.SessionUtil;


import com.aaonews.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;


import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet for handling user registration
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is already logged in
        User currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser != null) {
            // Redirect to home page or dashboard
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Get registration type from query parameter
        String registrationType = request.getParameter("type");

        if (registrationType == null) {
            // Show registration type selection page
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        } else if ("user".equals(registrationType)) {
            // Show user registration form
            request.getRequestDispatcher("/WEB-INF/views/user-register.jsp").forward(request, response);
        } else if ("admin".equals(registrationType)) {
            // Show admin registration form
            request.getRequestDispatcher("/WEB-INF/views/admin-register.jsp").forward(request, response);
        } else {
            // Invalid registration type
            response.sendRedirect(request.getContextPath() + "/register");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get registration type from form
        String registrationType = request.getParameter("registrationType");

        if ("user".equals(registrationType)) {
            handleUserRegistration(request, response);
        } else if ("admin".equals(registrationType)) {
            System.out.println("Admin registration Request" );
            handleAdminRegistration(request, response);
        } else {
            // Invalid registration type
            SessionUtil.setFlashMessage(request, "error", "Invalid registration type.");
            response.sendRedirect(request.getContextPath() + "/register");
        }
    }

    /**
     * Handles registration for regular users
     */
    private void handleUserRegistration(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        Role role = Role.valueOf(request.getParameter("role").toUpperCase());
        boolean rememberMe = "on".equals(request.getParameter("rememberMe"));


        // Validate form data
        Map<String, String> errors = validateUserForm(email, password, confirmPassword, fullName);

        if (!errors.isEmpty()) {
            // Store errors and form data in session for redisplay
            HttpSession session = request.getSession();
            session.setAttribute("errors", errors);
            session.setAttribute("formData", getFormData(request));

            // Redirect back to form
            response.sendRedirect(request.getContextPath() + "/register?type=user");
            return;
        }


        // Create user object
        User user = new User(email, password, fullName, role);

        // Save user to database
        int userId = userDAO.createUser(user);

        if (userId > 0) {
            // Set user in session
            user = userDAO.getUserById(userId);
            if (user.getRole() == Role.PUBLISHER) {
                Publisher publisher = new Publisher(userId);
                userDAO.createPublisher(publisher);
            }
            SessionUtil.createUserSession(request, user);

            // Set remember me cookie if requested
            if (rememberMe) {
                SessionUtil.createRememberMeCookie(response, userId);
            }

            // Set success message
            SessionUtil.setFlashMessage(request, "success", "Registration successful! Please check your email to verify your account.");


            // Redirect to dashboard or verification page
            response.sendRedirect(request.getContextPath() + "/");
        } else {
            // Registration failed
            SessionUtil.setFlashMessage(request, "error", "Registration failed. Please try again.");
            response.sendRedirect(request.getContextPath() + "/register?type=user");
        }
    }


    /**
     * Handles registration for administrators
     */
    private void handleAdminRegistration(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String adminCode = request.getParameter("adminCode");


        // Validate form data
        Map<String, String> errors = validateUserForm(email, password, confirmPassword, fullName);

        // Validate admin code
        String expectedAdminCode = getServletContext().getInitParameter("adminCode");
        if (!ValidationUtil.isNotEmpty(adminCode) || !adminCode.equals(expectedAdminCode)) {
            errors.put("adminCode", "Invalid administrator code.");
        }

        if (!errors.isEmpty()) {
            // Store errors and form data in session for redisplay
            HttpSession session = request.getSession();
            session.setAttribute("errors", errors);
            session.setAttribute("formData", getFormData(request));

            // Redirect back to form
            response.sendRedirect(request.getContextPath() + "/register?type=admin");
            return;
        }


        // Create user object
        User user = new User(email, password, fullName, Role.ADMIN);

        // Save user to database
        int userId = userDAO.createUser(user);

        if (userId > 0) {
            // Set success message
            SessionUtil.setFlashMessage(request, "success", "Admin registration request submitted. You will be notified once approved.");

            // Redirect to login page
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            // Registration failed
            SessionUtil.setFlashMessage(request, "error", "Registration failed. Please try again.");
            response.sendRedirect(request.getContextPath() + "/register?type=admin");
        }
    }

    /**
     * Validates the user registration form
     *
     * @return A map of field names to error messages, empty if no errors
     */
    private Map<String, String> validateUserForm(String email,  String password, String confirmPassword, String fullName) {
        Map<String, String> errors = new HashMap<>();

        // Validate email
        if (!ValidationUtil.isValidEmail(email)) {
            errors.put("email", "Please enter a valid email address.");
        } else if (userDAO.emailExists(email)) {
            errors.put("email", "This email is already registered.");
        }


        // Validate password
        if (!ValidationUtil.isValidPassword(password)) {
            errors.put("password", "Password must be at least 8 characters and include uppercase, lowercase, number, and special character.");
        }

        // Validate password confirmation
        if (!ValidationUtil.areEqual(password, confirmPassword)) {
            errors.put("confirmPassword", "Passwords do not match.");
        }

        // Validate full name
        if (!ValidationUtil.isNotEmpty(fullName)) {
            errors.put("fullName", "Full name is required.");
        }


        return errors;
    }

    /**
     * Gets form data from the request parameters
     *
     * @return A map of field names to values
     */
    private Map<String, String> getFormData(HttpServletRequest request) {
        Map<String, String> formData = new HashMap<>();

        formData.put("email", request.getParameter("email"));
        formData.put("fullName", request.getParameter("fullName"));

        return formData;
    }


}
