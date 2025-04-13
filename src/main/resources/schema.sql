-- Create a new database if it doesn't exist and set the character set and collation
CREATE DATABASE IF NOT EXISTS aaonews CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE aaonews;

-- Roles Table Definition
CREATE TABLE IF NOT EXISTS roles
(
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
) COMMENT ='Defines user roles in the system';


-- Users Table Definition
CREATE TABLE IF NOT EXISTS users
(
    user_id        INT AUTO_INCREMENT PRIMARY KEY,
    email          VARCHAR(255) NOT NULL UNIQUE,
    username       VARCHAR(50)  NOT NULL UNIQUE,
    password       VARCHAR(255) NOT NULL,
    full_name      VARCHAR(100) NOT NULL,
    role_id        INT UNSIGNED NOT NULL,
    email_verified BOOLEAN   DEFAULT FALSE,
    profile_image  MEDIUMBLOB, -- Profile image stored as a BLOB max size 16MB
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles (id)
) COMMENT ='Stores user information and credentials';



