package com.aaonews.controllers;


import com.aaonews.utils.DatabaseUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/article-image")
public class ArticleImageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException{
        String articleId = request.getParameter("id");

        // Basic validation
        if (articleId == null || articleId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Article ID is required");
            return;
        }

        // Fetch the image data from the database (this part is not implemented here)
        byte[] imageData = fetchImageDataFromDatabase(articleId);

        if (imageData != null && imageData.length > 0) {
            // Set content type and length
            response.setContentType("image/jpeg");
            response.setContentLength(imageData.length);
            response.getOutputStream().write(imageData);
        } else {

            response.setContentType("image/jpeg");
            response.setContentLength(0);
            response.getOutputStream().write(new byte[0]);


        }

    }

    private byte[] fetchImageDataFromDatabase(String articleId) {
        if (articleId == null) {
            System.err.println("Invalid article ID");
            return null;
        }

        String query = "SELECT featured_image FROM articles WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, Integer.parseInt(articleId));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBytes("featured_image");
                }
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid article ID format: " + articleId);
        } catch (SQLException e) {
            System.err.println("Database error while fetching image data: " + e.getMessage());
        }

        return null;
    }

}
