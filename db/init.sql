-- Creates the destinations table if it doesn't already exist.
-- This file runs automatically when the PostgreSQL container starts for the first time.

CREATE TABLE IF NOT EXISTS destinations (
    id        SERIAL PRIMARY KEY,
    country   VARCHAR(255) NOT NULL,
    capital   VARCHAR(255),
    population BIGINT,
    region    VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);
