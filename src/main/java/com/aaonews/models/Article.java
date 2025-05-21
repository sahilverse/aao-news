package com.aaonews.models;

import java.sql.Timestamp;
import com.aaonews.enums.ArticleStatus;


public class Article {
    private int id;
    private String title;
    private String slug;
    private String content;
    private String summary;
    private byte[] featureImage;
    private int authorId;
    private int categoryId;
    private ArticleStatus status;
    private String rejectionMessage;
    private boolean isFeatured;
    private int viewCount;
    private Timestamp publishedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private int commentCount;
    private int likeCount;
    private User author;

    public Article() {}


    public Article(String title, String slug, String content, String summary,
                   int authorId, int categoryId, ArticleStatus status) {
        this.title = title;
        this.slug = slug;
        this.content = content;
        this.summary = summary;
        this.authorId = authorId;
        this.categoryId = categoryId;
        this.status = status;
    }

    public void setAuthor(User author) {
        this.author = author;
    }

    public User getAuthor() {
        return author;
    }

    public int getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }
    public int getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getId() {
        return id;
    }


    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public byte[] getFeatureImage() {
        return featureImage;
    }

    public void setFeatureImage(byte[] featureImage) {
        this.featureImage = featureImage;
    }

    public int getAuthorId() {
        return authorId;
    }

    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public ArticleStatus getStatus() {
        return status;
    }

    public void setStatus(ArticleStatus status) {
        this.status = status;
    }

    public boolean isFeatured() {
        return isFeatured;
    }

    public void setFeatured(boolean featured) {
        isFeatured = featured;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }

    public String getRejectionMessage() {
        return rejectionMessage;
    }

    public void setRejectionMessage(String rejectionMessage) {
        this.rejectionMessage = rejectionMessage;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Timestamp getPublishedAt() {
        return publishedAt;
    }

    public void setPublishedAt(Timestamp publishedAt) {
        this.publishedAt = publishedAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

}
