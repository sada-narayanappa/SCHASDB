TABLE=pg_stpaul
LON=-71.120328
LAT=42.327462
SQL=select source from $TABLE order by st_distance(geom_way, st_setsrid(st_makepoint($LON, $LAT), 4326)) limit 1;

