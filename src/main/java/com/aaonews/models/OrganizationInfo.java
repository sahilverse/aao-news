package com.aaonews.models;

/*
 * This class represents the organization information of a publisher.
 * It contains fields for publisher ID, organization name, website, and PAN number.
 * It includes constructors, getters, and setters for these fields.
 */
public class OrganizationInfo {
    private int publisherId;
    private String organizationName;
    private String organizationWebsite;
    private String panNumber;

    public OrganizationInfo(int publisherId, String organizationName, String organizationWebsite, String panNumber) {
        this.publisherId = publisherId;
        this.organizationName = organizationName;
        this.organizationWebsite = organizationWebsite;
        this.panNumber = panNumber;
    }

    public int getPublisherId() {
        return publisherId;
    }

    public void setPublisherId(int publisherId) {
        this.publisherId = publisherId;
    }

    public String getOrganizationName() {
        return organizationName;
    }

    public void setOrganizationName(String organizationName) {
        this.organizationName = organizationName;
    }

    public String getOrganizationWebsite() {
        return organizationWebsite;
    }

    public void setOrganizationWebsite(String organizationWebsite) {
        this.organizationWebsite = organizationWebsite;
    }

    public String getPanNumber() {
        return panNumber;
    }

    public void setPanNumber(String panNumber) {
        this.panNumber = panNumber;
    }
}
