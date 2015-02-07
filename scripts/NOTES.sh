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

4. run tables.sql to create all the tables:
   psql -h localhost -U postgres  -d SCHASDB -f tables.sql


