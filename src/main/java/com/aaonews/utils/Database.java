package com.aaonews.utils;

import io.github.cdimascio.dotenv.Dotenv;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/* * Database.java
 * This class is responsible for establishing a connection to the database.
 * It uses the Dotenv library to load environment variables from a .env file.
 * The class provides a method to get a connection to the database.
 */

public class Database {

    private static final Dotenv dotenv = Dotenv.load();
    private static final String HOST = dotenv.get("DB_HOST");
    private static final String PORT = dotenv.get("DB_PORT");
    private static final String DB_NAME = dotenv.get("DB_NAME");
    private static final String USERNAME = dotenv.get("DB_USER");
    private static final String PASSWORD = dotenv.get("DB_PASSWORD");
    private static final String JDBC_URL = String.format(
            "jdbc:mysql://%s:%s/%s??sslmode=require",
            HOST, PORT, DB_NAME);

    /**
     * Gets a connection to the MySQL database.
     *
     * @return Connection object
     * @throws SQLException           if a database access error occurs
     * @throws ClassNotFoundException if the JDBC driver is not found
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {

        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(JDBC_URL, USERNAME, PASSWORD);
    }
}
