-- Create mail user and db
CREATE USER mailuser;
CREATE DATABASE mailserver;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO mailuser;

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