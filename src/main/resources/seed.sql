-- Database seeding script for initializing the database with default values
-- Database ma INITIAL VALUES LOAD GARNA YO FILE EXECUTE GARNEY

-- Truncate existing tables to avoid duplicates
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE roles;
TRUNCATE TABLE categories;
TRUNCATE TABLE article_statuses;
TRUNCATE TABLE system_settings;
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

-- Insert into the System Settings Table
INSERT INTO system_settings (setting_key, setting_value, setting_group, description)
VALUES ('site_name', 'AAOnews', 'general', 'The name of the website'),
       ('site_description', 'Your trusted source for the latest news', 'general', 'Short description of the website'),
       ('contact_email', 'info@aaonews.com', 'contact', 'Primary contact email address'),
       ('articles_per_page', '10', 'content', 'Number of articles to display per page'),
       ('allow_comments', 'true', 'content', 'Whether to allow comments on articles'),
       ('require_comment_approval', 'false', 'content', 'Whether comments require approval before being displayed'),
       ('allow_user_registration', 'true', 'users', 'Whether to allow new user registrations'),
       ('default_user_role', '1', 'users', 'Default role ID for new users'),
       ('maintenance_mode', 'false', 'system', 'Whether the site is in maintenance mode'),
       ('maintenance_message', 'We are currently performing scheduled maintenance. Please check back soon.', 'system',
        'Message to display during maintenance mode');