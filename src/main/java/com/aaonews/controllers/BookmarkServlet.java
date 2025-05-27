package com.aaonews.controllers;

import com.aaonews.dao.ArticleDAO;
import com.aaonews.dao.BookmarkDAO;
import com.aaonews.models.Article;
import com.aaonews.models.Bookmark;
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
import java.util.ArrayList;
import java.util.Optional;

@WebServlet("/bookmark")
public class BookmarkServlet extends HttpServlet {
    private BookmarkDAO bookmarkDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        bookmarkDAO = new BookmarkDAO();
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
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Please log in to bookmark articles");
            out.print(gson.toJson(errorResponse));
            return;
        }

        try {
            String action = request.getParameter("action");
            int articleId = Integer.parseInt(request.getParameter("articleId"));

            if ("toggle".equals(action)) {
                toggleBookmark(articleId, currentUser.getId(), out);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Invalid action");
                out.print(gson.toJson(errorResponse));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Invalid article ID");
            out.print(gson.toJson(errorResponse));
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
            String articleIdParam = request.getParameter("articleId");

            // Handle case where no parameters are provided or action is "getAll"
            if (action == null || action.isEmpty() || "getAll".equals(action)) {
                User currentUser = SessionUtil.getCurrentUser(request);
                if (currentUser == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                ArrayList<Bookmark> userBookmarks = (ArrayList<Bookmark>) bookmarkDAO.getBookmarksByUserId(currentUser.getId());
                ArrayList<Article> userArticles = new ArrayList<>();

                ArticleDAO articleDAO = new ArticleDAO();
                for (Bookmark bookmark : userBookmarks) {
                    Optional<Article> article = articleDAO.getArticleById(bookmark.getArticleId());
                    article.ifPresent(userArticles::add);
                }
                request.setAttribute("bookmarks", userArticles);
                request.getRequestDispatcher("/WEB-INF/views/bookmarks.jsp").forward(request, response);
                return;
            }

            // For other actions, articleId is required
            if (articleIdParam == null || articleIdParam.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Article ID is required");
                out.print(gson.toJson(errorResponse));
                return;
            }

            int articleId = Integer.parseInt(articleIdParam);

            if ("getCount".equals(action)) {
                getBookmarkCount(articleId, out);
            } else if ("checkBookmarked".equals(action)) {
                checkIfBookmarked(request, articleId, out);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Invalid action");
                out.print(gson.toJson(errorResponse));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Invalid article ID format");
            out.print(gson.toJson(errorResponse));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Server error: " + e.getMessage());
            out.print(gson.toJson(errorResponse));
        }
    }

    private void toggleBookmark(int articleId, int userId, PrintWriter out) throws IOException {
        boolean isBookmarked = bookmarkDAO.isBookmarked(userId, articleId);
        boolean success;

        if (isBookmarked) {
            success = bookmarkDAO.removeBookmark(userId, articleId);
        } else {
            Bookmark bookmark = new Bookmark(userId, articleId);
            success = bookmarkDAO.addBookmark(bookmark);
        }

        JsonObject response = new JsonObject();

        if (success) {
            int newCount = bookmarkDAO.getBookmarkCount(articleId);
            response.addProperty("success", true);
            response.addProperty("bookmarked", !isBookmarked);
            response.addProperty("bookmarkCount", newCount);
            response.addProperty("message", isBookmarked ? "Bookmark removed" : "Article bookmarked");
        } else {
            response.addProperty("success", false);
            response.addProperty("message", "Failed to toggle bookmark");
        }

        String jsonResponse = gson.toJson(response);
        out.print(jsonResponse);
        out.flush();
    }

    private void getBookmarkCount(int articleId, PrintWriter out) throws IOException {
        int count = bookmarkDAO.getBookmarkCount(articleId);
        JsonObject successResponse = new JsonObject();
        successResponse.addProperty("success", true);
        successResponse.addProperty("count", count);
        out.print(gson.toJson(successResponse));
    }

    private void checkIfBookmarked(HttpServletRequest request, int articleId, PrintWriter out) throws IOException {
        User currentUser = SessionUtil.getCurrentUser(request);

        boolean isBookmarked = false;
        if (currentUser != null) {
            isBookmarked = bookmarkDAO.isBookmarked(currentUser.getId(), articleId);
        }

        JsonObject successResponse = new JsonObject();
        successResponse.addProperty("success", true);
        successResponse.addProperty("bookmarked", isBookmarked);
        out.print(gson.toJson(successResponse));
    }
}
