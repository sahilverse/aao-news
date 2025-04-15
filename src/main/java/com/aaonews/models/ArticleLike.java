package com.aaonews.models;

import java.sql.Timestamp;

public class ArticleLike {
    private int id;
    private int articleId;
    private int userId;
    private Timestamp createdAt;

    public ArticleLike() {}

    public ArticleLike(int id, int articleId, int userId, Timestamp createdAt) {
        this(articleId, userId);
        this.id = id;
        this.createdAt = createdAt;
    }

    public ArticleLike(int articleId, int userId) {
        this.articleId = articleId;
        this.userId = userId;
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

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
