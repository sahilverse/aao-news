package com.aaonews.dto;

import com.aaonews.models.Comment;
import com.aaonews.models.User;

/**
 * Data Transfer Object that combines a Comment with its associated User.
 * This is used to transfer comment data along with user information.
 */

public class CommentWithUser {
    private Comment comment;
    private User user;

    public CommentWithUser() {
        // Default constructor
    }

    public CommentWithUser(Comment comment, User user) {
        this.comment = comment;
        this.user = user;
    }

    // Getters and setters
    public Comment getComment() {
        return comment;
    }

    public User getUser() {
        return user;
    }

    public void setComment(Comment comment) {
        this.comment = comment;
    }

    public void setUser(User user) {
        this.user = user;
    }
}

