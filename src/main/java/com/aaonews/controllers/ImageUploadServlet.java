package com.aaonews.controllers;

import com.aaonews.dao.UserDAO;
import com.aaonews.enums.Role;
import com.aaonews.models.User;
import com.aaonews.utils.SessionUtil;
import com.sun.security.jgss.GSSUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "ImageUploadServlet", urlPatterns = {"/upload-image"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class ImageUploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = SessionUtil.getCurrentUser(request);
        byte[] imageBytes = null;
        Part imagePart = request.getPart("profileImage");

        if (imagePart != null) {
            imageBytes = imagePart.getInputStream().readAllBytes();
        }

        if(user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        System.out.println("Image upload servlet: " + user.getId());
        UserDAO userDAO = new UserDAO();
        userDAO.updateProfileImage(user.getId(), imageBytes);

        // Update the user object in the session
        user.setProfileImage(imageBytes);
        SessionUtil.createUserSession(request, user);

        if(user.getRole() == Role.PUBLISHER){
            response.sendRedirect(request.getContextPath() + "/publisher/profile");
            return;
        }else if(user.getRole() == Role.ADMIN){
            response.sendRedirect(request.getContextPath() + "/admin/profile");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/profile");

    }

}
