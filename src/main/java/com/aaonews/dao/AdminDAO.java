package com.aaonews.dao;

import com.aaonews.enums.Role;
import com.aaonews.models.Publisher;
import com.aaonews.models.User;
import com.aaonews.utils.DatabaseUtil;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, email, password, full_name, role_id, profile_image FROM users";

        try (
                Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();
        ) {
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }

    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String email = rs.getString("email");
        String password = rs.getString("password");
        String fullName = rs.getString("full_name");
        Role role = Role.fromId(rs.getInt("role_id"));
        byte[] profileImage = rs.getBytes("profile_image");

        return new User(id, email, password, fullName, role, profileImage);
    }



//    publisher pending
    public List<Publisher> getPendingPublishers() {
        List<Publisher> publishersWithUsers = new ArrayList<>();
        String query = "SELECT u.email, u.full_name, p.is_verified, p.verification_date, p.publisher_id " +
                "FROM publisher p " +
                "JOIN users u ON p.publisher_id = u.id " +
                "WHERE p.is_verified = false";

        try (   Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            System.out.println("this is rs"+rs);
            while (rs.next()) {
                Publisher publisherWithUser = new Publisher();
                publisherWithUser.setPublisherId(rs.getInt("publisher_id"));
                publisherWithUser.setVerified(rs.getBoolean("is_verified"));
                publisherWithUser.setVerificationDate(rs.getTimestamp("verification_date"));
                publisherWithUser.setEmail(rs.getString("email"));
                publisherWithUser.setFullName(rs.getString("full_name"));

                publishersWithUsers.add(publisherWithUser);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error fetching pending publishers", e);
        }

        return publishersWithUsers;
    }


    public boolean approvePublisher(int publisherId) {
        String query = "UPDATE publisher SET is_verified = true, verification_date = CURRENT_TIMESTAMP WHERE publisher_id = ?";
        try (
                Connection conn= DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, publisherId);
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Reject Publisher (Set is_verified = false)
    public boolean rejectPublisher(int publisherId) {
        String query = "UPDATE publisher SET is_verified = false, verification_date = NULL WHERE publisher_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, publisherId);
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

    }


//    articles

//    public List<Article> getPendingArticles() {
//        List<Article> articles = new ArrayList<>();
//        String query = "SELECT * FROM articles WHERE status = 'PENDING'";
//
//        try (PreparedStatement stmt = connection.prepareStatement(query);
//             ResultSet rs = stmt.executeQuery()) {
//            while (rs.next()) {
//                Article article = new Article();
//                article.setId(rs.getInt("id"));
//                article.setTitle(rs.getString("title"));
//                article.setStatus(rs.getString("status"));
//                articles.add(article);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        return articles;
//    }
//
//    // Approve article
//    public boolean approveArticle(int articleId) {
//        String query = "UPDATE articles SET status = 'APPROVED' WHERE id = ?";
//        try (
//                Connection conn = DatabaseUtil.getConnection();
//                PreparedStatement stmt = conn.prepareStatement(query)) {
//            stmt.setInt(1, articleId);
//            int rowsUpdated = stmt.executeUpdate();
//            return rowsUpdated > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//
//    // Reject article
//    public boolean rejectArticle(int articleId) {
//        String query = "UPDATE articles SET status = 'REJECTED' WHERE id = ?";
//        try (
//                Connection conn = DatabaseUtil.getConnection();
//                PreparedStatement stmt = conn.prepareStatement(query)) {
//            stmt.setInt(1, articleId);
//            int rowsUpdated = stmt.executeUpdate();
//            return rowsUpdated > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        }
//    }


    public static void main(String[] args){
        AdminDAO adminDAO = new AdminDAO();
        List<Publisher> publishers = adminDAO.getPendingPublishers();
        for (Publisher publisher : publishers) {
            System.out.println(publisher.getFullName());
        }
    }
}
