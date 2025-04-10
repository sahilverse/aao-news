package com.aaonews.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.io.InputStream;

/**
 * DatabaseUtil.java
 * This class is responsible for establishing a connection to the database.
 * It uses a db.properties file to load configuration.
 * The class provides a method to get a connection to the database.
 */
public class DatabaseUtil {

    private static String jdbcUrl;
    private static String username;
    private static String password;

    static {
        try {
            // Load properties from db.properties
            Properties props = new Properties();
            InputStream input = DatabaseUtil.class.getClassLoader().getResourceAsStream("db.properties");
            props.load(input);

            String host = props.getProperty("db.host");
            String port = props.getProperty("db.port");
            String dbName = props.getProperty("db.name");
            username = props.getProperty("db.user");
            password = props.getProperty("db.password");

            jdbcUrl = String.format("jdbc:mysql://%s:%s/%s?sslmode=require", host, port, dbName);

            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Gets a connection to the MySQL database.
     *
     * @return Connection object
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcUrl, username, password);
    }
}
