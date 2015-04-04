#
# TO converts xml to csv do the following
# xml2csv --input "w.xml" --output w.csv --tag "station"
#
# RUN THE FOllowing command
export DB=test
export PORT=5432
export HOST=localhost
export PSQL="psql -h $HOST -d $DB -U postgres -p $PORT"

$PSQL -f load_weather.sql 

#THEN RUN 

$PSQL -f load_weather1.sql 

#Compute the voronoi diagram - they are computed and stored in "voronoi" directory
#Use Quantum GIS to generate Voronoi digram
# 
# To convert shape file to postgres Data run the following command
#
# Run in "voronoi" directory: shp2pgsql -s 4326 -I weather1.shp  wv1 > wv1.sql
#
# This will create a script to create a table named wv_vor
#
$PSQL -f voronoi/wv1.sql	

UPDATE weather_stations SET voronoi_geom = null;
UPDATE weather_stations SET voronoi_geom = (SELECT geom FROM wv1 where weather_stations.station_id = wv1.station_id);

$PSQL -c "$UPD"
$PSQL -c "DROP TABLE wv1"




