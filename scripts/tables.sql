--
-- RUN as
-- psql -h localhost -U postgres  -d SCHASDB -f tables.sql
--

CREATE TABLE env
(
    time TIMESTAMP NOT NULL,
    reported_userid INT NOT NULL,
    version VARCHAR(10) NOT NULL,
    lat NUMERIC(10) NOT NULL,
    lon NUMERIC(10) NOT NULL,
    velocity NUMERIC(10) NOT NULL,
    temperature NUMERIC(10) NOT NULL,
    humidity NUMERIC(10) NOT NULL,
    "03" NUMERIC(10) NOT NULL,
    n02 NUMERIC(10) NOT NULL,
    values VARCHAR(512) NOT NULL,
    pk_user INT PRIMARY KEY NOT NULL
);
CREATE TABLE health
(
    time TIMESTAMP NOT NULL,
    reported_userid INT NOT NULL,
    version VARCHAR(10) NOT NULL,
    lat NUMERIC(10) NOT NULL,
    lon NUMERIC(10) NOT NULL,
    velocity NUMERIC(10) NOT NULL,
    htype NUMERIC(10) NOT NULL,
    values VARCHAR(512) NOT NULL,
    pk_user INT PRIMARY KEY NOT NULL
);
CREATE UNIQUE INDEX "unique_reported_userId" ON env (reported_userid);
CREATE UNIQUE INDEX unique_reported_userid ON health (reported_userid);

CREATE TABLE "user"
(
    userid serial				PRIMARY KEY,,
    fname       VARCHAR(50)     ,
    lname       VARCHAR(50)     ,
    cname       VARCHAR(50)     ,
    address     VArCHAR(128)    ,
    cellphone   VARCHAR(15) ,
    mobileid    VARCHAR(32) ,
    homephone   VARCHAR(15) ,
    passwd      VARCHAR(128) ,
);
CREATE UNIQUE INDEX unique_userid ON "user" (userid);

-- Enable PostGIS (includes raster)
-- CREATE EXTENSION postgis;

