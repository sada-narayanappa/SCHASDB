--************************************************************
--
-- You must RUN this
-- psql -h 10.0.0.3 -U postgres  -d SCHASDB -f loc.sql
-- psql -h localhost -U postgres  -d SCHASDB -f loc.sql
--
-- See: http://postgresguide.com/sexy/hstore.html for hstore usage

--drop table loc;

CREATE TABLE IF NOT EXISTS loc
(
		id								serial				PRIMARY KEY,
    stored_at  				TIMESTAMP 		default (now() at time zone 'utc'),
    measured_at 			TIMESTAMP 		default (now() at time zone 'utc'),
    api_key           VARCHAR(16)   NOT NULL,
    version           VARCHAR(16)   ,
    record_type       VARCHAR(8)    ,
    session_num       VARCHAR(8)    ,
    mobile_id 				VARCHAR(32) 	,
    user_id						VARCHAR(32)   ,
    caller_ip         VARCHAR (32)  ,
    lat 							float,
    lon 							float,
    accuracy          float,
    speed		 					float,
    bearing 					float,
    alt 	 						float,
    device_temp       VARCHAR(16),
    device_pressure   VARCHAR(16),
    device_humidity   VARCHAR(16),
    device_light      VARCHAR(16),
    medication        VARCHAR(32),    --  Weather related items below
    weather_time			TIMESTAMP ,
		temperature_min 	float,
		temperature_max 	float,
    humidity 					float,
    NO2               float,
    pressure				 	float,
    wind							varchar(64),
    clouds_sky				varchar(64),
    notes	 						varchar,
    attr			 				hstore,
    the_geom					geometry,

	CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(the_geom) = 2),
  CONSTRAINT enforce_geotype_geom CHECK (geometrytype(the_geom) = 'POINT'::text OR the_geom IS NULL),
  CONSTRAINT enforce_srid_the_geom CHECK (st_srid(the_geom) = 4326)

);

CREATE INDEX loc_the_geom_gist ON loc
  USING gist
  (the_geom );

alter table loc add column location point;

update loc SET the_geom = ST_GeomFromText('POINT(' || lon || ' ' || lat || ')',4326);
update loc SET location = point(lon, lat )

/**
This has gotten little hairy. But we have one table for everything now.

Stored_at   ==>     Time at which it was recorded in our database
measured_at ==>     Time at which the recorded values are actually measured or gotten

session_num is a unique string we can create such that all the records can be grouped together
by identifying some contiguous set of records
 */
