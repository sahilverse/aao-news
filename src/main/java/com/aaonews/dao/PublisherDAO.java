package com.aaonews.dao;

import com.aaonews.models.Publisher;
import com.aaonews.models.User;
import com.aaonews.utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Publisher-related database operations
 */
public class PublisherDAO {

    /**
     * Creates a new publisher record in the database
     *
     * @param publisher The publisher to create
     * @return true if successful, false otherwise
     */

    public boolean createPublisher(Publisher publisher) {
        String sql = "INSERT INTO publisher (publisher_id) " +
                "VALUES (?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, publisher.getPublisherId());


            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gets a publisher by their ID
     *
     * @param publisherId The publisher ID to look up
     * @return The publisher, or null if not found
     */
    public Publisher getPublisherById(int publisherId) {
        String sql = "SELECT p.publisher_id, p.is_verified, p.verification_date, u.full_name, u.email " +
                "FROM publisher p " +
                "JOIN users u ON p.publisher_id = u.id " +
                "WHERE p.publisher_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, publisherId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Publisher publisher = new Publisher(
                            rs.getInt("publisher_id"),
                            rs.getBoolean("is_verified"),
                            rs.getTimestamp("verification_date")
                    );

                    // Set additional fields
                    publisher.setFullName(rs.getString("full_name"));
                    publisher.setEmail(rs.getString("email"));

                    return publisher;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Gets all publishers
     *
     * @return List of all publishers
     */
    public List<Publisher> getAllPublishers() {
        List<Publisher> publishers = new ArrayList<>();
        String sql = "SELECT p.publisher_id, p.is_verified, p.verification_date, u.full_name, u.email " +
                "FROM publisher p " +
                "JOIN users u ON p.publisher_id = u.id";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Publisher publisher = new Publisher(
                        rs.getInt("publisher_id"),
                        rs.getBoolean("is_verified"),
                        rs.getTimestamp("verification_date")
                );

                // Set additional fields
                publisher.setFullName(rs.getString("full_name"));
                publisher.setEmail(rs.getString("email"));

                publishers.add(publisher);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return publishers;
    }

    /**
     * Gets all unverified publishers
     *
     * @return List of unverified publishers
     */
    public List<Publisher> getUnverifiedPublishers() {
        List<Publisher> publishers = new ArrayList<>();
        String sql = "SELECT p.publisher_id, p.is_verified, p.verification_date, u.full_name, u.email " +
                "FROM publisher p " +
                "JOIN users u ON p.publisher_id = u.id " +
                "WHERE p.is_verified = false";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Publisher publisher = new Publisher(
                        rs.getInt("publisher_id"),
                        rs.getBoolean("is_verified"),
                        rs.getTimestamp("verification_date")
                );

                // Set additional fields
                publisher.setFullName(rs.getString("full_name"));
                publisher.setEmail(rs.getString("email"));

                publishers.add(publisher);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return publishers;
    }

    /**
     * Checks if a publisher is verified
     *
     * @param publisherId The publisher ID to check
     * @return true if verified, false otherwise
     */
    public boolean isPublisherVerified(int publisherId) {
        String sql = "SELECT is_verified FROM publisher WHERE publisher_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, publisherId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBoolean("is_verified");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Updates the verification status of a publisher
     *
     * @param publisherId The publisher ID to update
     * @param verified    The new verification status
     * @return true if successful, false otherwise
     */
    public boolean updateVerificationStatus(int publisherId, boolean verified) {
        String sql = "UPDATE publisher SET is_verified = ?, verification_date = ? WHERE publisher_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, verified);

            if (verified) {
                stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            } else {
                stmt.setNull(2, Types.TIMESTAMP);
            }

            stmt.setInt(3, publisherId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Deletes a publisher
     *
     * @param publisherId The publisher ID to delete
     * @return true if successful, false otherwise
     */
    public boolean deletePublisher(int publisherId) {
        String sql = "DELETE FROM publisher WHERE publisher_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, publisherId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Creates a publisher with user information
     *
     * @param user The user to create a publisher for
     * @return true if successful, false otherwise
     */
    public boolean createPublisherFromUser(User user) {
        Publisher publisher = new Publisher(user.getId());
        publisher.setFullName(user.getFullName());
        publisher.setEmail(user.getEmail());
        return createPublisher(publisher);
    }

    public int getAllVerifiedPublishersCount() throws SQLException {
        String sql = "SELECT count(*) FROM publisher";
        try (Connection conn = DatabaseUtil.getConnection();) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    return 0;
                }
            } catch (Exception e) {
                throw new SQLException(e);
            }

        }


    }
}
