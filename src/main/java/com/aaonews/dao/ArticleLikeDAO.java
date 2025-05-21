package com.aaonews.dao;

import com.aaonews.models.ArticleLike;
import com.aaonews.utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for ArticleLike entities.
 * Handles database operations related to article likes.
 */
public class ArticleLikeDAO {
    private static final Logger LOGGER = Logger.getLogger(ArticleLikeDAO.class.getName());

    /**
     * Adds a like to an article.
     *
     * @param articleId The ID of the article to like
     * @param userId The ID of the user liking the article
     * @return The created ArticleLike object, or null if creation failed
     */
    public ArticleLike addLike(int articleId, int userId) {
        // First check if the user has already liked the article
        if (hasUserLikedArticle(articleId, userId)) {
            LOGGER.log(Level.INFO, "User " + userId + " has already liked article " + articleId);
            return getLike(articleId, userId);
        }

        String sql = "INSERT INTO article_likes (article_id, user_id) VALUES (?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, articleId);
            stmt.setInt(2, userId);

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                LOGGER.log(Level.WARNING, "Adding like failed, no rows affected.");
                return null;
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return getLikeById(generatedKeys.getInt(1));
                } else {
                    LOGGER.log(Level.WARNING, "Adding like failed, no ID obtained.");
                    return null;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding like", e);
            return null;
        }
    }

    /**
     * Retrieves a like by its ID.
     *
     * @param likeId The ID of the like to retrieve
     * @return The like, or null if not found
     */
    public ArticleLike getLikeById(int likeId) {
        String sql = "SELECT * FROM article_likes WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, likeId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToLike(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving like by ID: " + likeId, e);
        }

        return null;
    }

    /**
     * Retrieves a like by article ID and user ID.
     *
     * @param articleId The ID of the article
     * @param userId The ID of the user
     * @return The like, or null if not found
     */
    public ArticleLike getLike(int articleId, int userId) {
        String sql = "SELECT * FROM article_likes WHERE article_id = ? AND user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);
            stmt.setInt(2, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToLike(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving like for article ID: " + articleId + " and user ID: " + userId, e);
        }

        return null;
    }

    /**
     * Checks if a user has liked an article.
     *
     * @param articleId The ID of the article
     * @param userId The ID of the user
     * @return true if the user has liked the article, false otherwise
     */
    public boolean hasUserLikedArticle(int articleId, int userId) {
        String sql = "SELECT COUNT(*) FROM article_likes WHERE article_id = ? AND user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);
            stmt.setInt(2, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if user has liked article", e);
        }

        return false;
    }

    /**
     * Removes a like from an article.
     *
     * @param articleId The ID of the article
     * @param userId The ID of the user
     * @return true if the removal was successful, false otherwise
     */
    public boolean removeLike(int articleId, int userId) {
        String sql = "DELETE FROM article_likes WHERE article_id = ? AND user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);
            stmt.setInt(2, userId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error removing like", e);
            return false;
        }
    }

    /**
     * Counts the number of likes for an article.
     *
     * @param articleId The ID of the article
     * @return The number of likes for the article
     */
    public int getArticleLikeCount(int articleId) {
        String sql = "SELECT COUNT(*) FROM article_likes WHERE article_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting likes for article ID: " + articleId, e);
        }

        return 0;
    }

    /**
     * Retrieves all likes for an article.
     *
     * @param articleId The ID of the article
     * @return A list of likes for the article
     */
    public List<ArticleLike> getLikesByArticleId(int articleId) {
        String sql = "SELECT * FROM article_likes WHERE article_id = ? ORDER BY created_at DESC";

        List<ArticleLike> likes = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    likes.add(mapResultSetToLike(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving likes for article ID: " + articleId, e);
        }

        return likes;
    }

    /**
     * Retrieves all articles liked by a user.
     *
     * @param userId The ID of the user
     * @return A list of article IDs liked by the user
     */
    public List<Integer> getArticlesLikedByUser(int userId) {
        String sql = "SELECT article_id FROM article_likes WHERE user_id = ? ORDER BY created_at DESC";

        List<Integer> articleIds = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    articleIds.add(rs.getInt("article_id"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving articles liked by user ID: " + userId, e);
        }

        return articleIds;
    }

    /**
     * Deletes all likes for an article.
     * Useful when deleting an article.
     *
     * @param articleId The ID of the article
     * @return true if the deletion was successful, false otherwise
     */
    public boolean deleteAllLikesForArticle(int articleId) {
        String sql = "DELETE FROM article_likes WHERE article_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);

            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting likes for article ID: " + articleId, e);
            return false;
        }
    }

    /**
     * Maps a ResultSet row to an ArticleLike object.
     *
     * @param rs The ResultSet to map
     * @return An ArticleLike object
     * @throws SQLException If an error occurs while accessing the ResultSet
     */
    private ArticleLike mapResultSetToLike(ResultSet rs) throws SQLException {
        ArticleLike like = new ArticleLike();
        like.setId(rs.getInt("id"));
        like.setArticleId(rs.getInt("article_id"));
        like.setUserId(rs.getInt("user_id"));
        like.setCreatedAt(rs.getTimestamp("created_at"));
        return like;
    }
}