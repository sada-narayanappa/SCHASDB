update hospital SET the_geom = ST_GeomFromText('POINT(' || longitude || ' ' || latitude || ')',4326);
