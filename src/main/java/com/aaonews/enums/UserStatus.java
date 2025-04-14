package com.aaonews.enums;

/**
 * UserStatus enum represents the status of a user in the system.
 * Each status has a unique ID associated with it.
 */

public enum UserStatus {
    ACTIVE(1),
    DEACTIVATED(2),
    PENDING(3),
    SUSPENDED(4),
    BANNED(5);

    private final int id;

    UserStatus(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public static UserStatus fromId(int id) {
        for (UserStatus status : values()) {
            if (status.id == id) {
                return status;
            }
        }
        throw new IllegalArgumentException("Invalid UserStatus ID: " + id);
    }
}
