#!/bin/sh
#------------------------------------------------------------------------
# NOTES
# =====
# For SCHASDB, always use the following:
#
# Username: postgres 
# Password: postgres1234
#
# For more info, please see geospaces.org - postgres DB
#
#------------------------------------------------------------------------
DBNAME=SCHASDB
AUTH='-h localhost -U postgres '
PSQL="psql $AUTH"

function backup {
		  pg_dump -C -Fp -f dump.sql $AUTH $DBNAME
		  #psql -U postgres -f dump.sql
}

if $PSQL -lqt | grep $DBNAME; then
   echo "$DBNAME already exists" 
	#dropdb $AUTH -T template_postgis $DBNAME
	exit
fi

#createdb $AUTH -T template_postgis $DBNAME
#$PSQL -lqt | grep $DBNAME;

$PSQL  -d $DBNAME -c "CREATE EXTENSION hstore;"
$PSQL  -d $DBNAME -c "CREATE EXTENSION postgis;"
$PSQL  -d $DBNAME -c "CREATE EXTENSION pgrouting;"
echo "$$DBNAME created"


# NOTES
#
# * run db.sh fist to create the database tables
# *
