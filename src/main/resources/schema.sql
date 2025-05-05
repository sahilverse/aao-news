-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS aaonews;
USE aaonews;

-- Role Definitions
CREATE TABLE IF NOT EXISTS roles
(
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
) COMMENT ='Defines user roles in the system';


-- Users table
CREATE TABLE IF NOT EXISTS users
(
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password      VARCHAR(255) NOT NULL,
    full_name     VARCHAR(100) NOT NULL,
    role_id       INT UNSIGNED NOT NULL,
    profile_image MEDIUMBLOB, -- Storing image Binary data MAX-SIZE: 16MB
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login    TIMESTAMP    NULL,
    FOREIGN KEY (role_id) REFERENCES roles (id),
    INDEX idx_users_email (email),
    INDEX idx_users_role (role_id)
) COMMENT ='Stores user account information';

-- Publisher table
CREATE TABLE IF NOT EXISTS publisher
(
    publisher_id      INT UNSIGNED PRIMARY KEY,
    is_verified       BOOLEAN DEFAULT FALSE,
    verification_date TIMESTAMP NULL,
    FOREIGN KEY (publisher_id) REFERENCES users (id) ON DELETE CASCADE
) COMMENT ='Stores core info for all publishers';

-- Categories table
CREATE TABLE IF NOT EXISTS categories
(
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE,
    slug        VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
) COMMENT ='Stores article categories';

-- Article status definitions
CREATE TABLE IF NOT EXISTS article_statuses
(
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
) COMMENT ='Defines possible article statuses';

-- Articles table
CREATE TABLE IF NOT EXISTS articles
(
    id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title             VARCHAR(255) NOT NULL,
    slug              VARCHAR(255) NOT NULL UNIQUE,
    content           LONGTEXT     NOT NULL,
    summary           TEXT,
    featured_image    MEDIUMBLOB, -- Storing image Binary data MAX-SIZE: 16MB
    author_id         INT UNSIGNED NOT NULL,
    category_id       INT UNSIGNED NOT NULL,
    status_id         INT UNSIGNED NOT NULL,
    rejection_message TEXT         NULL,
    is_featured       BOOLEAN      DEFAULT FALSE,
    view_count        INT UNSIGNED DEFAULT 0,
    published_at      TIMESTAMP    NULL,
    created_at        TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users (id),
    FOREIGN KEY (category_id) REFERENCES categories (id),
    FOREIGN KEY (status_id) REFERENCES article_statuses (id),
    INDEX idx_articles_author (author_id),
    INDEX idx_articles_category (category_id),
    INDEX idx_articles_status (status_id),
    INDEX idx_articles_published (published_at),
    CONSTRAINT check_view_count CHECK (view_count >= 0)
) COMMENT ='Stores article content';


-- Comments table
CREATE TABLE IF NOT EXISTS comments
(
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    article_id  INT UNSIGNED NOT NULL,
    user_id     INT UNSIGNED NOT NULL,
    parent_id   INT UNSIGNED NULL,
    content     TEXT         NOT NULL,
    is_approved BOOLEAN   DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (parent_id) REFERENCES comments (id) ON DELETE CASCADE,
    INDEX idx_comments_article (article_id),
    INDEX idx_comments_user (user_id),
    INDEX idx_comments_parent (parent_id)
) COMMENT ='Stores user comments on articles';

-- Comment likes table
CREATE TABLE IF NOT EXISTS comment_likes
(
    user_id    INT UNSIGNED NOT NULL,
    comment_id INT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, comment_id),
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (comment_id) REFERENCES comments (id) ON DELETE CASCADE
) COMMENT ='Tracks user likes on comments';

-- Article likes table
CREATE TABLE IF NOT EXISTS article_likes
(
    user_id    INT UNSIGNED NOT NULL,
    article_id INT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, article_id),
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (article_id) REFERENCES articles (id) ON DELETE CASCADE
) COMMENT ='Tracks user likes on articles';

-- Bookmarks table
CREATE TABLE IF NOT EXISTS bookmarks
(
    user_id    INT UNSIGNED NOT NULL,
    article_id INT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, article_id),
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (article_id) REFERENCES articles (id) ON DELETE CASCADE
) COMMENT ='Tracks user bookmarks';


-- Audit log table for tracking important system changes
CREATE TABLE IF NOT EXISTS audit_logs
(
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     INT UNSIGNED,
    action      VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50)  NOT NULL,
    entity_id   VARCHAR(50)  NOT NULL,
    details     JSON,
    ip_address  VARCHAR(45),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL,
    INDEX idx_audit_entity (entity_type, entity_id),
    INDEX idx_audit_user (user_id),
    INDEX idx_audit_action (action),
    INDEX idx_audit_created (created_at)
) COMMENT ='Tracks system changes for security and debugging';