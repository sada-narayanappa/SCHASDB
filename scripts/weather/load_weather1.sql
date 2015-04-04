--
-- Run this after the load_weather.sql 
--
--
ALTER TABLE "weather_stations" ADD COLUMN "is_valid" bool;
ALTER TABLE "weather_stations" ADD COLUMN "is_interested" bool;
SELECT AddGeometryColumn('','weather_stations','voronoi_geom','4326','MULTIPOLYGON',2);

\q

-- 
UPDATE 
	weather_stations SET is_interested='t'   
WHERE 
	geom && ST_MakeEnvelope(-93.06564974339717,44.55085951444461,-90.79834627660497,45.191245680230345);


