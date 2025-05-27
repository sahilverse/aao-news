package com.aaonews.controllers;

import com.aaonews.dao.CommentLikeDAO;
import com.aaonews.models.CommentLike;
import com.aaonews.models.User;
import com.aaonews.utils.SessionUtil;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/comment-like")
public class CommentLikeServlet extends HttpServlet {
    private CommentLikeDAO commentLikeDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        commentLikeDAO = new CommentLikeDAO();
        gson = new Gson();
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();


        User currentUser = SessionUtil.getCurrentUser(request);

        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String action = request.getParameter("action");
            int commentId = Integer.parseInt(request.getParameter("commentId"));

            if ("toggle".equals(action)) {
                toggleCommentLike(commentId, currentUser.getId(), out);
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
            int commentId = Integer.parseInt(request.getParameter("commentId"));

            if ("getCount".equals(action)) {
                getCommentLikeCount(commentId, out);
            } else if ("checkLiked".equals(action)) {
                checkIfCommentLiked(request, commentId, out);
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

    private void toggleCommentLike(int commentId, int userId, PrintWriter out) throws IOException {
        boolean isLiked = commentLikeDAO.hasUserLikedComment(commentId, userId);
        boolean success;

        if (isLiked) {
            success = commentLikeDAO.removeLike(commentId, userId);
        } else {
            CommentLike like = commentLikeDAO.addLike(commentId, userId);
            success = (like != null);
        }

        if (success) {
            int newCount = commentLikeDAO.getCommentLikeCount(commentId);
            JsonObject successResponse = new JsonObject();
            successResponse.addProperty("success", true);
            successResponse.addProperty("liked", !isLiked);
            successResponse.addProperty("likeCount", newCount);
            successResponse.addProperty("message", isLiked ? "Like removed" : "Comment liked");
            out.print(gson.toJson(successResponse));
        } else {
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Failed to toggle comment like");
            out.print(gson.toJson(errorResponse));
        }
    }

    private void getCommentLikeCount(int commentId, PrintWriter out) throws IOException {
        int count = commentLikeDAO.getCommentLikeCount(commentId);
        JsonObject successResponse = new JsonObject();
        successResponse.addProperty("success", true);
        successResponse.addProperty("count", count);
        out.print(gson.toJson(successResponse));
    }

    private void checkIfCommentLiked(HttpServletRequest request, int commentId, PrintWriter out) throws IOException {
        User currentUser = SessionUtil.getCurrentUser(request);

        boolean isLiked = false;
        if (currentUser != null) {
            isLiked = commentLikeDAO.hasUserLikedComment(commentId, currentUser.getId());
        }

        JsonObject successResponse = new JsonObject();
        successResponse.addProperty("success", true);
        successResponse.addProperty("liked", isLiked);
        out.print(gson.toJson(successResponse));
    }
}
