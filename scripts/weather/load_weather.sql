drop table weather_stations;
create table weather_stations (
		 station_id		varchar,
		 state	 		varchar,
		 state_name		varchar,
		 lat				float8,
		 lon				float8,
		 html_url		varchar,
		 rss_url			varchar,
		 xml_url			varchar
);
\copy weather_stations FROM '/tmp/weather_stations.csv' DELIMITER ',' CSV HEADER;

SELECT AddGeometryColumn('', 'weather_stations',  'geom', 4326, 'POINT',2);
UPDATE weather_stations 
   SET geom = ST_Transform(
      ST_GeomFromText('POINT(' || lon || ' ' || lat || ')',4326), 4326);

CREATE INDEX idx_weather_stations ON weather_stations USING gist(geom);
vacuum analyze weather_stations;

\q

