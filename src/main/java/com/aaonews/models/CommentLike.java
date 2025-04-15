package com.aaonews.models;

import java.sql.Timestamp;

public class CommentLike {
    private int commentId;
    private int userId;
    private Timestamp createdAt;

    public CommentLike(int commentId, int userId, Timestamp createdAt) {
        this(commentId, userId);
        this.createdAt = createdAt;
    }

    public CommentLike(int commentId, int userId) {
        this.commentId = commentId;
        this.userId = userId;
    }

    public int getCommentId() {
        return commentId;
    }

    public void setCommentId(int commentId) {
        this.commentId = commentId;
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
