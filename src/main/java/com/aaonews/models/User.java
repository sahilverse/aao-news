package com.aaonews.models;

import com.aaonews.enums.Role;

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
    private String phoneNumber;
    private byte[] profileImage;

    public User() {
    }

    public User(int id, String email, String username, String password, String fullName,
                Role role, String phoneNumber,
                byte[] profileImage) {
        this(email, username, password, fullName, role, phoneNumber, profileImage);
        this.id = id;
    }

    public User(String email, String username, String password, String fullName, Role role, String phoneNumber, byte[] profileImage) {
        this.email = email;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.role = role;
        this.phoneNumber = phoneNumber;
        this.profileImage = profileImage;
    }

    // Getters and setters...

    public int getId() {
        return id;
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



    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }


    public byte[] getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(byte[] profileImage) {
        this.profileImage = profileImage;
    }
}
