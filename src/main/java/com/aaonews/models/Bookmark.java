package com.aaonews.models;


import java.sql.Timestamp;

/**
 * Bookmark model class representing the bookmarks table
 */
public class Bookmark {
    private int userId;
    private int articleId;
    private Timestamp createdAt;

    // Default constructor
    public Bookmark() {}

    // Constructor with userId and articleId (createdAt will be set by database)
    public Bookmark(int userId, int articleId) {
        this.userId = userId;
        this.articleId = articleId;
    }

    // Full constructor
    public Bookmark(int userId, int articleId, Timestamp createdAt) {
        this.userId = userId;
        this.articleId = articleId;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getArticleId() {
        return articleId;
    }

    public void setArticleId(int articleId) {
        this.articleId = articleId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }


    @Override
    public String toString() {
        return "Bookmark{" +
                "userId=" + userId +
                ", articleId=" + articleId +
                ", createdAt=" + createdAt +
                '}';
    }
}
