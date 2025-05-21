package com.aaonews.models;

import com.aaonews.enums.Role;

import java.sql.Timestamp;

/**
 * User model class.
 * This class represents a user in the system.
 */
public class User {
    private int id;
    private String email;
    private String username;
    private String password;
    private String fullName;
    private Role role;
    private byte[] profileImage;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp lastLogin;



    public User() {
    }


    public User(int id, String email, String password, String fullName, Role role, byte[] profileImage) {
        this(email, password, fullName,  role, profileImage);
        this.id = id;
    }

    public User(int id, String email, String password, String fullName, Role role, byte[] profileImage, Timestamp lastLogin, Timestamp createdAt, Timestamp updatedAt) {
        this(id, email, password, fullName, role, profileImage, createdAt, updatedAt);
        this.lastLogin = lastLogin;

    }

    public User(int id, String email, String password, String fullName, Role role, byte[] profileImage, Timestamp createdAt, Timestamp updatedAt) {
        this(email, password, fullName,  role, profileImage);
        this.id = id;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }



    public User(String email,  String password, String fullName, Role role, byte[] profileImage) {
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.role = role;
        this.profileImage = profileImage;
    }

    public User(String email,  String password, String fullName, Role role) {
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.role = role;
        this.profileImage = null;
    }



    // Getters and setters...

    public int getId() {
        return id;
    }

    public Timestamp getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(Timestamp lastLogin) {
        this.lastLogin = lastLogin;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }


    public byte[] getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(byte[] profileImage) {
        this.profileImage = profileImage;
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

    public void setId(int id) {
        this.id = id;
    }
}
