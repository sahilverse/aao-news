package com.aaonews.dao;

import com.aaonews.enums.Role;
import com.aaonews.models.Publisher;
import com.aaonews.models.User;
import com.aaonews.utils.DatabaseUtil;
import com.aaonews.utils.PasswordUtil;

import java.sql.*;


/**
 * Data Access Object for User-related database operations
 */
public class UserDAO {

    /**
     * Creates a new user in the database
     *
     * @param user The user to create
     * @return The ID of the newly created user, or -1 if creation failed
     */
    public int createUser(User user) {
        String sql = "INSERT INTO users (email, username, password, full_name, role_id, phone_number, profile_image) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getUsername());
            stmt.setString(3, PasswordUtil.hashPassword(user.getPassword()));
            stmt.setString(4, user.getFullName());
            stmt.setInt(5, user.getRole().getId());
            stmt.setString(6, user.getPhoneNumber());


            if (user.getProfileImage() != null) {
                stmt.setBytes(9, user.getProfileImage());
            } else {
                stmt.setNull(9, Types.BLOB);
            }

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                return -1;
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    return -1;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * Creates publisher information for a user
     *
     * @param publisher The publisher information
     * @return true if successful, false otherwise
     */
    public boolean createPublisher(Publisher publisher) {
        String sql = "INSERT INTO publisher (publisher_id, is_verified, verification_date) " +
                "VALUES (?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, publisher.getPublisherId());
            stmt.setBoolean(3, publisher.isVerified());

            if(publisher.isVerified()) {
                stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            } else {
                stmt.setNull(4, Types.TIMESTAMP);
            }

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }



    /**
     * Checks if a username already exists in the database
     *
     * @param username The username to check
     * @return true if the username exists, false otherwise
     */
    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Checks if an email already exists in the database
     *
     * @param email The email to check
     * @return true if the email exists, false otherwise
     */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Gets a user by their username
     *
     * @param username The username to look up
     * @return The user, or null if not found
     */
    public User getUserByUsername(String username) {
        String sql = "SELECT id, email, username, password, full_name, role_id, phone_number, profile_image FROM users WHERE username = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Gets a user by their email
     *
     * @param email The email to look up
     * @return The user, or null if not found
     */
    public User getUserByEmail(String email) {
        String sql = "SELECT id, email, username, password, full_name, role_id, phone_number, profile_image FROM users WHERE email = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Gets a user by their ID
     *
     * @param id The user ID to look up
     * @return The user, or null if not found
     */
    public User getUserById(int id) {
        String sql = "SELECT id, email, username, password, full_name, role_id, phone_number, profile_image FROM users WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Updates the last login timestamp for a user
     *
     * @param userId The ID of the user
     */
    public void updateLastLogin(int userId) {
        String sql = "UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            int affectedRows = stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }



    /**
     * Helper method to extract a User object from a ResultSet
     */
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String email = rs.getString("email");
        String username = rs.getString("username");
        String password = rs.getString("password");
        String fullName = rs.getString("full_name");
        Role role = Role.fromId(rs.getInt("role_id"));
        String phoneNumber = rs.getString("phone_number");
        byte[] profileImage = rs.getBytes("profile_image");

        return new User(id, email, username, password, fullName, role, phoneNumber, profileImage);
    }
}
