package com.aaonews.models;

import java.sql.Timestamp;


/**
 * PublisherInfo model class.
 * This class represents the information of a publisher in the system.
 */

public class PublisherInfo {
    private int publisherId;
    private boolean isIndividual;
    private boolean isVerified;
    private Timestamp verificationDate;

    public PublisherInfo() {}

    public PublisherInfo(int publisherId, boolean isIndividual, boolean isVerified, Timestamp verificationDate) {
        this.publisherId = publisherId;
        this.isIndividual = isIndividual;
        this.isVerified = isVerified;
        this.verificationDate = verificationDate;
    }

    public int getPublisherId() {
        return publisherId;
    }

    public void setPublisherId(int publisherId) {
        this.publisherId = publisherId;
    }

    public boolean isIndividual() {
        return isIndividual;
    }

    public void setIndividual(boolean individual) {
        isIndividual = individual;
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
