-- Database seeding script for initializing the database with default values
-- Database ma INITIAL VALUES LOAD GARNA YO FILE EXECUTE GARNEY

-- Insert into the 'Roles' table
INSERT INTO roles (name, description)
VALUES ('user', 'Regular user with basic privileges'),
       ('publisher', 'Content creator with article management privileges'),
       ('admin', 'Administrator with full system access and management privileges');