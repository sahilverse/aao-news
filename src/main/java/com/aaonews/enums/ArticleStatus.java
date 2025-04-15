package com.aaonews.enums;

/*
 * ArticleStatus enum class.
 * This enum represents the status of an article in the system.
 */

public enum ArticleStatus {
    DRAFT(1),
    PENDING_REVIEW(2),
    PUBLISHED(3),
    REJECTED(4),
    ARCHIVED(5);

    private final int id;

    ArticleStatus(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public static ArticleStatus fromId(int id) {
        for (ArticleStatus status : values()) {
            if (status.id == id) return status;
        }
        throw new IllegalArgumentException("Invalid ArticleStatus ID: " + id);
    }
}
