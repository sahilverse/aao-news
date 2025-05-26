package com.aaonews.controllers;

import com.aaonews.dao.ArticleLikeDAO;
import com.aaonews.models.ArticleLike;
import com.aaonews.models.User;
import com.aaonews.utils.SessionUtil;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/article-like")
public class ArticleLikeServlet extends HttpServlet {
    private ArticleLikeDAO articleLikeDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        articleLikeDAO = new ArticleLikeDAO();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        PrintWriter out = response.getWriter();

        User currentUser = SessionUtil.getCurrentUser(request);

        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String action = request.getParameter("action");
            int articleId = Integer.parseInt(request.getParameter("articleId"));

            if ("toggle".equals(action)) {
                toggleLike(articleId, currentUser.getId(), out);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Invalid action");
                out.print(gson.toJson(errorResponse));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Server error: " + e.getMessage());
            out.print(gson.toJson(errorResponse));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String action = request.getParameter("action");
            int articleId = Integer.parseInt(request.getParameter("articleId"));

            if ("getCount".equals(action)) {
                getLikeCount(articleId, out);
            } else if ("checkLiked".equals(action)) {
                checkIfLiked(request, articleId, out);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Invalid action");
                out.print(gson.toJson(errorResponse));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Server error: " + e.getMessage());
            out.print(gson.toJson(errorResponse));
        }
    }

    private void toggleLike(int articleId, int userId, PrintWriter out) throws IOException {
        ArticleLikeDAO articleLikeDAO = new ArticleLikeDAO();
        boolean isLiked = articleLikeDAO.hasUserLikedArticle(articleId, userId);
        boolean success;

        if (isLiked) {
            success = articleLikeDAO.removeLike(articleId, userId);
        } else {
            ArticleLike like = articleLikeDAO.addLike(articleId, userId);
            success = (like != null);
            System.out.println("Successfully added like: " + success);
        }

        JsonObject response = new JsonObject();

        if (success) {
            int newCount = articleLikeDAO.getArticleLikeCount(articleId);
            response.addProperty("success", true);
            response.addProperty("liked", !isLiked);
            response.addProperty("likeCount", newCount);
            response.addProperty("message", isLiked ? "Like removed" : "Article liked");
        } else {
            response.addProperty("success", false);
            response.addProperty("message", "Failed to toggle like");
        }

        // Make sure to flush and close properly
        String jsonResponse = gson.toJson(response);
        out.print(jsonResponse);
        out.flush();
    }

    private void getLikeCount(int articleId, PrintWriter out) throws IOException {
        int count = articleLikeDAO.getArticleLikeCount(articleId);
        JsonObject successResponse = new JsonObject();
        successResponse.addProperty("success", true);
        successResponse.addProperty("count", count);
        out.print(gson.toJson(successResponse));
    }

    private void checkIfLiked(HttpServletRequest request, int articleId, PrintWriter out) throws IOException {
        User currentUser = SessionUtil.getCurrentUser(request);

        boolean isLiked = false;
        if (currentUser != null) {
            isLiked = articleLikeDAO.hasUserLikedArticle(articleId, currentUser.getId());
        }

        JsonObject successResponse = new JsonObject();
        successResponse.addProperty("success", true);
        successResponse.addProperty("liked", isLiked);
        out.print(gson.toJson(successResponse));
    }
}