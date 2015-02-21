--
-- RUN as
-- psql -h localhost -U postgres  -d SCHASDB -f tables.sql
--
DROP TABLE users;

CREATE TABLE IF NOT EXISTS users
(
    userid serial		PRIMARY KEY     ,
    fname           VARCHAR(32)     ,
    lname           VARCHAR(32)     ,
    cname           VARCHAR(32)     ,
    address         VARCHAR(128)    ,
    cellphone       VARCHAR(16)     ,
    mobileid        VARCHAR(32)     ,
    homephone       VARCHAR(16)     ,
    passwd          VARCHAR(128)    ,
    home_location   VARCHAR(128)
);
