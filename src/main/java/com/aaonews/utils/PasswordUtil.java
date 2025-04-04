package com.aaonews.utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    /**
     * Hashes a password using bcrypt.
     *
     * @param password the raw password
     * @return the hashed password
     */

    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(10));
    }

    /**
     * Compares a raw password with the hashed password.
     *
     * @param rawPassword the raw password
     * @param storedHash the stored bcrypt hashed password
     * @return true if the password matches, false otherwise
     */
    public static boolean comparePassword(String rawPassword, String storedHash) {
        return BCrypt.checkpw(rawPassword, storedHash);
    }

}
