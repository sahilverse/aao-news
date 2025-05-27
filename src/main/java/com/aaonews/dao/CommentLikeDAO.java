package com.aaonews.dao;

import com.aaonews.models.CommentLike;
import com.aaonews.utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for CommentLike entities.
 * Handles database operations related to comment likes.
 */
public class CommentLikeDAO {
    private static final Logger LOGGER = Logger.getLogger(CommentLikeDAO.class.getName());

    /**
     * Adds a like to a comment.
     *
     * @param commentId The ID of the comment to like
     * @param userId The ID of the user liking the comment
     * @return The created CommentLike object, or null if creation failed
     */
    public CommentLike addLike(int commentId, int userId) {
        // First check if the user has already liked the comment
        if (hasUserLikedComment(commentId, userId)) {
            LOGGER.log(Level.INFO, "User " + userId + " has already liked comment " + commentId);
            return getLike(commentId, userId);
        }

        String sql = "INSERT INTO comment_likes (comment_id, user_id) VALUES (?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, commentId);
            stmt.setInt(2, userId);

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                LOGGER.log(Level.WARNING, "Adding comment like failed, no rows affected.");
                return null;
            }

            return getLike(commentId, userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding comment like", e);
            return null;
        }
    }

    /**
     * Retrieves a like by comment ID and user ID.
     *
     * @param commentId The ID of the comment
     * @param userId The ID of the user
     * @return The like, or null if not found
     */
    public CommentLike getLike(int commentId, int userId) {
        String sql = "SELECT * FROM comment_likes WHERE comment_id = ? AND user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, commentId);
            stmt.setInt(2, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToLike(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving comment like for comment ID: " + commentId + " and user ID: " + userId, e);
        }

        return null;
    }

    /**
     * Checks if a user has liked a comment.
     *
     * @param commentId The ID of the comment
     * @param userId The ID of the user
     * @return true if the user has liked the comment, false otherwise
     */
    public boolean hasUserLikedComment(int commentId, int userId) {
        String sql = "SELECT COUNT(*) FROM comment_likes WHERE comment_id = ? AND user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, commentId);
            stmt.setInt(2, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if user has liked comment", e);
        }

        return false;
    }

    /**
     * Removes a like from a comment.
     *
     * @param commentId The ID of the comment
     * @param userId The ID of the user
     * @return true if the removal was successful, false otherwise
     */
    public boolean removeLike(int commentId, int userId) {
        String sql = "DELETE FROM comment_likes WHERE comment_id = ? AND user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, commentId);
            stmt.setInt(2, userId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error removing comment like", e);
            return false;
        }
    }

    /**
     * Counts the number of likes for a comment.
     *
     * @param commentId The ID of the comment
     * @return The number of likes for the comment
     */
    public int getCommentLikeCount(int commentId) {
        String sql = "SELECT COUNT(*) FROM comment_likes WHERE comment_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, commentId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting likes for comment ID: " + commentId, e);
        }

        return 0;
    }

    /**
     * Retrieves all likes for a comment.
     *
     * @param commentId The ID of the comment
     * @return A list of likes for the comment
     */
    public List<CommentLike> getLikesByCommentId(int commentId) {
        String sql = "SELECT * FROM comment_likes WHERE comment_id = ? ORDER BY created_at DESC";

        List<CommentLike> likes = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, commentId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    likes.add(mapResultSetToLike(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving likes for comment ID: " + commentId, e);
        }

        return likes;
    }

    /**
     * Maps a ResultSet row to a CommentLike object.
     *
     * @param rs The ResultSet to map
     * @return A CommentLike object
     * @throws SQLException If an error occurs while accessing the ResultSet
     */
    private CommentLike mapResultSetToLike(ResultSet rs) throws SQLException {
        CommentLike like = new CommentLike();
        like.setCommentId(rs.getInt("comment_id"));
        like.setUserId(rs.getInt("user_id"));
        like.setCreatedAt(rs.getTimestamp("created_at"));
        return like;
    }
}