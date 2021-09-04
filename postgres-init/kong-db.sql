-- Keycloak and kong using the same database server.
CREATE DATABASE kong;
GRANT ALL PRIVILEGES ON DATABASE kong TO postgres;