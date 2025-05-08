package com.aaonews.dao;

import com.aaonews.enums.ArticleStatus;
import com.aaonews.models.Article;
import com.aaonews.utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
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
        String sql = "INSERT INTO articles (title, slug, content, summary, author_id, category_id, status_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, article.getTitle());
            stmt.setString(2, article.getSlug());
            stmt.setString(3, article.getContent());
            stmt.setString(4, article.getSummary());
            stmt.setInt(5, article.getAuthorId());
            stmt.setInt(6, article.getCategoryId());
            stmt.setInt(7, article.getStatusID().getId());

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
        String sql = "UPDATE articles SET title = ?, slug = ?, content = ?, summary = ?, " +
                "category_id = ?, status_id = ?, updated_at = CURRENT_TIMESTAMP " +
                "WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, article.getTitle());
            stmt.setString(2, article.getSlug());
            stmt.setString(3, article.getContent());
            stmt.setString(4, article.getSummary());
            stmt.setInt(5, article.getCategoryId());
            stmt.setInt(6, article.getStatusID().getId());
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
        String sql = "SELECT * FROM articles WHERE author_id = ? ORDER BY created_at DESC";
        List<Article> articles = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, authorId);

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
     * @return List of articles in the specified category
     */
    public List<Article> getArticlesByCategory(int categoryId) {
        String sql = "SELECT * FROM articles WHERE category_id = ? AND status_id = ? " +
                "ORDER BY published_at DESC";
        List<Article> articles = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, categoryId);
            stmt.setInt(2, getPublishedStatusId());

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
     * Retrieves featured articles
     *
     * @param limit The maximum number of articles to retrieve
     * @return List of featured articles
     */
    public List<Article> getFeaturedArticles(int limit) {
        String sql = "SELECT * FROM articles WHERE is_featured = TRUE AND status_id = ? " +
                "ORDER BY published_at DESC LIMIT ?";
        List<Article> articles = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, getPublishedStatusId());
            stmt.setInt(2, limit);

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
     * Retrieves the most viewed articles
     *
     * @param limit The maximum number of articles to retrieve
     * @return List of most viewed articles
     */
    public List<Article> getMostViewedArticles(int limit) {
        String sql = "SELECT * FROM articles WHERE status_id = ? " +
                "ORDER BY view_count DESC LIMIT ?";
        List<Article> articles = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, getPublishedStatusId());
            stmt.setInt(2, limit);

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
     * Searches for articles by title or content
     *
     * @param searchTerm The term to search for
     * @param limit The maximum number of articles to retrieve
     * @return List of articles matching the search term
     */
    public List<Article> searchArticles(String searchTerm, int limit) {
        String sql = "SELECT * FROM articles WHERE status_id = ? AND " +
                "(title LIKE ? OR content LIKE ?) " +
                "ORDER BY published_at DESC LIMIT ?";
        List<Article> articles = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + searchTerm + "%";
            stmt.setInt(1, getPublishedStatusId());
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setInt(4, limit);

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
     * Helper method to get the ID of the published status
     *
     * @return The ID of the published status
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

        return 1;
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

    /**
     * Helper method to map a ResultSet row to an Article object
     *
     * @param rs The ResultSet containing article data
     * @return An Article object populated with data from the ResultSet
     * @throws SQLException If a database access error occurs
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
        article.setStatusID(ArticleStatus.fromId(rs.getInt("status_id")));
        article.setRejectionMessage(rs.getString("rejection_message"));
        article.setFeatured(rs.getBoolean("is_featured"));
        article.setViewCount(rs.getInt("view_count"));

        // Handle timestamps
        Timestamp publishedAt = rs.getTimestamp("published_at");
        if (publishedAt != null) {
            article.setPublishedAt(publishedAt.toLocalDateTime());
        }

        article.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        article.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

        // Handle BLOB data if needed
        Blob featuredImage = rs.getBlob("featured_image");
        if (featuredImage != null) {
            article.setFeatureImage(featuredImage.getBytes(1, (int) featuredImage.length()));
        }

        return article;
    }
}