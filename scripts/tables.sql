--
--
--
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
CREATE TABLE "user"
(
    userid INT NOT NULL,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    address BIGINT NOT NULL,
    cellphone VARCHAR(15) NOT NULL,
    mobileid VARCHAR(15) NOT NULL,
    homephone VARCHAR(15) NOT NULL,
    passwd VARCHAR(128) NOT NULL,
    pk_user INT PRIMARY KEY NOT NULL
);
CREATE UNIQUE INDEX "unique_reported_userId" ON env (reported_userid);
CREATE UNIQUE INDEX unique_reported_userid ON health (reported_userid);
CREATE UNIQUE INDEX unique_userid ON "user" (userid);

-- Enable PostGIS (includes raster)
-- CREATE EXTENSION postgis;

