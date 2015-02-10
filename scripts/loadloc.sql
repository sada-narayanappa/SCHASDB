--************************************************************
--
-- You must RUN this
-- psql -h 10.0.0.3 -U postgres  -d SCHASDB -f loadloc.sql
-- psql -h localhost -U postgres  -d SCHASDB -f loadloc.sql
--

--  t, o['lon'], o['lat'], o['bearing'], o['alt'], o['speed'], o['id'],o['accuracy'] ]

\copy loc(api_key,measured_at,lon,lat,bearing,alt,speed,mobile_id,accuracy) FROM 'data/loc.txt'  DELIMITERS ',' QUOTE E'\f' CSV HEADER ENCODING 'LATIN1';

update loc SET the_geom = ST_GeomFromText('POINT(' || lon || ' ' || lat || ')',4326);
update loc SET location = point(lon, lat )

