package com.aaonews.controllers.dashboard.publisher;
import com.aaonews.models.User;
import com.aaonews.utils.SessionUtil;
import com.aaonews.utils.SlugGenerator;
import com.aaonews.models.Article;
import com.aaonews.enums.ArticleStatus;

import com.aaonews.dao.ArticleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.http.Part;
import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;


@WebServlet(name = "CreateArticleServlet", urlPatterns = {"/publisher/create"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class CreateArticleServlet extends HttpServlet {

    private ArticleDAO articleDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        articleDAO = new ArticleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        requestDispatcher(req, resp);
    }

    /**
     * Handles POST requests - processes the article submission
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("CreateArticleServlet: doPost() called");

        try {
            // Get the current user from the session
            User user = SessionUtil.getCurrentUser(request);

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            int userId = user.getId();

            // Extract form data
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String summary = request.getParameter("summary");

            // Get category parameter - FIXED: changed from categoryId to category
            String categoryParam = request.getParameter("category");

            // Debug output to see what parameters are coming in
            System.out.println("Title: " + title);
            System.out.println("Content: " + content);
            System.out.println("Summary: " + summary);
            System.out.println("Category: " + categoryParam);
            System.out.println("Status: " + request.getParameter("status"));

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
                request.setAttribute("error", "Invalid category selected");
                requestDispatcher(request, response);
                return;
            }

            // Sanitize HTML content to prevent XSS attacks
            String sanitizedTitle = sanitizeHtml(title);
            String sanitizedContent = sanitizeHtml(content);
            String sanitizedSummary = sanitizeHtml(summary);

            // Create slug from title
            String slug = SlugGenerator.generateSlug(title);

            // Determine article status
            String statusParam = request.getParameter("status");
            ArticleStatus status;
            if (statusParam != null && statusParam.equalsIgnoreCase("publish")) {
                status = ArticleStatus.PENDING_REVIEW;
            } else {
                status = ArticleStatus.DRAFT;
            }

            // Create article object
            Article article = new Article();
            article.setTitle(sanitizedTitle);
            article.setSlug(slug);
            article.setContent(sanitizedContent);
            article.setSummary(sanitizedSummary);
            article.setAuthorId(userId);
            article.setCategoryId(categoryId);
            article.setStatus(status);

            // Handle featured image if provided
            try {
                Part imagePart = request.getPart("featuredImage");
                if(imagePart != null){
                    System.out.println("Image part name: " + imagePart.getName());
                    System.out.println("Image part size: " + imagePart.getSize());
                } else {
                    System.out.println("Image part is null");
                }
                if (imagePart != null && imagePart.getSize() > 0) {
                   byte[] imageBytes = imagePart.getInputStream().readAllBytes();
                    article.setFeatureImage(imageBytes);
                }
            } catch (Exception e) {
                System.out.println("Error processing image: " + e.getMessage());
                e.printStackTrace();
            }

            // Save article to database
            int articleId = articleDAO.createArticle(article);

            if (articleId > 0) {
                // Success - redirect to the article list with success message
                System.out.println("Article created successfully with ID: " + articleId);
                request.getSession().setAttribute("successMessage", "Article created successfully!");
                response.sendRedirect(request.getContextPath() + "/publisher/articles");
            } else {
                // Error - return to form with error message
                request.setAttribute("error", "Failed to create article. Please try again.");
                request.setAttribute("article", article); // Return the form data
                requestDispatcher(request, response);
            }

        } catch (Exception e) {
            // Log the exception
            System.out.println("Error in CreateArticleServlet: " + e.getMessage());
            e.printStackTrace();

            // Return to form with error message
            request.setAttribute("error", "An error occurred: " + e.getMessage());
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