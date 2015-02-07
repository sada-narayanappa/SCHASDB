drop table us_zip;
create table us_zip (
		 code		 		varchar,
		 city				varchar,
		 state	 		varchar,
		 country	 		varchar,
		 lat				float8,
		 lon				float8,
		 timezone		varchar,
		 dst				varchar
);
COPY us_zip FROM '/tmp/us_zip.csv' DELIMITER ',' CSV HEADER;

SELECT AddGeometryColumn('', 'us_zip',  'geom', 4326, 'POINT',2);
UPDATE us_zip 
   SET geom = ST_Transform(
      ST_GeomFromText('POINT(' || lon || ' ' || lat || ')',4326), 4326);

CREATE INDEX idx_us_zip_geom  ON us_zip USING gist(geom);
vacuum analyze us_zip;

\q

