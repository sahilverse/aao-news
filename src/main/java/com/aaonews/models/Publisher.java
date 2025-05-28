package com.aaonews.models;

import java.sql.Timestamp;


/**
 * PublisherInfo model class.
 * This class represents the information of a publisher in the system.
 */

public class Publisher {
    private int publisherId;
    private boolean isVerified;
    private Timestamp verificationDate;


//    added by -raghav dahal
    private String publisherName;
    private String publisherEmail;
    private int articleCount;


    public int getArticleCount() {
        return articleCount;
    }
    public void setArticleCount(int articleCount) {
        this.articleCount = articleCount;
    }

    public String getEmail() {
        return publisherEmail;
    }

    public void setEmail(String email) {
        this.publisherEmail = email;
    }
    public String getFullName() {
        return publisherName;
    }

    public void setFullName(String fullName) {
        this.publisherName = fullName;
    }
// end
    public Publisher() {}

    public Publisher(int publisherId, boolean isVerified, Timestamp verificationDate) {
        this.publisherId = publisherId;
        this.isVerified = isVerified;
        this.verificationDate = verificationDate;
    }

    public Publisher(boolean isVerified, Timestamp verificationDate) {

        this.isVerified = isVerified;
        this.verificationDate = verificationDate;
    }
    public Publisher(int publisherId) {
        this.publisherId = publisherId;
        this.isVerified = false;
        this.verificationDate = null;
    }

    public int getPublisherId() {
        return publisherId;
    }

    public void setPublisherId(int publisherId) {
        this.publisherId = publisherId;
    }

    public boolean getIsVerified() {
        return isVerified;
    }

    public void setVerified(boolean verified) {
        isVerified = verified;
    }

    public Timestamp getVerificationDate() {
        return verificationDate;
    }

    public void setVerificationDate(Timestamp verificationDate) {
        this.verificationDate = verificationDate;
    }

    public String getPublisherEmail() {
        return publisherEmail;
    }

    public void setPublisherEmail(String publisherEmail) {
        this.publisherEmail = publisherEmail;
    }

    public String getPublisherName() {
        return publisherName;
    }

    public void setPublisherName(String publisherName) {
        this.publisherName = publisherName;
    }

    @Override
    public String toString() {
        return "Publisher{id=" + this.getPublisherId() + ", isVerified=" + this.getIsVerified() + "}";
    }
}
