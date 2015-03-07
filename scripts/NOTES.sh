#
#
#
1. Make sure to install the database with POST GIS extension 
   See the notes in geospaces.org - 
   http://www.geospaces.org/geodata/Wiki.jsp?page=POstgres
	In somple steps on Mac:
   brew install postgres
   Brew install postgis
   => START POSTGRES Server

2. run db.sh - this will create the database

3. run test.sh - to test

4. run users.sql to create all the userusers:
   psql -h localhost -U postgres  -d SCHASDB -f users.sql


