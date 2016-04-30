export LATEST=SCHASDB.gz
export dump=$LATEST
export dbname=SCHASDB
dropdb -U postgres $dbname
createdb -U postgres $dbname
#createuser -Upostgres -s -r schas
#psql -h localhost -Upostgres -c "CREATE ROLE schas"

gunzip -c $dump | psql -U postgres -d $dbname

