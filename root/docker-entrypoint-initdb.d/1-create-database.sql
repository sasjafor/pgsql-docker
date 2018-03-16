-- Create mail user and db
\set mailuser_pw `echo "$POSTGRES_PASSWORD"`
CREATE USER mailuser WITH PASSWORD :'mailuser_pw';
CREATE DATABASE mailserver;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO mailuser;

-- Connect to database
\connect mailserver

-- Create domains table
CREATE TABLE virtual_domains (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL
);

-- Create table for email users
CREATE TABLE virtual_users (
	id SERIAL PRIMARY KEY,
	domain_id SERIAL NOT NULL,
	password VARCHAR(106) NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
	FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
);

-- Create table for aliases
CREATE TABLE virtual_aliases (
	id SERIAL PRIMARY KEY,
	domain_id SERIAL NOT NULL,
	source VARCHAR(100) NOT NULL,
	destination VARCHAR(100) NOT NULL,
	FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
);

-- Insert domain
\set hostname `echo "$SERVER_HOSTNAME"`
INSERT INTO virtual_domains 
	(id, name)
VALUES
	(1, :'hostname');

-- Create crypto extension
CREATE EXTENSION pgcrypto;

-- Insert main users
\set webmaster_user 'webmaster@' :hostname
\set webmaster_pw `echo "$WEBMASTER_PASSWORD"`
\set mailman_user 'mailman@' :hostname
\set mailman_pw `echo "$MAILMAN_PASSWORD"`
\set main_user `echo "$MAIN_ACCOUNT_USERNAME"` '@' :hostname
\set main_user_pw `echo "$MAIN_ACCOUNT_PASSWORD"`
INSERT INTO virtual_users
	(id, domain_id, password, email)
VALUES
	(1, 1, crypt(:'main_user_pw', gen_salt('bf', 10)), :'main_user'),
	(2, 1, crypt(:'webmaster_pw', gen_salt('bf', 10)), :'webmaster_user'),
	(3, 1, crypt(:'mailman_pw', gen_salt('bf', 10)), :'mailman_user');

-- TEST PASSWORD
-- SELECT * FROM virtual_users WHERE password = crypt(:'main_user_pw', password);
