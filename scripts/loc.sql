--************************************************************
--
-- You must RUN this
-- psql -h localhost -U postgres  -d SCHASDB -f tables.sql
--
-- See: http://postgresguide.com/sexy/hstore.html for hstore usage

drop table loc;

CREATE TABLE IF NOT EXISTS loc
(
		id								serial				PRIMARY KEY,
    stored_at  				TIMESTAMP 		default current_timestamp,
    measured_at 			TIMESTAMP 		default current_timestamp,
    mobile_id 				VARCHAR(32) 	,
    user_id						INTEGER ,
    lat 							float,
    lon 							float,
    the_geom					geometry,
    speed		 					float,
    bearing 					float,
    alt 	 						float,
    weather_time			TIMESTAMP ,
		temperature_min 	float,
		temperature_max 	float,
    humidity 					float,
    pressure				 	float,
    wind							varchar(64),
    clouds_sky				varchar(64),
    notes	 						varchar,
    attr			 				hstore,

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

