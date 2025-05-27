package com.aaonews.dao;

import com.aaonews.enums.ArticleStatus;
import com.aaonews.models.Article;
import com.aaonews.models.User;
import com.aaonews.utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Data Access Object for handling Article-related database operations
 */
public class ArticleDAO {

    /**
     * Creates a new article in the database
     *
     * @param article The article object to be created
     * @return The ID of the newly created article, or -1 if creation failed
     */
    public int createArticle(Article article) {
        String sql = "INSERT INTO articles (title, slug, content, summary, author_id, category_id, status_id, featured_image) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, article.getTitle());
            stmt.setString(2, article.getSlug());
            stmt.setString(3, article.getContent());
            stmt.setString(4, article.getSummary());
            stmt.setInt(5, article.getAuthorId());
            stmt.setInt(6, article.getCategoryId());
            stmt.setInt(7, article.getStatus().getId());

            if (article.getFeatureImage() != null) {
                stmt.setBytes(8, article.getFeatureImage());
            } else {
                stmt.setNull(8, Types.BLOB);
            }

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                return -1;
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    return -1;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * Retrieves an article by its ID
     *
     * @param articleId The ID of the article to retrieve
     * @return Optional containing the article if found, empty otherwise
     */
    public Optional<Article> getArticleById(int articleId) {
        String sql = "SELECT * FROM articles WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Article article = mapResultSetToArticle(rs);
                    return Optional.of(article);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return Optional.empty();
    }

    /**
     * Retrieves an article by its slug
     *
     * @param slug The slug of the article to retrieve
     * @return Optional containing the article if found, empty otherwise
     */
    public Optional<Article> getArticleBySlug(String slug) {
        String sql = "SELECT * FROM articles WHERE slug = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, slug);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Article article = mapResultSetToArticle(rs);
                    return Optional.of(article);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return Optional.empty();
    }

    /**
     * Updates an existing article in the database
     *
     * @param article The article object with updated values
     * @return true if update was successful, false otherwise
     */
    public boolean updateArticle(Article article) {
        String sql = "UPDATE articles SET title = ?, content = ?, summary = ?, " +
                "category_id = ?, status_id = ?, featured_image=?, updated_at = CURRENT_TIMESTAMP " +
                "WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, article.getTitle());
            stmt.setString(2, article.getContent());
            stmt.setString(3, article.getSummary());
            stmt.setInt(4, article.getCategoryId());
            stmt.setInt(5, article.getStatus().getId());
            if (article.getFeatureImage() != null) {
                stmt.setBytes(6, article.getFeatureImage());
            } else {
                stmt.setNull(6, Types.BLOB);
            }
            stmt.setInt(7, article.getId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Deletes an article from the database
     *
     * @param articleId The ID of the article to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteArticle(int articleId) {
        String sql = "DELETE FROM articles WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Publishes an article by setting its status and published date
     *
     * @param articleId The ID of the article to publish
     * @param statusId The status ID to set (typically published status)
     * @return true if publishing was successful, false otherwise
     */
    public boolean publishArticle(int articleId, int statusId) {
        String sql = "UPDATE articles SET status_id = ?, published_at = CURRENT_TIMESTAMP " +
                "WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, statusId);
            stmt.setInt(2, articleId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Rejects an article by setting its status and rejection message
     *
     * @param articleId The ID of the article to reject
     * @param statusId The status ID to set (typically rejected status)
     * @param rejectionMessage The message explaining why the article was rejected
     * @return true if rejection was successful, false otherwise
     */
    public boolean rejectArticle(int articleId, int statusId, String rejectionMessage) {
        String sql = "UPDATE articles SET status_id = ?, rejection_message = ? " +
                "WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, statusId);
            stmt.setString(2, rejectionMessage);
            stmt.setInt(3, articleId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Increments the view count of an article
     *
     * @param articleId The ID of the article to increment views for
     * @return true if increment was successful, false otherwise
     */
    public boolean incrementViewCount(int articleId) {
        String sql = "UPDATE articles SET view_count = view_count + 1 WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves all articles by a specific author
     *
     * @param authorId The ID of the author
     * @return List of articles by the author
     */
    public List<Article> getArticlesByAuthor(int authorId) {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT a.*, u.id as author_id, u.full_name as author_name, u.email as author_email, " +
                "u.profile_image as author_image " +
                "FROM articles a " +
                "JOIN users u ON a.author_id = u.id " +
                "WHERE a.author_id = ? " +
                "ORDER BY a.created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, authorId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Article article = mapResultSetToArticleWithAuthor(rs);
                    articles.add(article);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return articles;
    }

    /**
     * Retrieves all articles by status
     *
     * @param statusId The status ID to filter by
     * @return List of articles with the specified status
     */
    public List<Article> getArticlesByStatus(int statusId) {
        String sql = "SELECT * FROM articles WHERE status_id = ? ORDER BY created_at DESC";
        List<Article> articles = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, statusId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Article article = mapResultSetToArticle(rs);
                    articles.add(article);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return articles;
    }

    /**
     * Retrieves all articles by category
     *
     * @param categoryId The category ID to filter by
     * @param limit The maximum number of articles to retrieve
     * @return List of articles in the specified category
     */
    public List<Article> getArticlesByCategory(int categoryId, int limit) {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT a.*, u.id as author_id, u.full_name as author_name, u.email as author_email, " +
                "u.profile_image as author_image " +
                "FROM articles a " +
                "JOIN users u ON a.author_id = u.id " +
                "WHERE a.category_id = ? AND a.status_id = ? " +
                "ORDER BY a.created_at DESC LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, categoryId);
            stmt.setInt(2, getPublishedStatusId());
            stmt.setInt(3, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Article article = mapResultSetToArticleWithAuthor(rs);
                    articles.add(article);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return articles;
    }

    /**
     * Retrieves featured articles
     *
     * @param limit The maximum number of articles to retrieve
     * @return List of featured articles
     */
    public List<Article> getFeaturedArticles(int limit) {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT a.*, u.id as author_id, u.full_name as author_name, u.email as author_email, " +
                "u.profile_image as author_image " +
                "FROM articles a " +
                "JOIN users u ON a.author_id = u.id " +
                "WHERE a.is_featured = TRUE AND a.status_id = ? " +
                "ORDER BY a.created_at DESC LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, getPublishedStatusId());
            stmt.setInt(2, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Article article = mapResultSetToArticleWithAuthor(rs);
                    articles.add(article);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return articles;
    }

    /**
     * Retrieves the latest articles
     *
     * @param limit The maximum number of articles to retrieve
     * @return List of latest articles
     */
    public List<Article> getLatestArticles(int limit) {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT a.*, u.id as author_id, u.full_name as author_name, u.email as author_email, " +
                "u.profile_image as author_image " +
                "FROM articles a " +
                "JOIN users u ON a.author_id = u.id " +
                "WHERE a.status_id = ? " +
                "ORDER BY a.published_at DESC LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, getPublishedStatusId());
            stmt.setInt(2, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Article article = mapResultSetToArticleWithAuthor(rs);
                    articles.add(article);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return articles;
    }

    /**
     * Retrieves the most viewed articles
     *
     * @param limit The maximum number of articles to retrieve
     * @return List of most viewed articles
     */
    public List<Article> getMostViewedArticles(int limit) {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT a.*, u.id as author_id, u.full_name as author_name, u.email as author_email, " +
                "u.profile_image as author_image " +
                "FROM articles a " +
                "JOIN users u ON a.author_id = u.id " +
                "WHERE a.status_id = ? " +
                "ORDER BY a.view_count DESC LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, getPublishedStatusId());
            stmt.setInt(2, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Article article = mapResultSetToArticleWithAuthor(rs);
                    articles.add(article);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return articles;
    }

    /**
     * Retrieves trending articles based on view count in the last 7 days
     *
     * @param limit The maximum number of articles to retrieve
     * @return List of trending articles
     */
    public List<Article> getTrendingArticles(int limit) {
        List<Article> articles = new ArrayList<>();

        // Even more optimized version with indexed columns
        String sql = "SELECT a.id, a.title, a.slug, a.content, a.summary, a.featured_image, " +
                "a.author_id, a.category_id, a.status_id, a.rejection_message, " +
                "a.is_featured, a.view_count, a.published_at, a.created_at, a.updated_at, " +
                "u.full_name as author_name, u.email as author_email, u.profile_image as author_image, " +
                "(COALESCE(al.like_count, 0) + COALESCE(c.comment_count, 0) + (a.view_count * 0.1)) as engagement_score " +
                "FROM articles a " +
                "INNER JOIN users u ON a.author_id = u.id " +
                "LEFT JOIN (" +
                "    SELECT article_id, COUNT(*) as like_count " +
                "    FROM article_likes " +
                "    WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY) " +  // Only recent likes
                "    GROUP BY article_id" +
                ") al ON a.id = al.article_id " +
                "LEFT JOIN (" +
                "    SELECT article_id, COUNT(*) as comment_count " +
                "    FROM comments " +
                "    WHERE is_approved = TRUE " +
                "    AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY) " +  // Only recent comments
                "    GROUP BY article_id" +
                ") c ON a.id = c.article_id " +
                "WHERE a.status_id = ? " +
                "AND a.published_at >= DATE_SUB(NOW(), INTERVAL 7 DAY) " +
                "ORDER BY engagement_score DESC, a.published_at DESC " +
                "LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, getPublishedStatusId());
            stmt.setInt(2, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Article article = mapResultSetToArticleWithAuthor(rs);
                    articles.add(article);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error fetching trending articles: " + e.getMessage());
            e.printStackTrace();
        }

        return articles;
    }

    /**
     * Searches for articles by title or content
     *
     * @param searchTerm The term to search for
     * @param limit The maximum number of articles to retrieve
     * @return List of articles matching the search term
     */
    public List<Article> searchArticles(String searchTerm, int limit) {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT a.*, u.id as author_id, u.full_name as author_name, u.email as author_email, " +
                "u.profile_image as author_image " +
                "FROM articles a " +
                "JOIN users u ON a.author_id = u.id " +
                "WHERE a.status_id = ? AND (a.title LIKE ? OR a.content LIKE ?) " +
                "ORDER BY a.published_at DESC LIMIT ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + searchTerm + "%";
            stmt.setInt(1, getPublishedStatusId());
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setInt(4, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Article article = mapResultSetToArticleWithAuthor(rs);
                    articles.add(article);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return articles;
    }

    /**
     * Gets the total count of articles by a specific author
     *
     * @param authorId The ID of the author
     * @return The total count of articles by the author
     */
    public int getArticleCountByAuthor(int authorId) {
        String sql = "SELECT COUNT(*) FROM articles WHERE author_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, authorId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Gets the total view count of all articles by a specific author
     *
     * @param authorId The ID of the author
     * @return The total view count of all articles by the author
     */
    public int getTotalViewsByAuthor(int authorId) {
        String sql = "SELECT SUM(view_count) FROM articles WHERE author_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, authorId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Bulk fetch authors for multiple articles (Alternative approach)
     * Use this if you need to fetch authors separately
     */
    public Map<Integer, User> getAuthorsForArticles(List<Integer> authorIds) {
        Map<Integer, User> authors = new HashMap<>();

        if (authorIds.isEmpty()) {
            return authors;
        }

        // Create placeholders for IN clause
        String placeholders = String.join(",", authorIds.stream().map(id -> "?").toArray(String[]::new));
        String sql = "SELECT id, full_name, email, profile_image FROM users WHERE id IN (" + placeholders + ")";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Set parameters
            for (int i = 0; i < authorIds.size(); i++) {
                stmt.setInt(i + 1, authorIds.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    User author = new User();
                    author.setId(rs.getInt("id"));
                    author.setFullName(rs.getString("full_name"));
                    author.setEmail(rs.getString("email"));
                    author.setProfileImage(rs.getBytes("profile_image"));

                    authors.put(author.getId(), author);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return authors;
    }

    /**
     * Helper method to map ResultSet to Article with Author information (OPTIMIZED)
     */
    private Article mapResultSetToArticleWithAuthor(ResultSet rs) throws SQLException {
        Article article = new Article();

        // Map article fields
        article.setId(rs.getInt("id"));
        article.setTitle(rs.getString("title"));
        article.setSlug(rs.getString("slug"));
        article.setContent(rs.getString("content"));
        article.setSummary(rs.getString("summary"));
        article.setAuthorId(rs.getInt("author_id"));
        article.setCategoryId(rs.getInt("category_id"));
        article.setStatus(ArticleStatus.fromId(rs.getInt("status_id")));
        article.setRejectionMessage(rs.getString("rejection_message"));
        article.setFeatured(rs.getBoolean("is_featured"));
        article.setViewCount(rs.getInt("view_count"));
        article.setCreatedAt(rs.getTimestamp("created_at"));
        article.setUpdatedAt(rs.getTimestamp("updated_at"));
        article.setPublishedAt(rs.getTimestamp("published_at"));

        // Handle article image
        byte[] featuredImage = rs.getBytes("featured_image");
        if (featuredImage != null) {
            article.setFeatureImage(featuredImage);
        }

        // Map author fields
        User author = new User();
        author.setId(rs.getInt("author_id"));
        author.setFullName(rs.getString("author_name"));
        author.setEmail(rs.getString("author_email"));
        author.setUsername(rs.getString("author_name")); // Using full_name as username for display

        byte[] authorImage = rs.getBytes("author_image");
        if (authorImage != null) {
            author.setProfileImage(authorImage);
        }

        article.setAuthor(author);

        return article;
    }

    /**
     * Original mapping method for backward compatibility
     */
    private Article mapResultSetToArticle(ResultSet rs) throws SQLException {
        Article article = new Article();
        article.setId(rs.getInt("id"));
        article.setTitle(rs.getString("title"));
        article.setSlug(rs.getString("slug"));
        article.setContent(rs.getString("content"));
        article.setSummary(rs.getString("summary"));
        article.setAuthorId(rs.getInt("author_id"));
        article.setCategoryId(rs.getInt("category_id"));
        article.setStatus(ArticleStatus.fromId(rs.getInt("status_id")));
        article.setRejectionMessage(rs.getString("rejection_message"));
        article.setFeatured(rs.getBoolean("is_featured"));
        article.setViewCount(rs.getInt("view_count"));
        article.setCreatedAt(rs.getTimestamp("created_at"));
        article.setUpdatedAt(rs.getTimestamp("updated_at"));
        article.setPublishedAt(rs.getTimestamp("published_at"));

        byte[] featuredImage = rs.getBytes("featured_image");
        if (featuredImage != null) {
            article.setFeatureImage(featuredImage);
        }

        return article;
    }

    /**
     * Helper method to get the ID of the published status
     */
    private int getPublishedStatusId() {
        String sql = "SELECT id FROM article_statuses WHERE name = 'published'";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 1; // Default fallback
    }

    public int getAllArticlesCount() {
        String sql = "SELECT COUNT(*) FROM articles";
        try(Connection conn = DatabaseUtil.getConnection();) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
                else{
                    return 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public User getArticleAuthor(int articleId) {
        String sql = "SELECT u.* FROM articles a JOIN users u ON a.author_id = u.id WHERE a.id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setProfileImage(rs.getBytes("profile_image"));
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
