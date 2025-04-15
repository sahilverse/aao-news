package com.aaonews.models;

import java.sql.Timestamp;

public class Article {
    private int id;
    private String title;
    private String slug;
    private String content;
    private String summary;
    private byte[] featureImage;
    private int authorId;
    private int categoryId;
    private int statusID;
    private boolean isFeatured;
    private int viewCount;
    private Timestamp publishedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    private Article() {
    }

    public Article(int id, String title, String slug, String content, String summary, byte[] featureImage,
                   int authorId, int categoryId, int statusID, boolean isFeatured, int viewCount,
                   Timestamp publishedAt, Timestamp createdAt, Timestamp updatedAt) {

        this(title, slug, content, summary, featureImage, authorId, categoryId, statusID,
                isFeatured, publishedAt);

        this.id = id;
        this.viewCount = viewCount;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Article(String title, String slug, String content, String summary, byte[] featureImage,
                   int authorId, int categoryId, int statusID, boolean isFeatured,
                   Timestamp publishedAt) {
        this.title = title;
        this.slug = slug;
        this.content = content;
        this.summary = summary;
        this.featureImage = featureImage;
        this.authorId = authorId;
        this.categoryId = categoryId;
        this.statusID = statusID;
        this.isFeatured = isFeatured;
        this.publishedAt = publishedAt;

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

    public int getStatusID() {
        return statusID;
    }

    public void setStatusID(int statusID) {
        this.statusID = statusID;
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
