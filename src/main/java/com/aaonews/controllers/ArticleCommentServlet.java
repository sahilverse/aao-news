package com.aaonews.controllers;

import com.aaonews.dto.CommentWithUser;
import com.aaonews.utils.SessionUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import com.aaonews.dao.CommentDAO;
import com.aaonews.dao.UserDAO;
import com.aaonews.models.Comment;
import com.aaonews.models.User;
import com.google.gson.Gson;
import com.google.gson.JsonObject;



@WebServlet("/comment")
public class ArticleCommentServlet extends HttpServlet {
    private CommentDAO commentDAO;
    private UserDAO userDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        commentDAO = new CommentDAO();
        userDAO = new UserDAO();
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

            if ("add".equals(action)) {
                addComment(request, response, currentUser, out);
            } else if ("reply".equals(action)) {
                addReply(request, response, currentUser, out);
            }else if("delete".equalsIgnoreCase(action)){
                deleteComment(request,response,currentUser,out);
            }else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
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

            if ("getComments".equals(action)) {
                getComments(request, response, out);
            } else if ("getCount".equals(action)) {
                getCommentCount(request, response, out);
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

    private void addComment(HttpServletRequest request, HttpServletResponse response,
                            User currentUser, PrintWriter out) throws IOException {

        int articleId = Integer.parseInt(request.getParameter("articleId"));
        String content = request.getParameter("content");

        if (content == null || content.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Comment content cannot be empty");
            out.print(gson.toJson(errorResponse));
            return;
        }

        Comment comment = new Comment(articleId, currentUser.getId(), 0, content.trim());
        Comment createdComment = commentDAO.createComment(comment);

        if (createdComment != null) {
            JsonObject successResponse = new JsonObject();
            CommentWithUser commentWithUser = new CommentWithUser(createdComment, currentUser);
            successResponse.addProperty("success", true);
            successResponse.add("comments", gson.toJsonTree(commentWithUser));
            out.print(gson.toJson(successResponse));
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Failed to add comment");
            out.print(gson.toJson(errorResponse));
        }
    }

    private void addReply(HttpServletRequest request, HttpServletResponse response,
                          User currentUser, PrintWriter out) throws IOException {

        int articleId = Integer.parseInt(request.getParameter("articleId"));
        int parentId = Integer.parseInt(request.getParameter("parentId"));
        String content = request.getParameter("content");

        if (content == null || content.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Reply content cannot be empty");
            out.print(gson.toJson(errorResponse));
            return;
        }

        Comment reply = new Comment(articleId, currentUser.getId(), parentId, content.trim());
        Comment createdReply = commentDAO.createComment(reply);

        if (createdReply != null) {
            JsonObject successResponse = new JsonObject();
            CommentWithUser replyWithUser = new CommentWithUser(createdReply, currentUser);
            successResponse.addProperty("success", true);
            successResponse.add("reply", gson.toJsonTree(replyWithUser));
            out.print(gson.toJson(successResponse));
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Failed to add reply");
            out.print(gson.toJson(errorResponse));
        }
    }

    private void getComments(HttpServletRequest request, HttpServletResponse response,
                             PrintWriter out) throws IOException {

        int articleId = Integer.parseInt(request.getParameter("articleId"));
        List<Comment> comments = commentDAO.getCommentsByArticleId(articleId, true);

        List<CommentWithUser> commentWithUsers = new ArrayList<>();

        for (Comment comment : comments) {
            User user = userDAO.getUserById(comment.getUserId());
            user.setPassword(null); // Clear password for security
            commentWithUsers.add(new CommentWithUser(comment, user));
        }

        JsonObject successResponse = new JsonObject();
        successResponse.addProperty("success", true);
        successResponse.add("comments", gson.toJsonTree(commentWithUsers));
        out.print(gson.toJson(successResponse));
    }

    private void getCommentCount(HttpServletRequest request, HttpServletResponse response,
                                 PrintWriter out) throws IOException {

        int articleId = Integer.parseInt(request.getParameter("articleId"));
        int count = commentDAO.getArticleCommentCount(articleId, true);

        JsonObject successResponse = new JsonObject();
        successResponse.addProperty("success", true);
        successResponse.addProperty("count", count);
        out.print(gson.toJson(successResponse));
    }

    private void deleteComment(HttpServletRequest request, HttpServletResponse response,
                               User currentUser, PrintWriter out) throws IOException {

        int commentId = Integer.parseInt(request.getParameter("commentId"));
        Comment comment = commentDAO.getCommentById(commentId);

        if (comment == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Comment not found");
            out.print(gson.toJson(errorResponse));
            return;
        }

        if (comment.getUserId() != currentUser.getId()) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "You can only delete your own comments");
            out.print(gson.toJson(errorResponse));
            return;
        }

        boolean deleted = commentDAO.deleteComment(commentId);

        if (deleted) {
            JsonObject successResponse = new JsonObject();
            successResponse.addProperty("success", true);
            successResponse.addProperty("message", "Comment deleted successfully");
            out.print(gson.toJson(successResponse));
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Failed to delete comment");
            out.print(gson.toJson(errorResponse));
        }
    }
}
