package com.aaonews.dao;

import com.aaonews.models.Comment;
import com.aaonews.utils.DatabaseUtil;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Comment entities.
 * Handles database operations related to comments.
 */
public class CommentDAO {
    private static final Logger LOGGER = Logger.getLogger(CommentDAO.class.getName());

    /**
     * Creates a new comment in the database.
     *
     * @param comment The comment to create
     * @return The created comment with its ID set, or null if creation failed
     */
    public Comment createComment(Comment comment) {
        String sql = "INSERT INTO comments (article_id, user_id, parent_id, content) VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, comment.getArticleId());
            stmt.setInt(2, comment.getUserId());
            stmt.setInt(3, comment.getParentId());
            stmt.setString(4, comment.getContent());


            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                LOGGER.log(Level.WARNING, "Creating comment failed, no rows affected.");
                return null;
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    comment.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                    return getCommentById(generatedKeys.getInt(1));
                } else {
                    LOGGER.log(Level.WARNING, "Creating comment failed, no ID obtained.");
                    return null;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating comment", e);
            return null;
        }
    }

    /**
     * Retrieves a comment by its ID.
     *
     * @param commentId The ID of the comment to retrieve
     * @return The comment, or null if not found
     */
    public Comment getCommentById(int commentId) {
        String sql = "SELECT * FROM comments WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, commentId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToComment(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving comment by ID: " + commentId, e);
        }

        return null;
    }

    /**
     * Retrieves all comments for an article.
     *
     * @param articleId The ID of the article
     * @param approvedOnly Whether to retrieve only approved comments
     * @return A list of comments for the article
     */
    public List<Comment> getCommentsByArticleId(int articleId, boolean approvedOnly) {
        String sql = approvedOnly
                ? "SELECT * FROM comments WHERE article_id = ? AND is_approved = true ORDER BY created_at DESC"
                : "SELECT * FROM comments WHERE article_id = ? ORDER BY created_at DESC";

        List<Comment> comments = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    comments.add(mapResultSetToComment(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving comments for article ID: " + articleId, e);
        }

        return comments;
    }

    /**
     * Retrieves all replies to a parent comment.
     *
     * @param parentId The ID of the parent comment
     * @param approvedOnly Whether to retrieve only approved replies
     * @return A list of replies to the parent comment
     */
    public List<Comment> getRepliesByParentId(int parentId, boolean approvedOnly) {
        String sql = approvedOnly
                ? "SELECT * FROM comments WHERE parent_id = ? AND is_approved = true ORDER BY created_at ASC"
                : "SELECT * FROM comments WHERE parent_id = ? ORDER BY created_at ASC";

        List<Comment> replies = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, parentId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    replies.add(mapResultSetToComment(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving replies for parent ID: " + parentId, e);
        }

        return replies;
    }

    /**
     * Updates an existing comment.
     *
     * @param comment The comment to update
     * @return true if the update was successful, false otherwise
     */
    public boolean updateComment(Comment comment) {
        String sql = "UPDATE comments SET content = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, comment.getContent());
            stmt.setInt(2, comment.getId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating comment ID: " + comment.getId(), e);
            return false;
        }
    }

    /**
     * Approves or rejects a comment.
     *
     * @param commentId The ID of the comment
     * @param approved Whether to approve or reject the comment
     * @return true if the operation was successful, false otherwise
     */
    public boolean setCommentApproval(int commentId, boolean approved) {
        String sql = "UPDATE comments SET is_approved = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, approved);
            stmt.setInt(2, commentId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error setting approval for comment ID: " + commentId, e);
            return false;
        }
    }

    /**
     * Deletes a comment.
     *
     * @param commentId The ID of the comment to delete
     * @return true if the deletion was successful, false otherwise
     */
    public boolean deleteComment(int commentId) {
        // First, delete all replies to this comment
        deleteReplies(commentId);

        // Then delete the comment itself
        String sql = "DELETE FROM comments WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, commentId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting comment ID: " + commentId, e);
            return false;
        }
    }

    /**
     * Deletes all replies to a comment.
     *
     * @param parentId The ID of the parent comment
     */
    private void deleteReplies(int parentId) {
        String sql = "DELETE FROM comments WHERE parent_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, parentId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting replies for parent ID: " + parentId, e);
        }
    }

    /**
     * Counts the number of comments for an article.
     *
     * @param articleId The ID of the article
     * @param approvedOnly Whether to count only approved comments
     * @return The number of comments for the article
     */
    public int getArticleCommentCount(int articleId, boolean approvedOnly) {
        String sql = approvedOnly
                ? "SELECT COUNT(*) FROM comments WHERE article_id = ? AND is_approved = true"
                : "SELECT COUNT(*) FROM comments WHERE article_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting comments for article ID: " + articleId, e);
        }

        return 0;
    }

    /**
     * Retrieves all comments by a user.
     *
     * @param userId The ID of the user
     * @return A list of comments by the user
     */
    public List<Comment> getCommentsByUserId(int userId) {
        String sql = "SELECT * FROM comments WHERE user_id = ? ORDER BY created_at DESC";

        List<Comment> comments = new ArrayList<>();

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    comments.add(mapResultSetToComment(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving comments for user ID: " + userId, e);
        }

        return comments;
    }

    /**
     * Maps a ResultSet row to a Comment object.
     *
     * @param rs The ResultSet to map
     * @return A Comment object
     * @throws SQLException If an error occurs while accessing the ResultSet
     */
    private Comment mapResultSetToComment(ResultSet rs) throws SQLException {
        Comment comment = new Comment();
        comment.setId(rs.getInt("id"));
        comment.setArticleId(rs.getInt("article_id"));
        comment.setUserId(rs.getInt("user_id"));
        comment.setParentId(rs.getInt("parent_id"));
        comment.setContent(rs.getString("content"));
        comment.setApproved(rs.getBoolean("is_approved"));
        comment.setCreatedAt(rs.getTimestamp("created_at"));
        comment.setUpdatedAt(rs.getTimestamp("updated_at"));
        return comment;
    }
}