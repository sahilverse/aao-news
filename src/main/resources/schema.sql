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
    id             INT AUTO_INCREMENT PRIMARY KEY,
    email          VARCHAR(255) NOT NULL UNIQUE,
    username       VARCHAR(50)  NOT NULL UNIQUE,
    password       VARCHAR(255) NOT NULL,
    full_name      VARCHAR(100) NOT NULL,
    role_id        INT          NOT NULL,
    phone_number   VARCHAR(15)  NOT NULL UNIQUE,
    email_verified BOOLEAN   DEFAULT FALSE,
    profile_image  MEDIUMBLOB, -- Profile image stored as a BLOB max size 16MB
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles (id)
) COMMENT ='Stores user information and credentials';



-- Publisher Related Tables ---------------------------------------------

-- Publishers Information Table
CREATE TABLE IF NOT EXISTS publisher_info
(
    publisher_id      INT PRIMARY KEY,
    is_individual     BOOLEAN DEFAULT TRUE,
    is_verified       BOOLEAN DEFAULT FALSE,
    verification_date TIMESTAMP NULL,
    FOREIGN KEY (publisher_id) REFERENCES users (id) ON DELETE CASCADE
) COMMENT = 'Stores core info and verification status for all publishers (individuals or organizations)';

-- Publisher Individual Table
CREATE TABLE IF NOT EXISTS individual_info
(
    publisher_id     INT PRIMARY KEY,
    national_id_type VARCHAR(50) NOT NULL,
    national_id_no   VARCHAR(50) NOT NULL,
    FOREIGN KEY (publisher_id) REFERENCES publisher_info (publisher_id) ON DELETE CASCADE
) COMMENT = 'Stores identity verification info for individual publishers';


-- Publisher Organization Table
CREATE TABLE IF NOT EXISTS organization_info
(
    publisher_id         INT PRIMARY KEY,
    organization_name    VARCHAR(100) NOT NULL,
    organization_website VARCHAR(255),
    pan_number           VARCHAR(20)  NOT NULL,
    FOREIGN KEY (publisher_id) REFERENCES publisher_info (publisher_id) ON DELETE CASCADE
) COMMENT = 'Stores organization-specific information for publishers who are organizations';

-- END Publisher Related Tables ---------------------------------------------






