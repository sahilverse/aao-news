package com.aaonews.enums;

/**
 * Role enum represents the role of a user in the system.
 * Each role has a unique ID associated with it.
 */

public enum Role {
    USER(1),
    PUBLISHER(2),
    ADMIN(3);

    private final int id;

    Role(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public static Role fromId(int id) {
        for (Role role : values()) {
            if (role.id == id) {
                return role;
            }
        }
        throw new IllegalArgumentException("Invalid Role ID: " + id);
    }
}
