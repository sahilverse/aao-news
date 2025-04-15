package com.aaonews.models;

import java.sql.Timestamp;

/**
 * Represents a comment on an article.
 */
public class Comment {
    private int id;
    private int articleId;
    private int userId;
    private int parentId;
    private String content;
    private boolean isApproved;
    private Timestamp createdAt;
    private Timestamp updatedAt;


    public Comment(int id, int articleId, int userId, int parentId, String content, boolean isApproved, Timestamp createdAt, Timestamp updatedAt) {
        this(articleId, userId, parentId, content);
        this.id = id;
        this.isApproved = isApproved;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Comment(int articleId, int userId, int parentId, String content) {
        this.articleId = articleId;
        this.userId = userId;
        this.parentId = parentId;
        this.content = content;
    }

    public int getId() {
        return id;
    }


    public int getArticleId() {
        return articleId;
    }

    public void setArticleId(int articleId) {
        this.articleId = articleId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isApproved() {
        return isApproved;
    }

    public void setApproved(boolean approved) {
        isApproved = approved;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
