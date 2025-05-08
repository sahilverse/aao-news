package com.aaonews.controllers;

import com.aaonews.utils.DatabaseUtil;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


/*
 * UserImageServlet.java
 * This servlet handles requests for user profile images.
 * If the user has a profile image, it serves that image.
 * If not, it serves a default image.
 */

@WebServlet("/user-image")
public class UserImageServlet extends HttpServlet {
    private static final String DEFAULT_IMAGE_PATH = "/assets/images/default-user.jpeg";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userId = request.getParameter("id");

        // Basic validation
        if (userId == null || userId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required");
            return;
        }

        byte[] imageData = null;

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT profile_image FROM users WHERE id = ?")) {

            ps.setInt(1, Integer.parseInt(userId));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    imageData = rs.getBytes("profile_image");
                }
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error or invalid user ID");
            return;
        }

        if (imageData != null && imageData.length > 0) {
            // Set content type and length
            response.setContentType("image/jpeg");
            response.setContentLength(imageData.length);
            // Write image data to response
            response.getOutputStream().write(imageData);
            response.getOutputStream().flush();
        } else {
            serveDefaultImage(request, response);
        }
    }

    /**
     * Serves the default user image
     */
    private void serveDefaultImage(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (InputStream defaultImageStream = getServletContext().getResourceAsStream(DEFAULT_IMAGE_PATH)) {
            if (defaultImageStream != null) {
                response.setContentType("image/jpeg");

                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = defaultImageStream.read(buffer)) != -1) {
                    response.getOutputStream().write(buffer, 0, bytesRead);
                }
                response.getOutputStream().flush();
            } else {
                response.sendRedirect(request.getContextPath() + DEFAULT_IMAGE_PATH);
            }
        }
    }
}
