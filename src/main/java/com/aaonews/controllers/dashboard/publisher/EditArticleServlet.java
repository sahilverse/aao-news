package com.aaonews.controllers.dashboard.publisher;

import com.aaonews.dao.ArticleDAO;
import com.aaonews.enums.ArticleStatus;
import com.aaonews.models.Article;
import com.aaonews.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.aaonews.utils.SessionUtil;
import jakarta.servlet.http.Part;
import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;

import java.io.IOException;
import java.util.Objects;
import java.util.Optional;

@WebServlet(name = "EditArticleServlet", urlPatterns = {"/publisher/edit", "/publisher/updateArticle"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class EditArticleServlet extends HttpServlet {
    private ArticleDAO articleDAO;

    public void init() throws ServletException {
        super.init();
        articleDAO = new ArticleDAO();

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String articleId = request.getParameter("id");

        if (articleId == null || articleId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/publisher/articles");
            return;
        }

//        check if the article belongs to the user
       User author = articleDAO.getArticleAuthor(Integer.parseInt(articleId));
        if (author.getId() != Objects.requireNonNull(SessionUtil.getCurrentUser(request)).getId()) {
//           send 403 forbidden
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to edit this article.");
            return;
        }

//        Get the article
        Optional<Article> article = articleDAO.getArticleById(Integer.parseInt(articleId));
        if (article.isPresent()) {
            request.setAttribute("article", article.get());
            request.setAttribute("activePage", "createArticle");

            request.getRequestDispatcher("/WEB-INF/views/dashboard/publisher/publisher.jsp").forward(request, response);
        }else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Article not found");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        User user = SessionUtil.getCurrentUser(request);

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String articleId = request.getParameter("articleId");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String summary = request.getParameter("summary");

        // Get category parameter
        String categoryParam = request.getParameter("category");
        String statusParam = request.getParameter("status");

        // Validate required fields
        if (title == null || title.trim().isEmpty() ||
                content == null || content.trim().isEmpty() ||
                summary == null || summary.trim().isEmpty() ||
                categoryParam == null || categoryParam.trim().isEmpty()) {

            request.setAttribute("error", "All required fields must be filled out");
            requestDispatcher(request, response);
            return;
        }

        // Parse category ID
        int categoryId;

        try {
            categoryId = Integer.parseInt(categoryParam);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid category ID");
            requestDispatcher(request, response);
            return;
        }

        // Sanitize HTML content to prevent XSS attacks
        String sanitizedTitle = sanitizeHtml(title);
        String sanitizedContent = sanitizeHtml(content);
        String sanitizedSummary = sanitizeHtml(summary);

        // Determine article status

        ArticleStatus status;
        if (statusParam != null && statusParam.equalsIgnoreCase("publish")) {
            status = ArticleStatus.PUBLISHED;
        } else {
            status = ArticleStatus.DRAFT;
        }

        Article article = new Article();
        article.setId(Integer.parseInt(articleId));
        article.setTitle(sanitizedTitle);
        article.setContent(sanitizedContent);
        article.setSummary(sanitizedSummary);
        article.setCategoryId(categoryId);
        article.setStatus(status);

        // Handle featured image if provided
        try {
            Part imagePart = request.getPart("featuredImage");

            if (imagePart != null && imagePart.getSize() > 0) {
                byte[] imageBytes = imagePart.getInputStream().readAllBytes();
                article.setFeatureImage(imageBytes);
            }
        } catch (Exception e) {
            System.out.println("Error processing image: " + e.getMessage());
            e.printStackTrace();
        }

        // Update the article in the database
        boolean isUpdated = articleDAO.updateArticle(article);

        if (isUpdated) {
            // Success - redirect to the article list with success message
            System.out.println("Article Edited successfully with ID: " + articleId);
            request.getSession().setAttribute("successMessage", "Article Edited successfully!");
            response.sendRedirect(request.getContextPath() + "/publisher/articles");
        } else {
            // Error - return to form with error message
            request.setAttribute("error", "Failed to Edit article. Please try again.");
            request.setAttribute("article", article); // Return the form data
            requestDispatcher(request, response);
        }


    }

    /**
     * Sanitizes HTML content to prevent XSS attacks
     *
     * @param html The HTML content to sanitize
     * @return Sanitized HTML content
     */
    private String sanitizeHtml(String html) {
        if (html == null) {
            return "";
        }

        return Jsoup.clean(html, Safelist.relaxed());
    }

    private void requestDispatcher(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set the active page attribute for the JSP
        request.setAttribute("activePage", "createArticle");
        request.getRequestDispatcher("/WEB-INF/views/dashboard/publisher/publisher.jsp").forward(request, response);
    }

}
