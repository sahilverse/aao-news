-- Database seeding script for initializing the database with default values
-- Database ma INITIAL VALUES LOAD GARNA YO FILE EXECUTE GARNEY

-- Truncate existing tables to avoid duplicates
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE roles;
TRUNCATE TABLE categories;
TRUNCATE TABLE article_statuses;
SET FOREIGN_KEY_CHECKS = 1;


-- Insert into the 'Roles' table
INSERT INTO roles (name, description)
VALUES ('user', 'Regular user with basic privileges'),
       ('publisher', 'Content creator with article management privileges'),
       ('admin', 'Administrator with full system access and management privileges');


-- Insert into the 'Categories' table
INSERT INTO categories (name, slug, description)
VALUES ('Technology', 'technology', 'Technology news and updates'),
       ('Business', 'business', 'Business and economic news'),
       ('Health', 'health', 'Health and wellness information'),
       ('Sports', 'sports', 'Sports news and updates'),
       ('Culture', 'culture', 'Cultural news and events'),
       ('Politics', 'politics', 'Political news and analysis'),
       ('Science', 'science', 'Scientific discoveries and research'),
       ('Entertainment', 'entertainment', 'Entertainment news and reviews');

-- Insert into the Article Status Table
INSERT INTO article_statuses (name, description)
VALUES ('draft', 'Article is saved as a draft'),
       ('pending_review', 'Article is submitted for review'),
       ('published', 'Article is published and visible to users'),
       ('rejected', 'Article was rejected during review'),
       ('archived', 'Article is archived and no longer visible');

