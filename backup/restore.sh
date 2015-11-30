export LATEST=SCHASDB.gz
export dump=$LATEST
export dbname=SCHASDB
dropdb -h localhost -U postgres $dbname
createdb -h localhost -U postgres $dbname
#createuser -Upostgres -s -r schas
#psql -h localhost -Upostgres -c "CREATE ROLE schas"

gunzip -c $dump | psql -h localhost -U postgres -d $dbname

