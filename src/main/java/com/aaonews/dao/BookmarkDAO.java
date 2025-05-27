package com.aaonews.dao;

import com.aaonews.models.Bookmark;
import com.aaonews.utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * BookmarkDAO.java
 * Data Access Object for Bookmark operations
 * Provides CRUD operations for the bookmarks table
 */
public class BookmarkDAO {

    /**
     * Adds a new bookmark to the database
     *
     * @param bookmark The bookmark to add
     * @return true if the bookmark was added successfully, false otherwise
     */
    public boolean addBookmark(Bookmark bookmark) {
        String sql = "INSERT INTO bookmarks (user_id, article_id) VALUES (?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookmark.getUserId());
            stmt.setInt(2, bookmark.getArticleId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Removes a bookmark from the database
     *
     * @param userId The user ID
     * @param articleId The article ID
     * @return true if the bookmark was removed successfully, false otherwise
     */
    public boolean removeBookmark(int userId, int articleId) {
        String sql = "DELETE FROM bookmarks WHERE user_id = ? AND article_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, articleId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Checks if a bookmark exists for a specific user and article
     *
     * @param userId The user ID
     * @param articleId The article ID
     * @return true if the bookmark exists, false otherwise
     */
    public boolean isBookmarked(int userId, int articleId) {
        String sql = "SELECT COUNT(*) FROM bookmarks WHERE user_id = ? AND article_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, articleId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Retrieves all bookmarks for a specific user
     *
     * @param userId The user ID
     * @return List of bookmarks for the user
     */
    public List<Bookmark> getBookmarksByUserId(int userId) {
        List<Bookmark> bookmarks = new ArrayList<>();
        String sql = "SELECT user_id, article_id, created_at FROM bookmarks WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Bookmark bookmark = new Bookmark();
                    bookmark.setUserId(rs.getInt("user_id"));
                    bookmark.setArticleId(rs.getInt("article_id"));
                    bookmark.setCreatedAt(rs.getTimestamp("created_at"));
                    bookmarks.add(bookmark);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookmarks;
    }

    /**
     * Retrieves all bookmarks for a specific article
     *
     * @param articleId The article ID
     * @return List of bookmarks for the article
     */
    public List<Bookmark> getBookmarksByArticleId(int articleId) {
        List<Bookmark> bookmarks = new ArrayList<>();
        String sql = "SELECT user_id, article_id, created_at FROM bookmarks WHERE article_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Bookmark bookmark = new Bookmark();
                    bookmark.setUserId(rs.getInt("user_id"));
                    bookmark.setArticleId(rs.getInt("article_id"));
                    bookmark.setCreatedAt(rs.getTimestamp("created_at"));
                    bookmarks.add(bookmark);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookmarks;
    }

    /**
     * Gets the total count of bookmarks for a specific article
     *
     * @param articleId The article ID
     * @return The number of bookmarks for the article
     */
    public int getBookmarkCount(int articleId) {
        String sql = "SELECT COUNT(*) FROM bookmarks WHERE article_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);

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
     * Retrieves all bookmarks from the database
     *
     * @return List of all bookmarks
     */
    public List<Bookmark> getAllBookmarks() {
        List<Bookmark> bookmarks = new ArrayList<>();
        String sql = "SELECT user_id, article_id, created_at FROM bookmarks ORDER BY created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Bookmark bookmark = new Bookmark();
                bookmark.setUserId(rs.getInt("user_id"));
                bookmark.setArticleId(rs.getInt("article_id"));
                bookmark.setCreatedAt(rs.getTimestamp("created_at"));
                bookmarks.add(bookmark);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookmarks;
    }

    /**
     * Removes all bookmarks for a specific user
     *
     * @param userId The user ID
     * @return true if bookmarks were removed successfully, false otherwise
     */
    public boolean removeAllBookmarksByUserId(int userId) {
        String sql = "DELETE FROM bookmarks WHERE user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected >= 0; // Returns true even if no rows were deleted

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Removes all bookmarks for a specific article
     *
     * @param articleId The article ID
     * @return true if bookmarks were removed successfully, false otherwise
     */
    public boolean removeAllBookmarksByArticleId(int articleId) {
        String sql = "DELETE FROM bookmarks WHERE article_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, articleId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected >= 0; // Returns true even if no rows were deleted

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
