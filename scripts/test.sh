#------------------------------------------------------------------------
# RUN as
# [ ] test.sh 
#------------------------------------------------------------------------
DBNAME=SCHASDB
AUTH='-h localhost -U postgres '
PSQL="psql $AUTH -d $DBNAME"

echo "will run commands as [] $PSQL"

$PSQL -c "drop table test;"
$PSQL  <<EOF 
create table test (
		 name	 varchar,
		 value varchar,
		 valid boolean,
		 num1	 int,
		 num2	 float8,
		 num3	 float8
);
EOF

$PSQL  -c "insert into test values ('name1' , 'value', true, 0,0,0);"

$PSQL  -c 'SELECT * from test' 
