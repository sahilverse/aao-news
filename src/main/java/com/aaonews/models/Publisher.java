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


    public boolean isVerified() {
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
}
