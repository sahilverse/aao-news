package com.aaonews.models;

public class PublisherIndividualInfo {
    private int publisherId;
    private String nationalIdType;
    private String nationalIdNo;

    public PublisherIndividualInfo(int publisherId, String nationalIdType, String nationalIdNo) {
        this.publisherId = publisherId;
        this.nationalIdType = nationalIdType;
        this.nationalIdNo = nationalIdNo;
    }

    public int getPublisherId() {
        return publisherId;
    }

    public void setPublisherId(int publisherId) {
        this.publisherId = publisherId;
    }

    public String getNationalIdType() {
        return nationalIdType;
    }

    public void setNationalIdType(String nationalIdType) {
        this.nationalIdType = nationalIdType;
    }

    public String getNationalIdNo() {
        return nationalIdNo;
    }

    public void setNationalIdNo(String nationalIdNo) {
        this.nationalIdNo = nationalIdNo;
    }
}
